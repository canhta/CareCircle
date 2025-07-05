# CareCircle Backend Implementation Plan

## Overview

This document outlines the implementation plan for the CareCircle backend services built with NestJS. The backend provides API services, AI-powered features, notification management, and data processing capabilities to support the mobile and web applications. As a healthcare application handling sensitive patient data, CareCircle implements robust security measures and compliance standards throughout its architecture.

## Technology Stack

- **Framework**: NestJS (TypeScript)
- **Database**: PostgreSQL with TimescaleDB extension
- **ORM**: Prisma
- **Vector Database**: Milvus (for storing user behavior vectors and enabling similarity-based pattern analysis)
- **Queue System**: BullMQ with Redis
- **AI Integration**: OpenAI API for LLM-powered features
- **Authentication**: Passport.js with JWT and MFA support
- **HTTP Server**: Express (default) with option to migrate to Fastify for performance
- **Containerization**: Docker
- **Deployment**: Docker Compose for development, Kubernetes for production
- **Security**: Helmet, rate limiting, encryption, audit logging

## NestJS Architecture

CareCircle leverages NestJS's modular architecture to create a scalable and maintainable codebase:

### Core Architectural Patterns

- **Modular Design**: Each functional domain is encapsulated in its own NestJS module
- **Dependency Injection**: Services and providers are injected where needed, promoting loose coupling
- **Controllers**: Handle HTTP requests and delegate to appropriate services
- **Providers**: Implement business logic and are injected into controllers or other providers
- **Guards**: Protect routes based on conditions like authentication or permissions
- **Interceptors**: Transform the response/request objects or implement logging, caching, etc.
- **Pipes**: Validate and transform input data
- **Exception Filters**: Handle and format error responses
- **Middleware**: Process requests before they reach route handlers

### Advanced NestJS Features Implemented

- **Dynamic Modules**: For configurable features like database connections and external services
- **Custom Decorators**: For role-based access control and PHI access tracking
- **Execution Context**: To access request details across the application
- **Lifecycle Hooks**: For resource initialization and cleanup
- **Custom Providers**: For complex dependency injection scenarios
- **Async Configuration**: For environment-specific settings

## Implementation Phases

### Phase 1: Core Infrastructure & API Foundation (Complete)

#### 1.1 Project Setup (Complete)

- ✅ Initialized NestJS project with modular architecture
- ✅ Configured Docker and Docker Compose for development environment
- ✅ Setup environment configuration for multiple deployment environments
- ✅ Implemented logging infrastructure
- ✅ Removed test files to focus on MVP development per PRD

#### 1.2 User Management & Authentication (Complete)

- ✅ Implemented user registration, login, and profile management
- ✅ Created JWT authentication with refresh token strategy
- ✅ Built social authentication providers (Google, Apple)
- ✅ Set up role-based access control (RBAC) system
- ✅ Created email verification and password reset flows
- ✅ Implemented data consent and privacy controls
- ✅ Added support for multi-factor authentication (MFA)
- ✅ Implemented Guards for route protection

#### 1.3 Database & Data Models (Complete)

- ✅ Configured Prisma ORM with PostgreSQL
- ✅ Designed and implemented database schema for core entities
- ✅ Set up TimescaleDB extension for time-series data
- ✅ Implemented migration strategy and seeding
- ✅ Created data validation and transformation pipes
- ✅ Configured data encryption at rest
- ✅ Implemented custom repository pattern

#### 1.4 Health Data Processing (Complete)

- ✅ Built health data models and APIs
- ✅ Implemented data normalization and storage services
- ✅ Created time-series aggregation queries
- ✅ Set up batch processing for large data sets
- ✅ Implemented data synchronization endpoints
- ✅ Created health data consent and privacy controls
- ✅ Added support for data export and deletion
- ✅ Implemented audit logging for PHI access
- ✅ Added validation pipes for health data

### Phase 2: AI & Notification Systems (Complete)

#### 2.1 LLM-Powered Notification Engine (Complete)

- ✅ Set up BullMQ for notification queueing
- ✅ Created notification templates and content generation
- ✅ Implemented notification scheduling service
- ✅ Built notification delivery tracking
- ✅ Developed adaptive timing algorithm based on user behavior
- ✅ Implemented notification audit logging
- ✅ Added comprehensive template personalization
- ✅ Integrated with NestJS event system for cross-module communication

