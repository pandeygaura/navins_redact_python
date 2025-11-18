FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (Tesseract, Poppler, libs for Pillow)
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    poppler-utils \
    libtiff-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    python3-tk \
    ghostscript \
    build-essential \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Render sets PORT env automatically
ARG PORT=8000
ENV PORT=${PORT}

CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT}"]
