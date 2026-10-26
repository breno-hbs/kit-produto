#!/usr/bin/env bash
# Uso: ./scripts/marcar-concluida.sh <id>   (ex.: F003)
# Para o HUMANO, no merge de uma funcionalidade feita em modo paralelo (regra 9 do AGENTS.md):
# põe "passes": true no id indicado e soma 1 ao contador de ciclos de docs/estado-atual.md.
# Não commita e não faz push: confira com `git diff` e commite você mesmo.
set -euo pipefail
id="${1:-}"
[ -n "$id" ] || { echo "Uso: $0 <id>  (ex.: F003)" >&2; exit 2; }
[ -f feature_list.json ] || { echo "ERRO: rode na raiz do repositório (feature_list.json não encontrado)." >&2; exit 2; }

python3 - "$id" <<'PY'
import json, sys
id_ = sys.argv[1]
with open("feature_list.json", encoding="utf-8") as fh:
    data = json.load(fh)
feats = data.get("features", [])
alvo = [f for f in feats if f.get("id") == id_]
if not alvo:
    print(f"ERRO: id '{id_}' não existe em feature_list.json. Ids: {', '.join(str(f.get('id')) for f in feats)}", file=sys.stderr)
    sys.exit(1)
f = alvo[0]
if f.get("passes") is True:
    print(f"ERRO: {id_} já está com passes: true. Nada a fazer.", file=sys.stderr)
    sys.exit(1)
pend = [b for b in f.get("blocked_by", []) if not any(x.get("id") == b and x.get("passes") is True for x in feats)]
if pend:
    print(f"ERRO: {id_} depende de {', '.join(pend)}, que ainda não passou(aram). Conclua antes.", file=sys.stderr)
    sys.exit(1)
f["passes"] = True
with open("feature_list.json", "w", encoding="utf-8") as fh:
    json.dump(data, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
print(f"{id_}: passes -> true")
PY

# Contador de ciclos desde a última /limpeza (linha opcional em docs/estado-atual.md)
if [ -f docs/estado-atual.md ] && grep -q '^- Ciclos desde a última /limpeza: [0-9]\+' docs/estado-atual.md; then
  n=$(grep -o '^- Ciclos desde a última /limpeza: [0-9]\+' docs/estado-atual.md | grep -o '[0-9]\+$' | head -1)
  sed -i "s/^- Ciclos desde a última \/limpeza: [0-9]\+/- Ciclos desde a última \/limpeza: $((n + 1))/" docs/estado-atual.md
  echo "Contador de ciclos: $n -> $((n + 1))"
fi
echo "Pronto. Revise com 'git diff' e commite (não faço commit)."
