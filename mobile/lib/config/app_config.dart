import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // API Configuration
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Firebase Configuration
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  // Platform Configuration
  static String get iosBundleId =>
      dotenv.env['IOS_BUNDLE_ID'] ?? 'com.carecircle.app';
  static String get androidPackageName =>
      dotenv.env['ANDROID_PACKAGE_NAME'] ?? 'com.carecircle.app';

  // Feature Flags
  static bool get enableHealthKit =>
      dotenv.env['ENABLE_HEALTHKIT']?.toLowerCase() == 'true';
  static bool get enableGoogleFit =>
      dotenv.env['ENABLE_GOOGLE_FIT']?.toLowerCase() == 'true';
  static bool get enableOcrScanning =>
      dotenv.env['ENABLE_OCR_SCANNING']?.toLowerCase() == 'true';
  static bool get enableAiInsights =>
      dotenv.env['ENABLE_AI_INSIGHTS']?.toLowerCase() == 'true';

  // Development Configuration
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'info';

  // App Information
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get buildNumber => dotenv.env['BUILD_NUMBER'] ?? '1';

  // Validation method to check if required environment variables are set
  static bool validateConfig() {
    final requiredVars = ['API_BASE_URL', 'FIREBASE_PROJECT_ID'];

    for (String varName in requiredVars) {
      if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
        print('Warning: Required environment variable $varName is not set');
        return false;
      }
    }
    return true;
  }

  // Helper method to print current configuration (for debugging)
  static void printConfig() {
    if (debugMode) {
      print('=== App Configuration ===');
      print('API Base URL: $apiBaseUrl');
      print('Firebase Project ID: $firebaseProjectId');
      print('App Version: $appVersion');
      print('Debug Mode: $debugMode');
      print('HealthKit Enabled: $enableHealthKit');
      print('Google Fit Enabled: $enableGoogleFit');
      print('OCR Scanning Enabled: $enableOcrScanning');
      print('AI Insights Enabled: $enableAiInsights');
      print('========================');
    }
  }
}
