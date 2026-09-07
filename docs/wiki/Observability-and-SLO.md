# Observability and SLO

| Signal | Source | Example objective |
|---|---|---|
| Availability | Ingress success rate | 99.9% monthly |
| Latency | Request histogram | p95 below 300 ms |
| Errors | Status-labelled request counter | Below error-budget burn threshold |
| Saturation | Replica CPU/memory | Headroom before autoscale maximum |
| Deployment health | Revision readiness and canary metrics | No degradation during observation window |

The API emits JSON logs with a bounded request ID and Prometheus-compatible metrics. Example objectives must be calibrated from real traffic before production use.
