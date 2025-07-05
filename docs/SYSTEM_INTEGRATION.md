# CareCircle System Integration Guide

## Overview

This document outlines how the three major components of the CareCircle system work together:

1. **Backend Services** (NestJS/TypeScript)
2. **Admin Portal** (Next.js/React)
3. **Mobile Application** (Flutter/Dart)

The goal is to ensure all components integrate seamlessly while maintaining security, performance, and consistent user experience across the platform. The system is implemented following Domain-Driven Design (DDD) principles to ensure strong alignment with business requirements.

## Domain-Driven Design Implementation

CareCircle's architecture follows DDD principles across all components:

### Core DDD Concepts Applied

1. **Ubiquitous Language**:
   - Shared vocabulary between technical and domain experts
   - Consistent naming across all components (backend, frontend, mobile)
   - Domain terms reflected in code and documentation

2. **Bounded Contexts**:
   - Clear separation between different business domains
   - Primary bounded contexts:
     - User Management & Authentication
     - Health Data Management
     - Care Group Coordination
     - Notification System
     - Subscription Management
     - Analytics & Insights

3. **Domain Models**:
   - Rich domain models with behavior and validation
   - Anemic models for data transfer between components
   - Strategic use of value objects and entities

4. **Aggregates**:
   - Clear aggregate boundaries to maintain consistency
   - Root entities controlling access to aggregate members
   - Consistent transaction boundaries aligned with aggregates

5. **Domain Events**:
   - Event-driven communication between bounded contexts
   - Cross-cutting concerns managed through domain events
   - Decoupled component integration via events

### DDD Implementation in Components

1. **Backend (NestJS)**:
   - Domain modules aligned with bounded contexts
   - Clear separation between domain, application, and infrastructure layers
   - Domain services for complex business operations
   - Repositories abstracted from underlying infrastructure

2. **Mobile App (Flutter)**:
   - Feature modules aligned with bounded contexts
   - Domain models separated from UI concerns
   - Repositories implementing domain interfaces
   - Use cases encapsulating business logic

3. **Admin Portal (Next.js)**:
   - Page structure reflecting bounded contexts
   - Shared domain models with backend
   - Clear separation of domain logic from UI components

## System Architecture Overview

```
┌──────────────────┐     ┌───────────────────┐     ┌─────────────────┐
│                  │     │                   │     │                 │
│  Mobile App      │◄────┤  Backend Services │◄────┤  Admin Portal   │
│  (Flutter)       │─────►  (NestJS)         │─────►  (Next.js)      │
│                  │     │                   │     │                 │
└──────────────────┘     └───────────────────┘     └─────────────────┘
       │                          │                       │
       │                          │                       │
       ▼                          ▼                       ▼
┌──────────────────┐     ┌───────────────────┐     ┌─────────────────┐
│ Health Platform  │     │ Database &        │     │ Analytics &     │
│ Integration      │     │ Vector Storage    │     │ Monitoring      │
└──────────────────┘     └───────────────────┘     └─────────────────┘
```

## Authentication and Authorization

### Unified Authentication Strategy

To ensure consistent security across all platforms, CareCircle implements a unified authentication strategy:

1. **Backend Authentication Provider**:
   - JWT-based authentication with refresh token strategy
   - OAuth2 flow for social login providers (Google, Apple)
   - Multi-factor authentication support for sensitive operations

2. **Client Implementation**:
   - **Mobile App**: Implements OAuth2 authentication flow with JWT storage
   - **Admin Portal**: Uses NextAuth.js with JWT session strategy backed by the same backend

3. **Token Management**:
   - Access tokens (short-lived)
   - Refresh tokens (long-lived, secure storage)
   - Role-based claims embedded in tokens

### Authorization Flow

```
┌────────────┐       ┌────────────┐        ┌────────────┐
│            │       │            │        │            │
│  Client    │──1───►│  Auth      │───2───►│  Resource  │
│            │◄──4───│  Service   │◄──3────│  Service   │
│            │       │            │        │            │
└────────────┘       └────────────┘        └────────────┘
```

