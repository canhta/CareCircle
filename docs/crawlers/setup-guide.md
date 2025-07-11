# CareCircle Local Python Crawler Setup Guide

## Prerequisites

### System Requirements
- **Python**: 3.9 or higher
- **Operating System**: Windows 10+, macOS 10.15+, or Linux (Ubuntu 20.04+)
- **Memory**: Minimum 4GB RAM (8GB recommended)
- **Storage**: 2GB free space for virtual environment and data
- **Network**: Stable internet connection for crawling

### Required Software
1. **Python 3.9+**: Download from [python.org](https://python.org)
2. **Git**: For version control and project management
3. **Text Editor**: VS Code, PyCharm, or similar for development

## Step-by-Step Setup

### 1. Project Setup

```bash
# Clone the CareCircle repository (if not already done)
git clone https://github.com/your-org/carecircle.git
cd carecircle

# Navigate to crawlers directory
cd crawlers
```

### 2. Python Virtual Environment Setup

#### On Windows:
```cmd
# Create virtual environment
python -m venv .venv

# Activate virtual environment
.venv\Scripts\activate

# Verify activation (should show .venv in path)
where python
```

#### On macOS/Linux:
```bash
# Create virtual environment
python3 -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Verify activation (should show .venv in path)
which python
```

### 3. Install Dependencies

```bash
# Ensure virtual environment is activated
# Install core dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Verify installation
pip list
```

### 4. Configuration Setup

#### Create Configuration Files
```bash
# Create config directory if it doesn't exist
mkdir -p config

# Copy example configurations
cp config/sources.example.json config/sources.json
cp config/api_config.example.json config/api_config.json
cp config/crawler_settings.example.json config/crawler_settings.json
```

#### Configure API Access
Edit `config/api_config.json`:
```json
{
  "backend_url": "http://localhost:3000",
  "api_endpoints": {
    "content_upload": "/knowledge-management/content/upload",
    "bulk_upload": "/knowledge-management/content/bulk-upload",
    "sources": "/knowledge-management/sources",
    "status": "/knowledge-management/content/status"
  },
  "authentication": {
    "type": "firebase_jwt",
    "token": "your-firebase-jwt-token"
  },
  "rate_limiting": {
    "requests_per_minute": 60,
    "batch_size": 100
  }
}
```

#### Configure Vietnamese Healthcare Sources
Edit `config/sources.json`:
```json
{
  "sources": [
    {
      "id": "ministry-health",
      "name": "Vietnam Ministry of Health",
      "base_url": "https://moh.gov.vn",
      "type": "government",
      "language": "vi",
      "crawl_frequency": "daily",
      "selectors": {
        "content": ".content-main",
        "title": "h1, .title",
        "date": ".publish-date"
      },
      "rate_limit": 2.0
    },
    {
      "id": "health-news",
      "name": "Vietnamese Health News Portal",
      "base_url": "https://suckhoedoisong.vn",
      "type": "news",
      "language": "vi",
      "crawl_frequency": "hourly",
      "selectors": {
        "content": ".article-content",
        "title": ".article-title",
        "date": ".article-date"
      },
      "rate_limit": 1.5
    }
  ]
}
```

#### Configure Crawler Settings
Edit `config/crawler_settings.json`:
```json
{
  "general": {
    "user_agent": "CareCircle-Crawler/1.0 (+https://carecircle.com/crawler)",
    "timeout": 30,
    "max_retries": 3,
    "retry_delay": 5
  },
  "rate_limiting": {
    "default_delay": 2.0,
    "respect_robots_txt": true,
    "concurrent_requests": 1
  },
  "content_processing": {
    "max_content_length": 1000000,
    "min_content_length": 100,
    "remove_html_tags": true,
    "normalize_whitespace": true
  },
  "vietnamese_nlp": {
    "library": "underthesea",
    "enable_tokenization": true,
    "enable_pos_tagging": false,
    "enable_ner": true
  },
  "logging": {
    "level": "INFO",
    "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    "file_rotation": "1 day",
    "max_file_size": "10 MB"
  }
}
```

### 5. Directory Structure Creation

```bash
# Create output directories
mkdir -p output/{raw,processed,logs,uploads}

# Create source code directories
mkdir -p src/{core,extractors,utils}

# Create scripts directory
mkdir -p scripts

# Verify structure
tree . -I '.venv|__pycache__'
```

### 6. Environment Variables Setup

Create `.env` file in the crawlers directory:
```bash
# CareCircle Backend Configuration
BACKEND_URL=http://localhost:3000
FIREBASE_JWT_TOKEN=your-firebase-jwt-token

# Crawler Configuration
LOG_LEVEL=INFO
MAX_WORKERS=4
BATCH_SIZE=100

# Vietnamese NLP Configuration
UNDERTHESEA_MODEL_PATH=./models/underthesea
PYVI_MODEL_PATH=./models/pyvi

# Output Configuration
OUTPUT_DIR=./output
RAW_DATA_RETENTION_DAYS=30
PROCESSED_DATA_RETENTION_DAYS=90
```

### 7. Test Installation

#### Basic Python Test
```bash
# Test Python installation
python --version

# Test virtual environment
python -c "import sys; print(sys.prefix)"

# Test core dependencies
python -c "import requests, bs4, pandas; print('Core dependencies OK')"
```

#### Test Vietnamese NLP Libraries
```bash
# Test underthesea
python -c "import underthesea; print('Underthesea OK')"

# Test pyvi
python -c "import pyvi; print('PyVi OK')"
```

#### Test Crawler Components
```bash
# Test basic crawler functionality
python -c "
from src.core.base_crawler import BaseCrawler
from src.core.api_client import APIClient
print('Crawler components OK')
"
```

### 8. Initial Crawler Run

#### Validate Sources
```bash
# Test source accessibility
python scripts/validate_sources.py

# Expected output:
# ✓ ministry-health: Accessible (200 OK)
# ✓ health-news: Accessible (200 OK)
```

#### Run Test Crawl
```bash
# Run a small test crawl
python scripts/crawl_source.py --source ministry-health --limit 5

# Check output
ls -la output/raw/
ls -la output/processed/
```

## Troubleshooting

### Common Issues

#### 1. Virtual Environment Issues
```bash
# If activation fails, recreate environment
rm -rf .venv
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
pip install -r requirements.txt
```

#### 2. Dependency Installation Errors
```bash
# Update pip and setuptools
pip install --upgrade pip setuptools wheel

# Install dependencies one by one to identify issues
pip install requests
pip install beautifulsoup4
pip install underthesea
```

#### 3. Vietnamese NLP Library Issues
```bash
# For underthesea installation issues
pip install --no-cache-dir underthesea

# For pyvi installation issues
pip install --no-cache-dir pyvi

# Alternative: Use conda for complex dependencies
conda install -c conda-forge underthesea
```

#### 4. Network/Firewall Issues
```bash
# Test basic connectivity
python -c "import requests; print(requests.get('https://httpbin.org/get').status_code)"

# Test with proxy if needed
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
```

#### 5. Permission Issues (Linux/macOS)
```bash
# Fix permissions for output directories
chmod -R 755 output/
chmod -R 755 scripts/

# Make scripts executable
chmod +x scripts/*.py
```

### Logging and Debugging

#### Enable Debug Logging
Edit `config/crawler_settings.json`:
```json
{
  "logging": {
    "level": "DEBUG",
    "console_output": true,
    "file_output": true
  }
}
```

#### Check Log Files
```bash
# View recent logs
tail -f output/logs/crawler.log

# Search for errors
grep -i error output/logs/crawler.log

# View specific source logs
tail -f output/logs/ministry-health.log
```

## Performance Optimization

### 1. Concurrent Processing
```json
{
  "performance": {
    "max_workers": 4,
    "chunk_size": 50,
    "memory_limit": "1GB"
  }
}
```

### 2. Caching Configuration
```json
{
  "caching": {
    "enable_http_cache": true,
    "cache_duration": 3600,
    "cache_directory": "./cache"
  }
}
```

### 3. Resource Monitoring
```bash
# Monitor memory usage
python scripts/monitor_resources.py

# Monitor crawler performance
python scripts/performance_stats.py
```

## Next Steps

1. **Configure Sources**: Add specific Vietnamese healthcare sources
2. **Test Crawling**: Run initial crawls and verify data quality
3. **Set Up Scheduling**: Configure automated crawler execution
4. **Monitor Performance**: Set up logging and monitoring
5. **Data Upload**: Test API integration with backend

## Related Documentation

- [CareCircle Local Python Crawler Architecture](./README.md)
- [Data Ingestion API Guide](./data-ingestion-api.md)
- [Vietnamese Healthcare Sources](./vietnamese-sources.md)
- [Troubleshooting Guide](./troubleshooting.md)
