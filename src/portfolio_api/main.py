"""FastAPI application with health, readiness, metrics, and a sample endpoint."""

import logging
import os
import re
import time
import uuid
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, generate_latest
from pydantic import BaseModel, Field

from portfolio_api import __version__
from portfolio_api.logging import configure_logging

REQUEST_ID = re.compile(r"^[A-Za-z0-9._-]{1,64}$")
REQUESTS = Counter("portfolio_api_requests_total", "HTTP requests", ["method", "path", "status"])
LATENCY = Histogram("portfolio_api_request_seconds", "HTTP request latency", ["method", "path"])
LOGGER = logging.getLogger("portfolio_api")


class NormalizeRequest(BaseModel):
    text: str = Field(min_length=1, max_length=500)


class NormalizeResponse(BaseModel):
    normalized: str
    length: int


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    configure_logging()
    LOGGER.info("service_started", extra={"request_id": "startup"})
    yield
    LOGGER.info("service_stopped", extra={"request_id": "shutdown"})


app = FastAPI(
    title="Portfolio Delivery API",
    version=__version__,
    docs_url=None if os.getenv("DISABLE_API_DOCS", "false").lower() == "true" else "/docs",
    lifespan=lifespan,
)


@app.middleware("http")
async def observe_request(request: Request, call_next):  # type: ignore[no-untyped-def]
    supplied_id = request.headers.get("x-request-id", "")
    request_id = supplied_id if REQUEST_ID.fullmatch(supplied_id) else str(uuid.uuid4())
    started = time.perf_counter()

    try:
        response = await call_next(request)
    except Exception:
        LOGGER.exception("request_failed", extra={"request_id": request_id})
        raise
    finally:
        LATENCY.labels(request.method, request.url.path).observe(time.perf_counter() - started)

    response.headers["x-request-id"] = request_id
    REQUESTS.labels(request.method, request.url.path, str(response.status_code)).inc()
    LOGGER.info(
        "request_completed",
        extra={"request_id": request_id},
    )
    return response


@app.get("/health", include_in_schema=False)
async def health() -> dict[str, str]:
    return {"status": "healthy", "version": __version__}


@app.get("/ready", include_in_schema=False)
async def ready() -> dict[str, str]:
    return {"status": "ready"}


@app.get("/metrics", include_in_schema=False)
async def metrics() -> Response:
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)


@app.post("/api/v1/normalize", response_model=NormalizeResponse)
async def normalize(payload: NormalizeRequest) -> NormalizeResponse:
    normalized = " ".join(payload.text.strip().lower().split())
    return NormalizeResponse(normalized=normalized, length=len(normalized))
