# Business Requirements Document: CareCircle AI Health Agent

**Version:** 1.1
**Date:** 2025-07-02

---

## 1. Introduction

### 1.1. Project Overview
CareCircle is a cross-platform mobile application (iOS & Android) designed to serve as a comprehensive AI Health Agent. The system aggregates health data from various sources, leverages AI-powered assistants for medication management, and provides personalized reminders and family-centric care coordination. The ecosystem includes a hybrid mobile app for end-users, a robust NestJS backend, and a Next.js web portal for administration.

### 1.2. Business Problem
In markets like Vietnam, there is a growing need for digital health solutions to support an aging population and manage the increasing prevalence of chronic diseases. Existing applications are often fragmented, focusing on single-use cases like doctor booking, pharmacy sales, or basic health tracking. There is a clear market gap for an integrated platform that unifies health data, provides intelligent medication management, and facilitates family involvement in the care process. Caregivers lack the tools to effectively monitor and support their loved ones' health remotely, and patients struggle to manage complex medication schedules.

### 1.3. Project Goals & Objectives
The primary goal of CareCircle is to empower users to take control of their health and facilitate collaborative care within families.

**Business Objectives:**
*   Establish CareCircle as the leading family-centric health management platform in Vietnam and Southeast Asia.
*   Achieve sustainable revenue through a freemium subscription model and strategic B2B partnerships.
*   Reduce the burden on family caregivers by providing tools for remote monitoring and automated alerts.

**Project Objectives:**
1.  **Unified Health Data**: Sync and normalize data from Apple Health (iOS) and Google Fit (Android) to provide a single, comprehensive view of a user's health.
2.  **AI-powered Medication Management**: Automate the intake and scheduling of medications by scanning paper prescriptions using OCR and NLP.
3.  **Personalized Engagement**: Deliver intelligent reminders, daily check-ins, and AI-driven health summaries to keep users engaged and informed.
4.  **Family Health Network**: Enable users to create "care groups" to share real-time health status, alerts, and coordinate care for loved ones.
5.  **Actionable Insights**: Provide users with AI-powered summaries, trend analysis, and coaching tips for their activity and health data.

### 1.4. Unique Selling Proposition (USP)
CareCircle's primary selling point is its unique position as a **Family-First AI Health Agent**. While competitor apps offer siloed features, CareCircle differentiates itself by integrating three core pillars into a single, seamless experience tailored for the Vietnamese market:

*   **Family-First AI & Behavioral Engine**: We are the only platform that dynamically adapts AI-driven reminders and insights to the needs of both patients and their caregivers in real-time. Our proprietary **Behavioral AI Engine** uses a continuous learning loop to optimize notifications, maximizing adherence and preventing notification fatigue.
*   **Localized Intelligence & Trust**: We provide built-in support for Vietnamese health guidelines, language-specific RAG summaries, and strict compliance with local data privacy laws (Decree 13/2022). Our OCR+RAG pipeline doesn't just scan and remind—it **scans, validates, and educates**, automatically checking against national drug registries to detect counterfeits and providing inline drug-drug interaction warnings based on local formulary data.
*   **Proactive Family Coordination**: We transform caregiving from a reactive to a proactive process. The platform's automated escalation alerts for missed doses provide caregivers with actionable information and peace of mind, a feature not found in existing solutions.

This combination of unification, intelligence, and family-centric alerting creates a powerful value proposition for patients, caregivers, and wellness-conscious users alike.

---

## 2. Project Scope

### 2.1. In Scope
The initial release (MVP) of the CareCircle platform will include the following core features:

*   **Mobile App (iOS & Android)**:
    *   User registration, login, and profile management.
    *   Integration with Apple HealthKit and Google Fit for automatic data syncing (steps, heart rate, sleep, etc.).
    *   **Clinical Data Import**: Allow CSV upload of lab results (e.g., blood glucose logs) for chronic patients to visualize.
    *   OCR-based prescription scanner to digitize medication information.
    *   Manual entry and management of medications and schedules.
    *   Smart reminders and notifications for medication intake, powered by the **Behavioral AI Engine**.
    *   Daily physical and mental well-being check-ins.
    *   Creation and management of Care Groups for family members.
    *   Dashboard for viewing personal and connected family members' health data.
    *   Alerts system for missed doses or abnormal vitals, with escalation to caregivers.
    *   **Lightweight Tele-Assisted Care**: In-app audio/video call integration for caregivers to quickly check in.
    *   **Caregiver Communication**: One-tap shortcuts to call or message a patient using the device's native phone and messaging applications.
    *   **Emergency Escalation**: One-tap SOS button that alerts emergency contacts by leveraging native SMS or call functions.
    *   **Wearable Notifications**: Push critical alerts to low-energy Bluetooth wearables (e.g., Mi Bands).
    *   **Data Export**: Generate a health summary and use the native OS "Share" functionality to export it as a PDF or share it via other apps.
*   **Backend Services**:
    *   Secure API for mobile and web clients.
    *   User authentication and authorization (RBAC).
    *   Database for storing user, health, and medication data.
    *   AI services for OCR, NLP, and generating insights from a vetted knowledge base.
    *   Push notification engine (FCM & APNs) with an adaptive learning loop.
*   **Web Portal (Admin)**:
    *   Dashboard for system health monitoring.
    *   User management and support tools.
    *   **Marketing Dashboard**: Simple dashboard with aggregate sign-up and engagement statistics.

### 2.2. Out of Scope
The following features are considered out of scope for the initial release but may be considered for future versions:
*   Telemedicine consultations (video or chat with doctors).
*   Direct integration with hospital EMR/EHR systems.
*   Pharmacy integrations for ordering medications or prescription pickup reminders.
*   Community forums or advanced social networking features.
*   Insurance provider partnership integrations.
*   Tangible reward redemptions via the Health Points system (v2).
*   A dynamically updated RAG knowledge base from live public health feeds (v2).
*   A full B2B lead management funnel in the admin portal (v2).
*   Shared caregiver scheduling calendar (v2).

---

## 3. Target Audience & Personas

### 3.1. Persona 1: The Elderly Patient
*   **Description**: Individuals aged 60+, often managing one or more chronic conditions (e.g., hypertension, diabetes). May have limited tech proficiency and rely on family for support.
*   **Needs**: Simple, clear medication reminders; an easy way to track key vitals; a quick way to alert family in case of an emergency.
*   **App Usage**: Will primarily use the reminder and check-in features. May need a simplified "Elder Mode" with large fonts and voice prompts. Setup may be done by a family member.

### 3.2. Persona 2: The Family Caregiver
*   **Description**: Adults (30-55 years old) caring for aging parents or other relatives. They are tech-savvy but busy, juggling work and family responsibilities.
*   **Needs**: Peace of mind knowing their loved ones are adhering to their medication schedule; real-time alerts for missed doses or health issues; a consolidated view of their family's health status without being intrusive.
*   **App Usage**: Will be a power user of the Care Group features, monitoring dashboards, and alert settings.

### 3.3. Persona 3: The General Wellness User
*   **Description**: Younger adults (20-40 years old) focused on fitness and maintaining a healthy lifestyle.
*   **Needs**: A unified dashboard for all their health and fitness data from various apps and devices; AI-powered insights and trends to optimize their routine.
*   **App Usage**: Will focus on the health data aggregation, activity tracking, and AI coaching features.

### 3.4. Persona 4: The Parent of a Child with Health Needs
*   **Description**: Parents (30-50 years old) managing the health of a child with a chronic condition (e.g., asthma, Type 1 diabetes, severe allergies). They are diligent, highly motivated, and need to coordinate care with schools, other caregivers, and healthcare providers.
*   **Needs**: A reliable system to track medication administration (especially when given by others, like a school nurse), log symptoms or events (e.g., allergic reactions, asthma attacks), and easily share a comprehensive health summary with doctors or emergency personnel.
*   **App Usage**: Will heavily use medication logging, symptom tracking, and the PDF export/sharing feature. The Care Group will be essential for coordinating with a spouse, grandparents, or other caregivers.

