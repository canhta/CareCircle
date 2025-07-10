# Knowledge Management Context (KMC)

## Module Overview

The Knowledge Management Context is responsible for crawling, processing, and managing Vietnamese healthcare data sources to enhance the AI Assistant's capabilities with localized medical knowledge. This context implements a comprehensive RAG (Retrieval-Augmented Generation) system that integrates Vietnamese medical databases, government health policies, pharmaceutical information, and healthcare news.

### Responsibilities

- Vietnamese healthcare data source crawling and monitoring
- Medical content extraction, processing, and validation
- Vector database management for semantic search
- Knowledge base maintenance and quality assurance
- Content freshness tracking and automated updates
- Medical authority verification and source ranking
- Integration with AI Assistant for enhanced responses

### Role in Overall Architecture

The Knowledge Management Context serves as the knowledge foundation for the CareCircle platform's AI capabilities, specifically focusing on Vietnamese healthcare market adaptation. It consumes publicly available Vietnamese medical content and transforms it into searchable, validated knowledge that enhances the AI Assistant's ability to provide culturally appropriate and medically accurate guidance to Vietnamese users.

## Technical Specification

### Key Data Models and Interfaces

#### Domain Entities

1. **KnowledgeItem**

   ```typescript
   interface KnowledgeItem {
     id: string;
     title: string;
     content: string;
     originalUrl: string;
     sourceId: string;
     contentType: ContentType;
     medicalSpecialty: MedicalSpecialty[];
     language: Language;
     publishedAt: Date;
     lastVerified: Date;
     authorityScore: number; // 0-100
     qualityScore: number; // 0-100
     medicalEntities: MedicalEntity[];
     tags: string[];
     vectorId: string;
     status: ContentStatus;
     metadata: KnowledgeMetadata;
   }
   ```

2. **DataSource**

   ```typescript
   interface DataSource {
     id: string;
     name: string;
     baseUrl: string;
     sourceType: SourceType;
     authorityLevel: AuthorityLevel;
     crawlFrequency: CrawlFrequency;
     lastCrawled: Date;
     isActive: boolean;
     crawlConfig: CrawlConfiguration;
     accessMethod: AccessMethod;
     rateLimit: RateLimitConfig;
     contentSelectors: ContentSelector[];
   }
   ```

3. **CrawlJob**

   ```typescript
   interface CrawlJob {
     id: string;
     sourceId: string;
     jobType: CrawlJobType;
     status: JobStatus;
     scheduledAt: Date;
     startedAt?: Date;
     completedAt?: Date;
     itemsProcessed: number;
     itemsSuccessful: number;
     itemsFailed: number;
     errorLog: CrawlError[];
     metadata: CrawlJobMetadata;
   }
   ```

4. **MedicalEntity**

   ```typescript
   interface MedicalEntity {
     id: string;
     type: EntityType;
     vietnameseName: string;
     englishName?: string;
     aliases: string[];
     category: MedicalCategory;
     confidence: number;
     sourceReferences: string[];
   }
   ```

#### Value Objects

