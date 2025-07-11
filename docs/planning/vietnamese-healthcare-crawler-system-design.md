# Vietnamese Healthcare Data Crawler System Design

## Executive Summary

This document outlines the design and implementation plan for a comprehensive Vietnamese healthcare data ingestion system using **local Python crawlers** that integrates with the existing CareCircle AI Assistant to provide localized medical knowledge and guidance. The system will enhance the current RAG (Retrieval-Augmented Generation) capabilities by incorporating Vietnamese healthcare sources, medical databases, and regulatory information through a local execution architecture.

## 1. System Analysis Phase

### 1.1 Current AI Module Implementation

**Existing Infrastructure:**

- ✅ **Backend**: NestJS with DDD architecture, OpenAI integration, conversation management
- ✅ **Vector Database**: Milvus configured in Docker Compose (not yet integrated)
- ✅ **Authentication**: Firebase authentication with admin SDK
- ✅ **Background Processing**: BullMQ for job queues
- ✅ **Health Context**: Integration with user health data, metrics, and profiles

**Missing Components:**

- ❌ **Vector Database Service**: Milvus integration in backend
- ❌ **RAG System**: No current implementation for knowledge retrieval
- ❌ **Data Ingestion API**: No existing API for receiving crawled content
- ❌ **Knowledge Base**: No medical knowledge management system
- ❌ **Local Crawler Scripts**: No Python crawler implementation

### 1.2 New Local Crawler Architecture

**Status**: Migrating from planned server-side crawling to local Python execution.

**Architecture Benefits:**
- No server resource consumption for crawling operations
- Easier development and debugging with Python tools
- Flexible deployment and scheduling options
- Simpler backend focused on data ingestion and processing

**Current AI Assistant Integration Points:**

- Conversation service with OpenAI API
- Health context builder using user data
- Healthcare-specific prompts and validation
- Emergency detection and escalation
- Background job processing for health analytics

## 2. Market Research Phase

### 2.1 Vietnamese Healthcare Data Sources

**Government and Official Sources:**

- **Vietnam Ministry of Health (Bộ Y tế)**: Official health policies, treatment guidelines
- **Infrastructure and Medical Device Administration (IMDA)**: Medical device regulations
- **Government Health Statistics**: Expenditure data, health indicators
- **Official Treatment Protocols**: "Hướng dẫn điều trị" - clinical guidelines

**Medical Information Systems:**

- **Hospital Information Systems (HIS)**: Major Vietnamese hospitals
- **Electronic Medical Records (EMR)**: Healthcare provider systems
- **Laboratory Information Systems (LIS)**: Diagnostic data
- **District Health Systems**: Community health information

**Pharmaceutical Sources:**

- **Vietnamese Drug Information**: "Thông tin thuốc" databases
- **Clinical Pharmacy Guidelines**: "Dược lâm sàng" protocols
- **Drug Interaction Databases**: Safety and efficacy information
- **Pharmaceutical Research**: Vietnamese medical journals

**Medical Research and Publications:**

- **Vietnamese Medical Journals**: Peer-reviewed research
- **Clinical Treatment Guidelines**: Evidence-based protocols
- **Medical Education Materials**: Training and reference content
- **Healthcare Quality Standards**: Safety and compliance guidelines

### 2.2 Data Source Characteristics

**Access Methods:**

- **Web Scraping**: Public healthcare websites and portals
- **API Integration**: Available government and institutional APIs
- **Document Processing**: PDF guidelines, research papers
- **RSS/News Feeds**: Health news and updates

**Data Formats:**

- **Structured**: JSON APIs, XML feeds
- **Semi-structured**: HTML content, PDF documents
- **Unstructured**: News articles, research papers

**Update Frequencies:**

- **Real-time**: Health news and alerts
- **Daily**: Policy updates, new research
- **Weekly**: Treatment guideline revisions
- **Monthly**: Statistical reports, regulatory changes

## 3. Crawler System Design Phase

### 3.1 Local Python Crawler Architecture Overview

**Two-Part System Design:**

1. **Local Python Crawlers** (./crawlers/)
2. **Backend Data Ingestion API** (Knowledge Management Context)

