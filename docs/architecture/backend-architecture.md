# CareCircle Backend Structure

This document outlines the backend architecture for the CareCircle platform, following the principles of Clean Architecture and Domain-Driven Design (DDD). The design emphasizes modularity, separation of concerns, and domain-centric development.

> **Note:** For more detailed specifications of major features, please refer to the corresponding files in the `./docs/details/` directory.

**Cross-Cutting Concerns:** For shared architectural patterns including authentication, error handling, logging, and validation, see [Cross-Cutting Concerns Architecture](./cross-cutting-concerns.md).

## 1. Technology Stack

### Core Technologies

- **Language**: TypeScript
- **Framework**: NestJS
- **Database**: PostgreSQL with TimescaleDB extension (for time-series health data)
- **ORM**: Prisma
- **API**: REST primary with GraphQL for complex queries
- **Authentication**: Firebase Authentication with Admin SDK

### Supporting Technologies

- **Cache**: Redis for session management and performance optimization
- **Queue**: BullMQ for background processing and scheduled tasks _(planned - not yet implemented)_
- **Vector Database**: Milvus for AI feature vector storage and similarity search _(planned - not yet implemented)_
- **Storage**: Firebase Storage for medical documents and images
- **Containerization**: Docker and Kubernetes for deployment _(development Docker Compose available)_

### AI & ML Services

- **LLM Integration**: OpenAI API for health insights and conversational features
- **OCR**: Dedicated service for prescription scanning
- **Vector Embeddings**: For user behavior analysis and recommendation

## 2. Project Directory Structure

```
backend/
├── .github/                 # CI/CD workflows (not yet implemented)
├── prisma/                  # Database schema and migrations
│   ├── migrations/          # Database migration files
│   └── schema.prisma        # Prisma schema definition
├── scripts/                 # Database and utility scripts
│   └── timescaledb-setup.sql # TimescaleDB initialization script
├── src/
│   ├── main.ts              # Application entry point
│   ├── app.module.ts        # Root module
│   ├── common/              # Shared utilities and modules
│   │   ├── constants/       # Application constants
│   │   ├── decorators/      # Custom decorators
│   │   ├── dtos/            # Shared DTOs
│   │   ├── enums/           # Enumerations (re-exported from Prisma)
│   │   ├── exceptions/      # Custom exceptions
│   │   ├── filters/         # Exception filters
│   │   ├── guards/          # Guards for route protection (Firebase Auth)
│   │   ├── interceptors/    # HTTP interceptors
│   │   ├── interfaces/      # Shared interfaces
│   │   ├── middleware/      # HTTP middleware
│   │   ├── pipes/           # Validation pipes
│   │   ├── types/           # Common types and Prisma type re-exports
│   │   └── utils/           # Utility functions
│   ├── identity-access/     # Identity & Access bounded context
│   │   ├── application/     # Use cases and application services
│   │   ├── domain/          # Domain entities and value objects
│   │   ├── infrastructure/  # External integrations (Firebase, repositories)
│   │   └── presentation/    # Controllers and DTOs
│   ├── health-data/         # Health Data bounded context
│   │   ├── application/     # Health analytics and validation services
│   │   ├── domain/          # Health metric entities and value objects
│   │   ├── infrastructure/  # TimescaleDB repositories and external services
│   │   └── presentation/    # Health data controllers and DTOs
│   ├── ai-assistant/        # AI Assistant bounded context
│   │   ├── application/     # Conversation and context management services
│   │   ├── domain/          # Conversation entities and message objects
│   │   ├── infrastructure/  # OpenAI integration and conversation repositories
│   │   └── presentation/    # AI chat controllers and DTOs
├── dist/                    # Compiled TypeScript output
├── node_modules/            # Node.js dependencies
├── .env                     # Environment variables (not in git)
├── .env.example             # Example environment file
├── eslint.config.mjs        # ESLint configuration
├── firebase-adminsdk.json   # Firebase service account key
├── nest-cli.json            # NestJS CLI configuration
├── package.json             # Project dependencies
├── package-lock.json        # Dependency lock file
├── tsconfig.json            # TypeScript configuration
├── tsconfig.build.json      # Build-specific TypeScript configuration
└── TODO.md                  # Backend development tasks
```

