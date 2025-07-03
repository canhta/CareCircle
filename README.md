# CareCircle AI Health Agent

A cross-platform health management ecosystem for families. Aggregates health data, provides AI-powered medication management, and enables care coordination through mobile, web, and backend services.

## ✨ Features

- **Health Integration:** Apple HealthKit & Google Fit sync, OCR prescription scanning
- **Family Care:** Secure care groups, permission-based sharing, emergency alerts
- **AI Insights:** Health trend analysis, risk assessment, personalized recommendations
- **Compliance:** GDPR-compliant document management with audit trails

## 🛠 Tech Stack

**Backend:** NestJS, PostgreSQL, Prisma, BullMQ, Redis  
**Frontend:** Next.js 15, React 19, Tailwind CSS  
**Mobile:** Flutter, BLoC, HealthKit/Google Fit  
**DevOps:** Docker, GitHub Actions, Husky

## 🚀 Quick Start

### Prerequisites

- Node.js 18+, Flutter SDK, Docker & Docker Compose

### Setup

```bash
# Clone and start services
git clone https://github.com/canhta/CareCircle.git
cd CareCircle
docker-compose up -d postgres redis
npm install

# Backend
cd backend && npm install
npm run db:generate && npm run db:migrate && npm run db:seed
npm run start:dev  # http://localhost:3001

# Frontend
cd frontend && npm install && npm run dev  # http://localhost:3000

# Mobile
cd mobile && flutter pub get && flutter run
```

## � Project Structure

```
CareCircle/
├── backend/         # NestJS API (auth, health-records, care-groups)
├── frontend/        # Next.js Admin Portal
├── mobile/          # Flutter App
├── docs/            # Documentation (PRD, BRD, research)
└── docker/          # Development environment
```

## ⚙️ Environment Variables

**Backend** (`.env`):

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/carecircle_dev"
JWT_SECRET="your-jwt-secret"
REDIS_URL="redis://localhost:6379"
GOOGLE_CLIENT_ID="your-google-client-id"
APPLE_CLIENT_ID="your-apple-client-id"
```

**Frontend** (`.env.local`):

```env
NEXT_PUBLIC_API_URL="http://localhost:3001"
```

## 🧪 Development

**Useful Commands:**

```bash
npm run lint          # Lint all projects
npm run format        # Format all code
npm run db:studio     # Open database GUI
flutter doctor        # Check Flutter setup
flutter test          # Run mobile tests
```

**Build for Production:**

```bash
# Backend
cd backend && npm run build

# Frontend
cd frontend && npm run build

# Mobile
cd mobile && flutter build ios --release
cd mobile && flutter build apk --release
```

## 🤝 Contributing

1. Fork → Create feature branch → Make changes → Test → Submit PR
2. Follow TypeScript/Dart best practices
3. Run `npm run pre-commit` before committing

**Author:** Canh Ta - [canhta.w@gmail.com](mailto:canhta.w@gmail.com)  
**License:** ISC  
**Repository:** [github.com/canhta/CareCircle](https://github.com/canhta/CareCircle)
