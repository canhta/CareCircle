#!/bin/bash

# Flutter Development Script
# This script starts the Flutter development environment with optimizations

set -e

# Default values
DEVICE=""
PERFORMANCE_MODE=false
NETWORK_DEBUG=false
WEB_PORT=8080
PROFILE_MODE=false
DEBUG_LEVEL="info"
FAST_START=false
SKIP_BUILD_RUNNER=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -p|--performance)
            PERFORMANCE_MODE=true
            shift
            ;;
        -n|--network-debug)
            NETWORK_DEBUG=true
            shift
            ;;
        -w|--web-port)
            WEB_PORT="$2"
            shift 2
            ;;
        -r|--profile)
            PROFILE_MODE=true
            shift
            ;;
        -l|--log-level)
            DEBUG_LEVEL="$2"
            shift 2
            ;;
        -f|--fast)
            FAST_START=true
            shift
            ;;
        -s|--skip-build-runner)
            SKIP_BUILD_RUNNER=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -d, --device             Device to run on (device_id or 'menu' for interactive)"
            echo "  -p, --performance        Run with performance overlay"
            echo "  -n, --network-debug      Enable network debugging"
            echo "  -w, --web-port           Web server port (default: 8080)"
            echo "  -r, --profile            Run in profile mode"
            echo "  -l, --log-level          Log level (verbose|debug|info|warning|error)"
            echo "  -f, --fast               Fast start (skip dependency checks)"
            echo "  -s, --skip-build-runner  Skip build_runner generation"
            echo "  -h, --help               Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🚀 Starting Flutter development..."

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter and add it to your PATH."
    exit 1
fi

# Quick dependency check unless fast start is enabled
if [[ "$FAST_START" != true ]]; then
    echo "📦 Checking dependencies..."
    flutter pub get --suppress-analytics
    
    # Check for any outdated dependencies
    OUTDATED=$(flutter pub outdated --no-dev-dependencies --mode=null-safety 2>/dev/null | grep -c "^\s*[├└]")
    if [[ $OUTDATED -gt 0 ]]; then
        echo "⚠️  You have $OUTDATED outdated package(s). Consider upgrading with 'flutter pub upgrade'."
    fi
fi

# Run build_runner if needed
if [[ "$SKIP_BUILD_RUNNER" != true ]]; then
    if grep -q "build_runner" pubspec.yaml; then
        echo "🔧 Running build_runner..."
        if [[ -f "lib/generated" || -f "lib/**/*.g.dart" || -f "lib/**/*.freezed.dart" ]]; then
            flutter pub run build_runner build --delete-conflicting-outputs
        fi
    fi
fi

# Configure log level
case $DEBUG_LEVEL in
    verbose)
        FLUTTER_LOG="--verbose"
        ;;
    debug)
        FLUTTER_LOG="--verbose"
        ;;
    info)
        FLUTTER_LOG=""
        ;;
    warning)
        FLUTTER_LOG="--log-tag=WARNING"
        ;;
    error)
        FLUTTER_LOG="--log-tag=ERROR"
        ;;
    *)
        FLUTTER_LOG=""
        ;;
esac

# Configure performance mode
PERF_FLAGS=""
if [[ "$PERFORMANCE_MODE" == true ]]; then
    PERF_FLAGS="--trace-skia --trace-systrace"
    echo "🔍 Performance overlay enabled"
fi

# Configure network debugging
if [[ "$NETWORK_DEBUG" == true ]]; then
    echo "🌐 Network debugging enabled"
    if [[ -f "lib/main.dart" ]]; then
        # Create a temporary file with network debugging enabled
        TMP_FILE=$(mktemp)
        cat > $TMP_FILE << 'EOF'
// Temporary network debugging setup
import 'dart:developer';
import 'package:dio/dio.dart';

void setupNetworkDebugging(Dio dio) {
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    logPrint: (obj) => log(obj.toString()),
  ));
}
EOF
        echo "📝 Network debugging helpers created"
        echo "💡 Add 'setupNetworkDebugging(yourDioInstance);' to your app initialization"
    fi
fi

# Show available devices
echo "📱 Available devices:"
flutter devices

# Device selection
if [[ "$DEVICE" == "menu" || "$DEVICE" == "" ]]; then
    echo ""
    echo "🔍 Select a device to run on:"
    
    # Get available devices
    readarray -t DEVICES < <(flutter devices | grep "•" | awk -F'•' '{print $2}' | awk '{$1=$1};1')
    
    # Exit if no devices
    if [[ ${#DEVICES[@]} -eq 0 ]]; then
        echo "❌ No devices available. Connect a device or start an emulator."
        exit 1
    fi
    
    # Print device menu
    for i in "${!DEVICES[@]}"; do
        echo "$((i+1)). ${DEVICES[$i]}"
    done
    
    # Get user choice
    read -p "Enter device number (1-${#DEVICES[@]}): " DEVICE_NUM
    
    # Validate and select device
    if [[ $DEVICE_NUM =~ ^[0-9]+$ && $DEVICE_NUM -ge 1 && $DEVICE_NUM -le ${#DEVICES[@]} ]]; then
        SELECTED_DEVICE=${DEVICES[$((DEVICE_NUM-1))]}
        DEVICE=$(echo $SELECTED_DEVICE | awk '{print $1}')
        echo "📱 Selected device: $SELECTED_DEVICE"
    else
        echo "❌ Invalid selection. Using default device."
    fi
fi

# Build run command
RUN_CMD="flutter run"

if [ -n "$DEVICE" ]; then
    RUN_CMD="$RUN_CMD --device-id $DEVICE"
fi

# Add profile mode
if [[ "$PROFILE_MODE" == true ]]; then
    RUN_CMD="$RUN_CMD --profile"
    echo "📊 Running in profile mode for performance analysis"
else
    RUN_CMD="$RUN_CMD --debug"
fi

# Add web port if running on web
if [[ "$DEVICE" == *"web"* || "$DEVICE" == *"chrome"* ]]; then
    RUN_CMD="$RUN_CMD --web-port $WEB_PORT"
    echo "🌐 Web server port: $WEB_PORT"
fi

# Add performance flags
if [[ -n "$PERF_FLAGS" ]]; then
    RUN_CMD="$RUN_CMD $PERF_FLAGS"
fi

# Add log flags
if [[ -n "$FLUTTER_LOG" ]]; then
    RUN_CMD="$RUN_CMD $FLUTTER_LOG"
fi

# Final setup
echo "🎯 Running: $RUN_CMD"
echo ""
echo "💡 Development shortcuts:"
echo "  • r - Hot reload"
echo "  • R - Hot restart"
echo "  • h - Display help"
echo "  • c - Clear screen"
echo "  • q - Quit"
echo ""
echo "🔍 Performance tips:"
echo "  • Run in profile mode (-r) for accurate performance metrics"
echo "  • Use Performance Overlay (p) to monitor rendering and CPU"
echo "  • Enable slow animations (s) to identify UI issues"
echo ""

# Start the app
$RUN_CMD

# Cleanup on exit
if [[ -n "$TMP_FILE" && -f "$TMP_FILE" ]]; then
    rm $TMP_FILE
fi
