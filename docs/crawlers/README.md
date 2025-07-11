# CareCircle Local Python Crawler Architecture

## Overview

The CareCircle crawler system uses a **local Python execution architecture** where data extraction is performed by standalone Python scripts running in a virtual environment outside the backend server. This approach provides better resource management, easier debugging, and more flexible deployment options.

## Architecture Benefits

### Local Python Execution Advantages
- **No Server Resources**: Crawling doesn't consume backend server CPU/memory
- **Easier Development**: Debug and test crawlers independently with Python tools
- **Flexible Scheduling**: Run crawlers on different machines or schedules
- **Scalable**: Distribute crawling across multiple environments
- **Simpler Deployment**: No Chromium/Playwright on production servers
- **Rich Ecosystem**: Leverage Python's extensive web scraping libraries

### Data Flow
1. **Local Crawling**: Python scripts extract content from Vietnamese healthcare sources
2. **Content Processing**: Clean and structure data locally using Python libraries
3. **API Upload**: Send processed content to backend via REST API
4. **Backend Processing**: Generate embeddings and store in vector database
5. **AI Integration**: Enhanced responses with Vietnamese medical knowledge

## Project Structure

```
./crawlers/
├── README.md                          # This file
├── requirements.txt                   # Python dependencies
├── .venv/                            # Python virtual environment (created locally)
├── config/
│   ├── sources.json                   # Vietnamese healthcare sources configuration
│   ├── crawler_settings.json         # Rate limiting, retry settings
│   └── api_config.json               # Backend API endpoints and auth
├── src/
│   ├── core/
│   │   ├── __init__.py
│   │   ├── base_crawler.py           # Base crawler class with common functionality
│   │   ├── content_processor.py      # Text cleaning and processing
│   │   ├── api_client.py             # Backend API communication
│   │   └── logger.py                 # Crawler logging system
│   ├── extractors/
│   │   ├── __init__.py
│   │   ├── ministry_health.py        # Ministry of Health extractor
│   │   ├── hospital_sites.py         # Hospital website extractors
│   │   ├── pharma_db.py              # Pharmaceutical database extractors
│   │   └── health_news.py            # Health news portal extractors
│   └── utils/
│       ├── __init__.py
│       ├── vietnamese_nlp.py         # Vietnamese text processing
│       ├── file_manager.py           # Local file storage management
│       └── validation.py             # Content validation utilities
├── scripts/
│   ├── crawl_all.py                  # Run all configured crawlers
│   ├── crawl_source.py               # Run specific source crawler
│   ├── upload_data.py                # Upload crawled data to backend
│   ├── validate_sources.py           # Test source accessibility
│   └── cleanup.py                    # Clean old crawled data
└── output/
    ├── raw/                          # Raw crawled content (by date/source)
    ├── processed/                    # Cleaned and processed content
    ├── logs/                         # Crawler execution logs
    └── uploads/                      # Data prepared for API upload
```

## Python Dependencies

### Core Libraries (requirements.txt)
```
# HTTP Requests and Web Scraping
requests>=2.31.0
beautifulsoup4>=4.12.0
lxml>=4.9.0
scrapy>=2.11.0

# Vietnamese Text Processing
underthesea>=6.7.0
pyvi>=0.1.1

# Data Processing
pandas>=2.0.0
numpy>=1.24.0

# File and Data Handling
python-dotenv>=1.0.0
pydantic>=2.0.0

# Logging and Monitoring
loguru>=0.7.0

# Testing
pytest>=7.4.0
pytest-asyncio>=0.21.0
```

## Key Components

### Base Crawler Class (Python)
- Rate limiting and politeness (robots.txt compliance)
- Error handling and retry mechanisms with exponential backoff
- Content deduplication using hash-based detection
- Progress tracking and structured logging
- Session management for authenticated sources

### Content Processor (Python)
- Vietnamese text normalization using underthesea/pyvi
- Medical entity extraction and terminology processing
- Content quality assessment and validation
- Format standardization for API upload
- Data cleaning and sanitization

### API Client (Python)
- Authentication with CareCircle backend
- Batch upload capabilities with chunking
- Upload progress tracking and monitoring
- Comprehensive error handling and retry logic
- Request rate limiting and connection pooling

