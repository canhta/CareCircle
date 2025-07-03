import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../managers/health_data_manager.dart';

/// Background sync service for health data using WorkManager
class BackgroundSyncService {
  static const String _syncTaskName = 'health_data_sync';
  static const String _retryTaskName = 'health_data_retry_sync';
  static const String _lastBackgroundSyncKey = 'last_background_sync';
  static const String _syncFailureCountKey = 'sync_failure_count';
  static const String _offlineQueueKey = 'offline_sync_queue';

  static final BackgroundSyncService _instance =
      BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();

  bool _isInitialized = false;

  /// Initialize the background sync service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      _isInitialized = true;
      debugPrint('BackgroundSyncService: Successfully initialized');
    } catch (e) {
      debugPrint('BackgroundSyncService: Failed to initialize - $e');
      throw Exception('Failed to initialize background sync service: $e');
    }
  }

  /// Register periodic health data sync
  Future<void> registerPeriodicSync({
    Duration frequency = const Duration(hours: 6),
    bool requiresNetworkConnectivity = true,
    bool requiresDeviceIdle = false,
  }) async {
    if (!_isInitialized) {
      throw Exception('BackgroundSyncService not initialized');
    }

    await Workmanager().registerPeriodicTask(
      _syncTaskName,
      _syncTaskName,
      frequency: frequency,
    );

    debugPrint(
      'BackgroundSyncService: Registered periodic sync with ${frequency.inHours}h frequency',
    );
  }

  /// Register retry sync for failed operations
  Future<void> registerRetrySync({
    Duration delay = const Duration(minutes: 15),
  }) async {
    if (!_isInitialized) {
      throw Exception('BackgroundSyncService not initialized');
    }

    await Workmanager().registerOneOffTask(
      _retryTaskName,
      _retryTaskName,
      initialDelay: delay,
    );

    debugPrint(
      'BackgroundSyncService: Registered retry sync with ${delay.inMinutes}min delay',
    );
  }

  /// Cancel all sync tasks
  Future<void> cancelAllSyncTasks() async {
    if (!_isInitialized) return;

    await Workmanager().cancelByUniqueName(_syncTaskName);
    await Workmanager().cancelByUniqueName(_retryTaskName);

    debugPrint('BackgroundSyncService: Cancelled all sync tasks');
  }

  /// Check if network is available
  static Future<bool> _isNetworkAvailable() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      debugPrint('BackgroundSyncService: Network check failed - $e');
      return false;
    }
  }

  /// Get last background sync time
  static Future<DateTime?> getLastBackgroundSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastBackgroundSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Set last background sync time
  static Future<void> _setLastBackgroundSyncTime(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastBackgroundSyncKey,
      timestamp.millisecondsSinceEpoch,
    );
  }

  /// Get sync failure count
  static Future<int> _getSyncFailureCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_syncFailureCountKey) ?? 0;
  }

  /// Set sync failure count
  static Future<void> _setSyncFailureCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_syncFailureCountKey, count);
  }

  /// Add failed sync to offline queue
  static Future<void> _addToOfflineQueue(Map<String, dynamic> syncData) async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_offlineQueueKey) ?? [];

    queueJson.add(syncData.toString());
    await prefs.setStringList(_offlineQueueKey, queueJson);

    debugPrint('BackgroundSyncService: Added sync to offline queue');
  }

  /// Process offline queue
  static Future<void> _processOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getStringList(_offlineQueueKey) ?? [];

    if (queueJson.isEmpty) return;

    debugPrint(
      'BackgroundSyncService: Processing ${queueJson.length} items from offline queue',
    );

    // Process each queued sync
    final remainingQueue = <String>[];

    for (final item in queueJson) {
      try {
        // Parse and retry sync
        // This would need proper JSON parsing in a real implementation
        await _performSyncWithRetry();
      } catch (e) {
        // Keep item in queue if still failing
        remainingQueue.add(item);
        debugPrint('BackgroundSyncService: Queue item still failing - $e');
      }
    }

    // Update queue with remaining items
    await prefs.setStringList(_offlineQueueKey, remainingQueue);

    if (remainingQueue.isEmpty) {
      debugPrint('BackgroundSyncService: Offline queue processed successfully');
    } else {
      debugPrint(
        'BackgroundSyncService: ${remainingQueue.length} items remain in offline queue',
      );
    }
  }

  /// Perform sync with exponential backoff retry
  static Future<void> _performSyncWithRetry({int maxRetries = 3}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        // Initialize health data manager for background task
        final healthManager = HealthDataManager();

        // Attempt sync
        final result = await healthManager.syncHealthData();

        if (result.success) {
          await _setLastBackgroundSyncTime(DateTime.now());
          await _setSyncFailureCount(0);
          debugPrint('BackgroundSyncService: Sync completed successfully');
          return;
        } else {
          throw Exception(result.message);
        }
      } catch (e) {
        retryCount++;
        final failureCount = await _getSyncFailureCount();
        await _setSyncFailureCount(failureCount + 1);

        debugPrint(
          'BackgroundSyncService: Sync attempt $retryCount failed - $e',
        );

        if (retryCount < maxRetries) {
          // Exponential backoff: 2^retryCount minutes
          final delayMinutes = pow(2, retryCount).toInt();
          debugPrint(
            'BackgroundSyncService: Retrying in $delayMinutes minutes',
          );

          await Future.delayed(Duration(minutes: delayMinutes));
        } else {
          // Add to offline queue after all retries failed
          await _addToOfflineQueue({
            'timestamp': DateTime.now().toIso8601String(),
            'error': e.toString(),
            'retryCount': retryCount,
          });

          debugPrint(
            'BackgroundSyncService: Max retries reached, added to offline queue',
          );
          rethrow;
        }
      }
    }
  }
}

/// Background task callback dispatcher
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('BackgroundSyncService: Executing task: $task');

      // Check network availability
      if (!await BackgroundSyncService._isNetworkAvailable()) {
        debugPrint(
          'BackgroundSyncService: No network available, skipping sync',
        );
        return Future.value(false);
      }

      switch (task) {
        case BackgroundSyncService._syncTaskName:
          await BackgroundSyncService._performSyncWithRetry();
          await BackgroundSyncService._processOfflineQueue();
          break;

        case BackgroundSyncService._retryTaskName:
          await BackgroundSyncService._processOfflineQueue();
          break;

        default:
          debugPrint('BackgroundSyncService: Unknown task: $task');
          return Future.value(false);
      }

      debugPrint('BackgroundSyncService: Task $task completed successfully');
      return Future.value(true);
    } catch (e) {
      debugPrint('BackgroundSyncService: Task $task failed - $e');
      return Future.value(false);
    }
  });
}
