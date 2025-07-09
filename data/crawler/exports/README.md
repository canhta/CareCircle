# CareCircle Vietnamese Healthcare Data Crawler - Exports

This directory contains exported data from the Vietnamese Healthcare Data Crawler. The files are generated during the crawling, processing, and embedding processes.

## File Types

### Crawled Data

Files with pattern: `{source_id}_crawled_{timestamp}.json`

These files contain raw data crawled from Vietnamese healthcare websites. Each item typically includes:

- `title`: Title of the webpage or article
- `content`: Raw text content extracted from the page
- `url`: Source URL
- `crawl_timestamp`: Time when the data was crawled
- `categories`: Automatically assigned categories
- `source_id`: Identifier of the source website

### Processed Data

Files with pattern: `{source_id}_processed_{timestamp}.json`

These files contain processed Vietnamese text with:

- `content`: Cleaned and normalized Vietnamese text
- `medical_terms`: Extracted Vietnamese medical terminology
- `named_entities`: Recognized entities (people, organizations, locations)
- All original metadata from the crawled data

### Chunked Data

Files with pattern: `{source_id}_chunks_{timestamp}.json`

These files contain text chunks suitable for vector database storage:

- `text`: Text chunk with appropriate size for embedding
- `metadata`: Information about the chunk's source and position
- `categories`: Categories relevant to the chunk
- `source`: Source URL
- `title`: Original document title

### Search Results

Files with pattern: `search_results_{timestamp}.json`

These files contain results from vector database searches:

- `text`: Retrieved text chunk
- `score`: Similarity score
- `source`: Source URL
- `category`: Categories of the result
- `metadata`: Additional information about the result

## Usage

These exported files serve several purposes:

1. **Data Inspection**: Examine the data at different stages of the pipeline
2. **Debugging**: Troubleshoot issues in the crawling or processing steps
3. **Backup**: Preserve crawled data in case of database issues
4. **Offline Processing**: Enable processing without re-crawling
5. **Data Migration**: Facilitate moving data between environments

## Example Commands

To process previously crawled data:

```bash
python src/end_to_end_demo.py --skip-crawl --input-file exports/moh_crawled_20250710_123456.json
```

To search the vector database using processed data:

```bash
python src/search_vectors.py --query "điều trị tiểu đường" --domain healthcare_system
```

## Data Retention

By default, exported files are retained indefinitely. For production environments, consider implementing a data retention policy to manage disk usage.
