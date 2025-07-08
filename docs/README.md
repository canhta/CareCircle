# CareCircle System Documentation

This directory contains comprehensive documentation for the CareCircle system, an AI-powered family health management platform designed for Southeast Asia. The documentation follows modern best practices including Domain-Driven Design (DDD) and Clean Architecture principles.

## Documentation Structure

The documentation is organized into the following main components:

1. **Main Architecture Documents**

   - High-level architecture and design documents
   - Overview of all system components

2. **Detailed Specifications**
   - In-depth documentation of major features
   - Technical specifications for system components
   - UI/UX documentation with separated functional and visual concerns

## Main Documents

| Document                                                         | Description                                                               |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [features_list.md](./features_list.md)                           | Comprehensive list of all system features organized by domain             |
| [backend_structure.md](./backend_structure.md)                   | Backend architecture following Clean Architecture and DDD principles      |
| [mobile_structure.md](./mobile_structure.md)                     | Mobile application architecture using Flutter and feature-first design    |
| [planning_and_todolist_ddd.md](./planning_and_todolist_ddd.md)   | Development roadmap organized by DDD Bounded Contexts                     |
| [legacy_migration_decisions.md](./legacy_migration_decisions.md) | Summary of key architectural decisions migrated from legacy documentation |

## Detailed Specifications

For more detailed specifications on specific features, please see the [details](./details) directory, which includes:

### Feature Specifications

- [AI Health Chat](./details/feature_AHA-001.md) - Detailed specification for the AI-powered health assistant
- [Prescription Scanning](./details/feature_MM-001.md) - Detailed specification for prescription scanning feature
- [Care Group Creation](./details/feature_FCC-001.md) - Detailed specification for care group management
- [Firebase Authentication](./details/feature_UM-010.md) - Detailed specification for authentication with guest mode and account linking
- [Smart Notification System](./details/feature_NSS-001.md) - Detailed specification for AI-powered notification system

### Technical Specifications

- [Bounded Context Communication](./details/technical_bounded_context_communication.md) - Technical specification for bounded context communication patterns
- [AI Agent Implementation Options](./details/technical_ai_agent_implementation.md) - Comparative analysis of different AI chat and TTS implementation approaches
- [Firebase Authentication Integration Flow](./details/firebase_auth_integration_flow.md) - Detailed authentication flow between mobile, backend, and Firebase Auth

### UI/UX Documentation

- [UI/UX Mockups](./details/uiux) - Functional UI/UX specifications and visual design placeholders
- [UI/UX Textual Mockup Guidelines](./details/uiux_textual_mockup_guidelines.md) - Guidelines for creating textual UI/UX mockups

## UI/UX Documentation Approach

The CareCircle documentation follows a separation of concerns approach for UI/UX specifications:

1. **Textual Mockups**: Functional descriptions focusing on:

   - Information architecture
   - User flows
   - Functional requirements
   - Screen states
   - Accessibility considerations

2. **Visual Design Documents**: Visual specifications focusing on:
   - Visual composition
   - Style guide application
   - Component usage
   - Responsive design
   - Animation and transitions

This approach allows for clear communication of functional requirements independently from visual design decisions, which may evolve separately during the development lifecycle.

For details on this approach, see the [UI/UX Textual Mockup Guidelines](./details/uiux_textual_mockup_guidelines.md).

## Documentation Conventions

This documentation follows these conventions:

1. **Feature IDs**: Each feature has a unique ID (e.g., `AHA-001`) consisting of:

   - Domain/module prefix (e.g., `AHA` for AI Health Assistant)
   - Sequential number (e.g., `001`)

2. **Cross-References**: Documents reference each other using:

   - Direct links to other documents
   - Section references using header anchors (e.g., `#5-ai-integration-flow`)

3. **Diagrams**: ASCII diagrams are used for:

   - Architecture components
   - Data flows
   - UI mockups

4. **Code Examples**: Illustrative code examples are provided using appropriate syntax highlighting

## Using This Documentation

- **For product managers**: Start with `features_list.md` to understand the system's capabilities
- **For backend developers**: Begin with `backend_structure.md` and relevant detailed specifications
- **For mobile developers**: Focus on `mobile_structure.md` and mobile feature specifications
- **For system architects**: Review `planning_and_todolist_ddd.md` for the overall system design
- **For designers**: Review the textual mockups for functional requirements and create corresponding visual designs

## Contributing to Documentation

When adding to or modifying this documentation:

1. Maintain the established structure and formatting
2. Update cross-references when changing document organization
3. Place detailed specifications in the `details` directory
4. Follow the naming conventions for new files
5. For UI/UX documentation, maintain separation between functional and visual specifications
6. Update relevant README files when adding new documents
