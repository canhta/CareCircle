# CareCircle Development Environment Setup

This guide provides step-by-step instructions to set up the complete CareCircle development environment, including both backend (NestJS) and mobile (Flutter) components.


## Backend Development Setup (NestJS)

**Core Backend Libraries to Install:**
```bash
# Core NestJS packages
npm install @nestjs/common @nestjs/core @nestjs/platform-express
npm install @nestjs/config @nestjs/jwt @nestjs/passport
npm install @nestjs/terminus @nestjs/bull
npm install @nestjs/cache-manager @nestjs/throttler

# Database and ORM
npm install prisma @prisma/client
npm install pg timescaledb

# Authentication and Security
npm install firebase-admin
npm install passport passport-jwt passport-local
npm install bcryptjs helmet cors

# Validation and Utilities
npm install class-validator class-transformer

# Queue and Caching
npm install bull redis ioredis
npm install @nestjs/bull

# Vector Database
npm install @zilliz/milvus2-sdk-node

# Logging and Monitoring
npm install nestjs-pino pino-http
npm install @nestjs/terminus

# Development Dependencies
npm install -D @types/node @types/express
npm install -D @typescript-eslint/eslint-plugin
npm install -D prettier eslint
npm install -D prisma
```

### 3. Docker Compose Configuration

**Create `docker-compose.dev.yml`:**
```yaml
version: '3.8'

services:
  postgres:
    image: timescale/timescaledb:latest-pg15
    container_name: carecircle-postgres
    environment:
      POSTGRES_DB: carecircle_dev
      POSTGRES_USER: carecircle_user
      POSTGRES_PASSWORD: carecircle_password
      POSTGRES_HOST_AUTH_METHOD: trust
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init-db.sql:/docker-entrypoint-initdb.d/init-db.sql
    networks:
      - carecircle-network

  redis:
    image: redis:7-alpine
    container_name: carecircle-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - carecircle-network

  milvus-etcd:
    container_name: milvus-etcd
    image: quay.io/coreos/etcd:v3.5.5
    environment:
      - ETCD_AUTO_COMPACTION_MODE=revision
      - ETCD_AUTO_COMPACTION_RETENTION=1000
      - ETCD_QUOTA_BACKEND_BYTES=4294967296
      - ETCD_SNAPSHOT_COUNT=50000
    volumes:
      - etcd_data:/etcd
    command: etcd -advertise-client-urls=http://127.0.0.1:2379 -listen-client-urls http://0.0.0.0:2379 --data-dir /etcd
    networks:
      - carecircle-network

  milvus-minio:
    container_name: milvus-minio
    image: minio/minio:RELEASE.2023-03-20T20-16-18Z
    environment:
      MINIO_ACCESS_KEY: minioadmin
      MINIO_SECRET_KEY: minioadmin
    ports:
      - "9001:9001"
      - "9000:9000"
    volumes:
      - minio_data:/minio_data
    command: minio server /minio_data --console-address ":9001"
    networks:
      - carecircle-network

  milvus-standalone:
    container_name: milvus-standalone
    image: milvusdb/milvus:v2.3.0
    command: ["milvus", "run", "standalone"]
    environment:
      ETCD_ENDPOINTS: milvus-etcd:2379
      MINIO_ADDRESS: milvus-minio:9000
    volumes:
      - milvus_data:/var/lib/milvus
    ports:
      - "19530:19530"
      - "9091:9091"
    depends_on:
      - "milvus-etcd"
      - "milvus-minio"
    networks:
      - carecircle-network

volumes:
  postgres_data:
  redis_data:
  etcd_data:
  minio_data:
  milvus_data:

networks:
  carecircle-network:
    driver: bridge
```

### 4. Environment Configuration

**Create `.env.example`:**
```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_URL="postgresql://carecircle_user:carecircle_password@localhost:5432/carecircle_dev"
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USERNAME=carecircle_user
POSTGRES_PASSWORD=carecircle_password
POSTGRES_DATABASE=carecircle_dev

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Milvus Vector Database
MILVUS_HOST=localhost
MILVUS_PORT=19530

# Firebase
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=your-service-account@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_AUTH_URI=https://accounts.google.com/o/oauth2/auth
FIREBASE_TOKEN_URI=https://oauth2.googleapis.com/token

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=your-refresh-secret-key
JWT_REFRESH_EXPIRES_IN=30d

# Monitoring and Logging
LOG_LEVEL=debug

# Rate Limiting
THROTTLE_TTL=60
THROTTLE_LIMIT=100

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_DEST=./uploads

# Health Check
HEALTH_CHECK_TIMEOUT=5000
```