**Local Python Crawler Structure:**
```
./crawlers/
├── requirements.txt                   # Python dependencies
├── .venv/                            # Virtual environment
├── config/
│   ├── sources.json                  # Vietnamese healthcare sources
│   ├── crawler_settings.json        # Rate limiting, retry settings
│   └── api_config.json              # Backend API configuration
├── src/
│   ├── core/
│   │   ├── base_crawler.py          # Base crawler with rate limiting
│   │   ├── content_processor.py     # Vietnamese text processing
│   │   └── api_client.py            # Backend API communication
│   ├── extractors/
│   │   ├── ministry_health.py       # Government source extractor
│   │   ├── hospital_sites.py        # Hospital website extractors
│   │   └── pharma_db.py             # Pharmaceutical database extractors
│   └── utils/
│       ├── vietnamese_nlp.py        # Vietnamese NLP processing
│       └── file_manager.py          # Local file management
├── scripts/
│   ├── crawl_all.py                 # Run all crawlers
│   ├── upload_data.py               # Upload to backend API
│   └── validate_sources.py          # Test source accessibility
└── output/
    ├── raw/                         # Raw crawled content (JSON)
    ├── processed/                   # Cleaned content (JSON)
    └── logs/                        # Crawler execution logs
```

**Backend Knowledge Management Context:**
```
backend/src/knowledge-management/
├── domain/
│   ├── entities/
│   │   ├── knowledge-item.entity.ts
│   │   ├── content-batch.entity.ts
│   │   └── data-source.entity.ts
│   ├── repositories/
│   │   ├── knowledge-item.repository.ts
│   │   └── data-source.repository.ts
│   └── value-objects/
│       ├── medical-content.vo.ts
│       └── content-quality.vo.ts
├── application/
│   └── services/
│       ├── content-processing.service.ts
│       ├── knowledge-indexing.service.ts
│       └── data-ingestion.service.ts
├── infrastructure/
│   ├── repositories/
│   │   ├── prisma-knowledge-item.repository.ts
│   │   └── prisma-data-source.repository.ts
│   └── services/
│       ├── vietnamese-nlp.service.ts
│       ├── vector-database.service.ts
│       └── content-validation.service.ts
└── presentation/
    └── controllers/
        ├── data-ingestion.controller.ts
        └── knowledge.controller.ts
```

### 3.2 Local Crawler ETL Process Design

**Extract Phase (Local Python Crawlers):**

- **Web Scraping**: requests + BeautifulSoup for static content, Scrapy for complex sites
- **Vietnamese Text Processing**: underthesea and pyvi for Vietnamese NLP
- **Content Storage**: Local JSON files with structured data formats
- **Rate Limiting**: Polite crawling with configurable delays and robots.txt compliance

**Transform Phase (Local Python Processing):**

- **Content Cleaning**: Remove navigation, ads, and non-medical content
- **Vietnamese NLP**: Text normalization, entity extraction, medical term recognition
- **Quality Assessment**: Authority scoring, content validation, duplicate detection
- **Data Structuring**: Prepare JSON format for API upload

**Load Phase (Backend API Ingestion):**

- **API Upload**: Batch upload processed content via REST endpoints
- **Backend Validation**: Content structure validation and quality checks
- **Vector Generation**: OpenAI embeddings for Vietnamese medical content
- **Database Storage**: Milvus vector database and PostgreSQL metadata
- **Content Deduplication**: Hash-based duplicate detection

**Transform Phase:**

- **Vietnamese Text Processing**:
  - Unicode normalization for diacritics
  - Medical terminology extraction
  - Entity recognition (medications, conditions, procedures)
  - Abbreviation expansion and synonym mapping

- **Content Structuring**:
  - Medical content categorization
  - Metadata extraction (source, date, specialty)
  - Quality scoring based on source authority
  - Medical fact verification

- **Vector Preparation**:
  - Text chunking (500-1000 tokens per chunk)
  - Context preservation across chunks
  - Vietnamese-specific tokenization

**Load Phase:**

- **Vector Generation**: OpenAI embeddings for semantic search
- **Milvus Storage**: Vectors with filterable metadata
- **PostgreSQL Storage**: Original content and processing metadata
- **Search Indexing**: Optimized retrieval indexes

### 3.3 Vector Database Schema

**Milvus Collections:**

- `vietnamese_medical_content`: General medical information
- `drug_information`: Pharmaceutical data and interactions
- `treatment_guidelines`: Clinical protocols and procedures
- `health_news`: Recent health news and updates
- `government_policies`: Official health policies and regulations

**Vector Schema:**

- **Dimension**: 1536 (OpenAI ada-002 embeddings)
- **Metadata**: source_type, medical_specialty, authority_score, language, publication_date
- **Content**: original_text, processed_text, medical_entities

## 4. Integration Planning

### 4.1 Vector Database and RAG Integration

**Enhanced AI Assistant Capabilities:**