**Note**: The actual implementation uses bounded context directories directly under `src/` rather than a `modules/` subdirectory. Currently implemented bounded contexts are:

- `identity-access/` - Authentication and user management
- `health-data/` - Health metrics and TimescaleDB integration
- `ai-assistant/` - OpenAI integration and conversation management

**Missing bounded contexts** (schema exists but services not implemented):

- `care-group/` - Care group coordination
- `medication/` - Medication management
- `notification/` - Notification system

## 3. Core Module Breakdown

Each domain module follows Clean Architecture principles with layers that separate concerns:

### 3.1 Identity & Access Bounded Context (`src/identity-access/`)

```
identity-access/
├── domain/                  # Domain layer (core business rules)
│   ├── entities/            # Enterprise business rules
│   │   ├── user.entity.ts   # User domain entity
│   │   └── user-profile.entity.ts # User profile entity
│   ├── value-objects/       # Value objects
│   │   ├── email.vo.ts      # Email value object
│   │   └── phone-number.vo.ts # Phone number value object
│   └── repositories/        # Repository interfaces
│       ├── user.repository.interface.ts # User repository contract
│       └── user-profile.repository.interface.ts # Profile repository contract
├── application/             # Application layer (use cases)
│   └── services/            # Application services
│       ├── auth.service.ts  # Authentication service
│       ├── user.service.ts  # User management service
│       └── user-profile.service.ts # Profile management service
├── infrastructure/          # Infrastructure layer (external concerns)
│   ├── repositories/        # Data persistence implementations
│   │   ├── prisma-user.repository.ts # Prisma user repository
│   │   └── prisma-user-profile.repository.ts # Prisma profile repository
│   └── services/            # External services integration
│       └── firebase-auth.service.ts # Firebase authentication service
├── presentation/            # Presentation layer (controllers, DTOs)
│   ├── controllers/         # REST controllers
│   │   ├── auth.controller.ts # Authentication controller
│   │   └── user-profile.controller.ts # Profile controller
│   └── dtos/                # Data transfer objects
│       ├── auth-request.dto.ts # Authentication DTOs
│       ├── auth-response.dto.ts # Authentication response DTOs
│       └── user-profile.dto.ts # Profile DTOs
└── identity-access.module.ts # Module definition
```

### 3.2 Health Data Bounded Context (`src/health-data/`)

**Implemented** - Focused on health data management with TimescaleDB integration:

- **Domain**: Health metrics, vitals, and measurements as entities and value objects
- **Application**: Services for health data analysis, trend detection, and validation
- **Infrastructure**: TimescaleDB repositories with continuous aggregates, statistical functions
- **Presentation**: Controllers for health data input and querying

**Key Features**:

- TimescaleDB hypertables for time-series optimization
- Continuous aggregates for daily/weekly/monthly analytics
- Advanced anomaly detection and trend analysis
- Healthcare-specific validation with quality scoring

### 3.3 AI Assistant Bounded Context (`src/ai-assistant/`)

**Implemented** - Conversational AI with health context integration:

- **Domain**: Conversation contexts, health queries, and user preferences
- **Application**: Context management, health insight generation
- **Infrastructure**: OpenAI API integration, conversation history storage
- **Presentation**: Controllers for chat interactions and health insights

**Key Features**:

- OpenAI GPT-4 integration with healthcare-focused prompts
- Health context building from user data
- Conversation management and history
- Firebase authentication integration

### 3.4 Missing Bounded Contexts (Schema Exists, Services Not Implemented)

