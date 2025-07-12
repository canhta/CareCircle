# Vietnamese Healthcare Multi-Agent API Documentation

## Overview

The CareCircle Vietnamese Healthcare Multi-Agent System provides comprehensive AI-powered healthcare assistance specifically designed for Vietnamese users. It integrates traditional Vietnamese medicine (thuốc nam) with modern medical knowledge, cultural context awareness, and HIPAA-compliant PHI protection.

## Base URL

```
http://localhost:3001/api/v1/ai-assistant/vietnamese-healthcare
```

## Authentication

All endpoints require Firebase authentication. Include the Firebase ID token in the Authorization header:

```
Authorization: Bearer <firebase_id_token>
```

## Endpoints

### 1. Vietnamese Healthcare Chat

**POST** `/chat`

Process Vietnamese healthcare queries with cultural context and traditional medicine integration.

#### Request Body

```json
{
  "message": "Tôi bị đau đầu và sốt, có thuốc nam nào không?",
  "culturalContext": "mixed",
  "languagePreference": "vietnamese",
  "medicalHistory": ["cao huyết áp"],
  "currentMedications": ["thuốc hạ áp"],
  "allergies": ["penicillin"],
  "urgentQuery": false
}
```

#### Parameters

- `message` (required): The healthcare query in Vietnamese or English
- `culturalContext` (optional): `"traditional"`, `"modern"`, or `"mixed"`
- `languagePreference` (optional): `"vietnamese"`, `"english"`, or `"mixed"`
- `medicalHistory` (optional): Array of medical conditions
- `currentMedications` (optional): Array of current medications
- `allergies` (optional): Array of known allergies
- `urgentQuery` (optional): Boolean indicating if this is an urgent query

#### Response

