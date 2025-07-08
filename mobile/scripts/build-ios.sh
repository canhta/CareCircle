#!/bin/bash
set -e

echo "Building iOS app for development..."
flutter build ios --flavor development --dart-define=ENVIRONMENT=development

echo "Building iOS app for production..."
flutter build ios --flavor production --dart-define=ENVIRONMENT=production
