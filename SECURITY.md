# Security Policy

Report suspected vulnerabilities through GitHub private vulnerability reporting. Do not publish secrets, identity tokens, cloud identifiers, private image names, or production logs in an issue.

## Release invariants

- The base image and deployed application image use immutable digests.
- Runtime dependencies are locked with hashes.
- CI has no Azure identity.
- Deployment uses OIDC and a protected GitHub environment.
- Images are scanned before push and deployment.
- The container runs as a numeric non-root user.
- Canary failure restores traffic to the previous active revision.

No security scanner can prove the permanent absence of vulnerabilities. Scans establish that no known high or critical issue is present in the evaluated dependency and image databases at release time.
