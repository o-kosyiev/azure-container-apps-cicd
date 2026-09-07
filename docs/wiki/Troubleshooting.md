# Troubleshooting

| Symptom | Likely cause | First action |
|---|---|---|
| Image pull failure | Missing `AcrPull` or private DNS | Check managed identity and ACR networking |
| Revision never becomes ready | Port, startup or dependency failure | Inspect revision system and console logs |
| OIDC login rejected | Federation subject mismatch | Check repository, branch/environment and audience |
| Canary errors increase | Application regression | Run `rollback.sh` and preserve logs |
| Audit reports a vulnerability | Stale lock or base image | Update dependency/digest and rebuild |
