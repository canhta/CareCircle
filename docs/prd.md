# Product Requirements Document: CareCircle AI Health Agent

**Version:** 1.0
**Date:** 2025-07-03

---

## 1. Technical Architecture Overview

### 1.1. System Components
CareCircle consists of three main applications:

1. **Backend API** (NestJS + PostgreSQL + Prisma)
2. **Admin Web Portal** (Next.js + TypeScript)
3. **Mobile Application** (Flutter + Dart)

### 1.2. Development Principles
- **MVP-First Approach**: Focus on core functionality over comprehensive tooling
- **Manual Quality Assurance**: Emphasize code reviews and manual testing
- **Rapid Iteration**: Prioritize speed of development and deployment
- **Production Monitoring**: Rely on logging and error tracking for quality insights

---

## 2. Backend Services (NestJS)

### 2.1. Core Modules
- **Authentication Module**: JWT-based auth with Google/Apple SSO
- **User Management Module**: Profile and settings management
- **Health Data Module**: Integration with HealthKit/Google Fit
- **Prescription Module**: OCR processing and medication management
- **Notification Module**: Smart reminders and alerts
- **Care Group Module**: Family network and permissions
- **AI Services Module**: RAG-based insights and summaries

### 2.2. Database Schema (Prisma)
```prisma
// Core entities: User, HealthRecord, Prescription, CareGroup, Notification
// Relationships: Many-to-many for care groups, one-to-many for prescriptions
```

### 2.3. API Design
- RESTful endpoints with proper HTTP status codes
- JWT authentication for protected routes
- Rate limiting and request validation
- Comprehensive error handling and logging

### 2.4. Quality Assurance
- **No automated tests** - focus on manual testing
- **Code reviews** required for all PRs
- **TypeScript** for type safety
- **ESLint** for code consistency
- **Prisma** for database type safety

---

## 3. Frontend Applications

### 3.1. Admin Web Portal (Next.js)
- **Technology Stack**: Next.js 15, TypeScript, Tailwind CSS
- **Key Features**:
  - System health monitoring dashboard
  - User management and support tools
  - AI cost monitoring and analytics
  - Marketing metrics and insights

### 3.2. Mobile Application (Flutter)
- **Technology Stack**: Flutter, Dart, Firebase
- **Key Features**:
  - Cross-platform iOS/Android support
  - Native health data integration
  - OCR prescription scanning
  - Push notifications
  - Offline functionality

---

## 4. Development Workflow

### 4.1. Code Quality Standards
- **Mandatory Code Reviews**: All code changes require peer review
- **TypeScript/Dart**: Strong typing for error reduction
- **Linting**: ESLint for JavaScript/TypeScript, Dart Analyzer for Flutter
- **Git Flow**: Feature branches with PR-based merges

### 4.2. Manual Testing Strategy
1. **Feature Testing**: Test each feature thoroughly before code review
2. **Integration Testing**: Manual verification of API integrations
3. **User Journey Testing**: Test complete user workflows manually
4. **Cross-Platform Testing**: Verify mobile app on both iOS and Android
5. **Edge Case Testing**: Test error conditions and edge cases

### 4.3. Deployment & Monitoring
- **Staging Environment**: Manual testing before production
- **Production Monitoring**: Comprehensive logging and error tracking
- **Gradual Rollout**: Feature flags for controlled releases
- **User Feedback**: Direct channels for bug reports and issues

---

## 5. API Specifications

### 5.1. Authentication Endpoints
```
POST /auth/register
POST /auth/login
POST /auth/google
POST /auth/apple
POST /auth/refresh
```

### 5.2. User Management
```
GET /users/profile
PUT /users/profile
GET /users/settings
PUT /users/settings
```

### 5.3. Health Data
```
POST /health/sync
GET /health/records
GET /health/summary
```

### 5.4. Prescriptions
```
POST /prescriptions/ocr
POST /prescriptions
GET /prescriptions
PUT /prescriptions/:id
DELETE /prescriptions/:id
```

