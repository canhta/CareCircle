# CareCircle AI Agent Configuration Templates

## Overview

This document provides ready-to-use configuration templates for deploying CareCircle's AI agent system across different environments (development, staging, production) with proper healthcare compliance settings.

## 1. Environment Configuration Templates

### 1.1 Development Environment (.env.development)

```bash
# =============================================================================
# CareCircle AI Agent - Development Configuration
# =============================================================================

# Node Environment
NODE_ENV=development
PORT=3001
LOG_LEVEL=debug

# AI Service Configuration
OPENAI_API_KEY=sk-your-development-openai-key
LANGCHAIN_API_KEY=your-langchain-api-key
LANGCHAIN_TRACING_V2=true
LANGCHAIN_CALLBACKS_BACKGROUND=true
LANGCHAIN_PROJECT=carecircle-ai-dev

# Database Configuration
DATABASE_URL=postgresql://carecircle_dev:dev_password@localhost:5432/carecircle_dev
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=dev_redis_password

# Vector Database (Milvus)
MILVUS_HOST=localhost
MILVUS_PORT=19530
MILVUS_USERNAME=milvus_dev
MILVUS_PASSWORD=dev_milvus_password

# Healthcare Compliance (Development - Relaxed)
HIPAA_AUDIT_ENABLED=true
PHI_DETECTION_ENABLED=true
PHI_ENCRYPTION_KEY=dev_phi_encryption_key_32_chars_long
AUDIT_LOG_LEVEL=debug
AUDIT_LOG_RETENTION_DAYS=30

# Cost Management (Development)
DEFAULT_MONTHLY_BUDGET=50.00
COST_ALERT_THRESHOLD=0.8
ENABLE_COST_OPTIMIZATION=true
COST_TRACKING_ENABLED=true

# Security (Development)
JWT_SECRET=dev_jwt_secret_key_for_development_only
ENCRYPTION_KEY=dev_encryption_key_32_characters_long
API_RATE_LIMIT=1000
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# Firebase Configuration
FIREBASE_PROJECT_ID=carecircle-dev
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-dev@carecircle-dev.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_DEV_PRIVATE_KEY\n-----END PRIVATE KEY-----\n"

# Monitoring (Development)
ENABLE_METRICS=true
METRICS_PORT=9090
HEALTH_CHECK_INTERVAL=30000

# Feature Flags (Development)
ENABLE_EMERGENCY_TRIAGE=true
ENABLE_MEDICATION_ASSISTANT=true
ENABLE_VOICE_PROCESSING=false
ENABLE_IMAGE_ANALYSIS=false
ENABLE_REAL_TIME_STREAMING=true

# Vietnamese Healthcare Data
ENABLE_VIETNAMESE_HEALTHCARE_DATA=true
VIETNAMESE_MEDICAL_TERMS_ENABLED=true
CRAWLER_INTEGRATION_ENABLED=false
```

### 1.2 Production Environment (.env.production)

