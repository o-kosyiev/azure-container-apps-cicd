# Container Supply Chain

```mermaid
flowchart LR
  Lock[Hashed dependency lock] --> Build[Multi-stage build]
  Base[Digest-pinned official base] --> Build
  Build --> Scan[Vulnerability scan]
  Scan --> SBOM[SPDX SBOM]
  SBOM --> Registry[Private registry]
  Registry --> Digest[Digest deployment]
```

| Artifact | Integrity control |
|---|---|
| Python packages | Exact versions and package hashes |
| Builder image | Python patch tag plus OCI manifest digest |
| Runtime image | Distroless Python plus OCI manifest digest |
| GitHub actions | Full commit hashes |
| Application image | Git SHA tag and immutable registry digest |
| SBOM | Generated from the built image and retained with CI evidence |
