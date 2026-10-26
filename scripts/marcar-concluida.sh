#!/usr/bin/env bash
# Uso: ./scripts/marcar-concluida.sh <id>   (ex.: F003)
# Para o HUMANO, no merge de uma funcionalidade feita em modo paralelo (regra 9 do AGENTS.md):
# põe "passes": true no id indicado e soma 1 ao contador de ciclos de docs/estado-atual.md.
# Troca só a linha do "passes" (o resto do feature_list.json fica byte a byte igual).
# Não commita e não faz push: confira com `git diff` e commite você mesmo.
set -euo pipefail
id="${1:-}"
[ -n "$id" ] || { echo "Uso: $0 <id>  (ex.: F003)" >&2; exit 2; }
[ -f feature_list.json ] || { echo "ERRO: rode na raiz do repositório (feature_list.json não encontrado)." >&2; exit 2; }

python3 -I - "$id" <<'PY'
import json, re, sys
id_ = sys.argv[1]
path = "feature_list.json"
raw = open(path, encoding="utf-8", newline="").read()
data = json.loads(raw)
feats = data.get("features", [])
alvo = [f for f in feats if f.get("id") == id_]
def die(msg):
    print("ERRO: " + msg, file=sys.stderr); sys.exit(1)
if not alvo:
    die(f"id '{id_}' não existe em feature_list.json. Ids: {', '.join(str(f.get('id')) for f in feats)}")
f = alvo[0]
if f.get("passes") is True:
    die(f"{id_} já está com passes: true. Nada a fazer.")
pend = [b for b in f.get("blocked_by", []) if not any(x.get("id") == b and x.get("passes") is True for x in feats)]
if pend:
    die(f"{id_} depende de {', '.join(pend)}, que ainda não passou(aram). Conclua antes.")
m = re.search(r'"id"\s*:\s*' + re.escape(json.dumps(id_)), raw)
if not m:
    die("não achei o id no texto do arquivo; edite o passes à mão.")
rest = raw[m.end():]
p = re.search(r'"passes"\s*:\s*false', rest)
nxt = re.search(r'"id"\s*:', rest)
if not p or (nxt and nxt.start() < p.start()):
    die(f"não achei o 'passes' de {id_} logo após o id (formato fora do usual); edite à mão.")
novo = raw[:m.end()] + rest[:p.start()] + re.sub(r'false$', 'true', p.group(0)) + rest[p.end():]
# Confere: só o passes desse id mudou
d2 = json.loads(novo)
for a, b in zip(feats, d2["features"]):
    if a.get("id") == id_:
        a = dict(a, passes=True)
    if a != b:
        die("a troca mexeria em mais do que o passes; abortei sem gravar. Edite à mão.")
if {k: v for k, v in data.items() if k != "features"} != {k: v for k, v in d2.items() if k != "features"} or len(feats) != len(d2["features"]):
    die("a troca mexeria em mais do que o passes; abortei sem gravar. Edite à mão.")
open(path, "w", encoding="utf-8", newline="").write(novo)
print(f"{id_}: passes -> true")
PY

# Contador de ciclos desde a última /limpeza (linha exigida pelo check-docs.sh)
if [ -f docs/estado-atual.md ] && grep -q '^- Ciclos desde a última /limpeza: [0-9]\+' docs/estado-atual.md; then
  n=$(grep -o '^- Ciclos desde a última /limpeza: [0-9]\+' docs/estado-atual.md | grep -o '[0-9]\+$' | head -1)
  sed -i "s/^- Ciclos desde a última \/limpeza: [0-9]\+/- Ciclos desde a última \/limpeza: $((n + 1))/" docs/estado-atual.md
  echo "Contador de ciclos: $n -> $((n + 1))"
else
  echo "AVISO: docs/estado-atual.md sem a linha '- Ciclos desde a última /limpeza: N'; contador não atualizado. Restaure a linha." >&2
fi
echo "Pronto. Revise com 'git diff' e commite (não faço commit)."