#### 2.2 OpenAI Integration for Health Insights (Complete)

- ✅ Configured OpenAI API integration with key management
- ✅ Created health insight generation services
- ✅ Implemented prompt engineering for medical content
- ✅ Built content caching and optimization
- ✅ Developed personalization based on user profile
- ✅ Integrated with Milvus for vector-based similarity search
- ✅ Added PII/PHI sanitization for AI requests
- ✅ Implemented interceptors for response transformation

#### 2.3 Daily Check-In & Analytics Services (Complete)

- ✅ Created personalized question generation system
- ✅ Implemented response analysis service
- ✅ Built trend analysis for check-in data
- ✅ Developed health score calculation algorithms
- ✅ Created anomaly detection for health patterns
- ✅ Implemented interactive notification responses
- ✅ Added custom exception filters for error handling

#### 2.4 Vector Database Implementation (Complete)

- ✅ Set up Milvus vector database
- ✅ Implemented embedding service for user behavior
- ✅ Created vector similarity search service
- ✅ Built pattern recognition for user interactions
- ✅ Developed recommendation engine based on vector similarity
- ✅ Added to Docker Compose for local development
- ✅ Implemented custom providers for vector database access

### Phase 3: Extended Features & Implementation (In Progress)

#### 3.1 Subscription & Payment Processing (In Progress)

- ✅ Implemented subscription models and plans
- ✅ Created payment processing services
- 🔄 Building webhook handlers for payment events
- 🔄 Implementing feature access control based on subscription
- 🔄 Developing analytics for subscription performance
- 🔄 Integrating Vietnamese payment gateways (MoMo, ZaloPay)
- 🔄 Implementing PCI-DSS compliance measures
- 🔄 Adding custom guards for subscription-based access

#### 3.2 Care Group Management (Complete)

- ✅ Built care group creation and management APIs
- ✅ Implemented role-based permissions within groups
- ✅ Created invitation system with secure tokens
- ✅ Developed health data sharing with privacy controls
- ✅ Built notification rules for group alerts
- ✅ Implemented deep linking functionality
- ✅ Added consent management for shared PHI
- ✅ Created custom decorators for group permissions

#### 3.3 Prescription OCR & Management (Complete)

- ✅ Implemented prescription image upload and processing
- ✅ Built OCR extraction for medication details
- ✅ Created data validation and storage for prescriptions
- ✅ Developed prescription management APIs
- ✅ Implemented medication reminders based on prescription data
- ✅ Added medication interaction checking
- ✅ Implemented file streaming for prescription images

#### 3.4 Analytics & Monitoring (In Progress)

- ✅ Created user behavior analytics service
- 🔄 Implementing AI cost tracking and optimization
- 🔄 Building system performance monitoring
- 🔄 Developing usage reports and dashboards
- ✅ Implemented audit logging for compliance
- 🔄 Setting up anomaly detection for security events
- 🔄 Implementing custom interceptors for performance metrics

#### 3.5 Performance & Security (Planned)

- 🔄 Optimizing database queries and indexing
- 🔄 Implementing API rate limiting and caching
- 🔄 Enhancing security with request validation
- 🔄 Setting up automated security scanning
- 🔄 Performing load testing and optimization
- 🔄 Implementing advanced encryption for sensitive fields
- 🔄 Evaluating Fastify adapter for performance improvement

## Microservices Architecture (Future)

While the current implementation uses a monolithic approach for MVP development, the system is designed with future microservices migration in mind:

### Planned Microservices

- **Authentication Service**: Handle user authentication and authorization
- **Health Data Service**: Process and store health-related information
- **Notification Service**: Manage notification delivery and tracking
- **AI Service**: Handle AI-related processing and vector operations
- **Subscription Service**: Manage payments and subscription plans

### Transport Layer Options

- **gRPC**: For high-performance internal service communication
- **Redis**: For event-based communication and pub/sub patterns
- **RabbitMQ**: For complex message routing and guaranteed delivery
- **Kafka**: For high-throughput event streaming (if needed)

### Hybrid Approach

- Implement a hybrid application that exposes both HTTP and microservices endpoints
- Use NestJS's platform-agnostic design to maintain consistent code structure
- Gradually migrate features to microservices as scaling needs emerge

## Testing Strategy

Per the PRD's MVP-first approach, the current focus is on:

