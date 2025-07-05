import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../features/health/health.dart';
import '../common/common.dart';
import '../config/app_config.dart';

/// Simple sync result class
class SyncResult {
  final bool isSuccess;
  final String? message;
  final int? recordCount;

  const SyncResult({
    required this.isSuccess,
    this.message,
    this.recordCount,
  });

  static SyncResult success(int recordCount) => SyncResult(
        isSuccess: true,
        recordCount: recordCount,
        message: 'Sync completed successfully',
      );

  static SyncResult failure(String message) => SyncResult(
        isSuccess: false,
        message: message,
      );
}

/// Central manager for health data operations
class HealthDataManager {
  static final HealthDataManager _instance = HealthDataManager._internal();
  factory HealthDataManager() => _instance;
  HealthDataManager._internal();

  HealthService? _healthService;
  bool _isInitialized = false;
  Timer? _syncTimer;

  static const String _lastSyncKey = 'health_last_sync';
  static const String _autoSyncEnabledKey = 'health_auto_sync_enabled';

  /// Initialize the health data manager
  Future<void> initialize({String? authToken}) async {
    if (_isInitialized) return;

    try {
      // Check if HealthKit is enabled in configuration
      if (!AppConfig.enableHealthKit) {
        debugPrint(
          'HealthDataManager: HealthKit is disabled in configuration. Set ENABLE_HEALTHKIT=true in .env file to enable health features.',
        );
        // We still mark as initialized but health service won't be available
        _isInitialized = true;
        return;
      }

      // Initialize HealthService with required dependencies
      _healthService = HealthService(
        apiClient: ApiClient.instance,
        logger: AppLogger('HealthDataManager'),
        secureStorage: SecureStorageService(),
      );

      await _healthService!.initialize();
      _isInitialized = true;
      debugPrint('HealthDataManager: Successfully initialized');

      // Start automatic sync if enabled
      final autoSyncEnabled = await isAutoSyncEnabled();
      if (autoSyncEnabled) {
        startAutoSync();
      }
    } catch (e) {
      debugPrint('HealthDataManager: Failed to initialize - $e');
      throw Exception('Failed to initialize health data manager: $e');
    }
  }

  /// Check if the manager is initialized and available
  bool get isAvailable => _isInitialized && _healthService?.isAvailable == true;

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    if (!_isInitialized || _healthService == null) {
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

    final result = await _healthService!.requestPermissions(requiredTypes);
    return result.fold(
      (permissions) => permissions.hasAllPermissions(requiredTypes),
      (error) => false,
    );
  }

  /// Check if permissions are granted
  Future<bool> hasPermissions() async {
    if (!_isInitialized || _healthService == null) return false;

    const requiredTypes = [
      CareCircleHealthDataType.steps,
      CareCircleHealthDataType.heartRate,
      CareCircleHealthDataType.weight,
      CareCircleHealthDataType.sleepAsleep,
    ];

    final result = await _healthService!.checkPermissions(requiredTypes);
    return result.fold(
      (permissions) => permissions.hasAllPermissions(requiredTypes),
      (error) => false,
    );
  }

  /// Perform manual sync of health data
  Future<SyncResult> syncHealthData() async {
    if (!_isInitialized || _healthService == null) {
      return SyncResult.failure('Manager not initialized');
    }

    try {
      final now = DateTime.now();
      final lastSync =
          await getLastSyncTime() ?? now.subtract(const Duration(days: 30));

      debugPrint('HealthDataManager: Starting sync from $lastSync to $now');

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
      final request = HealthDataRequest(
        types: typesToSync,
        startDate: lastSync,
        endDate: now,
      );

      final result = await _healthService!.getHealthData(request);
      return result.fold(
        (healthData) {
          debugPrint(
              'HealthDataManager: Retrieved ${healthData.length} health data points');
          setLastSyncTime(now);
          return SyncResult.success(healthData.length);
        },
        (error) {
          debugPrint('HealthDataManager: Sync error - $error');
          return SyncResult.failure('Sync failed: ${error.toString()}');
        },
      );
    } catch (e) {
      debugPrint('HealthDataManager: Sync error - $e');
      return SyncResult.failure('Sync failed: $e');
    }
  }