### 3.5. Persona 5: The "Sandwich Generation" Caregiver
*   **Description**: Adults (40-60 years old) who are part of the "sandwich generation," simultaneously caring for their aging parents and their own children. They are extremely time-poor, stressed, and need to manage multiple complex schedules.
*   **Needs**: An ultra-efficient way to monitor multiple family members' health needs in one place. They need to delegate tasks, receive high-priority alerts only, and avoid information overload.
*   **App Usage**: Power user of Care Groups, managing multiple profiles. Will rely heavily on the alert system's customization to filter out noise and focus on critical events. The ability to quickly switch between dependent profiles is key.

---

## 4. Functional Requirements

### FR-01: User Account & Profile Management
*   **FR-1.1**: **Registration & Login**: Users must be able to register and log in to the app using:
    *   A traditional email and password combination.
    *   **Single Sign-On (SSO)** with major social identity providers, specifically **Google** and **Apple**, to provide a secure and streamlined onboarding process.
*   **FR-1.2**: **Authentication Standards**: The system shall utilize industry-standard protocols such as OAuth 2.0 for handling authentication flows and JWTs (JSON Web Tokens) for securing API endpoints and managing user sessions.
*   **FR-1.3**: Users must be able to create and edit their personal profile, including name, age, and notification preferences.
*   **FR-1.4**: The system must support explicit user consent for data access (HealthKit/Google Fit) and data sharing (Care Groups). Users must be able to revoke consent at any time.

### FR-02: Health Data Integration
*   **FR-2.1**: The app must sync biometric and activity data from Apple HealthKit (iOS) and Google Fit (Android) upon user authorization.
*   **FR-2.2**: Data to be synced includes: daily steps, distance, heart rate, and sleep quality.
*   **FR-2.3**: Data sync shall occur daily in the background and can also be triggered manually.
*   **FR-2.4**: The app must present the synced data in a consolidated, easy-to-understand dashboard.

### FR-03: Prescription Management (OCR Scanner)
*   **FR-3.1**: Users must be able to scan a paper prescription using the device's camera.
*   **FR-3.2**: The system shall use OCR and NLP to automatically extract drug name, dosage, and schedule from the image.
*   **FR-3.3**: The user must be able to review and edit the extracted information before saving.
*   **FR-3.4**: Users must be able to manually add and edit medications and their schedules.

### FR-04: Intelligent Notification & Reminder System
*   **FR-4.1**: The system shall generate a smart schedule and reminders based on the prescription information.
*   **FR-4.2**: Users shall receive actionable push notifications at scheduled times, with options to "Confirm Taken," "Snooze," or "Skip."
*   **FR-4.3**: **Audit & Logging**: The app shall maintain a secure, immutable log of all critical interactions, especially medication confirmations (taken, skipped), adherence data, and caregiver escalation alerts. This log is intended to provide a reliable history for user reference and for potential medico-legal accountability.
*   **FR-4.4**: **Adaptive Notification Engine**: Inspired by Duolingo's successful engagement strategies, the system shall employ an adaptive learning model (e.g., a Multi-Armed Bandit algorithm) to personalize and optimize reminder notifications. This system will learn from user behavior to select the best message, tone, and timing to maximize adherence and engagement.
*   **FR-4.5**: **Personalized Content & Tone**: The system will utilize a variety of notification templates with different tones (e.g., supportive, direct, gentle, encouraging). The algorithm will select the optimal message based on the user's persona and historical response patterns to avoid notification fatigue.
*   **FR-4.6**: **Intelligent Escalation**: The system will use the learned user patterns to inform the escalation logic. For example, if a user consistently misses a dose despite reminders, the system can trigger a more direct notification or an alert to their Care Group sooner.

