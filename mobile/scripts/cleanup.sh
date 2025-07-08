#!/bin/bash

# Flutter Project Cleanup and Reinstall Script
# This script cleans up Flutter project dependencies and reinstalls everything fresh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the mobile directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the mobile directory."
    exit 1
fi

print_status "Starting Flutter project cleanup and reinstall..."

# Step 1: Flutter clean
print_status "Running flutter clean..."
flutter clean

# Step 2: Remove pub cache lock files
print_status "Removing pub cache lock files..."
rm -f pubspec.lock
rm -rf .dart_tool/

# Step 3: Clean iOS specific files
if [ -d "ios" ]; then
    print_status "Cleaning iOS dependencies..."
    
    # Remove Pods directory and Podfile.lock
    rm -rf ios/Pods/
    rm -f ios/Podfile.lock
    
    # Remove derived data and build artifacts
    rm -rf ios/.symlinks/
    rm -rf ios/Flutter/Flutter.framework
    rm -rf ios/Flutter/Flutter.podspec
    
    # Clean Xcode derived data (if xcodebuild is available)
    if command -v xcodebuild &> /dev/null; then
        print_status "Cleaning Xcode derived data..."
        xcodebuild clean -workspace ios/Runner.xcworkspace -scheme Runner 2>/dev/null || true
    fi
fi

# Step 4: Clean Android specific files
if [ -d "android" ]; then
    print_status "Cleaning Android dependencies..."
    
    # Remove gradle cache and build directories
    rm -rf android/.gradle/
    rm -rf android/build/
    rm -rf android/app/build/
    rm -rf android/.dart_tool/
fi

# Step 5: Get Flutter dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Step 6: Upgrade Flutter dependencies (optional - can be commented out)
print_status "Upgrading Flutter dependencies..."
flutter pub upgrade

# Step 7: Install iOS pods (if iOS directory exists)
if [ -d "ios" ]; then
    print_status "Installing iOS CocoaPods dependencies..."
    cd ios
    
    # Update CocoaPods repo (optional, can be slow)
    # pod repo update
    
    # Install pods
    pod install --repo-update
    cd ..
fi

# Step 8: Clean and rebuild (optional)
print_status "Running flutter clean again after dependency installation..."
flutter clean

print_status "Getting dependencies one more time..."
flutter pub get

# Step 9: Verify installation
print_status "Verifying Flutter installation..."
flutter doctor

print_success "Flutter project cleanup and reinstall completed successfully!"
print_status "You can now run: flutter run --dart-define-from-file=.env.development"
