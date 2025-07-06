#!/bin/bash

# Flutter Clean Script
# This script performs a clean of the Flutter project with optimizations

# Don't use "set -e" to avoid exiting on Java check errors
# set -e

# Default values
PLATFORM="all"
DEEP_CLEAN=false
PRESERVE_CACHE=false
REINSTALL_DEPS=true
ANALYZE_DEPS=false
VERBOSE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -d|--deep)
            DEEP_CLEAN=true
            shift
            ;;
        -c|--preserve-cache)
            PRESERVE_CACHE=true
            shift
            ;;
        -n|--no-reinstall)
            REINSTALL_DEPS=false
            shift
            ;;
        -a|--analyze-deps)
            ANALYZE_DEPS=true
            shift
            ;;
        -v|--verbose)
            VERBOSE="--verbose"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -p, --platform       Platform to clean (android, ios, all) [default: all]"
            echo "  -d, --deep           Perform a deeper clean (removes more cache files)"
            echo "  -c, --preserve-cache Preserve pub and gradle caches"
            echo "  -n, --no-reinstall   Skip dependency reinstallation"
            echo "  -a, --analyze-deps   Analyze and report unused dependencies"
            echo "  -v, --verbose        Enable verbose output"
            echo "  -h, --help           Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🧹 Cleaning Flutter project..."
echo "Platform: $PLATFORM"
[[ "$DEEP_CLEAN" == true ]] && echo "Deep clean: enabled"
[[ "$PRESERVE_CACHE" == true ]] && echo "Preserving cache: enabled"
[[ "$REINSTALL_DEPS" == false ]] && echo "Dependency reinstallation: disabled"

# Start time
START_TIME=$(date +%s)

# Check for unused dependencies if requested
if [[ "$ANALYZE_DEPS" == true ]]; then
    echo "📊 Analyzing dependencies..."
    
    # Check if flutter_unused_dep is installed
    if ! command -v flutter pub run flutter_unused_dep &> /dev/null; then
        echo "📦 Installing dependency analyzer..."
        flutter pub global activate flutter_unused_dep
    fi
    
    echo "📋 Unused dependencies report:"
    flutter pub run flutter_unused_dep
    echo ""
    
    read -p "Continue with cleaning? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cleaning canceled."
        exit 0
    fi
fi

# Clean Flutter
if [[ "$PLATFORM" == "all" ]]; then
    echo "🧼 Running Flutter clean..."
    flutter clean $VERBOSE
    
    # Remove build directories
    echo "🗑️ Removing build directories..."
    rm -rf build/
    
    if [[ "$DEEP_CLEAN" == true ]]; then
        echo "🧹 Performing deep clean..."
        rm -rf .dart_tool/
        rm -rf .flutter-plugins
        rm -rf .flutter-plugins-dependencies
        rm -rf .packages
        rm -rf pubspec.lock
        
        if [[ "$PRESERVE_CACHE" == false ]]; then
            echo "🗑️ Cleaning Flutter cache..."
            flutter pub cache repair
        fi
    fi
else
    echo "🧼 Skipping full Flutter clean for selective platform cleaning..."
    if [[ -d "build" ]]; then
        if [[ "$PLATFORM" == "android" ]]; then
            echo "🗑️ Removing Android build directories..."
            rm -rf build/app/outputs/flutter-apk/
            rm -rf build/app/outputs/bundle/
            rm -rf build/app/intermediates/
            rm -rf build/app/kotlin/
        elif [[ "$PLATFORM" == "ios" ]]; then
            echo "🗑️ Removing iOS build directories..."
            rm -rf build/ios/
            rm -rf build/Pods/
        fi
    fi
fi

# Clean iOS
if [[ "$PLATFORM" == "all" || "$PLATFORM" == "ios" ]]; then
    if [ -d "ios" ]; then
        echo "🍎 Cleaning iOS..."
        cd ios
        if [[ "$DEEP_CLEAN" == true ]]; then
            echo "🗑️ Removing derived data..."
            rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
        fi
        
        echo "🗑️ Removing Pods..."
        rm -rf Pods/
        rm -rf Podfile.lock
        rm -rf .symlinks/
        cd ..
    fi
