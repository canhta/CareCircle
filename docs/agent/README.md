# CareCircle AI Agent System Documentation

## Overview

This directory contains streamlined documentation for the CareCircle AI Agent System, designed following lean MVP principles to provide essential information without unnecessary complexity.

## Documentation Structure

The documentation has been consolidated into three focused files:

### 📋 [Agent System Overview](./agent-system-overview.md)
**Core system architecture and design concepts**
- System architecture diagram
- Agent capabilities and responsibilities  
- Technology stack overview
- Integration points with existing CareCircle platform
- Quick start guide

### 🛠️ [Implementation Guide](./implementation-guide.md)
**Practical implementation steps and configuration**
- Three-phase implementation approach
- Environment setup and configuration
- Docker containerization
- Database integration
- Testing and troubleshooting

### 🔒 [Compliance & Deployment](./compliance-and-deployment.md)
**Healthcare compliance and production deployment**
- HIPAA compliance essentials
- Security requirements and best practices
- Production deployment strategies
- Cost management and monitoring
- Backup and recovery procedures

## Quick Navigation

**Getting Started?** → Start with [Agent System Overview](./agent-system-overview.md)

**Ready to Implement?** → Follow the [Implementation Guide](./implementation-guide.md)

**Deploying to Production?** → Review [Compliance & Deployment](./compliance-and-deployment.md)

## Key Features

- **Lean MVP Approach**: Single intelligent agent with minimal infrastructure dependencies
- **Healthcare-First Design**: HIPAA compliance and patient safety prioritized
- **Seamless Integration**: Works with existing CareCircle NestJS backend and Flutter mobile app
- **Cost-Optimized**: Intelligent model routing and usage controls
- **Production-Ready**: Containerized deployment with monitoring and compliance

## Prerequisites

- Node.js 22+ with npm/yarn
- Docker Desktop
- PostgreSQL 15+ database
- Redis 7+ for session management
- OpenAI API access

## 🚀 Quick Start (5 Minutes)

### Prerequisites
- Node.js 22+ installed
- Docker Desktop running
- OpenAI API key
- Git access to CareCircle repository

### Rapid Setup

```bash
# 1. Clone and navigate to project
git clone https://github.com/canhta/CareCircle.git
cd CareCircle/backend

# 2. Install healthcare agent dependencies
npm install @langchain/core@^0.3.0 @langchain/openai@^0.3.0
npm install @langchain/langgraph@^0.2.0 fhir@^4.11.1
npm install crypto-js@^4.2.0 @milvus-io/milvus2-sdk-node@^2.3.0

# 3. Configure environment (minimal setup)
cp .env.example .env.healthcare-agents
echo "OPENAI_API_KEY=your_openai_key_here" >> .env.healthcare-agents
echo "ENABLE_PHI_DETECTION=true" >> .env.healthcare-agents
echo "ENABLE_COMPLIANCE_MONITORING=true" >> .env.healthcare-agents

# 4. Start healthcare agent services
docker-compose -f docker-compose.healthcare.yml up -d
npm run start:healthcare-agents

# 5. Verify installation (should return 200 OK)
curl http://localhost:3001/health
curl http://localhost:3001/agents/health
```

### Validation Steps

```bash
# Test PHI detection
curl -X POST http://localhost:3001/debug/phi-detection \
  -H "Content-Type: application/json" \
  -d '{"text": "Patient John Doe, SSN 123-45-6789"}'

# Test agent orchestration
curl -X POST http://localhost:3001/api/v1/healthcare/chat \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your_firebase_token" \
  -d '{"message": "I have a headache", "patientContext": {"age": 30}}'

# Test emergency detection
curl -X POST http://localhost:3001/api/v1/healthcare/chat \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your_firebase_token" \
  -d '{"message": "I am having severe chest pain"}'
```

### Expected Results
- ✅ Health endpoints return 200 OK
- ✅ PHI detection identifies and masks SSN
- ✅ Healthcare chat returns intelligent responses
- ✅ Emergency detection triggers escalation protocols

### Next Steps After Quick Start
1. **Complete Setup**: Follow [Implementation Guide](./implementation-guide.md) for full configuration
2. **Integration**: Connect with existing CareCircle backend modules
3. **Testing**: Run comprehensive healthcare compliance tests
4. **Production**: Deploy using [Compliance & Deployment](./compliance-and-deployment.md) guide

## Architecture at a Glance

```
┌─────────────────────────────────────────────────────────────┐
│                CareCircle AI Agent System                   │
├─────────────────────────────────────────────────────────────┤
│  Agent Orchestration (LangGraph.js)                        │
│  ├── Supervisor Agent (Coordination)                       │
│  ├── Health Advisor (General Health)                       │
│  ├── Medication Assistant (Drug Management)                │
│  ├── Emergency Triage (Critical Care)                      │
│  └── Data Interpreter (Health Analytics)                   │
├─────────────────────────────────────────────────────────────┤
│  Supporting Services                                        │
│  ├── Vector Database (Semantic Memory)                     │
│  ├── Redis (Session Management)                            │
│  └── Compliance Service (HIPAA Protection)                 │
├─────────────────────────────────────────────────────────────┤
│  Existing CareCircle Platform                              │
│  ├── NestJS Backend (DDD Architecture)                     │
│  ├── PostgreSQL Database                                   │
│  ├── Firebase Authentication                               │
│  └── Flutter Mobile App                                    │
└─────────────────────────────────────────────────────────────┘
```

## Documentation Principles

This documentation follows lean MVP principles:

- **Focused Content**: Essential information only, no redundancy
- **Practical Guidance**: Implementation-focused rather than theoretical
- **Streamlined Structure**: Three comprehensive files instead of 13+ scattered documents
- **Healthcare-Centric**: Compliance and patient safety considerations throughout
- **Iterative Approach**: User feedback-driven improvement over complex upfront design

## Support

For implementation questions or issues:

1. Review the relevant documentation section
2. Check the troubleshooting sections in each guide
3. Create a GitHub issue with detailed information
4. Contact the development team

---

**Important**: This AI agent system handles Protected Health Information (PHI) and must be deployed in compliance with HIPAA regulations. Ensure proper security measures, audit trails, and access controls are in place before processing any real patient data.
