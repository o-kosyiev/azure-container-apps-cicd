# Getting Started

```bash
python3.13 -m venv .venv
source .venv/bin/activate
python -m pip install --require-hashes -r requirements-dev.lock
./scripts/validate.sh
PYTHONPATH=src python -m uvicorn portfolio_api.main:app --port 8000
```

In another terminal, run `./scripts/smoke-test.sh http://127.0.0.1:8000`.

Cloud deployment additionally requires a pre-provisioned ACR and Container App, environment-scoped repository variables, and a federated GitHub identity.
