# CareCircle Data Ingestion API Guide

## Overview

The CareCircle Data Ingestion API provides endpoints for uploading crawled Vietnamese healthcare content from local Python crawlers to the backend system. The API handles content validation, processing, and integration with the vector database for AI-powered responses.

## Authentication

All API endpoints require Firebase JWT authentication.

### Headers Required
```http
Authorization: Bearer <firebase-jwt-token>
Content-Type: application/json
User-Agent: CareCircle-Crawler/1.0
```

### Python Authentication Example
```python
import requests

headers = {
    'Authorization': f'Bearer {firebase_jwt_token}',
    'Content-Type': 'application/json',
    'User-Agent': 'CareCircle-Crawler/1.0'
}

response = requests.post(url, json=data, headers=headers)
```

## API Endpoints

### 1. Single Content Upload

**Endpoint**: `POST /knowledge-management/content/upload`

**Description**: Upload a single piece of crawled content for processing.

**Request Body**:
```json
{
  "source_id": "ministry-health",
  "source_url": "https://moh.gov.vn/article/123",
  "title": "Vietnamese Healthcare Guidelines 2024",
  "content": "Full text content in Vietnamese...",
  "content_type": "article",
  "language": "vi",
  "published_at": "2024-01-15T10:30:00Z",
  "crawled_at": "2024-01-16T08:15:00Z",
  "metadata": {
    "author": "Ministry of Health",
    "category": "guidelines",
    "tags": ["healthcare", "policy", "2024"],
    "medical_specialty": ["general"],
    "authority_score": 95,
    "content_hash": "sha256:abc123..."
  },
  "extracted_entities": [
    {
      "text": "huyết áp",
      "type": "medical_condition",
      "confidence": 0.95
    }
  ]
}
```

**Response**:
```json
{
  "success": true,
  "content_id": "km_content_123456",
  "status": "queued_for_processing",
  "message": "Content uploaded successfully",
  "processing_estimate": "2-5 minutes"
}
```

**Error Response**:
```json
{
  "success": false,
  "error": "validation_failed",
  "message": "Content validation failed",
  "details": [
    {
      "field": "content",
      "error": "Content too short (minimum 100 characters)"
    }
  ]
}
```

### 2. Bulk Content Upload

**Endpoint**: `POST /knowledge-management/content/bulk-upload`

**Description**: Upload multiple pieces of content in a single request for efficient batch processing.

**Request Body**:
```json
{
  "batch_id": "batch_20240116_001",
  "source_id": "ministry-health",
  "items": [
    {
      "source_url": "https://moh.gov.vn/article/123",
      "title": "Healthcare Guidelines 2024",
      "content": "Content text...",
      "content_type": "article",
      "language": "vi",
      "published_at": "2024-01-15T10:30:00Z",
      "metadata": {
        "author": "Ministry of Health",
        "category": "guidelines"
      }
    },
    {
      "source_url": "https://moh.gov.vn/article/124",
      "title": "Medical Device Regulations",
      "content": "Content text...",
      "content_type": "regulation",
      "language": "vi",
      "published_at": "2024-01-14T14:20:00Z",
      "metadata": {
        "author": "IMDA",
        "category": "regulations"
      }
    }
  ]
}
```

**Response**:
```json
{
  "success": true,
  "batch_id": "batch_20240116_001",
  "total_items": 2,
  "accepted_items": 2,
  "rejected_items": 0,
  "status": "processing",
  "processing_estimate": "5-10 minutes",
  "items": [
    {
      "source_url": "https://moh.gov.vn/article/123",
      "content_id": "km_content_123456",
      "status": "accepted"
    },
    {
      "source_url": "https://moh.gov.vn/article/124",
      "content_id": "km_content_123457",
      "status": "accepted"
    }
  ]
}
```

### 3. Source Management

**Endpoint**: `GET /knowledge-management/sources`

**Description**: Retrieve list of configured data sources and their status.

**Response**:
```json
{
  "success": true,
  "sources": [
    {
      "id": "ministry-health",
      "name": "Vietnam Ministry of Health",
      "type": "government",
      "status": "active",
      "last_crawl": "2024-01-16T08:15:00Z",
      "total_content": 1250,
      "crawl_frequency": "daily"
    },
    {
      "id": "health-news",
      "name": "Vietnamese Health News Portal",
      "type": "news",
      "status": "active",
      "last_crawl": "2024-01-16T09:30:00Z",
      "total_content": 3420,
      "crawl_frequency": "hourly"
    }
  ]
}
```

**Endpoint**: `POST /knowledge-management/sources/validate`

**Description**: Validate a new source configuration before adding it.

**Request Body**:
```json
{
  "source_config": {
    "id": "new-hospital",
    "name": "Bach Mai Hospital",
    "base_url": "https://benhvienbachmai.vn",
    "type": "hospital",
    "language": "vi",
    "selectors": {
      "content": ".article-content",
      "title": ".article-title"
    }
  }
}
```

**Response**:
```json
{
  "success": true,
  "validation_result": {
    "accessible": true,
    "response_time": 1.2,
    "content_found": true,
    "selectors_valid": true,
    "robots_txt_compliant": true
  },
  "recommendations": [
    "Consider adding rate limiting of 2 seconds between requests",
    "Robots.txt allows crawling with 1 second delay"
  ]
}
```

### 4. Processing Status

**Endpoint**: `GET /knowledge-management/content/status`