- **Manual Testing**: Comprehensive manual testing of all features
- **Code Reviews**: Mandatory code reviews for all changes
- **TypeScript Benefits**: Utilizing TypeScript for compile-time safety
- **ESLint**: Using static analysis to ensure code quality
- **Production Monitoring**: Implementing logging and monitoring in production

Planned additions post-MVP:

- **Unit Tests**: For core services and utilities using Jest
- **Integration Tests**: For API endpoints and data flows
- **E2E Tests**: For critical user journeys using NestJS testing tools
- **Security Tests**: Regular penetration testing and vulnerability scanning

## Deployment Plan

1. **Development Environment**: Local Docker setup using Docker Compose (Implemented)
2. **Staging Environment**: CI/CD pipeline deployment (Planned)
3. **Production MVP**: Containerized deployment with essential services (Planned)
4. **Scaling Strategy**: Kubernetes deployment for horizontal scaling (Future)
5. **Disaster Recovery**: Multi-region failover configuration (Future)

## Healthcare Compliance

### HIPAA Compliance Framework

1. **Administrative Safeguards**:
   - Role-based access control
   - Regular risk assessment procedures
   - Security incident response plan
   - Comprehensive audit logging

2. **Technical Safeguards**:
   - Encryption of data at rest and in transit
   - Unique user identification
   - Automatic session timeout
   - Emergency access procedures
   - Audit controls

3. **Physical Safeguards**:
   - Secure server locations
   - Hardware and media controls
   - Proper disposal procedures

### PHI Protection Measures

- Data encryption in transit using TLS 1.3
- Data encryption at rest using AES-256
- Database field-level encryption for sensitive PHI
- Audit logging for all PHI access events
- Automatic session termination after inactivity
- Data anonymization for analytics and reporting
- Secure backup and disaster recovery processes

## Security Implementation

Leveraging NestJS's security features:

### Authentication

- **Passport Integration**: Using passport strategies for flexible authentication
- **JWT Implementation**: Stateless authentication with secure token handling
- **Guards**: Custom AuthGuard implementation for route protection
- **MFA**: Multi-factor authentication using time-based one-time passwords

### Authorization

- **RBAC**: Role-based access control using custom decorators and guards
- **CASL Integration**: Fine-grained permissions management
- **Custom Metadata**: Using SetMetadata for route-specific permissions

### Data Protection

- **Helmet Integration**: HTTP header security with Helmet middleware
- **CORS Configuration**: Strict cross-origin resource sharing policies
- **CSRF Protection**: Cross-site request forgery prevention
- **Rate Limiting**: Request throttling to prevent abuse
- **Encryption**: Data encryption using NestJS encryption utilities

## Monitoring & Operations

- **Logging**: Centralized logging system with encrypted PHI fields
- **Metrics**: Health endpoint monitoring and business KPI tracking
- **Alerts**: Service disruption monitoring with escalation procedures
- **Backup Strategy**: Automated encrypted database backups with integrity verification
- **Disaster Recovery**: Multi-region deployment with failover testing
- **Audit Trail**: Comprehensive logging of all data access and changes with user attribution

## Security Considerations

- **Data Encryption**: Implemented encryption at rest and in transit
- **API Security**: JWT validation, API key management, and rate limiting
- **Secrets Management**: Environment variables and secure vault for sensitive data
- **Compliance**: Vietnam's Decree 13/2022/ND-CP compliance and HIPAA-inspired controls
- **Audit Trail**: Comprehensive logging of data access and changes
- **Vulnerability Management**: Regular scanning and remediation processes
- **Penetration Testing**: Scheduled third-party security assessments
- **Security Headers**: Implementation of Helmet for secure HTTP headers
- **Input Validation**: Comprehensive request validation using class-validator
- **Dependency Management**: Regular updates and vulnerability scanning

## Performance Requirements

- **API Response Time**: < 200ms for standard endpoints, < 3s for AI-powered endpoints
- **Throughput**: Support for 100+ concurrent users initially, scalable to 1000+
- **Database Performance**: Optimized queries with < 100ms response time
- **AI Service Latency**: < 3s for insight generation
- **Caching Strategy**: Response and data caching to reduce load on critical services

## Risk Management

