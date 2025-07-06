#!/bin/bash

# Flutter Build Script
# This script builds the Flutter app for iOS and Android with optimizations

set -e

# Default values
PLATFORM="all"
BUILD_TYPE="release"
FLAVOR="production"
BUILD_NUMBER=""
VERBOSE=""
CLEAN_BUILD=false
OBFUSCATE=false
SPLIT_DEBUG_INFO=""
SIMULATOR_MODE=false

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
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -n|--build-number)
            BUILD_NUMBER="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN_BUILD=true
            shift
            ;;
        -v|--verbose)
            VERBOSE="--verbose"
            shift
            ;;
        -o|--obfuscate)
            OBFUSCATE=true
            shift
            ;;
        -s|--split-debug-info)
            SPLIT_DEBUG_INFO="$2"
            shift 2
            ;;
        --simulator)
            SIMULATOR_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -p, --platform         Platform to build (android, ios, all) [default: all]"
            echo "  -t, --type             Build type (debug, profile, release) [default: release]"
            echo "  -f, --flavor           Build flavor (dev, staging, production) [default: production]"
            echo "  -n, --build-number     Specify build number"
            echo "  -c, --clean            Perform clean build"
            echo "  -v, --verbose          Enable verbose output"
            echo "  -o, --obfuscate        Obfuscate code (release builds only)"
            echo "  -s, --split-debug-info Path to split debug info"
            echo "  --simulator            Build for iOS simulator"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                     Build all platforms in release mode"
            echo "  $0 -p android          Build Android only"
            echo "  $0 -p ios --simulator  Build iOS for simulator"
            echo "  $0 -t debug            Build debug version"
            echo "  $0 -o -s build/debug   Build with obfuscation and debug info"
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
echo "Flavor: $FLAVOR"
[[ -n "$BUILD_NUMBER" ]] && echo "Build Number: $BUILD_NUMBER"

# Build flags
BUILD_FLAGS="--$BUILD_TYPE $VERBOSE"
[[ -n "$BUILD_NUMBER" ]] && BUILD_FLAGS="$BUILD_FLAGS --build-number=$BUILD_NUMBER"

# For release builds, add optimization flags
if [[ "$BUILD_TYPE" == "release" ]]; then
    if [[ "$OBFUSCATE" == true ]]; then
        BUILD_FLAGS="$BUILD_FLAGS --obfuscate"
        [[ -n "$SPLIT_DEBUG_INFO" ]] && BUILD_FLAGS="$BUILD_FLAGS --split-debug-info=$SPLIT_DEBUG_INFO"
    fi
    
    # Tree shaking for images to reduce app size
    BUILD_FLAGS="$BUILD_FLAGS --tree-shake-icons"
    
    # Dart defines for environment
    BUILD_FLAGS="$BUILD_FLAGS --dart-define=ENVIRONMENT=$FLAVOR"
fi

# Perform clean if requested
if [[ "$CLEAN_BUILD" == true ]]; then
    echo "🧹 Performing clean build..."
    flutter clean
fi

# Ensure dependencies are up to date
echo "📦 Getting dependencies..."
flutter pub get --suppress-analytics

# Build start time
START_TIME=$(date +%s)

# Create output directory if it doesn't exist
mkdir -p build/outputs

