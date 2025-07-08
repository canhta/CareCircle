#!/bin/bash

# Change to mobile directory if script is run from elsewhere
if [[ ! -d "lib" && -d "../mobile" ]]; then
  cd ../mobile
elif [[ ! -d "lib" && -d "mobile" ]]; then
  cd mobile
fi

# Check if we're in the mobile directory
if [[ ! -d "lib" ]]; then
  echo "Error: Could not find mobile directory. Run this script from the project root or mobile directory."
  exit 1
fi

echo "Starting build_runner in watch mode..."
flutter pub run build_runner watch --delete-conflicting-outputs &
BUILD_RUNNER_PID=$!

echo "Starting Flutter debug mode..."
flutter run --debug

# When flutter run ends, kill the build_runner process
kill $BUILD_RUNNER_PID 