import 'secure_storage.dart';
import 'hive_storage.dart';
import '../logging/bounded_context_loggers.dart';

/// Unified storage service for CareCircle
/// Provides a single interface for both secure and cache storage
class StorageService {
  static final _logger = BoundedContextLoggers.core;
  static bool _initialized = false;

  /// Initialize the storage service
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Hive storage
      await HiveStorageService.initialize();

      _initialized = true;
      _logger.info('Storage service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize storage service', e);
      rethrow;
    }
  }

  /// Secure Storage Methods (for sensitive data)

  /// Store sensitive data securely
  static Future<void> setSecure(String key, String value) async {
    await SecureStorageService.setString(key, value);
  }

  /// Retrieve sensitive data securely
  static Future<String?> getSecure(String key) async {
    return await SecureStorageService.getString(key);
  }

  /// Store sensitive JSON data securely
  static Future<void> setSecureJson(
    String key,
    Map<String, dynamic> value,
  ) async {
    await SecureStorageService.setJson(key, value);
  }

  /// Retrieve sensitive JSON data securely
  static Future<Map<String, dynamic>?> getSecureJson(String key) async {
    return await SecureStorageService.getJson(key);
  }

  /// Remove sensitive data
  static Future<void> removeSecure(String key) async {
    await SecureStorageService.remove(key);
  }

  /// Cache Storage Methods (for non-sensitive data)

  /// Store data in cache
  static Future<void> setCache<T>(String boxName, String key, T value) async {
    await HiveStorageService.put<T>(boxName, key, value);
  }

  /// Retrieve data from cache
  static Future<T?> getCache<T>(String boxName, String key) async {
    return await HiveStorageService.get<T>(boxName, key);
  }

  /// Store JSON data in cache
  static Future<void> setCacheJson(
    String boxName,
    String key,
    Map<String, dynamic> value,
  ) async {
    await HiveStorageService.putJson(boxName, key, value);
  }

  /// Retrieve JSON data from cache
  static Future<Map<String, dynamic>?> getCacheJson(
    String boxName,
    String key,
  ) async {
    return await HiveStorageService.getJson(boxName, key);
  }

  /// Remove data from cache
  static Future<void> removeCache(String boxName, String key) async {
    await HiveStorageService.delete(boxName, key);
  }

  /// Clear entire cache box
  static Future<void> clearCacheBox(String boxName) async {
    await HiveStorageService.clearBox(boxName);
  }

  /// Healthcare-specific convenience methods

  /// Store user authentication token
  static Future<void> setAuthToken(String token) async {
    await setSecure(SecureStorageKeys.firebaseToken, token);
  }

  /// Get user authentication token
  static Future<String?> getAuthToken() async {
    return await getSecure(SecureStorageKeys.firebaseToken);
  }

  /// Store user profile securely
  static Future<void> setUserProfile(Map<String, dynamic> profile) async {
    await setSecureJson(SecureStorageKeys.userProfile, profile);
  }

  /// Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    return await getSecureJson(SecureStorageKeys.userProfile);
  }

  /// Store health profile securely
  static Future<void> setHealthProfile(Map<String, dynamic> profile) async {
    await setSecureJson(SecureStorageKeys.healthProfile, profile);
  }

  /// Get health profile
  static Future<Map<String, dynamic>?> getHealthProfile() async {
    return await getSecureJson(SecureStorageKeys.healthProfile);
  }

  /// Cache health metrics for offline access
  static Future<void> cacheHealthMetrics(
    List<Map<String, dynamic>> metrics,
  ) async {
    await setCacheJson(HiveBoxNames.healthMetrics, 'latest_metrics', {
      'metrics': metrics,
      'cached_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get cached health metrics
  static Future<List<Map<String, dynamic>>?> getCachedHealthMetrics() async {
    final data = await getCacheJson(
      HiveBoxNames.healthMetrics,
      'latest_metrics',
    );
    if (data == null) return null;

    final metrics = data['metrics'] as List?;
    return metrics?.cast<Map<String, dynamic>>();
  }

  /// Store last sync time
  static Future<void> setLastSyncTime(DateTime time) async {
    await setSecure(SecureStorageKeys.lastSyncTime, time.toIso8601String());
  }

  /// Get last sync time
  static Future<DateTime?> getLastSyncTime() async {
    final timeString = await getSecure(SecureStorageKeys.lastSyncTime);
    if (timeString == null) return null;
    return DateTime.tryParse(timeString);
  }

  /// Store app settings
  static Future<void> setAppSettings(Map<String, dynamic> settings) async {
    await setCacheJson(HiveBoxNames.appSettings, 'user_settings', settings);
  }

  /// Get app settings
  static Future<Map<String, dynamic>?> getAppSettings() async {
    return await getCacheJson(HiveBoxNames.appSettings, 'user_settings');
  }

  /// Emergency data cleanup (GDPR compliance)
  static Future<void> clearAllUserData() async {
    try {
      // Clear secure storage
      await SecureStorageService.clearAll();

      // Clear all cache boxes
      await HiveStorageService.clearBox(HiveBoxNames.healthMetrics);
      await HiveStorageService.clearBox(HiveBoxNames.conversations);
      await HiveStorageService.clearBox(HiveBoxNames.userPreferences);
      await HiveStorageService.clearBox(HiveBoxNames.medications);
      await HiveStorageService.clearBox(HiveBoxNames.careGroups);

      _logger.warning('All user data cleared from storage');
    } catch (e) {
      _logger.error('Failed to clear all user data', e);
      rethrow;
    }
  }

  /// Check storage health
  static Future<Map<String, dynamic>> getStorageHealth() async {
    try {
      final secureKeys = await SecureStorageService.getAllKeys();
      final healthMetricsSize = await HiveStorageService.getBoxSize(
        HiveBoxNames.healthMetrics,
      );
      final conversationsSize = await HiveStorageService.getBoxSize(
        HiveBoxNames.conversations,
      );

      return {
        'secure_storage_keys': secureKeys.length,
        'health_metrics_cache_size': healthMetricsSize,
        'conversations_cache_size': conversationsSize,
        'initialized': _initialized,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.error('Failed to get storage health', e);
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}
