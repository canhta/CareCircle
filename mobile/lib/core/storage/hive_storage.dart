import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../logging/bounded_context_loggers.dart';

/// Hive storage service for offline data caching
/// Provides fast local storage for non-sensitive healthcare data
class HiveStorageService {
  static final _logger = BoundedContextLoggers.core;
  static bool _initialized = false;

  /// Initialize Hive storage
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await Hive.initFlutter();
      _initialized = true;
      _logger.info('Hive storage initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize Hive storage', e);
      rethrow;
    }
  }

  /// Open a Hive box
  static Future<Box<T>> openBox<T>(String boxName) async {
    try {
      if (!_initialized) {
        await initialize();
      }
      
      final box = await Hive.openBox<T>(boxName);
      _logger.info('Opened Hive box: $boxName');
      return box;
    } catch (e) {
      _logger.error('Failed to open Hive box: $boxName', e);
      rethrow;
    }
  }

  /// Close a Hive box
  static Future<void> closeBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
        _logger.info('Closed Hive box: $boxName');
      }
    } catch (e) {
      _logger.error('Failed to close Hive box: $boxName', e);
    }
  }

  /// Store a value in a Hive box
  static Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = await openBox<T>(boxName);
      await box.put(key, value);
      _logger.info('Stored value in Hive box: $boxName, key: $key');
    } catch (e) {
      _logger.error('Failed to store value in Hive box: $boxName, key: $key', e);
      rethrow;
    }
  }

  /// Retrieve a value from a Hive box
  static Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await openBox<T>(boxName);
      final value = box.get(key);
      if (value != null) {
        _logger.info('Retrieved value from Hive box: $boxName, key: $key');
      }
      return value;
    } catch (e) {
      _logger.error('Failed to retrieve value from Hive box: $boxName, key: $key', e);
      return null;
    }
  }

  /// Store a JSON object in a Hive box
  static Future<void> putJson(String boxName, String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      await put<String>(boxName, key, jsonString);
    } catch (e) {
      _logger.error('Failed to store JSON in Hive box: $boxName, key: $key', e);
      rethrow;
    }
  }

  /// Retrieve a JSON object from a Hive box
  static Future<Map<String, dynamic>?> getJson(String boxName, String key) async {
    try {
      final jsonString = await get<String>(boxName, key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Failed to retrieve JSON from Hive box: $boxName, key: $key', e);
      return null;
    }
  }

  /// Remove a value from a Hive box
  static Future<void> delete(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      await box.delete(key);
      _logger.info('Deleted value from Hive box: $boxName, key: $key');
    } catch (e) {
      _logger.error('Failed to delete value from Hive box: $boxName, key: $key', e);
      rethrow;
    }
  }

  /// Clear all values from a Hive box
  static Future<void> clearBox(String boxName) async {
    try {
      final box = await openBox(boxName);
      await box.clear();
      _logger.warning('Cleared all values from Hive box: $boxName');
    } catch (e) {
      _logger.error('Failed to clear Hive box: $boxName', e);
      rethrow;
    }
  }

  /// Check if a key exists in a Hive box
  static Future<bool> containsKey(String boxName, String key) async {
    try {
      final box = await openBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      _logger.error('Failed to check key existence in Hive box: $boxName, key: $key', e);
      return false;
    }
  }

  /// Get all keys from a Hive box
  static Future<Iterable<dynamic>> getAllKeys(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.keys;
    } catch (e) {
      _logger.error('Failed to get all keys from Hive box: $boxName', e);
      return [];
    }
  }

  /// Get all values from a Hive box
  static Future<Iterable<dynamic>> getAllValues(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.values;
    } catch (e) {
      _logger.error('Failed to get all values from Hive box: $boxName', e);
      return [];
    }
  }

  /// Get box size
  static Future<int> getBoxSize(String boxName) async {
    try {
      final box = await openBox(boxName);
      return box.length;
    } catch (e) {
      _logger.error('Failed to get Hive box size: $boxName', e);
      return 0;
    }
  }

  /// Close all open boxes
  static Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
      _logger.info('Closed all Hive boxes');
    } catch (e) {
      _logger.error('Failed to close all Hive boxes', e);
    }
  }
}

/// Healthcare-specific Hive box names
class HiveBoxNames {
  // Health Data Cache
  static const String healthMetrics = 'health_metrics';
  static const String healthGoals = 'health_goals';
  static const String deviceData = 'device_data';
  
  // AI Assistant Cache
  static const String conversations = 'conversations';
  static const String aiResponses = 'ai_responses';
  
  // App Cache
  static const String userPreferences = 'user_preferences';
  static const String appSettings = 'app_settings';
  static const String syncQueue = 'sync_queue';
  
  // Offline Data
  static const String offlineActions = 'offline_actions';
  static const String pendingUploads = 'pending_uploads';
  
  // Medication Cache
  static const String medications = 'medications';
  static const String medicationSchedule = 'medication_schedule';
  
  // Care Group Cache
  static const String careGroups = 'care_groups';
  static const String familyMembers = 'family_members';
}
