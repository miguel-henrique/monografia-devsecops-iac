# monografia-devsecops

Monografia **DevSecOps e Infraestrutura como Código (IaC): Um Modelo de
Integração e Segurança Automatizada** — fontes LaTeX + toolchain de
compilação 100% Docker.

## Estrutura

```
monografia-devsecops/
├── monografia/          conteudo LaTeX (fontes, figuras, .bib)
│   ├── ArquivoPrincipal.tex
│   ├── Dados.tex
│   ├── Referencias.bib
│   ├── Arquivos/            pacotes e imagens
│   ├── capitulos/           1 arquivo .tex por capitulo
│   └── textos/              pre-textuais, apendices etc.
├── build/               logica de build (Docker, latexmk)
│   ├── compile.sh           gera pdf/monografia[-<versao>].pdf
│   ├── watch.sh             recompila automaticamente
│   ├── shell.sh             shell interativo no container
│   ├── latexmkrc            receita do latexmk
│   └── .cache/              auxiliares (gitignored)
├── pdf/                 PDFs finais compilados (versionados)
├── .vscode/             config LaTeX Workshop (opcional)
├── Makefile             atalhos de linha de comando
└── README.md            este arquivo
```

## Pre-requisitos

Apenas **Docker** (nada de TeX Live no host).

```bash
docker --version
docker pull texlive/texlive:latest   # ~4 GB, uma unica vez
```

## Compilando (linha de comando)

```bash
make                          # gera pdf/monografia.pdf
make v=v1                     # gera pdf/monografia-v1.pdf
make v=v1-rc2                 # gera pdf/monografia-v1-rc2.pdf
make v=2026-07-defesa         # gera pdf/monografia-2026-07-defesa.pdf

make watch                    # rebuild automatico -> pdf/monografia.pdf
make list                     # lista pdf/*.pdf
make clean                    # limpa build/.cache/
make purge                    # limpa build/.cache/ + pdf/*.pdf
make shell                    # shell interativo no container (debug)
make help                     # cabecalho do Makefile
```

Ou chame o script diretamente (aceita multiplos argumentos, que sao
concatenados com hifen):

```bash
./build/compile.sh                     # pdf/monografia.pdf
./build/compile.sh v1                  # pdf/monografia-v1.pdf
./build/compile.sh v1 rc2              # pdf/monografia-v1-rc2.pdf
./build/compile.sh 2026-07-03 banca    # pdf/monografia-2026-07-03-banca.pdf
```

## Compilando (Cursor / VS Code)

1. Instale a extensao **LaTeX Workshop** (`james-yu.latex-workshop`) —
   o Cursor sugere automaticamente ao abrir o projeto.
2. Abra qualquer `.tex` em `monografia/`.
3. `Ctrl+Alt+B` — build (chama `./build/compile.sh`, gera
   `pdf/monografia.pdf`).
4. `Ctrl+Alt+V` — abre o PDF em aba lateral. O preview usa o PDF
   intermediario em `build/.cache/ArquivoPrincipal.pdf`, que atualiza
   a cada build.
5. Salvar o arquivo dispara rebuild automatico (desative em
   `.vscode/settings.json` com `"latex-workshop.latex.autoBuild.run":
   "never"` se preferir).

## Onde ficam os arquivos

| Arquivo                                | Onde                                |
|----------------------------------------|-------------------------------------|
| Fontes LaTeX                           | `monografia/`                       |
| PDF intermediario (para preview)       | `build/.cache/ArquivoPrincipal.pdf` |
| PDF final (default)                    | `pdf/monografia.pdf`                |
| PDF final (versionado)                 | `pdf/monografia-<versao>.pdf`       |
| Log do ultimo build                    | `build/.cache/ArquivoPrincipal.log` |

## Troubleshooting

- **`docker: permission denied ... /var/run/docker.sock`**: adicione
  seu usuario ao grupo `docker`
  (`sudo usermod -aG docker $USER`) e reinicie a sessao.
- **PDF nao aparece em `pdf/`**: o `compile.sh` falhou. Veja o log em
  `build/.cache/ArquivoPrincipal.log` ou rode `make shell` e execute
  `latexmk -r /work/build/latexmkrc` manualmente para inspecionar.
- **Preview no Cursor nao atualiza**: apague `build/.cache/` (via
  `make clean`) e rebuilde.
- **Watch mode nao para com Ctrl+C**: mate o container manualmente com
  `docker ps` + `docker stop <id>`. O container abre em modo `-it`,
  entao Ctrl+C normalmente funciona.
