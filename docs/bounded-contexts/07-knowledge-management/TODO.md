# Knowledge Management Context - Implementation TODO

## Implementation Status: 🚀 Ready to Begin

**Current State**: Architecture refactored to local crawler execution
**Target**: Vietnamese healthcare data ingestion system with RAG integration via local crawlers
**Priority**: High - Critical for Vietnamese market adaptation

## Architecture Overview

**New Local Crawler Architecture:**

- **Local Execution**: Standalone crawler scripts in `./crawlers/` directory
- **Data Ingestion**: Backend APIs for receiving crawled content
- **Vector Processing**: Backend handles embedding generation and storage
- **Benefits**: No server-side Chromium, easier debugging, scalable execution

## Phase 1: Backend Foundation Setup (2-3 weeks) 🏗️

### 1.1 Bounded Context Structure Setup

- [ ] **Create Knowledge Management bounded context directory structure**
  - **Location**: `backend/src/knowledge-management/`
  - **Components**: domain/, application/, infrastructure/, presentation/
  - **Pattern**: Follow existing DDD bounded context patterns

- [ ] **Domain Layer Implementation**
  - [ ] Create KnowledgeItem entity with Vietnamese medical content support
  - [ ] Create DataSource entity for Vietnamese healthcare sources
  - [ ] Create ContentBatch entity for batch upload tracking
  - [ ] Create MedicalEntity value object for Vietnamese medical terms
  - [ ] Implement repository interfaces following DDD patterns

- [ ] **Database Schema Design**
  - [ ] Add Knowledge Management tables to Prisma schema
  - [ ] Create migrations for knowledge_items, data_sources, content_batches tables
  - [ ] Add indexes for Vietnamese text search and medical entity queries
  - [ ] Implement soft delete and audit trail support

### 1.2 Milvus Vector Database Integration

- [ ] **Vector Database Service Implementation**
  - **Location**: `backend/src/knowledge-management/infrastructure/services/vector-database.service.ts`
  - **Dependencies**: @zilliz/milvus2-sdk-node (already in package.json)
  - **Features**: Collection management, vector CRUD operations, similarity search

- [ ] **Vector Collections Setup**
  - [ ] Create `vietnamese_medical_content` collection (general medical info)
  - [ ] Create `drug_information` collection (pharmaceutical data)
  - [ ] Create `treatment_guidelines` collection (clinical protocols)
  - [ ] Create `health_news` collection (recent health updates)
  - [ ] Create `government_policies` collection (official health policies)

- [ ] **Vector Schema Configuration**
  - [ ] Configure 1536-dimension vectors (OpenAI ada-002 embeddings)
  - [ ] Add metadata fields: source_type, medical_specialty, authority_score, language
  - [ ] Implement vector indexing strategies for optimal search performance

### 1.3 Data Ingestion API Infrastructure

- [ ] **Data Ingestion Controller Implementation**
  - **Location**: `backend/src/knowledge-management/presentation/controllers/data-ingestion.controller.ts`
  - **Features**: Content upload endpoints, batch processing, validation
  - **Authentication**: Firebase JWT for secure access

- [ ] **API Endpoints**
  - [ ] POST /knowledge-management/content/upload - Single content upload
  - [ ] POST /knowledge-management/content/bulk-upload - Batch content upload
  - [ ] GET /knowledge-management/sources - List configured sources
  - [ ] POST /knowledge-management/sources/validate - Validate source configuration
  - [ ] GET /knowledge-management/content/status - Check processing status

- [ ] **Content Validation Pipeline**
  - [ ] Validate uploaded content structure and format
  - [ ] Implement content deduplication using hash-based detection
  - [ ] Create content quality assessment
  - [ ] Add medical content validation rules

### 1.4 Vietnamese Text Processing Pipeline

- [ ] **Vietnamese NLP Service Implementation**
  - **Location**: `backend/src/knowledge-management/infrastructure/services/vietnamese-nlp.service.ts`
  - **Features**: Text normalization, medical term extraction, entity recognition

