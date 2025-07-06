#!/bin/bash

# Flutter Setup Script
# This script sets up the Flutter development environment with optimizations

set -e

# Default values
PLATFORM="all"
VERBOSE=false
UPGRADE=false
SKIP_FLUTTER_UPGRADE=false
FORCE_INSTALL=false
CHECK_PERFORMANCE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -u|--upgrade)
            UPGRADE=true
            shift
            ;;
        -s|--skip-flutter-upgrade)
            SKIP_FLUTTER_UPGRADE=true
            shift
            ;;
        -f|--force)
            FORCE_INSTALL=true
            shift
            ;;
        -c|--check-performance)
            CHECK_PERFORMANCE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -p, --platform           Platform to setup (android, ios, all) [default: all]"
            echo "  -v, --verbose            Enable verbose output"
            echo "  -u, --upgrade            Upgrade dependencies"
            echo "  -s, --skip-flutter-upgrade Skip Flutter SDK upgrade"
            echo "  -f, --force              Force reinstallation of components"
            echo "  -c, --check-performance  Check setup performance issues"
            echo "  -h, --help               Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🚀 Setting up Flutter development environment..."
echo "Platform: $PLATFORM"
[[ "$UPGRADE" == true ]] && echo "Upgrade mode: enabled"
[[ "$CHECK_PERFORMANCE" == true ]] && echo "Performance check: enabled"

# Start timer
START_TIME=$(date +%s)

# Check OS
OS=$(uname -s)
case $OS in
    Darwin)
        echo "🍎 macOS detected"
        ;;
    Linux)
        echo "🐧 Linux detected"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "🪟 Windows detected"
        ;;
    *)
        echo "⚠️ Unknown OS: $OS"
        ;;
esac

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Upgrade Flutter if needed
if [[ "$SKIP_FLUTTER_UPGRADE" != true ]]; then
    echo "🔄 Updating Flutter SDK..."
    flutter upgrade
fi

# Flutter doctor
echo "🏥 Running Flutter doctor..."
if [[ "$VERBOSE" == true ]]; then
    flutter doctor -v
else
    flutter doctor
fi

# Flutter diagnostics for performance issues
if [[ "$CHECK_PERFORMANCE" == true ]]; then
    echo "🔍 Checking Flutter setup performance..."
    if [[ "$OS" == "Darwin" ]]; then
        # Check if running on Apple Silicon with Rosetta
        if [[ $(uname -m) == "arm64" ]]; then
            echo "📱 Detected Apple Silicon (M1/M2/M3)"
            if grep -q "x86_64" <(file $(which flutter)); then
                echo "⚠️  Flutter is running under Rosetta translation. For better performance, consider using the ARM version."
            else
                echo "✅ Running native ARM Flutter - good for performance"
            fi
        fi
    fi
    
    # Check for Android emulator acceleration
    if [[ "$PLATFORM" == "all" || "$PLATFORM" == "android" ]]; then
        echo "🔍 Checking Android emulator acceleration..."
        if [[ "$OS" == "Darwin" ]]; then
            if ! pkgutil --pkg-info com.intel.kext.intelhaxm &>/dev/null && ! pgrep -q "vmd"; then
                echo "⚠️  Hardware acceleration may not be enabled for Android emulators. Performance will be affected."
            else
                echo "✅ Android emulator acceleration appears to be configured"
            fi
        elif [[ "$OS" == "Linux" ]]; then
            if ! grep -q "kvm" /proc/cpuinfo; then
                echo "⚠️  KVM acceleration may not be available. Check with 'kvm-ok' command"
            fi
        fi
    fi
    
    # Check for common performance issues
    if [[ -d ".dart_tool" ]]; then
        CACHE_SIZE=$(du -sh .dart_tool | awk '{print $1}')
        echo "💾 Dart tool cache size: $CACHE_SIZE"
        if [[ $CACHE_SIZE > "500M" ]]; then
            echo "⚠️  Large Dart cache detected, may slow down build times"
        fi
    fi
fi

# Get dependencies
echo "📦 Getting Flutter dependencies..."
if [[ "$UPGRADE" == true ]]; then
    echo "🔄 Upgrading dependencies..."
    flutter pub upgrade --major-versions
else
    flutter pub get
fi

# Check for project-level configuration issues
echo "🔍 Checking project configuration..."

# Check pubspec for common configuration issues
if [[ -f "pubspec.yaml" ]]; then
    # Check Flutter SDK constraint
    FLUTTER_SDK_CONSTRAINT=$(grep "flutter:" pubspec.yaml -A 2 | grep "sdk:" | awk '{print $2}' | tr -d "'\"")
    if [[ -n "$FLUTTER_SDK_CONSTRAINT" ]]; then
        echo "🔷 Flutter SDK constraint: $FLUTTER_SDK_CONSTRAINT"
    else
        echo "⚠️  No Flutter SDK constraint found in pubspec.yaml"
    fi
    
    # Check for dependency conflict resolution
    if ! grep -q "dependency_overrides:" pubspec.yaml && [[ "$UPGRADE" == true ]]; then
        echo "🔍 Checking for dependency conflicts..."
        flutter pub deps > /dev/null
    fi
