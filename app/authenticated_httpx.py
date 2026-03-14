import httpx
from google.adk.agents.remote_a2a_agent import DEFAULT_TIMEOUT


def create_authenticated_client(
        remote_service_url: str,
        timeout: float = DEFAULT_TIMEOUT
    ) -> httpx.AsyncClient:
    """Plain client for local development using Gemini API key (no GCP auth needed)."""
    return httpx.AsyncClient(follow_redirects=True, timeout=timeout)
