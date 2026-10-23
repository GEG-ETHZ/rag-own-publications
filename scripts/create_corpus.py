# /// script
# requires-python = ">=3.11"
# dependencies = ["google-cloud-aiplatform>=1.38.0"]
# ///
"""Create the Vertex AI RAG Engine corpus the ingestion function imports into. Prints its resource name."""

import argparse

import vertexai
from vertexai.preview import rag


def main() -> None:
    """Create the corpus; the name goes into the Secret Manager secret the function reads."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default="geg-core-dev")
    parser.add_argument("--location", default="europe-west1")
    parser.add_argument("--display-name", default="GEG-Own-Publications")
    args = parser.parse_args()
    vertexai.init(project=args.project, location=args.location)
    corpus = rag.create_corpus(display_name=args.display_name)
    print(corpus.name)


if __name__ == "__main__":
    main()
