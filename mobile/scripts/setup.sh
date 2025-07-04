#!/bin/bash

# Flutter Setup Script
# This script sets up the Flutter development environment

set -e

echo "🚀 Setting up Flutter development environment..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Flutter doctor
echo "🏥 Running Flutter doctor..."
flutter doctor

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Check for .env file
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found."
    if [ -f ".env.example" ]; then
        echo "📄 Copying .env.example to .env..."
        cp .env.example .env
    else
        echo "Creating basic .env file..."
        cat > .env << EOF
# Environment Configuration
ENV=development
API_BASE_URL=http://localhost:3000
API_TIMEOUT=30000
EOF
    fi
    echo "✏️  Please edit .env file with your configuration"
fi

# iOS specific setup
if [ -d "ios" ]; then
    echo "🍎 Setting up iOS..."
    if command -v pod &> /dev/null; then
        echo "📦 Installing iOS dependencies..."
        cd ios
        pod install
        cd ..
    else
        echo "⚠️  CocoaPods not found. Install it with: sudo gem install cocoapods"
    fi
fi

# Android specific setup
if [ -d "android" ]; then
    echo "🤖 Setting up Android..."
    echo "📄 Accepting Android licenses..."
    yes | flutter doctor --android-licenses 2>/dev/null || true
fi

echo "✅ Setup completed!"
echo ""
echo "🎯 Available scripts:"
echo "  - ./scripts/dev.sh      - Start development server"
echo "  - ./scripts/build.sh    - Build the app"
echo "  - ./scripts/clean.sh    - Clean project"
echo "  - ./scripts/deploy.sh   - Deploy the app"
