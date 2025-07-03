# Backend Implementation Plan - NestJS

**Version:** 2.0
**Date:** 2025-07-03

---

## Overview

This document details the backend implementation plan for CareCircle AI Health Agent using NestJS. The backend serves both the mobile app and admin portal, providing REST APIs for all core functionality.

---

## Sprint 0: Project Setup & Core Infrastructure ✅ COMPLETED

### Task 0.1: Initialize NestJS Project Structure ✅
- **Status:** COMPLETED - NestJS project with modular structure has been initialized
- **Next Steps:** Begin implementing authentication and user management modules

### Task 0.2: Dockerize Application ✅  
- **Status:** COMPLETED - Basic Docker setup is in place
- **Next Steps:** Configure production Docker settings and database connections

### Task 0.3: Configure TypeORM ✅
- **Status:** COMPLETED - Database connection foundation is ready
- **Next Steps:** Create entity models and migrations

### Task 0.4: Environment Configuration ✅
- **Status:** COMPLETED - Basic environment setup is done
- **Next Steps:** Add specific environment variables for integrations

### Task 0.5: CI/CD Pipeline
- **Status:** Ready for implementation
- **Priority:** Can be implemented in parallel with feature development

### Task 0.6: Logging & Health Check
- **Status:** Ready for implementation  
- **Priority:** Should be completed early in Sprint 1

---

## Sprint 1: User Authentication & Profiles

### Task 1.1: User Entity & Migration
- **Objective:** Define core user data structure
- **Entity fields:**
  ```typescript
  @Entity('users')
  export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true })
    email: string;

    @Column({ nullable: true })
    password: string;

    @Column()
    firstName: string;

    @Column()
    lastName: string;

    @Column({ nullable: true })
    dateOfBirth: Date;

    @Column({ type: 'enum', enum: Gender, nullable: true })
    gender: Gender;

    @Column({ nullable: true })
    phoneNumber: string;

    @Column({ nullable: true })
    profilePicture: string;

    @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
    role: UserRole;

    @Column({ default: true })
    isActive: boolean;

    @Column({ default: false })
    emailVerified: boolean;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn()
    updatedAt: Date;
  }
  ```

### Task 1.2: Email/Password Authentication
- **Objective:** Implement traditional auth flow
- **Dependencies:** `@nestjs/jwt`, `@nestjs/passport`, `passport-local`, `bcrypt`
- **Endpoints:**
  - `POST /auth/register`
  - `POST /auth/login`
  - `POST /auth/forgot-password`
  - `POST /auth/reset-password`
- **Implementation:**
  - Hash passwords with bcrypt
  - Generate JWT tokens
  - Implement email verification flow

### Task 1.3: Social Authentication (Google & Apple)
- **Objective:** Enable SSO capabilities
- **Dependencies:** `passport-google-oauth20`, `passport-apple`
- **Endpoints:**
  - `GET /auth/google`
  - `GET /auth/google/callback`
  - `POST /auth/apple`
- **Implementation:**
  - Configure OAuth strategies
  - Handle user creation/linking
  - Return JWT tokens

### Task 1.4: User Profile Management
- **Objective:** CRUD operations for user profiles
- **Endpoints:**
  - `GET /users/me` - Get current user profile
  - `PATCH /users/me` - Update profile
  - `POST /users/me/avatar` - Upload profile picture
  - `DELETE /users/me` - Soft delete account

### Task 1.5: Role-Based Access Control (RBAC)
- **Objective:** Implement authorization guards
- **Roles:** `ADMIN`, `USER`
- **Implementation:**
  - `@Roles()` decorator
  - `RolesGuard`
  - JWT payload includes user role

### Task 1.6: Admin User Management APIs
- **Objective:** Admin portal backend support
- **Endpoints:**
  - `GET /admin/users` - List users with pagination/filtering
  - `GET /admin/users/:id` - Get user details
  - `PATCH /admin/users/:id` - Update user (admin only)
  - `DELETE /admin/users/:id` - Deactivate user
  - `GET /admin/stats` - System statistics