```bash
# =============================================================================
# CareCircle AI Agent - Production Configuration
# =============================================================================

# Node Environment
NODE_ENV=production
PORT=3001
LOG_LEVEL=info

# AI Service Configuration
OPENAI_API_KEY=${OPENAI_API_KEY_SECRET}
LANGCHAIN_API_KEY=${LANGCHAIN_API_KEY_SECRET}
LANGCHAIN_TRACING_V2=true
LANGCHAIN_CALLBACKS_BACKGROUND=true
LANGCHAIN_PROJECT=carecircle-ai-prod

# Database Configuration (Use secrets in production)
DATABASE_URL=${DATABASE_URL_SECRET}
REDIS_URL=${REDIS_URL_SECRET}
REDIS_PASSWORD=${REDIS_PASSWORD_SECRET}

# Vector Database (Milvus)
MILVUS_HOST=milvus-standalone-service
MILVUS_PORT=19530
MILVUS_USERNAME=${MILVUS_USERNAME_SECRET}
MILVUS_PASSWORD=${MILVUS_PASSWORD_SECRET}

# Healthcare Compliance (Production - Strict)
HIPAA_AUDIT_ENABLED=true
PHI_DETECTION_ENABLED=true
PHI_ENCRYPTION_KEY=${PHI_ENCRYPTION_KEY_SECRET}
AUDIT_LOG_LEVEL=info
AUDIT_LOG_RETENTION_DAYS=2555  # 7 years for HIPAA compliance
COMPLIANCE_MONITORING_ENABLED=true
EMERGENCY_ESCALATION_ENABLED=true

# Cost Management (Production)
DEFAULT_MONTHLY_BUDGET=500.00
COST_ALERT_THRESHOLD=0.9
ENABLE_COST_OPTIMIZATION=true
COST_TRACKING_ENABLED=true
BUDGET_ENFORCEMENT_ENABLED=true

# Security (Production)
JWT_SECRET=${JWT_SECRET}
ENCRYPTION_KEY=${ENCRYPTION_KEY_SECRET}
API_RATE_LIMIT=100
CORS_ORIGINS=https://carecircle.app,https://app.carecircle.com
ENABLE_HTTPS_ONLY=true
SECURE_COOKIES=true

# Firebase Configuration (Production)
FIREBASE_PROJECT_ID=carecircle-prod
FIREBASE_CLIENT_EMAIL=${FIREBASE_CLIENT_EMAIL_SECRET}
FIREBASE_PRIVATE_KEY=${FIREBASE_PRIVATE_KEY_SECRET}

# Monitoring (Production)
ENABLE_METRICS=true
METRICS_PORT=9090
HEALTH_CHECK_INTERVAL=15000
PROMETHEUS_ENABLED=true
ALERTING_ENABLED=true

# Feature Flags (Production)
ENABLE_EMERGENCY_TRIAGE=true
ENABLE_MEDICATION_ASSISTANT=true
ENABLE_VOICE_PROCESSING=true
ENABLE_IMAGE_ANALYSIS=true
ENABLE_REAL_TIME_STREAMING=true

# Vietnamese Healthcare Data
ENABLE_VIETNAMESE_HEALTHCARE_DATA=true
VIETNAMESE_MEDICAL_TERMS_ENABLED=true
CRAWLER_INTEGRATION_ENABLED=true
```

## 2. Agent Configuration Templates

### 2.1 Healthcare Agent Configuration

