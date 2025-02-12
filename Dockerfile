FROM python:3.10-slim AS builder

WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    default-libmysqlclient-dev \
    libmariadb-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "" django

# Copy installed dependencies from the builder stage
COPY --from=builder /install /usr/local/lib/python3.10/site-packages

COPY . .

RUN chown -R django:django /app
USER django

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