1. Client authenticates with Auth Service
2. Auth Service provides signed JWT
3. Resource Service validates JWT with Auth Service
4. Client receives protected resources

## API Integration

### API Documentation

- All backend APIs are documented using OpenAPI/Swagger
- API documentation is available at `/api/docs` in the development environment
- Clients should use the documented endpoints for all communication

### API Versioning Strategy

- APIs are versioned using URL path versioning (e.g., `/api/v1/users`)
- Backward compatibility is maintained for at least one version
- API changes are documented in the changelog

### Client Implementation

#### Mobile App API Integration

The mobile app should implement a centralized API client with:

- Base URL configuration for different environments
- Authentication token management
- Error handling and retry logic
- Offline operation support

```dart
// Example of mobile app API client structure
class ApiClient {
  final String baseUrl;
  final TokenManager tokenManager;

  // HTTP methods with authentication and error handling
  Future<Response> get(String path, {Map<String, dynamic>? params});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);

  // Token refresh logic
  Future<void> refreshTokenIfNeeded();
}
```

#### Admin Portal API Integration

The admin portal should use a combination of:

- Server Components: Direct API calls from the server with proper caching
- Server Actions: For mutations and form submissions
- Client-side API client: For interactive components using React Query

```typescript
// Example of admin portal API client structure
interface ApiClientOptions {
  baseUrl: string;
  headers?: Record<string, string>;
}

class ApiClient {
  // Configuration methods
  static configure(options: ApiClientOptions): void;

  // HTTP methods
  static async get<T>(path: string, params?: Record<string, any>): Promise<T>;
  static async post<T>(path: string, data?: any): Promise<T>;
  static async put<T>(path: string, data?: any): Promise<T>;
  static async delete<T>(path: string): Promise<T>;
}
```

## Data Flow and Integration Points

### Health Data Flow

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│               │     │               │     │               │
│ Health Source │────►│ Mobile App    │────►│ Backend       │
│ (HealthKit/   │     │ (Processing & │     │ (Storage &    │
│  Health       │     │  Buffering)   │     │  Analysis)    │
│  Connect)     │     │               │     │               │
└───────────────┘     └───────────────┘     └───────────────┘
                                                    │
                                                    ▼
                                           ┌───────────────┐
                                           │ Admin Portal  │
                                           │ (Reporting &  │
                                           │  Analytics)   │
                                           └───────────────┘
```

#### Integration Requirements:

1. **Health Data Collection** (Mobile App):
   - Implement data synchronization with HealthKit/Health Connect
   - Buffer data for offline operation
   - Apply client-side privacy filters

2. **Health Data Processing** (Backend):
   - Receive and validate health data from mobile app
   - Process and store in time-series database
   - Apply AI analysis for insights and recommendations

3. **Health Data Visualization** (Admin & Mobile):
   - Fetch aggregated health data from backend
   - Render visualizations with appropriate access controls

### Care Group Integration

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│               │     │               │     │               │
│ Caregiver     │────►│ Care Group    │────►│ Care          │
│ Mobile App    │     │ Service       │     │ Recipient     │
│               │     │               │     │ Mobile App    │
└───────────────┘     └───────────────┘     └───────────────┘
```

#### Integration Requirements:

1. **Care Group Management**:
   - Centralized group membership and permission management
   - Secure invitation system with deep linking
   - Role-based access control for health data sharing

2. **Real-time Updates**:
   - Notification system for status changes
   - Health alert propagation to caregivers
   - Secure data sharing with consent tracking

## Notification System Integration

The notification system spans all components with centralized management:

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│               │     │               │     │               │
│ Backend       │────►│ Firebase      │────►│ Mobile App    │
│ Notification  │     │ Cloud         │     │ (Display &    │
│ Service       │     │ Messaging     │     │  Interaction) │
│               │     │               │     │               │
└───────────────┘     └───────────────┘     └───────────────┘
```

### Integration Requirements:

1. **Backend Notification Service**:
   - Template-based notification generation
   - Scheduling and delivery tracking
   - User preference management
   - Adaptive timing algorithm

2. **Mobile App Integration**:
   - FCM token management and registration
   - Background notification handling
   - Interactive notification responses
   - Notification preference UI

## Subscription and Payment Integration

Payment processing should be centralized in the backend with client-specific UI:

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│               │     │               │     │               │
│ Client UI     │────►│ Backend       │────►│ Payment       │
│ (Purchase     │     │ Payment       │     │ Gateway       │
│  Flow)        │     │ Service       │     │ (MoMo,        │
│               │     │               │     │  ZaloPay)     │
└───────────────┘     └───────────────┘     └───────────────┘
                             │
                             ▼
                      ┌───────────────┐
                      │ Subscription  │
                      │ Management    │
                      └───────────────┘
```

