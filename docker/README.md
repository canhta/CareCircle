# CareCircle Docker Development Environment

This document explains how to set up and use the Docker development environment for CareCircle.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)

## Services

The development environment includes the following services:

### Core Services
- **PostgreSQL** (Port 5432): Main database for the application
- **Redis** (Port 6379): Caching and session storage

### Admin Tools
- **pgAdmin** (Port 5050): PostgreSQL administration interface
- **Redis Commander** (Port 8081): Redis administration interface

## Quick Start

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Start only core services (PostgreSQL + Redis):**
   ```bash
   docker-compose up -d postgres redis
   ```

3. **View logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Stop all services:**
   ```bash
   docker-compose down
   ```

5. **Stop and remove volumes (⚠️ This will delete all data):**
   ```bash
   docker-compose down -v
   ```

## Database Management

### Initial Setup
```bash
# Generate Prisma client
npm run db:generate

# Run migrations
npm run db:migrate

# Seed the database with sample data
npm run db:seed
```

### Useful Commands
```bash
# Reset database (⚠️ This will delete all data)
npm run db:reset

# Open Prisma Studio
npm run db:studio

# View database with pgAdmin
# Go to http://localhost:5050
# Email: admin@carecircle.com
# Password: admin
```

## Connection Details

### PostgreSQL
- **Host:** localhost
- **Port:** 5432
- **Database:** carecircle_dev
- **Username:** postgres
- **Password:** password

### Redis
- **Host:** localhost
- **Port:** 6379
- **No password required**

## pgAdmin Setup

1. Open http://localhost:5050 in your browser
2. Login with:
   - Email: admin@carecircle.com
   - Password: admin
3. Add a new server:
   - Name: CareCircle Local
   - Host: postgres (Docker service name)
   - Port: 5432
   - Username: postgres
   - Password: password

## Redis Commander

Access Redis Commander at http://localhost:8081 to view and manage Redis data.

## Troubleshooting

### Port Conflicts
If you encounter port conflicts, you can modify the ports in `docker-compose.yml`:

```yaml
services:
  postgres:
    ports:
      - "5433:5432"  # Change host port
```

### Database Connection Issues
1. Ensure Docker services are running: `docker-compose ps`
2. Check container logs: `docker-compose logs postgres`
3. Verify environment variables in `.env` file

### Reset Everything
```bash
# Stop all containers and remove volumes
docker-compose down -v

# Remove all CareCircle Docker resources
docker system prune -f

# Start fresh
docker-compose up -d
npm run db:migrate
npm run db:seed
```

## Environment Variables

Make sure your `.env` file contains:

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/carecircle_dev"
REDIS_URL="redis://localhost:6379"
```