- [ ] **Text Normalization**
  - [ ] Unicode normalization for Vietnamese diacritics
  - [ ] HTML/XML tag removal and text extraction
  - [ ] Special character handling (medical symbols, units)
  - [ ] Whitespace and formatting cleanup

- [ ] **Medical Term Processing**
  - [ ] Create Vietnamese medical terminology dictionary
  - [ ] Implement abbreviation expansion (e.g., "HA" → "huyết áp")
  - [ ] Add synonym mapping for medical terms
  - [ ] Create translation mapping between Vietnamese and English

### 1.5 Data Source Management System

- [ ] **Data Source Repository Implementation**
  - **Location**: `backend/src/knowledge-management/infrastructure/repositories/prisma-data-source.repository.ts`
  - **Features**: CRUD operations, source configuration, metadata tracking

- [ ] **Vietnamese Healthcare Sources Configuration**
  - [ ] Define Vietnam Ministry of Health source metadata
  - [ ] Configure major Vietnamese hospital source definitions
  - [ ] Add Vietnamese pharmaceutical information source configs
  - [ ] Define Vietnamese health news portal sources
  - [ ] Create source authority scoring system

## Phase 2: Local Python Crawler Development (3-4 weeks) 🐍

### 2.1 Python Crawler Project Setup

- [ ] **Python Virtual Environment Setup**
  - [ ] Create `./crawlers/` directory in project root
  - [ ] Set up Python virtual environment (.venv)
  - [ ] Create requirements.txt with Python dependencies (requests, beautifulsoup4, underthesea, etc.)
  - [ ] Configure Python project structure with proper **init**.py files

- [ ] **Core Python Components**
  - [ ] Implement BaseCrawler class with rate limiting and error handling
  - [ ] Create ContentProcessor for Vietnamese text processing
  - [ ] Build APIClient for backend communication
  - [ ] Set up logging system with loguru

- [ ] **Source-Specific Python Extractors**
  - [ ] Create ministry_health.py extractor for Ministry of Health
  - [ ] Build hospital_sites.py for Vietnamese hospital websites
  - [ ] Develop pharma_db.py for pharmaceutical databases
  - [ ] Create health_news.py for Vietnamese health news portals

### 2.2 Vietnamese Language Processing with Python

- [ ] **Vietnamese NLP Integration**
  - [ ] Set up underthesea library for Vietnamese text processing
  - [ ] Configure pyvi for additional Vietnamese NLP features
  - [ ] Implement Vietnamese text normalization and cleaning
  - [ ] Add diacritic handling and character encoding support

- [ ] **Medical Entity Recognition**
  - [ ] Create Vietnamese medical terminology dictionaries
  - [ ] Implement drug name recognition for Vietnamese pharmaceuticals
  - [ ] Add disease and symptom extraction in Vietnamese
  - [ ] Build medical abbreviation expansion system

- [ ] **Content Quality Assessment**
  - [ ] Implement authority scoring based on source credibility
  - [ ] Create content freshness detection algorithms
  - [ ] Add duplicate content detection using content hashing
  - [ ] Build medical accuracy validation rules

### 2.3 Local Data Processing and Storage

- [ ] **JSON Data Management**
  - [ ] Implement local JSON file storage for crawled content
  - [ ] Create structured data formats for different content types
  - [ ] Add data validation using Pydantic models
  - [ ] Implement data compression and archiving

- [ ] **Batch Processing System**
  - [ ] Create batch upload preparation scripts
  - [ ] Implement data chunking for large datasets
  - [ ] Add progress tracking and resumable uploads
  - [ ] Build error handling and retry mechanisms

## Phase 3: Python Crawler Implementation (2-3 weeks) 🔧

### 3.1 Core Python Crawler Components

- [ ] **Base Crawler Implementation**
  - **Location**: `./crawlers/src/core/base_crawler.py`
  - **Features**: Rate limiting, error handling, session management
  - **Dependencies**: requests, beautifulsoup4, loguru