### Integration Requirements:

1. **Backend Payment Service**:
   - Payment gateway integration (MoMo, ZaloPay)
   - Subscription plan management
   - Payment verification and receipt validation
   - Webhook handling for payment events

2. **Mobile App Integration**:
   - Native in-app purchase flow
   - Payment UI with backend validation
   - Subscription status checking
   - Receipt validation

3. **Admin Portal Integration**:
   - Subscription management interface
   - Payment analytics and reporting
   - Plan configuration and management

## AI Service Integration

AI services are centralized in the backend with client consumption:

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│               │     │               │     │               │
│ Client        │────►│ Backend AI    │────►│ OpenAI        │
│ (Request      │     │ Service       │     │ API           │
│  Insights)    │     │ (Processing & │     │               │
│               │     │  Sanitization)│     │               │
└───────────────┘     └───────────────┘     └───────────────┘
                             │
                             ▼
                      ┌───────────────┐
                      │ Milvus Vector │
                      │ Database      │
                      └───────────────┘
```

### Integration Requirements:

1. **Backend AI Service**:
   - OpenAI API integration with key management
   - PHI detection and sanitization
   - Embedding generation for vector search
   - Content caching for optimization

2. **Mobile App Integration**:
   - Health insight request and display
   - Personalized recommendation UI
   - AI-powered features with graceful degradation

3. **Admin Portal Integration**:
   - AI usage monitoring and analytics
   - Cost tracking and optimization
   - Model performance analysis

## Error Handling and Logging Strategy

Implement a consistent error handling approach across all components:

1. **Error Classification**:
   - Network errors
   - Authentication/authorization errors
   - Validation errors
   - Business logic errors
   - System errors

2. **Client-side Error Handling**:
   - Typed error responses
   - User-friendly error messages
   - Retry mechanisms for transient errors
   - Offline operation fallbacks

3. **Centralized Logging**:
   - Structured logging format
   - Error aggregation in monitoring system
   - PHI protection in logs
   - Correlation IDs across system components

## Environment Configuration

Maintain consistent environment configuration across components:

1. **Development Environment**:
   - Local development with Docker Compose
   - Mock services for third-party dependencies
   - Development-specific settings

2. **Staging Environment**:
   - Isolated database and services
   - Production-like configuration
   - Testing environment for integration verification

3. **Production Environment**:
   - Scaled services with high availability
   - Production security settings
   - Performance monitoring and alerting

## Development Strategy

The development approach prioritizes:

1. **Domain-First Development**:
   - Start with domain model implementation
   - Focus on business logic and rules
   - Implement technical infrastructure around domain model

2. **Manual Testing**:
   - Comprehensive manual testing during initial development
   - Focus on business rule validation and user experience
   - Automated tests to be implemented in later phases

3. **Feature Delivery**:
   - Focus on delivering working features
   - Iterative refinement based on stakeholder feedback
   - Documentation of domain concepts alongside implementation

## Next Steps for Integration

1. **Backend**:
   - Implement domain models following DDD principles
   - Create domain services for core business logic
   - Complete OpenAPI documentation for all endpoints
   - Implement centralized error handling

2. **Mobile App**:
   - Implement feature modules aligned with bounded contexts
   - Create centralized ApiClient class with DDD approach
   - Standardize authentication flow with backend
   - Implement domain entities and value objects

3. **Admin Portal**:
   - Structure components around domain concepts
   - Select and implement authentication solution
   - Create API client library for consistent backend access
   - Implement server component data fetching with proper caching
