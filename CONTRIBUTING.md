# Contributing

1. Create a focused branch from `main`.
2. Add or update tests for behavior changes.
3. Run `./scripts/validate.sh` and a local container smoke test.
4. Document deployment or rollback impact.
5. Open a pull request and wait for required checks.

Never commit `.env` files, cloud identifiers from a real environment, container registry credentials, exported logs, signing keys, or image archives.
