#!/usr/bin/env bash
# =============================================================================
# watch.sh -- recompila automaticamente a cada save. Saida: pdf/monografia.pdf
#
# Uso: build/watch.sh   (Ctrl+C para sair)
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="texlive/texlive:latest"

mkdir -p "$ROOT/build/.cache" "$ROOT/pdf"

echo ">> Watch mode. Salve algum .tex para recompilar. Ctrl+C para sair."
echo ">> Saida atualizada em: pdf/monografia.pdf"

# latexmk -pvc: watches sources and rebuilds. -view=none: sem viewer proprio.
# $success_cmd: copia o PDF final para pdf/monografia.pdf depois de cada
# compilacao bem-sucedida.
docker run --rm -it \
  -v "$ROOT:/work" \
  -w /work/monografia \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" \
  latexmk -r /work/build/latexmkrc -pvc -view=none \
          -e '$success_cmd = q(cp -f /work/build/.cache/ArquivoPrincipal.pdf /work/pdf/monografia.pdf)'