**Copy and configure your environment:**
```bash
cp .env.example .env
# Edit .env with your actual values
```

### 5. Database Setup and Migrations

**Initialize Prisma:**
```bash
npx prisma init
npx prisma generate
```

**Run database migrations:**
```bash
# Start database services
docker-compose -f docker-compose.dev.yml up -d postgres redis

# Run Prisma migrations
npx prisma migrate dev --name init

# Seed database (if seed file exists)
npx prisma db seed
```

### 6. Development Scripts

**Add to `package.json`:**
```json
{
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "db:migrate": "npx prisma migrate dev",
    "db:generate": "npx prisma generate",
    "db:seed": "npx prisma db seed",
    "db:reset": "npx prisma migrate reset",
    "docker:dev": "docker-compose -f docker-compose.dev.yml up -d",
    "docker:down": "docker-compose -f docker-compose.dev.yml down",
    "docker:logs": "docker-compose -f docker-compose.dev.yml logs -f"
  }
}
```

## Mobile Development Setup (Flutter)

### 1. Flutter SDK Installation

**Install Flutter SDK:**
```bash
# macOS
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Add to your shell profile (.bashrc, .zshrc, etc.)
echo 'export PATH="$PATH:/path/to/flutter/bin"' >> ~/.zshrc

# Verify installation
flutter doctor
```

**Install Flutter Version Manager (FVM) - Recommended:**
```bash
dart pub global activate fvm
fvm install 3.16.0
fvm use 3.16.0
```

### 2. Platform-Specific Setup

**Android Setup:**
```bash
# Install Android Studio
# Download from: https://developer.android.com/studio

# Accept Android licenses
flutter doctor --android-licenses

# Set Android SDK path
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**iOS Setup (macOS only):**
```bash
# Install Xcode from App Store
# Install Xcode command line tools
sudo xcode-select --install

# Install CocoaPods
sudo gem install cocoapods
```

### 3. Flutter Dependencies

**Core Flutter packages to add to `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Navigation
  go_router: ^12.1.3
  
  # Network
  dio: ^5.4.0
  retrofit: ^4.0.3
  
  # Local Storage
  flutter_secure_storage: ^9.0.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Authentication
  local_auth: ^2.1.6
  firebase_auth: ^4.15.3
  
  # Health Integration
  health: ^10.1.0
  
  # Notifications
  flutter_local_notifications: ^16.3.2
  
  # UI Components (Design System)
  flutter_hooks: ^0.20.3
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0

  # AI Assistant Interface
  speech_to_text: ^6.6.0
  flutter_tts: ^3.8.5

  # Healthcare UI Components
  fl_chart: ^0.65.0
  percent_indicator: ^4.2.3

  # Design System
  flex_color_scheme: ^7.3.1
  
  # Utilities
  connectivity_plus: ^5.0.2
  permission_handler: ^11.1.0
  package_info_plus: ^4.2.0
  
  # Development
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  retrofit_generator: ^8.0.4
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  
  # Linting
  flutter_lints: ^3.0.1
  
  # Testing
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

**Install dependencies:**
```bash
flutter pub get
flutter pub run build_runner build
```

### 4. Environment Configuration for Flutter

**Create environment configuration files:**

**`lib/core/config/app_config.dart`:**
```dart
abstract class AppConfig {
  static const String appName = 'CareCircle';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
}
```

**Create build flavors configuration:**

**`android/app/build.gradle` (add to android section):**
```gradle
flavorDimensions "environment"
productFlavors {
    development {
        dimension "environment"
        applicationIdSuffix ".dev"
        versionNameSuffix "-dev"
        buildConfigField "String", "API_BASE_URL", '"http://10.0.2.2:3000/api/v1"'
        buildConfigField "String", "ENVIRONMENT", '"development"'
    }
    production {
        dimension "environment"
        buildConfigField "String", "API_BASE_URL", '"https://api.carecircle.com/api/v1"'
        buildConfigField "String", "ENVIRONMENT", '"production"'
    }
}
```

**`ios/Runner/Info.plist` (add configurations):**
```xml
<key>API_BASE_URL</key>
<string>$(API_BASE_URL)</string>
<key>ENVIRONMENT</key>
<string>$(ENVIRONMENT)</string>
```