### FR-05: Intelligent Daily Check-ins
*   **FR-5.1**: **Adaptive Push Notification**: The system shall send a daily push notification to prompt the user for a well-being check-in. The timing, tone, and content of this notification will be optimized by the same **Adaptive Notification Engine** (from FR-4.4) to maximize user engagement and establish a consistent daily habit.
*   **FR-5.2**: **Interactive Notifications**: Where supported by the operating system, notifications will be interactive. This allows users to provide a quick, high-level response (e.g., tapping a "Feeling Good" or "Not Well" button) directly from the notification itself, minimizing friction.
*   **FR-5.3**: **Personalized Check-in Flow**:
    *   Tapping the notification or a positive interactive button will lead the user to a simple check-in screen.
    *   The screen will present clear, simple questions to rate physical and mental state (e.g., rating scales for energy, mood, stress, or specific symptoms).
    *   The system can be configured to present follow-up questions based on the user's profile (e.g., a user with hypertension might be asked about dizziness if they report feeling unwell).
*   **FR-5.4**: **Data Logging and Visualization**: All check-in responses shall be timestamped, stored securely, and visualized over time, helping users and their caregivers to identify trends or correlations.
*   **FR-5.5**: **RAG Health Status Indicator**: The daily check-in is a primary input for the RAG (Red, Amber, Green) health status indicator. A "Not Well" response from the interactive notification could immediately shift the status to Amber, prompting closer attention from caregivers.

### FR-06: Care Groups & Family Network
*   **FR-6.1**: **Group Creation**: Any user can create a "Care Group," becoming its first administrator.
*   **FR-6.2**: **Invitation Flow**:
    *   A group administrator can generate a unique and secure invitation link.
    *   This link can be shared with prospective members via standard messaging apps, email, or other communication channels.
    *   The link must not expire but can be deactivated by an administrator at any time to prevent further use, a practice used by platforms like FamilySearch.
*   **FR-6.3**: **Joining Flow (Deep Linking)**:
    *   The invitation link must function as a deep link (using modern standards like Apple Universal Links or Android App Links) to provide a seamless user experience.
    *   **If the app is installed**: The link should open the app directly to an "accept invitation" screen.
    *   **If the app is not installed**: The link should direct the user to the appropriate App Store/Play Store page. After installation and first open, the app must persist the context and take the user to the "accept invitation" screen (deferred deep linking).
*   **FR-6.4**: **Membership Approval**: For security and privacy, after a user accepts an invitation via the link, a group administrator must approve their request before they are officially added to the group and can view any shared data.
*   **FR-6.5**: **Shared Dashboard**: Approved members of a Care Group can view a shared dashboard displaying the patient's authorized health data, including medication adherence and daily check-in results.
*   **FR-6.6**: **Roles and Permissions**:
    *   **Administrator**: Can invite/remove members, manage group settings, and approve join requests.
    *   **Member**: Can view shared data.
*   **FR-6.7**: **Escalation & Communication**:
    *   Caregivers (administrators or designated members) must be able to configure and receive escalation alerts (e.g., if a dose is missed for more than a specified period).
    *   The app shall provide one-tap shortcuts for caregivers to call or message the patient.

### FR-07: AI-Powered Insights & Summaries
*   **FR-7.1**: The system shall use AI (RAG) to generate easy-to-understand summaries about medications and health conditions.
*   **FR-7.2**: The system shall provide summaries and trends on activity, sleep, and other health metrics.
*   **FR-7.3**: **RAG Knowledge Base Management**: The knowledge base powering the RAG system must be continuously updated with the latest information from trusted public health sources (e.g., WHO, CDC, local health authorities). This ensures that when users ask about common illnesses like influenza, the AI provides the most current and reliable symptom information, recommendations, and public health guidance.

