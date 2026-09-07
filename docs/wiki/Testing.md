# Testing

| Test layer | Tool | Coverage |
|---|---|---|
| Unit/API | pytest and TestClient | Health, validation, normalization and request IDs |
| Type | mypy | Strict application interfaces |
| Style/security | Ruff | Correctness and common security rules |
| Dependency | pip-audit | Known Python advisories |
| Dockerfile | Hadolint | Image construction practices |
| Image/filesystem | Trivy | Vulnerabilities, secrets and misconfiguration |
| Release | Bash smoke test | Health, readiness and bounded API behavior |
