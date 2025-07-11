# CareCircle Vietnamese Healthcare Crawler
# Multi-stage Docker build for Vietnamese NLP libraries

# Stage 1: Build stage with Rust for compiling Vietnamese NLP libraries
FROM python:3.12-slim AS builder

# Install system dependencies for building
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Create virtual environment and install dependencies
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install build tools
RUN pip install --upgrade pip setuptools wheel

# Install basic dependencies first
RUN pip install --no-cache-dir -r requirements.txt

# Install Vietnamese NLP libraries (pyvi works without Rust compilation issues)
RUN pip install --no-cache-dir pyvi>=0.1.1

# Note: underthesea requires complex Rust compilation and is skipped for now
# Alternative: Use pyvi for Vietnamese word segmentation
# Future: Consider using pre-built underthesea wheels or alternative libraries

# Stage 2: Runtime stage - smaller final image
FROM python:3.12-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /app

# Create necessary directories
RUN mkdir -p output/raw output/processed output/logs output/uploads \
    models/pyvi

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash crawler && \
    chown -R crawler:crawler /app
USER crawler

# Set environment variables
ENV PYTHONPATH=/app/src
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; import pyvi; print('OK')" || exit 1

# Default command
CMD ["python", "-c", "print('CareCircle Vietnamese Healthcare Crawler is ready!')"]
