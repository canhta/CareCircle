# CareCircle Crawler Architecture Migration Plan

## Migration Overview

This document outlines the migration from the originally planned **server-side crawler architecture** to a new **local Python crawler execution architecture** for the CareCircle Vietnamese healthcare data ingestion system.

## Original vs New Architecture

### Original Architecture (Planned)
- ❌ **Server-Side Crawling**: Puppeteer/Playwright running on backend server
- ❌ **Resource Intensive**: High CPU/memory usage on production servers
- ❌ **Complex Deployment**: Chromium dependencies in production environment
- ❌ **Debugging Challenges**: Difficult to debug crawler issues in production

### New Architecture (Implemented)
- ✅ **Local Python Execution**: Standalone Python scripts with virtual environment
- ✅ **Resource Efficient**: No server resources consumed for crawling
- ✅ **Simple Deployment**: Backend focused on data ingestion APIs only
- ✅ **Easy Development**: Local debugging and testing capabilities

## Migration Benefits

### 1. Development Benefits
- **Easier Debugging**: Run crawlers locally with full debugging capabilities
- **Faster Iteration**: Test and modify crawlers without backend deployment
- **Language Flexibility**: Python's rich ecosystem for web scraping and NLP
- **Vietnamese NLP**: Better support for Vietnamese text processing libraries

### 2. Operational Benefits
- **Resource Efficiency**: Backend servers not consumed by crawling operations
- **Scalable Execution**: Run crawlers on different machines or environments
- **Flexible Scheduling**: Independent crawler execution scheduling
- **Simpler Monitoring**: Separate logging and monitoring for crawlers

### 3. Deployment Benefits
- **Lighter Backend**: No Chromium/Playwright dependencies in production
- **Independent Updates**: Update crawlers without backend deployment
- **Environment Isolation**: Crawler issues don't affect backend stability
- **Cost Optimization**: Reduced server resource requirements

## Implementation Phases

### Phase 1: Documentation Updates ✅ COMPLETED
- [x] Updated Knowledge Management bounded context documentation
- [x] Created local Python crawler architecture documentation
- [x] Updated planning documents to reflect new architecture
- [x] Created setup guides and API documentation

### Phase 2: Backend API Development (2-3 weeks)
- [ ] Implement data ingestion API endpoints
- [ ] Create content validation and processing services
- [ ] Set up vector database integration for uploaded content
- [ ] Implement batch processing and status tracking

### Phase 3: Python Crawler Development (3-4 weeks)
- [ ] Set up Python virtual environment and project structure
- [ ] Implement base crawler classes and utilities
- [ ] Create Vietnamese healthcare source extractors
- [ ] Build content processing and API upload functionality

### Phase 4: Integration and Testing (1-2 weeks)
- [ ] Test end-to-end data flow from crawlers to backend
- [ ] Validate Vietnamese content processing and vector generation
- [ ] Performance testing and optimization
- [ ] Documentation updates and deployment guides

## Technical Implementation Details

### Backend Changes Required

#### New API Endpoints
```typescript
// Data Ingestion Controller
POST /knowledge-management/content/upload
POST /knowledge-management/content/bulk-upload
GET /knowledge-management/sources
POST /knowledge-management/sources/validate
GET /knowledge-management/content/status
```

#### Services to Implement
- `DataIngestionService` - Handle uploaded content
- `ContentValidationService` - Validate content structure and quality
- `BatchProcessingService` - Handle large uploads efficiently
- `VectorDatabaseService` - Generate embeddings and store in Milvus

#### Database Schema Updates
```sql
-- Content batches for tracking uploads
CREATE TABLE content_batches (
  id UUID PRIMARY KEY,
  batch_id VARCHAR(255) UNIQUE,
  source_id VARCHAR(255),
  total_items INTEGER,
  processed_items INTEGER,
  status VARCHAR(50),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Knowledge items with enhanced metadata
CREATE TABLE knowledge_items (
  id UUID PRIMARY KEY,
  content_id VARCHAR(255) UNIQUE,
  source_id VARCHAR(255),
  source_url TEXT,
  title TEXT,
  content TEXT,
  content_type VARCHAR(100),
  language VARCHAR(10),
  published_at TIMESTAMP,
  crawled_at TIMESTAMP,
  metadata JSONB,
  vector_id VARCHAR(255),
  quality_score DECIMAL(3,2),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Python Crawler Implementation

#### Project Structure
```
./crawlers/
├── requirements.txt
├── .venv/
├── config/
├── src/
│   ├── core/
│   ├── extractors/
│   └── utils/
├── scripts/
└── output/
```

#### Key Dependencies
```txt
# Web scraping
requests>=2.31.0
beautifulsoup4>=4.12.0
scrapy>=2.11.0

