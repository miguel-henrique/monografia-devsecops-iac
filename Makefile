# =============================================================================
# monografia-devsecops -- comandos de alto nivel (100% Docker, zero instalacao)
# =============================================================================
# Uso:
#   make                 -> pdf/monografia.pdf
#   make v=v1            -> pdf/monografia-v1.pdf
#   make v=v1-rc2        -> pdf/monografia-v1-rc2.pdf
#   make v=2026-07-defesa-> pdf/monografia-2026-07-defesa.pdf
#   make watch           -> rebuild automatico (atualiza pdf/monografia.pdf)
#   make clean           -> remove build/.cache/ (auxiliares)
#   make purge           -> remove build/.cache/ E pdf/*.pdf
#   make shell           -> shell interativo dentro do container (debug)
#   make list            -> lista PDFs em pdf/
#   make help            -> este cabecalho
#
# Requer apenas: Docker.
# =============================================================================

v ?=

.DEFAULT_GOAL := build
.PHONY: build watch clean purge shell list help

build:
	@./build/compile.sh $(v)

watch:
	@./build/watch.sh

clean:
	@rm -rf build/.cache
	@echo ">> build/.cache removido"

purge: clean
	@rm -f pdf/*.pdf
	@echo ">> pdf/*.pdf removido"

shell:
	@./build/shell.sh

list:
	@ls -lh pdf/*.pdf 2>/dev/null || echo "(nenhum PDF gerado ainda)"

help:
	@sed -n '3,17p' Makefile
