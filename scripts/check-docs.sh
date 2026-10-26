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
         .claude/commands/configurar-projeto.md \
         processo/processo.md processo/bloco-1-descobrir.md processo/bloco-2-definir.md \
         processo/bloco-3-entregar.md processo/bloco-4-sustentar.md \
         docs/discovery/idea.md docs/discovery/validacao.md docs/discovery/kill-criteria.md; do
  [ -f "$f" ] || err "arquivo obrigatório ausente: $f. Crie-o (veja AGENTS.md para a função dele)."
done

# 2. AGENTS.md é índice: no máximo 100 linhas
if [ -f AGENTS.md ]; then
  n=$(wc -l < AGENTS.md)
  [ "$n" -le 100 ] || err "AGENTS.md tem $n linhas (limite 100). Mova o conteúdo longo para docs/ e deixe só um ponteiro."
fi

# 3. Ponteiros de AGENTS.md (caminhos entre crases que parecem arquivos) existem
if [ -f AGENTS.md ]; then
  ptrs=$(grep -oE '`[A-Za-z0-9_./-]+\.(md|json|sh|txt)`' AGENTS.md | tr -d '`' | sort -u)
  for p in $ptrs; do
    case "$p" in
      docs/exec-plans/active/*|docs/references/*) continue ;;
    esac
    [ -e "$p" ] || err "AGENTS.md aponta para '$p', que não existe. Crie o arquivo ou remova o ponteiro."
  done
fi

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

# 6. Agentes têm frontmatter com name e description
for a in .claude/agents/*.md; do
  [ -f "$a" ] || continue
  head -1 "$a" | grep -q '^---$' || err "$a sem frontmatter. Comece o arquivo com --- name/description ---."
  grep -q '^name:' "$a" || err "$a sem campo 'name:' no frontmatter."
  grep -q '^description:' "$a" || err "$a sem campo 'description:' no frontmatter."
done

if [ "$fail" -eq 0 ]; then echo "check-docs: ok"; else echo "check-docs: FALHOU" >&2; fi
exit "$fail"
