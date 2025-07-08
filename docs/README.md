# CareCircle Documentation

This directory contains all technical documentation for the CareCircle health management platform. The documentation is structured to minimize duplication and provide clear implementation guidance for AI agents and developers.

## Documentation Structure

The documentation is organized into three main categories:

1. **Module Documentation** (`./modules/`) - Implementation-focused technical specifications for each Domain-Driven Design (DDD) bounded context

   - See [Module Documentation Index](./modules/README.md)

2. **Feature Specifications** (`./details/`) - User story-driven feature specifications that may span multiple modules

   - See [Feature Specifications Index](./details/README.md)

3. **Architecture Documents** (root directory) - System-level architecture and design decisions
   - Backend structure, mobile structure, planning, etc.

## Avoiding Documentation Duplication

To minimize duplication while maintaining comprehensive documentation:

1. **Module vs. Feature Focus**

   - Module docs focus on the "how" - technical implementation details
   - Feature docs focus on the "what" - user-facing functionality

2. **Cross-Reference Instead of Duplicate**

   - Documents link to each other rather than duplicating content
   - Example: Firebase authentication is detailed in module docs, referenced in feature docs

3. **Implementation Order**
   - Follow the [Implementation Order Guide](./modules/implementation_order.md) when implementing the system

## Key Documentation Files

### Architecture Documents (Root Level)

- [Mobile Structure](./mobile_structure.md) - Mobile app architecture
- [Backend Structure](./backend_structure.md) - Backend service architecture
- [Planning and TodoList DDD](./planning_and_todolist_ddd.md) - DDD planning guidelines
- [Features List](./features_list.md) - Complete list of platform features
- [Legacy Migration Decisions](./legacy_migration_decisions.md) - Migration planning

### Module Documentation (`./modules/`)

- Documentation for each DDD bounded context module
- Numbered in implementation order (e.g., `01_identity_access_context.md`)
- Technical details for implementation

### Feature Documentation (`./details/`)

- Feature specifications organized by feature ID
- User stories, requirements, and acceptance criteria
- UI/UX specifications in the `./details/uiux/` subdirectory

## Implementation Guidelines

When implementing features in CareCircle:

1. Start with the numbered module documentation in `./modules/`
2. Reference the feature specifications for user-facing requirements
3. Use the architecture documents to understand system-wide patterns

## For AI Agents

AI agents should focus primarily on the module documentation as it provides implementation-focused technical details. Feature specifications should be consulted for understanding user requirements and acceptance criteria.