| Risk                            | Impact | Mitigation                                                     |
| ------------------------------- | ------ | -------------------------------------------------------------- |
| OpenAI API availability         | High   | Implement fallback responses and caching of common outputs     |
| Database scaling challenges     | Medium | Design with sharding capability from the start                 |
| Vector DB performance issues    | Medium | Implement progressive enhancement and optional vector features |
| High AI token consumption costs | High   | Set up budgeting, monitoring and rate limiting                 |
| Security vulnerabilities        | High   | Regular security audits and code reviews                       |
| PHI data breach                 | High   | Comprehensive encryption, access controls, and audit logging   |
| Compliance violations           | High   | Regular compliance reviews and automated controls              |

## LLM Integration Strategy

The system now uses a simplified LLM-based approach leveraging OpenAI's capabilities:

- **Vector Storage**: Milvus vector database stores user behavior patterns as high-dimensional vectors
- **OpenAI Integration**: Directly integrates with OpenAI's API for various AI features
- **Embedding Generation**: Utilizes OpenAI embeddings for efficient vector creation and similarity search
- **PHI Protection**: Implements robust sanitization to prevent PHI leakage to AI systems
- **AI-Powered Features**:
  - Personalized notification content and timing
  - Health insight generation
  - Daily check-in question personalization
  - Response analysis and trend detection
  - Medication information and interaction analysis

## Key Module Overview

### AI Module

- **OpenAIService**: Handles LLM API calls with proper error handling, retries, and PHI protection
- **EmbeddingService**: Creates vector embeddings for various content types
- **SanitizationService**: Removes PHI from data before AI processing

### Vector Module

- **MilvusService**: Manages vector storage and similarity search operations

### Security Module

- **EncryptionService**: Handles encryption/decryption of sensitive data
- **AuditService**: Records access to PHI and sensitive operations
- **ComplianceService**: Enforces data access policies and consent management

### Notification Module

- **AdaptiveNotificationEngine**: Personalizes notifications based on user behavior
- **NotificationTemplateService**: Manages customizable templates with placeholders
- **TemplateRenderingService**: Replaces template placeholders with user data
- **NotificationSchedulingService**: Handles timing of notifications with cron jobs
- **NotificationPrivacyService**: Ensures notifications don't leak PHI

### Health Data Module

- **HealthRecordService**: Manages health data synchronization and storage
- **HealthAnalysisService**: Analyzes health data for trends and insights
- **DataAnonymizationService**: Creates anonymized datasets for analysis

### Daily Check-In Module

- **PersonalizedQuestionService**: Generates tailored health questions
- **ResponseAnalysisService**: Analyzes user responses for health insights
- **TrendDetectionService**: Identifies patterns in user responses over time

### Care Group Module

- **CareGroupService**: Handles group creation and membership
- **CareGroupInvitationService**: Manages secure invitations with JWT
- **CareGroupDashboardService**: Aggregates health data for group view
- **SharingConsentService**: Manages PHI sharing permissions between users

### Prescription Module

- **PrescriptionOCRService**: Processes prescription images
- **PrescriptionService**: Manages medication data and schedules
- **MedicationInteractionService**: Checks for potential medication conflicts

### Subscription Module

- **SubscriptionService**: Handles subscription plans and payments
- **PaymentIntegrationService**: Interfaces with payment providers
- **PlanAccessControlService**: Manages feature access based on subscription level

## NestJS Architecture Best Practices

- **Modular Design**: Each feature encapsulated in its own NestJS module
- **Dependency Injection**: Leveraging NestJS DI container for loose coupling
- **Exception Filters**: Global exception handling with proper error responses
- **Interceptors**: Request/response transformation and logging
- **Guards**: Authentication and authorization at route level
- **Custom Decorators**: For PHI access control and audit logging
- **Middleware**: For request preprocessing and security headers
- **Pipes**: For request validation and transformation
- **Execution Context**: Properly accessing request context across the application
- **Lifecycle Hooks**: Using OnModuleInit, OnModuleDestroy for resource management
- **Dynamic Modules**: For configurable module imports
- **Custom Providers**: Using factory providers for complex initialization

## Documentation Requirements

- **API Documentation**: OpenAPI/Swagger specification
- **Data Models**: Entity relationship diagrams
- **Architecture Diagrams**: System components and interactions
- **Deployment Guides**: Environment setup and configuration
- **Developer Guides**: Local development setup and conventions
- **Security Policies**: Access control and data handling procedures
- **Compliance Documentation**: HIPAA-aligned policies and procedures