# Build for platform
case $PLATFORM in
    android)
        echo "🤖 Building for Android..."
        
        # Check if keystore exists for release builds
        if [[ "$BUILD_TYPE" == "release" && ! -f "android/app/upload-keystore.jks" ]]; then
            echo "⚠️ Warning: Release keystore not found. Using debug signing."
        fi
        
        # Enable multidex for Android
        echo "Configuring Android build..."
        if [[ -f "android/app/build.gradle" ]]; then
            grep -q "multiDexEnabled true" android/app/build.gradle || 
                echo "⚠️ Warning: multiDexEnabled not set in build.gradle. Large apps may fail to build."
        fi
        
        # Build with optimizations
        echo "📱 Building APK..."
        flutter build apk $BUILD_FLAGS
        cp build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.apk
        
        echo "📦 Building App Bundle..."
        flutter build appbundle $BUILD_FLAGS
        cp build/app/outputs/bundle/$BUILD_TYPE/app-$BUILD_TYPE.aab build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.aab
        ;;
    ios)
        echo "🍎 Building for iOS..."
        
        # Check if development team is set for iOS
        if [[ ! -f "ios/Runner.xcworkspace/contents.xcworkspacedata" ]]; then
            echo "⚠️ Warning: iOS workspace not found. Run 'flutter create --platforms=ios .' to set up iOS."
        fi
        
        # Set simulator flag if needed
        if [[ "$SIMULATOR_MODE" == true ]]; then
            BUILD_FLAGS="$BUILD_FLAGS --simulator"
            echo "📱 Building for iOS simulator"
        else
            echo "📱 Building for iOS device (requires valid provisioning profile)"
        fi
        
        # Optimize iOS build - set build mode
        if [[ "$BUILD_TYPE" == "release" ]]; then
            # Set Swift optimization level for release
            if [[ -f "ios/Podfile" ]]; then
                echo "Applying Swift optimizations..."
                # We already have Swift optimization in Podfile from our previous fix
                cd ios && pod install && cd ..
            fi
        fi
        
        # Build iOS
        flutter build ios $BUILD_FLAGS
        
        # Archive IPA if in release mode and not in simulator mode
        if [[ "$BUILD_TYPE" == "release" && "$SIMULATOR_MODE" == false ]]; then
            echo "📦 Attempting to archive IPA..."
            mkdir -p build/ios/ipa
            
            # Check if ExportOptions.plist exists
            if [[ -f "ios/ExportOptions.plist" ]]; then
                xcrun xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -config Release archive -archivePath build/ios/Runner.xcarchive || {
                    echo "❌ Archive failed. This is expected if you don't have a valid provisioning profile."
                    echo "ℹ️ You can still use the build/ios/ directory to manually archive in Xcode."
                    echo "ℹ️ Or try building with '--simulator' flag for simulator builds."
                }
                
                if [[ -d "build/ios/Runner.xcarchive" ]]; then
                    xcrun xcodebuild -exportArchive -archivePath build/ios/Runner.xcarchive -exportOptionsPlist ios/ExportOptions.plist -exportPath build/ios/ipa/ || {
                        echo "❌ Export failed. You may need to update your ExportOptions.plist."
                    }
                    
                    # Copy IPA to outputs directory
                    if [[ -f "build/ios/ipa/Runner.ipa" ]]; then
                        cp build/ios/ipa/Runner.ipa build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.ipa
                        echo "✅ IPA archived successfully!"
                    else
                        echo "⚠️ Warning: IPA file not generated. Check Xcode configuration and signing."
                    fi
                fi
            else
                echo "⚠️ Warning: ExportOptions.plist not found. IPA archiving skipped."
                echo "Please create ios/ExportOptions.plist for app distribution."
            fi
        fi
        ;;
    all)
        # Call this script recursively for each platform
        OBFUSCATION_FLAGS=""
        if [[ "$OBFUSCATE" == true && -n "$SPLIT_DEBUG_INFO" ]]; then
            OBFUSCATION_FLAGS="-o -s \"$SPLIT_DEBUG_INFO\""
        fi
        
        # Add simulator flag if needed
        SIMULATOR_FLAG=""
        if [[ "$SIMULATOR_MODE" == true ]]; then
            SIMULATOR_FLAG="--simulator"
        fi
        
        "$0" -p android -t "$BUILD_TYPE" -f "$FLAVOR" ${BUILD_NUMBER:+-n "$BUILD_NUMBER"} ${CLEAN_BUILD:+-c} ${VERBOSE:+-v} $OBFUSCATION_FLAGS
        "$0" -p ios -t "$BUILD_TYPE" -f "$FLAVOR" ${BUILD_NUMBER:+-n "$BUILD_NUMBER"} ${VERBOSE:+-v} $OBFUSCATION_FLAGS $SIMULATOR_FLAG
        ;;
    *)
        echo "❌ Unknown platform: $PLATFORM"
        exit 1
        ;;
esac

# Build end time and duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo "✅ Build completed in ${MINUTES}m ${SECONDS}s!"

# Show output locations
echo ""
echo "📁 Build outputs stored in build/outputs/:"
if [ "$PLATFORM" == "all" ] || [ "$PLATFORM" == "android" ]; then
    echo "  Android APK: build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.apk"
    echo "  Android AAB: build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.aab"
fi
if [ "$PLATFORM" == "all" ] || [ "$PLATFORM" == "ios" ]; then
    echo "  iOS IPA: build/outputs/carecircle-$FLAVOR-$BUILD_TYPE.ipa"
fi
