# CareCircle Modules Documentation

This directory contains technical implementation documentation for the CareCircle platform's domain-driven design (DDD) modules. These documents serve as technical specifications for AI agents and developers implementing the system.

## Module Implementation Order

For the recommended implementation sequence, refer to the [Implementation Order Guide](./implementation_order.md).

## Core Modules

| #   | Module                    | Code | Description                                          | Key Document                                                          |
| --- | ------------------------- | ---- | ---------------------------------------------------- | --------------------------------------------------------------------- |
| 1   | Identity & Access Context | IAC  | User authentication, profiles, and permissions       | [Firebase Auth Implementation](./01a_firebase_auth_implementation.md) |
| 2   | Care Group Context        | CGC  | Family care coordination and shared responsibilities | [Care Group Context](./02_care_group_context.md)                      |
| 3   | Health Data Context       | HDC  | Health metrics storage and analytics                 | [Health Data Context](./03_health_data_context.md)                    |
| 4   | Medication Context        | MDC  | Medication tracking and adherence monitoring         | [Medication Context](./04_medication_context.md)                      |
| 5   | Notification Context      | NOC  | Multi-channel communication system                   | [Notification Context](./05_notification_context.md)                  |
| 6   | AI Assistant Context      | AAC  | Conversational health interface                      | [AI Assistant Context](./06_ai_assistant_context.md)                  |

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
