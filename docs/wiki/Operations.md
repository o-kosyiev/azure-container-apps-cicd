# Operations

## Release checklist

1. Confirm all CI checks and image scan results.
2. Confirm the target environment and image digest.
3. Start a small canary and watch health, latency and error rate.
4. Promote only after the observation window.
5. Record digest, revision, approver and verification result.

## Routine work

| Frequency | Task |
|---|---|
| Per release | Validate SBOM, scan and rollback target |
| Daily | Review error rate and unhealthy replicas |
| Weekly | Apply dependency and base-image updates |
| Monthly | Exercise rollback and review identity access |