---

## Sprint 2: Health Data Integration

### Task 2.1: Health Data Entity
- **Objective:** Time-series optimized health data storage
- **Entity design:**
  ```typescript
  @Entity('health_data')
  export class HealthData {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User)
    user: User;

    @Column()
    dataType: HealthDataType; // STEPS, HEART_RATE, SLEEP, etc.

    @Column('decimal', { precision: 10, scale: 2 })
    value: number;

    @Column({ nullable: true })
    unit: string;

    @Column()
    recordedAt: Date;

    @Column({ nullable: true })
    source: string; // Apple Health, Google Fit, Manual

    @CreateDateColumn()
    createdAt: Date;
  }
  ```

### Task 2.2: Health Data Ingestion API
- **Objective:** Bulk data import from mobile apps
- **Endpoints:**
  - `POST /health-data/batch` - Bulk upload health data
  - `GET /health-data` - Query health data with filters
  - `GET /health-data/summary` - Aggregated health metrics
- **Implementation:**
  - Validate data format and ranges
  - Handle duplicate detection
  - Batch insert optimization

### Task 2.3: TimescaleDB Integration
- **Objective:** Optimize for time-series data
- **Implementation:**
  - Create hypertables for health_data
  - Implement data retention policies
  - Create aggregation views for common queries
  - Add proper indexing for time-based queries

---

## Sprint 3: Medication Management

### Task 3.1: Medication Entities
- **Objective:** Define medication and scheduling data models
- **Entities:**
  ```typescript
  @Entity('medications')
  export class Medication {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User)
    user: User;

    @Column()
    name: string;

    @Column({ nullable: true })
    dosage: string;

    @Column({ nullable: true })
    instructions: string;

    @Column({ nullable: true })
    sideEffects: string;

    @Column({ default: true })
    isActive: boolean;

    @OneToMany(() => MedicationSchedule, schedule => schedule.medication)
    schedules: MedicationSchedule[];
  }

  @Entity('medication_schedules')
  export class MedicationSchedule {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => Medication)
    medication: Medication;

    @Column('time')
    time: string;

    @Column('simple-array')
    daysOfWeek: number[]; // 0-6, Sunday-Saturday

    @Column({ default: true })
    isActive: boolean;
  }
  ```

### Task 3.2: Medication CRUD APIs
- **Objective:** Manual medication management
- **Endpoints:**
  - `GET /medications` - List user medications
  - `POST /medications` - Add new medication
  - `PATCH /medications/:id` - Update medication
  - `DELETE /medications/:id` - Remove medication
  - `POST /medications/:id/schedules` - Add schedule
  - `PATCH /schedules/:id` - Update schedule

### Task 3.3: OCR Integration
- **Objective:** Extract text from prescription images
- **Dependencies:** Google Cloud Vision API
- **Endpoints:**
  - `POST /medications/ocr` - Upload image and extract text
- **Implementation:**
  - Image validation and processing
  - Call Google Vision API
  - Return extracted text for parsing

### Task 3.4: NLP Medication Parser
- **Objective:** Parse medication details from OCR text
- **Implementation:**
  - Rule-based parsing for common patterns
  - Drug name recognition using external drug databases
  - Dosage and frequency extraction
  - Confidence scoring for extracted data

---

## Sprint 4: Reminders & Notifications

### Task 4.1: Push Notification Setup
- **Objective:** Configure FCM and APNs
- **Dependencies:** `@nestjs/firebase-admin`
- **Implementation:**
  - Firebase Admin SDK configuration
  - Device token management
  - Message formatting for different platforms

### Task 4.2: Reminder Scheduler
- **Objective:** Automated medication reminders
- **Dependencies:** `@nestjs/schedule`, `node-cron`
- **Implementation:**
  - Cron jobs for checking due medications
  - Queue system for notification delivery
  - Retry logic for failed notifications

### Task 4.3: Adherence Tracking
- **Objective:** Track medication compliance
- **Endpoints:**
  - `POST /medications/:id/adherence` - Log medication taken/missed
  - `GET /medications/:id/adherence` - Get adherence history
