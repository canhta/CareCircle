# CareCircle AI Agent Docker Containerization Guide

## Overview

This guide provides comprehensive Docker containerization for CareCircle's multi-agent AI system, ensuring HIPAA compliance, security hardening, and production-ready deployment. The containerized architecture supports horizontal scaling, secure inter-service communication, and healthcare data protection.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    CareCircle AI Agent Stack                    │
├─────────────────────────────────────────────────────────────────┤
│  AI Agent Services (Docker Containers)                         │
│  ├── Agent Orchestrator Service                                │
│  ├── Healthcare Agents Service                                 │
│  ├── Vector Database Service (Milvus)                          │
│  ├── Redis Memory Store                                        │
│  └── Compliance & Audit Service                                │
├─────────────────────────────────────────────────────────────────┤
│  Existing CareCircle Infrastructure                            │
│  ├── NestJS Backend                                            │
│  ├── PostgreSQL + TimescaleDB                                  │
│  ├── Firebase Authentication                                   │
│  └── Flutter Mobile App                                        │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Docker Services Configuration

### 1.1 AI Agent Orchestrator Service

**Dockerfile.agent-orchestrator**
```dockerfile
# Multi-stage build for production optimization
FROM node:22-alpine AS builder

# Security: Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S carecircle -u 1001

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies with security audit
RUN npm ci --only=production && \
    npm audit --audit-level high

# Copy source code
COPY src/ ./src/

# Build TypeScript
RUN npm run build

# Production stage
FROM node:22-alpine AS production

# Security hardening
RUN apk --no-cache add dumb-init && \
    addgroup -g 1001 -S nodejs && \
    adduser -S carecircle -u 1001

WORKDIR /app

# Copy built application
COPY --from=builder --chown=carecircle:nodejs /app/dist ./dist
COPY --from=builder --chown=carecircle:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=carecircle:nodejs /app/package.json ./

# Healthcare compliance: Secure file permissions
RUN chmod -R 750 /app && \
    chown -R carecircle:nodejs /app

# Health check for container orchestration
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD node dist/health-check.js

USER carecircle

EXPOSE 3001

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/main.js"]
```

### 1.2 Healthcare Agents Service

**Dockerfile.healthcare-agents**
```dockerfile
FROM node:22-alpine AS builder

# Install Python for healthcare NLP libraries
RUN apk add --no-cache python3 py3-pip build-base

WORKDIR /app

# Copy and install Node.js dependencies
COPY package*.json ./
RUN npm ci --only=production

# Install healthcare-specific Python dependencies
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/ ./src/
RUN npm run build

# Production stage
FROM node:22-alpine AS production

# Install Python runtime
RUN apk --no-cache add python3 py3-pip dumb-init && \
    addgroup -g 1001 -S nodejs && \
    adduser -S carecircle -u 1001

WORKDIR /app

# Copy application and dependencies
COPY --from=builder --chown=carecircle:nodejs /app/dist ./dist
COPY --from=builder --chown=carecircle:nodejs /app/node_modules ./node_modules
COPY --from=builder /usr/lib/python3.*/site-packages /usr/lib/python3.11/site-packages

# HIPAA compliance: Secure configuration
RUN chmod -R 750 /app && \
    chown -R carecircle:nodejs /app

# Healthcare data encryption keys (mounted as secrets)
VOLUME ["/app/secrets"]

USER carecircle
EXPOSE 3002

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/healthcare-agents.js"]
```

### 1.3 Vector Database Service (Milvus)

**docker-compose.milvus.yml**
```yaml
version: '3.8'

services:
  milvus-etcd:
    container_name: carecircle-milvus-etcd
    image: quay.io/coreos/etcd:v3.5.5
    environment:
      - ETCD_AUTO_COMPACTION_MODE=revision
      - ETCD_AUTO_COMPACTION_RETENTION=1000
      - ETCD_QUOTA_BACKEND_BYTES=4294967296
      - ETCD_SNAPSHOT_COUNT=50000
    volumes:
      - milvus_etcd_data:/etcd
    command: etcd -advertise-client-urls=http://127.0.0.1:2379 -listen-client-urls http://0.0.0.0:2379 --data-dir /etcd
    healthcheck:
      test: ["CMD", "etcdctl", "endpoint", "health"]
      interval: 30s
      timeout: 20s
      retries: 3

  milvus-minio:
    container_name: carecircle-milvus-minio
    image: minio/minio:RELEASE.2023-03-20T20-16-18Z
    environment:
      MINIO_ACCESS_KEY: ${MILVUS_MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MILVUS_MINIO_SECRET_KEY}
    ports:
      - "9001:9001"
      - "9000:9000"
    volumes:
      - milvus_minio_data:/minio_data
    command: minio server /minio_data --console-address ":9001"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 20s
      retries: 3

  milvus-standalone:
    container_name: carecircle-milvus-standalone
    image: milvusdb/milvus:v2.3.3
    command: ["milvus", "run", "standalone"]
    security_opt:
      - seccomp:unconfined
    environment:
      ETCD_ENDPOINTS: milvus-etcd:2379
      MINIO_ADDRESS: milvus-minio:9000
    volumes:
      - milvus_data:/var/lib/milvus
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9091/healthz"]
      interval: 30s
      start_period: 90s
      timeout: 20s
      retries: 3
    ports:
      - "19530:19530"
      - "9091:9091"
    depends_on:
      - "milvus-etcd"
      - "milvus-minio"

volumes:
  milvus_etcd_data:
    driver: local
  milvus_minio_data:
    driver: local
  milvus_data:
    driver: local

networks:
  default:
    name: carecircle-ai-network
```

