#!/usr/bin/env bash
# Verificação mecânica da base de conhecimento. Cada mensagem de erro diz como corrigir.
# Uso: ./scripts/check-docs.sh   (retorna 0 se tudo ok, 1 se houver falhas)
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
err() { echo "ERRO: $1" >&2; fail=1; }

# 1. Arquivos obrigatórios
for f in AGENTS.md CLAUDE.md ARCHITECTURE.md feature_list.json init.sh \
         docs/PLANS.md docs/estado-atual.md docs/decisions.md docs/depth.md docs/risks.md docs/operacao.md docs/QUALITY_SCORE.md docs/SECURITY.md docs/FRONTEND.md \
         docs/design-docs/core-beliefs.md docs/product-specs/index.md \
         docs/exec-plans/tech-debt-tracker.md docs/selecao-de-funcionalidade.md docs/comandos.md \
         .claude/agents/planner.md .claude/agents/generator.md \
         .claude/agents/evaluator.md .claude/agents/docs-gardener.md \
         .claude/commands/configurar-projeto.md .claude/commands/proxima-feature.md .claude/commands/avaliar.md .claude/commands/limpeza.md \
         processo/processo.md processo/bloco-1-descobrir.md processo/bloco-2-definir.md \
         processo/bloco-3-entregar.md processo/bloco-4-sustentar.md \
         docs/discovery/idea.md docs/discovery/validacao.md docs/discovery/kill-criteria.md; do
  [ -f "$f" ] || err "arquivo obrigatório ausente: $f. Crie-o (veja AGENTS.md para a função dele) ou, se removeu de propósito, tire-o da lista em scripts/check-docs.sh e as menções em AGENTS.md, .claude/ e docs/comandos.md."
done

# 2. AGENTS.md é índice: no máximo 100 linhas
if [ -f AGENTS.md ]; then
  n=$(wc -l < AGENTS.md)
  [ "$n" -le 100 ] || err "AGENTS.md tem $n linhas (limite 100). Mova o conteúdo longo para docs/ e deixe só um ponteiro."
fi

# 3. Ponteiros (caminhos entre crases que parecem arquivos) existem: AGENTS.md, agentes, comandos e docs/comandos.md
skip_ptr() {
  case "$1" in
    *'<'*|docs/exec-plans/active/*|docs/exec-plans/completed/*|docs/references/*|docs/ia.md|docs/kit.md|docs/product-specs/brainstorm.md|scripts/verificar.sh) return 0 ;;
  esac
  return 1
}
for src in AGENTS.md .claude/agents/*.md .claude/commands/*.md docs/comandos.md; do
  [ -f "$src" ] || continue
  for p in $(grep -oE '`[A-Za-z0-9_./<>-]+\.(md|json|sh|txt)`' "$src" | tr -d '`' | sort -u); do
    skip_ptr "$p" && continue
    # fora do AGENTS.md só conferimos caminhos com pasta e os arquivos da raiz do kit (nomes soltos como check-docs.sh são só citações)
    [ "$src" = AGENTS.md ] || case "$p" in */*|ARCHITECTURE.md|AGENTS.md|CLAUDE.md|README.md|feature_list.json) ;; *) continue ;; esac
    [ -e "$p" ] || err "$src aponta para '$p', que não existe. Crie o arquivo ou remova o ponteiro (se removeu a peça de propósito, tire a menção de $src)."
  done
done

# 4. feature_list.json é JSON válido e cada funcionalidade tem os campos exigidos
if [ -f feature_list.json ]; then
  python3 -I - <<'PY' || fail=1
import json, sys
try:
    data = json.load(open("feature_list.json", encoding="utf-8"))
except Exception as e:
    print(f"ERRO: feature_list.json não é JSON válido ({e}). Corrija a sintaxe.", file=sys.stderr); sys.exit(1)
feats = data.get("features")
if not isinstance(feats, list) or not feats:
    print("ERRO: feature_list.json precisa da chave 'features' com ao menos uma funcionalidade.", file=sys.stderr); sys.exit(1)
