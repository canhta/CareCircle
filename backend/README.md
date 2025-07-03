# CareCircle Backend

A NestJS-based backend service for the CareCircle healthcare management platform.

[![Backend Build Status](https://img.shields.io/badge/build-passing-brightgreen)](../)

## Description

The CareCircle backend provides REST APIs for managing user accounts, health data integration, prescription management, notifications, and care group functionality. Built with NestJS for scalability and maintainability.

## Project Structure

```
backend/
  ├── src/
  │   ├── app.module.ts
  │   ├── auth/
  │   ├── care-group/
  │   ├── daily-check-in/
  │   ├── document/
  │   ├── health-record/
  │   ├── notification/
  │   ├── prescription/
  │   ├── prisma/
  │   └── user/
  ├── prisma/
  │   └── schema.prisma
  └── ...
```

## Project Setup

```bash
npm install
```

## Compile and Run the Project

```bash
# development
npm run start

# watch mode
npm run start:dev

# production mode
npm run start:prod
```

## Database Migration & Seeding

```bash
# Generate Prisma client
npm run db:generate

# Run migrations
npm run db:migrate

# Seed the database
npm run db:seed
```

## Environment Variables

| Variable     | Description                  | Example                                                      |
| ------------ | ---------------------------- | ------------------------------------------------------------ |
| DATABASE_URL | PostgreSQL connection string | postgresql://postgres:password@localhost:5432/carecircle_dev |
| JWT_SECRET   | JWT secret key               | your_jwt_secret                                              |
| ...          | ...                          | ...                                                          |

## API Documentation

- The API is documented using Swagger. After running the backend, visit: `http://localhost:3000/api`
- For more details, see [frontend/README.md](../frontend/README.md) and [mobile/README.md](../mobile/README.md)

## Related Docs

- [Frontend README](../frontend/README.md)
- [Mobile README](../mobile/README.md)
- [Docker README](../docker/README.md)