- **Semantic Search**: Vietnamese medical content retrieval
- **Hybrid Search**: Vector similarity + keyword matching
- **Context Ranking**: Authority-based content prioritization
- **Multi-language Support**: Vietnamese and English medical terms

**RAG System Enhancement:**

- **Enhanced Health Context**: Include relevant Vietnamese medical knowledge
- **Localized Responses**: Culturally appropriate health advice
- **Source Citations**: Reference Vietnamese medical authorities
- **Emergency Protocols**: Vietnamese emergency procedures and contacts

### 4.2 Firebase Authentication Integration

**Security and Access Control:**

- **Service Account Authentication**: Automated crawler operations
- **API Security**: Firebase admin authentication for management endpoints
- **Role-based Access**: Healthcare provider and admin permissions
- **Audit Trails**: Complete operation logging for compliance

### 4.3 DDD Architecture Compliance

**Bounded Context Integration:**

- **Domain Events**: Publish events for new medical content
- **Repository Pattern**: Consistent data access patterns
- **Anti-Corruption Layer**: Protect AI Assistant from crawler details
- **Shared Kernel**: Common medical terminology and validation

**Cross-Context Communication:**

- **Event-Driven Architecture**: Loose coupling between contexts
- **Context Mapping**: Clear relationship definitions
- **Infrastructure Consistency**: Shared PostgreSQL, Redis, and BullMQ

## 5. Implementation Roadmap

### Phase 1: Foundation (2-3 weeks)

- [ ] Set up Knowledge Management bounded context structure
- [ ] Implement Milvus vector database service integration
- [ ] Create basic crawler infrastructure with rate limiting
- [ ] Establish Vietnamese text processing pipeline
- [ ] Set up data source management system

### Phase 2: Core Crawling (3-4 weeks)

- [ ] Implement web scraping for Vietnamese healthcare sources
- [ ] Build content extraction and cleaning pipelines
- [ ] Create medical entity recognition for Vietnamese content
- [ ] Implement vector embedding generation and storage
- [ ] Set up background job processing for crawling tasks

### Phase 3: RAG Integration (2-3 weeks)

- [ ] Enhance AI Assistant with semantic search capabilities
- [ ] Implement hybrid search for Vietnamese queries
- [ ] Add source citation and authority ranking
- [ ] Create medical content validation and quality scoring
- [ ] Integrate with existing health context building

### Phase 4: Optimization and Monitoring (2 weeks)

- [ ] Implement content freshness tracking and updates
- [ ] Add crawler performance monitoring and alerting
- [ ] Create administrative interfaces for crawler management
- [ ] Optimize search performance and caching strategies
- [ ] Conduct end-to-end testing with Vietnamese medical queries

## 6. Technical Feasibility Assessment

**High Feasibility:**

- Basic web crawling and content extraction
- Text processing and cleaning pipelines
- Vector storage and retrieval
- Integration with existing backend architecture

**Medium Feasibility:**

- Vietnamese medical NLP and entity recognition
- Content quality assessment and validation
- Real-time content updates and synchronization

**Considerations:**

- Some government sources may require special access permissions
- Anti-crawling measures on certain websites
- Vietnamese language processing complexity
- Medical content accuracy validation requirements

**Risk Mitigation:**

- Start with publicly available sources
- Implement robust error handling and retry mechanisms
- Use multiple data sources for content validation
- Establish medical expert consultation for content verification

## 7. Resource Requirements

**Development Resources:**

- **Backend Development**: 1-2 developers for 8-12 weeks
- **Vietnamese Medical Expertise**: Consultant for content validation
- **DevOps Support**: Infrastructure setup and monitoring

**Infrastructure Requirements:**

- **Existing Infrastructure**: Sufficient Milvus and PostgreSQL capacity
- **External APIs**: OpenAI embeddings, potential Vietnamese NLP services
- **Storage**: Additional storage for crawled content and vectors

**Operational Requirements:**

- **Monitoring**: Crawler performance and content quality tracking
- **Maintenance**: Regular source validation and content updates
- **Compliance**: Healthcare data handling and privacy requirements

## 8. Success Metrics

**Technical Metrics:**

- Crawling success rate (>95%)
- Content processing accuracy (>90%)
- Search relevance scores (>85%)
- System uptime and reliability (>99%)

**Business Metrics:**

- AI Assistant response quality improvement
- Vietnamese medical query coverage
- User satisfaction with localized responses
- Healthcare provider adoption and feedback

---

**Document Status**: Draft for Review
**Last Updated**: 2025-07-10
**Next Review**: Implementation Phase 1 Completion
