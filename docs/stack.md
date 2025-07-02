### Technology Stack

This document outlines the technology stack for the CareCircle project, covering the backend, frontend, and mobile application.

### Backend (BE)

- **Framework:** NestJS (A progressive Node.js framework for building efficient, reliable, and scalable server-side applications).
- **Language:** TypeScript
- **Database:** PostgreSQL with the TimescaleDB extension for handling large volumes of time-series data efficiently.
- **ORM:** TypeORM for object-relational mapping, simplifying database interactions.
- **Authentication:** Passport.js for handling JWT-based authentication and social sign-on (Google, Apple).
- **API:** RESTful API for standard client-server communication.
- **Deployment:** Docker for containerization, with CI/CD managed by GitHub Actions for automated builds, tests, and deployments.
- **Monitoring:** Prometheus and Grafana for real-time application health and performance monitoring.

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
- **Navigation:** `go_router` for declarative, URL-based routing that enables deep linking and a structured navigation flow.
- **Native Integrations:**
  - `health` for Apple HealthKit and Google Fit integration.
  - `camera` and `google_ml_kit_text_recognition` for prescription scanning.
  - `firebase_messaging` for push notifications.
- **Build Tools:** Gradle for Android and Xcode for iOS.
- **CI/CD:** GitHub Actions for automated building and testing.