- **Entity:**
  ```typescript
  @Entity('medication_adherence')
  export class MedicationAdherence {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => Medication)
    medication: Medication;

    @ManyToOne(() => User)
    user: User;

    @Column()
    scheduledTime: Date;

    @Column({ nullable: true })
    takenTime: Date;

    @Column()
    status: AdherenceStatus; // TAKEN, MISSED, SNOOZED

    @CreateDateColumn()
    createdAt: Date;
  }
  ```

### Task 4.4: Escalation Logic
- **Objective:** Notify caregivers of missed medications
- **Implementation:**
  - Track missed medication count
  - Trigger caregiver notifications after threshold
  - Configurable escalation rules per user

---

## Sprint 5: Care Groups & Data Sharing

### Task 5.1: Care Group Entities
- **Objective:** Define family/caregiver relationships
- **Entities:**
  ```typescript
  @Entity('care_groups')
  export class CareGroup {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    name: string;

    @ManyToOne(() => User)
    owner: User;

    @Column({ unique: true })
    inviteCode: string;

    @OneToMany(() => GroupMembership, membership => membership.group)
    memberships: GroupMembership[];

    @CreateDateColumn()
    createdAt: Date;
  }

  @Entity('group_memberships')
  export class GroupMembership {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => CareGroup)
    group: CareGroup;

    @ManyToOne(() => User)
    user: User;

    @Column()
    role: MemberRole; // OWNER, CAREGIVER, MEMBER

    @Column()
    status: MembershipStatus; // PENDING, ACTIVE, REMOVED

    @CreateDateColumn()
    joinedAt: Date;
  }
  ```

### Task 5.2: Invitation System
- **Objective:** Secure group joining mechanism
- **Endpoints:**
  - `POST /care-groups` - Create new group
  - `POST /care-groups/:id/invites` - Generate invite link
  - `POST /care-groups/join/:code` - Join group via code
- **Implementation:**
  - Generate secure, time-limited invite codes
  - Email invitation system
  - Deep link handling

### Task 5.3: Member Management
- **Objective:** Manage group memberships
- **Endpoints:**
  - `GET /care-groups/:id/members` - List group members
  - `PATCH /care-groups/:id/members/:userId` - Update member role
  - `DELETE /care-groups/:id/members/:userId` - Remove member
  - `POST /care-groups/:id/members/:userId/approve` - Approve pending member

### Task 5.4: Data Sharing Logic
- **Objective:** Control what data is shared within groups
- **Implementation:**
  - Basic consent model (all or nothing for MVP)
  - Filter APIs to respect sharing permissions
  - Audit trail for data access

---

## Sprint 6: MVP Polish & Deployment

### Task 6.1: Production Deployment
- **Objective:** Deploy to production environment
- **Infrastructure:**
  - Container orchestration (Docker Swarm/Kubernetes)
  - Load balancer configuration
  - SSL certificate setup
  - Database backup strategy

### Task 6.2: Security Review
- **Objective:** Address security vulnerabilities
- **Checklist:**
  - Input validation and sanitization
  - SQL injection prevention
  - Authentication and authorization
  - Rate limiting
  - CORS configuration
  - Data encryption at rest and in transit

---

## Phase 2: Post-MVP Enhancements

### Sprint 7: Monetization & Subscriptions

### Task 7.1: Feature Flagging
- **Objective:** Tier-based feature access
- **Implementation:**
  - Feature flag service
  - Subscription tier definitions
  - API endpoint decorators for premium features

### Task 7.2: Payment Integration
- **Objective:** Stripe integration for subscriptions
- **Dependencies:** `stripe`
- **Endpoints:**
  - `POST /subscriptions/create` - Create subscription
  - `POST /subscriptions/cancel` - Cancel subscription
  - `POST /webhooks/stripe` - Handle subscription events

### Task 7.3: Subscription Webhooks
- **Objective:** Handle payment lifecycle events
- **Implementation:**
  - Webhook signature verification
  - User subscription status updates
  - Grace period handling