## Vietnamese Healthcare Sources

### Government Sources
- **Vietnam Ministry of Health (Bộ Y tế)**: Official policies and guidelines
- **IMDA**: Medical device regulations and approvals
- **Government Health Statistics**: Public health data and reports

### Medical Information
- **Major Vietnamese Hospitals**: Treatment protocols and information
- **Pharmaceutical Databases**: Drug information and interactions
- **Medical Universities**: Research and educational content

### News and Updates
- **Health News Portals**: Recent health developments and updates
- **Policy Updates**: Healthcare regulation changes and announcements
- **Medical Research**: Vietnamese medical research publications

## Getting Started

### Prerequisites
- Python 3.9+ installed
- Access to CareCircle backend API
- Valid authentication credentials

### Virtual Environment Setup
```bash
# Navigate to crawlers directory
cd crawlers

# Create Python virtual environment
python -m venv .venv

# Activate virtual environment
# On Windows:
.venv\Scripts\activate
# On macOS/Linux:
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Configuration
1. Copy configuration templates:
   ```bash
   cp config/sources.example.json config/sources.json
   cp config/api_config.example.json config/api_config.json
   ```

2. Configure Vietnamese healthcare sources in `config/sources.json`
3. Set up API credentials in `config/api_config.json`
4. Adjust crawler settings in `config/crawler_settings.json`

### Running Crawlers
```bash
# Activate virtual environment first
source .venv/bin/activate  # or .venv\Scripts\activate on Windows

# Run all crawlers
python scripts/crawl_all.py

# Run specific source
python scripts/crawl_source.py --source ministry-health

# Upload processed data
python scripts/upload_data.py

# Validate sources
python scripts/validate_sources.py
```

## Web Scraping Best Practices (Python)

### 1. Requests + BeautifulSoup Approach
- **Use Case**: Simple static content extraction
- **Benefits**: Lightweight, fast, easy to debug
- **Libraries**: `requests` for HTTP, `beautifulsoup4` for parsing

### 2. Scrapy Framework Approach
- **Use Case**: Complex crawling with multiple pages and data pipelines
- **Benefits**: Built-in rate limiting, robust error handling, extensible
- **Libraries**: `scrapy` with custom spiders and pipelines

### 3. Content Processing Pipeline
- **Vietnamese Text**: Use `underthesea` or `pyvi` for Vietnamese NLP
- **Data Validation**: Use `pydantic` for structured data validation
- **File Handling**: Use `pandas` for data manipulation and export

### 4. Rate Limiting and Politeness
- Respect robots.txt files
- Implement delays between requests (1-2 seconds minimum)
- Use session management for efficient connection reuse
- Monitor response times and adjust accordingly

## Content Processing Pipeline

### 1. Extraction
- Fetch content from configured Vietnamese healthcare sources
- Handle both static and dynamic content appropriately
- Extract text, metadata, and structural information
- Implement robust error handling for network issues

### 2. Processing
- Clean and normalize Vietnamese text using NLP libraries
- Extract medical entities and terminology
- Assess content quality and authority scoring
- Remove duplicates and filter irrelevant content

### 3. Validation
- Verify content structure and format compliance
- Check medical accuracy indicators where possible
- Validate source authority and content freshness
- Ensure compliance with content guidelines

### 4. Upload
- Batch content for efficient API calls
- Include comprehensive metadata and processing information
- Handle upload errors with retry mechanisms
- Track upload status and progress monitoring

## Integration with Backend

The local Python crawlers integrate with the CareCircle backend through dedicated API endpoints:

- **Content Upload**: POST `/knowledge-management/content/upload`
- **Batch Upload**: POST `/knowledge-management/content/bulk-upload`
- **Source Management**: GET/POST `/knowledge-management/sources`
- **Status Tracking**: GET `/knowledge-management/content/status`

For detailed API documentation, see [Data Ingestion API Guide](./data-ingestion-api.md).

## Related Documentation

- [Knowledge Management Context](../bounded-contexts/07-knowledge-management/README.md)
- [Data Ingestion API Guide](./data-ingestion-api.md)
- [Setup Guide](./setup-guide.md)
- [Vietnamese Healthcare Sources](./vietnamese-sources.md)
