# CareCircle Vietnamese Healthcare Crawler System

A comprehensive local Python crawler system for extracting Vietnamese healthcare content and uploading it to the CareCircle backend via API endpoints.

## 🏗️ Architecture Overview

This crawler system uses a **local execution architecture** where data extraction is performed by standalone Python scripts running in a virtual environment outside the backend server. This provides better resource management, easier debugging, and more flexible deployment options.

### Key Benefits

- **No Server Resources**: Crawling doesn't consume backend server CPU/memory
- **Easier Development**: Debug and test crawlers independently with Python tools
- **Flexible Scheduling**: Run crawlers on different machines or schedules
- **Rich Ecosystem**: Leverage Python's extensive web scraping and Vietnamese NLP libraries
- **Simpler Deployment**: No Chromium/Playwright dependencies on production servers

## 📁 Project Structure

```
./crawlers/
├── README.md                          # This file
├── requirements.txt                   # Python dependencies
├── setup.py                          # Setup script
├── .env.example                      # Environment variables template
├── .venv/                            # Python virtual environment (created during setup)
├── config/
│   ├── sources.json                   # Vietnamese healthcare sources configuration
│   ├── crawler_settings.json         # Rate limiting, retry settings
│   └── api_config.json               # Backend API endpoints and auth
├── src/
│   ├── core/
│   │   ├── base_crawler.py           # Base crawler class with common functionality
│   │   ├── content_processor.py      # Text cleaning and processing
│   │   ├── api_client.py             # Backend API communication
│   │   └── logger.py                 # Crawler logging system
│   ├── extractors/
│   │   ├── ministry_health.py        # Ministry of Health extractor
│   │   ├── hospital_sites.py         # Hospital website extractors
│   │   └── health_news.py            # Health news portal extractors
│   └── utils/
│       ├── vietnamese_nlp.py         # Vietnamese text processing
│       ├── file_manager.py           # Local file storage management
│       └── validation.py             # Content validation utilities
├── scripts/
│   ├── crawl_all.py                  # Run all configured crawlers
│   ├── crawl_source.py               # Run specific source crawler
│   ├── upload_data.py                # Upload crawled data to backend
│   └── validate_sources.py           # Test source accessibility
└── output/
    ├── raw/                          # Raw crawled content (by date/source)
    ├── processed/                    # Cleaned and processed content
    ├── logs/                         # Crawler execution logs
    └── uploads/                      # Data prepared for API upload
```

## 🚀 Quick Start

### Prerequisites

- Python 3.9+ installed
- Access to CareCircle backend API
- Valid Firebase JWT authentication token

### 1. Setup

Run the automated setup script:

```bash
cd crawlers
python setup.py
```

This will:
- Create Python virtual environment
- Install all dependencies
- Create necessary directories
- Set up configuration templates

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
