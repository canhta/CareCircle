# CareCircle Modules Documentation

This directory contains technical implementation documentation for the CareCircle platform's domain-driven design (DDD) modules. These documents serve as technical specifications for AI agents and developers implementing the system.

## Documentation Structure

The CareCircle documentation is organized into two main areas:

1. **Module Documentation (this directory)** - Contains implementation-focused technical specifications for each bounded context, following DDD principles
2. **Detailed Features (`../details/`)** - Contains user story-driven feature specifications that may span multiple modules

## Module Implementation Order

For the recommended implementation sequence, refer to the [Implementation Order Guide](./implementation_order.md).

## Core Modules

| #   | Module                    | Code | Description                                          | Key Document                                                          | Related Features                         |
| --- | ------------------------- | ---- | ---------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------- |
| 1   | Identity & Access Context | IAC  | User authentication, profiles, and permissions       | [Firebase Auth Implementation](./01a_firebase_auth_implementation.md) | [UM-010](../details/feature_UM-010.md)   |
| 2   | Care Group Context        | CGC  | Family care coordination and shared responsibilities | [Care Group Context](./02_care_group_context.md)                      | [FCC-001](../details/feature_FCC-001.md) |
| 3   | Health Data Context       | HDC  | Health metrics storage and analytics                 | [Health Data Context](./03_health_data_context.md)                    | -                                        |
| 4   | Medication Context        | MDC  | Medication tracking and adherence monitoring         | [Medication Context](./04_medication_context.md)                      | [MM-001](../details/feature_MM-001.md)   |
| 5   | Notification Context      | NOC  | Multi-channel communication system                   | [Notification Context](./05_notification_context.md)                  | [NSS-001](../details/feature_NSS-001.md) |
| 6   | AI Assistant Context      | AAC  | Conversational health interface                      | [AI Assistant Context](./06_ai_assistant_context.md)                  | [AHA-001](../details/feature_AHA-001.md) |

## Module Dependencies

```
1. IAC <-- All other modules depend on IAC
   |
   v
2. CGC <-- HDC, MDC depend on CGC
   |
   v
3. HDC <-- MDC, AAC depend on HDC
   |
   v
4. MDC <-- AAC depends on MDC
   |
   v
5. NOC <-- Works with all modules
   |
   v
6. AAC <-- Depends on all previous modules
```

## Relationship Between Documentation Types

- **Module Documents**: Focus on implementation details within a bounded context, including data models, APIs, and technical implementations
- **Feature Specifications**: Describe user-facing features that may require multiple modules to implement
- **Integration Documents**: Describe how modules communicate and interact (see [Bounded Context Communication](../details/technical_bounded_context_communication.md))

## Avoiding Documentation Duplication

To minimize duplication across documentation:

1. **Reference Instead of Duplicate**: When detailed information exists in another document, link to it rather than copying
2. **Implementation vs. Features**: Module documents focus on "how to implement", while feature documents focus on "what to implement"
3. **Technical Details**: Code examples should primarily exist in module documents
4. **High-Level Flows**: Architecture diagrams and flows may be in both places, with module docs focusing on implementation details

## Implementation Guidelines

For AI agents implementing the CareCircle platform:

1. **Follow the numbered order** - Implement modules in the sequence defined in the implementation order guide
2. **Reference the detailed documentation** - Each module has a dedicated technical specification
3. **Special attention to Firebase Authentication** - For IAC implementation, refer to the Firebase auth implementation guide
4. **Use bounded context communication patterns** - Follow DDD principles for inter-module communication
5. **Track implementation progress** - Create task lists for each module implementation

## Cross-Module References

When implementing a module, refer to these integration points:

- **User authentication (IAC)** is required by all other modules
- **Care groups (CGC)** provide social structure for health data sharing
- **Health data (HDC)** provides metrics used by medication and AI modules
- **Medication tracking (MDC)** integrates with notifications and AI assistant
- **Notifications (NOC)** deliver alerts from all other modules
- **AI Assistant (AAC)** integrates data from all previous modules

## Technical Stack References

- Backend: NestJS with TypeScript
- Mobile: Flutter with Firebase integration
- Databases:
  - Firebase Firestore (user data, care groups)
  - TimescaleDB (time-series health metrics)
- Authentication: Firebase Authentication
- AI Integration: OpenAI API

## Implementation Status Tracking

As implementation progresses, update the [Implementation Order Guide](./implementation_order.md) to track completion status.