### 5. Build Scripts and Automation

**Add to `Makefile` or create shell scripts:**

**`scripts/build-android.sh`:**
```bash
#!/bin/bash
set -e

echo "Building Android APK for development..."
flutter build apk --flavor development --dart-define=ENVIRONMENT=development

echo "Building Android APK for production..."
flutter build apk --flavor production --dart-define=ENVIRONMENT=production

echo "Building Android App Bundle for production..."
flutter build appbundle --flavor production --dart-define=ENVIRONMENT=production
```

**`scripts/build-ios.sh`:**
```bash
#!/bin/bash
set -e

echo "Building iOS app for development..."
flutter build ios --flavor development --dart-define=ENVIRONMENT=development

echo "Building iOS app for production..."
flutter build ios --flavor production --dart-define=ENVIRONMENT=production
```

**Add to `pubspec.yaml` scripts section:**
```yaml
scripts:
  build_runner: flutter pub run build_runner build --delete-conflicting-outputs
  build_runner_watch: flutter pub run build_runner watch --delete-conflicting-outputs
  test_coverage: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
  analyze: flutter analyze
  format: dart format .
  clean: flutter clean && flutter pub get
```

## Complete Development Workflow

### 1. Initial Setup

**Clone and setup the complete project:**
```bash
# Clone the repository
git clone <carecircle-repository-url>
cd carecircle

# Setup backend
cd backend
cp .env.example .env
# Edit .env with your configuration
npm install
docker-compose -f docker-compose.dev.yml up -d
npm run db:migrate
npm run start:dev

# Setup mobile (in new terminal)
cd ../mobile
flutter pub get
flutter pub run build_runner build
flutter run --flavor development
```

### 2. Daily Development Commands

**Backend development:**
```bash
# Start all services
npm run docker:dev

# Start backend in watch mode
npm run start:dev

# Run tests
npm run test:watch

# Database operations
npm run db:migrate
npm run db:seed
```

**Mobile development:**
```bash
# Run on development flavor
flutter run --flavor development

# Hot reload is automatic, but for full restart:
# Press 'R' in terminal or 'Ctrl+F5' in VS Code

# Run tests
flutter test

# Generate code
flutter pub run build_runner build
```

### 3. Environment Variables Setup

**Backend `.env` configuration checklist:**
- [ ] Database connection string
- [ ] Redis connection details
- [ ] Firebase service account credentials
- [ ] JWT secrets (generate strong random strings)
- [ ] External API keys (OpenAI, Twilio)
- [ ] Milvus vector database connection

**Mobile environment setup:**
- [ ] API base URL pointing to local backend
- [ ] Firebase configuration files (google-services.json, GoogleService-Info.plist)
- [ ] Platform-specific permissions configured
- [ ] Build flavors configured for dev/prod

## Troubleshooting Common Issues

### Backend Issues

**Database Connection Issues:**
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check database logs
docker logs carecircle-postgres

# Reset database if needed
npm run db:reset
```

**Redis Connection Issues:**
```bash
# Check Redis status
docker ps | grep redis

# Test Redis connection
redis-cli ping
```

**Milvus Vector Database Issues:**
```bash
# Check all Milvus containers
docker ps | grep milvus

# Restart Milvus services
docker-compose -f docker-compose.dev.yml restart milvus-standalone
```

**Node.js/npm Issues:**
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Check Node.js version
node --version  # Should be 18.x or 20.x
```

### Mobile Issues

**Flutter Doctor Issues:**
```bash
# Run Flutter doctor to check setup
flutter doctor -v

# Fix Android license issues
flutter doctor --android-licenses

# Update Flutter
flutter upgrade
```

**iOS Build Issues:**
```bash
# Clean iOS build
cd ios && rm -rf Pods Podfile.lock
flutter clean
flutter pub get
cd ios && pod install
```

**Android Build Issues:**
```bash
# Clean Android build
flutter clean
cd android && ./gradlew clean
flutter pub get
```

