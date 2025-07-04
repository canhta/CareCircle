#!/bin/bash

# Flutter Build Script
# This script builds the Flutter app for iOS and Android

set -e

# Default values
PLATFORM="all"
BUILD_TYPE="release"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -p, --platform   Platform to build (android, ios, all) [default: all]"
            echo "  -t, --type       Build type (debug, release) [default: release]"
            echo "  -h, --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🚀 Building Flutter app..."
echo "Platform: $PLATFORM"
echo "Build Type: $BUILD_TYPE"

# Build for platform
case $PLATFORM in
    android)
        echo "🤖 Building for Android..."
        flutter build apk --$BUILD_TYPE
        flutter build appbundle --$BUILD_TYPE
        ;;
    ios)
        echo "🍎 Building for iOS..."
        flutter build ios --$BUILD_TYPE
        ;;
    all)
        echo "🤖 Building for Android..."
        flutter build apk --$BUILD_TYPE
        flutter build appbundle --$BUILD_TYPE
        echo "🍎 Building for iOS..."
        flutter build ios --$BUILD_TYPE
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        exit 1
        ;;
esac

echo "✅ Build completed!"

# Show output locations
echo ""
echo "📁 Build outputs:"
if [ "$PLATFORM" == "all" ] || [ "$PLATFORM" == "android" ]; then
    echo "  Android APK: build/app/outputs/flutter-apk/"
    echo "  Android AAB: build/app/outputs/bundle/release/"
fi
if [ "$PLATFORM" == "all" ] || [ "$PLATFORM" == "ios" ]; then
    echo "  iOS: build/ios/ipa/"
fi
