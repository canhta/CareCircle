import 'dart:async';

import 'package:dio/dio.dart';
import 'package:health/health.dart';

import '../../../health-data/models/health_metric.dart' show HealthMetric, MetricType, DataSource, ValidationStatus;
import '../../domain/models/health_metric_type.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/config/app_config.dart';
import 'device_health_service.dart';
import '../../../health-data/services/health_data_service.dart';

/// Service for synchronizing health data between device and backend
class HealthDataSyncService {
  static final HealthDataSyncService _instance = HealthDataSyncService._internal();
  factory HealthDataSyncService() => _instance;
  HealthDataSyncService._internal();

  final DeviceHealthService _deviceHealthService = DeviceHealthService();
  late final HealthDataService _healthDataService;

  // Healthcare-compliant logger for health data context
  static final _logger = BoundedContextLoggers.healthData;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  /// Initialize the sync service
  Future<bool> initialize() async {
    try {
      _logger.info('Initializing health data sync service...');

      // Initialize Dio client for health data service
      final dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      _healthDataService = HealthDataService(dio);

      final deviceInitialized = await _deviceHealthService.initialize();
      if (!deviceInitialized) {
        _logger.error('Failed to initialize device health service');
        return false;
      }

      _logger.info('Health data sync service initialized successfully');
      return true;
    } catch (e) {
      _logger.error('Failed to initialize health data sync service: $e', e);
      return false;
    }
  }

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    try {
      _logger.info('Requesting health data sync permissions...');

      final granted = await _deviceHealthService.requestPermissions();
      if (granted) {
        _logger.info('Health data sync permissions granted');
      } else {
        _logger.warning('Health data sync permissions denied');
      }

      return granted;
    } catch (e) {
      _logger.error('Failed to request health data sync permissions: $e', e);
      return false;
    }
  }

  /// Sync health data from device to backend
  Future<SyncResult> syncHealthData({
    List<HealthMetricType>? metricTypes,
    DateTime? startTime,
    DateTime? endTime,
    bool forceSync = false,
  }) async {
    if (_isSyncing && !forceSync) {
      _logger.warning('Sync already in progress');
      return SyncResult(success: false, message: 'Sync already in progress', syncedCount: 0, errorCount: 0);
    }

    _isSyncing = true;

    try {
      _logger.info('Starting health data sync...');

      // Default to last 7 days if no time range specified
      final syncStartTime = startTime ?? _lastSyncTime ?? DateTime.now().subtract(const Duration(days: 7));
      final syncEndTime = endTime ?? DateTime.now();

      // Default to all metric types if none specified
      final typesToSync = metricTypes ?? HealthMetricType.values;

      int syncedCount = 0;
      int errorCount = 0;
      final List<String> errors = [];

      for (final metricType in typesToSync) {
        try {
          final result = await _syncMetricType(metricType, syncStartTime, syncEndTime);
          syncedCount += result.syncedCount;
          errorCount += result.errorCount;
          errors.addAll(result.errors);
        } catch (e) {
          _logger.error('Failed to sync ${metricType.displayName}: $e', e);
          errorCount++;
          errors.add('Failed to sync ${metricType.displayName}: $e');
        }
      }

      _lastSyncTime = syncEndTime;

      _logger.info('Health data sync completed: $syncedCount synced, $errorCount errors');

      return SyncResult(
        success: errorCount == 0,
        message: errorCount == 0
            ? 'Successfully synced $syncedCount health data points'
            : 'Synced $syncedCount points with $errorCount errors',
        syncedCount: syncedCount,
        errorCount: errorCount,
        errors: errors,
        lastSyncTime: _lastSyncTime,
      );
    } catch (e) {
      _logger.error('Health data sync failed: $e', e);
      return SyncResult(
        success: false,
        message: 'Sync failed: $e',
        syncedCount: 0,
        errorCount: 1,
        errors: ['Sync failed: $e'],
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a specific metric type
  Future<SyncResult> _syncMetricType(HealthMetricType metricType, DateTime startTime, DateTime endTime) async {
    try {
      _logger.info('Syncing ${metricType.displayName} from $startTime to $endTime');

      // Fetch data from device
      final deviceData = await _deviceHealthService.fetchHealthData(
        metricType: metricType,
        startTime: startTime,
        endTime: endTime,
        includeManualEntries: true,
      );

      if (deviceData.isEmpty) {
        _logger.info('No ${metricType.displayName} data found on device');
        return SyncResult(success: true, message: 'No data to sync', syncedCount: 0, errorCount: 0);
      }

      // Convert device data to backend format
      final healthMetrics = _convertDeviceDataToHealthMetrics(deviceData, metricType);

      int syncedCount = 0;
      int errorCount = 0;
      final List<String> errors = [];

      // Upload to backend
      for (final metric in healthMetrics) {
        try {
          await _healthDataService.recordHealthMetric('', metric); // TODO: Get actual userId
          syncedCount++;
        } catch (e) {
          _logger.error('Failed to upload health metric: $e', e);
          errorCount++;
          errors.add('Failed to upload metric: $e');
        }
      }

      _logger.info('Synced ${metricType.displayName}: $syncedCount uploaded, $errorCount errors');

      return SyncResult(
        success: errorCount == 0,
        message: 'Synced ${metricType.displayName}',
        syncedCount: syncedCount,
        errorCount: errorCount,
        errors: errors,
      );
    } catch (e) {
      _logger.error('Failed to sync ${metricType.displayName}: $e', e);
      return SyncResult(
        success: false,
        message: 'Failed to sync ${metricType.displayName}',
        syncedCount: 0,
        errorCount: 1,
        errors: ['Failed to sync ${metricType.displayName}: $e'],
      );
    }
  }

  /// Convert device health data points to backend health metrics
  List<HealthMetric> _convertDeviceDataToHealthMetrics(List<HealthDataPoint> deviceData, HealthMetricType metricType) {
    final List<HealthMetric> metrics = [];

    if (metricType.isBloodPressure) {
      // Group blood pressure readings by timestamp
      final Map<DateTime, Map<String, HealthDataPoint>> bpReadings = {};

      for (final point in deviceData) {
        final timestamp = point.dateFrom;
        bpReadings[timestamp] ??= {};

        if (point.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
          bpReadings[timestamp]!['systolic'] = point;
        } else if (point.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
          bpReadings[timestamp]!['diastolic'] = point;
        }
      }

      // Create blood pressure metrics
      for (final entry in bpReadings.entries) {
        final systolic = entry.value['systolic'];
        final diastolic = entry.value['diastolic'];

        if (systolic != null) {
          final metadata = <String, dynamic>{};
          if (diastolic != null) {
            metadata['diastolic'] = _extractNumericValue(diastolic.value);
          }
          metadata.addAll(_getMetadata(systolic));

          final metric = HealthMetric(
            id: '', // Will be assigned by backend
            userId: '', // Will be set by caller
            metricType: _convertToMetricType(metricType),
            value: _extractNumericValue(systolic.value),
            unit: metricType.unit,
            timestamp: systolic.dateFrom,
            source: _getDataSource(systolic),
            deviceId: _getDeviceId(systolic),
            isManualEntry: systolic.recordingMethod == RecordingMethod.manual,
            validationStatus: ValidationStatus.pending,
            metadata: metadata,
            createdAt: DateTime.now(),
          );
          metrics.add(metric);
        }
      }
    } else {
      // Handle other metric types
      for (final point in deviceData) {
        final metric = HealthMetric(
          id: '', // Will be assigned by backend
          userId: '', // Will be set by caller
          metricType: _convertToMetricType(metricType),
          value: _extractNumericValue(point.value),
          unit: metricType.unit,
          timestamp: point.dateFrom,
          source: _getDataSource(point),
          deviceId: _getDeviceId(point),
          isManualEntry: point.recordingMethod == RecordingMethod.manual,
          metadata: _getMetadata(point),
          validationStatus: ValidationStatus.pending,
          createdAt: DateTime.now(),
        );
        metrics.add(metric);
      }
    }

    return metrics;
  }

  /// Convert HealthMetricType to MetricType enum
  MetricType _convertToMetricType(HealthMetricType healthMetricType) {
    switch (healthMetricType) {
      case HealthMetricType.heartRate:
        return MetricType.heartRate;
      case HealthMetricType.bloodPressure:
        return MetricType.bloodPressure;
      case HealthMetricType.bloodGlucose:
        return MetricType.bloodGlucose;
      case HealthMetricType.bodyTemperature:
        return MetricType.bodyTemperature;
      case HealthMetricType.weight:
        return MetricType.weight;
      case HealthMetricType.steps:
        return MetricType.steps;
      case HealthMetricType.oxygenSaturation:
        return MetricType.bloodOxygen;
      case HealthMetricType.sleep:
        return MetricType.sleep;
      case HealthMetricType.exercise:
        return MetricType.activity;
      case HealthMetricType.height:
        return MetricType.weight; // Fallback to weight for height
    }
  }

  /// Extract numeric value from HealthValue
  double _extractNumericValue(HealthValue value) {
    if (value is NumericHealthValue) {
      return value.numericValue.toDouble();
    }
    // Fallback for other types
    return 0.0;
  }

  /// Get data source from health data point
  DataSource _getDataSource(HealthDataPoint point) {
    if (point.recordingMethod == RecordingMethod.manual) {
      return DataSource.manual;
    }

    // Determine source based on platform and source
    final sourceName = point.sourceName.toLowerCase();
    if (sourceName.contains('health')) {
      return DataSource.appleHealth;
    } else if (sourceName.contains('fit') || sourceName.contains('google')) {
      return DataSource.googleFit;
    } else {
      return DataSource.bluetoothDevice;
    }
  }

  /// Get device ID from health data point
  String? _getDeviceId(HealthDataPoint point) {
    return point.sourceDeviceId;
  }

  /// Get metadata from health data point
  Map<String, dynamic> _getMetadata(HealthDataPoint point) {
    final metadata = <String, dynamic>{};

    metadata['sourceName'] = point.sourceName;
    metadata['sourceId'] = point.sourceId;
    metadata['recordingMethod'] = point.recordingMethod.toString();

    return metadata;
  }

  /// Check if sync is currently in progress
  bool get isSyncing => _isSyncing;

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Check if the service is ready to sync
  bool get isReady => _deviceHealthService.isReady;

  /// Dispose resources
  void dispose() {
    _deviceHealthService.dispose();
    _logger.info('Health data sync service disposed');
  }
}

/// Result of a health data sync operation
class SyncResult {
  final bool success;
  final String message;
  final int syncedCount;
  final int errorCount;
  final List<String> errors;
  final DateTime? lastSyncTime;

  const SyncResult({
    required this.success,
    required this.message,
    required this.syncedCount,
    required this.errorCount,
    this.errors = const [],
    this.lastSyncTime,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, synced: $syncedCount, errors: $errorCount)';
  }
}
