#!/usr/bin/env bash
# Deploy the ingestion Cloud Function that imports every new PDF of the bucket into the RAG corpus.
#
# Prerequisites, once:
#   1. A RAG corpus:           uv run scripts/create_corpus.py   (prints the corpus resource name)
#   2. The corpus id secret:   printf '%s' "<corpus resource name>" | \
#                                gcloud secrets create "$SECRET_ID" --data-file=- --project "$PROJECT"
#   3. The bucket, created through geg-core-infra (OpenTofu), not by hand.
set -euo pipefail

PROJECT="${PROJECT:-geg-core-dev}"
REGION="${REGION:-europe-west1}"
BUCKET="${BUCKET:-geg-core-dev-rag-own-publications}"
FUNCTION_NAME="${FUNCTION_NAME:-rag-own-publications-ingestor}"
SECRET_ID="${SECRET_ID:-rag-own-publications-corpus-id}"
SERVICE_ACCOUNT="${SERVICE_ACCOUNT:-rag-ingestor-sa-corpus-agent@${PROJECT}.iam.gserviceaccount.com}"
GEMINI_MODEL_NAME="${GEMINI_MODEL_NAME:-gemini-2.5-flash}"

echo "Deploying ${FUNCTION_NAME} in ${PROJECT}/${REGION}, triggered by gs://${BUCKET}"
gcloud functions deploy "${FUNCTION_NAME}" \
  --project "${PROJECT}" \
  --region "${REGION}" \
  --gen2 \
  --runtime python312 \
  --source "$(dirname "$0")/../function" \
  --entry-point process_file \
  --trigger-location "${REGION}" \
  --trigger-event-filters "type=google.cloud.storage.object.v1.finalized" \
  --trigger-event-filters "bucket=${BUCKET}" \
  --service-account "${SERVICE_ACCOUNT}" \
  --set-env-vars "GCP_SECRET_ID=${SECRET_ID},GEMINI_MODEL_NAME=${GEMINI_MODEL_NAME},GOOGLE_CLOUD_LOCATION=${REGION},GOOGLE_CLOUD_PROJECT=${PROJECT}" \
  --timeout 540s \
  --memory 512Mi \
  --max-instances 1 \
  --concurrency 1 \
  --retry
# One instance, one request: RAG Engine allows one import per corpus at a time.
# --retry: Eventarc redelivers an event whose import failed, for up to 24 h.