**Medication Management Context** - Prescription and medication tracking
**Care Group Context** - Family care coordination and sharing
**Notification Context** - Multi-channel communication system

## 4. Authentication and Authorization Flow

### 4.1 Authentication Strategy

CareCircle uses Firebase Authentication exclusively with the following features:

- Firebase ID token-based authentication (no custom JWT tokens)
- Secure token storage and transmission handled by Firebase SDK
- Multi-factor authentication for sensitive operations
- OAuth integration for social logins (Google, Apple)
- Guest mode support with anonymous authentication
- Token refresh and session management handled entirely by Firebase

### 4.2 Registration Flow

1. **Client Request**: User submits registration form with email/password or initiates OAuth
2. **Firebase Auth**: Creates user account and generates initial tokens
3. **Backend Validation**: Verifies token and creates user profile in database
4. **Profile Setup**: User completes extended profile information
5. **Confirmation**: Email verification sent to user
6. **Account Activation**: User account activated upon email verification

### 4.3 Login Flow

1. **Credential Submission**: User enters credentials or uses biometrics/social login
2. **Firebase Authentication**: Validates credentials and generates tokens
3. **Token Processing**: Access token and refresh token provided to client
4. **Backend Validation**: Backend validates token and retrieves user context
5. **Session Establishment**: User session established with appropriate permissions

### 4.4 Authenticated Request Flow

1. **Request Initiation**: Client sends request with Authorization header
2. **Auth Guard Processing**: NestJS guard intercepts and validates token
3. **Token Verification**: Firebase Admin SDK verifies token integrity and expiration
4. **Permission Check**: Role-based access control determines permission
5. **Request Processing**: If authorized, request processed by controller
6. **Response Delivery**: Response returned to client with appropriate data

### 4.5 Token Refresh Flow

1. **Token Expiration**: Client detects expired access token
2. **Refresh Request**: Client sends refresh token to authentication endpoint
3. **Token Validation**: Backend validates refresh token
4. **Token Generation**: New access token (and optionally refresh token) generated
5. **Token Delivery**: New tokens sent to client
6. **Session Continuation**: Client continues with new access token

### 4.6 Guest Authentication Flow

1. **Guest Login Request**: User selects "Continue as Guest" option
2. **Anonymous Authentication**: Firebase creates anonymous user account
3. **Device Tracking**: System records device identifier to prevent multiple guest accounts
4. **Limited Profile Creation**: Basic guest profile created with temporary ID
5. **Feature Limitation**: Guest users have access to limited feature set
6. **Conversion Prompt**: Periodic prompts encourage conversion to registered account
7. **Account Conversion**: When user registers, guest data is migrated to permanent account

## 5. AI Integration Flow

### 5.1 General AI Architecture

CareCircle employs a hybrid AI architecture that combines:

- Backend-hosted LLM interactions for sensitive health data processing
- Edge AI for privacy-sensitive operations on device
- Vector database for similarity search and pattern recognition

### 5.2 Health Data Processing Flow

1. **Data Collection**: Health data collected from devices or manual entry
2. **Preprocessing**: Data normalized and sanitized
3. **Feature Extraction**: Relevant features extracted for analysis
4. **Vector Embedding**: Health patterns converted to vector representations
5. **Pattern Analysis**: Similar patterns identified through vector similarity
6. **Insight Generation**: LLM generates insights based on patterns
7. **Personalized Delivery**: Insights delivered to user in context

### 5.3 AI Chat Flow

1. **User Query**: User submits health-related question
2. **Context Loading**: System loads relevant user health context
3. **Privacy Filtering**: PHI/PII filtered from prompt when not needed
4. **Prompt Construction**: Context-aware prompt constructed for LLM
5. **OpenAI Processing**: Request sent to OpenAI with appropriate parameters
6. **Response Validation**: AI response validated for medical accuracy
7. **Response Delivery**: Answer delivered to user with appropriate citations
8. **Conversation Storage**: Conversation stored securely for context maintenance

