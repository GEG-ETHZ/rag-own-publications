"""
Module containing demo test.

This module can be deleted or renamed and used for actual tests.  Run tests with `uv run pytest` in the
project root.
"""


def test_import() -> None:
    """
    Demo test that verifies that rag_own_publications can be imported.
    """
    import rag_own_publications  # noqa: F401  # type: ignore[import]

    assert rag_own_publications.__version__ == "0.1.0"
