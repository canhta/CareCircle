# CareCircle Mobile App

A Flutter-based mobile application for healthcare management and care coordination.

[![Mobile Build Status](https://img.shields.io/badge/build-passing-brightgreen)](../)

## Description

The CareCircle mobile app enables users to manage their health data, medications, care groups, and receive intelligent notifications for better health outcomes. Built with Flutter for cross-platform compatibility.

## Project Structure

```
mobile/
  ├── lib/
  │   ├── config/
  │   ├── managers/
  │   ├── models/
  │   ├── repositories/
  │   ├── screens/
  │   └── services/
  ├── android/
  ├── ios/
  ├── pubspec.yaml
  └── ...
```

## Features

- User authentication and profile management
- Health data integration (Apple HealthKit, Google Fit)
- OCR-based prescription scanning
- Intelligent medication reminders
- Daily health check-ins
- Care group collaboration
- Health insights and summaries
- Document export and sharing
- Accessibility features (Elder Mode)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode for mobile development
- iOS Simulator / Android Emulator

### Installation

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Running on Simulators/Emulators

- **Android:**
  1. Open Android Studio and launch an Android Emulator.
  2. Run `flutter run` or use the IDE's run button.
- **iOS:**
  1. Open Xcode and launch an iOS Simulator.
  2. Run `flutter run` or use the IDE's run button.

### Linting and Formatting

```bash
# Lint the code
flutter analyze

# Format the code
dart format .
```

### Building

```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

## Environment Variables

Copy `.env.example` to `.env` and configure the following:

| Variable            | Description            | Example               |
| ------------------- | ---------------------- | --------------------- |
| API_BASE_URL        | Backend API base URL   | http://localhost:3000 |
| FIREBASE_PROJECT_ID | Firebase project ID    | your-firebase-project |
| ENABLE_HEALTHKIT    | Enable Apple HealthKit | true                  |
| ENABLE_GOOGLE_FIT   | Enable Google Fit      | true                  |

## Troubleshooting

- If you encounter issues with dependencies, run `flutter pub get` again.
- For simulator/emulator issues, ensure your IDE and device tools are up to date.
- For iOS, ensure CocoaPods is installed and run `pod install` in the `ios/` directory if needed.
- For Android, check that the emulator is running and device is recognized with `flutter devices`.

## Related Docs

- [Backend README](../backend/README.md)
- [Frontend README](../frontend/README.md)
- [Docker README](../docker/README.md)
