#!/usr/bin/env bash
set -Eeuo pipefail

image_reference="${1:?Usage: deploy-canary.sh registry/name@sha256:digest}"
canary_percent="${CANARY_PERCENT:-10}"

: "${AZURE_RESOURCE_GROUP:?AZURE_RESOURCE_GROUP is required}"
: "${AZURE_CONTAINER_APP:?AZURE_CONTAINER_APP is required}"

if [[ ! "$image_reference" =~ @sha256:[0-9a-f]{64}$ ]]; then
  printf 'The deployment image must be pinned to a full sha256 digest.\n' >&2
  exit 2
fi

revision_suffix="$(printf '%s' "$image_reference" | shasum -a 256 | cut -c1-8)"

az containerapp update \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_CONTAINER_APP" \
  --image "$image_reference" \
  --revision-suffix "$revision_suffix" \
  --output none

new_revision="$(az containerapp revision list \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_CONTAINER_APP" \
  --query "sort_by([?contains(name, '${revision_suffix}')], &createdTime)[-1].name" \
  --output tsv)"

stable_revision="$(az containerapp revision list \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_CONTAINER_APP" \
  --query "sort_by([?properties.active && name!='${new_revision}'], &properties.createdTime)[-1].name" \
  --output tsv)"

if [[ -z "$new_revision" || -z "$stable_revision" ]]; then
  printf 'Unable to resolve stable and canary revisions.\n' >&2
  exit 1
fi

az containerapp ingress traffic set \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_CONTAINER_APP" \
  --revision-weight "$stable_revision=$((100 - canary_percent))" "$new_revision=$canary_percent" \
  --output none

printf 'Canary revision %s now receives %s%% of traffic.\n' "$new_revision" "$canary_percent"