### Task 7.4: Referral System
- **Objective:** Track user referrals
- **Endpoints:**
  - `POST /referrals/generate` - Generate referral code
  - `GET /referrals/stats` - User referral statistics

### Sprint 8: AI-Powered Features

### Task 8.1: Adaptive Notification Engine
- **Objective:** Personalized notification timing and content
- **Implementation:**
  - User interaction tracking
  - Rule-based adaptation algorithm
  - A/B testing framework for notification strategies

### Task 8.2: LLM Integration
- **Objective:** AI-generated health insights
- **Dependencies:** OpenAI API or similar
- **Endpoints:**
  - `POST /ai/health-summary` - Generate health summary
  - `POST /ai/medication-insights` - Medication recommendations

### Task 8.3: RAG Pipeline for Drug Information
- **Objective:** AI-powered drug information queries
- **Implementation:**
  - Vector database setup (Pinecone/Chroma)
  - Drug information ingestion pipeline
  - Semantic search capabilities

### Sprint 9: Gamification

### Task 9.1: Health Points & Badges
- **Objective:** Reward system for user engagement
- **Entities:**
  ```typescript
  @Entity('user_points')
  export class UserPoints {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User)
    user: User;

    @Column()
    points: number;

    @Column()
    action: string; // medication_taken, health_data_synced, etc.

    @CreateDateColumn()
    earnedAt: Date;
  }

  @Entity('user_badges')
  export class UserBadge {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User)
    user: User;

    @Column()
    badgeType: BadgeType;

    @CreateDateColumn()
    earnedAt: Date;
  }
  ```

### Task 9.2: Achievement APIs
- **Objective:** Track and award achievements
- **Endpoints:**
  - `GET /gamification/points` - User points summary
  - `GET /gamification/badges` - User badges
  - `POST /gamification/daily-checkin` - Daily check-in

### Sprint 10: Advanced Features

### Task 10.1: Granular Data Sharing
- **Objective:** Fine-grained sharing controls
- **Implementation:**
  - Field-level permissions
  - Time-limited sharing
  - Consent management system

### Task 10.2: E-Pharmacy Integration
- **Objective:** Partner API for medication refills
- **Endpoints:**
  - `GET /pharmacy/partners` - List partner pharmacies
  - `POST /pharmacy/refill-request` - Request medication refill
  - `GET /pharmacy/orders` - Track refill orders

---

## Testing Strategy

### Unit Tests
- Service layer tests with mocked dependencies
- Repository pattern tests
- Guard and interceptor tests
- Target: 80% code coverage

### Integration Tests
- API endpoint tests
- Database integration tests
- External service integration tests

### Performance Tests
- Load testing for high-traffic endpoints
- Database query optimization
- Memory leak detection

### Security Tests
- Authentication bypass attempts
- SQL injection testing
- Rate limiting validation
- Data access authorization tests

## Implementation Status & Next Steps

### Current Status
- ✅ **Project Setup Complete** - NestJS project with modular structure initialized
- ✅ **Basic Structure** - Module structure and core folders established
- ✅ **Docker Foundation** - Basic containerization setup complete
- ✅ **Database Foundation** - TypeORM and environment configuration ready

### Immediate Next Steps (Sprint 1)
1. **Complete Logging & Health Check** - Implement observability endpoints
2. **User Entity & Migration** - Create user data model and database schema
3. **Authentication Module** - JWT, email/password, and OAuth implementation
4. **Admin APIs** - User management endpoints for admin portal
5. **Role-Based Access Control** - Implement RBAC guards and decorators

### Dependencies to Install
```bash
# Authentication & Authorization
npm install @nestjs/jwt @nestjs/passport passport passport-local passport-jwt passport-google-oauth20 bcrypt

# Database & ORM
npm install @nestjs/typeorm typeorm pg @types/pg

# Configuration & Validation
npm install @nestjs/config class-validator class-transformer

# Logging & Health
npm install winston @nestjs/terminus

# Testing
npm install --save-dev @nestjs/testing jest supertest
```
