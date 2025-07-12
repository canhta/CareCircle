# Use Python 3.7 for better compatibility with older Vietnamese NLP libraries
FROM python:3.7-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Vietnamese NLP libraries
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    build-essential \
    python3-dev \
    libffi-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install compatible build tools for scikit-learn 0.20.3
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir "setuptools<60.0" wheel

# Install numpy first (required for scikit-learn 0.20.3)
RUN pip install --no-cache-dir numpy==1.21.6

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user for security before downloading models
RUN adduser --disabled-password --gecos '' nlpuser && \
    mkdir -p /app/models /app/data && \
    chown -R nlpuser:nlpuser /app

# Switch to non-root user for model download
USER nlpuser

# Initialize Vietnamese NLP models
RUN python -c "import underthesea; underthesea.word_tokenize('Xin chào')" || \
    echo "Model initialization completed"

# Copy application code
COPY --chown=nlpuser:nlpuser . .

# Expose port
EXPOSE 8080

# Health check with better timeout and startup period
HEALTHCHECK --interval=30s --timeout=15s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start the Vietnamese NLP service
CMD ["python", "app.py"]
