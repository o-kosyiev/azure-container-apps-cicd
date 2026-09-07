# Rollback

Run:

```bash
export AZURE_RESOURCE_GROUP="replace-with-environment-value"
export AZURE_CONTAINER_APP="replace-with-environment-value"
./scripts/rollback.sh optional-known-good-revision
```

Rollback changes traffic only; it does not rebuild or mutate an image. After stabilization, record the failed digest, preserve telemetry, create a corrective issue, and keep the release frozen until the root cause is understood.
