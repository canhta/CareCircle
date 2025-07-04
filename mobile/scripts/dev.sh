#!/bin/bash

# Flutter Development Script
# This script starts the Flutter development environment

set -e

# Default values
DEVICE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -d, --device       Device to run on (device_id)"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🚀 Starting Flutter development..."

# Show available devices
echo "📱 Available devices:"
flutter devices

# Build run command
RUN_CMD="flutter run"

if [ -n "$DEVICE" ]; then
    RUN_CMD="$RUN_CMD --device-id $DEVICE"
fi

echo "🎯 Running: $RUN_CMD"
echo ""
echo "💡 Hot reload tips:"
echo "  - Press 'r' to hot reload"
echo "  - Press 'R' to hot restart"
echo "  - Press 'q' to quit"
echo ""

# Run the app
$RUN_CMD
