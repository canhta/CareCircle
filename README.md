# CareCircle - AI-Powered Health Management Platform

CareCircle is a comprehensive health management platform designed to facilitate family care coordination, medication management, and AI-powered health insights for elderly care and chronic condition management.

## 🏗️ Project Structure

```
CareCircle/
├── backend/           # NestJS backend with healthcare APIs
├── mobile/            # Flutter mobile app with AI assistant
├── docs/              # Comprehensive project documentation
├── scripts/           # Database and deployment scripts
└── docker-compose.dev.yml # Development infrastructure
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- Flutter 3.8+ and Dart
- Docker and Docker Compose
- Git

### 1. Clone and Setup
```bash
git clone <repository-url>
cd CareCircle
```

### 2. Start Infrastructure
```bash
# Start all development services (PostgreSQL, Redis, Milvus)
docker-compose -f docker-compose.dev.yml up -d
```

### 3. Backend Setup
```bash
cd backend
cp .env.example .env
# Edit .env with your configuration (Firebase, OpenAI, etc.)
npm install
npm run db:generate
npm run start:dev
```

### 4. Mobile Setup
```bash
cd mobile
flutter pub get
flutter run --flavor development
```

## 🏥 Healthcare Features

### Core Capabilities
- **AI Health Assistant** - Conversational interface with voice support
- **Family Care Coordination** - Multi-user care group management
- **Medication Management** - OCR prescription scanning and adherence tracking
- **Health Data Integration** - HealthKit/Health Connect device sync
- **Smart Notifications** - AI-powered proactive health alerts

### Technology Stack
- **Backend**: NestJS, TimescaleDB, Redis, Milvus Vector DB
- **Mobile**: Flutter, Riverpod, Firebase Auth
- **AI**: OpenAI integration, speech-to-text, text-to-speech
- **Infrastructure**: Docker, PostgreSQL with TimescaleDB extension

## 📋 Development Status

See [TODO.md](./TODO.md) for overall project progress and [docs/README.md](./docs/README.md) for detailed documentation.

### Current Phase: Foundation Setup ✅
- [x] Development environment configured
- [x] Backend infrastructure running
- [x] Mobile app structure created
- [x] AI assistant framework ready

### Next Phase: Core Implementation
- [ ] Authentication system
- [ ] Database schema design
- [ ] AI assistant integration
- [ ] Health data collection

## 🔧 Development Commands

### Backend
```bash
npm run start:dev      # Start development server
npm run docker:dev     # Start all Docker services
npm run db:migrate     # Run database migrations
npm run build          # Build for production
```

### Mobile
```bash
flutter run --flavor development    # Run development build
flutter analyze                     # Check code quality
```

**JSON Serialization**: Uses modern code generation tools (json_serializable, freezed) for type safety and maintainability

## 📚 Documentation

- **[Complete Documentation](./docs/README.md)** - Architecture, features, and implementation guides
- **[Development Setup](./docs/setup/development-environment.md)** - Detailed setup instructions
- **[System Overview](./docs/architecture/system-overview.md)** - High-level architecture
- **[Design System](./docs/design/design-system.md)** - UI/UX guidelines and components

## 🏛️ Architecture

CareCircle follows Domain-Driven Design (DDD) with 6 bounded contexts:

1. **Identity & Access** - Authentication and user management
2. **Care Group** - Family coordination and role management
3. **Health Data** - Metrics collection and device integration
4. **Medication** - Prescription management and adherence
5. **Notification** - Multi-channel communication system
6. **AI Assistant** - Conversational interface and health insights

## 🔐 Security & Compliance

- HIPAA-compliant data handling
- End-to-end encryption for health data
- Firebase Authentication with MFA support
- Role-based access control for care groups
- Audit logging for all health data access

## 🤝 Contributing

1. Review the [Implementation Roadmap](./docs/planning/implementation-roadmap.md)
2. Check [TODO.md](./TODO.md) for current priorities
3. Follow the [Development Environment Setup](./docs/setup/development-environment.md)
4. Read the [Architecture Documentation](./docs/architecture/README.md)

## 📄 License

[License information to be added]

## 🆘 Support

For setup issues or questions:
1. Check the [Development Environment Setup](./docs/setup/development-environment.md)
2. Review the [Troubleshooting Guide](./docs/setup/development-environment.md#troubleshooting-common-issues)
3. Create an issue with detailed error information
