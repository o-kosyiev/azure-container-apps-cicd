# syntax=docker/dockerfile:1.18
ARG BUILDER_IMAGE=python:3.13.13-slim-trixie@sha256:aa938a849bcb82dce8f49480f056ab82bf5c1c3ebc294f0430f37b6820e7f286
ARG RUNTIME_IMAGE=gcr.io/distroless/python3-debian13:nonroot@sha256:f3d5ddc6c64a019fe520e7f005f2880be21e6afc461b10a3c15ef2e4edc71e33

FROM ${BUILDER_IMAGE} AS builder
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1
COPY requirements.lock /tmp/requirements.lock
RUN pip install \
      --require-hashes \
      --requirement /tmp/requirements.lock \
      --target /opt/dependencies

FROM ${RUNTIME_IMAGE} AS runtime
ENV PYTHONPATH=/app/src:/app/dependencies \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000
WORKDIR /app
COPY --from=builder --chown=65532:65532 /opt/dependencies /app/dependencies
COPY --chown=65532:65532 src /app/src
USER 65532:65532
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD ["/usr/bin/python3", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"]
CMD ["-m", "uvicorn", "portfolio_api.main:app", "--host", "0.0.0.0", "--port", "8000", "--no-access-log"]
