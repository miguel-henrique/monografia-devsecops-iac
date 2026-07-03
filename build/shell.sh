#!/usr/bin/env bash
# =============================================================================
# shell.sh -- abre um shell interativo dentro do container TeX Live.
# Util para debugar (rodar pdflatex/bibtex manualmente, inspecionar logs etc.).
#
# Uso: build/shell.sh
# Dentro do container voce esta em /work/monografia com os fontes montados.
# =============================================================================
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="texlive/texlive:latest"

docker run --rm -it \
  -v "$ROOT:/work" \
  -w /work/monografia \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" bash
