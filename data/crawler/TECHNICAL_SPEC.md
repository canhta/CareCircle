# CareCircle Vietnamese Healthcare Data Crawler - Technical Specification

## Technology Stack

### Primary Technologies

- **Language**: Python 3.10+
- **Web Scraping Framework**: Scrapy 2.8.0
- **HTML Parsing**: Beautiful Soup 4.12.0
- **HTTP Client**: Requests 2.31.0
- **Data Processing**: Pandas 2.0.0+
- **Database**: MongoDB 6.0+ (for flexible schema storage)
- **Text Processing**: NLTK 3.8.1 with Vietnamese language support
- **Vector Embeddings**: Sentence-Transformers with multilingual models

### Supporting Libraries

- **Proxy Management**: Rotating-Proxies 0.6.0
- **Rate Limiting**: Scrapy-Deltafetch 2.0.1
- **Scheduling**: APScheduler 3.10.0
- **Logging**: Loguru 0.7.0
- **Configuration**: Python-Decouple 3.8.0
- **Testing**: Pytest 7.3.0

## System Architecture

### Component Diagram

```
┌─────────────────────────────────────┐
│           Crawler Manager           │
│                                     │
│  ┌─────────┐    ┌───────────────┐   │
│  │ Config  │    │ URL Frontier   │   │
│  │ Manager │    │ & Scheduler   │   │
│  └─────────┘    └───────────────┘   │
│        │               │            │
└────────┼───────────────┼────────────┘
         │               │
         ▼               ▼
┌─────────────────┐    ┌─────────────────┐
│  Site-Specific  │    │   Crawl Engine  │
│   Extractors    │    │                 │
│                 │    │  ┌───────────┐  │
│  ┌───────────┐  │    │  │ Fetchers  │  │
│  │ MOH       │◄─┼────┼─►│           │  │
│  └───────────┘  │    │  └───────────┘  │
│  ┌───────────┐  │    │  ┌───────────┐  │
│  │ Hospitals │◄─┼────┼─►│ Parsers   │  │
│  └───────────┘  │    │  └───────────┘  │
│  ┌───────────┐  │    │  ┌───────────┐  │
│  │ Portals   │◄─┼────┼─►│ Pipelines │  │
│  └───────────┘  │    │  └───────────┘  │
└─────────────────┘    └─────────────────┘
         │                     │
         └───────┬─────────────┘
                 ▼
┌─────────────────────────────────────┐
│        Data Processing Layer        │
│                                     │
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Cleaning &  │  │ Vietnamese  │   │
│  │ Validation  │  │ NLP Module  │   │
│  └─────────────┘  └─────────────┘   │
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Structured  │  │ Metadata    │   │
│  │ Extraction  │  │ Generation  │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│           Storage Layer             │
│                                     │
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Raw Data    │  │ Processed   │   │
│  │ Storage     │  │ Data Store  │   │
│  └─────────────┘  └─────────────┘   │
│  ┌─────────────┐  ┌─────────────┐   │
│  │ Vector      │  │ Export      │   │
│  │ Database    │  │ Module      │   │
│  └─────────────┘  └─────────────┘   │
└─────────────────────────────────────┘
```

## Module Specifications

### 1. Crawler Manager

#### Config Manager

- **Purpose**: Centralized configuration for all crawler components
- **Key Features**:
  - Environment-specific settings (dev, test, prod)
  - Source-specific crawl parameters
  - Rate limiting and politeness settings
  - Proxy configuration
  - User-agent rotation settings
  - File structure:
    ```
    config/
    ├── base_config.yaml       # Common settings
    ├── sources/               # Source-specific configurations
    │   ├── moh.yaml           # Ministry of Health specific settings
    │   ├── hospitals.yaml     # Hospital websites settings
    │   └── portals.yaml       # Health portal settings
    ├── crawl_patterns.yaml    # XPath/CSS selectors for extraction
    └── runtime_config.yaml    # Dynamic runtime configuration
    ```

#### URL Frontier & Scheduler