fi

# Check for .env file
if [[ ! -f ".env" ]]; then
    echo "⚠️  .env file not found."
    if [[ -f ".env.example" ]]; then
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
if [[ "$PLATFORM" == "all" || "$PLATFORM" == "ios" ]]; then
    if [[ "$OS" == "Darwin" && -d "ios" ]]; then
        echo "🍎 Setting up iOS..."
        
        # Check Xcode CLI tools
        if ! xcode-select -p &> /dev/null; then
            echo "⚠️  Xcode Command Line Tools not found. Installing..."
            xcode-select --install
        fi
        
        # Check CocoaPods installation
        if ! command -v pod &> /dev/null; then
            echo "⚠️  CocoaPods not found. Installing..."
            sudo gem install cocoapods
        else
            if [[ "$UPGRADE" == true ]]; then
                echo "🔄 Updating CocoaPods..."
                sudo gem update cocoapods
            fi
            
            echo "🔍 CocoaPods version: $(pod --version)"
            
            # Ensure Pods repo is up to date
            if [[ "$FORCE_INSTALL" == true ]]; then
                echo "🔄 Updating CocoaPods repo..."
                pod repo update
            fi
        fi
        
        # Install iOS dependencies
        echo "📦 Installing iOS dependencies..."
        
        # Check for M1/M2/M3 Mac
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            echo "🔷 Detected ARM architecture, setting up for M-series Mac..."
            cd ios
            arch -x86_64 pod install
            cd ..
        else
            cd ios
            pod install
            cd ..
        fi
        
        # Create export options plist if it doesn't exist
        if [[ ! -f "ios/ExportOptions.plist" ]]; then
            echo "📄 Creating default iOS export options file..."
            cat > ios/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
EOF
            echo "✏️  Please edit ios/ExportOptions.plist with your team ID"
        fi
    elif [[ "$OS" != "Darwin" ]]; then
        echo "⚠️  iOS setup requires macOS"
    fi
fi

# Android specific setup
if [[ "$PLATFORM" == "all" || "$PLATFORM" == "android" ]]; then
    if [[ -d "android" ]]; then
        echo "🤖 Setting up Android..."
        
        # Check for JAVA_HOME
        if [[ -z "$JAVA_HOME" ]]; then
            echo "⚠️  JAVA_HOME environment variable not set"
        else
            echo "🔷 Java: $JAVA_HOME"
        fi
        
        # Check Android SDK installation
        FLUTTER_CONFIG=$(flutter config --machine)
        ANDROID_SDK=$(echo $FLUTTER_CONFIG | grep -o '"androidSdkPath":"[^"]*"' | sed 's/"androidSdkPath":"\(.*\)"/\1/')
        
        if [[ -z "$ANDROID_SDK" ]]; then
            echo "⚠️  Android SDK path not found in Flutter config"
        else
            echo "🔷 Android SDK: $ANDROID_SDK"
            
            # Check for necessary Android SDK components
            if [[ -f "$ANDROID_SDK/platform-tools/adb" ]]; then
                echo "✅ Android platform tools found"
            else
                echo "⚠️  Android platform tools not found"
            fi
        fi
        
        echo "📄 Accepting Android licenses..."
        yes | flutter doctor --android-licenses 2>/dev/null || true
        
        # Add local.properties if not exist
        if [[ ! -f "android/local.properties" && -n "$ANDROID_SDK" ]]; then
            echo "📄 Creating Android local.properties..."
            echo "sdk.dir=$ANDROID_SDK" > android/local.properties
        fi
        
        # Configure Gradle
        if [[ -f "android/gradle.properties" ]]; then
            # Enable Gradle caching for faster builds
            if ! grep -q "org.gradle.caching=true" android/gradle.properties; then
                echo "🔧 Enabling Gradle caching for faster builds..."
                echo "org.gradle.caching=true" >> android/gradle.properties
            fi
            
            # Enable parallel builds
            if ! grep -q "org.gradle.parallel=true" android/gradle.properties; then
                echo "🔧 Enabling parallel builds..."
                echo "org.gradle.parallel=true" >> android/gradle.properties
            fi
            
            # Set appropriate Gradle memory settings
            if ! grep -q "org.gradle.jvmargs" android/gradle.properties; then
                echo "🔧 Setting optimal Gradle memory configuration..."
                echo "org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=1024m -XX:+HeapDumpOnOutOfMemoryError" >> android/gradle.properties
            fi
        fi
    fi
fi

# Create useful script links in project root
echo "🔧 Creating development script links..."
for script in scripts/*.sh; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")
        ln -sf "$script" "./$script_name" 2>/dev/null || true
    fi
done

# End time and duration calculation
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo "✅ Setup completed in ${MINUTES}m ${SECONDS}s!"
echo ""
echo "🎯 Available scripts:"
echo "  • ./dev.sh      - Start development server"
echo "  • ./build.sh    - Build the app"
echo "  • ./clean.sh    - Clean project"
echo ""
echo "📱 Next steps:"
echo "  1. Edit the .env file with your configuration"
echo "  2. Run './dev.sh' to start development"
