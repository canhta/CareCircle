# CareCircle Vietnamese Healthcare Data Crawler

A specialized web crawler designed to collect healthcare information from Vietnamese sources for the CareCircle RAG (Retrieval-Augmented Generation) system.

## Overview

This crawler module systematically extracts healthcare data from authoritative Vietnamese websites, processes it with Vietnamese language-specific tools, and stores it in structured formats suitable for vector database ingestion. The collected data serves as the knowledge base for CareCircle's AI assistant, providing Vietnam-specific healthcare context.

## Features

- **Vietnamese-Optimized**: Built specifically for Vietnamese language content with proper diacritics handling and language-specific processing
- **Healthcare-Focused**: Extracts medical terminology, health conditions, medications, and healthcare policies
- **Site-Specific Extractors**: Custom extractors for different Vietnamese healthcare websites
- **Structured Data Extraction**: Converts unstructured web content into structured healthcare data
- **Vector Database Integration**: Prepares data for semantic search via Milvus vector database
- **Configurable**: Extensive YAML-based configuration for crawl behavior and extraction patterns
- **Polite Crawling**: Respects robots.txt, implements rate limiting, and follows ethical web scraping practices

## Directory Structure

```
crawler/
├── config/                  # Configuration files
│   ├── base_config.yaml     # Base crawler configuration
│   └── sources/             # Source-specific configurations
│       ├── moh.yaml         # Ministry of Health configuration
│       └── ...              # Other source configurations
├── src/                     # Source code
│   ├── extractors/          # Site-specific extractors
│   │   ├── base_extractor.py        # Abstract base extractor
│   │   ├── government/              # Government site extractors
│   │   │   ├── moh_extractor.py     # Ministry of Health extractor
│   │   │   └── ...
│   │   ├── hospitals/               # Hospital site extractors
│   │   └── portals/                 # Health portal extractors
│   ├── crawl_engine/        # Core crawling components
│   ├── data_processing/     # Data processing and NLP
│   ├── storage/             # Database and storage handlers
│   └── main.py              # Main entry point
├── exports/                 # Exported data (JSON, CSV)
├── logs/                    # Log files
├── docker-compose.yml       # Docker Compose configuration
├── Dockerfile               # Docker image definition
└── requirements.txt         # Python dependencies
```

## Requirements

- Python 3.10+
- MongoDB 6.0+
- Milvus 2.2+
- Docker and Docker Compose (for containerized deployment)

## Installation

### Using Docker (Recommended)

1. Clone the repository:

   ```bash
   git clone https://github.com/carecircle/healthcare-crawler.git
   cd healthcare-crawler
   ```

2. Start the containerized environment:

   ```bash
   docker-compose up -d
   ```

3. Access the services:
   - MongoDB Express: http://localhost:8081
   - Milvus UI (Attu): http://localhost:8080

### Manual Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/carecircle/healthcare-crawler.git
   cd healthcare-crawler
   ```

2. Create a virtual environment:

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Install Vietnamese language support:

   ```bash
   python -m nltk.downloader punkt stopwords wordnet
   ```

5. Set up MongoDB and Milvus (refer to their official documentation).

## Usage

### Basic Usage

Run the crawler with default settings (Ministry of Health website):

```bash
python src/main.py
```

### Specifying Source

Crawl a specific source:

```bash
python src/main.py --source moh
```

### Limiting Crawl Scope

Limit the number of pages to crawl:

```bash
python src/main.py --source moh --max-pages 100
```

### Adjusting Log Level

Change the logging verbosity:

```bash
python src/main.py --log-level DEBUG
```

## Configuration

### Base Configuration

The `config/base_config.yaml` file contains common settings for all crawlers:

- Request settings (headers, timeouts, retries)
- Rate limiting rules
- Content extraction patterns
- Processing options
- Storage configuration

### Source-Specific Configuration

Each source has its own configuration file in `config/sources/`:

- Start URLs
- Allowed domains
- Site-specific extraction selectors
- Content categorization rules
- Custom extraction patterns

## Adding New Sources

To add a new source:

1. Create a new configuration file in `config/sources/` (e.g., `vinmec.yaml`)
2. Implement a new extractor class in the appropriate directory (e.g., `src/extractors/hospitals/vinmec_extractor.py`)
3. Update `src/main.py` to include the new extractor

## Data Processing Pipeline

1. **Crawling**: Fetch pages from Vietnamese healthcare websites
2. **Extraction**: Extract structured content using site-specific selectors
3. **Processing**: Clean, normalize, and process Vietnamese text
4. **Categorization**: Classify content into healthcare domains
5. **Enrichment**: Add metadata, extract entities, generate summaries
6. **Storage**: Store in MongoDB with appropriate structure
7. **Vector Generation**: Create embeddings for semantic search
8. **Export**: Generate files for RAG system ingestion

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Vietnamese Ministry of Health for providing public health information
- Vietnamese healthcare institutions for their valuable online resources
- Open source libraries that make this crawler possible
