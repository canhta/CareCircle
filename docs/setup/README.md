# CareCircle Setup Documentation

This directory contains comprehensive setup and configuration guides for the CareCircle healthcare platform.

## Complete Setup Guide

### [Development Environment Setup](./development-environment.md)
*Single comprehensive guide for complete CareCircle development environment setup*

**Includes:**

**Backend Setup (NestJS):**
- Node.js and package manager installation
- Core library installations (Prisma, Firebase Admin, Redis, Bull, Milvus)
- Docker Compose configuration for local services
- Environment configuration and database setup
- Development scripts and workflow

**Mobile Setup (Flutter):**
- Flutter SDK installation and version management
- Platform-specific setup (Android SDK, iOS tools)
- Required dependencies and packages
- Build flavors and environment configuration
- Build scripts and automation
- Design System Integration: Healthcare-optimized UI components and AI-first interface setup
- Accessibility Configuration: WCAG 2.1 AA compliance setup for healthcare applications

**Firebase Authentication Setup:**
- Firebase project creation and configuration
- Authentication provider setup (Email/Password, Anonymous, Google, Phone)
- Service account creation and backend configuration
- Mobile app configuration for Android and iOS
- Connection testing and troubleshooting

**Mobile-Backend Connectivity:**
- Automatic setup scripts for local development
- Manual configuration for custom setups
- Network troubleshooting and common issues
- IP address detection and configuration

**Key Features:**
- Step-by-step installation instructions
- Complete Docker Compose setup for all services
- Environment file templates with all required variables
- Design System Integration: Setup for AI-first conversational interface and healthcare-optimized components
- Accessibility Setup: WCAG 2.1 AA compliance configuration for healthcare applications
- Troubleshooting guide for common issues
- Development workflow and daily commands
- VS Code extensions and tool recommendations

## Quick Start

For new developers joining the project:

1. **Prerequisites**: Ensure you have the required system specifications
2. **Follow the Guide**: Complete the [Development Environment Setup](./development-environment.md)
3. **Verify Setup**: Run health checks for all services
4. **Start Development**: Begin with the implementation roadmap

## Services Included

The development environment includes:

### Backend Services
- **PostgreSQL with TimescaleDB**: Primary database for healthcare data
- **Redis**: Caching and session storage
- **Milvus**: Vector database for AI/ML features
- **NestJS Backend**: Main API server

### Development Tools
- **Docker Compose**: Container orchestration for local development
- **Prisma**: Database ORM and migration tool
- **Firebase Admin**: Authentication and cloud services
- **Bull**: Queue management for background tasks

### Mobile Development
- **Flutter SDK**: Cross-platform mobile development
- **Android Studio**: Android development tools
- **Xcode**: iOS development tools (macOS only)
- **Build Flavors**: Separate configurations for dev/production

## Environment Configuration

The setup includes comprehensive environment configuration:

- **Backend**: Complete `.env` template with all required variables
- **Mobile**: Build flavors for development and production environments
- **Docker**: Service configuration for local development
- **Database**: Initialization scripts and migration setup
- **Design System**: Healthcare-optimized color tokens, typography, and accessibility settings
- **AI Assistant**: Conversational interface configuration with voice input/output setup

## Troubleshooting

The development environment guide includes troubleshooting sections for:

- Database connection issues
- Redis and Milvus setup problems
- Flutter doctor and platform-specific issues
- Network and API connectivity problems
- Build and dependency issues

## Additional Resources

- [Backend Architecture](../architecture/backend-architecture.md) - NestJS architecture with best practices
- [Mobile Architecture](../architecture/mobile-architecture.md) - Flutter architecture with healthcare patterns
- [Implementation Roadmap](../planning/implementation-roadmap.md) - Development plan and priorities
- [Feature Catalog](../features/feature-catalog.md) - Complete feature specifications

## Support

For setup issues not covered in the guides:

1. Check the troubleshooting sections in the development environment guide
2. Review the project's GitHub issues for similar problems
3. Create a new issue with detailed error information and system specifications
4. Include relevant logs and configuration details

The setup documentation is designed to get new developers productive quickly while ensuring a consistent development environment across the team.
