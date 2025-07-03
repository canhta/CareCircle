import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/health_service.dart';
import '../repositories/health_data_repository.dart';
import '../services/background_sync_service.dart';

/// Central manager for health data operations
class HealthDataManager {
  static final HealthDataManager _instance = HealthDataManager._internal();
  factory HealthDataManager() => _instance;
  HealthDataManager._internal();

  final HealthService _healthService = HealthService();
  final HealthDataRepository _repository = HealthDataRepository();
  final BackgroundSyncService _backgroundSyncService = BackgroundSyncService();

  Timer? _syncTimer;
  bool _isInitialized = false;

  static const String _lastSyncKey = 'health_last_sync';
  static const String _autoSyncEnabledKey = 'health_auto_sync_enabled';
  static const String _backgroundSyncEnabledKey =
      'health_background_sync_enabled';

  /// Initialize the health data manager
  Future<void> initialize({String? authToken}) async {
    if (_isInitialized) return;

    try {
      await _healthService.initialize();

      if (authToken != null) {
        _repository.setAuthToken(authToken);
      }

      _isInitialized = true;
      debugPrint('HealthDataManager: Successfully initialized');

      // Initialize background sync service
      await _backgroundSyncService.initialize();

      // Start automatic sync if enabled
      final autoSyncEnabled = await isAutoSyncEnabled();
      if (autoSyncEnabled) {
        startAutoSync();
      }

      // Start background sync if enabled
      final backgroundSyncEnabled = await isBackgroundSyncEnabled();
      if (backgroundSyncEnabled) {
        await setBackgroundSyncEnabled(true);
      }
    } catch (e) {
      debugPrint('HealthDataManager: Failed to initialize - $e');
      throw Exception('Failed to initialize health data manager: $e');
    }
  }

