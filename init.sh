#!/usr/bin/env bash
# Sobe o ambiente de desenvolvimento e roda um teste básico de ponta a ponta.
# Preencha os três blocos marcados com TODO para o seu projeto.
set -euo pipefail
cd "$(dirname "$0")"

echo "[init] diretório: $(pwd)"

# Worktree novo (ORCA) vem sem .env/node_modules: este script roda em cada um.
[ -f .env ] || echo "[init] aviso: .env ausente (veja .worktreeinclude)"

# TODO 1: instalar dependências (ex.: pip install -r requirements.txt | npm install)
echo "[init] dependências: TODO"

# TODO 2: subir o servidor de desenvolvimento em segundo plano (ex.: uvicorn app.main:app &)
echo "[init] servidor: TODO"

# TODO 3: teste básico de ponta a ponta (ex.: curl -fsS http://localhost:8000/health)
echo "[init] teste básico: TODO"

echo "[init] ok (lembre-se: substitua os TODO, senão este script não verifica nada)"
