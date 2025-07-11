# CareCircle Vietnamese Healthcare Crawler

Docker-based web crawler for Vietnamese healthcare websites with Vietnamese NLP processing.

## Setup

```bash
cd crawlers
./setup.sh
```

## Manual Commands

```bash
# Build and start
docker build -t carecircle-crawler:latest .
docker-compose up -d

# Access container
docker-compose exec carecircle-crawler bash

# Test Vietnamese NLP
docker-compose exec carecircle-crawler python -c "
from pyvi import ViTokenizer
print(ViTokenizer.tokenize('Thuốc paracetamol giảm đau'))
"
```
- Test the installation

> **Note**: Docker setup provides a clean, isolated environment for Vietnamese NLP libraries without complex compilation issues.

This will:
- Check Docker installation
- Build Docker image with Vietnamese NLP libraries
- Start Docker services
- Test the installation

### 2. Configuration

Edit the configuration files:

```bash
# Configure environment variables
cp .env.example .env
# Edit .env with your Firebase JWT token and backend URL

# Configure API endpoints
# Edit config/api_config.json with correct backend endpoints

# Configure Vietnamese healthcare sources
# Edit config/sources.json to customize sources
```

### 3. Docker Usage

#### Basic Commands

```bash
# Start services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f carecircle-crawler

# Stop services
docker-compose down
```

#### Running Crawlers

```bash
# Validate sources
docker-compose exec carecircle-crawler python scripts/validate_sources.py

# Run crawler
docker-compose exec carecircle-crawler python scripts/crawl_source.py ministry-health --limit 5

# Upload data
docker-compose exec carecircle-crawler python scripts/upload_data.py --source ministry-health
```

#### Development

```bash
# Access container shell
docker-compose exec carecircle-crawler bash

# Python shell with Vietnamese NLP
docker-compose exec carecircle-crawler python

# Rebuild after code changes
docker-compose build && docker-compose up -d
```

### 3. Validate Setup

Test source accessibility and configuration:

```bash
# Activate virtual environment
source .venv/bin/activate  # Linux/macOS
# or
.venv\Scripts\activate     # Windows

# Validate sources
python scripts/validate_sources.py
```

### 4. Run Your First Crawler

```bash
# Crawl a specific source with limit
python scripts/crawl_source.py ministry-health --limit 5

# Upload the crawled data
python scripts/upload_data.py --source ministry-health
```

## 🔧 Usage

### Running Crawlers

#### Crawl All Sources
```bash
python scripts/crawl_all.py
```

#### Crawl Specific Source
```bash
python scripts/crawl_source.py <source-id> [options]

# Examples:
python scripts/crawl_source.py ministry-health --limit 10
python scripts/crawl_source.py health-news --no-upload
python scripts/crawl_source.py bach-mai-hospital --dry-run
```

#### Available Sources
- `ministry-health`: Vietnam Ministry of Health
- `health-news`: Sức khỏe & Đời sống news portal
- `vnexpress-health`: VnExpress health section
- `bach-mai-hospital`: Bach Mai Hospital
- `cho-ray-hospital`: Cho Ray Hospital

### Data Upload

#### Upload Processed Data
```bash
# Upload latest data for specific source
python scripts/upload_data.py --source ministry-health

# Upload specific file
python scripts/upload_data.py --file output/processed/ministry-health/data.json

# Upload all available data
python scripts/upload_data.py --all

# Check upload status
python scripts/upload_data.py --check-status batch_20240116_001
```

### Validation and Testing

#### Validate Sources
```bash
# Validate all sources
python scripts/validate_sources.py

# Validate specific sources
python scripts/validate_sources.py --sources ministry-health health-news

# Skip backend connectivity test
python scripts/validate_sources.py --skip-backend
```

## 🇻🇳 Vietnamese Healthcare Sources

### Government Sources
- **Vietnam Ministry of Health (Bộ Y tế)**: Official policies and guidelines
- **IMDA**: Medical device regulations and approvals
- **Government Health Statistics**: Public health data and reports

### Medical Information
- **Major Vietnamese Hospitals**: Bach Mai, Cho Ray, K Hospital treatment protocols
- **Pharmaceutical Databases**: Vietnamese drug information and interactions
- **Medical Universities**: Research and educational content

### News and Updates
- **VnExpress Health**: Health news portal
- **Sức khỏe & Đời sống**: Health and lifestyle news
- **Medical Research**: Vietnamese medical research publications