**Dependency Issues:**
```bash
# Clear pub cache
flutter pub cache clean

# Get dependencies
flutter pub get

# Regenerate generated files
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Network and API Issues

**CORS Issues:**
- Ensure backend CORS is configured for mobile app origins
- Check if API endpoints are accessible from mobile device/emulator

**SSL/TLS Issues in Development:**
- Use HTTP for local development
- Configure network security policy for Android
- Add ATS exceptions for iOS development

**Firebase Configuration:**
- Verify Firebase project configuration
- Check service account permissions
- Ensure Firebase configuration files are in correct locations

## Additional Resources

### Documentation Links
- [NestJS Documentation](https://docs.nestjs.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Prisma Documentation](https://www.prisma.io/docs/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [TimescaleDB Documentation](https://docs.timescale.com/)
- [Milvus Documentation](https://milvus.io/docs)

### VS Code Extensions
**Backend Development:**
- NestJS Files
- Prisma
- Docker
- Thunder Client (API testing)
- GitLens

**Mobile Development:**
- Flutter
- Dart
- Flutter Intl
- Flutter Tree
- Awesome Flutter Snippets

### Recommended Development Tools
- **API Testing**: Postman or Thunder Client
- **Database Management**: pgAdmin or DBeaver
- **Redis Management**: RedisInsight
- **Mobile Testing**: Android Studio Device Manager, iOS Simulator
- **Version Control**: Git with GitHub Desktop or SourceTree
## Design System Integration

After completing the basic setup, integrate the CareCircle design system for consistent UI/UX implementation:

### Design Documentation Review
**REQUIRED reading before UI development:**

1. **[Design System](../design/design-system.md)** - Core design principles and healthcare-optimized components
2. **[AI Assistant Interface](../design/ai-assistant-interface.md)** - Central conversational UI patterns and AI personality
3. **[Accessibility Guidelines](../design/accessibility-guidelines.md)** - WCAG 2.1 AA compliance for healthcare applications
4. **[User Journeys](../design/user-journeys.md)** - Complete user flows with AI assistant integration
5. **[Implementation Guide](../design/implementation-guide.md)** - Developer guidelines for design system implementation

### Design System Setup for Flutter

**Add design system dependencies to `pubspec.yaml`:**
```yaml
dependencies:
  # Design System Core
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0

  # AI Assistant Interface
  speech_to_text: ^6.6.0
  flutter_tts: ^3.8.5

  # Accessibility
  semantics: ^0.2.0

  # Healthcare UI Components
  fl_chart: ^0.65.0
  percent_indicator: ^4.2.3

  # Design Tokens
  flex_color_scheme: ^7.3.1
```

**Create design system configuration:**
```dart
// lib/core/design/design_tokens.dart
class CareCircleDesignTokens {
  // Healthcare-optimized colors from design system
  static const Color primaryMedicalBlue = Color(0xFF1976D2);
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color criticalAlert = Color(0xFFD32F2F);

  // Accessibility-compliant spacing
  static const double touchTargetMin = 48.0;
  static const double emergencyButtonMin = 56.0;

  // Medical data typography
  static const TextStyle vitalSignsStyle = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );
}
```

### AI Assistant Integration Setup

**Configure AI assistant as central interface:**
```dart
// lib/core/ai/ai_assistant_config.dart
class AIAssistantConfig {
  static const String openAIApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const bool enableVoiceInput = true;
  static const bool enableProactiveNotifications = true;

  // AI personality settings from design documentation
  static const AIPersonality personality = AIPersonality(
    empathetic: true,
    authoritative: true,
    supportive: true,
    transparent: true,
  );
}
```

### Accessibility Setup

**Configure accessibility features:**
```dart
// lib/core/accessibility/accessibility_config.dart
class AccessibilityConfig {
  static const double minimumContrastRatio = 4.5;
  static const double medicalDataContrastRatio = 7.0;
  static const bool enableHighContrastMode = true;
  static const bool enableVoiceControl = true;
  static const bool enableScreenReaderOptimization = true;
}
```

## Next Steps

After completing this setup:

1. **Verify Installation**: Run all health checks and ensure services are running
2. **Review Architecture**: Read the [Backend Architecture](../architecture/backend-architecture.md) and [Mobile Architecture](../architecture/mobile-architecture.md) documents
3. **Study Design System**: Thoroughly review all design documentation before implementing UI components
4. **Implement AI-First Interface**: Follow the [AI Assistant Interface](../design/ai-assistant-interface.md) patterns for conversational navigation
5. **Ensure Accessibility**: Implement [Accessibility Guidelines](../design/accessibility-guidelines.md) from the start
6. **Explore Features**: Check the [Feature Catalog](../features/feature-catalog.md) for implementation priorities
7. **Start Development**: Begin with the [Implementation Roadmap](../planning/implementation-roadmap.md)

For any setup issues not covered in this guide, please check the project's GitHub issues or create a new issue with detailed error information.
