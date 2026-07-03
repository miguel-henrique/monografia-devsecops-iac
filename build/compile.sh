#!/usr/bin/env bash
# =============================================================================
# compile.sh -- gera pdf/monografia[-<versao>].pdf via Docker (TeX Live)
#
# Uso:
#   build/compile.sh                  -> pdf/monografia.pdf
#   build/compile.sh v1               -> pdf/monografia-v1.pdf
#   build/compile.sh v1 rc2           -> pdf/monografia-v1-rc2.pdf
#   build/compile.sh 2026-07-03       -> pdf/monografia-2026-07-03.pdf
#
# Requisitos: apenas Docker instalado. Nao instala nada no host.
# =============================================================================
set -euo pipefail

# Descobre a raiz do projeto (o diretorio pai de build/).
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="texlive/texlive:latest"
CACHE_DIR="$ROOT/build/.cache"
OUT_DIR="$ROOT/pdf"

# Nome final do PDF. Junta argumentos com "-" para permitir versoes compostas.
if [ "$#" -eq 0 ] || [ -z "${1:-}" ]; then
  NAME="monografia"
else
  # Sanitiza: substitui espacos/barras/dois-pontos por hifen
  suffix="$(printf '%s-' "$@" | sed 's/-$//; s#[/: ]#-#g')"
  NAME="monografia-${suffix}"
fi

mkdir -p "$CACHE_DIR" "$OUT_DIR"

echo ">> Compilando ${NAME}.pdf (Docker: ${IMAGE})"

# -u: mantem os arquivos gerados com uid/gid do host (nao ficam como root).
docker run --rm \
  -v "$ROOT:/work" \
  -w /work/monografia \
  -u "$(id -u):$(id -g)" \
  "$IMAGE" \
  latexmk -r /work/build/latexmkrc

# Verifica se o PDF bruto foi gerado.
RAW_PDF="$CACHE_DIR/ArquivoPrincipal.pdf"
if [ ! -f "$RAW_PDF" ]; then
  echo "!! Falha: PDF nao gerado. Log em build/.cache/ArquivoPrincipal.log" >&2
  exit 1
fi

# Copia com o nome final. Usa cp para preservar o cache (permite reuso pelo
# LaTeX Workshop e por -pvc no watch mode).
cp -f "$RAW_PDF" "$OUT_DIR/${NAME}.pdf"

size="$(du -h "$OUT_DIR/${NAME}.pdf" | cut -f1)"
echo ">> Pronto: pdf/${NAME}.pdf (${size})"