## 🧠 Vietnamese NLP Processing

The system includes specialized Vietnamese language processing:

### Text Processing
- **Normalization**: Unicode normalization and text cleaning
- **Tokenization**: Vietnamese word segmentation using underthesea
- **Entity Extraction**: Medical entity recognition for Vietnamese terms

### Medical Entity Recognition
- **Diseases**: tiểu đường, huyết áp, ung thư, etc.
- **Symptoms**: đau đầu, sốt, ho, khó thở, etc.
- **Medications**: paracetamol, aspirin, thuốc kháng sinh, etc.
- **Procedures**: xét nghiệm, chụp x-quang, phẫu thuật, etc.

### Content Quality Assessment
- **Medical Relevance**: Scoring based on medical terminology density
- **Authority Scoring**: Source credibility assessment
- **Content Validation**: Structure and quality checks

## 📊 Data Flow

### 1. Local Crawling Phase
```
Python Crawlers → Local JSON Files → Content Processing → Structured Data
```

### 2. Upload Phase
```
Structured Data → API Client → Backend Validation → Database Storage
```

### 3. Processing Phase
```
Database Content → Vector Generation → Milvus Storage → AI Integration
```

## ⚙️ Configuration

### Environment Variables (.env)
```bash
# Backend Configuration
BACKEND_URL=http://localhost:3000
FIREBASE_JWT_TOKEN=your-firebase-jwt-token

# Crawler Settings
LOG_LEVEL=INFO
MAX_WORKERS=4
BATCH_SIZE=100

# Vietnamese NLP
UNDERTHESEA_MODEL_PATH=./models/underthesea
PYVI_MODEL_PATH=./models/pyvi
```

### Source Configuration (config/sources.json)
```json
{
  "sources": [
    {
      "id": "ministry-health",
      "name": "Vietnam Ministry of Health",
      "base_url": "https://moh.gov.vn",
      "type": "government",
      "language": "vi",
      "enabled": true,
      "selectors": {
        "content": ".content-main",
        "title": "h1",
        "date": ".publish-date"
      },
      "rate_limit": 2.0
    }
  ]
}
```

## 🔍 Monitoring and Logs

### Log Files
- **General logs**: `output/logs/carecircle_crawler.log`
- **Error logs**: `output/logs/carecircle_crawler_errors.log`
- **Source-specific logs**: `output/logs/{source-id}.log`

### Storage Statistics
```bash
# Check storage usage
python -c "
from src.utils.file_manager import FileManager
fm = FileManager({'output': {}})
print(fm.get_storage_stats())
"
```

## 🛠️ Development

### Adding New Sources

1. **Configure source** in `config/sources.json`
2. **Create extractor** (if needed) in `src/extractors/`
3. **Test source** with `validate_sources.py`
4. **Run crawler** with `crawl_source.py`

### Custom Extractors

Extend `BaseCrawler` for specialized extraction:

```python
from src.core.base_crawler import BaseCrawler

class CustomExtractor(BaseCrawler):
    def get_urls_to_crawl(self):
        # Implement URL discovery
        pass
    
    def _determine_content_type(self, url, title, content):
        # Implement content type classification
        pass
```

## 🚨 Troubleshooting

### Common Issues

1. **Import Errors**: Ensure virtual environment is activated
2. **Network Errors**: Check source accessibility with `validate_sources.py`
3. **Authentication Errors**: Verify Firebase JWT token in `.env`
4. **Processing Errors**: Check Vietnamese NLP library installation

### Debug Mode
```bash
python scripts/crawl_source.py ministry-health --log-level DEBUG
```

### Clean Up Old Data
```bash
python -c "
from src.utils.file_manager import FileManager
fm = FileManager({'output': {}})
fm.cleanup_old_files(retention_days=7)
"
```

## 📚 Related Documentation

- [Setup Guide](../docs/crawlers/setup-guide.md)
- [Data Ingestion API Guide](../docs/crawlers/data-ingestion-api.md)
- [Knowledge Management Context](../docs/bounded-contexts/07-knowledge-management/README.md)
- [Migration Plan](../docs/crawlers/migration-plan.md)

## 🤝 Contributing

1. Follow Python coding standards (PEP 8)
2. Add comprehensive logging
3. Include error handling
4. Test with Vietnamese content
5. Update documentation

## 📄 License

This project is part of the CareCircle healthcare platform.
