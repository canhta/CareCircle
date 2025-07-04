import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Enhanced application configuration with modern dependencies
class AppConfig {
  static const String appName = 'CareCircle';
  static const String version = '1.0.0';

  // API Configuration - Environment-specific URLs
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        kDebugMode ? 'http://10.0.2.2:3000' : 'https://api.carecircle.com',
  );
  static const int apiTimeout = 30000;
  static const bool debugMode = kDebugMode;

  // Environment configuration
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: kDebugMode ? 'development' : 'production',
  );

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String dailyCheckInsEndpoint = '/daily-check-ins';
  static const String healthRecordsEndpoint = '/health-records';
  static const String careGroupsEndpoint = '/care-groups';
  static const String prescriptionsEndpoint = '/prescriptions';
  static const String notificationsEndpoint = '/notifications';
  static const String subscriptionsEndpoint = '/subscriptions';

  // Storage Configuration
  static late SharedPreferences _prefs;
  static late Logger _logger;
  static late Connectivity _connectivity;

  // Secure storage instance
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initialize the app configuration
  static Future<void> initialize() async {
    try {
      // Initialize shared preferences
      _prefs = await SharedPreferences.getInstance();

      // Initialize logger
      _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

      // Initialize connectivity
      _connectivity = Connectivity();

      _logger.i('AppConfig initialized successfully');
      _logger.i('Environment: $environment');
      _logger.i('API Base URL: $apiBaseUrl');
    } catch (e) {
      // Initialize a fallback logger for error reporting
      _logger = Logger(
        printer: SimplePrinter(),
      );

      _logger.e('Failed to initialize AppConfig: $e');

      if (kDebugMode) {
        print('Failed to initialize AppConfig: $e');
      }

      // Re-throw the error to let the caller handle it
      rethrow;
    }
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs => _prefs;

  /// Get Logger instance
  static Logger get logger => _logger;

  /// Get Connectivity instance
  static Connectivity get connectivity => _connectivity;

  // App Settings Keys
  static const String _themeMode = 'theme_mode';
  static const String _language = 'language';
  static const String _notificationsEnabled = 'notifications_enabled';
  static const String _biometricEnabled = 'biometric_enabled';
  static const String _onboardingCompleted = 'onboarding_completed';

  // Getters for app settings
  static String get themeMode => _prefs.getString(_themeMode) ?? 'system';
  static String get language => _prefs.getString(_language) ?? 'en';
  static bool get notificationsEnabled =>
      _prefs.getBool(_notificationsEnabled) ?? true;
  static bool get biometricEnabled =>
      _prefs.getBool(_biometricEnabled) ?? false;
  static bool get onboardingCompleted =>
      _prefs.getBool(_onboardingCompleted) ?? false;

  // Setters for app settings
  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeMode, mode);
    _logger.d('Theme mode set to: $mode');
  }

  static Future<void> setLanguage(String lang) async {
    await _prefs.setString(_language, lang);
    _logger.d('Language set to: $lang');
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsEnabled, enabled);
    _logger.d('Notifications enabled: $enabled');
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(_biometricEnabled, enabled);
    _logger.d('Biometric enabled: $enabled');
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingCompleted, completed);
    _logger.d('Onboarding completed: $completed');
  }

  // Secure Storage Keys
  static const String _accessToken = 'access_token';
  static const String _refreshToken = 'refresh_token';
  static const String _userId = 'user_id';
  static const String _userEmail = 'user_email';
  static const String _biometricKey = 'biometric_key';

  // Secure storage methods
  static Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: _accessToken, value: token);
    _logger.d('Access token stored securely');
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessToken);
  }

  static Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshToken, value: token);
    _logger.d('Refresh token stored securely');
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshToken);
  }

  static Future<void> setUserId(String id) async {
    await _secureStorage.write(key: _userId, value: id);
    _logger.d('User ID stored securely');
  }

  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userId);
  }

  static Future<void> setUserEmail(String email) async {
    await _secureStorage.write(key: _userEmail, value: email);
    _logger.d('User email stored securely');
  }

  static Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _userEmail);
  }

  static Future<void> setBiometricKey(String key) async {
    await _secureStorage.write(key: _biometricKey, value: key);
    _logger.d('Biometric key stored securely');
  }

  static Future<String?> getBiometricKey() async {
    return await _secureStorage.read(key: _biometricKey);
  }

  /// Clear all secure storage
  static Future<void> clearSecureStorage() async {
    // Clear each key individually or use deleteAll if available
    await _secureStorage.delete(key: _accessToken);
    await _secureStorage.delete(key: _refreshToken);
    await _secureStorage.delete(key: _userId);
    await _secureStorage.delete(key: _userEmail);
    await _secureStorage.delete(key: _biometricKey);
    _logger.i('Secure storage cleared');
  }

  /// Clear all app data
  static Future<void> clearAllData() async {
    await _prefs.clear();
    await clearSecureStorage();
    _logger.i('All app data cleared');
  }

  /// Check network connectivity
  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  /// Get network connectivity stream
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  // Legacy compatibility properties (for existing code)
  static bool get enableHealthKit => true;
  static bool get enableGoogleFit => true;
  static bool get enableOcrScanning => true;
  static bool get enableAiInsights => true;

  // Validation method (for compatibility)
  static bool validateConfig() {
    // Simple validation - can be expanded
    return true;
  }

  // Print config method (for compatibility)
  static void printConfig() {
    try {
      _logger.i('AppConfig loaded successfully');
      _logger.d('API Base URL: $apiBaseUrl');
      _logger.d('Debug Mode: $debugMode');
    } catch (e) {
      // Fallback to print if logger is not initialized
      if (kDebugMode) {
        print('AppConfig loaded successfully');
        print('API Base URL: $apiBaseUrl');
        print('Debug Mode: $debugMode');
        print('Note: Logger not initialized, using fallback print: $e');
      }
    }
  }
}