```json
{
  "success": true,
  "data": {
    "response": "Đối với triệu chứng đau đầu và sốt, bạn có thể...",
    "responseLanguage": "vietnamese",
    "traditionalMedicineAdvice": "Y học cổ truyền khuyên dùng...",
    "modernMedicineAdvice": "Y học hiện đại khuyên...",
    "culturalConsiderations": [
      "Tôn trọng truyền thống y học cổ truyền của gia đình",
      "Cân bằng giữa y học cổ truyền và hiện đại"
    ],
    "recommendedActions": [
      "Theo dõi triệu chứng trong vài ngày",
      "Đi khám nếu triệu chứng không cải thiện"
    ],
    "urgencyLevel": 0.3,
    "confidence": 0.85,
    "requiresPhysicianReview": false,
    "metadata": {
      "agentType": "VIETNAMESE_MEDICAL",
      "processingTime": 1640995200000,
      "culturalContext": "mixed",
      "languagePreference": "vietnamese"
    }
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 2. Search Vietnamese Medical Knowledge

**POST** `/search-knowledge`

Search the Vietnamese medical knowledge base for relevant information.

#### Request Body

```json
{
  "query": "đau đầu",
  "language": "vietnamese",
  "medicalSpecialty": "nội khoa",
  "documentTypes": ["article", "guideline"],
  "topK": 10
}
```

#### Parameters

- `query` (required): Search query in Vietnamese or English
- `language` (optional): `"vietnamese"`, `"english"`, or `"mixed"`
- `medicalSpecialty` (optional): Medical specialty filter
- `documentTypes` (optional): Array of document types to search
- `topK` (optional): Number of results to return (default: 10)

#### Response

```json
{
  "success": true,
  "data": {
    "results": [
      {
        "id": "vinmec_abc123_xyz789",
        "title": "Nguyên nhân và cách điều trị đau đầu",
        "content": "Đau đầu là triệu chứng phổ biến...",
        "source": "vinmec",
        "medicalSpecialty": "nội khoa",
        "documentType": "article",
        "score": 0.92,
        "keywords": ["đau đầu", "triệu chứng", "điều trị"]
      }
    ],
    "totalResults": 5,
    "query": "đau đầu"
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 3. Crawl Vietnamese Healthcare Sites

**POST** `/crawl`

Initiate crawling of Vietnamese healthcare websites to update the knowledge base.

#### Request Body

```json
{
  "sites": ["vinmec", "bachmai", "moh"],
  "forceRefresh": true
}
```

#### Parameters

- `sites` (optional): Array of specific sites to crawl
- `forceRefresh` (optional): Force refresh of existing content

#### Response

```json
{
  "success": true,
  "data": {
    "crawlResults": [
      {
        "siteId": "hospital_vinmec_hospital",
        "siteName": "Vinmec Hospital",
        "documentsProcessed": 150,
        "documentsStored": 142,
        "errors": [],
        "crawlTime": 45000,
        "lastCrawled": "2024-01-01T00:00:00.000Z"
      }
    ],
    "totalSites": 5,
    "totalDocuments": 650,
    "crawlTime": 180000
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 4. Get System Status

**GET** `/status`

Get the current status of the Vietnamese healthcare system.

#### Response

```json
{
  "success": true,
  "data": {
    "services": {
      "vietnameseMedicalAgent": {
        "status": "active",
        "capabilities": [
          "vietnamese_consultation",
          "traditional_medicine",
          "cultural_context"
        ]
      },
      "firecrawlService": {
        "service": "firecrawl-vietnamese-healthcare",
        "status": "active",
        "sitesConfigured": 5,
        "lastCrawl": "2024-01-01T00:00:00.000Z"
      },
      "vectorDatabase": {
        "status": "active",
        "stats": {
          "totalDocuments": 1250,
          "collections": 1
        }
      }
    },
    "features": {
      "vietnameseLanguageSupport": true,
      "traditionalMedicineIntegration": true,
      "culturalContextAwareness": true,
      "phiProtection": true,
      "knowledgeBaseSearch": true,
      "emergencyDetection": true
    }
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 5. Get Knowledge Base Statistics

**GET** `/knowledge-stats`

Get statistics about the Vietnamese medical knowledge base.

#### Response

```json
{
  "success": true,
  "data": {
    "collectionStats": {
      "totalDocuments": 1250,
      "totalSize": "50MB",
      "lastUpdated": "2024-01-01T00:00:00.000Z"
    },
    "supportedLanguages": ["vietnamese", "english", "mixed"],
    "supportedSources": [
      "vinmec",
      "bachmai",
      "moh",
      "traditional_medicine",
      "pharmaceutical"
    ],
    "documentTypes": [
      "article",
      "guideline",
      "research",
      "traditional_recipe",
      "drug_info"
    ]
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 6. Get Crawl Status

**GET** `/crawl-status`

Get the status of the last crawl operation.

#### Response

```json
{
  "success": true,
  "data": {
    "service": "firecrawl-vietnamese-healthcare",
    "status": "active",
    "sitesConfigured": 5,
    "lastCrawl": "2024-01-01T00:00:00.000Z"
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Error Responses

All endpoints return standardized error responses:

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Message is required",
    "details": {}
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Usage Examples

### Basic Vietnamese Healthcare Query

```bash
curl -X POST http://localhost:3001/api/v1/ai-assistant/vietnamese-healthcare/chat \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Tôi bị đau đầu và sốt, có thuốc gì không?",
    "culturalContext": "mixed",
    "languagePreference": "vietnamese"
  }'
```

### Emergency Query

```bash
curl -X POST http://localhost:3001/api/v1/ai-assistant/vietnamese-healthcare/chat \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Cấp cứu! Tôi bị đau tim dữ dội!",
    "urgentQuery": true
  }'
```

### Traditional Medicine Query

```bash
curl -X POST http://localhost:3001/api/v1/ai-assistant/vietnamese-healthcare/chat \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Có bài thuốc nam nào chữa ho không?",
    "culturalContext": "traditional"
  }'
```

### Search Medical Knowledge

```bash
curl -X POST http://localhost:3001/api/v1/ai-assistant/vietnamese-healthcare/search-knowledge \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "cao huyết áp",
    "language": "vietnamese",
    "topK": 5
  }'
```

## Features

### Vietnamese Language Support

- Native Vietnamese medical terminology processing
- Automatic language detection and response matching
- Support for mixed Vietnamese-English queries

### Traditional Medicine Integration

- Vietnamese traditional medicine (thuốc nam) knowledge base
- Cultural context awareness for healthcare decisions
- Integration of traditional and modern medical approaches

### PHI Protection

- HIPAA-compliant detection of 18 standard identifiers
- Vietnamese-specific PHI patterns (ID cards, insurance cards)
- Real-time masking and risk assessment

### Emergency Detection

- Vietnamese emergency keyword recognition
- Urgency level assessment and escalation
- Cultural considerations for emergency care

### Knowledge Base

- Comprehensive Vietnamese healthcare website crawling
- Vector-based semantic search
- Multi-source medical information integration

## Rate Limits

- Chat queries: 60 requests per minute per user
- Knowledge search: 100 requests per minute per user
- Crawl operations: 5 requests per hour per user
- Status endpoints: 200 requests per minute per user

## Support

For technical support or questions about the Vietnamese Healthcare Multi-Agent API, please contact the development team or refer to the system documentation.
