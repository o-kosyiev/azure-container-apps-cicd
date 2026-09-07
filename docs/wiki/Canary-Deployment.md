# Canary Deployment

`deploy-canary.sh` creates a new revision from an immutable image digest and assigns a small traffic percentage.

| Phase | Traffic | Gate |
|---|---|---|
| Baseline | Stable 100% | Current SLO is healthy |
| Canary | Stable 90–95%, canary 5–10% | Health, readiness, error and latency checks |
| Promotion | Canary 100% | Observation window completed |
| Failure | Previous stable 100% | Automatic or operator rollback |

Do not deactivate the stable revision until the canary has passed and the rollback window has elapsed.
