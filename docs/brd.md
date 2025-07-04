# Business Requirements Document: CareCircle AI Health Agent

**Version:** 2.0
**Date:** January 2025
**Document Status:** Updated to align with PRD v2.0

---

## 1. Introduction

### 1.1. Project Overview

CareCircle is a comprehensive AI-powered health management platform designed to revolutionize family-centered healthcare. The ecosystem consists of three integrated components:

1. **Cross-Platform Mobile Application** (Flutter/Dart): Primary user interface for patients and caregivers, featuring AI-powered medication management, health monitoring, and family coordination tools.

2. **Advanced Backend Infrastructure** (NestJS/TypeScript): Robust API services with microservices architecture, implementing advanced AI/LLM capabilities, vector databases, and real-time analytics.

3. **Administrative Web Portal** (Next.js/React): Comprehensive dashboard for system administration, user management, analytics, and AI service monitoring.

The platform leverages cutting-edge AI technologies including OpenAI's GPT models, Milvus vector database, and sophisticated behavioral analysis engines to deliver personalized health insights and adaptive user experiences. Built with modern technologies and best practices, CareCircle represents the next generation of digital health solutions tailored specifically for Southeast Asian markets.

### 1.2. Business Problem

The global healthcare landscape faces critical challenges that are particularly acute in emerging markets like Vietnam and Southeast Asia:

**Market Fragmentation**: Existing digital health solutions operate in silos, with separate apps for doctor booking, pharmacy services, basic health tracking, and family communication. This fragmentation creates user friction and prevents comprehensive health management.

**Aging Population Crisis**: Southeast Asia's rapidly aging population (65+ demographic growing at 3.7% annually) creates unprecedented demand for innovative eldercare solutions, while traditional family care structures struggle to adapt to modern lifestyles.

**Medication Adherence Gap**: Studies show that medication non-adherence affects 40-60% of patients with chronic conditions, leading to increased healthcare costs and preventable complications. Current solutions lack intelligent, personalized approaches to address this challenge.

**Family Care Coordination**: Modern families are geographically dispersed, making traditional caregiving models inadequate. Caregivers lack effective tools for remote monitoring and coordination, creating stress and suboptimal health outcomes.

**Healthcare Accessibility**: Limited access to healthcare professionals in rural and underserved areas creates a gap that digital health solutions can bridge through AI-powered insights and remote monitoring capabilities.

**Cultural Context**: Western-designed health apps often fail to consider Asian family dynamics, cultural preferences, and local healthcare systems, creating adoption barriers in target markets.

### 1.3. Project Goals & Objectives

The primary goal of CareCircle is to empower users to take control of their health and facilitate collaborative care within families.

**Business Objectives:**

- Establish CareCircle as the leading family-centric health management platform in Vietnam and Southeast Asia.
- Achieve sustainable revenue through a freemium subscription model and strategic B2B partnerships.
- Reduce the burden on family caregivers by providing tools for remote monitoring and automated alerts.

**Project Objectives:**

1.  **Actionable Health Data**: Sync and normalize data from Apple Health (iOS) and Google Fit (Android), transforming it into a source of actionable insights and alerts for the entire family.
2.  **AI-powered Medication Management**: Automate the intake and scheduling of medications by scanning paper prescriptions using OCR and NLP.
3.  **Personalized Engagement**: Deliver intelligent reminders, daily check-ins, and AI-driven health summaries to keep users engaged and informed.
4.  **Family Health Network**: Enable users to create "care groups" to share real-time health status, alerts, and coordinate care for loved ones.
5.  **Actionable Insights**: Provide users with AI-powered summaries, trend analysis, and coaching tips for their activity and health data.

### 1.4. Unique Selling Proposition (USP)

CareCircle's differentiation lies in its position as the **World's First Family-Centric AI Health Agent** specifically designed for Asian markets. Our competitive advantages include:

#### **1. Advanced AI-Powered Behavioral Engine**

- **Proprietary LLM Integration**: Unique combination of OpenAI's GPT models with Milvus vector database for intelligent behavior analysis and personalized health insights
- **Adaptive Notification System**: Dynamic learning algorithm that optimizes reminder timing, tone, and content based on individual user behavior patterns
- **Predictive Health Analytics**: AI-driven trend analysis and early warning systems for potential health issues

#### **2. Comprehensive Family Ecosystem**

- **Multi-Generational Care Groups**: Sophisticated permission management allowing seamless coordination across multiple family members
- **Intelligent Escalation Protocols**: Automated alert systems that notify caregivers based on customizable criteria and user behavior patterns
- **Cultural Sensitivity**: Designed specifically for Asian family dynamics with respect for hierarchy, privacy, and cultural norms