## 2. Main Docker Compose Configuration

**docker-compose.ai-agents.yml**
```yaml
version: '3.8'

services:
  # AI Agent Orchestrator
  agent-orchestrator:
    build:
      context: .
      dockerfile: Dockerfile.agent-orchestrator
    container_name: carecircle-agent-orchestrator
    environment:
      - NODE_ENV=production
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - LANGCHAIN_API_KEY=${LANGCHAIN_API_KEY}
      - LANGCHAIN_TRACING_V2=true
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=${DATABASE_URL}
      - MILVUS_HOST=milvus-standalone
      - MILVUS_PORT=19530
    ports:
      - "3001:3001"
    depends_on:
      redis:
        condition: service_healthy
      milvus-standalone:
        condition: service_healthy
    networks:
      - carecircle-ai-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'

  # Healthcare Agents Service
  healthcare-agents:
    build:
      context: .
      dockerfile: Dockerfile.healthcare-agents
    container_name: carecircle-healthcare-agents
    environment:
      - NODE_ENV=production
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=${DATABASE_URL}
    ports:
      - "3002:3002"
    volumes:
      - healthcare_secrets:/app/secrets:ro
    depends_on:
      - redis
      - agent-orchestrator
    networks:
      - carecircle-ai-network
    restart: unless-stopped

  # Redis for session management and caching
  redis:
    image: redis:7-alpine
    container_name: carecircle-redis
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    environment:
      - REDIS_PASSWORD=${REDIS_PASSWORD}
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
    networks:
      - carecircle-ai-network
    restart: unless-stopped

  # Compliance and Audit Service
  compliance-audit:
    build:
      context: .
      dockerfile: Dockerfile.compliance
    container_name: carecircle-compliance-audit
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - AUDIT_LOG_LEVEL=info
    volumes:
      - audit_logs:/app/logs
      - healthcare_secrets:/app/secrets:ro
    depends_on:
      - agent-orchestrator
    networks:
      - carecircle-ai-network
    restart: unless-stopped

volumes:
  redis_data:
    driver: local
  audit_logs:
    driver: local
  healthcare_secrets:
    external: true

networks:
  carecircle-ai-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

secrets:
  openai_api_key:
    external: true
  langchain_api_key:
    external: true
  redis_password:
    external: true
```

## 3. Environment Configuration

**ai-agents.env**
```bash
# AI Configuration
OPENAI_API_KEY=your_openai_api_key
LANGCHAIN_API_KEY=your_langchain_api_key
LANGCHAIN_TRACING_V2=true
LANGCHAIN_CALLBACKS_BACKGROUND=true

# Redis Configuration
REDIS_URL=redis://redis:6379
REDIS_PASSWORD=your_secure_redis_password

# Vector Database Configuration
MILVUS_HOST=milvus-standalone
MILVUS_PORT=19530
MILVUS_USERNAME=your_milvus_username
MILVUS_PASSWORD=your_milvus_password
MILVUS_MINIO_ACCESS_KEY=your_minio_access_key
MILVUS_MINIO_SECRET_KEY=your_minio_secret_key

# Database Configuration
DATABASE_URL=postgresql://username:password@postgres:5432/carecircle

# Healthcare Compliance
HIPAA_AUDIT_ENABLED=true
PHI_ENCRYPTION_KEY=your_phi_encryption_key
AUDIT_LOG_RETENTION_DAYS=2555  # 7 years for HIPAA compliance

# Cost Management
DEFAULT_MONTHLY_BUDGET=100.00
COST_ALERT_THRESHOLD=0.8
ENABLE_COST_OPTIMIZATION=true

# Security
JWT_SECRET=your_jwt_secret
ENCRYPTION_KEY=your_encryption_key
API_RATE_LIMIT=100  # requests per minute

# Monitoring
ENABLE_METRICS=true
METRICS_PORT=9090
LOG_LEVEL=info
```

## 4. Healthcare Security & Compliance

### 4.1 HIPAA-Compliant Container Security