### 5.5. Care Groups
```
POST /care-groups
GET /care-groups
POST /care-groups/:id/invite
PUT /care-groups/:id/member/:userId
```

### 5.6. Notifications
```
GET /notifications
PUT /notifications/:id/read
GET /notifications/settings
PUT /notifications/settings
```

---

## 6. Data Models

### 6.1. User Model
```typescript
interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  dateOfBirth: Date;
  gender: Gender;
  emergencyContacts: EmergencyContact[];
  settings: UserSettings;
  createdAt: Date;
  updatedAt: Date;
}
```

### 6.2. Health Record Model
```typescript
interface HealthRecord {
  id: string;
  userId: string;
  type: HealthDataType;
  value: number;
  unit: string;
  timestamp: Date;
  source: DataSource;
}
```

### 6.3. Prescription Model
```typescript
interface Prescription {
  id: string;
  userId: string;
  medicationName: string;
  dosage: string;
  frequency: string;
  startDate: Date;
  endDate?: Date;
  reminders: Reminder[];
  isActive: boolean;
}
```

---

## 7. Security & Privacy

### 7.1. Data Protection
- **Encryption**: All sensitive data encrypted at rest and in transit
- **GDPR Compliance**: User consent and data deletion capabilities
- **Vietnam Compliance**: Adherence to Decree 13/2022
- **Medical Data**: HIPAA-inspired protections for health information

### 7.2. Authentication & Authorization
- **JWT Tokens**: Secure, stateless authentication
- **Role-Based Access**: Patient, Caregiver, Admin roles
- **OAuth Integration**: Google and Apple Sign-In
- **Session Management**: Secure token refresh and logout

---

## 8. Performance Requirements

### 8.1. Response Times
- **API Responses**: < 200ms for standard operations
- **OCR Processing**: < 5 seconds for prescription scanning
- **Health Data Sync**: < 30 seconds for daily sync
- **Mobile App Launch**: < 3 seconds cold start

### 8.2. Scalability
- **Concurrent Users**: Support 1000+ concurrent users
- **Data Volume**: Handle 100K+ health records per user
- **Geographic Distribution**: Primary focus on Vietnam/SEA

---

## 9. Integration Requirements

### 9.1. Health Platforms
- **Apple HealthKit**: iOS health data integration
- **Google Fit**: Android health data integration
- **CSV Import**: Manual lab result uploads

### 9.2. Third-Party Services
- **Firebase**: Push notifications and analytics
- **OCR Service**: Prescription text extraction
- **AI/NLP**: OpenAI or equivalent for insights
- **Payment**: MoMo, ZaloPay for subscriptions

---

## 10. Development Milestones

### 10.1. Phase 1: Foundation (Weeks 1-4)
- ✅ Project setup and infrastructure
- ✅ Remove testing infrastructure (completed)
- User authentication and basic profile management
- Database schema implementation

### 10.2. Phase 2: Core Features (Weeks 5-8)
- Health data integration (HealthKit/Google Fit)
- OCR prescription scanning
- Basic medication reminders

### 10.3. Phase 3: Family Features (Weeks 9-12)
- Care group creation and management
- Family dashboard and notifications
- Admin portal development

### 10.4. Phase 4: Intelligence (Weeks 13-16)
- AI-powered insights and summaries
- Advanced notification system
- User settings and personalization

### 10.5. Phase 5: Polish & Launch (Weeks 17-20)
- Mobile app optimization
- Production deployment
- User feedback integration
- Launch preparation

---

## 11. Success Metrics

### 11.1. Technical Metrics
- **API Uptime**: 99.9%
- **App Crash Rate**: < 0.1%
- **Response Time**: < 200ms average
- **User Onboarding**: < 5 minutes

### 11.2. Business Metrics
- **User Acquisition**: 1000+ registered users in first 3 months
- **Engagement**: 70%+ daily active users
- **Retention**: 60%+ 30-day retention
- **Medication Adherence**: 80%+ reminder completion rate

---

*This PRD reflects our MVP-first approach without automated testing infrastructure, focusing on rapid development and manual quality assurance.*
