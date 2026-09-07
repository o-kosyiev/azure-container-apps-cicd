#!/usr/bin/env bash
set -Eeuo pipefail

base_url="${1:?Usage: smoke-test.sh https://service.example}"
base_url="${base_url%/}"

curl --fail --silent --show-error --retry 6 --retry-all-errors \
  --retry-delay 5 "${base_url}/health" >/dev/null
curl --fail --silent --show-error --retry 6 --retry-all-errors \
  --retry-delay 5 "${base_url}/ready" >/dev/null

response="$(curl --fail --silent --show-error \
  --header 'content-type: application/json' \
  --data '{"text":"  Delivery   verified  "}' \
  "${base_url}/api/v1/normalize")"

if [[ "$response" != *'"normalized":"delivery verified"'* ]]; then
  printf 'Unexpected API response.\n' >&2
  exit 1
fi

printf 'Smoke test passed for %s\n' "$base_url"
