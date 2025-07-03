import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_config.dart';

/// Health data types that CareCircle tracks
enum CareCircleHealthDataType {
  steps,
  heartRate,
  bloodPressure,
  weight,
  height,
  sleepInBed,
  sleepAsleep,
  activeEnergyBurned,
  basalEnergyBurned,
  distanceWalkingRunning,
  bodyTemperature,
  oxygenSaturation,
  bloodGlucose,
}

/// Mapping from CareCircle types to Flutter Health types
const Map<CareCircleHealthDataType, HealthDataType> _healthDataTypeMap = {
  CareCircleHealthDataType.steps: HealthDataType.STEPS,
  CareCircleHealthDataType.heartRate: HealthDataType.HEART_RATE,
  CareCircleHealthDataType.bloodPressure:
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  CareCircleHealthDataType.weight: HealthDataType.WEIGHT,
  CareCircleHealthDataType.height: HealthDataType.HEIGHT,
  CareCircleHealthDataType.sleepInBed: HealthDataType.SLEEP_IN_BED,
  CareCircleHealthDataType.sleepAsleep: HealthDataType.SLEEP_ASLEEP,
  CareCircleHealthDataType.activeEnergyBurned:
      HealthDataType.ACTIVE_ENERGY_BURNED,
  CareCircleHealthDataType.basalEnergyBurned:
      HealthDataType.BASAL_ENERGY_BURNED,
  CareCircleHealthDataType.distanceWalkingRunning:
      HealthDataType.DISTANCE_WALKING_RUNNING,
  CareCircleHealthDataType.bodyTemperature: HealthDataType.BODY_TEMPERATURE,
  CareCircleHealthDataType.oxygenSaturation: HealthDataType.BLOOD_OXYGEN,
  CareCircleHealthDataType.bloodGlucose: HealthDataType.BLOOD_GLUCOSE,
};

/// Health data model for CareCircle
class CareCircleHealthData {
  final CareCircleHealthDataType type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? source;

  const CareCircleHealthData({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.source,
  });

  /// Convert from Flutter Health HealthDataPoint
  factory CareCircleHealthData.fromHealthDataPoint(HealthDataPoint dataPoint) {
    // Find the CareCircle type that matches this health data type
    final careCircleType = _healthDataTypeMap.entries
        .firstWhere(
          (entry) => entry.value == dataPoint.type,
          orElse: () => throw ArgumentError(
            'Unsupported health data type: ${dataPoint.type}',
          ),
        )
        .key;

    return CareCircleHealthData(
      type: careCircleType,
      value: (dataPoint.value as num).toDouble(),
      unit: dataPoint.unit.name,
      timestamp: dataPoint.dateFrom,
      source: dataPoint.sourcePlatform.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'source': source,
    };
  }

  @override
  String toString() {
    return 'CareCircleHealthData(type: $type, value: $value, unit: $unit, timestamp: $timestamp, source: $source)';
  }
}

