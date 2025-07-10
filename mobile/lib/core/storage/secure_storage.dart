import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../logging/bounded_context_loggers.dart';

/// Secure storage service for healthcare data
/// Provides HIPAA-compliant storage for PHI/PII data
class SecureStorageService {
  static final _logger = BoundedContextLoggers.core;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );

  /// Store a string value securely
  static Future<void> setString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      _logger.info('Secure storage: Stored value for key: $key');
    } catch (e) {
      _logger.error('Failed to store secure value for key: $key', e);
      rethrow;
    }
  }

  /// Retrieve a string value securely
  static Future<String?> getString(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) {
        _logger.info('Secure storage: Retrieved value for key: $key');
      }
      return value;
    } catch (e) {
      _logger.error('Failed to retrieve secure value for key: $key', e);
      return null;
    }
  }

  /// Store a JSON object securely
  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      await setString(key, jsonString);
    } catch (e) {
      _logger.error('Failed to store JSON for key: $key', e);
      rethrow;
    }
  }

  /// Retrieve a JSON object securely
  static Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to retrieve JSON for key: $key', e);
      return null;
    }
  }

  /// Store a boolean value securely
  static Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }

  /// Retrieve a boolean value securely
  static Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  /// Store an integer value securely
  static Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }

  /// Retrieve an integer value securely
  static Future<int?> getInt(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Remove a value from secure storage
  static Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
      _logger.info('Secure storage: Removed value for key: $key');
    } catch (e) {
      _logger.error('Failed to remove secure value for key: $key', e);
      rethrow;
    }
  }

  /// Clear all secure storage (use with caution)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      _logger.warning('Secure storage: Cleared all stored values');
    } catch (e) {
      _logger.error('Failed to clear secure storage', e);
      rethrow;
    }
  }

  /// Check if a key exists in secure storage
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      _logger.error('Failed to check key existence: $key', e);
      return false;
    }
  }

  /// Get all keys from secure storage
  static Future<Set<String>> getAllKeys() async {
    try {
      final all = await _storage.readAll();
      return all.keys.toSet();
    } catch (e) {
      _logger.error('Failed to get all keys from secure storage', e);
      return <String>{};
    }
  }
}

/// Healthcare-specific secure storage keys
class SecureStorageKeys {
  // Authentication
  static const String firebaseToken = 'firebase_token';
  static const String refreshToken = 'refresh_token';
  static const String biometricEnabled = 'biometric_enabled';
  static const String lastLoginTime = 'last_login_time';

  // User Profile
  static const String userProfile = 'user_profile';
  static const String healthProfile = 'health_profile';

  // Health Data
  static const String lastSyncTime = 'last_sync_time';
  static const String offlineHealthData = 'offline_health_data';
  static const String devicePermissions = 'device_permissions';

  // AI Assistant
  static const String conversationHistory = 'conversation_history';
  static const String aiPreferences = 'ai_preferences';

  // App Settings
  static const String appSettings = 'app_settings';
  static const String notificationSettings = 'notification_settings';

  // Emergency
  static const String emergencyContacts = 'emergency_contacts';
  static const String medicalAlerts = 'medical_alerts';
}
