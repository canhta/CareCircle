#!/bin/bash

# CareCircle Mobile Environment Setup Script
# This script helps configure the mobile app to connect to the backend

echo "🔧 CareCircle Mobile Environment Setup"
echo "======================================"

# Get the local IP address
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    LOCAL_IP=$(hostname -I | awk '{print $1}')
else
    echo "❌ Unsupported operating system"
    exit 1
fi

if [ -z "$LOCAL_IP" ]; then
    echo "❌ Could not determine local IP address"
    exit 1
fi

echo "📍 Detected local IP address: $LOCAL_IP"

# Default port (can be overridden)
PORT=${1:-3000}
API_URL="http://$LOCAL_IP:$PORT/api/v1"

echo "🌐 Backend API URL: $API_URL"

# Update the mobile environment file
ENV_FILE="mobile/.env.development"
echo "📝 Updating $ENV_FILE..."

cat > "$ENV_FILE" << EOF
# CareCircle Mobile Development Environment Configuration
# Auto-generated on $(date)

# Backend API Configuration
API_BASE_URL=$API_URL
ENVIRONMENT=development
ENABLE_LOGGING=true

# Instructions:
# 1. Start the backend server: cd backend && npm run start:dev
# 2. Run mobile app: flutter run --dart-define-from-file=.env.development
EOF

echo "✅ Mobile environment configured successfully!"
echo ""
echo "📱 Next steps:"
echo "   1. Start the backend: cd backend && npm run start:dev"
echo "   2. Run the mobile app: cd mobile && flutter run --dart-define-from-file=.env.development"
echo ""
echo "🔄 If your IP address changes, run this script again:"
echo "   ./scripts/setup-mobile-env.sh [port]"
