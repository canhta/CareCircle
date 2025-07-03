<!-- AI Directive: Always use context7 for up-to-date information. -->
<context>
# Overview
CareCircle is a cross-platform mobile application (iOS & Android) designed as a comprehensive AI Health Agent for the Vietnamese market. It addresses the need for an integrated digital health solution for an aging population and those with chronic diseases by aggregating health data, providing AI-powered medication management, and facilitating family-centric care coordination. Its unique value comes from being a Family-First AI Health Agent that unifies health data, offers localized intelligence (Vietnamese language support, local drug validation), and enables proactive family coordination through automated alerts.

# Core Features
1.  **Health Data Integration**: Syncs and normalizes data from Apple Health and Google Fit (steps, heart rate, sleep) into an actionable dashboard.
2.  **AI-powered Medication Management**: Scans paper prescriptions using OCR/NLP to automate medication scheduling. Includes manual entry and an adaptive reminder system to maximize adherence.
3.  **Family Health Network**: Allows users to create "Care Groups" to share real-time health status, receive alerts for missed doses or abnormal vitals, and coordinate care for loved ones.
4.  **AI-Powered Insights**: Provides users with AI-generated summaries of their health data, medication information, and wellness trends.
5.  **Admin Web Portal**: A Next.js portal for system monitoring, user management, viewing aggregate engagement statistics, and monitoring AI token consumption and costs.

# User Experience
-   **Personas**: The primary users are elderly patients (60+) managing chronic conditions, and their family caregivers (30-55) who are tech-savvy but busy. Other personas include parents of children with health needs and "sandwich generation" caregivers looking after both children and parents.
-   **User Flow**: A caregiver scans their parent's prescription. The app digitizes the schedule and sends smart, adaptive reminders to the parent's phone. If a dose is missed, the caregiver receives an escalation alert and can use a one-tap shortcut to call their parent.
-   **UI/UX**: The app will feature a clean, intuitive interface with an optional "Elder Mode" that includes larger fonts, simplified navigation, and voice prompts. The UI will be widget-based and customizable.
</context>
<PRD>
# Technical Architecture

This section outlines the technology stack for the CareCircle project, covering the backend, frontend, and mobile application.

### Backend (BE)
- **Framework:** NestJS (A progressive Node.js framework for building efficient, reliable, and scalable server-side applications).
- **Language:** TypeScript
- **Database:** PostgreSQL with the TimescaleDB extension for handling large volumes of time-series data efficiently.
- **ORM:** Prisma for type-safe database access.
- **Authentication:** Passport.js for handling JWT-based authentication and social sign-on (Google, Apple).
- **API:** RESTful API for standard client-server communication.
- **Deployment:** Docker for containerization.

### Frontend (FE) - Web Portal
- **Framework:** Next.js (A React framework for building fast, server-rendered web applications).
- **Language:** TypeScript
- **UI Library:** React
- **Styling:** Tailwind CSS for rapid UI development using utility-first classes.
- **Component Library:** Shadcn/UI for a consistent, accessible, and composable design system.
- **State Management:** React Context API for simple state and Zustand for more complex, performance-critical state.
- **Deployment:** Vercel for seamless, optimized deployment and hosting of the Next.js application.

