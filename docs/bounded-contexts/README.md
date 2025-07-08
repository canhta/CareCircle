# CareCircle Bounded Contexts

This directory contains technical implementation documentation for each Domain-Driven Design (DDD) bounded context in the CareCircle platform.

## Bounded Context Overview

The CareCircle system is organized into 6 bounded contexts, each with clear responsibilities and boundaries:

| Order | Context | Code | Description | Documentation |
|-------|---------|------|-------------|---------------|
| 1 | Identity & Access | IAC | Authentication, authorization, user management | [01-identity-access/](./01-identity-access/) |
| 2 | Care Group | CGC | Family care coordination, group management | [02-care-group/](./02-care-group/) |
| 3 | Health Data | HDC | Health metrics, device integration, analytics | [03-health-data/](./03-health-data/) |
| 4 | Medication | MDC | Prescription management, medication scheduling | [04-medication/](./04-medication/) |
| 5 | Notification | NOC | Multi-channel communication system | [05-notification/](./05-notification/) |
| 6 | AI Assistant | AAC | Conversational AI, health insights | [06-ai-assistant/](./06-ai-assistant/) |

## Implementation Order

The contexts are numbered in their recommended implementation order based on dependencies:

```
1. IAC (Identity & Access) ← Foundation for all other contexts
   ↓
2. CGC (Care Group) ← Defines user relationships and permissions
   ↓
3. HDC (Health Data) ← Core health functionality
   ↓
4. MDC (Medication) ← Builds on health data
   ↓
5. NOC (Notification) ← Supports all contexts with communication
   ↓
6. AAC (AI Assistant) ← Integrates with all contexts for intelligence
```

## Context Structure

Each bounded context directory contains:

- **README.md** - Technical specification and implementation details
- **TODO.md** - Implementation tasks and progress tracking
- **Additional files** - Context-specific implementation guides

## AI Agent Workflow

When working on a bounded context:

1. **Review the README.md** for technical specifications
2. **Check the TODO.md** for current tasks and dependencies
3. **Add new tasks** to TODO.md before starting implementation
4. **Update task status** as work progresses
5. **Reference related features** in the features directory

## Context Dependencies

### Core Dependencies
- **IAC** → No dependencies (foundational)
- **CGC** → Depends on IAC for user authentication
- **HDC** → Depends on IAC and CGC for user context and sharing
- **MDC** → Depends on IAC, CGC, and HDC for full functionality
- **NOC** → Works with all contexts for notifications
- **AAC** → Depends on all contexts for comprehensive AI functionality

### External Dependencies
- **Firebase Authentication** (IAC)
- **TimescaleDB** (HDC)
- **RxNorm API** (MDC)
- **Firebase Cloud Messaging** (NOC)
- **OpenAI API** (AAC)

## Cross-Context Communication

Contexts communicate through:
- **Domain Events** - Asynchronous communication for state changes
- **API Contracts** - Synchronous communication for data queries
- **Shared Kernel** - Common domain concepts and value objects

See [Bounded Context Communication](../architecture/bounded-context-communication.md) for detailed patterns.

## Related Documentation
- [Architecture](../architecture/README.md) - System-level architecture
- [Features](../features/README.md) - User-facing feature specifications
- [Planning](../planning/README.md) - Implementation roadmap
