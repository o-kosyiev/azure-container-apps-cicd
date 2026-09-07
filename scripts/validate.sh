#!/usr/bin/env bash
set -Eeuo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

python -m ruff check src tests
python -m mypy src
python -m pytest
python -m pip_audit --requirement requirements.lock --disable-pip

if command -v hadolint >/dev/null 2>&1; then
  hadolint Dockerfile
fi

if command -v trivy >/dev/null 2>&1; then
  trivy fs --exit-code 1 --severity HIGH,CRITICAL --scanners vuln,secret .
fi