### 5.4 Prescription OCR Flow

1. **Image Capture**: User captures prescription image
2. **Image Preprocessing**: Image optimized for OCR processing
3. **OCR Processing**: Text extracted from prescription image
4. **Entity Extraction**: Medication names, dosages, and instructions identified
5. **Verification**: Extracted information validated against medication database
6. **User Confirmation**: User verifies extracted information
7. **Schedule Creation**: Medication schedule created based on instructions
8. **Reminder Setup**: Intelligent reminders configured based on schedule

### 5.5 LLM-Powered Notification Engine

1. **User Context Analysis**: System analyzes user behavior patterns and preferences
2. **Multi-armed Bandit Algorithm**: Decision engine optimizes notification timing and content
3. **Template Selection**: System selects optimal notification template based on context
4. **Personalization**: Content personalized with user-specific data
5. **Delivery Timing**: Notification scheduled for optimal delivery time
6. **Interaction Tracking**: User interaction with notification recorded
7. **Feedback Loop**: Algorithm updated based on interaction data
8. **A/B Testing**: Continuous optimization through testing different approaches

## 6. NestJS Architecture Features

### 6.1 Core Architectural Patterns

CareCircle leverages NestJS's architecture to create a robust application:

- **Modular Design**: Each functional domain is encapsulated in its own NestJS module
- **Dependency Injection**: Services and providers are injected where needed
- **Controllers**: Handle HTTP requests and delegate to appropriate services
- **Providers**: Implement business logic and are injected into controllers or other providers
- **Guards**: Protect routes based on conditions like authentication or permissions
- **Interceptors**: Transform the response/request objects or implement logging, caching
- **Pipes**: Validate and transform input data
- **Exception Filters**: Handle and format error responses
- **Middleware**: Process requests before they reach route handlers

### 6.2 Advanced NestJS Features

- **Dynamic Modules**: For configurable features like database connections and external services
- **Custom Decorators**: For role-based access control and PHI access tracking
- **Execution Context**: To access request details across the application
- **Lifecycle Hooks**: For resource initialization and cleanup
- **Custom Providers**: For complex dependency injection scenarios
- **Async Configuration**: For environment-specific settings

### 6.3 Exception Handling Strategy

```typescript
// Global exception filter for consistent error responses
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = "Internal server error";
    let code = "INTERNAL_ERROR";

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      if (typeof exceptionResponse === "object") {
        message = (exceptionResponse as any).message || message;
        code = (exceptionResponse as any).code || code;
      } else {
        message = exceptionResponse as string;
      }
    } else if (exception instanceof PrismaClientKnownRequestError) {
      // Handle Prisma specific errors
      status = HttpStatus.BAD_REQUEST;
      message = this.handlePrismaError(exception);
      code = `PRISMA_${exception.code}`;
    } else if (exception instanceof Error) {
      message = exception.message;
    }

    // Log the error (excluding sensitive data)
    Logger.error(
      `${request.method} ${request.url} - ${status}: ${message}`,
      (exception as Error).stack,
      "GlobalExceptionFilter",
    );

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message,
      code,
    });
  }

  private handlePrismaError(error: PrismaClientKnownRequestError): string {
    switch (error.code) {
      case "P2002":
        return `Unique constraint failed on the field: ${error.meta?.target}`;
      case "P2025":
        return "Record not found";
      default:
        return "Database error occurred";
    }
  }
}
```

## 7. Data Protection and Compliance

### 7.1 Data Security Measures

- End-to-end encryption for all health data
- Field-level encryption for sensitive health information
- Secure key management with rotation policies
- Access control with principle of least privilege
- Comprehensive audit logging of all PHI access

### 7.2 Privacy Controls

- Granular user consent management
- Data minimization in AI processing
- Retention policies with automatic purging
- Data portability and export options
- Right to be forgotten implementation

