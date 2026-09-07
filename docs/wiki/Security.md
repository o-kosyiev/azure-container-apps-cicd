# Security

```mermaid
flowchart LR
  Source[Public source] --> CI[Unprivileged CI]
  CI --> Artifact[Scanned image and SBOM]
  Deploy[Protected deploy job] -->|OIDC| Entra[Microsoft Entra ID]
  Entra --> Azure[Scoped Azure resources]
  Artifact --> Azure
  Secret[Long-lived cloud password] -. prohibited .-> Deploy
```

| Control | Verification |
|---|---|
| Non-root runtime | Dockerfile numeric `USER` |
| Immutable base | Full base image digest |
| Immutable release | Registry digest passed to Container Apps |
| Dependency integrity | Hash-locked requirement files |
| Vulnerability gate | High/critical scan before deployment |
| Cloud authentication | Federated token, protected environment |