- [ ] **Content Processor Implementation**
  - **Location**: `./crawlers/src/core/content_processor.py`
  - **Features**: Vietnamese text processing, entity extraction
  - **Dependencies**: underthesea, pyvi, pydantic

- [ ] **API Client Implementation**
  - **Location**: `./crawlers/src/core/api_client.py`
  - **Features**: Backend communication, batch uploads, authentication
  - **Dependencies**: requests, python-dotenv

### 3.2 Vietnamese Healthcare Source Extractors

- [ ] **Ministry of Health Extractor**
  - **Location**: `./crawlers/src/extractors/ministry_health.py`
  - **Target**: https://moh.gov.vn
  - **Content**: Official health policies, guidelines, announcements

- [ ] **Hospital Website Extractors**
  - **Location**: `./crawlers/src/extractors/hospital_sites.py`
  - **Targets**: Bach Mai, Cho Ray, K Hospital, etc.
  - **Content**: Treatment protocols, medical information

- [ ] **Pharmaceutical Database Extractor**
  - **Location**: `./crawlers/src/extractors/pharma_db.py`
  - **Targets**: Vietnamese drug databases
  - **Content**: Drug information, interactions, dosages

- [ ] **Health News Extractor**
  - **Location**: `./crawlers/src/extractors/health_news.py`
  - **Targets**: VnExpress Health, Sức khỏe & Đời sống
  - **Content**: Health news, medical research updates

### 3.3 Python Crawler Scripts and Utilities

- [ ] **Crawler Execution Scripts**
  - **Location**: `./crawlers/scripts/`
  - [ ] crawl_all.py - Execute all configured crawlers
  - [ ] crawl_source.py - Run specific source crawler with options
  - [ ] upload_data.py - Upload processed data to backend API
  - [ ] validate_sources.py - Test source accessibility and configuration
  - [ ] cleanup.py - Clean old crawled data and logs

- [ ] **Configuration Management**
  - **Location**: `./crawlers/config/`
  - [ ] sources.json - Vietnamese healthcare source definitions
  - [ ] crawler_settings.json - Rate limiting and processing settings
  - [ ] api_config.json - Backend API endpoints and authentication

- [ ] **Vietnamese NLP Utilities**
  - **Location**: `./crawlers/src/utils/vietnamese_nlp.py`
  - [ ] Text normalization and cleaning functions
  - [ ] Medical entity extraction using underthesea
  - [ ] Vietnamese medical terminology processing
  - [ ] Content quality assessment algorithms

## Phase 4: Backend Data Ingestion API (2-3 weeks) 🔄

### 4.1 Data Ingestion Controller Implementation

- [ ] **API Endpoints**
  - **Location**: `backend/src/knowledge-management/presentation/controllers/data-ingestion.controller.ts`
  - [ ] POST /knowledge-management/content/upload - Single content upload
  - [ ] POST /knowledge-management/content/bulk-upload - Batch content upload
  - [ ] GET /knowledge-management/sources - List configured sources
  - [ ] POST /knowledge-management/sources/validate - Validate source configuration
  - [ ] GET /knowledge-management/content/status - Check processing status

- [ ] **Request Validation and Authentication**
  - [ ] Firebase JWT authentication for all endpoints
  - [ ] Content structure validation using DTOs
  - [ ] Rate limiting for API endpoints
  - [ ] Request logging and monitoring

### 4.2 Content Processing Service

- [ ] **Content Validation Service**
  - **Location**: `backend/src/knowledge-management/application/services/content-validation.service.ts`
  - [ ] Validate uploaded content structure and format
  - [ ] Check content quality and medical relevance
  - [ ] Implement duplicate detection using content hashing
  - [ ] Medical content accuracy validation

- [ ] **Batch Processing Service**
  - **Location**: `backend/src/knowledge-management/application/services/batch-processing.service.ts`
  - [ ] Handle large batch uploads efficiently
  - [ ] Implement chunked processing for memory management
  - [ ] Progress tracking and status reporting
  - [ ] Error handling and partial failure recovery