ids = set(); bad = False
for i, f in enumerate(feats):
    if not isinstance(f, dict):
        print(f"ERRO: a funcionalidade #{i+1} de feature_list.json deve ser um objeto com id, category, description, steps e passes. Corrija.", file=sys.stderr); sys.exit(1)
    if not isinstance(f.get("id"), str) or not f.get("id"):
        print(f"ERRO: a funcionalidade #{i+1} precisa de 'id' como texto não vazio (ex.: \"F001\").", file=sys.stderr); sys.exit(1)
    if not isinstance(f.get("steps"), list) or not all(isinstance(s, str) and s for s in f.get("steps", [])):
        print(f"ERRO: 'steps' de {f.get('id')} deve ser uma lista de textos, um por passo de verificação.", file=sys.stderr); sys.exit(1)
    for k in ("id", "category", "description", "steps", "passes"):
        if k not in f:
            print(f"ERRO: funcionalidade #{i+1} sem o campo '{k}'. Acrescente-o.", file=sys.stderr); bad = True
    if f.get("id") in ids:
        print(f"ERRO: id repetido '{f.get('id')}' em feature_list.json. Use ids únicos.", file=sys.stderr); bad = True
    ids.add(f.get("id"))
    if not isinstance(f.get("passes"), bool):
        print(f"ERRO: 'passes' de {f.get('id')} deve ser true ou false.", file=sys.stderr); bad = True
    if not f.get("steps"):
        print(f"ERRO: {f.get('id')} sem 'steps'. Descreva como verificar como um usuário faria.", file=sys.stderr); bad = True
    if "type" in f and f["type"] not in ("afk", "hitl"):
        print(f"ERRO: 'type' de {f.get('id')} deve ser 'afk' ou 'hitl'.", file=sys.stderr); bad = True
    if "blocked_by" in f and not isinstance(f["blocked_by"], list):
        print(f"ERRO: 'blocked_by' de {f.get('id')} deve ser uma lista de ids.", file=sys.stderr); bad = True
for f in feats:
    for b in (f.get("blocked_by") or []):
        if b not in ids:
            print(f"ERRO: {f.get('id')} depende de '{b}' em 'blocked_by', que não existe. Corrija o id.", file=sys.stderr); bad = True
        if b == f.get("id"):
            print(f"ERRO: {f.get('id')} bloqueia a si mesma. Remova de 'blocked_by'.", file=sys.stderr); bad = True
by_id = {f.get("id"): f for f in feats}
for f in feats:
    if f.get("passes") is True:
        for b in (f.get("blocked_by") or []):
            if b in by_id and by_id[b].get("passes") is not True:
                print(f"ERRO: {f.get('id')} está com passes true, mas depende de '{b}', que não. Marque '{b}' como concluída ou volte {f.get('id')} para false.", file=sys.stderr); bad = True
state = {}
def visit(i, path):
    state[i] = 1
    for b in (by_id.get(i, {}).get("blocked_by") or []):
        if b not in by_id: continue
        if state.get(b) == 1:
            ciclo = " -> ".join(path[path.index(b):] + [b]) if b in path else b
            print(f"ERRO: ciclo em 'blocked_by': {ciclo}. Nenhuma delas poderia ser escolhida; remova uma das dependências.", file=sys.stderr); return True
        if state.get(b) is None and visit(b, path + [b]): return True
    state[i] = 2
    return False
for f in feats:
    if state.get(f.get("id")) is None and visit(f.get("id"), [f.get("id")]):
        bad = True; break
sys.exit(1 if bad else 0)
PY
fi

# 4b. Contador de ciclos em estado-atual.md (usado por generator, /limpeza e marcar-concluida.sh)
if [ -f docs/estado-atual.md ]; then
  grep -q '^- Ciclos desde a última /limpeza: [0-9]\+' docs/estado-atual.md || err "docs/estado-atual.md sem a linha '- Ciclos desde a última /limpeza: N'. Restaure-a: generator, /limpeza e marcar-concluida.sh dependem dela."
fi

# 4a. .claude/settings.json é JSON válido e mantém a lista de permissões negadas (JSON quebrado pode derrubar as regras em silêncio)
if [ -f .claude/settings.json ]; then
  python3 -I - <<'PY2' || fail=1
import json, sys
try:
    d = json.load(open(".claude/settings.json", encoding="utf-8"))
except Exception as e:
    print(f"ERRO: .claude/settings.json não é JSON válido ({e}). Corrija a sintaxe (vírgula sobrando ou aspas): com ele quebrado, as regras que barram .env e push na main podem ser ignoradas.", file=sys.stderr); sys.exit(1)
deny = (d.get("permissions") or {}).get("deny") if isinstance(d, dict) else None
if not isinstance(deny, list) or not deny:
    print("ERRO: .claude/settings.json sem 'permissions.deny' (lista não vazia). Restaure as regras que barram .env, secrets/, rm -rf e push na main.", file=sys.stderr); sys.exit(1)
