#!/bin/bash

# Flutter Clean Script
# This script performs a clean of the Flutter project

set -e

echo "🧹 Cleaning Flutter project..."

# Clean Flutter
flutter clean

# Remove build directories
rm -rf build/
rm -rf .dart_tool/

# Clean iOS
if [ -d "ios" ]; then
    echo "🍎 Cleaning iOS..."
    cd ios
    rm -rf Pods/
    rm -rf Podfile.lock
    cd ..
fi

# Clean Android
if [ -d "android" ]; then
    echo "🤖 Cleaning Android..."
    cd android
    ./gradlew clean || true
    cd ..
fi

# Get dependencies
echo "📥 Getting dependencies..."
flutter pub get

# iOS pod install
if [ -d "ios" ]; then
    echo "🍎 Installing iOS pods..."
    cd ios
    pod install
    cd ..
fi

echo "✅ Clean completed!"
