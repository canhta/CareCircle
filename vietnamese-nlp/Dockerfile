FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download Vietnamese NLP models
RUN python -c "import underthesea; underthesea.word_tokenize('Xin chào')"

# Copy application code
COPY . .

# Create non-root user for security
RUN adduser --disabled-password --gecos '' nlpuser && \
    chown -R nlpuser:nlpuser /app
USER nlpuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["python", "app.py"]