#### **3. Advanced Technical Architecture**

- **Microservices Infrastructure**: Scalable, containerized architecture using Docker and Kubernetes for enterprise-grade reliability
- **Real-Time Data Processing**: TimescaleDB integration for efficient time-series health data management
- **Vector-Based Intelligence**: Milvus vector database enabling sophisticated similarity search and pattern recognition

#### **4. Localized Market Intelligence**

- **Vietnamese Healthcare Integration**: Built-in support for local health guidelines, drug databases, and regulatory compliance (Decree 13/2022/ND-CP)
- **Multi-Language AI**: Natural language processing optimized for Vietnamese and English, with architecture supporting rapid expansion to other Southeast Asian languages
- **Cultural Health Practices**: Integration of traditional and modern health approaches common in Southeast Asian cultures

#### **5. Subscription-Based Monetization**

- **Freemium Model**: Strategically designed free tier to drive adoption while premium features justify subscription costs
- **B2B Expansion**: Enterprise-ready architecture supporting healthcare providers, insurance companies, and corporate wellness programs
- **Local Payment Integration**: Support for regional payment methods including MoMo, ZaloPay, and traditional banking systems

This combination of advanced AI technology, cultural sensitivity, and comprehensive family health management creates a unique value proposition that addresses the specific needs of Southeast Asian markets while leveraging cutting-edge technology for scalable growth.

---

## 2. Project Scope

### 2.1. In Scope

The initial release (MVP) of the CareCircle platform will include the following core features:

- **Mobile App (iOS & Android)**:
  - User registration, login, and profile management.
  - Integration with Apple HealthKit and Google Fit for automatic data syncing (steps, heart rate, sleep, etc.).
  - **Clinical Data Import**: Allow CSV upload of lab results (e.g., blood glucose logs) for chronic patients to visualize.
  - OCR-based prescription scanner to digitize medication information.
  - Manual entry and management of medications and schedules.
  - Smart reminders and notifications for medication intake, powered by the **LLM-Powered Behavioral Engine** using OpenAI GPT models and Milvus vector similarity search.
  - Daily physical and mental well-being check-ins.
  - Creation and management of Care Groups for family members.
  - Dashboard for viewing personal and connected family members' health data.
  - Alerts system for missed doses or abnormal vitals, with escalation to caregivers.
  - **Seamless Caregiver Communication**: One-tap shortcuts to call or message a patient using their preferred external applications (e.g., Zalo, native Phone/SMS).
  - **E-Pharmacy Integration**: A feature to request medication refills through integrated e-pharmacy partners.
  - **Emergency Escalation**: One-tap SOS button that alerts emergency contacts by leveraging native SMS or call functions.
  - **Wearable Notifications**: Push critical alerts to low-energy Bluetooth wearables (e.g., Mi Bands).
  - **Data Export**: Generate a health summary and use the native OS "Share" functionality to export it as a PDF or share it via other apps.
- **Backend Services**:
  - Secure API for mobile and web clients.
  - User authentication and authorization (RBAC).
  - Database for storing user, health, and medication data.
  - AI services for OCR, NLP, and generating insights from a vetted knowledge base.
  - Push notification engine (FCM & APNs) with an adaptive learning loop.
- **Web Portal (Admin)**:
  - Dashboard for system health monitoring.
  - User management and support tools.
  - **Marketing Dashboard**: Simple dashboard with aggregate sign-up and engagement statistics.
  - **AI Cost Monitoring**: Dashboard to track AI service usage, token consumption, and associated costs per user/request.

### 2.2. Out of Scope

The following features are considered out of scope for the initial release but may be considered for future versions:

- Telemedicine consultations (video or chat with doctors).
- Direct integration with hospital EMR/EHR systems.
- Pharmacy integrations for ordering medications or prescription pickup reminders.
- Community forums or advanced social networking features.
- Insurance provider partnership integrations.
- Tangible reward redemptions via the Health Points system (v2).
- A dynamically updated RAG knowledge base from live public health feeds (v2).
- A full B2B lead management funnel in the admin portal (v2).
- Shared caregiver scheduling calendar (v2).

---

## 3. Target Audience & Personas

### 3.1. Primary Personas

#### **The Elderly Patient (60+)**

- **Profile**: Managing chronic conditions with limited tech proficiency
- **Needs**: Simple medication reminders, health tracking, emergency alerts
- **Usage**: Elder Mode interface, family-assisted setup, basic check-ins

#### **The Family Caregiver (30-55)**

- **Profile**: Tech-savvy adults caring for aging relatives while managing work/family
- **Needs**: Real-time health monitoring, automated alerts, consolidated family health view
- **Usage**: Power user of Care Groups, dashboards, and alert customization