fi

# Clean Android
if [[ "$PLATFORM" == "all" || "$PLATFORM" == "android" ]]; then
    if [ -d "android" ]; then
        echo "🤖 Cleaning Android..."
        
        # Test if Java is working by actually trying to run it
        JAVA_INSTALLED=false
        
        if java -version 2>/dev/null; then
            JAVA_INSTALLED=true
        fi
        
        if [[ "$JAVA_INSTALLED" != true ]]; then
            echo "⚠️  Java Runtime not found or not working. Skipping Gradle clean."
            echo "ℹ️  To install Java:"
            case "$(uname -s)" in
                Darwin)
                    echo "   - For macOS: brew install openjdk@17"
                    ;;
                Linux)
                    echo "   - For Ubuntu/Debian: sudo apt install openjdk-17-jdk"
                    echo "   - For Fedora: sudo dnf install java-17-openjdk"
                    ;;
                MINGW*|MSYS*)
                    echo "   - For Windows: Download from https://adoptium.net/"
                    ;;
            esac
            echo ""
            echo "🧹 Performing manual Android clean..."
            rm -rf android/build/ 2>/dev/null || true
            rm -rf android/app/build/ 2>/dev/null || true
            rm -rf android/.gradle/ 2>/dev/null || true
        else
            # If Java is available, proceed with Gradle clean
            echo "✅ Java detected, using Gradle for cleaning..."
            
            (
                cd android
                # Try to run gradlew directly
                if ./gradlew -version &>/dev/null; then
                    if [[ "$VERBOSE" != "" ]]; then
                        ./gradlew clean || {
                            echo "⚠️  Gradle clean failed. Performing manual clean..."
                            rm -rf build/ app/build/ .gradle/
                        }
                    else
                        ./gradlew clean -q || {
                            echo "⚠️  Gradle clean failed. Performing manual clean..."
                            rm -rf build/ app/build/ .gradle/
                        }
                    fi
                else
                    echo "⚠️  Gradle wrapper isn't working. Performing manual clean..."
                    rm -rf build/ app/build/ .gradle/
                fi
                
                if [[ "$DEEP_CLEAN" == true ]]; then
                    echo "🗑️ Removing Gradle cache..."
                    rm -rf .gradle/
                    if [[ "$PRESERVE_CACHE" == false ]]; then
                        echo "🗑️ Clearing Gradle cache..."
                        rm -rf ~/.gradle/caches/modules-2/files-2.1/com.android.tools.build/ 2>/dev/null || true
                    fi
                fi
            ) || {
                echo "⚠️  Error while cleaning Android. Continuing with other tasks..."
            }
        fi
    fi
fi

# Get dependencies
if [[ "$REINSTALL_DEPS" == true ]]; then
    echo "📥 Getting dependencies..."
    flutter pub get $VERBOSE || echo "⚠️  Error getting dependencies. You may need to fix pubspec.yaml issues."
    
    # iOS pod install
    if [[ "$PLATFORM" == "all" || "$PLATFORM" == "ios" ]]; then
        if [ -d "ios" ]; then
            echo "🍎 Installing iOS pods..."
            
            # Check if M1 Mac and set ARCH flag
            ARCH=$(uname -m)
            if [[ "$ARCH" == "arm64" ]]; then
                echo "🍏 Detected ARM architecture, setting pod flags for M1/M2 Macs..."
                ARCH_FLAGS="arch -x86_64"
            else
                ARCH_FLAGS=""
            fi
            
            (
                cd ios
                $ARCH_FLAGS pod install || { 
                    echo "⚠️ Pod install failed. Trying with repo update..."
                    $ARCH_FLAGS pod install --repo-update || echo "❌ Pod install failed. You may need to run 'pod repo update' manually."
                }
            ) || echo "⚠️  Error during pod install. Continuing with other tasks..."
        fi
    fi
fi

# End time and duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "✅ Clean completed in $DURATION seconds!"
echo ""
echo "💡 Next steps:"
echo "  - Run './dev.sh' to start development"
echo "  - Run './build.sh' to build the app"
