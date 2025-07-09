FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Vietnamese language support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i vi_VN -c -f UTF-8 -A /usr/share/locale/locale.alias vi_VN.UTF-8

# Set locale environment
ENV LANG vi_VN.UTF-8
ENV LANGUAGE vi_VN:vi
ENV LC_ALL vi_VN.UTF-8

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data
RUN python -m nltk.downloader punkt stopwords wordnet

# Copy the application code
COPY . .

# Create necessary directories
RUN mkdir -p exports logs

# Set environment variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# Default command
CMD ["python", "src/main.py"] 