- **Purpose**: Manage crawl targets and execution schedule
- **Key Features**:
  - Prioritized URL queue management
  - Duplicate URL detection
  - Crawl depth control
  - Scheduling and frequency management
  - Crawl history tracking
  - Interfaces:

    ```python
    class URLFrontier:
        def add_url(self, url, priority=0, metadata=None)
        def get_next_batch(self, batch_size=10)
        def mark_processed(self, url, status, result_metadata)
        def get_crawl_stats()

    class CrawlScheduler:
        def schedule_crawl(self, source_id, frequency='daily')
        def get_due_crawls()
        def update_crawl_status(self, crawl_id, status)
        def get_crawl_history(self, source_id)
    ```

### 2. Site-Specific Extractors

- **Purpose**: Specialized modules for each data source
- **Key Features**:
  - Custom navigation patterns
  - Site-specific content extraction rules
  - Authentication handling (if needed)
  - Pagination management
  - Structure:
    ```
    extractors/
    ├── base_extractor.py      # Abstract base class
    ├── government/
    │   ├── moh_extractor.py   # Ministry of Health extractor
    │   └── who_extractor.py   # WHO Vietnam extractor
    ├── hospitals/
    │   ├── vinmec_extractor.py
    │   └── fv_hospital_extractor.py
    └── portals/
        ├── suckhoedoisong_extractor.py
        └── duocviet_extractor.py
    ```

### 3. Crawl Engine

#### Fetchers

- **Purpose**: Handle HTTP requests and responses
- **Key Features**:
  - Configurable request headers
  - Cookie and session management
  - Response validation
  - Error handling and retry logic
  - Proxy rotation
  - Rate limiting enforcement
  - Interfaces:
    ```python
    class BaseFetcher:
        def fetch(self, url, headers=None, cookies=None)
        def fetch_with_retry(self, url, max_retries=3)
        def get_request_stats()
    ```

#### Parsers

- **Purpose**: Extract structured data from HTML/XML responses
- **Key Features**:
  - HTML/XML parsing
  - Content extraction via XPath/CSS selectors
  - Text normalization
  - Date parsing
  - Image and media extraction
  - Interfaces:
    ```python
    class BaseParser:
        def parse_html(self, html_content)
        def extract_content(self, parsed_html, extraction_rules)
        def extract_metadata(self, parsed_html)
        def extract_links(self, parsed_html, filter_pattern=None)
    ```

#### Pipelines

- **Purpose**: Process and transform extracted data
- **Key Features**:
  - Data validation
  - Field normalization
  - Duplicate detection
  - Content filtering
  - Data enrichment
  - Interfaces:
    ```python
    class BasePipeline:
        def process_item(self, item)
        def validate_item(self, item)
        def enrich_item(self, item)
    ```

### 4. Data Processing Layer

#### Cleaning & Validation

- **Purpose**: Ensure data quality and consistency
- **Key Features**:
  - Text cleaning (HTML removal, whitespace normalization)
  - Data type validation
  - Required field checking
  - Outlier detection
  - Duplicate content detection
  - Interfaces:

    ```python
    class DataCleaner:
        def clean_text(self, text)
        def sanitize_html(self, html_content)
        def normalize_whitespace(self, text)
        def remove_boilerplate(self, content)

    class DataValidator:
        def validate_schema(self, item, schema)
        def check_required_fields(self, item)
        def detect_anomalies(self, item)
    ```

#### Vietnamese NLP Module

- **Purpose**: Handle Vietnamese language processing
- **Key Features**:
  - Vietnamese tokenization
  - Diacritics normalization
  - Stop word removal
  - Medical term extraction
  - Named entity recognition for Vietnamese medical entities
  - Sentiment analysis for health content
  - Interfaces:
    ```python
    class VietnameseNLP:
        def tokenize(self, text)
        def normalize_diacritics(self, text)
        def extract_medical_terms(self, text)
        def extract_named_entities(self, text)
        def detect_language_mix(self, text)
    ```

#### Structured Extraction

- **Purpose**: Extract specific structured data from text
- **Key Features**:
  - Pattern-based extraction (regex)
  - Table extraction
  - List extraction
  - Statistical data extraction
  - Healthcare terminology mapping
  - Interfaces:
    ```python
    class StructuredExtractor:
        def extract_tables(self, html_content)
        def extract_lists(self, html_content)
        def extract_statistics(self, text)
        def extract_medical_dosages(self, text)
        def extract_contact_information(self, text)
    ```