**security-hardening.sh**
```bash
#!/bin/bash
# CareCircle AI Agent Security Hardening Script

set -euo pipefail

echo "🔒 Applying HIPAA-compliant security hardening..."

# 1. Create secure secrets
docker secret create openai_api_key openai_key.txt
docker secret create langchain_api_key langchain_key.txt
docker secret create redis_password redis_pass.txt
docker secret create phi_encryption_key phi_key.txt

# 2. Set up encrypted volumes for PHI data
docker volume create --driver local \
  --opt type=tmpfs \
  --opt device=tmpfs \
  --opt o=size=1g,uid=1001,gid=1001,mode=0700 \
  healthcare_secrets

# 3. Configure network security
docker network create --driver bridge \
  --subnet=172.20.0.0/16 \
  --opt com.docker.network.bridge.enable_icc=false \
  --opt com.docker.network.bridge.enable_ip_masquerade=true \
  carecircle-ai-network

# 4. Set up audit logging
mkdir -p /var/log/carecircle-ai
chmod 750 /var/log/carecircle-ai
chown root:docker /var/log/carecircle-ai

echo "✅ Security hardening completed"
```

### 4.2 PHI Data Protection

**Dockerfile.compliance**
```dockerfile
FROM node:22-alpine AS production

# Security: Install security updates
RUN apk --no-cache upgrade && \
    apk --no-cache add dumb-init openssl && \
    addgroup -g 1001 -S nodejs && \
    adduser -S carecircle -u 1001

WORKDIR /app

# Copy compliance service
COPY --chown=carecircle:nodejs compliance/ ./
COPY --chown=carecircle:nodejs package*.json ./

# Install dependencies with security audit
RUN npm ci --only=production && \
    npm audit --audit-level high

# HIPAA compliance: Secure file permissions
RUN chmod -R 750 /app && \
    chown -R carecircle:nodejs /app

# Create secure directories for PHI handling
RUN mkdir -p /app/logs /app/temp && \
    chmod 700 /app/logs /app/temp && \
    chown carecircle:nodejs /app/logs /app/temp

USER carecircle

# Health check for compliance monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD node health-check.js

EXPOSE 3003

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "compliance-service.js"]
```

## 5. Deployment Commands

### 5.1 Development Deployment
```bash
# 1. Clone and setup
git clone https://github.com/canhta/CareCircle.git
cd CareCircle

# 2. Create environment file
cp docs/agent/ai-agents.env.example .env

# 3. Apply security hardening
chmod +x docs/agent/security-hardening.sh
./docs/agent/security-hardening.sh

# 4. Start AI agent services
docker-compose -f docker-compose.ai-agents.yml up -d

# 5. Start vector database
docker-compose -f docker-compose.milvus.yml up -d

# 6. Verify deployment
docker-compose ps
docker logs carecircle-agent-orchestrator
```

### 5.2 Production Deployment
```bash
# 1. Production environment setup
export NODE_ENV=production
export DOCKER_BUILDKIT=1

# 2. Build production images
docker-compose -f docker-compose.ai-agents.yml build --no-cache

# 3. Deploy with health checks
docker-compose -f docker-compose.ai-agents.yml up -d --wait

# 4. Verify HIPAA compliance
docker exec carecircle-compliance-audit node compliance-check.js

# 5. Monitor deployment
docker stats
docker-compose logs -f
```

## 6. Monitoring & Observability

### 6.1 Health Checks
```bash
# Agent orchestrator health
curl http://localhost:3001/health

# Healthcare agents health
curl http://localhost:3002/health

# Redis health
docker exec carecircle-redis redis-cli ping

# Milvus health
curl http://localhost:9091/healthz
```

### 6.2 Log Aggregation
```yaml
# docker-compose.logging.yml
version: '3.8'

services:
  fluentd:
    image: fluent/fluentd:v1.16-debian-1
    container_name: carecircle-fluentd
    volumes:
      - ./fluentd/conf:/fluentd/etc
      - /var/log/carecircle-ai:/var/log/carecircle-ai:ro
    ports:
      - "24224:24224"
    networks:
      - carecircle-ai-network

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    container_name: carecircle-elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    networks:
      - carecircle-ai-network

volumes:
  elasticsearch_data:
    driver: local
```

## 7. Backup & Recovery

### 7.1 Data Backup Strategy
```bash
#!/bin/bash
# backup-ai-data.sh

# Backup Redis data
docker exec carecircle-redis redis-cli BGSAVE
docker cp carecircle-redis:/data/dump.rdb ./backups/redis-$(date +%Y%m%d).rdb

# Backup Milvus data
docker exec carecircle-milvus-standalone tar -czf /tmp/milvus-backup.tar.gz /var/lib/milvus
docker cp carecircle-milvus-standalone:/tmp/milvus-backup.tar.gz ./backups/milvus-$(date +%Y%m%d).tar.gz

# Backup audit logs (HIPAA requirement)
docker cp carecircle-compliance-audit:/app/logs ./backups/audit-logs-$(date +%Y%m%d)

echo "✅ AI agent data backup completed"
```

This containerization guide provides a production-ready, HIPAA-compliant deployment strategy for CareCircle's AI agent system with comprehensive security, monitoring, and compliance measures.
```