  /// Get health data for a specific date range
  Future<List<CareCircleHealthData>?> getLocalHealthData({
    required List<CareCircleHealthDataType> types,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized || _healthService == null) return null;

    final request = HealthDataRequest(
      types: types,
      startDate: startDate,
      endDate: endDate,
    );

    final result = await _healthService!.getHealthData(request);
    return result.fold(
      (data) => data,
      (error) => null,
    );
  }

  /// Get health metrics for display
  Future<Map<String, dynamic>?> getHealthMetrics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized || _healthService == null) return null;

    const types = [
      CareCircleHealthDataType.steps,
      CareCircleHealthDataType.heartRate,
      CareCircleHealthDataType.weight,
      CareCircleHealthDataType.sleepAsleep,
    ];

    final data = await getLocalHealthData(
      types: types,
      startDate: startDate,
      endDate: endDate,
    );

    if (data == null) return null;

    // Calculate basic metrics
    final metrics = <String, dynamic>{};

    // Steps
    final stepsData =
        data.where((d) => d.type == CareCircleHealthDataType.steps).toList();
    if (stepsData.isNotEmpty) {
      metrics['totalSteps'] =
          stepsData.fold<double>(0, (sum, d) => sum + d.value);
      metrics['averageSteps'] = metrics['totalSteps'] / stepsData.length;
    }

    // Heart rate
    final hrData = data
        .where((d) => d.type == CareCircleHealthDataType.heartRate)
        .toList();
    if (hrData.isNotEmpty) {
      metrics['averageHeartRate'] =
          hrData.fold<double>(0, (sum, d) => sum + d.value) / hrData.length;
    }

    return metrics;
  }

  /// Write health data to device
  Future<bool> writeHealthData({
    required CareCircleHealthDataType type,
    required double value,
    required String unit,
    DateTime? timestamp,
  }) async {
    if (!_isInitialized || _healthService == null) return false;

    final data = CareCircleHealthData(
      type: type,
      value: value,
      unit: unit,
      timestamp: timestamp ?? DateTime.now(),
    );

    final result = await _healthService!.writeHealthData(data);
    return result.fold(
      (success) => success,
      (error) => false,
    );
  }

  /// Write blood pressure data
  Future<bool> writeBloodPressure({
    required double systolic,
    required double diastolic,
    DateTime? timestamp,
  }) async {
    if (!_isInitialized || _healthService == null) return false;

    final result = await _healthService!.writeBloodPressure(
      systolic: systolic,
      diastolic: diastolic,
      timestamp: timestamp ?? DateTime.now(),
    );

    return result.fold(
      (success) => success,
      (error) => false,
    );
  }

  /// Get total steps for today
  Future<int?> getTotalSteps() async {
    if (!_isInitialized || _healthService == null) return null;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final data = await getLocalHealthData(
      types: [CareCircleHealthDataType.steps],
      startDate: startOfDay,
      endDate: today,
    );

    if (data == null || data.isEmpty) return null;

    return data.fold<double>(0, (sum, d) => sum + d.value).toInt();
  }

  /// Start automatic background sync
  void startAutoSync({Duration interval = const Duration(hours: 6)}) {
    stopAutoSync(); // Stop any existing timer

    _syncTimer = Timer.periodic(interval, (timer) async {
      try {
        final result = await syncHealthData();
        debugPrint(
          'HealthDataManager: Auto sync ${result.isSuccess ? 'completed' : 'failed'}: ${result.message}',
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

  /// Dispose resources
  void dispose() {
    stopAutoSync();
    _isInitialized = false;
  }
}