### 7.3 Regional Compliance

- Vietnam Decree 13/2022/ND-CP compliance
- GDPR-ready architecture
- HIPAA-inspired security controls
- Localization of data storage where required

### 7.4 PHI Protection Implementation

```typescript
// PHI access logging interceptor
@Injectable()
export class PhiAccessInterceptor implements NestInterceptor {
  constructor(private readonly auditService: AuditService) {}

  async intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const endpoint = request.path;
    const method = request.method;

    // Determine if this endpoint accesses PHI
    const phiAccessMetadata = this.getPhiAccessMetadata(context);

    if (phiAccessMetadata && user) {
      // Log PHI access before processing request
      await this.auditService.logPhiAccess({
        userId: user.uid,
        action: `${method} ${endpoint}`,
        dataCategory: phiAccessMetadata.dataCategory,
        purpose: phiAccessMetadata.purpose,
        timestamp: new Date(),
        ipAddress: request.ip,
        userAgent: request.headers["user-agent"],
      });
    }

    return next.handle();
  }

  private getPhiAccessMetadata(
    context: ExecutionContext,
  ): PhiAccessMetadata | null {
    const handler = context.getHandler();
    const classRef = context.getClass();

    // Check handler first, then the controller class
    return (
      Reflect.getMetadata(PHI_ACCESS_KEY, handler) ||
      Reflect.getMetadata(PHI_ACCESS_KEY, classRef)
    );
  }
}

// Custom decorator for PHI access
export const PhiAccess = (metadata: PhiAccessMetadata) =>
  SetMetadata(PHI_ACCESS_KEY, metadata);

// Example usage in controller
@Controller("health-records")
@PhiAccess({ dataCategory: "health_records", purpose: "patient_care" })
export class HealthRecordsController {
  @Get(":id")
  async getHealthRecord(@Param("id") id: string, @Request() req) {
    // Controller implementation
  }
}
```

## 8. Scalability and Performance Considerations

### 8.1 Database Scaling

- Read replicas for high-volume queries
- Sharding strategy for user data distribution
- Time-series optimization for health metrics
- Caching layer for frequently accessed data

### 8.2 Microservices Pathway

While starting as a modular monolith, the system is designed for future transition to microservices:

- Bounded contexts clearly defined
- Service boundaries aligned with domains
- Inter-module communication via well-defined interfaces
- Stateless design where possible

### 8.3 Performance Optimization

- API response time targets (<500ms)
- Query optimization through indexing
- N+1 query elimination strategies
- Edge caching for static resources
- Compression for bandwidth optimization

### 8.4 Performance Monitoring

```typescript
// Performance monitoring interceptor
@Injectable()
export class PerformanceInterceptor implements NestInterceptor {
  private readonly logger = new Logger(PerformanceInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const method = request.method;
    const url = request.url;
    const userAgent = request.headers["user-agent"] || "";
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const endTime = Date.now();
        const responseTime = endTime - startTime;

        this.logger.log(
          `[PERFORMANCE] ${method} ${url} ${responseTime}ms - ${userAgent}`,
        );

        // Log to monitoring system if response time exceeds threshold
        if (responseTime > 500) {
          this.logger.warn(
            `[SLOW REQUEST] ${method} ${url} ${responseTime}ms - ${userAgent}`,
          );
          // Additional logic to report to monitoring system
        }
      }),
    );
  }
}
```

## 9. Deployment and DevOps Strategy

### 9.1 Development Environment

- Docker Compose for local development
- Synchronized environment variables with .env files
- Hot-reloading for developer productivity
- Local database seeding and migrations

### 9.2 Staging Environment

- Kubernetes-based deployment
- CI/CD pipeline with GitHub Actions
- Automated testing before deployment
- Environment-specific configuration

### 9.3 Production Deployment

