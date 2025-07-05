import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Secure storage service for sensitive data
class SecureStorageService {
  static SecureStorageService? _instance;
  late final FlutterSecureStorage _secureStorage;

  SecureStorageService._internal();

  /// Factory constructor for singleton pattern
  factory SecureStorageService() {
    _instance ??= SecureStorageService._internal();
    return _instance!;
  }

  /// Initialize secure storage
  void initialize({
    AndroidOptions? androidOptions,
    IOSOptions? iosOptions,
  }) {
    _secureStorage = FlutterSecureStorage(
      aOptions: androidOptions ??
          const AndroidOptions(
            encryptedSharedPreferences: true,
          ),
      iOptions: iosOptions ??
          const IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
    );
  }

  /// Storage keys constants
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _biometricKey = 'biometric_enabled';
  static const String _deviceIdKey = 'device_id';
  static const String _userPreferencesKey = 'user_preferences';

  /// Write a string value to secure storage
  Future<void> writeString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error writing string for key $key: $e');
      }
      rethrow;
    }
  }

  /// Read a string value from secure storage
  Future<String?> readString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error reading string for key $key: $e');
      }
      return null;
    }
  }

  /// Write a JSON object to secure storage
  Future<void> writeJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error writing JSON for key $key: $e');
      }
      rethrow;
    }
  }

  /// Read a JSON object from secure storage
  Future<Map<String, dynamic>?> readJson(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error reading JSON for key $key: $e');
      }
      return null;
    }
  }

  /// Write a boolean value to secure storage
  Future<void> writeBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error writing bool for key $key: $e');
      }
      rethrow;
    }
  }

  /// Read a boolean value from secure storage
  Future<bool?> readBool(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      if (value != null) {
        return value.toLowerCase() == 'true';
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error reading bool for key $key: $e');
      }
      return null;
    }
  }

  /// Write an integer value to secure storage
  Future<void> writeInt(String key, int value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error writing int for key $key: $e');
      }
      rethrow;
    }
  }

  /// Read an integer value from secure storage
  Future<int?> readInt(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      if (value != null) {
        return int.tryParse(value);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error reading int for key $key: $e');
      }
      return null;
    }
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error deleting key $key: $e');
      }
      rethrow;
    }
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error checking key $key: $e');
      }
      return false;
    }
  }

  /// Get all keys from secure storage
  Future<Map<String, String>> readAll() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error reading all keys: $e');
      }
      return {};
    }
  }

  /// Clear all data from secure storage
  Future<void> deleteAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      if (kDebugMode) {
        print('SecureStorageService: Error clearing all data: $e');
      }
      rethrow;
    }
  }

  // Convenience methods for common operations

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await writeString(_accessTokenKey, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await readString(_accessTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await writeString(_refreshTokenKey, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await readString(_refreshTokenKey);
  }

  /// Save user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await writeJson(_userDataKey, userData);
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    return await readJson(_userDataKey);
  }

  /// Save biometric setting
  Future<void> saveBiometricEnabled(bool enabled) async {
    await writeBool(_biometricKey, enabled);
  }

  /// Get biometric setting
  Future<bool> getBiometricEnabled() async {
    return await readBool(_biometricKey) ?? false;
  }

  /// Save device ID
  Future<void> saveDeviceId(String deviceId) async {
    await writeString(_deviceIdKey, deviceId);
  }

  /// Get device ID
  Future<String?> getDeviceId() async {
    return await readString(_deviceIdKey);
  }

  /// Save user preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await writeJson(_userPreferencesKey, preferences);
  }

  /// Get user preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    return await readJson(_userPreferencesKey);
  }

  /// Clear authentication data
  Future<void> clearAuthData() async {
    await delete(_accessTokenKey);
    await delete(_refreshTokenKey);
    await delete(_userDataKey);
  }

  /// Clear all user data
  Future<void> clearUserData() async {
    await delete(_userDataKey);
    await delete(_userPreferencesKey);
  }
}