#### **The Multi-Generational Caregiver (40-60)**

- **Profile**: "Sandwich generation" managing both aging parents and children's health
- **Needs**: Efficient multi-profile management, priority alerts, streamlined coordination
- **Usage**: Advanced Care Group features, cross-profile switching, alert filtering

---

## 4. Core Functional Requirements

### FR-01: User Management & Authentication

- **Multi-platform Registration**: Email/password and SSO (Google, Apple)
- **Profile Management**: Personal profiles with health preferences and consent controls
- **Role-Based Access**: Secure authorization with granular permissions for Care Groups

### FR-02: Health Data Integration & Management

- **Native Health Sync**: Apple HealthKit and Google Fit integration for automatic data collection
- **Prescription OCR**: Camera-based prescription scanning with AI-powered extraction
- **Manual Data Entry**: Comprehensive medication and health data management tools
- **Data Export**: PDF generation with native sharing capabilities

### FR-03: AI-Powered Notification Engine

- **Adaptive Reminders**: LLM-powered behavioral analysis for optimized notification timing and content
- **Intelligent Escalation**: Automated caregiver alerts based on user behavior patterns
- **Personalized Tone**: AI-generated messages adapted to user preferences and response history
- **Interactive Notifications**: Quick-response options directly from notification interface

### FR-04: Family Care Coordination

- **Care Group Management**: Invitation-based family networks with role-based permissions
- **Shared Health Dashboard**: Real-time family health status with customizable privacy controls
- **Emergency Communication**: One-tap emergency contacts and SOS functionality
- **Deep Linking**: Seamless app installation and invitation flow across platforms

### FR-05: Health Insights & Analytics

- **AI-Powered Summaries**: RAG-based health insights and medication information
- **Trend Analysis**: Behavioral pattern recognition and health trend visualization
- **Daily Check-ins**: Adaptive wellness surveys with RAG health status indicators
- **Personalized Recommendations**: AI-driven health coaching and actionable insights

### FR-06: Subscription & Monetization

- **Freemium Model**: Free tier (1 profile, 2 Care Group members) vs Premium (unlimited features)
- **Multi-Platform Payments**: App Store IAP, Google Play, and Vietnamese e-wallets (MoMo, ZaloPay)
- **Referral Program**: Viral growth incentives with reward tracking
- **Usage Analytics**: Comprehensive tracking for conversion optimization

### FR-07: Administrative Portal

- **System Monitoring**: Real-time dashboard for service health and user analytics
- **AI Cost Management**: OpenAI API usage tracking and cost optimization tools
- **User Support**: Customer service tools and user management capabilities
- **Security Management**: API key rotation, audit logging, and compliance monitoring

---

## 5. Non-Functional Requirements

### NFR-01: Security & Privacy

- **Data Protection**: AES-256 encryption at rest, TLS 1.3 in transit, RBAC with audit logging
- **Compliance**: Vietnam Decree 13/2022/ND-CP, GDPR-ready architecture, automated data retention
- **Security Architecture**: Zero trust model, MFA for admin access, regular penetration testing

### NFR-02: Performance & Scalability

- **Response Times**: <500ms API calls, <3s app launch, <5s AI processing, <30s data sync
- **Scalability**: Microservices with auto-scaling, 10x user growth support, 10K concurrent users
- **Optimization**: Intelligent load balancing, database indexing, elastic storage scaling

### NFR-03: Reliability & Availability

- **Service Levels**: 99.9% uptime for core services, 99.5% notification delivery, <1hr RTO
- **Fault Tolerance**: Multi-region deployment, circuit breakers, graceful degradation
- **Disaster Recovery**: Automated backups, real-time replication, regular recovery testing

### NFR-04: Usability & Accessibility

- **User Experience**: Platform-specific design guidelines, WCAG 2.1 AA compliance
- **Multi-Generational Design**: Elder Mode, screen reader support, dynamic font sizing
- **Localization**: Vietnamese/English support, cultural adaptation, Unicode compatibility

### NFR-05: AI & Integration

- **AI Performance**: >90% OCR accuracy, <3s AI insights, real-time personalization
- **API Design**: RESTful with OpenAPI docs, GraphQL support, webhook integration
- **Extensibility**: Health platform integrations, healthcare provider APIs, SDK development

---

## 6. System Architecture & Business Model

### 6.1. Technical Architecture

#### **Core Technology Stack**

- **Backend**: NestJS/TypeScript, PostgreSQL with TimescaleDB, Redis, Milvus vector DB
- **Mobile**: Flutter/Dart with HealthKit/Google Fit integration, Firebase messaging
- **Web Portal**: Next.js/React, Tailwind CSS, real-time analytics dashboard
- **AI Services**: OpenAI GPT models, vector embeddings, OCR processing
- **Infrastructure**: Docker/Kubernetes, multi-region deployment, auto-scaling

