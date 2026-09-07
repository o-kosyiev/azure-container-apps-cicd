# Architecture

```mermaid
flowchart TB
  Client[HTTPS client] --> Ingress[Azure-managed ingress]
  Ingress --> Stable[Stable revision]
  Ingress --> Canary[Canary revision]
  Stable --> API[Stateless FastAPI process]
  Canary --> API2[Stateless FastAPI process]
  API --> Logs[Structured logs]
  API --> Metrics[Prometheus metrics]
  API2 --> Logs
  API2 --> Metrics
  Identity[Managed identity] --> ACR[Private ACR]
  ACR --> Stable
  ACR --> Canary
```

| Component | Responsibility |
|---|---|
| Container Apps ingress | TLS termination, routing and revision traffic |
| Stable revision | Known-good production workload |
| Canary revision | New immutable image under evaluation |
| Managed identity | Passwordless ACR pull and approved service access |
| Log Analytics | Central application and platform telemetry |