```typescript
// config/agents.config.ts
export const healthcareAgentsConfig = {
  supervisor: {
    name: 'supervisor',
    model: 'gpt-4o',
    temperature: 0.1,
    maxTokens: 800,
    systemPrompt: `You are a healthcare AI supervisor managing specialized medical agents.
    Route queries to appropriate specialists based on medical context and urgency.
    ALWAYS prioritize patient safety and emergency situations.
    
    Available agents:
    - healthAdvisor: General health questions and wellness advice
    - medicationAssistant: Drug interactions and medication management
    - emergencyTriage: Urgent health situations and emergency protocols
    - dataInterpreter: Health metrics analysis and insights
    - careCoordinator: Family communication and care coordination
    
    Vietnamese healthcare context: Understand Vietnamese medical terms and cultural health practices.`,
    tools: [
      'transferToHealthAdvisor',
      'transferToMedicationAssistant',
      'transferToEmergencyTriage',
      'transferToDataInterpreter',
      'transferToCareCoordinator'
    ],
    complianceLevel: 'standard'
  },

  healthAdvisor: {
    name: 'healthAdvisor',
    model: 'gpt-3.5-turbo',
    temperature: 0.7,
    maxTokens: 1000,
    systemPrompt: `You are a knowledgeable healthcare advisor specializing in:
    - General health and wellness guidance
    - Symptom assessment and health education
    - Preventive care recommendations
    - Lifestyle and wellness coaching
    
    IMPORTANT: 
    - Always include medical disclaimers
    - Escalate emergencies immediately
    - Respect Vietnamese healthcare practices and cultural sensitivities
    - Use appropriate medical terminology for the user's education level`,
    tools: [
      'getHealthRecommendations',
      'analyzeSymptoms',
      'transferToEmergencyTriage',
      'transferToMedicationAssistant'
    ],
    complianceLevel: 'standard'
  },

  medicationAssistant: {
    name: 'medicationAssistant',
    model: 'gpt-4',
    temperature: 0.1,
    maxTokens: 1200,
    systemPrompt: `You are a medication management specialist with expertise in:
    - Drug interactions and contraindications
    - Dosage calculations and adjustments
    - Side effect analysis and management
    - Medication adherence support
    
    CRITICAL SAFETY REQUIREMENTS:
    - Always use the most current drug interaction databases
    - Escalate any serious interaction risks immediately
    - Consider Vietnamese traditional medicine interactions
    - Provide clear, actionable medication guidance`,
    tools: [
      'checkDrugInteractions',
      'calculateDosage',
      'analyzeSideEffects',
      'transferToEmergencyTriage'
    ],
    complianceLevel: 'phi_sensitive'
  },

  emergencyTriage: {
    name: 'emergencyTriage',
    model: 'gpt-4',
    temperature: 0.05,
    maxTokens: 1000,
    systemPrompt: `You are an emergency triage specialist with critical responsibilities:
    - Immediate assessment of health emergencies
    - Activation of emergency protocols
    - Coordination with emergency services
    - Patient safety is PARAMOUNT - err on the side of caution
    
    EMERGENCY PROTOCOLS:
    - Activate emergency services for life-threatening situations
    - Notify emergency contacts immediately
    - Provide clear, step-by-step emergency instructions
    - Consider Vietnamese emergency service protocols`,
    tools: [
      'assessUrgency',
      'triggerEmergencyProtocols',
      'notifyEmergencyContacts',
      'escalateToHealthcareProvider'
    ],
    complianceLevel: 'emergency'
  }
};
```

### 2.2 Model Selection Configuration

```typescript
// config/models.config.ts
export const modelSelectionConfig = {
  // Cost per 1K tokens (updated 2025 pricing)
  modelCosts: {
    'gpt-3.5-turbo': { input: 0.0015, output: 0.002 },
    'gpt-4': { input: 0.03, output: 0.06 },
    'gpt-4-turbo': { input: 0.01, output: 0.03 },
    'gpt-4o': { input: 0.005, output: 0.015 },
    'gpt-4o-mini': { input: 0.00015, output: 0.0006 }
  },

  // Healthcare-specific model matrix
  healthcareModelMatrix: {
    emergency: {
      simple: 'gpt-4o',
      moderate: 'gpt-4',
      complex: 'gpt-4',
      critical: 'gpt-4'
    },
    medication: {
      simple: 'gpt-3.5-turbo',
      moderate: 'gpt-4o',
      complex: 'gpt-4',
      critical: 'gpt-4'
    },
    general: {
      simple: 'gpt-3.5-turbo',
      moderate: 'gpt-3.5-turbo',
      complex: 'gpt-4o',
      critical: 'gpt-4'
    }
  },

  // Budget-based fallback rules
  budgetFallbackRules: {
    lowBudget: {
      threshold: 0.1, // 10% of monthly budget remaining
      fallbackModel: 'gpt-3.5-turbo',
      emergencyOverride: true // Still use GPT-4 for emergencies
    },
    mediumBudget: {
      threshold: 0.3,
      fallbackModel: 'gpt-4o',
      emergencyOverride: true
    }
  }
};
```

## 3. Docker Configuration Templates

### 3.1 Docker Compose for Development

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  agent-orchestrator:
    build:
      context: .
      dockerfile: Dockerfile.agent-orchestrator
      target: development
    container_name: carecircle-agent-orchestrator-dev
    environment:
      - NODE_ENV=development
      - PORT=3001
    env_file:
      - .env.development
    ports:
      - "3001:3001"
      - "9229:9229" # Debug port
    volumes:
      - ./src:/app/src
      - ./node_modules:/app/node_modules
    command: npm run start:dev
    depends_on:
      - redis-dev
      - postgres-dev
    networks:
      - carecircle-ai-dev

  redis-dev:
    image: redis:7-alpine
    container_name: carecircle-redis-dev
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_dev_data:/data
    networks:
      - carecircle-ai-dev

  postgres-dev:
    image: postgres:15-alpine
    container_name: carecircle-postgres-dev
    environment:
      POSTGRES_DB: carecircle_dev
      POSTGRES_USER: carecircle_dev
      POSTGRES_PASSWORD: dev_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_dev_data:/var/lib/postgresql/data
    networks:
      - carecircle-ai-dev

volumes:
  redis_dev_data:
  postgres_dev_data:

networks:
  carecircle-ai-dev:
    driver: bridge
```