#### **Key Integrations**

- **Health Data**: Apple HealthKit, Google Fit, wearable device APIs
- **Payments**: App Store IAP, Google Play, MoMo, ZaloPay e-wallets
- **Communication**: Firebase push notifications, SMS/email alerts
- **Security**: JWT authentication, RBAC, AES-256 encryption

### 6.2. Business Model & Financial Strategy

#### **Revenue Streams**

- **Freemium Subscription**: $9.99/month premium tier with AI features
- **B2B Enterprise**: Healthcare provider and corporate wellness solutions
- **Strategic Partnerships**: E-pharmacy referrals, wearable integrations

#### **Growth Targets**

- **2025**: 100K users (10K premium), $1.2M revenue, 10% conversion rate
- **2026**: 500K users (50K premium), $6M revenue, Southeast Asia expansion
- **2027**: 1M users (100K premium), $15M revenue, profitability milestone

#### **Key Metrics**

- **User**: 30% DAU/MAU ratio, 85% medication adherence, 60% daily check-ins
- **Business**: <$15 CAC, $180 LTV, <6 month payback period
- **Technical**: 99.9% uptime, <500ms API response, >90% OCR accuracy

---

## 7. Assumptions, Constraints & Success Metrics

### 7.1. Key Assumptions

- **Technology**: Stable smartphone adoption (iOS 14+/Android 8.0+), reliable OpenAI API availability
- **Market**: Continued digital health growth in Southeast Asia, favorable regulatory environment
- **User Behavior**: Willingness to share health data, family engagement in care coordination
- **Business**: Freemium model effectiveness, B2B partnership development opportunities

### 7.2. Critical Constraints

- **Technical**: AI service dependencies, OCR accuracy limitations, platform restrictions
- **Resource**: MVP timeline and budget limitations, specialized AI/ML expertise requirements
- **Regulatory**: Healthcare compliance boundaries, cross-border data transfer restrictions
- **Market**: Cultural adaptation requirements, local payment system integration challenges

### 7.3. Success Metrics

#### **User Growth & Engagement**

- **2025 Targets**: 100K MAU, 30K DAU (30% ratio), 85% medication adherence
- **Retention**: 85% Day 1, 60% Day 7, 40% Day 30, 25% Day 90
- **Feature Adoption**: 70% Care Group participation, 60% daily check-ins

#### **Business Performance**

- **Revenue**: $100K MRR by end 2025, 10% conversion rate, $180 LTV
- **Efficiency**: <$15 CAC, <6 month payback, <40% operational cost ratio
- **Growth**: 20% monthly growth, 25% referral rate, 15% Vietnam market share

#### **Technical Quality**

- **Performance**: 99.9% uptime, <500ms API response, <3s app launch
- **Accuracy**: >90% OCR success, >95% notification delivery, <0.1% crash rate

## 8. Risk Management & Development Approach

### 8.1. Key Risks & Mitigation

#### **High-Priority Technical Risks**

- **AI Service Dependency**: OpenAI API outages/pricing changes
  - _Mitigation_: Fallback mechanisms, alternative AI providers, cost monitoring
- **Data Privacy Compliance**: Regulatory changes requiring architectural updates
  - _Mitigation_: Privacy-by-design architecture, regular compliance audits
- **Platform Dependencies**: iOS/Android API changes affecting core functionality
  - _Mitigation_: Close platform monitoring, adapter patterns, manual fallbacks

#### **Business & Market Risks**

- **Lower Adoption Rates**: Family-centric health management not adopted as expected
  - _Mitigation_: Extensive user research, iterative development, flexible pivoting
- **Competitive Pressure**: Major tech companies entering family health space
  - _Mitigation_: Focus on unique value proposition, rapid feature development
- **Economic Impact**: Reduced willingness to pay for premium features
  - _Mitigation_: Flexible pricing models, enhanced free tier value

### 8.2. Development Strategy

#### **MVP-First Approach**

- **Quality Philosophy**: Manual testing and code reviews over automated testing infrastructure
- **Rationale**: Prioritize rapid market validation and user feedback collection
- **Quality Assurance**: Comprehensive manual testing, staged deployments, real-time monitoring
- **Future Evolution**: Gradual introduction of automated testing post-MVP

#### **Compliance & Regulatory Framework**

- **Data Privacy**: Vietnam Decree 13/2022/ND-CP compliance, GDPR-ready architecture
- **Healthcare Regulations**: Clear non-medical positioning with appropriate disclaimers
- **Platform Compliance**: iOS/Android health app guidelines, AI ethics transparency
