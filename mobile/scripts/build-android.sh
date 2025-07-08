#!/bin/bash
set -e

echo "Building Android APK for development..."
flutter build apk --flavor development --dart-define=ENVIRONMENT=development

echo "Building Android APK for production..."
flutter build apk --flavor production --dart-define=ENVIRONMENT=production

echo "Building Android App Bundle for production..."
flutter build appbundle --flavor production --dart-define=ENVIRONMENT=production
