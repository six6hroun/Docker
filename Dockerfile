FROM python:3.10-slim AS builder

WORKDIR /app

COPY pyproject.toml .

RUN pip install --upgrade pip
RUN pip install ".[test]"

FROM python:3.10-slim

WORKDIR /app

ENV PYTHONPATH=/app

COPY --from=builder /usr/local/lib/python3.10 /usr/local/lib/python3.10
COPY --from=builder /usr/local/bin /usr/local/bin

COPY src ./src
COPY tests ./tests

EXPOSE 8102

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8102"]
