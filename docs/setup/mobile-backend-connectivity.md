# Mobile-Backend Connectivity Setup

This guide explains how to configure the mobile app to connect to the backend API during development.

## Overview

For mobile development, the app needs to connect to the backend API running on your local machine. Since mobile devices/simulators can't use `localhost`, we need to use your machine's actual IP address.

## Automatic Setup (Recommended)

### Quick Setup Script

Run the automated setup script to configure mobile connectivity:

```bash
# From the project root
./scripts/setup-mobile-env.sh

# Or specify a custom port if backend runs on different port
./scripts/setup-mobile-env.sh 3001
```

This script will:
1. Detect your local IP address automatically
2. Update the mobile environment configuration
3. Provide next steps for running the apps

### Manual Setup

If you prefer manual configuration:

1. **Start the backend and note the IP address:**
   ```bash
   cd backend
   npm run start:dev
   ```
   
   Look for output like:
   ```
   🚀 CareCircle Backend is running:
      Local:    http://localhost:3000/api/v1
      Network:  http://192.168.9.103:3000/api/v1
   
   📱 For mobile development, use the Network URL
      Mobile API Base URL: http://192.168.9.103:3000/api/v1
   ```

2. **Update mobile environment file:**
   
   Edit `mobile/.env.development`:
   ```env
   API_BASE_URL=http://192.168.9.103:3000/api/v1
   ENVIRONMENT=development
   ENABLE_LOGGING=true
   ```

3. **Run the mobile app:**
   ```bash
   cd mobile
   flutter run --dart-define-from-file=.env.development
   ```

## Backend Configuration

The backend is automatically configured to:

1. **Display IP addresses** - Shows both localhost and network URLs on startup
2. **Allow CORS** - Accepts requests from local network IP addresses
3. **Support mobile development** - Optimized for mobile app connectivity

### CORS Configuration

The backend allows connections from:
- `localhost` (web development)
- Private network ranges:
  - `192.168.x.x` (most home networks)
  - `10.x.x.x` (corporate networks)
  - `172.16-31.x.x` (Docker/VPN networks)

## Mobile Configuration

The mobile app uses environment variables for API configuration:

- **`API_BASE_URL`** - Backend API endpoint
- **`ENVIRONMENT`** - Development/production mode
- **`ENABLE_LOGGING`** - Debug logging toggle

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Ensure backend is running
   - Check firewall settings
   - Verify IP address is correct

2. **CORS Errors**
   - Backend automatically allows local network IPs
   - Check console for specific CORS messages

3. **IP Address Changes**
   - Re-run setup script: `./scripts/setup-mobile-env.sh`
   - Or manually update `.env.development`

### Network Debugging

1. **Test backend connectivity:**
   ```bash
   # Replace with your actual IP
   curl http://192.168.9.103:3000/api/v1/auth/health
   ```

2. **Check mobile logs:**
   ```bash
   flutter logs
   ```

3. **Verify environment variables:**
   ```bash
   flutter run --dart-define-from-file=.env.development --verbose
   ```

## Development Workflow

### Daily Development

1. **Start backend:**
   ```bash
   cd backend && npm run start:dev
   ```

2. **Note the Network URL** from backend console output

3. **Run mobile app:**
   ```bash
   cd mobile && flutter run --dart-define-from-file=.env.development
   ```

### When IP Changes

If your IP address changes (new network, VPN, etc.):

```bash
./scripts/setup-mobile-env.sh
```

Then restart the mobile app.

## Production Considerations

For production deployment:

1. **Backend** - Deploy to cloud service with public IP/domain
2. **Mobile** - Update `API_BASE_URL` to production endpoint
3. **CORS** - Configure for production domains only
4. **SSL** - Use HTTPS for production API calls

## Files Reference

- **Backend startup**: `backend/src/main.ts`
- **Mobile config**: `mobile/lib/core/config/app_config.dart`
- **Environment file**: `mobile/.env.development`
- **Setup script**: `scripts/setup-mobile-env.sh`
