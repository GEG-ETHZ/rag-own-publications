# Migration to the DOI-named bucket, October 2026

How `geg-core-dev-rag-own-publications` was first filled and wired to the agent. Kept so the
decisions can be traced; the day-to-day use is in geg-ops `computing/ai/literature-rag.md`.

## Sources

| Source | Files | Of which unique after DOI naming |
|---|---|---|
| `gs://geg-publications-rag-bucket` (former bucket) | 137 | 137 |
| Group folder of collected PDFs | 227 | 101 more; 84 byte-identical and 42 same-DOI copies skipped |

Every DOI the tool detected was cross-checked against the Crossref title. Left out on purpose: the
Walsh 2020 electropulse preprint, because the published version is already in the set.

## Files named by hand

The tool could not derive a usable name for four PDFs; they were uploaded with `--title`:

| File | Why | Title given |
|---|---|---|
| `2018_birdsell_code-development-...pdf` | LANL report LA-UR-20-20362, no DOI | Code development for modeling induced seismicity with flow and mechanics using a discrete fracture network and matrix formulation with evolving hydraulic diffusivity |
| `2020_schadle_flow-and-transport-...pdf` | ETH dissertation 26731, two-style title | Flow and transport through fractured rock: numerical approaches to account for fracture heterogeneity |
| `2020_grimm-lima_evolution-of-permeability-...pdf` | ETH dissertation 27067, title wraps over four lines | Evolution of permeability of natural fractures due to THMC processes in the context of CO2-based reservoir applications |
| `teqppaper.pdf.pdf` | preprint, two-line title | Implementing an equation of state without derivatives: teqp |

Two PDFs were named after a Crossref match on their title and first author: the Tutolo 2016
GSA Data Repository supplement (named as its parent paper, `10.1130/g37349.1`) and the Buscheck
2016 Geosphere paper (`10.1130/ges01207.1`).

## Order of operations

1. Bucket: merge request !10 in geg-core-infra, `tofu apply` in `environments/dev`.
2. Corpus `GEG-Own-Publications` in europe-west1: `uv run scripts/create_corpus.py`.
3. Secret `rag-own-publications-corpus-id` holding the corpus resource name.
4. Function `rag-own-publications-ingestor`: `scripts/deploy-function.sh`.
5. Upload: `geg-rag-upload migrate <folder>` for the former bucket and the group folder, then the four
   `--title` uploads above.
6. Wait for the corpus to list every file, test in the Playground.
7. Switch the agent: `scripts/switch-agent-corpus.sh 4185840766943232000 <new corpus name>`. To roll
   back, run it with `projects/geg-core-dev/locations/europe-west1/ragCorpora/6917529027641081856`.
