# Configuration

## Runtime

| Variable | Default | Purpose |
|---|---|---|
| `PORT` | `8000` | Container listen port |
| `DISABLE_API_DOCS` | `false` | Disable interactive API documentation |
| `PYTHONUNBUFFERED` | `1` | Emit logs immediately |

## Deployment

Azure identifiers are stored as protected environment variables. The workflow receives no registry password; Azure OIDC login authorizes `az acr login` for the short-lived job session.
