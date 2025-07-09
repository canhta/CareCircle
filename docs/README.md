# CareCircle Documentation

This directory contains all technical documentation for the CareCircle health management platform. The documentation follows Domain-Driven Design (DDD) principles and is structured to minimize duplication while providing clear implementation guidance for AI agents and developers.

## Task Management for AI Agents

**Important:** AI agents must follow the new task management workflow:

1. **Before starting any implementation work**, AI agents must first append corresponding to-do items in the format `[ ]` within a `TODO.md` file located in the relevant bounded context folder
2. **All progress tracking** should be handled directly in repository TODO.md files, not within documentation files
3. **Documentation files** should focus on specifications and requirements, not progress tracking
4. Use the [TODO Template](./TODO_TEMPLATE.md) to create standardized TODO.md files in bounded context directories

## Documentation Structure

The documentation is organized into four main categories following DDD principles:

### 1. Architecture (`./architecture/`)

System-level architecture, design patterns, and technical decisions

- [System Overview](./architecture/system-overview.md) - High-level platform architecture
- [Backend Architecture](./architecture/backend-architecture.md) - Backend service structure
- [Mobile Architecture](./architecture/mobile-architecture.md) - Mobile app architecture
- [Bounded Context Communication](./architecture/bounded-context-communication.md) - Inter-context patterns
- [Legacy Migration Decisions](./architecture/legacy-migration-decisions.md) - Historical decisions

### 2. Bounded Contexts (`./bounded-contexts/`)

Technical implementation specifications for each DDD bounded context

- [01-identity-access/](./bounded-contexts/01-identity-access/) - Authentication and user management
- [02-care-group/](./bounded-contexts/02-care-group/) - Family care coordination
- [03-health-data/](./bounded-contexts/03-health-data/) - Health metrics and device integration
- [04-medication/](./bounded-contexts/04-medication/) - Prescription and medication management
- [05-notification/](./bounded-contexts/05-notification/) - Multi-channel communication
- [06-ai-assistant/](./bounded-contexts/06-ai-assistant/) - Conversational AI and insights

### 3. Features (`./features/`)

User-facing feature specifications that may span multiple bounded contexts

- [Feature Catalog](./features/feature-catalog.md) - Complete feature list
- [AHA-001: AI Health Chat](./features/aha-001-ai-health-chat.md)
- [FCC-001: Care Group Creation](./features/fcc-001-care-group-creation.md)
- [MM-001: Prescription Scanning](./features/mm-001-prescription-scanning.md)
- [NSS-001: AI-Powered Smart Notification](./features/nss-001-ai-powered-smart-notification.md)
- [UM-010: Firebase Authentication](./features/um-010-firebase-authentication.md)

### 4. Planning (`./planning/`)

Implementation roadmaps and project planning

- [Implementation Roadmap](./planning/implementation-roadmap.md) - Development plan by bounded context

### 5. Setup (`./setup/`)

Development environment setup and configuration guides

- [Development Environment Setup](./setup/development-environment.md) - Complete setup guide for backend and mobile

### 6. Design (`./design/`)

UI/UX design system and guidelines with AI-first conversational interface

- [Design System](./design/design-system.md) - Core design principles and healthcare-optimized components
- [AI Assistant Interface](./design/ai-assistant-interface.md) - Conversational UI patterns and AI interaction design
- [Accessibility Guidelines](./design/accessibility-guidelines.md) - Healthcare-specific accessibility requirements
- [User Journeys](./design/user-journeys.md) - Key user flows with AI assistant integration
- [Implementation Guide](./design/implementation-guide.md) - Developer guidelines for design system implementation

## Documentation Principles

### Single Source of Truth

Each piece of information exists in only one authoritative location:

- **Architecture concepts** → `./architecture/` directory
- **Technical implementation** → `./bounded-contexts/` directory
- **User requirements** → `./features/` directory
- **Project planning** → `./planning/` directory

### Cross-Referencing Over Duplication

- Use links to reference information in other documents
- Maintain clear relationships between architecture, implementation, and features
- Update cross-references when moving or renaming files

### DDD-Aligned Organization

- Documentation structure mirrors the system's bounded contexts
- Clear separation between different types of documentation
- Consistent naming conventions using kebab-case

## Implementation Workflow

### For AI Agents

When implementing features:

1. **Start with System Overview** - Review [System Overview](./architecture/system-overview.md)
2. **Select Bounded Context** - Choose from `./bounded-contexts/` directory
3. **Review Technical Specs** - Read the context's README.md
4. **Check Dependencies** - Verify prerequisite contexts are implemented
5. **Plan Tasks** - Add tasks to the context's TODO.md file
6. **Cross-Reference Features** - Link to relevant feature specifications
7. **Track Progress** - Update TODO.md as work progresses

### Implementation Order

Follow the numbered bounded contexts in dependency order:

1. Identity & Access (foundation)
2. Care Group (user relationships)
3. Health Data (core functionality)
4. Medication (health-specific features)
5. Notification (communication layer)
6. AI Assistant (intelligence layer)

## Quick Navigation

### Getting Started

- [Development Environment Setup](./setup/development-environment.md) - Complete setup guide for backend and mobile
- [System Overview](./architecture/system-overview.md) - Start here for platform understanding
- [Implementation Roadmap](./planning/implementation-roadmap.md) - Development plan and phases
- [Documentation Improvements](./architecture/documentation-improvements.md) - Research-based system improvements

### Technical Implementation

- [Backend Architecture](./architecture/backend-architecture.md) - NestJS architecture with healthcare best practices
- [Mobile Architecture](./architecture/mobile-architecture.md) - Flutter architecture with healthcare mobile patterns
- [Logging Architecture](./architecture/logging-architecture.md) - Logging and monitoring architecture
- [Bounded Contexts](./bounded-contexts/README.md) - Technical specifications by context
- [Architecture Overview](./architecture/README.md) - System design and patterns

### Design and User Experience

- [Design System](./design/design-system.md) - AI-first conversational interface and healthcare-optimized components
- [AI Assistant Interface](./design/ai-assistant-interface.md) - Central conversational UI patterns and interaction design
- [Accessibility Guidelines](./design/accessibility-guidelines.md) - WCAG 2.1 AA compliance for healthcare applications
- [User Journeys](./design/user-journeys.md) - Complete user flows with AI assistant integration

### Feature Development

- [Features](./features/README.md) - User-facing functionality specifications
- [Feature Catalog](./features/feature-catalog.md) - Complete feature list

### Setup and Configuration

- [Development Environment](./setup/development-environment.md) - Complete setup guide for backend and mobile
- [Setup Documentation](./setup/README.md) - Overview of all setup guides

### Project Management

- [Planning](./planning/README.md) - Roadmaps and project planning
- [TODO Template](./TODO_TEMPLATE.md) - Task management template
