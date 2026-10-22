"""Upload GEG publications to the RAG bucket under DOI-based names, skipping duplicates."""

from importlib.metadata import version

import rag_own_publications

__version__ = version("rag_own_publications")
