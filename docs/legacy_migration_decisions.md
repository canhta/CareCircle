# Legacy Documentation Migration Decisions

This document summarizes key architectural and implementation decisions that have been migrated from the legacy documentation to the current documentation structure. It serves as a reference for understanding the rationale behind certain design choices and ensures that valuable insights from earlier planning phases are preserved.

## Authentication Strategy

### Decision: Migrate from JWT to Firebase Auth with Guest Login

**Legacy Documentation Source:** `legacy/auth/FIREBASE_AUTH_REFACTORING.md`, `legacy/MOBILE_TODO.md`

**Implementation Details:**

- Replace custom JWT authentication with Firebase Authentication
- Implement anonymous authentication for guest mode
- Create device-based account tracking to prevent multiple guest accounts
- Develop account linking system for guest-to-registered conversion
- Ensure data migration during account conversion
- Implement secure token storage and refresh mechanisms
- Add offline authentication support

**Benefits:**

- Unified authentication across platforms (mobile, web, backend)
- Simplified social authentication (Google, Apple)
- Enhanced security with Firebase's robust implementation
- Better user experience with guest exploration mode
- Reduced development and maintenance effort

**Current Documentation:** [Firebase Authentication System](./details/feature_UM-010.md)

## AI Agent Implementation

### Decision: Hybrid AI Approach with Firebase Gemini and Local Fallbacks

**Legacy Documentation Source:** `legacy/agent/AI_AGENT_COMPARISON.md`, `legacy/agent/FIREBASE_AI_IMPLEMENTATION_PLAN.md`

**Implementation Details:**

- Primary implementation using Firebase AI Services (Gemini)
- Secondary/fallback implementation using on-device processing
- Secure handling of PHI data with proper sanitization
- Implementation of both chat and text-to-speech capabilities
- Conversation context management and storage
- Multi-language support (Vietnamese and English)

**Benefits:**

- Balance of implementation complexity, quality, and cost
- Better performance in areas with inconsistent connectivity
- Enhanced privacy protection for sensitive health data
- Seamless integration with existing Firebase services
- Reduced operational costs compared to direct OpenAI integration

**Current Documentation:** [AI Agent Implementation Options](./details/technical_ai_agent_implementation.md), [AI Health Chat](./details/feature_AHA-001.md)

## Backend Architecture

### Decision: Modular Monolith with Microservices Pathway

**Legacy Documentation Source:** `legacy/BACKEND_IMPLEMENTATION.md`, `legacy/BACKEND_TODO.md`

**Implementation Details:**

- NestJS framework with TypeScript
- Domain-Driven Design with bounded contexts
- Clean Architecture with layered approach
- PostgreSQL with TimescaleDB for time-series health data
- Milvus vector database for AI feature vectors
- BullMQ for background processing and queues
- Comprehensive health monitoring and logging

**Benefits:**

- Faster initial development with monolithic approach
- Clear path to microservices when scaling needs emerge
- Proper isolation of domains through bounded contexts
- Optimized database for health-specific time-series data
- Strong security and compliance controls

**Current Documentation:** [Backend Structure](./backend_structure.md)

## Notification System

### Decision: AI-Powered Smart Notification System with Multi-Armed Bandit Algorithm

**Legacy Documentation Source:** `legacy/BACKEND_IMPLEMENTATION.md`, `legacy/FRONTEND_IMPLEMENTATION.md`

**Implementation Details:**

- Multi-armed bandit algorithm for notification optimization
- Personalization engine for content customization
- Adaptive timing based on user behavior
- A/B testing framework for continuous improvement
- Cultural adaptation for Southeast Asian markets

**Benefits:**

- Improved user engagement through personalized notifications
- Reduced notification fatigue with optimal timing
- Higher conversion rates through contextual messaging
- Enhanced user experience with culturally appropriate content
- Data-driven optimization through continuous learning

**Current Documentation:** [AI-Powered Smart Notification System](./details/feature_NSS-001.md)

## Mobile Architecture

### Decision: Feature-First Architecture with Riverpod State Management