### 2.4 Vector Embedding Generation and Storage

- [ ] **Embedding Generation Service**
  - [ ] Integrate OpenAI embeddings API for Vietnamese text
  - [ ] Implement text chunking for optimal embedding (500-1000 tokens)
  - [ ] Add overlap strategy for context preservation
  - [ ] Create batch processing for large content volumes

- [ ] **Vector Storage and Indexing**
  - [ ] Store vectors in appropriate Milvus collections
  - [ ] Add metadata for filtering and ranking
  - [ ] Implement vector deduplication
  - [ ] Create vector update and versioning strategies

### 2.5 Background Job Processing for Crawling Tasks

- [ ] **Crawler Job Processor**
  - **Location**: `backend/src/knowledge-management/infrastructure/jobs/crawler.processor.ts`
  - **Integration**: BullMQ queue system
  - **Features**: Scheduled crawling, job monitoring, error handling

- [ ] **Job Scheduling and Management**
  - [ ] Implement cron-based scheduling for regular crawls
  - [ ] Add priority-based job processing
  - [ ] Create job retry mechanisms with exponential backoff
  - [ ] Implement job monitoring and alerting

## Phase 3: RAG Integration (2-3 weeks) 🤖

### 3.1 AI Assistant Semantic Search Enhancement

- [ ] **Enhanced Conversation Service Integration**
  - **Location**: `backend/src/ai-assistant/application/services/conversation.service.ts`
  - **Enhancement**: Add Vietnamese medical knowledge retrieval

- [ ] **Semantic Search Implementation**
  - [ ] Integrate vector similarity search for user queries
  - [ ] Add query preprocessing for Vietnamese medical terms
  - [ ] Implement result ranking based on relevance and authority
  - [ ] Create context-aware search filtering

### 3.2 Hybrid Search for Vietnamese Queries

- [ ] **Hybrid Search Service**
  - **Location**: `backend/src/knowledge-management/application/services/hybrid-search.service.ts`
  - **Features**: Vector similarity + keyword matching

- [ ] **Query Processing Pipeline**
  - [ ] Implement Vietnamese query normalization
  - [ ] Add medical term expansion and synonym matching
  - [ ] Create query intent detection for medical queries
  - [ ] Implement query translation for mixed-language queries

### 3.3 Source Citation and Authority Ranking

- [ ] **Authority Scoring System**
  - [ ] Implement source authority scoring (government = highest)
  - [ ] Add publication recency weighting
  - [ ] Create medical specialty relevance scoring
  - [ ] Implement citation formatting for Vietnamese sources

- [ ] **Response Enhancement**
  - [ ] Add source citations to AI responses
  - [ ] Implement authority-based content prioritization
  - [ ] Create medical disclaimer injection for appropriate content
  - [ ] Add Vietnamese emergency contact information

### 3.4 Medical Content Validation and Quality Scoring

- [ ] **Content Quality Assessment**
  - [ ] Implement medical accuracy validation algorithms
  - [ ] Create content completeness scoring
  - [ ] Add fact-checking against established medical standards
  - [ ] Implement peer review and expert validation tracking

- [ ] **Quality Monitoring**
  - [ ] Create quality metrics dashboard
  - [ ] Implement automated quality alerts
  - [ ] Add content freshness tracking
  - [ ] Create quality improvement recommendations

### 3.5 Health Context Integration

- [ ] **Enhanced Health Context Builder**
  - **Location**: `backend/src/ai-assistant/application/services/conversation.service.ts` (buildHealthContext method)
  - **Enhancement**: Include relevant Vietnamese medical knowledge

- [ ] **Context-Aware Knowledge Retrieval**
  - [ ] Filter knowledge based on user health profile
  - [ ] Prioritize content relevant to user's medical conditions
  - [ ] Add age and gender-appropriate content filtering
  - [ ] Implement personalized medical guidance

## Phase 4: Optimization and Monitoring (2 weeks) 📊

