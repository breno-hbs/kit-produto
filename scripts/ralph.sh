#!/usr/bin/env bash
# Loop "Ralph": uma tarefa por iteração, um processo, com limites.
# Roda o Claude Code sem interface (-p) repetidamente até acabarem as funcionalidades
# pendentes, atingir o máximo de iterações ou algo falhar.
#
# AVISO: NÃO foi testado contra o CLI real durante a criação deste kit. Rode primeiro com
# MAX_ITER=1 e acompanhe. Rodando na main, ele cria a branch ralph/<data>; permissões restritas em .claude/settings.json.
# Ações destrutivas, financeiras ou em produção NÃO devem estar permitidas.
# O modo -p não pode pedir permissão: se travar no primeiro Edit/Bash, passe flags do CLI em RALPH_FLAGS.
# Exemplo (não testado): RALPH_FLAGS="--permission-mode acceptEdits --max-budget-usd 5" MAX_ITER=1 ./scripts/ralph.sh
# Sem RALPH_FLAGS nada muda. --max-budget-usd limita o gasto de cada iteração.
set -euo pipefail
cd "$(dirname "$0")/.."

MAX_ITER="${MAX_ITER:-5}"
RALPH_FLAGS="${RALPH_FLAGS:-}"
PROMPT='Siga o procedimento de .claude/commands/proxima-feature.md conforme AGENTS.md: uma funcionalidade, verificada de ponta a ponta, commit e progresso atualizados. Se não houver funcionalidade pendente, responda apenas: SEM_PENDENCIAS'

pendentes() {
  python3 -I - <<'PY'
import json
d = json.load(open("feature_list.json", encoding="utf-8"))
print(sum(1 for f in d["features"] if not f["passes"]))
PY
}

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = main ] || [ "$branch" = master ]; then
  git checkout -q -b "ralph/$(date +%Y%m%d-%H%M)" || exit 1
  echo "Criei a branch $(git rev-parse --abbrev-ref HEAD): o loop nunca commita na $branch. Um PR só, com um commit por funcionalidade."
fi

[ -z "$(git status --porcelain)" ] || { echo "Árvore git suja. Faça commit ou stash antes (cada iteração precisa começar limpa)."; exit 1; }

for i in $(seq 1 "$MAX_ITER"); do
  n=$(pendentes)
  [ "$n" -gt 0 ] || { echo "Sem funcionalidades pendentes."; exit 0; }
  echo "=== iteração $i/$MAX_ITER — $n pendente(s) ==="
  # shellcheck disable=SC2086  # RALPH_FLAGS é uma lista de flags separadas por espaço
  claude -p $RALPH_FLAGS "$PROMPT"
  depois=$(pendentes)
  if [ "$depois" -ge "$n" ]; then
    echo "O agente parou sem concluir nenhuma funcionalidade (provavelmente hitl, grande demais ou travado). Leia o resultado e decida."
    exit 1
  fi
  ./scripts/check-docs.sh || { echo "check-docs falhou; parando para revisão humana."; exit 1; }
  [ -z "$(git status --porcelain)" ] || { echo "Árvore suja após a iteração (o agente não deixou o ambiente limpo); parando."; exit 1; }
done
echo "Limite de $MAX_ITER iterações atingido. Revise o trabalho antes de continuar."
