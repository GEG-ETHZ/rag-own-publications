# Changelog

All notable changes to `RAG Own Publications` are documented here.
`RAG Own Publications` does not yet follow [Semantic Versioning](https://semver.org/) — everything is
pre-release. Once the first public release (`1.0.0`) is cut, the project will
adopt SemVer strictly.

## [In Development]

### Added

- `geg-rag-upload upload` and `migrate`: name a PDF after its DOI (or normalised title), skip files
  already in the bucket by name or by content hash, write bibliographic metadata on the object.
- `function/`: the ingestion Cloud Function source, previously deployed only from a zip.
- `scripts/create_corpus.py` and `scripts/deploy-function.sh`.
- `docs/missing-papers/`: the 81 GEG papers without a PDF, how to find and add one, and
  `scripts/missing_list.py` to rebuild the checklist from the CSV.
- README: how to contribute a missing paper or a code change.

### Changed

- CONTRIBUTING.md follows the group's branching rules: `main` plus `<type>/<description>` topic
  branches, squash-merged; no `develop` until there is a separate place to test a change.

### Fixed

### Removed

<!-- Version comparison links — verify and update when cutting a release.
     Label is [Unreleased] (not [In Development]) so changelog tooling recognises it. -->
[Unreleased]: https://github.com/GEG-ETHZ/rag-own-publications/commits/main
