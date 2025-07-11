# CareCircle Vietnamese Healthcare Crawler

Production-ready Docker-based crawler system for Vietnamese healthcare websites with comprehensive NLP processing and vector database integration.

## Quick Start

```bash
cd crawlers
./setup.sh
```

## Production Crawling Guide

### 1. Configure Healthcare Sources

Edit `config/sources.json` to add Vietnamese healthcare websites:

```bash
docker-compose exec carecircle-crawler nano config/sources.json
```

**Supported Source Types:**
- **Hospitals**: Major Vietnamese hospital websites
- **Health Ministry**: Ministry of Health Vietnam official sites
- **Medical Journals**: Vietnamese medical research publications
- **Pharmaceutical**: Drug databases and medication information

### 2. Run Production Crawlers

```bash
# Crawl specific healthcare source
docker-compose exec carecircle-crawler python scripts/crawl_source.py [source-name] --limit 100

# Crawl all configured sources
docker-compose exec carecircle-crawler python scripts/crawl_all.py

# Hospital websites
docker-compose exec carecircle-crawler python scripts/crawl_source.py hospitals-vietnam

# Ministry of Health
docker-compose exec carecircle-crawler python scripts/crawl_source.py ministry-health-vn

# Medical journals
docker-compose exec carecircle-crawler python scripts/crawl_source.py medical-journals-vn
```

### 3. Automated Scheduling

Set up cron jobs for regular crawling:

```bash
# Daily crawl at 2 AM
0 2 * * * cd /path/to/crawlers && docker-compose exec carecircle-crawler python scripts/crawl_all.py

# Weekly full crawl on Sundays
0 1 * * 0 cd /path/to/crawlers && docker-compose exec carecircle-crawler python scripts/crawl_all.py --full-crawl
```

### 4. Production Monitoring

```bash
# Check crawler status
docker-compose exec carecircle-crawler python scripts/validate_sources.py

# Monitor logs
docker-compose logs -f carecircle-crawler

# Check output files
ls -la output/raw/ output/processed/
```

## Data Processing Guide

### 1. Vietnamese Healthcare Text Processing

Process crawled data with medical-specific Vietnamese NLP:

```bash
# Process raw crawled data
docker-compose exec carecircle-crawler python scripts/process_medical_text.py

# Clean and validate medical terminology
docker-compose exec carecircle-crawler python scripts/validate_medical_content.py

# Extract medical entities (diseases, medications, treatments)
docker-compose exec carecircle-crawler python scripts/extract_medical_entities.py
```

### 2. Data Quality Validation

Ensure healthcare data compliance and accuracy:

```bash
# Validate medical content accuracy
docker-compose exec carecircle-crawler python scripts/validate_medical_accuracy.py

# Check for duplicate content
docker-compose exec carecircle-crawler python scripts/deduplicate_content.py

# Verify source authenticity
docker-compose exec carecircle-crawler python scripts/verify_healthcare_sources.py
```

### 3. Vietnamese NLP Pipeline

**Medical Text Tokenization:**
```bash
# Advanced Vietnamese medical text processing
docker-compose exec carecircle-crawler python -c "
from src.utils.vietnamese_nlp import MedicalTextProcessor
processor = MedicalTextProcessor()
text = 'Bệnh nhân được chẩn đoán viêm phổi và được kê đơn thuốc kháng sinh'
result = processor.process_medical_text(text)
print(result)
"
```

**Healthcare Entity Extraction:**
- Medical conditions and diseases
- Medications and dosages
- Treatment procedures
- Healthcare facility information

### 4. Output Standardization

Standardize data format for healthcare compliance:

```bash
# Convert to healthcare-compliant JSON format
docker-compose exec carecircle-crawler python scripts/standardize_healthcare_data.py

# Generate medical terminology index
docker-compose exec carecircle-crawler python scripts/build_medical_index.py

# Create structured medical knowledge base
docker-compose exec carecircle-crawler python scripts/build_knowledge_base.py
```

## Vector Database Integration Guide

### 1. Configure Vector Database Connection

Set up connection to your vector database in `.env`:

```bash
# Copy environment template
cp .env.example .env

# Edit configuration
docker-compose exec carecircle-crawler nano .env
```