```typescript
enum ContentType {
  TREATMENT_GUIDELINE = "treatment_guideline",
  DRUG_INFORMATION = "drug_information",
  HEALTH_NEWS = "health_news",
  GOVERNMENT_POLICY = "government_policy",
  RESEARCH_PAPER = "research_paper",
  PATIENT_EDUCATION = "patient_education",
}

enum SourceType {
  GOVERNMENT_WEBSITE = "government_website",
  MEDICAL_INSTITUTION = "medical_institution",
  PHARMACEUTICAL_DATABASE = "pharmaceutical_database",
  NEWS_PORTAL = "news_portal",
  RESEARCH_JOURNAL = "research_journal",
  HEALTHCARE_PROVIDER = "healthcare_provider",
}

enum AuthorityLevel {
  GOVERNMENT_OFFICIAL = "government_official", // Ministry of Health
  MEDICAL_INSTITUTION = "medical_institution", // Hospitals, medical schools
  PROFESSIONAL_ASSOCIATION = "professional_association", // Medical associations
  COMMERCIAL_RELIABLE = "commercial_reliable", // Verified commercial sources
  COMMUNITY_VERIFIED = "community_verified", // Community-verified content
}

enum MedicalSpecialty {
  CARDIOLOGY = "cardiology",
  ENDOCRINOLOGY = "endocrinology",
  NEUROLOGY = "neurology",
  ONCOLOGY = "oncology",
  PEDIATRICS = "pediatrics",
  GERIATRICS = "geriatrics",
  EMERGENCY_MEDICINE = "emergency_medicine",
  GENERAL_PRACTICE = "general_practice",
  PHARMACY = "pharmacy",
  PUBLIC_HEALTH = "public_health",
}

enum Language {
  VIETNAMESE = "vi",
  ENGLISH = "en",
  MIXED = "mixed",
}

interface KnowledgeMetadata {
  extractionMethod: string;
  processingTime: number;
  contentHash: string;
  medicalValidation: {
    isValidated: boolean;
    validatedBy: string;
    validationDate: Date;
    validationNotes: string;
  };
  vietnameseNLP: {
    medicalTermsExtracted: number;
    entityRecognitionConfidence: number;
    languageQuality: number;
  };
}

interface CrawlConfiguration {
  maxDepth: number;
  followExternalLinks: boolean;
  respectRobotsTxt: boolean;
  userAgent: string;
  requestDelay: number;
  maxConcurrentRequests: number;
  contentFilters: ContentFilter[];
}

interface ContentSelector {
  name: string;
  selector: string;
  attribute?: string;
  required: boolean;
  postProcessing?: string[];
}
```

### Key APIs

#### Crawler Management API

```typescript
interface CrawlerService {
  // Source management
  addDataSource(source: Omit<DataSource, "id">): Promise<DataSource>;
  updateDataSource(sourceId: string, updates: Partial<DataSource>): Promise<DataSource>;
  getDataSources(filters?: SourceFilters): Promise<DataSource[]>;
  activateSource(sourceId: string): Promise<void>;
  deactivateSource(sourceId: string): Promise<void>;

  // Crawling operations
  scheduleCrawlJob(sourceId: string, jobType: CrawlJobType): Promise<CrawlJob>;
  executeCrawlJob(jobId: string): Promise<CrawlJobResult>;
  getCrawlJobs(filters?: JobFilters): Promise<CrawlJob[]>;
  cancelCrawlJob(jobId: string): Promise<void>;

  // Content processing
  processContent(rawContent: RawContent): Promise<KnowledgeItem>;
  validateMedicalContent(content: string): Promise<ValidationResult>;
  extractMedicalEntities(content: string): Promise<MedicalEntity[]>;
}
```

#### Knowledge Base API

```typescript
interface KnowledgeService {
  // Knowledge management
  addKnowledgeItem(item: Omit<KnowledgeItem, "id">): Promise<KnowledgeItem>;
  updateKnowledgeItem(itemId: string, updates: Partial<KnowledgeItem>): Promise<KnowledgeItem>;
  getKnowledgeItem(itemId: string): Promise<KnowledgeItem>;
  deleteKnowledgeItem(itemId: string): Promise<void>;

  // Search and retrieval
  searchKnowledge(query: SearchQuery): Promise<SearchResult[]>;
  semanticSearch(query: string, filters?: SearchFilters): Promise<KnowledgeItem[]>;
  hybridSearch(query: string, keywords: string[], filters?: SearchFilters): Promise<KnowledgeItem[]>;
  
  // Content validation
  verifyKnowledgeItem(itemId: string, verification: VerificationData): Promise<KnowledgeItem>;
  updateContentQuality(itemId: string, qualityMetrics: QualityMetrics): Promise<void>;
  
  // Analytics
  getKnowledgeStatistics(): Promise<KnowledgeStatistics>;
  getContentFreshness(specialty?: MedicalSpecialty): Promise<FreshnessReport>;
}
```

