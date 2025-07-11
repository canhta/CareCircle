abstract class AppConfig {
  static const String appName = 'CareCircle';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.9.103:3000/api/v1',
  );
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  /// Check if the app is running in development mode
  static bool get isDevelopment => environment == 'development';
}
