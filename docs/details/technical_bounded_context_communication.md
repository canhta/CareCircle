# Technical Specification: Bounded Context Communication

## Overview

This document specifies the communication patterns between Bounded Contexts in the CareCircle system. Following Domain-Driven Design principles, each Bounded Context represents a distinct business domain with its own models, language, and responsibilities. This specification defines how these contexts interact while maintaining appropriate boundaries and independence.

## Communication Patterns

CareCircle employs several communication patterns between Bounded Contexts, each chosen based on the specific requirements of the interaction:

### 1. Synchronous API Calls

**When to Use:**

- For immediate, request-response interactions
- When the calling context needs an immediate answer
- For simple, direct queries that don't require complex processing

**Implementation:**

- REST APIs with well-defined contracts
- GraphQL for more complex, selective data retrieval
- HTTP/2 for improved performance
- Content negotiation (application/json, application/hal+json)

**Example:**

```typescript
// Health Data Context querying User Context for profile information
const userProfile = await userContextClient.get(`/api/users/${userId}/profile`);
```

### 2. Asynchronous Event-Based Communication

**When to Use:**

- For notifications of state changes
- When contexts need to react to events in other contexts
- For eventual consistency scenarios
- When operations can be processed in the background

**Implementation:**

- Event bus using RabbitMQ
- Event schema versioning
- Idempotent event handlers
- Dead letter queues for failed events

**Example:**

```typescript
// Medication Context publishing an event when medication is added
eventBus.publish("medication.added", {
  medicationId: newMedication.id,
  userId: user.id,
  timestamp: new Date().toISOString(),
  medication: {
    name: newMedication.name,
    dosage: newMedication.dosage,
    instructions: newMedication.instructions,
  },
});
```

### 3. Shared Database (Limited Use)

**When to Use:**

- Only for very tightly coupled contexts where other methods introduce excessive complexity
- For read-only access from one context to another's data
- For maintaining reference data used across multiple contexts

**Implementation:**

- Schema-per-context design
- Read-only views for cross-context access
- Clear documentation of shared tables and their ownership
- Database triggers to publish events when shared data changes

**Example:**

```sql
-- Creating a read-only view for medication references
CREATE VIEW medication_context.medication_reference AS
SELECT id, name, generic_name, form, strength
FROM medication_catalog_context.medications;
```

### 4. Context Map API

**When to Use:**

- For accessing metadata about available contexts and their capabilities
- For service discovery
- For managing system-wide settings that span multiple contexts

**Implementation:**

- Central registry of contexts and their APIs
- API versioning information
- Health check endpoints
- Documentation endpoints

**Example:**

```typescript
// Discovering available contexts and their endpoints
const contexts = await contextMapClient.get("/api/contexts");
const healthDataEndpoints = contexts.find(
  (c) => c.name === "health-data"
).endpoints;
```

## Context Integration Patterns

### 1. Conformist

**Description:** One context explicitly adopts the model of another context to simplify integration.

**Applied In:** The Notification Context conforms to models from other contexts when delivering notifications, adapting to the data structures provided by source contexts.

### 2. Anti-Corruption Layer

**Description:** A translation layer that prevents concepts from one context from leaking into another.

**Applied In:** The Health Data Context uses an anti-corruption layer when integrating with external health systems, translating between CareCircle's domain model and external data formats.

### 3. Published Language

**Description:** A well-documented shared format for cross-context communication.

**Applied In:** All contexts publish and consume events using a standardized event format with schema validation.

### 4. Open Host Service

**Description:** A protocol that gives access to a bounded context as a set of services.

**Applied In:** The User Context provides an open host service that other contexts use to retrieve user profile information.

## Implementation Details

### Event Schema Definition

Events in CareCircle follow a standardized format:

```typescript
interface DomainEvent<T> {
  id: string; // Unique event identifier
  type: string; // Event type (e.g., 'medication.added')
  timestamp: string; // ISO timestamp of when the event occurred
  version: string; // Schema version
  source: string; // Originating context
  correlationId?: string; // For tracking related events
  causationId?: string; // ID of the event that caused this one
  payload: T; // Event-specific payload
  metadata?: {
    // Optional metadata
    userId?: string; // User who triggered the event
    deviceId?: string; // Device that triggered the event
    ip?: string; // IP address of the request
  };
}
```

