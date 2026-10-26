#!/usr/bin/env bash
# Loop "Ralph": uma tarefa por iteração, um processo, com limites.
# Roda o Claude Code sem interface (-p) repetidamente até acabarem as funcionalidades
# pendentes, atingir o máximo de iterações ou algo falhar.
#
# AVISO: NÃO foi testado contra o CLI real durante a criação deste kit. Rode primeiro com
# MAX_ITER=1 e acompanhe. Use em branch própria, com permissões restritas em .claude/settings.json.
# Ações destrutivas, financeiras ou em produção NÃO devem estar permitidas.
set -euo pipefail
cd "$(dirname "$0")/.."

MAX_ITER="${MAX_ITER:-5}"
PROMPT='Execute /proxima-feature conforme AGENTS.md: uma funcionalidade, verificada de ponta a ponta, commit e progresso atualizados. Se não houver funcionalidade pendente, responda apenas: SEM_PENDENCIAS'

pendentes() {
  python3 -I - <<'PY'
import json
d = json.load(open("feature_list.json", encoding="utf-8"))
print(sum(1 for f in d["features"] if not f["passes"]))
PY
}

[ -z "$(git status --porcelain)" ] || { echo "Árvore git suja. Faça commit ou stash antes (cada iteração precisa começar limpa)."; exit 1; }

for i in $(seq 1 "$MAX_ITER"); do
  n=$(pendentes)
  [ "$n" -gt 0 ] || { echo "Sem funcionalidades pendentes."; exit 0; }
  echo "=== iteração $i/$MAX_ITER — $n pendente(s) ==="
  claude -p "$PROMPT"
  ./scripts/check-docs.sh || { echo "check-docs falhou; parando para revisão humana."; exit 1; }
  [ -z "$(git status --porcelain)" ] || { echo "Árvore suja após a iteração (o agente não deixou o ambiente limpo); parando."; exit 1; }
done
echo "Limite de $MAX_ITER iterações atingido. Revise o trabalho antes de continuar."
