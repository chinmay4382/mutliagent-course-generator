FROM python:3.12-slim

WORKDIR /app

COPY authenticated_httpx.py .
COPY a2a_utils.py .

COPY main.py .
COPY frontend/ ./frontend/

RUN pip install --no-cache-dir \
    fastapi==0.123.* \
    uvicorn==0.40.0 \
    httpx \
    httpx-sse \
    google-adk==1.22.* \
    a2a-sdk==0.3.* \
    opentelemetry-exporter-gcp-trace \
    google-auth

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