**Description**: Check the processing status of uploaded content.

**Query Parameters**:
- `content_id`: Specific content ID to check
- `batch_id`: Batch ID to check all items in batch
- `source_id`: Check status for all content from a source
- `since`: ISO timestamp to check status since a specific time

**Example**: `GET /knowledge-management/content/status?batch_id=batch_20240116_001`

**Response**:
```json
{
  "success": true,
  "batch_id": "batch_20240116_001",
  "overall_status": "completed",
  "total_items": 2,
  "completed": 2,
  "processing": 0,
  "failed": 0,
  "items": [
    {
      "content_id": "km_content_123456",
      "status": "completed",
      "vector_id": "vec_789012",
      "processing_time": 3.2,
      "quality_score": 0.87
    },
    {
      "content_id": "km_content_123457",
      "status": "completed",
      "vector_id": "vec_789013",
      "processing_time": 2.8,
      "quality_score": 0.92
    }
  ]
}
```

## Data Models

### Content Item Schema
```json
{
  "source_id": "string (required)",
  "source_url": "string (required, valid URL)",
  "title": "string (required, 1-500 chars)",
  "content": "string (required, 100-1000000 chars)",
  "content_type": "enum: article|regulation|guideline|news|research",
  "language": "enum: vi|en (default: vi)",
  "published_at": "ISO 8601 datetime",
  "crawled_at": "ISO 8601 datetime (auto-generated if not provided)",
  "metadata": {
    "author": "string (optional)",
    "category": "string (optional)",
    "tags": "array of strings (optional)",
    "medical_specialty": "array of strings (optional)",
    "authority_score": "number 0-100 (optional)",
    "content_hash": "string (optional, auto-generated if not provided)"
  },
  "extracted_entities": [
    {
      "text": "string",
      "type": "enum: medical_condition|medication|procedure|symptom",
      "confidence": "number 0-1"
    }
  ]
}
```

### Error Response Schema
```json
{
  "success": false,
  "error": "string (error code)",
  "message": "string (human-readable message)",
  "details": [
    {
      "field": "string (field name)",
      "error": "string (specific error message)"
    }
  ],
  "request_id": "string (for debugging)"
}
```

## Python Client Example

### Basic Upload Client
```python
import requests
import json
from typing import Dict, List, Optional

class CareCircleAPIClient:
    def __init__(self, base_url: str, firebase_token: str):
        self.base_url = base_url.rstrip('/')
        self.headers = {
            'Authorization': f'Bearer {firebase_token}',
            'Content-Type': 'application/json',
            'User-Agent': 'CareCircle-Crawler/1.0'
        }
    
    def upload_content(self, content_data: Dict) -> Dict:
        """Upload single content item"""
        url = f"{self.base_url}/knowledge-management/content/upload"
        response = requests.post(url, json=content_data, headers=self.headers)
        return response.json()
    
    def bulk_upload(self, batch_data: Dict) -> Dict:
        """Upload multiple content items"""
        url = f"{self.base_url}/knowledge-management/content/bulk-upload"
        response = requests.post(url, json=batch_data, headers=self.headers)
        return response.json()
    
    def check_status(self, batch_id: str) -> Dict:
        """Check processing status"""
        url = f"{self.base_url}/knowledge-management/content/status"
        params = {'batch_id': batch_id}
        response = requests.get(url, params=params, headers=self.headers)
        return response.json()

# Usage example
client = CareCircleAPIClient(
    base_url="http://localhost:3000",
    firebase_token="your-firebase-jwt-token"
)

# Upload single content
content = {
    "source_id": "ministry-health",
    "source_url": "https://moh.gov.vn/article/123",
    "title": "Healthcare Guidelines 2024",
    "content": "Full Vietnamese content...",
    "content_type": "article",
    "language": "vi"
}

result = client.upload_content(content)
print(f"Upload result: {result}")
```

## Rate Limiting

### Default Limits
- **Single Upload**: 60 requests per minute
- **Bulk Upload**: 10 requests per minute
- **Status Check**: 120 requests per minute
- **Source Validation**: 5 requests per minute

### Rate Limit Headers
```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1642345678
```

### Handling Rate Limits
```python
import time

def upload_with_retry(client, content_data, max_retries=3):
    for attempt in range(max_retries):
        try:
            result = client.upload_content(content_data)
            return result
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 429:  # Rate limited
                retry_after = int(e.response.headers.get('Retry-After', 60))
                time.sleep(retry_after)
                continue
            raise
    raise Exception("Max retries exceeded")
```

## Error Handling

### Common Error Codes
- `validation_failed`: Content validation errors
- `rate_limit_exceeded`: Too many requests
- `authentication_failed`: Invalid or expired token
- `source_not_found`: Invalid source_id
- `content_too_large`: Content exceeds size limits
- `duplicate_content`: Content already exists (based on hash)
- `processing_failed`: Backend processing error

### Retry Strategy
```python
import time
import random

def exponential_backoff_retry(func, max_retries=3):
    for attempt in range(max_retries):
        try:
            return func()
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            
            # Exponential backoff with jitter
            delay = (2 ** attempt) + random.uniform(0, 1)
            time.sleep(delay)
```

## Related Documentation

- [CareCircle Local Python Crawler Architecture](./README.md)
- [Setup Guide](./setup-guide.md)
- [Knowledge Management Context](../bounded-contexts/07-knowledge-management/README.md)
