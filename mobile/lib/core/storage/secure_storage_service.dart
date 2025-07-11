import 'dart:convert';
import 'secure_storage.dart' as core_storage;

/// Secure storage service interface for notification system
///
/// Provides a simplified interface that matches the notification system's expectations
/// while delegating to the existing SecureStorageService implementation.
class SecureStorageService {
  /// Store a string value securely
  Future<void> store(String key, String value) async {
    await core_storage.SecureStorageService.setString(key, value);
  }

  /// Retrieve a string value securely
  Future<String?> retrieve(String key) async {
    return await core_storage.SecureStorageService.getString(key);
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await core_storage.SecureStorageService.remove(key);
  }

  /// Encrypt data for storage
  Future<String> encryptData(dynamic data) async {
    // For now, just JSON encode the data
    // In a production app, you would add proper encryption here
    return jsonEncode(data);
  }

  /// Decrypt data from storage
  Future<dynamic> decryptData(String encryptedData) async {
    // For now, just JSON decode the data
    // In a production app, you would add proper decryption here
    return jsonDecode(encryptedData);
  }

  /// Store JSON data securely
  Future<void> storeJson(String key, Map<String, dynamic> data) async {
    await core_storage.SecureStorageService.setJson(key, data);
  }

  /// Retrieve JSON data securely
  Future<Map<String, dynamic>?> retrieveJson(String key) async {
    return await core_storage.SecureStorageService.getJson(key);
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await core_storage.SecureStorageService.containsKey(key);
  }

  /// Clear all data (use with caution)
  Future<void> clearAll() async {
    await core_storage.SecureStorageService.clearAll();
  }
}