### 4.1 Content Freshness Tracking and Updates

- [ ] **Freshness Monitoring Service**
  - [ ] Implement content age tracking
  - [ ] Add automated freshness scoring
  - [ ] Create update notification system
  - [ ] Implement stale content identification and removal

### 4.2 Crawler Performance Monitoring and Alerting

- [ ] **Performance Monitoring**
  - [ ] Create crawler success rate tracking
  - [ ] Implement processing time monitoring
  - [ ] Add error rate alerting
  - [ ] Create performance optimization recommendations

### 4.3 Administrative Interfaces

- [ ] **Crawler Management API**
  - **Location**: `backend/src/knowledge-management/presentation/controllers/crawler.controller.ts`
  - **Features**: Source management, job scheduling, monitoring

- [ ] **Knowledge Management API**
  - **Location**: `backend/src/knowledge-management/presentation/controllers/knowledge.controller.ts`
  - **Features**: Content search, quality management, analytics

### 4.4 Search Performance and Caching Optimization

- [ ] **Search Optimization**
  - [ ] Implement query result caching
  - [ ] Add search performance monitoring
  - [ ] Create index optimization strategies
  - [ ] Implement search analytics and improvement

### 4.5 End-to-End Testing with Vietnamese Medical Queries

- [ ] **Testing Framework**
  - [ ] Create Vietnamese medical query test cases
  - [ ] Implement response quality assessment
  - [ ] Add performance benchmarking
  - [ ] Create regression testing for content updates

## Dependencies and Prerequisites

### External Dependencies

- [ ] **Confirm OpenAI API access** for embedding generation
- [ ] **Verify Milvus configuration** in Docker Compose
- [ ] **Assess Vietnamese NLP libraries** for medical term processing
- [ ] **Evaluate web scraping tools** (Puppeteer vs Playwright)

### Infrastructure Requirements

- [ ] **Database capacity planning** for knowledge storage
- [ ] **Vector database sizing** for Vietnamese content
- [ ] **Background job queue capacity** for crawler operations
- [ ] **Monitoring and alerting setup** for production deployment

### Compliance and Legal

- [ ] **Review robots.txt compliance** for target websites
- [ ] **Assess content licensing** for scraped medical information
- [ ] **Verify healthcare compliance** for medical content handling
- [ ] **Implement privacy protection** for user query logging

## Success Metrics and KPIs

### Technical Metrics

- [ ] **Crawling Success Rate**: Target >95%
- [ ] **Content Processing Accuracy**: Target >90%
- [ ] **Search Relevance Scores**: Target >85%
- [ ] **System Uptime and Reliability**: Target >99%

### Business Metrics

- [ ] **AI Assistant Response Quality**: Measured by user feedback
- [ ] **Vietnamese Medical Query Coverage**: Percentage of queries with relevant results
- [ ] **User Satisfaction**: Vietnamese-specific response quality ratings
- [ ] **Healthcare Provider Adoption**: Professional user engagement metrics

## Risk Mitigation

### Technical Risks

- [ ] **Website Anti-Crawling Measures**: Implement robust error handling and alternative sources
- [ ] **Vietnamese Language Processing Complexity**: Use multiple NLP approaches and validation
- [ ] **Content Quality Variability**: Implement multi-source validation and expert review
- [ ] **Performance Scalability**: Design for horizontal scaling and optimization

### Operational Risks

- [ ] **Source Availability Changes**: Monitor source status and maintain backup sources
- [ ] **Content Licensing Issues**: Implement fair use practices and source attribution
- [ ] **Medical Accuracy Concerns**: Establish expert review processes and disclaimers
- [ ] **Compliance Requirements**: Maintain healthcare data handling standards

---

**Document Status**: Implementation Ready
**Last Updated**: 2025-07-10
**Next Review**: Phase 1 Completion (3 weeks)
**Estimated Total Duration**: 8-12 weeks
**Resource Requirements**: 1-2 backend developers, Vietnamese medical consultant