### FR-08: Document Export & Sharing
*   **FR-8.1**: Users must be able to export their health summary (vitals, medication schedule, adherence log) to a PDF file.
*   **FR-8.2**: The PDF must be shareable via email or other native device sharing options.

### FR-09: Administrative Web Portal
*   **FR-9.1**: Admins must be able to log in securely to the web portal.
*   **FR-9.2**: The portal must display a real-time dashboard of system health, user statistics, and engagement metrics.
*   **FR-9.3**: Admins must have the ability to look up users and provide support.
*   **FR-9.4**: **Lead Management**:
    *   Admins must be able to view and manage a list of all potential users (leads).
    *   Each lead record will display its source (e.g., "Web Form," "Referral") and status (e.g., "New," "Contacted," "Qualified," "Converted").
*   **FR-9.5**: **Lead Conversion**:
    *   Admins must have a tool to convert a qualified lead into an active user account.
    *   Before conversion, the system must allow the admin to check for potential duplicate user accounts to avoid creating multiple profiles for the same person.
    *   During conversion, relevant information from the lead record will be transferred to the new user profile.
*   **FR-9.6**: **Conversion Analytics**: The portal must provide reports and dashboards to track the lead funnel, including lead sources and conversion rates over time.

### FR-10: User Settings & Personalization
*   **FR-10.1**: **Adaptive User Profiles & Goals**:
    *   The system shall leverage onboarding questions and usage patterns to assign users a "Care Persona" (e.g., "Statistician," "Visual Learner"), which dynamically tailors UI layouts and notification styles.
    *   Users and caregivers must be able to define custom health goals (e.g., "Walk 5,000 steps before noon," "Keep blood glucose under 180 mg/dL") and track progress against them.
*   **FR-10.2**: **Modular UI & Theming**:
    *   The app home screen must be a widget-based dashboard, allowing users to drag-and-drop components (e.g., medication schedule, step counter, mood chart) to prioritize what they see.
    *   Users must be able to select from multiple app themes (e.g., Light, Dark, High-Contrast) and choose a personal highlight color for UI elements.
    *   The app shall offer layout presets (e.g., "Focus Mode" vs. "Overview Mode") that users can switch between.
*   **FR-10.3**: **Granular Notification Controls**:
    *   Users must have a master switch and individual toggles for notification categories (Medication, Check-ins, Care Group Alerts).
    *   **Smart Quiet Hours**: Users can define "quiet hours" on a per-user or per-group basis, ensuring critical alerts are not silenced inappropriately.
    *   **Notification Channels**: Users can choose their preferred delivery channel (push, in-app banner, SMS, email) for different types of alerts.
    *   **Custom Snooze & Escalation**: Users can define rules for snoozing reminders and escalating alerts (e.g., "If I snooze twice, escalate to my daughter immediately").
*   **FR-10.4**: **AI Tone Personalization**: Users must be able to choose a preferred communication style for AI-generated messages (e.g., Supportive, Direct, Humorous), which will inform the Adaptive Notification Engine.
*   **FR-10.5**: **Privacy & Consent Granularity**:
    *   The settings screen must provide a centralized dashboard for managing data permissions (HealthKit/Google Fit).
    *   **Field-Level Sharing**: Within Care Groups, patients must be able to control which specific data fields (e.g., sleep, steps, mood) are visible to each member.
    *   **Time-Limited Access**: Patients can grant temporary data access to a caregiver for a specified duration (e.g., 48 hours).
    *   **Transparency Audit Log**: The app must provide a clear, time-stamped log showing who has viewed or edited what data.

