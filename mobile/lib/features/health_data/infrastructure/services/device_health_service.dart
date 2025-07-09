import 'dart:async';
import 'dart:io';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/health_metric_type.dart';
import '../../../../core/logging/bounded_context_loggers.dart';

/// Service for integrating with device health platforms (HealthKit/Health Connect)
class DeviceHealthService {
  static final DeviceHealthService _instance = DeviceHealthService._internal();
  factory DeviceHealthService() => _instance;
  DeviceHealthService._internal();

  final Health _health = Health();
  bool _isConfigured = false;
  bool _hasPermissions = false;

  // Healthcare-compliant logger for health data context
  static final _logger = BoundedContextLoggers.healthData;

  /// Initialize the health service
  Future<bool> initialize() async {
    try {
      _logger.info('Initializing device health service...');

      // Configure the health plugin
      await _health.configure();
      _isConfigured = true;

      _logger.info('Device health service initialized successfully');
      return true;
    } catch (e, _) {
      _logger.error('Failed to initialize device health service: $e', e);
      return false;
    }
  }

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    if (!_isConfigured) {
      _logger.warning('Health service not configured. Initializing first...');
      final initialized = await initialize();
      if (!initialized) return false;
    }

    try {
      _logger.info('Requesting health data permissions...');

      // Request runtime permissions first (Android)
      if (Platform.isAndroid) {
        await Permission.activityRecognition.request();
        await Permission.location.request();
      }

      // Request health data authorization
      final types = HealthMetricType.allHealthDataTypes;
      final permissions = HealthMetricType.allPermissions;

      final granted = await _health.requestAuthorization(types, permissions: permissions);

      _hasPermissions = granted;

      if (granted) {
        _logger.info('Health data permissions granted');
      } else {
        _logger.warning('Health data permissions denied');
      }

      return granted;
    } catch (e, _) {
      _logger.error('Failed to request health permissions: $e', e);
      return false;
    }
  }

  /// Check if permissions are granted
  Future<bool> hasPermissions() async {
    if (!_isConfigured) return false;

    try {
      final types = HealthMetricType.allHealthDataTypes;
      final hasAuth = await _health.hasPermissions(types);
      _hasPermissions = hasAuth ?? false;
      return _hasPermissions;
    } catch (e, _) {
      _logger.error('Failed to check health permissions: $e', e);
      return false;
    }
  }

  /// Fetch health data for a specific metric type
  Future<List<HealthDataPoint>> fetchHealthData({
    required HealthMetricType metricType,
    required DateTime startTime,
    required DateTime endTime,
    bool includeManualEntries = true,
  }) async {
    if (!_hasPermissions) {
      _logger.warning('No health permissions. Requesting permissions...');
      final granted = await requestPermissions();
      if (!granted) return [];
    }

    try {
      _logger.info('Fetching health data for ${metricType.displayName}');

      List<HealthDataType> types = [metricType.toHealthDataType()];

      // For blood pressure, fetch both systolic and diastolic
      if (metricType.isBloodPressure) {
        types = [HealthDataType.BLOOD_PRESSURE_SYSTOLIC, HealthDataType.BLOOD_PRESSURE_DIASTOLIC];
      }

      List<RecordingMethod> recordingMethodsToFilter = [];
      if (!includeManualEntries) {
        recordingMethodsToFilter = [RecordingMethod.automatic];
      }

      final healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startTime,
        endTime: endTime,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      // Remove duplicates
      final uniqueData = _health.removeDuplicates(healthData);

      _logger.info('Fetched ${uniqueData.length} health data points for ${metricType.displayName}');
      return uniqueData;
    } catch (e, _) {
      _logger.error('Failed to fetch health data for ${metricType.displayName}: $e', e);
      return [];
    }
  }

  /// Write health data to the device
  Future<bool> writeHealthData({
    required HealthMetricType metricType,
    required double value,
    required DateTime timestamp,
    String? unit,
    Map<String, dynamic>? metadata,
    double? diastolicValue, // For blood pressure
  }) async {
    if (!_hasPermissions) {
      _logger.warning('No health permissions. Requesting permissions...');
      final granted = await requestPermissions();
      if (!granted) return false;
    }

    try {
      _logger.info('Writing health data: ${metricType.displayName} = $value');

      bool success = false;

      if (metricType.isBloodPressure) {
        // Write both systolic and diastolic values
        final systolicSuccess = await _health.writeHealthData(
          value: value,
          type: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
          startTime: timestamp,
          endTime: timestamp,
          recordingMethod: RecordingMethod.manual,
        );

        bool diastolicSuccess = true;
        if (diastolicValue != null) {
          diastolicSuccess = await _health.writeHealthData(
            value: diastolicValue,
            type: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
            startTime: timestamp,
            endTime: timestamp,
            recordingMethod: RecordingMethod.manual,
          );
        }

        success = systolicSuccess && diastolicSuccess;
      } else {
        success = await _health.writeHealthData(
          value: value,
          type: metricType.toHealthDataType(),
          startTime: timestamp,
          endTime: timestamp,
          recordingMethod: RecordingMethod.manual,
        );
      }

      if (success) {
        _logger.info('Successfully wrote health data for ${metricType.displayName}');
      } else {
        _logger.warning('Failed to write health data for ${metricType.displayName}');
      }

      return success;
    } catch (e, _) {
      _logger.error('Failed to write health data for ${metricType.displayName}: $e', e);
      return false;
    }
  }

  /// Get total steps for a specific day
  Future<int?> getTotalStepsForDay(DateTime date) async {
    if (!_hasPermissions) {
      final granted = await requestPermissions();
      if (!granted) return null;
    }

    try {
      final midnight = DateTime(date.year, date.month, date.day);
      final endOfDay = midnight.add(const Duration(days: 1));

      final steps = await _health.getTotalStepsInInterval(midnight, endOfDay);
      _logger.info('Total steps for ${date.toIso8601String().split('T')[0]}: $steps');

      return steps;
    } catch (e, _) {
      _logger.error('Failed to get total steps for day: $e', e);
      return null;
    }
  }

  /// Check if Health Connect is available (Android only)
  Future<bool> isHealthConnectAvailable() async {
    if (!Platform.isAndroid) return false;

    try {
      // Configure and check if Health Connect is available
      await _health.configure();
      return true;
    } catch (e) {
      _logger.warning('Health Connect not available: $e');
      return false;
    }
  }

  /// Get the platform type (HealthKit or Health Connect)
  String get platformName {
    if (Platform.isIOS) {
      return 'HealthKit';
    } else if (Platform.isAndroid) {
      return 'Health Connect';
    } else {
      return 'Unknown';
    }
  }

  /// Check if the service is ready to use
  bool get isReady => _isConfigured && _hasPermissions;

  /// Get supported metric types for the current platform
  List<HealthMetricType> get supportedMetricTypes {
    // All metric types are supported on both platforms
    return HealthMetricType.values;
  }

  /// Dispose resources
  void dispose() {
    // Clean up any resources if needed
    _logger.info('Device health service disposed');
  }
}
