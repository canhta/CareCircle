# CareCircle AI Health Agent

CareCircle is a cross-platform health management platform designed to empower families to manage health together. It aggregates health data, leverages AI for medication management, and provides personalized reminders and family-centric care coordination. The ecosystem includes a Flutter mobile app for end-users, a robust NestJS backend, and a Next.js web portal for administration.

---

## Features
- **Health Data Integration:** Syncs with Apple HealthKit (iOS) and Google Fit (Android) for steps, heart rate, sleep, and more.
- **AI-powered Medication Management:** Scan paper prescriptions via OCR, auto-extract drug info, and generate smart reminders.
- **Personalized Notifications:** Daily check-ins, medication reminders, and intelligent escalation to caregivers if doses are missed.
- **Family Health Network:** Create care groups to share real-time health status, alerts, and coordinate care for loved ones.
- **AI Health Insights:** Summaries, trends, and coaching tips powered by AI.
- **Document Export & Sharing:** Export health summaries to PDF for sharing with clinicians.
- **Admin Web Portal:** Dashboard for system health, user management, and engagement statistics.

---

## Technology Stack

### Backend
- **Framework:** NestJS (Node.js, TypeScript)
- **Database:** PostgreSQL + TimescaleDB
- **ORM:** TypeORM
- **Authentication:** Passport.js (JWT, Google, Apple SSO)
- **API:** RESTful
- **Deployment:** Docker, GitHub Actions
- **Monitoring:** Prometheus, Grafana

### Frontend (Web Portal)
- **Framework:** Next.js (React, TypeScript)
- **Styling:** Tailwind CSS, Shadcn/UI
- **State Management:** React Context API, Zustand
- **Deployment:** Vercel

### Mobile App
- **Framework:** Flutter (Dart)
- **State Management:** BLoC
- **Navigation:** go_router
- **Native Integrations:** HealthKit, Google Fit, camera, OCR, push notifications
- **Build Tools:** Gradle (Android), Xcode (iOS)
- **CI/CD:** GitHub Actions

---

## Getting Started

### Prerequisites
- Node.js (for backend/frontend)
- Flutter SDK (for mobile)
- Docker (for local DB/dev)

### Backend (NestJS)
```bash
cd backend
npm install
npm run start:dev
```

### Frontend (Next.js)
```bash
cd frontend
npm install
npm run dev
```

### Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

---

## License

This project is licensed under the MIT License. 