#### Metadata Generation

- **Purpose**: Create rich metadata for extracted content
- **Key Features**:
  - Topic classification
  - Keyword extraction
  - Summary generation
  - Source attribution
  - Content categorization
  - Interfaces:
    ```python
    class MetadataGenerator:
        def classify_topic(self, text)
        def extract_keywords(self, text, max_keywords=10)
        def generate_summary(self, text, max_length=200)
        def categorize_content(self, text, taxonomy)
    ```

### 5. Storage Layer

#### Raw Data Storage

- **Purpose**: Store original crawled content
- **Key Features**:
  - Original HTML storage
  - Response metadata
  - Crawl timestamp
  - HTTP headers
  - Schema:
    ```json
    {
      "url": "String - Source URL",
      "crawl_timestamp": "DateTime",
      "http_status": "Integer - HTTP status code",
      "content_type": "String - MIME type",
      "html_content": "String - Raw HTML",
      "headers": "Object - HTTP response headers",
      "crawl_metadata": {
        "crawler_id": "String",
        "duration_ms": "Integer",
        "success": "Boolean"
      }
    }
    ```

#### Processed Data Store

- **Purpose**: Store cleaned and structured data
- **Key Features**:
  - JSON document storage
  - Domain-specific collections
  - Indexing for efficient retrieval
  - Version tracking
  - Collections:
    - `healthcare_system`
    - `health_conditions`
    - `medications`
    - `cultural_practices`
    - `elderly_care`
    - `health_statistics`

#### Vector Database

- **Purpose**: Store vector embeddings for semantic search
- **Key Features**:
  - Text embedding generation
  - Vector indexing
  - Similarity search
  - Metadata filtering
  - Schema:
    ```json
    {
      "text_id": "String - Reference to processed document",
      "text_chunk": "String - Text segment",
      "embedding": "Array - Vector representation",
      "metadata": {
        "source": "String - Source URL",
        "domain": "String - Healthcare domain",
        "date": "DateTime - Publication date",
        "language": "String - 'vi' for Vietnamese"
      }
    }
    ```

#### Export Module

- **Purpose**: Generate data exports for RAG system
- **Key Features**:
  - JSON/CSV export
  - Incremental updates
  - Data transformation for target systems
  - Export scheduling
  - Interfaces:
    ```python
    class DataExporter:
        def export_to_json(self, collection, query, output_path)
        def export_to_csv(self, collection, query, output_path)
        def export_incremental(self, collection, last_export_date)
        def export_for_vector_db(self, collection, chunk_size=512)
    ```

## Data Flow

1. **Crawl Initiation**

   - Scheduler triggers crawl based on configuration
   - URL Frontier provides batch of URLs to process
   - Crawler Manager assigns URLs to appropriate extractors

2. **Data Acquisition**

   - Site-specific extractor navigates to target pages
   - Fetcher retrieves HTML content with politeness controls
   - Parser extracts raw content based on extraction rules
   - Initial pipeline performs basic validation

3. **Data Processing**

   - Cleaning module removes HTML and normalizes text
   - Vietnamese NLP module processes language-specific elements
   - Structured extractor identifies tables, lists, and patterns
   - Validation ensures data meets quality standards

4. **Enrichment & Classification**

   - Metadata generator adds keywords and categories
   - Content is classified into healthcare domains
   - Related content is linked when possible
   - Source attribution is added

5. **Storage & Indexing**

   - Raw data is archived in raw storage
   - Processed data is stored in domain-specific collections
   - Text is embedded and stored in vector database
   - Indexes are updated for efficient retrieval

6. **Export & Integration**
   - Processed data is exported in RAG-compatible format
   - Vector embeddings are exported for semantic search
   - Metadata is formatted for retrieval filtering
   - Crawl statistics are generated for monitoring

## Error Handling & Resilience

### Error Types & Handling Strategies