**Legacy Documentation Source:** `legacy/MOBILE_IMPLEMENTATION.md`, `legacy/MOBILE_TODO.md`

**Implementation Details:**

- Flutter framework with Dart
- Riverpod for declarative state management
- Feature-first project organization
- Health Connect and HealthKit integration
- Offline-first data synchronization
- Result-based error handling pattern

**Benefits:**

- Better code organization and separation of concerns
- Simplified testing and maintenance
- Enhanced performance with optimized state management
- Improved user experience with offline support
- Consistent error handling across the application

**Current Documentation:** [Mobile Structure](./mobile_structure.md)

## Healthcare Compliance

### Decision: HIPAA-Inspired Security Controls with Regional Adaptations

**Legacy Documentation Source:** `legacy/BACKEND_IMPLEMENTATION.md`, `legacy/PRD.md`

**Implementation Details:**

- End-to-end encryption for health data
- Field-level encryption for sensitive PHI
- Comprehensive audit logging for all PHI access
- Role-based access control with fine-grained permissions
- Compliance with Vietnam's Decree 13/2022/ND-CP

**Benefits:**

- Protection of sensitive health information
- Compliance with regional regulations
- Preparation for potential future international expansion
- Building user trust through strong security measures
- Reduction of security incident risks

**Current Documentation:** [Backend Structure - Data Protection and Compliance](./backend_structure.md#7-data-protection-and-compliance)

## Admin Portal

### Decision: Next.js-Based Admin Portal with Advanced Analytics

**Legacy Documentation Source:** `legacy/FRONTEND_IMPLEMENTATION.md`, `legacy/FRONTEND_TODO.md`

**Implementation Details:**

- Next.js 15 with App Router architecture
- Tailwind CSS for styling
- Role-based access control for administrators
- Advanced analytics dashboards
- AI service monitoring
- User management tools

**Benefits:**

- Modern, responsive admin interface
- Comprehensive system monitoring capabilities
- Improved operational efficiency
- Enhanced security with role-based access
- Better insights into system performance and usage

**Current Documentation:** _Planned for future documentation update_

## Implementation Phasing

### Decision: Feature-Based Phased Implementation

**Legacy Documentation Source:** `legacy/BACKEND_TODO.md`, `legacy/MOBILE_TODO.md`

**Implementation Details:**

- Phase 1: Core Infrastructure & Foundation
- Phase 2: AI & Notification Systems
- Phase 3: Enhanced Features & Integration
- Phase 4: Performance Optimization & Scaling

**Benefits:**

- Faster time-to-market with MVP features
- Risk reduction through incremental development
- Better resource allocation
- Improved quality through focused implementation
- Earlier user feedback for core features

**Current Documentation:** [Planning and Todo List](./planning_and_todolist_ddd.md)

## Cross-Platform Integration

### Decision: Standardized API Contracts and Authentication

**Legacy Documentation Source:** `legacy/BACKEND_TODO.md`, `legacy/MOBILE_TODO.md`

**Implementation Details:**

- Standardized API contracts between backend and mobile
- Unified authentication strategy with Firebase
- Consistent error handling and response formats
- Comprehensive API documentation
- Integration testing across platforms

**Benefits:**

- Reduced integration issues
- Improved developer productivity
- Consistent user experience across platforms
- Faster debugging and issue resolution
- Better collaboration between backend and mobile teams

**Current Documentation:** [Backend Structure](./backend_structure.md), [Mobile Structure](./mobile_structure.md)

## UI/UX Documentation Approach

### Decision: Separation of Functional and Visual Documentation

**Legacy Documentation Source:** Various legacy documentation

**Implementation Details:**

- Textual mockups for functional descriptions
- Visual designs for visual representation
- Clear guidelines for creating UI/UX documentation
- Consistent naming conventions
- Cross-referencing between functional and visual documentation

**Benefits:**

- Clear communication of functional requirements
- Separation of concerns between functionality and visual design
- Better collaboration between designers and developers
- Reduced ambiguity in requirements
- Easier maintenance of documentation

**Current Documentation:** [UI/UX Textual Mockup Guidelines](./details/uiux_textual_mockup_guidelines.md)