#### Vector Database API

```typescript
interface VectorDatabaseService {
  // Vector operations
  storeVector(vector: Vector, metadata: VectorMetadata): Promise<string>;
  searchSimilar(queryVector: Vector, filters?: VectorFilters, limit?: number): Promise<VectorSearchResult[]>;
  updateVector(vectorId: string, vector: Vector, metadata?: VectorMetadata): Promise<void>;
  deleteVector(vectorId: string): Promise<void>;

  // Collection management
  createCollection(name: string, schema: CollectionSchema): Promise<void>;
  getCollectionInfo(name: string): Promise<CollectionInfo>;
  optimizeCollection(name: string): Promise<void>;

  // Embedding generation
  generateEmbedding(text: string): Promise<Vector>;
  batchGenerateEmbeddings(texts: string[]): Promise<Vector[]>;
}
```

#### Vietnamese NLP API

```typescript
interface VietnameseNLPService {
  // Text processing
  normalizeVietnameseText(text: string): Promise<string>;
  extractMedicalTerms(text: string): Promise<MedicalTerm[]>;
  recognizeEntities(text: string): Promise<NamedEntity[]>;
  
  // Medical terminology
  expandAbbreviations(text: string): Promise<string>;
  mapSynonyms(term: string): Promise<string[]>;
  translateMedicalTerm(term: string, targetLanguage: Language): Promise<string>;
  
  // Content analysis
  assessContentQuality(text: string): Promise<QualityAssessment>;
  detectMedicalSpecialty(text: string): Promise<MedicalSpecialty[]>;
  extractDosageInformation(text: string): Promise<DosageInfo[]>;
}
```

### Dependencies and Interactions

- **AI Assistant Context**: Enhanced with Vietnamese medical knowledge for localized responses
- **Health Data Context**: Provides context for relevant medical content filtering
- **Identity & Access Context**: Authentication for crawler operations and content access
- **Notification Context**: Alerts for crawler status, content updates, and quality issues
- **Milvus Vector Database**: Semantic search and similarity matching
- **OpenAI API**: Embedding generation and content validation
- **Background Job Processing**: BullMQ for crawler scheduling and content processing

### Backend Implementation Notes

1. **Crawler Infrastructure**
   - Implement polite crawling with rate limiting and robots.txt compliance
   - Use Puppeteer/Playwright for dynamic content extraction
   - Implement content deduplication using hash-based detection
   - Create robust error handling and retry mechanisms

2. **Vietnamese Language Processing**
   - Integrate Vietnamese NLP libraries for text normalization
   - Build medical terminology dictionaries for entity recognition
   - Implement abbreviation expansion and synonym mapping
   - Create translation bridges between Vietnamese and English medical terms

3. **Content Quality Assurance**
   - Implement authority scoring based on source credibility
   - Create medical content validation against established standards
   - Build fact-checking mechanisms for medical accuracy
   - Implement content freshness tracking and update notifications

4. **Vector Database Integration**
   - Design optimal collection schemas for different content types
   - Implement efficient indexing strategies for Vietnamese text
   - Create hybrid search combining vector similarity and keyword matching
   - Optimize query performance for real-time AI Assistant integration

5. **Background Processing**
   - Schedule regular crawling jobs based on source update frequencies
   - Implement batch processing for large content volumes
   - Create monitoring and alerting for crawler performance
   - Build administrative interfaces for crawler management

## To-do Checklist

### Backend Tasks