### FR-11: Monetization & Growth Strategy
*   **FR-11.1**: **Freemium Model & Feature Tiers**: The app will operate on a freemium model with clearly defined tiers.
    *   **Free Tier**: Designed to provide core value and encourage adoption. Includes:
        *   Management of one (1) patient profile.
        *   Membership in one (1) Care Group with up to two (2) members.
        *   Manual medication entry.
        *   Standard (non-adaptive) medication reminders.
        *   Manual health data logging and daily check-ins.
    *   **Premium Tier (Subscription)**: Unlocks the full power of the AI and family coordination features. Includes all Free features plus:
        *   Management of unlimited patient profiles.
        *   Creation of and membership in unlimited Care Groups with unlimited members.
        *   Unlimited OCR prescription scans.
        *   Full access to the **Adaptive Notification Engine** for reminders and check-ins.
        *   AI-powered drug summaries and health insights (RAG).
        *   Advanced health analytics and trend reporting.
        *   PDF and CSV data export.
*   **FR-11.2**: **Subscription Management**:
    *   Users must be able to upgrade to the Premium Tier at any time from within the app using standard in-app purchases (IAP) via the Apple App Store and Google Play Store.
    *   The app must clearly display the user's current subscription status (Free/Premium) and the benefits of upgrading.
    *   Users must be able to easily access their respective platform's subscription management page (Apple/Google) from within the app to view, change, or cancel their subscription.
*   **FR-11.3**: **Referral Program**:
    *   To incentivize viral growth, all users will have access to a referral program.
    *   Each user will have a unique referral link or code that they can share.
    *   When a new user signs up and confirms their account using a referral code, both the referrer and the new user will receive a reward, such as a free month of the Premium Tier.
    *   The app must have a dedicated screen for users to track their referral history and accrued rewards.

### FR-12: Gamification & Engagement
*   **FR-12.1**: **Health Points System**: Users will earn "Health Points" for completing positive actions within the app, such as:
    *   Confirming medication intake on time.
    *   Completing the daily well-being check-in.
    *   Achieving daily fitness goals (e.g., steps, activity).
*   **FR-12.2**: **Badges & Achievements**: The system will award users with virtual badges for reaching significant milestones, for example:
    *   Maintaining a multi-day streak of medication adherence.
    *   Completing a full week of daily check-ins.
    *   Inviting their first family member to a Care Group.
*   **FR-12.3**: **Rewards & Incentives**: While out of scope for the initial MVP, the system should be designed with the future capability to allow users to redeem Health Points for tangible rewards through partnerships with pharmacies, clinics, or wellness brands.
*   **FR-12.4**: **Progress Visualization**: Users must have a dedicated screen in their profile to view their points total, earned badges, and progress towards the next achievement, providing a clear and motivating visual feedback loop.