PY2
fi

# 4c. Todo comando de .claude/commands aparece em AGENTS.md, docs/comandos.md e no README do kit
for c in .claude/commands/*.md; do
  [ -f "$c" ] || continue
  n=$(basename "$c" .md)
  for f in AGENTS.md docs/comandos.md README.md; do
    [ -f "$f" ] || continue
    [ "$f" = README.md ] && [ -f docs/kit.md ] && continue  # projeto configurado: o README é do projeto
    grep -q "/$n" "$f" || err "O comando /$n (.claude/commands/$n.md) não aparece em $f. Acrescente-o lá, ou remova o comando e seu arquivo."
  done
done

# 5. Scripts executáveis
for s in init.sh scripts/check-docs.sh scripts/ralph.sh scripts/marcar-concluida.sh; do
  [ -f "$s" ] && { [ -x "$s" ] || err "$s não é executável. Rode: chmod +x $s"; }
done

# 5b. SECURITY.md mantém a lista de áreas que sempre exigem humano
if [ -f docs/SECURITY.md ]; then
  grep -q 'Sempre precisa de humano' docs/SECURITY.md || err "docs/SECURITY.md sem a seção 'Sempre precisa de humano'. Restaure-a (mesmo num projeto simples): planner, generator e evaluator dependem dela."
fi

# 5c. Projeto já configurado (AGENTS.md sem o nome-modelo): a lista de SECURITY.md não pode ficar com o exemplo
if [ -f AGENTS.md ] && [ -f docs/SECURITY.md ] && ! grep -q '<NOME_DO_PROJETO>' AGENTS.md; then
  ! grep -q '<área do projeto>' docs/SECURITY.md || err "docs/SECURITY.md ainda tem o exemplo '<área do projeto>' na lista 'Sempre precisa de humano'. Preencha com as áreas do projeto ou escreva 'nenhuma: <motivo>'."
fi

# 5d. Aviso (não erro): projeto configurado com init.sh ainda sem o teste básico preenchido
if [ -f AGENTS.md ] && [ -f init.sh ] && ! grep -q '<NOME_DO_PROJETO>' AGENTS.md; then
  ! grep -qE '# TODO [0-9]|: TODO"' init.sh || echo "AVISO: init.sh ainda tem TODO: o início de sessão não verifica nada. Preencha (instalar, subir, teste básico) ou diga ao humano por que não dá." >&2
fi

# 5e. Projeto configurado (nome-modelo trocado): o resto do AGENTS.md não pode ficar com o modelo
if [ -f AGENTS.md ] && ! grep -q '<NOME_DO_PROJETO>' AGENTS.md; then
  for ph in '<COMANDO_DE_TESTE>' '<COMANDO_DE_LINT>' '<ESCOLHA>' '<O QUE O PRODUTO FAZ E PARA QUEM>'; do
    ! grep -qF "$ph" AGENTS.md || err "AGENTS.md ainda tem o modelo '$ph'. Preencha (se não houver teste ou lint ainda, escreva 'nenhum: <motivo>')."
  done
  # Aviso (não erro): docs de partida ainda com o modelo
  [ ! -f docs/estado-atual.md ] || ! grep -qF '<objetivo do projeto>' docs/estado-atual.md || echo "AVISO: docs/estado-atual.md ainda tem '<objetivo do projeto>'." >&2
  [ ! -f docs/estado-atual.md ] || ! grep -qE 'Bloco e fase: <ex|Ambiente: <sobe' docs/estado-atual.md || echo "AVISO: docs/estado-atual.md ainda tem 'Bloco e fase' ou 'Ambiente' com o modelo: a regra 10 depende desses campos." >&2
  [ ! -f docs/product-specs/index.md ] || ! grep -qF '<qual>' docs/product-specs/index.md || echo "AVISO: docs/product-specs/index.md ainda tem o modelo ('Problema: <qual>')." >&2
fi

# 6. Agentes têm frontmatter com name e description
for a in .claude/agents/*.md; do
  [ -f "$a" ] || continue
  head -1 "$a" | grep -q '^---$' || err "$a sem frontmatter. Comece o arquivo com --- name/description ---."
  grep -q '^name:' "$a" || err "$a sem campo 'name:' no frontmatter."
  grep -q '^description:' "$a" || err "$a sem campo 'description:' no frontmatter."
done

if [ "$fail" -eq 0 ]; then echo "check-docs: ok"; else echo "check-docs: FALHOU" >&2; fi
exit "$fail"