- Multi-region Kubernetes clusters
- Blue-green deployment strategy
- Automated rollbacks for failed deployments
- Centralized logging and monitoring
- Disaster recovery procedures

### 9.4 Infrastructure as Code

```yaml
# kubernetes/production/backend-deployment.yaml example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: carecircle-backend
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: carecircle-backend
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: carecircle-backend
    spec:
      containers:
        - name: backend
          image: ${CONTAINER_REGISTRY}/carecircle-backend:${IMAGE_TAG}
          ports:
            - containerPort: 3000
          resources:
            requests:
              cpu: 500m
              memory: 512Mi
            limits:
              cpu: 1000m
              memory: 1Gi
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 15
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health/live
              port: 3000
            initialDelaySeconds: 30
            periodSeconds: 30
          env:
            - name: NODE_ENV
              value: production
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: carecircle-secrets
                  key: database-url
            - name: FIREBASE_SERVICE_ACCOUNT_KEY
              valueFrom:
                secretKeyRef:
                  name: carecircle-secrets
                  key: firebase-service-account
            - name: OPENAI_API_KEY
              valueFrom:
                secretKeyRef:
                  name: carecircle-secrets
                  key: openai-api-key
```

## 10. Monitoring and Operations

### 10.1 Logging Strategy

- Structured JSON logs for machine readability
- Centralized log collection with Elasticsearch
- Log levels (DEBUG, INFO, WARN, ERROR) for filtering
- PHI exclusion from logs for privacy
- Request correlation IDs for tracing

### 10.2 Health Monitoring

```typescript
// Health check controller for Kubernetes probes
@Controller("health")
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @HealthCheck()
  async check() {
    return this.healthService.check([
      // Database health check
      async () => this.checkDatabase(),
      // Redis health check
      async () => this.checkRedis(),
      // External service checks
      async () => this.checkOpenAIService(),
    ]);
  }

  @Get("live")
  livenessCheck() {
    return { status: "ok" };
  }

  private async checkDatabase() {
    try {
      // Perform simple query to check database connection
      await this.prismaService.$queryRaw`SELECT 1`;
      return { database: { status: "up" } };
    } catch (error) {
      return { database: { status: "down", message: error.message } };
    }
  }

  private async checkRedis() {
    try {
      // Check Redis connection
      const ping = await this.redisService.ping();
      return { redis: { status: ping === "PONG" ? "up" : "down" } };
    } catch (error) {
      return { redis: { status: "down", message: error.message } };
    }
  }

  private async checkOpenAIService() {
    try {
      // Verify OpenAI API is accessible
      await this.openAIService.testConnection();
      return { openai: { status: "up" } };
    } catch (error) {
      return { openai: { status: "down", message: error.message } };
    }
  }
}
```

### 10.3 Metrics Collection

- Request count and latency metrics
- Error rate monitoring
- Resource utilization tracking
- Business KPI monitoring
- AI service usage metrics

### 10.4 Alerting Strategy

- Critical service disruption alerts
- Performance degradation warnings
- Security incident notifications
- Business metric anomalies
- On-call rotation for urgent issues

## 11. Testing Strategy

### 11.1 Unit Testing

```typescript
// Example unit test for a service
describe("UserService", () => {
  let service: UserService;
  let userRepositoryMock: MockType<UserRepository>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useFactory: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    userRepositoryMock = module.get(UserRepository);
  });

  it("should find a user by id", async () => {
    const user = { id: "1", email: "test@example.com" };
    userRepositoryMock.findById.mockReturnValue(user);

    expect(await service.findById("1")).toEqual(user);
    expect(userRepositoryMock.findById).toHaveBeenCalledWith("1");
  });
});
```

### 11.2 Integration Testing

- Database integration tests
- API endpoint testing
- Authentication flow testing
- External service mocking
- Transaction testing

### 11.3 E2E Testing

- Complete request flow testing
- API contract validation
- Performance testing under load
- Error handling verification
- Authentication and authorization testing