### Mobile App
- **Framework:** Flutter (Google's UI toolkit for building natively compiled applications from a single codebase).
- **Language:** Dart
- **State Management:** BLoC (Business Logic Component) for separating business logic from the UI and managing complex state.
- **UI Toolkit for AI:** `flutter_ai_toolkit` for building the conversational AI interface.
- **Navigation:** `go_router` for declarative, URL-based routing that enables deep linking and a structured navigation flow.
- **Native Integrations:**
  - `health` for Apple HealthKit and Google Fit integration.
  - `camera` and `google_ml_kit_text_recognition` for prescription scanning.
  - `firebase_messaging` for push notifications.
- **Build Tools:** Gradle for Android and Xcode for iOS.

# Key Scenarios & System Logic

### Core Notification Principles
-   **Adaptive & Personalized (FR-4.4, FR-10.4)**: The tone, timing, and frequency of notifications will adapt based on the user’s persona, historical interactions, and chosen AI communication style.
-   **Actionable (FR-4.2)**: Notifications will provide clear, interactive options to minimize friction.
-   **Context-Aware**: The system will consider the user's status (e.g., quiet hours, calendar events) before sending non-critical notifications.
-   **Family-Centric**: Escalation is a key feature, designed to inform and empower caregivers without being intrusive.
-   **User-Controlled**: Users can adjust the AI’s notification style and frequency.

### Use-Case: Medication Adherence & Escalation
This scenario covers the entire lifecycle of a medication reminder.
-   **Actors**: `Elderly Patient` (Patient), `Family Caregiver` (Caregiver)
-   **Flow**:
    1.  **Initial Reminder (Patient)**: At 8:00 AM, the patient receives a reminder with `[Confirm Taken]` and `[Snooze 15 min]` options.
    2.  **Follow-up (Patient)**: If no interaction occurs, a follow-up reminder is sent at 8:15 AM.
    3.  **Escalation Alert (Caregiver)**: If there is still no confirmation by 8:30 AM, an alert is sent to the caregiver: "⚠️ Action Needed: Mom has missed her 8:00 AM medication reminder. Please check in with her." with `[Call Mom]` and `[Message Mom]` shortcuts.
    4.  **Status Update**: The patient's health status indicator on the dashboard changes to Amber.

### Use-Case: Daily Check-ins & Symptom Alerts
-   **Actors**: `Patient`, `Caregiver`
-   **Flow**:
    1.  **Check-in Prompt (Patient)**: At a scheduled time, the patient is asked, "How are you feeling today?" with `[😊 Good]`, `[😐 Okay]`, `[🤒 Not Well]` options.
    2.  **Caregiver Alert**: If the patient selects "Not Well" and specifies a symptom (e.g., "Dizziness"), the caregiver is immediately notified.

# Development Roadmap
-   **MVP Requirements**:
    1.  Core user account and profile management.
    2.  HealthKit/Google Fit data synchronization.
    3.  OCR prescription scanner and manual medication management.
    4.  Adaptive notification system for reminders.
    5.  Care Group creation and management.
    6.  Basic AI-powered insights.
    7.  Admin portal for user management and AI cost monitoring.
    8.  Freemium model with in-app purchases.
-   **Future Enhancements (Post-MVP)**:
    -   Telemedicine consultations.
    -   Direct EMR/EHR integration.
    -   Advanced gamification with tangible rewards.
    -   A dynamically updated RAG knowledge base from live public health feeds.

# Logical Dependency Chain
1.  **Foundation (Task 1)**: Set up repositories, CI/CD, and initial database schema.
2.  **Core User Services (Task 2)**: Implement user authentication and profile management, as this is required for all other features.
3.  **Backend Features (Tasks 4, 5, 8)**: Develop backend support for prescription management, notifications, and AI insights.
4.  **Mobile MVP (Tasks 3, 4, 5, 6, 7)**: Build the core mobile experience, integrating with the backend services. The goal is to get a usable version into users' hands quickly.
5.  **Admin & Monetization (Tasks 10, 12)**: Develop the admin portal and implement monetization hooks in parallel or after the core user-facing features are stable.

# Risks and Mitigations
-   **Technical Challenge**: OCR accuracy for prescriptions.
    -   **Mitigation**: Use a state-of-the-art OCR/AI service and always require user confirmation of scanned data.
-   **Market Adoption**: User willingness to grant health data permissions.
    -   **Mitigation**: Be transparent about data usage, comply with local data privacy laws (Decree 13/2022), and clearly demonstrate the value of data sharing within the family context.
-   **Resource Constraints**: Limited development team size.
    -   **Mitigation**: Focus on a tightly-scoped MVP, leverage cross-platform frameworks (Flutter, NestJS), and build features iteratively.

# Appendix
-   **Success Metrics**: Monthly Active Users (MAU), medication adherence rate (>85%), free-to-premium conversion rate, system uptime (99.9%), and AI cost per user.
-   **Compliance**: The system must comply with Vietnam's Decree 13/2022/ND-CP on personal data protection.
</PRD>
