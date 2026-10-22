# rag-own-publications

Puts a GEG paper into the literature RAG bucket under its DOI name and skips it when it is already
there. Also holds the Cloud Function that ingests each new PDF into the Vertex AI RAG corpus.

Why: people uploaded the same paper under different hand-written names, and the RAG answered from
duplicates. A name derived from the DOI is the same no matter who uploads.

## Use

Once:

```bash
gcloud auth login
gcloud auth application-default login
uv tool install git+https://github.com/GEG-ETHZ/rag-own-publications
```

Per paper:

```bash
geg-rag-upload upload paper.pdf                 # --dry-run shows the plan without uploading
geg-rag-upload upload paper.pdf --doi 10.1000/x # when the PDF carries no DOI
geg-rag-upload migrate ~/papers --dry-run       # a whole folder, or gs://some-bucket
```

The tool prints one line per file: source, DOI, target name, action and reason. Exit code 1 means at
least one file needs `--doi` or `--title`.

## How a file is named

| Found | Object name | Example |
|---|---|---|
| DOI in PDF metadata or on the first two pages, confirmed at doi.org | DOI, lower case, `/` and other unsafe characters become `_` | `10.1016_j.cesys.2022.100086.pdf` |
| No DOI, but a title (Crossref, PDF metadata or the largest-font line on page 1) | `python-slugify` of the title, at most 120 characters | `natural-convection-in-porous-media.pdf` |
| Neither | the tool stops and asks for `--doi` or `--title` | |

## When a file is skipped

- The target name already exists in the bucket (`--force` overwrites).
- A byte-identical file exists under any name. Never overridden; a second copy helps nobody.

DOI, title, year, first author, original file name, uploader and time are written to the object's
custom metadata, so the bucket stays flat and still searchable.

## Layout

```text
src/rag_own_publications/   the CLI
  doi.py        find and normalise a DOI
  naming.py     DOI or title to object name
  plan.py       pure decision logic, no I/O
  pdfmeta.py    PyMuPDF: metadata, text, largest-font line
  crossref.py   doi.org check and Crossref record
  bucket.py     Google Cloud Storage
  cli.py        argument parsing and the run loop
function/       the ingestion Cloud Function (Eventarc on object.finalized → rag.import_files)
scripts/        create_corpus.py, deploy-function.sh
tests/          one file per module; the CLI is tested against a fake store
```

## Develop

```bash
just setup    # uv sync + git hooks
just check    # format, lint, mypy strict, tests with coverage ≥ 80 %
```

## Infrastructure

The bucket `geg-core-dev-rag-own-publications` (europe-west1) is defined in
`gitlab.ethz.ch/geg/geg-infra/geg-core-infra`. The function is deployed with
`scripts/deploy-function.sh`; it reads the corpus id from the Secret Manager secret
`rag-own-publications-corpus-id`. How the group uses the RAG is documented in geg-ops,
`computing/ai/literature-rag.md`.