### API Gateway Pattern

To simplify client interactions, CareCircle implements an API Gateway that:

1. Routes requests to appropriate contexts
2. Handles authentication and authorization
3. Provides request logging and monitoring
4. Implements rate limiting and throttling
5. Manages API versioning

### Event Sourcing for Critical Contexts

For critical contexts like Health Data and Medication, we implement event sourcing to:

1. Maintain a complete audit history
2. Enable temporal queries (data as of a specific time)
3. Facilitate rebuilding state from event history
4. Support replay of events for debugging and testing

## Cross-Cutting Concerns

### 1. Authentication and Authorization

Authentication is handled centrally by the Identity Context, which issues JWT tokens. Each context is responsible for:

1. Validating tokens
2. Checking permissions specific to that context
3. Implementing fine-grained access control for its domain objects

### 2. Distributed Tracing

To monitor and debug cross-context interactions:

1. Correlation IDs propagate through all communications
2. OpenTelemetry integration provides distributed tracing
3. Centralized logging aggregates information across contexts
4. Custom trace attributes capture domain-specific information

### 3. Error Handling

Each cross-context communication includes standardized error handling:

1. Well-defined error responses with error codes
2. Circuit breakers for failing services
3. Fallback mechanisms for critical functionality
4. Retry strategies with exponential backoff

### 4. Performance Considerations

1. Caching strategies at context boundaries
2. Request batching for high-volume operations
3. Data pagination for large result sets
4. Data denormalization where appropriate for read performance

## Communication Matrix

The following matrix outlines the primary communication methods between key contexts:

| From / To                | User Context | Health Data Context | Medication Context | Care Group Context | Notification Context |
| ------------------------ | ------------ | ------------------- | ------------------ | ------------------ | -------------------- |
| **User Context**         | -            | Events              | Events             | Events             | Events               |
| **Health Data Context**  | API Calls    | -                   | Events             | Events             | Events               |
| **Medication Context**   | API Calls    | Events              | -                  | Events             | Events               |
| **Care Group Context**   | API Calls    | API Calls           | API Calls          | -                  | Events               |
| **Notification Context** | API Calls    | API Calls           | API Calls          | API Calls          | -                    |

## Implementation Phases

### Phase 1: Basic Integration

- Implement REST APIs between contexts
- Set up basic event bus with RabbitMQ
- Implement authentication token propagation
- Create initial context map for service discovery

### Phase 2: Enhanced Communication

- Add GraphQL APIs for complex data queries
- Implement event schema versioning
- Add distributed tracing
- Create anti-corruption layers for external integrations

### Phase 3: Advanced Features

- Implement event sourcing for critical contexts
- Add circuit breakers and fallback mechanisms
- Implement API gateway for external clients
- Add performance optimizations (caching, batching)

## Testing Strategy

### 1. Contract Testing

- Define explicit contracts between contexts
- Implement consumer-driven contract tests
- Automate contract verification in CI pipeline

### 2. Integration Testing

- End-to-end tests for critical paths across contexts
- Mocked context boundaries for isolated testing
- Event replay testing for event-driven interactions

### 3. Chaos Testing

- Simulate context failures to test resilience
- Test network partition scenarios
- Validate fallback behaviors

## Monitoring and Observability

### 1. Metrics

- Track cross-context call volumes and latencies
- Monitor event processing rates and delays
- Record error rates by context and operation

### 2. Logging

- Structured logging with context identifiers
- Correlation IDs across context boundaries
- Log aggregation with context-based filtering

### 3. Alerting

- Thresholds for cross-context communication failures
- Event processing backlog alerts
- Dead letter queue monitoring

## Related Documents

- [Backend Structure](../backend_structure.md)
- [Planning and DDD Roadmap](../planning_and_todolist_ddd.md)
- [AI Integration Flow](../backend_structure.md#5-ai-integration-flow)