**Required Environment Variables:**
```env
# Vector Database Configuration
VECTOR_DB_HOST=your-vector-db-host
VECTOR_DB_PORT=5432
VECTOR_DB_NAME=carecircle_vectors
VECTOR_DB_USER=your-username
VECTOR_DB_PASSWORD=your-password

# Embedding Configuration
EMBEDDING_MODEL=sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2
EMBEDDING_DIMENSION=384
BATCH_SIZE=100

# Healthcare Compliance
HIPAA_COMPLIANCE=true
DATA_ENCRYPTION=true
AUDIT_LOGGING=true
```

### 2. Data Transformation Pipeline

Transform crawled healthcare data to vector embeddings:

```bash
# Generate embeddings for medical content
docker-compose exec carecircle-crawler python scripts/generate_medical_embeddings.py

# Create vector index for healthcare search
docker-compose exec carecircle-crawler python scripts/create_vector_index.py

# Optimize embeddings for medical terminology
docker-compose exec carecircle-crawler python scripts/optimize_medical_vectors.py
```

### 3. Batch Upload to Vector Database

Upload processed healthcare data to vector database:

```bash
# Upload daily crawled data
docker-compose exec carecircle-crawler python scripts/upload_to_vector_db.py --date today

# Upload specific healthcare domain
docker-compose exec carecircle-crawler python scripts/upload_to_vector_db.py --domain hospitals

# Full database sync
docker-compose exec carecircle-crawler python scripts/sync_vector_database.py --full
```

### 4. Production Monitoring & Verification

Monitor vector database operations:

```bash
# Verify upload success
docker-compose exec carecircle-crawler python scripts/verify_vector_uploads.py

# Check vector database health
docker-compose exec carecircle-crawler python scripts/check_vector_db_health.py

# Generate upload reports
docker-compose exec carecircle-crawler python scripts/generate_upload_reports.py

# Monitor embedding quality
docker-compose exec carecircle-crawler python scripts/monitor_embedding_quality.py
```

### 5. Healthcare Compliance Verification

Ensure data handling meets healthcare standards:

```bash
# HIPAA compliance check
docker-compose exec carecircle-crawler python scripts/verify_hipaa_compliance.py

# Data encryption verification
docker-compose exec carecircle-crawler python scripts/verify_data_encryption.py

# Audit trail generation
docker-compose exec carecircle-crawler python scripts/generate_audit_trail.py
```

## Production Configuration

### 1. Environment Setup

Configure production environment variables:

```bash
cp .env.example .env
```

**Production Environment Variables:**
```env
# Backend API Configuration
CARECIRCLE_API_URL=https://api.carecircle.com
FIREBASE_JWT_TOKEN=your-production-jwt-token

# Vector Database Configuration
VECTOR_DB_HOST=your-vector-db-host
VECTOR_DB_PORT=5432
VECTOR_DB_NAME=carecircle_vectors
VECTOR_DB_USER=your-username
VECTOR_DB_PASSWORD=your-password

# Healthcare Compliance
HIPAA_COMPLIANCE=true
DATA_ENCRYPTION=true
AUDIT_LOGGING=true

# Crawling Configuration
MAX_CONCURRENT_CRAWLS=5
CRAWL_DELAY_SECONDS=2
RETRY_ATTEMPTS=3
TIMEOUT_SECONDS=30
```

### 2. Healthcare Sources Configuration

Configure Vietnamese healthcare websites in `config/sources.json`:

```json
{
  "hospitals": {
    "bach-mai-hospital": {
      "url": "https://benhvienbachmai.gov.vn",
      "type": "hospital",
      "priority": "high",
      "crawl_frequency": "daily"
    },
    "cho-ray-hospital": {
      "url": "https://choray.vn",
      "type": "hospital",
      "priority": "high",
      "crawl_frequency": "daily"
    }
  },
  "government": {
    "ministry-health": {
      "url": "https://moh.gov.vn",
      "type": "government",
      "priority": "critical",
      "crawl_frequency": "hourly"
    }
  },
  "medical-journals": {
    "vietnam-medical-journal": {
      "url": "https://tapchiyduoc.org",
      "type": "journal",
      "priority": "medium",
      "crawl_frequency": "weekly"
    }
  }
}
```

### 3. Production Deployment

Deploy crawler system for production use:

```bash
# Build production image
docker build -t carecircle-crawler:production .

# Start production services
docker-compose -f docker-compose.prod.yml up -d

# Verify production deployment
docker-compose exec carecircle-crawler python scripts/health_check.py
```

### 4. Error Handling & Recovery

Production error handling and recovery procedures:

```bash
# Check crawler health
docker-compose exec carecircle-crawler python scripts/check_crawler_health.py

# Restart failed crawlers
docker-compose exec carecircle-crawler python scripts/restart_failed_crawlers.py

# Generate error reports
docker-compose exec carecircle-crawler python scripts/generate_error_reports.py

# Backup crawled data
docker-compose exec carecircle-crawler python scripts/backup_crawled_data.py
```

## Production Operations

### Scalability Configuration

Configure crawler system for high-volume production use:

```bash
# Scale crawler instances
docker-compose up --scale carecircle-crawler=3

# Configure load balancing
docker-compose exec carecircle-crawler python scripts/configure_load_balancer.py

# Set up distributed crawling
docker-compose exec carecircle-crawler python scripts/setup_distributed_crawling.py
```

### Performance Optimization

Optimize crawler performance for production workloads:

```bash
# Optimize database connections
docker-compose exec carecircle-crawler python scripts/optimize_db_connections.py

# Configure memory usage
docker-compose exec carecircle-crawler python scripts/configure_memory_limits.py

# Set up caching layer
docker-compose exec carecircle-crawler python scripts/setup_redis_cache.py
```

### Security & Compliance

Ensure healthcare data security and compliance:

```bash
# Enable data encryption
docker-compose exec carecircle-crawler python scripts/enable_data_encryption.py

# Configure access controls
docker-compose exec carecircle-crawler python scripts/configure_access_controls.py

# Set up audit logging
docker-compose exec carecircle-crawler python scripts/setup_audit_logging.py

# HIPAA compliance check
docker-compose exec carecircle-crawler python scripts/verify_hipaa_compliance.py
```

## Production Maintenance

### System Health Monitoring

Monitor crawler system health and performance:

```bash
# System health dashboard
docker-compose exec carecircle-crawler python scripts/health_dashboard.py

# Performance metrics
docker-compose exec carecircle-crawler python scripts/performance_metrics.py

# Resource utilization monitoring
docker-compose exec carecircle-crawler python scripts/monitor_resources.py
```

### Backup & Recovery

Production backup and disaster recovery procedures:

```bash
# Backup crawled data
docker-compose exec carecircle-crawler python scripts/backup_production_data.py

# Backup vector database
docker-compose exec carecircle-crawler python scripts/backup_vector_database.py

# Disaster recovery
docker-compose exec carecircle-crawler python scripts/disaster_recovery.py

# Data integrity verification
docker-compose exec carecircle-crawler python scripts/verify_data_integrity.py
```

### Production Troubleshooting

Resolve production issues efficiently:

```bash
# Diagnose system issues
docker-compose exec carecircle-crawler python scripts/diagnose_system_issues.py

# Fix corrupted data
docker-compose exec carecircle-crawler python scripts/fix_corrupted_data.py

# Restart failed services
docker-compose exec carecircle-crawler python scripts/restart_failed_services.py

# Emergency shutdown
docker-compose exec carecircle-crawler python scripts/emergency_shutdown.py
```

## Healthcare Compliance

### HIPAA Compliance

Ensure healthcare data handling meets HIPAA requirements:

- **Data Encryption**: All healthcare data encrypted at rest and in transit
- **Access Controls**: Role-based access to sensitive medical information
- **Audit Logging**: Complete audit trail of all data access and modifications
- **Data Retention**: Automated data retention and secure deletion policies

### Data Quality Standards

Maintain high-quality healthcare data:

- **Medical Terminology Validation**: Verify medical terms against standard vocabularies
- **Source Authenticity**: Validate healthcare source credibility and authority
- **Content Accuracy**: Cross-reference medical information for accuracy
- **Compliance Monitoring**: Continuous monitoring for regulatory compliance

### Security Measures

Production security implementation:

- **Network Security**: VPN and firewall protection for crawler infrastructure
- **Authentication**: Multi-factor authentication for system access
- **Data Sanitization**: Remove PII and sensitive information from crawled data
- **Incident Response**: Automated incident detection and response procedures