## 11. NestJS Best Practices for Healthcare Applications

### 11.1 Health Monitoring and Observability

**Implementation Guide for AI Agents:**

- Use @nestjs/terminus for comprehensive health checks
- Monitor database connectivity, external services, memory usage, and disk space
- Implement detailed health endpoints for different monitoring levels
- Set appropriate thresholds: memory (150MB), disk (50% usage)
- Include Firebase Auth and external API health checks

**Key Components to Implement:**

- HealthController with multiple check endpoints
- Memory and disk monitoring with configurable thresholds
- External service dependency checks
- Structured health response format

### 11.2 Multi-Tenant Architecture for Healthcare Organizations

**Implementation Guide for AI Agents:**

- Implement tenant isolation using NestJS durable provider contexts
- Use x-tenant-id header for tenant identification
- Create tenant-specific dependency injection sub-trees
- Ensure data isolation between healthcare organizations
- Implement tenant validation and authorization

**Key Components to Implement:**

- HealthcareTenantContextIdStrategy class
- Tenant ID validation middleware
- Tenant-scoped services and repositories
- Cross-tenant data access prevention
- Tenant configuration management

### 11.3 HIPAA-Compliant Audit Logging

**Implementation Guide for AI Agents:**

- Log all PHI access with comprehensive audit trails
- Include user ID, patient ID, action type, IP address, timestamp
- Implement both local and external audit logging
- Track successful and failed access attempts
- Generate unique session IDs for audit correlation

**Key Components to Implement:**

- HIPAAAuditLogger service
- Audit data models with required HIPAA fields
- Controller-level audit logging integration
- External audit service integration
- Audit log retention and archival policies

### 11.4 Robust Data Validation

**Implementation Guide for AI Agents:**

- Implement domain-specific validation rules (vital signs, medications)
- Add business logic validation beyond schema validation
- Create reusable validation DTOs
- Implement critical value alerting for health data

**Key Components to Implement:**

- Business logic validation in services
- Critical value detection and alerting
- Validation error handling and user feedback

### 11.5 Security Best Practices

**Implementation Guide for AI Agents:**

- Implement rate limiting for API protection
- Use helmet for security headers
- Configure CORS for healthcare applications
- Implement request/response encryption
- Add input sanitization and XSS protection

**Key Components to Implement:**

- Security middleware configuration
- Rate limiting by user and endpoint
- CORS configuration for healthcare domains
- Request encryption/decryption interceptors
- Input sanitization pipes

### 11.6 Performance Optimization

**Implementation Guide for AI Agents:**

- Implement Redis caching for frequently accessed data
- Use database connection pooling
- Add request/response compression
- Implement lazy loading for large datasets
- Use pagination for list endpoints

**Key Components to Implement:**

- Redis cache service with TTL management
- Database connection pool configuration
- Compression middleware
- Pagination DTOs and query builders
- Performance monitoring and metrics

### 11.7 Recommended Libraries for Healthcare Applications

**Essential Libraries for AI Agents to Include:**

- @nestjs/terminus - Health checks and monitoring
- @nestjs/cqrs - Command Query Responsibility Segregation
- @nestjs/bull - Queue management for background tasks
- nestjs-pino - Structured logging with request context
- @nestjs/cache-manager - Caching for performance
- nestjs-otel - OpenTelemetry for observability
- @nestjs/throttler - Rate limiting and API protection

**Integration Guidelines:**

- Configure each library according to healthcare compliance requirements
- Implement proper error handling and logging for all integrations
- Use environment-specific configurations
- Add health checks for all external dependencies
- Document configuration options and security considerations

## Related Documents

- [Feature Specifications](./details)
- [AI Agent Implementation Options](./details/technical_ai_agent_implementation.md)
- [Firebase Authentication System](./details/feature_UM-010.md)
- [AI-Powered Smart Notification System](./details/feature_NSS-001.md)
