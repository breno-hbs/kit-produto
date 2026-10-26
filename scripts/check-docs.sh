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
         docs/exec-plans/tech-debt-tracker.md \
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
sys.exit(1 if bad else 0)
PY
fi

# 5. Scripts executáveis
for s in init.sh scripts/check-docs.sh scripts/ralph.sh; do
  [ -f "$s" ] && { [ -x "$s" ] || err "$s não é executável. Rode: chmod +x $s"; }
done

# 6. Agentes têm frontmatter com name e description
for a in .claude/agents/*.md; do
  [ -f "$a" ] || continue
  head -1 "$a" | grep -q '^---$' || err "$a sem frontmatter. Comece o arquivo com --- name/description ---."
  grep -q '^name:' "$a" || err "$a sem campo 'name:' no frontmatter."
  grep -q '^description:' "$a" || err "$a sem campo 'description:' no frontmatter."
done

if [ "$fail" -eq 0 ]; then echo "check-docs: ok"; else echo "check-docs: FALHOU" >&2; fi
exit "$fail"
