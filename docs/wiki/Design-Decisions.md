# Design Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Service shape | Stateless bounded API | Easy to scale, test and roll back |
| Build base | Python slim pinned by digest | Reproducible wheel-compatible dependency installation |
| Runtime base | Distroless Python pinned by digest | Minimal attack surface without a package manager or shell |
| Runtime user | Numeric non-root | No reliance on a mutable passwd entry |
| Release identity | GitHub OIDC | Removes stored Azure passwords |
| Image tag | Git commit SHA | Traceability from source to image |
| Deployment identity | Image digest | Prevents tag mutation between scan and run |
| Rollout | Revision canary | Limits blast radius and preserves instant rollback |