- [ ] BE: Design and implement Knowledge Management domain models
- [ ] BE: Set up Milvus vector database service integration
- [ ] BE: Create web crawler service with rate limiting and robots.txt compliance
- [ ] BE: Implement Vietnamese NLP service for medical content processing
- [ ] BE: Build content extraction and cleaning pipelines
- [ ] BE: Create medical entity recognition for Vietnamese content
- [ ] BE: Implement vector embedding generation and storage
- [ ] BE: Set up background job processing for crawling tasks
- [ ] BE: Create content quality assessment and validation system
- [ ] BE: Implement source authority ranking and verification
- [ ] BE: Build administrative APIs for crawler management
- [ ] BE: Create monitoring and alerting for crawler operations
- [ ] BE: Implement content freshness tracking and update notifications
- [ ] BE: Build integration with AI Assistant for enhanced responses

### Integration Tasks

- [ ] Integration: Enhance AI Assistant with semantic search capabilities
- [ ] Integration: Implement hybrid search for Vietnamese medical queries
- [ ] Integration: Add source citation and authority ranking to AI responses
- [ ] Integration: Create medical content validation and quality scoring
- [ ] Integration: Integrate with existing health context building
- [ ] Integration: Implement Vietnamese emergency protocols and contacts
- [ ] Integration: Create culturally appropriate health advice generation

## References

### Libraries and Services

- **Milvus**: Vector database for semantic search and embeddings
  - Documentation: [Milvus Documentation](https://milvus.io/docs)
  - Features: High-performance similarity search, scalable vector indexing

- **Puppeteer**: Web scraping and automation
  - Documentation: [Puppeteer Documentation](https://pptr.dev/)
  - Features: Headless Chrome automation, dynamic content extraction

- **OpenAI Embeddings**: Text embedding generation
  - Documentation: [OpenAI Embeddings](https://platform.openai.com/docs/guides/embeddings)
  - Features: High-quality text embeddings for semantic search

- **Vietnamese NLP Libraries**: Text processing for Vietnamese language
  - **VnCoreNLP**: Vietnamese natural language processing toolkit
  - **pyvi**: Vietnamese word segmentation and POS tagging

### Vietnamese Healthcare Sources

- **Government Sources**:
  - Vietnam Ministry of Health (Bộ Y tế): Official health policies and guidelines
  - Infrastructure and Medical Device Administration (IMDA): Medical device regulations

- **Medical Databases**:
  - Vietnamese drug information databases
  - Clinical pharmacy guidelines and protocols
  - Medical research journals and publications

- **Healthcare Information Systems**:
  - Hospital Information Systems (HIS) in major Vietnamese hospitals
  - Electronic Medical Records (EMR) systems
  - Laboratory Information Systems (LIS)

## Logging Specifications

### Knowledge Management Context Logging

The Knowledge Management bounded context implements comprehensive logging for crawler operations, content processing, and quality assurance while maintaining healthcare privacy compliance.

**Logger Instance**: `BoundedContextLoggers.knowledgeManagement`

**Log Categories**:
- **Crawler Operations**: Source monitoring, content extraction, job scheduling
- **Content Processing**: Vietnamese NLP, entity recognition, quality assessment
- **Vector Operations**: Embedding generation, similarity search, index management
- **Quality Assurance**: Content validation, authority verification, freshness tracking
- **Performance Monitoring**: Processing times, success rates, error tracking

**Privacy Protection**:
- Medical content is anonymized before logging
- Source URLs are logged but content is sanitized
- User queries are hashed for privacy protection
- No patient-specific information is logged

**Critical Logging Points**:
1. **Crawler Operations**: Log crawling initiation, success/failure rates, content extraction
2. **Content Processing**: Log Vietnamese NLP processing, entity recognition accuracy
3. **Vector Operations**: Log embedding generation, search performance, index updates
4. **Quality Assurance**: Log content validation results, authority scoring, freshness checks
5. **Error Handling**: Comprehensive error logging with context preservation

---

**Last Updated**: 2025-07-10
**Status**: Design Phase - Ready for Implementation
**Next Milestone**: Phase 1 Foundation Implementation