# Vietnamese NLP
underthesea>=6.7.0
pyvi>=0.1.1

# Data processing
pandas>=2.0.0
pydantic>=2.0.0

# Utilities
loguru>=0.7.0
python-dotenv>=1.0.0
```

#### Core Components
- **BaseCrawler**: Rate limiting, error handling, session management
- **ContentProcessor**: Vietnamese text processing and entity extraction
- **APIClient**: Backend communication and batch uploads
- **SourceExtractors**: Specific extractors for Vietnamese healthcare sources

## Data Flow Architecture

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

## Vietnamese Healthcare Sources

### Government Sources
- **Vietnam Ministry of Health**: https://moh.gov.vn
- **IMDA**: Medical device regulations
- **Government Health Statistics**: Public health data

### Medical Information
- **Major Vietnamese Hospitals**: Bach Mai, Cho Ray, K Hospital
- **Pharmaceutical Databases**: Vietnamese drug information
- **Medical Universities**: Research and educational content

### News and Updates
- **VnExpress Health**: Health news portal
- **Sức khỏe & Đời sống**: Health and lifestyle news
- **Medical Research**: Vietnamese medical publications

## Quality Assurance

### Content Validation
- **Structure Validation**: Ensure proper JSON format and required fields
- **Medical Relevance**: Validate content is healthcare-related
- **Vietnamese Language**: Verify Vietnamese text encoding and processing
- **Authority Scoring**: Assess source credibility and content quality

### Testing Strategy
- **Unit Tests**: Test individual crawler components
- **Integration Tests**: Test API communication and data flow
- **Source Tests**: Validate source accessibility and content extraction
- **Performance Tests**: Test batch processing and upload performance

## Monitoring and Maintenance

### Logging
- **Crawler Logs**: Detailed execution logs for each crawler run
- **API Logs**: Backend API request and response logging
- **Error Tracking**: Comprehensive error logging and alerting
- **Performance Metrics**: Timing and resource usage monitoring

### Maintenance Tasks
- **Source Validation**: Regular checks for source accessibility
- **Content Freshness**: Monitor for updated content
- **Performance Optimization**: Optimize crawler and processing performance
- **Error Analysis**: Regular review and resolution of crawler errors

## Migration Timeline

### Week 1-2: Backend API Development
- Implement data ingestion endpoints
- Create content validation services
- Set up database schema updates
- Test API functionality

### Week 3-4: Python Crawler Setup
- Set up Python virtual environment
- Implement base crawler classes
- Create configuration management
- Build core utilities

### Week 5-6: Source Extractors
- Implement Ministry of Health extractor
- Create hospital website extractors
- Build pharmaceutical database extractors
- Develop health news extractors

### Week 7-8: Integration and Testing
- Test end-to-end data flow
- Performance optimization
- Documentation completion
- Deployment preparation

## Success Criteria

### Technical Success
- [ ] All Vietnamese healthcare sources successfully crawled
- [ ] Content properly processed and stored in vector database
- [ ] API endpoints functioning with proper authentication
- [ ] Vietnamese NLP processing working correctly

### Operational Success
- [ ] Crawlers running reliably on schedule
- [ ] Backend performance not impacted by data ingestion
- [ ] Monitoring and alerting functioning properly
- [ ] Documentation complete and accessible

### Business Success
- [ ] AI Assistant enhanced with Vietnamese medical knowledge
- [ ] Improved response quality for Vietnamese healthcare queries
- [ ] Scalable system for ongoing content updates
- [ ] Maintainable architecture for future enhancements

## Related Documentation

- [Local Python Crawler Architecture](./README.md)
- [Setup Guide](./setup-guide.md)
- [Data Ingestion API Guide](./data-ingestion-api.md)
- [Knowledge Management Context](../bounded-contexts/07-knowledge-management/README.md)
- [Vietnamese Healthcare Crawler System Design](../planning/vietnamese-healthcare-crawler-system-design.md)
