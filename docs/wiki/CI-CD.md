# CI/CD

```mermaid
sequenceDiagram
  participant Dev as Engineer
  participant CI as CI runner
  participant ACR as Azure Container Registry
  participant ACA as Azure Container Apps
  Dev->>CI: Reviewed commit
  CI->>CI: test, lint, audit
  CI->>CI: build, scan, SBOM
  Dev->>CI: Manual deployment approval
  CI->>ACR: Push Git SHA image
  ACR-->>CI: Immutable digest
  CI->>ACA: Create canary revision by digest
  CI->>ACA: Smoke test and promote
```

| Workflow | Trigger | Azure access |
|---|---|---|
| CI | Pull request, main push | None |
| Deploy | Manual dispatch | Environment-scoped OIDC |

Actions are pinned to immutable revisions. The deploy job builds once and deploys the digest returned by the registry push.