  /// Check if the manager is initialized and available
  bool get isAvailable => _isInitialized && _healthService.isAvailable;

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      throw Exception('HealthDataManager not initialized');
    }

    const requiredTypes = [
      CareCircleHealthDataType.steps,
      CareCircleHealthDataType.heartRate,
      CareCircleHealthDataType.weight,
      CareCircleHealthDataType.height,
      CareCircleHealthDataType.sleepAsleep,
      CareCircleHealthDataType.activeEnergyBurned,
      CareCircleHealthDataType.distanceWalkingRunning,
      CareCircleHealthDataType.bloodPressure,
      CareCircleHealthDataType.bodyTemperature,
      CareCircleHealthDataType.oxygenSaturation,
      CareCircleHealthDataType.bloodGlucose,
    ];

    final permissionsGranted = await _healthService.requestPermissions(
      requiredTypes,
    );

    if (permissionsGranted) {
      // Update consent records
      await _repository.updateHealthConsent(
        consentType: 'DATA_COLLECTION',
        dataCategories: requiredTypes.map((type) => type.name).toList(),
        purpose: 'Health monitoring and family care coordination',
        consentGranted: true,
        consentVersion: '1.0',
      );
    }

    return permissionsGranted;
  }

  /// Check if permissions are granted
  Future<bool> hasPermissions() async {
    if (!_isInitialized) return false;

    const requiredTypes = [
      CareCircleHealthDataType.steps,
      CareCircleHealthDataType.heartRate,
      CareCircleHealthDataType.weight,
      CareCircleHealthDataType.sleepAsleep,
    ];

    return await _healthService.hasPermissions(requiredTypes);
  }

  /// Perform manual sync of health data
  Future<SyncResult> syncHealthData() async {
    if (!_isInitialized) {
      return SyncResult.failure('Manager not initialized');
    }

    try {
      final now = DateTime.now();
      final lastSync =
          await getLastSyncTime() ?? now.subtract(const Duration(days: 30));

      debugPrint('HealthDataManager: Starting sync from $lastSync to $now');

      // Update sync status to in progress
      await _repository.updateSyncStatus(
        source: 'MOBILE_APP',
        status: 'IN_PROGRESS',
        recordsCount: 0,
      );

      // Define the health data types to sync
      const typesToSync = [
        CareCircleHealthDataType.steps,
        CareCircleHealthDataType.heartRate,
        CareCircleHealthDataType.weight,
        CareCircleHealthDataType.sleepAsleep,
        CareCircleHealthDataType.activeEnergyBurned,
        CareCircleHealthDataType.distanceWalkingRunning,
        CareCircleHealthDataType.bloodPressure,
      ];

      // Get health data from device
      final healthData = await _healthService.getHealthData(
        types: typesToSync,
        startDate: lastSync,
        endDate: now,
      );

      debugPrint(
        'HealthDataManager: Retrieved ${healthData.length} health data points',
      );

      // Sync to backend
      final syncTime = DateTime.now();
      final startDate = lastSync;

      await _repository.syncHealthData(
        healthData,
        'MOBILE_APP',
        startDate,
        syncTime,
      );

      await setLastSyncTime(syncTime);

      return SyncResult.success(healthData.length);
    } catch (e) {
      debugPrint('HealthDataManager: Sync error - $e');

      // Update sync status to failed
      await _repository.updateSyncStatus(
        source: 'MOBILE_APP',
        status: 'FAILED',
        recordsCount: 0,
        errorMessage: e.toString(),
      );

      return SyncResult.failure(e.toString());
    }
  }

  /// Get health data from local device
  Future<List<CareCircleHealthData>> getLocalHealthData({
    required List<CareCircleHealthDataType> types,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      throw Exception('Manager not initialized');
    }

    return await _healthService.getHealthData(
      types: types,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get health metrics from backend
  Future<List<Map<String, dynamic>>?> getHealthMetrics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _repository.getHealthMetrics(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Start automatic background sync
  void startAutoSync({Duration interval = const Duration(hours: 6)}) {
    stopAutoSync(); // Stop any existing timer

    _syncTimer = Timer.periodic(interval, (timer) async {
      try {
        final result = await syncHealthData();
        debugPrint(
          'HealthDataManager: Auto sync ${result.success ? 'completed' : 'failed'}: ${result.message}',
        );
      } catch (e) {
        debugPrint('HealthDataManager: Auto sync error - $e');
      }
    });

    debugPrint(
      'HealthDataManager: Auto sync started with ${interval.inHours}h interval',
    );
  }

  /// Stop automatic background sync
  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('HealthDataManager: Auto sync stopped');
  }

  /// Check if auto sync is enabled
  Future<bool> isAutoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSyncEnabledKey) ?? true; // Default to enabled
  }

  /// Set auto sync preference
  Future<void> setAutoSyncEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSyncEnabledKey, enabled);

    if (enabled) {
      startAutoSync();
    } else {
      stopAutoSync();
    }
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Set last sync time
  Future<void> setLastSyncTime(DateTime timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
  }

  /// Get sync history from backend
  Future<List<Map<String, dynamic>>?> getSyncHistory() async {
    return await _repository.getSyncHistory();
  }

  /// Write health data to device
  Future<bool> writeHealthData({
    required CareCircleHealthDataType type,
    required double value,
    required String unit,
    DateTime? timestamp,
  }) async {
    if (!_isInitialized) {
      throw Exception('Manager not initialized');
    }

    return await _healthService.writeHealthData(
      type: type,
      value: value,
      unit: unit,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Write blood pressure data
  Future<bool> writeBloodPressure({
    required double systolic,
    required double diastolic,
    DateTime? timestamp,
  }) async {
    if (!_isInitialized) {
      throw Exception('Manager not initialized');
    }

    return await _healthService.writeBloodPressure(
      systolic: systolic,
      diastolic: diastolic,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Get total steps for a date range
  Future<int?> getTotalSteps({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) return null;

    return await _healthService.getTotalSteps(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Update family sharing consent
  Future<bool> updateFamilySharingConsent({
    required bool shareWithFamily,
    String? careGroupId,
  }) async {
    return await _repository.updateHealthConsent(
      consentType: 'FAMILY_SHARING',
      dataCategories: ['health_metrics', 'activity_data'],
      purpose: 'Family care coordination and monitoring',
      consentGranted: shareWithFamily,
      consentVersion: '1.0',
      careGroupId: careGroupId,
      shareWithFamily: shareWithFamily,
    );
  }

  /// Dispose resources
  void dispose() {
    stopAutoSync();
    _isInitialized = false;
  }

  /// Check if network is available
  Future<bool> _isNetworkAvailable() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      debugPrint('HealthDataManager: Network check failed - $e');
      return false;
    }
  }

  /// Perform network-aware sync with better error handling
  Future<SyncResult> syncHealthDataWithNetworkCheck() async {
    if (!_isInitialized) {
      return SyncResult.failure('Manager not initialized');
    }

    // Check network availability first
    if (!await _isNetworkAvailable()) {
      debugPrint(
        'HealthDataManager: No network available, queueing sync for later',
      );
      return SyncResult.failure('No network connection available');
    }

    return await syncHealthData();
  }

  /// Enable/disable background sync
  Future<void> setBackgroundSyncEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundSyncEnabledKey, enabled);

    if (enabled) {
      await _backgroundSyncService.initialize();
      await _backgroundSyncService.registerPeriodicSync(
        frequency: const Duration(hours: 6),
        requiresNetworkConnectivity: true,
      );
      debugPrint('HealthDataManager: Background sync enabled');
    } else {
      await _backgroundSyncService.cancelAllSyncTasks();
      debugPrint('HealthDataManager: Background sync disabled');
    }
  }

  /// Check if background sync is enabled
  Future<bool> isBackgroundSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_backgroundSyncEnabledKey) ??
        true; // Default to enabled
  }

  /// Get last background sync time
  Future<DateTime?> getLastBackgroundSyncTime() async {
    return await BackgroundSyncService.getLastBackgroundSyncTime();
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final int? recordsCount;

  SyncResult.success(this.recordsCount)
    : success = true,
      message = 'Sync completed successfully. $recordsCount records synced.';

  SyncResult.failure(this.message) : success = false, recordsCount = null;

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, recordsCount: $recordsCount)';
  }
}