| Error Type             | Detection                       | Handling Strategy                     | Recovery                      |
| ---------------------- | ------------------------------- | ------------------------------------- | ----------------------------- |
| Network Failure        | HTTP timeout/error              | Exponential backoff retry             | Reschedule after delay        |
| Rate Limiting          | 429 status code                 | Pause crawler, increase delay         | Resume with longer intervals  |
| Parser Failure         | Exception in extraction         | Log error, continue with partial data | Flag for manual review        |
| Schema Violation       | Validation failure              | Reject item, log details              | Continue with next item       |
| Authentication Failure | 401/403 status code             | Refresh credentials, retry            | Alert if persistent           |
| Site Structure Change  | Extraction yields empty results | Flag for pattern update               | Fall back to previous pattern |

### Monitoring & Alerting

- **Health Metrics**:

  - Crawl success rate
  - Items processed per minute
  - Error frequency by type
  - Response time distribution
  - Storage usage

- **Alert Conditions**:
  - Crawl success rate below 80%
  - Error spike (>20% increase)
  - Critical source unavailable >24h
  - Storage approaching capacity (>80%)
  - Processing pipeline stalled

## Development & Testing Plan

### Development Environment

- **Local Setup**:

  - Docker containers for services
  - Local MongoDB instance
  - Python virtual environment
  - Pre-commit hooks for code quality
  - Development configuration with limited crawl scope

- **Test Environment**:
  - Isolated test database
  - Mock HTTP responses
  - Reduced rate limits
  - Synthetic Vietnamese health data

### Testing Strategy

- **Unit Tests**:

  - Test each component in isolation
  - Mock external dependencies
  - Focus on data processing logic
  - Vietnamese language handling edge cases

- **Integration Tests**:

  - Test component interactions
  - Use recorded HTTP responses
  - Verify data flow through pipeline
  - Test database operations

- **System Tests**:
  - End-to-end crawl of limited scope
  - Verify complete data processing
  - Test scheduling and monitoring
  - Performance under load

### Quality Assurance

- **Code Quality**:

  - PEP 8 compliance
  - Type annotations
  - Documentation coverage
  - Code review process

- **Data Quality**:
  - Content validation rules
  - Sample-based manual review
  - Statistical outlier detection
  - Duplicate detection

## Deployment & Operations

### Deployment Strategy

- **Containerization**:

  - Docker containers for each component
  - Docker Compose for local deployment
  - Kubernetes for production scaling

- **Configuration Management**:
  - Environment-specific settings
  - Secrets management
  - Feature flags for gradual rollout

### Operational Procedures

- **Backup & Recovery**:

  - Daily database backups
  - Crawl state persistence
  - Disaster recovery plan

- **Scaling**:

  - Horizontal scaling of crawler workers
  - Database sharding strategy
  - Load balancing for high-traffic periods

- **Monitoring**:
  - Prometheus metrics
  - Grafana dashboards
  - Log aggregation
  - Alerting rules

## Security Considerations

- **Network Security**:

  - HTTPS for all requests
  - IP rotation for anonymity
  - Firewall rules for outbound traffic

- **Data Security**:

  - Encryption at rest
  - Access control for stored data
  - PII detection and removal
  - Data retention policies

- **Compliance**:
  - Terms of service adherence
  - robots.txt compliance
  - Rate limiting enforcement
  - Attribution preservation

## Performance Targets

- **Throughput**:

  - Process 1,000 pages per hour
  - Extract 5,000+ healthcare data points daily
  - Generate 10,000+ vector embeddings per day

- **Latency**:

  - Average processing time <5s per page
  - Data available for RAG within 1 hour of crawl
  - Export generation <10 minutes

- **Resource Usage**:
  - Peak memory usage <4GB per worker
  - Storage growth <1GB per day
  - CPU utilization <70% average

## Future Enhancements

- **Machine Learning Integration**:

  - Automated content quality scoring
  - Vietnamese medical entity recognition model
  - Content relevance prediction

- **Advanced NLP**:

  - Vietnamese medical terminology extraction
  - Health condition symptom mapping
  - Treatment efficacy analysis

- **Data Enhancement**:

  - Cross-reference with international health databases
  - Regional health statistics correlation
  - Temporal trend analysis

- **User Feedback Loop**:
  - Content quality feedback from RAG system
  - Automated extractor pattern updates
  - Priority adjustment based on usage patterns