### 3.2 Kubernetes ConfigMap Template

```yaml
# k8s/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: carecircle-ai-config
  namespace: carecircle-ai
data:
  # Agent Configuration
  agents.json: |
    {
      "supervisor": {
        "model": "gpt-4o",
        "temperature": 0.1,
        "maxTokens": 800,
        "complianceLevel": "standard"
      },
      "healthAdvisor": {
        "model": "gpt-3.5-turbo",
        "temperature": 0.7,
        "maxTokens": 1000,
        "complianceLevel": "standard"
      },
      "medicationAssistant": {
        "model": "gpt-4",
        "temperature": 0.1,
        "maxTokens": 1200,
        "complianceLevel": "phi_sensitive"
      },
      "emergencyTriage": {
        "model": "gpt-4",
        "temperature": 0.05,
        "maxTokens": 1000,
        "complianceLevel": "emergency"
      }
    }

  # Healthcare Configuration
  healthcare.json: |
    {
      "vietnameseHealthcareEnabled": true,
      "emergencyProtocolsEnabled": true,
      "phiDetectionEnabled": true,
      "auditLoggingEnabled": true,
      "complianceMonitoringEnabled": true
    }

  # Cost Management Configuration
  cost-management.json: |
    {
      "defaultMonthlyBudget": 500.00,
      "costAlertThreshold": 0.9,
      "budgetEnforcementEnabled": true,
      "costOptimizationEnabled": true
    }
```

## 4. Testing Configuration Templates

### 4.1 Jest Configuration for AI Agents

```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/test'],
  testMatch: [
    '**/__tests__/**/*.ts',
    '**/?(*.)+(spec|test).ts'
  ],
  transform: {
    '^.+\\.ts$': 'ts-jest'
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/main.ts'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/test/setup.ts'],
  testTimeout: 30000, // AI agent tests may take longer
  
  // Healthcare-specific test configuration
  globals: {
    'ts-jest': {
      tsconfig: 'tsconfig.json'
    }
  },
  
  // Mock external services for testing
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
};
```

### 4.2 Test Environment Configuration

```typescript
// test/setup.ts
import { ConfigService } from '@nestjs/config';

// Mock AI services for testing
jest.mock('@langchain/openai', () => ({
  ChatOpenAI: jest.fn().mockImplementation(() => ({
    invoke: jest.fn().mockResolvedValue({
      content: 'Mock AI response for testing'
    })
  }))
}));

// Mock Redis for testing
jest.mock('ioredis', () => {
  return jest.fn().mockImplementation(() => ({
    get: jest.fn(),
    set: jest.fn(),
    del: jest.fn(),
    exists: jest.fn()
  }));
});

// Healthcare test data
export const mockHealthcareData = {
  user: {
    id: 'test-user-123',
    healthProfile: {
      age: 35,
      gender: 'female',
      conditions: ['hypertension'],
      allergies: ['penicillin']
    }
  },
  medications: [
    {
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'daily'
    }
  ],
  emergencyContacts: [
    {
      name: 'John Doe',
      relationship: 'spouse',
      phone: '+1234567890'
    }
  ]
};
```

This configuration template provides a comprehensive setup for CareCircle's AI agent system across all environments while maintaining healthcare compliance and optimal performance.
