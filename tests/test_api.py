from fastapi.testclient import TestClient

from portfolio_api.main import app


def test_health_is_versioned() -> None:
    with TestClient(app) as client:
        response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy", "version": "1.0.0"}


def test_request_id_is_returned() -> None:
    with TestClient(app) as client:
        response = client.get("/ready", headers={"x-request-id": "test-request-1"})
    assert response.headers["x-request-id"] == "test-request-1"


def test_invalid_request_id_is_replaced() -> None:
    with TestClient(app) as client:
        response = client.get("/ready", headers={"x-request-id": "not valid"})
    assert response.headers["x-request-id"] != "not valid"


def test_normalize_endpoint_has_bounded_contract() -> None:
    with TestClient(app) as client:
        response = client.post("/api/v1/normalize", json={"text": "  Hello   PLATFORM  "})
    assert response.status_code == 200
    assert response.json() == {"normalized": "hello platform", "length": 14}


def test_normalize_rejects_empty_input() -> None:
    with TestClient(app) as client:
        response = client.post("/api/v1/normalize", json={"text": ""})
    assert response.status_code == 422
