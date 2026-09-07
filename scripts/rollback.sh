#!/usr/bin/env bash
set -Eeuo pipefail

: "${AZURE_RESOURCE_GROUP:?AZURE_RESOURCE_GROUP is required}"
: "${AZURE_CONTAINER_APP:?AZURE_CONTAINER_APP is required}"

target_revision="${1:-}"
if [[ -z "$target_revision" ]]; then
  target_revision="$(az containerapp revision list \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --name "$AZURE_CONTAINER_APP" \
    --query 'sort_by([?properties.active], &properties.createdTime)[-2].name' \
    --output tsv)"
fi

if [[ -z "$target_revision" ]]; then
  printf 'No previous active revision was found.\n' >&2
  exit 1
fi

az containerapp ingress traffic set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_CONTAINER_APP" \
  --revision-weight "$target_revision=100" \
  --output none

printf 'Traffic restored to %s.\n' "$target_revision"