/// Main health service for managing health data integration
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  bool _isConfigured = false;

  /// Initialize the health service
  Future<void> initialize() async {
    if (_isConfigured) return;

    try {
      // Check if HealthKit is enabled in configuration
      if (!AppConfig.enableHealthKit) {
        debugPrint('HealthService: HealthKit is disabled in configuration');
        _isConfigured = false;
        return;
      }

      await _health.configure();
      _isConfigured = true;
      debugPrint('HealthService: Successfully configured');
    } catch (e) {
      debugPrint('HealthService: Failed to configure - $e');
      throw Exception('Failed to initialize health service: $e');
    }
  }

  /// Check if the health service is available on this platform
  bool get isAvailable => _isConfigured;

  /// Request permissions for specific health data types
  Future<bool> requestPermissions(List<CareCircleHealthDataType> types) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      // Request activity recognition permission first (required for Android)
      final activityPermission = await Permission.activityRecognition.request();
      final locationPermission = await Permission.location.request();

      if (activityPermission != PermissionStatus.granted) {
        debugPrint('HealthService: Activity recognition permission denied');
      }

      if (locationPermission != PermissionStatus.granted) {
        debugPrint('HealthService: Location permission denied');
      }

      // Convert to Flutter Health types
      final healthTypes = types
          .map((type) => _healthDataTypeMap[type]!)
          .toList();

      // Request health data permissions
      final bool hasPermissions = await _health.requestAuthorization(
        healthTypes,
        permissions: healthTypes
            .map((type) => HealthDataAccess.READ_WRITE)
            .toList(),
      );

      if (hasPermissions) {
        debugPrint(
          'HealthService: Permissions granted for ${types.length} data types',
        );
      } else {
        debugPrint('HealthService: Permissions denied');
      }

      return hasPermissions;
    } catch (e) {
      debugPrint('HealthService: Error requesting permissions - $e');
      return false;
    }
  }

  /// Check if permissions are granted for specific health data types
  Future<bool> hasPermissions(List<CareCircleHealthDataType> types) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      final healthTypes = types
          .map((type) => _healthDataTypeMap[type]!)
          .toList();

      final bool? hasPermissions = await _health.hasPermissions(
        healthTypes,
        permissions: healthTypes
            .map((type) => HealthDataAccess.READ_WRITE)
            .toList(),
      );

      return hasPermissions ?? false;
    } catch (e) {
      debugPrint('HealthService: Error checking permissions - $e');
      return false;
    }
  }

  /// Get health data for specific types within a date range
  Future<List<CareCircleHealthData>> getHealthData({
    required List<CareCircleHealthDataType> types,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      final healthTypes = types
          .map((type) => _healthDataTypeMap[type]!)
          .toList();

      final List<HealthDataPoint> healthData = await _health
          .getHealthDataFromTypes(
            types: healthTypes,
            startTime: startDate,
            endTime: endDate,
          );

      // Remove duplicates and convert to CareCircle format
      final List<HealthDataPoint> uniqueData = _health.removeDuplicates(
        healthData,
      );

      return uniqueData
          .map(
            (dataPoint) => CareCircleHealthData.fromHealthDataPoint(dataPoint),
          )
          .toList();
    } catch (e) {
      debugPrint('HealthService: Error getting health data - $e');
      throw Exception('Failed to get health data: $e');
    }
  }

  /// Get step count for a specific date range
  Future<int?> getTotalSteps({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      return await _health.getTotalStepsInInterval(startDate, endDate);
    } catch (e) {
      debugPrint('HealthService: Error getting step count - $e');
      return null;
    }
  }

  /// Write health data point
  Future<bool> writeHealthData({
    required CareCircleHealthDataType type,
    required double value,
    required String unit,
    required DateTime timestamp,
  }) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      final healthType = _healthDataTypeMap[type]!;

      return await _health.writeHealthData(
        value: value,
        type: healthType,
        startTime: timestamp,
        endTime: timestamp,
      );
    } catch (e) {
      debugPrint('HealthService: Error writing health data - $e');
      return false;
    }
  }

  /// Write blood pressure data (special case with systolic and diastolic)
  Future<bool> writeBloodPressure({
    required double systolic,
    required double diastolic,
    required DateTime timestamp,
  }) async {
    if (!_isConfigured) {
      await initialize();
    }

    try {
      return await _health.writeBloodPressure(
        systolic: systolic.toInt(),
        diastolic: diastolic.toInt(),
        startTime: timestamp,
      );
    } catch (e) {
      debugPrint('HealthService: Error writing blood pressure - $e');
      return false;
    }
  }

  /// Get the last sync time for health data
  DateTime? getLastSyncTime() {
    // This would be stored in local storage/preferences
    // For now, return null to indicate no previous sync
    return null;
  }

  /// Set the last sync time
  Future<void> setLastSyncTime(DateTime timestamp) async {
    // This would be stored in local storage/preferences
    // Implementation would use SharedPreferences or similar
  }

  /// Sync health data to backend
  Future<bool> syncToBackend(List<CareCircleHealthData> healthData) async {
    try {
      // This would make HTTP calls to your NestJS backend
      // For now, just log the data
      debugPrint(
        'HealthService: Syncing ${healthData.length} health data points to backend',
      );

      for (final data in healthData) {
        debugPrint('HealthService: ${data.toString()}');
      }

      // TODO: Implement actual HTTP call to backend
      // final response = await http.post(
      //   Uri.parse('${baseUrl}/health-data/sync'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(healthData.map((data) => data.toJson()).toList()),
      // );

      return true;
    } catch (e) {
      debugPrint('HealthService: Error syncing to backend - $e');
      return false;
    }
  }

  /// Perform a complete health data sync
  Future<bool> performSync() async {
    try {
      final now = DateTime.now();
      final lastSync =
          getLastSyncTime() ?? now.subtract(const Duration(days: 30));

      // Define the health data types we want to sync
      const typesToSync = [
        CareCircleHealthDataType.steps,
        CareCircleHealthDataType.heartRate,
        CareCircleHealthDataType.weight,
        CareCircleHealthDataType.sleepAsleep,
        CareCircleHealthDataType.activeEnergyBurned,
        CareCircleHealthDataType.distanceWalkingRunning,
      ];

      debugPrint('HealthService: Starting sync from $lastSync to $now');

      // Get health data
      final healthData = await getHealthData(
        types: typesToSync,
        startDate: lastSync,
        endDate: now,
      );

      // Sync to backend
      final success = await syncToBackend(healthData);

      if (success) {
        await setLastSyncTime(now);
        debugPrint(
          'HealthService: Sync completed successfully with ${healthData.length} data points',
        );
      } else {
        debugPrint('HealthService: Sync failed');
      }

      return success;
    } catch (e) {
      debugPrint('HealthService: Error during sync - $e');
      return false;
    }
  }
}