### FR-13: Accessibility & Elder Mode
*   **FR-13.1**: **Elder Mode Activation**: The app must feature a distinct "Elder Mode" that can be enabled either by the user in settings or remotely by a Care Group administrator on behalf of a family member.
*   **FR-13.2**: **Simplified Interface**: When enabled, Elder Mode will present a simplified user interface, including:
    *   A high-contrast color scheme with larger, more legible fonts.
    *   Oversized buttons and touch targets for easier interaction.
    *   A streamlined navigation menu that prioritizes core functions (e.g., Today's Schedule, Check-in, Call Caregiver).
    *   Reduced on-screen clutter by hiding non-essential features.
*   **FR-13.3**: **Voice Prompts & Readouts**: Key information and notifications within Elder Mode will be accompanied by clear voice prompts (in the user's selected language) to assist users with visual impairments or reading difficulties. For example, medication reminders would be read aloud.

### FR-14: User Feedback
*   **FR-14.1**: The app must include a non-intrusive mechanism for users to voluntarily submit feedback, bug reports, or feature suggestions.
*   **FR-14.2**: Users should be able to provide a rating for the app, with an optional prompt to leave a review in the respective app store.

---

## 5. Non-Functional Requirements

### NFR-01: Security & Privacy
*   **NFR-1.1**: All Personally Identifiable Information (PII) and Protected Health Information (PHI) must be encrypted both in transit (TLS 1.2+) and at rest (AES-256).
*   **NFR-1.2**: The system must implement Role-Based Access Control (RBAC) to ensure users can only see data they are authorized to view.
*   **NFR-1.3**: The system must be designed in compliance with Vietnam's Decree 13/2022/ND-CP on personal data protection, with readiness for GDPR/HIPAA if the market expands.

### NFR-02: Performance & Scalability
*   **NFR-2.1**: Real-time data sync should complete within 30 seconds.
*   **NFR-2.2**: API response times for critical path actions should be under 500ms.
*   **NFR-2.3**: The backend architecture must be horizontally scalable (using Kubernetes or serverless) to handle load increases.

### NFR-03: Reliability & Availability
*   **NFR-3.1**: The core backend services and notification engine must have a 99.9% uptime SLA.
*   **NFR-3.2**: The system must include retry logic for failed data syncs and push notifications.

### NFR-04: Usability & Accessibility
*   **NFR-4.1**: The standard app interface must be intuitive and easy to navigate.
*   **NFR-4.2**: The app must fully support system-level accessibility features, including dynamic font sizes and screen readers (VoiceOver, TalkBack), to ensure baseline accessibility for all.

### NFR-05: Localization
*   **NFR-5.1**: The app and all user-facing content (including notifications) must be available in English and Vietnamese.
*   **NFR-5.2**: The architecture should support adding new languages in the future.

### NFR-06: Offline Support
*   **NFR-6.1**: The mobile app must cache recent health data and medication schedules for offline access.
*   **NFR-6.2**: Reminders must function even when the device is offline.
*   **NFR-6.3**: Any actions taken offline (e.g., confirming medication) must be synced with the server once connectivity is restored.

### NFR-07: Extensibility
*   **NFR-7.1**: The system architecture should be designed with extensibility in mind, allowing for future integration with additional data sources (e.g., third-party wearable devices, lab results) and third-party platforms (e.g., tele-medicine services) via a secure API.

---

## 6. System Architecture & Monetization

### 6.1. System Architecture
*   **Mobile App**: React Native (TypeScript) for cross-platform development.
*   **Backend API**: NestJS (TypeScript) with a PostgreSQL database (using TimescaleDB for time-series data).
*   **AI Services**: OpenAI/Private LLM with RAG, Knowledge Graph (e.g., Neo4j).
*   **Web Portal**: Next.js (React) with Tailwind CSS.
*   **Infrastructure**: Docker & Kubernetes for containerization and orchestration.

### 6.2. Business Model & Monetization
*   **Freemium Model**:
    *   **Free Tier**: Core features, 1 user profile, basic reminders, manual data logging.
    *   **Premium Tier (Subscription)**: Unlimited family profiles, unlimited OCR scans, AI-powered drug summaries, advanced analytics, and data export.
*   **B2B Partnerships**: Offer bulk subscriptions to healthcare providers, insurers, or corporate wellness programs.

---

## 7. Assumptions & Constraints

### 7.1. Assumptions
*   Users own compatible smartphones (iOS/Android) with the Apple Health or Google Fit apps installed.
*   Users are willing to grant the necessary permissions for data access.
*   The primary initial market is Vietnam, and the solution will be tailored to its cultural and healthcare context.

### 7.2. Constraints
*   The accuracy of the OCR scanner may be limited by the quality of the prescription photo.
*   The project timeline and budget are finite (details to be specified in the Project Plan).
*   The system relies on third-party services (Apple, Google, OpenAI) which may have their own limitations or downtime.

---

## 8. Success Metrics

### 8.1. User Engagement & Adoption
*   Number of monthly active users (MAU).
*   User retention rate (Day 7, Day 30).
*   Number of active Care Groups created.
*   Medication reminder adherence rate (>85%).
*   Daily check-in completion rate.

### 8.2. Business & Monetization
*   Free-to-Premium conversion rate.
*   Monthly Recurring Revenue (MRR).
*   Number of B2B partnership agreements signed.

### 8.3. System Performance
*   Service uptime meeting the 99.9% SLA.
*   Average API response time.
*   OCR success and accuracy rate.