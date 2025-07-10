import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/health_metric_type.dart';
import '../../infrastructure/services/device_health_service.dart';
import '../../infrastructure/services/health_data_sync_service.dart';
import '../../../../core/logging/bounded_context_loggers.dart';

// Healthcare-compliant logger for health data context
final _logger = BoundedContextLoggers.healthData;

/// Provider for device health service
final deviceHealthServiceProvider = Provider<DeviceHealthService>((ref) {
  return DeviceHealthService();
});

/// Provider for health data sync service
final healthDataSyncServiceProvider = Provider<HealthDataSyncService>((ref) {
  return HealthDataSyncService();
});

/// Provider for health data API service (imported from infrastructure)
/// This provider is defined in health_data_api_service.dart

/// Provider for health sync permissions status
final healthSyncPermissionsProvider = FutureProvider<bool>((ref) async {
  final deviceService = ref.read(deviceHealthServiceProvider);
  return await deviceService.hasPermissions();
});

/// Provider for health sync status
final healthSyncStatusProvider =
    StateNotifierProvider<HealthSyncStatusNotifier, HealthSyncStatus>((ref) {
      return HealthSyncStatusNotifier(ref.read(healthDataSyncServiceProvider));
    });

/// Provider for requesting health permissions
final requestHealthPermissionsProvider = FutureProvider.family<bool, void>((
  ref,
  _,
) async {
  final syncService = ref.read(healthDataSyncServiceProvider);
  final result = await syncService.requestPermissions();

  // Invalidate permissions provider to refresh status
  ref.invalidate(healthSyncPermissionsProvider);

  return result;
});

/// Provider for syncing health data
final syncHealthDataProvider =
    FutureProvider.family<SyncResult, SyncHealthDataParams>((
      ref,
      params,
    ) async {
      final syncService = ref.read(healthDataSyncServiceProvider);

      _logger.info(
        'Starting health data sync with params: ${params.toString()}',
      );

      final result = await syncService.syncHealthData(
        metricTypes: params.metricTypes,
        startTime: params.startTime,
        endTime: params.endTime,
        forceSync: params.forceSync,
      );

      // Update sync status
      ref.read(healthSyncStatusProvider.notifier).updateLastSync(result);

      return result;
    });

/// Provider for getting total steps for a specific day
final dailyStepsProvider = FutureProvider.family<int?, DateTime>((
  ref,
  date,
) async {
  final deviceService = ref.read(deviceHealthServiceProvider);
  return await deviceService.getTotalStepsForDay(date);
});

/// Provider for checking if Health Connect is available (Android)
final healthConnectAvailableProvider = FutureProvider<bool>((ref) async {
  final deviceService = ref.read(deviceHealthServiceProvider);
  return await deviceService.isHealthConnectAvailable();
});

/// Provider for supported metric types
final supportedMetricTypesProvider = Provider<List<HealthMetricType>>((ref) {
  final deviceService = ref.read(deviceHealthServiceProvider);
  return deviceService.supportedMetricTypes;
});

/// Provider for platform name (HealthKit/Health Connect)
final healthPlatformNameProvider = Provider<String>((ref) {
  final deviceService = ref.read(deviceHealthServiceProvider);
  return deviceService.platformName;
});

/// State notifier for health sync status
class HealthSyncStatusNotifier extends StateNotifier<HealthSyncStatus> {
  final HealthDataSyncService _syncService;

  HealthSyncStatusNotifier(this._syncService)
    : super(HealthSyncStatus.initial()) {
    _initializeStatus();
  }

  void _initializeStatus() {
    state = state.copyWith(
      isSyncing: _syncService.isSyncing,
      lastSyncTime: _syncService.lastSyncTime,
      isReady: _syncService.isReady,
    );
  }

  void updateSyncStatus(bool isSyncing) {
    state = state.copyWith(isSyncing: isSyncing);
  }

  void updateLastSync(SyncResult result) {
    state = state.copyWith(
      isSyncing: false,
      lastSyncTime: result.lastSyncTime ?? DateTime.now(),
      lastSyncResult: result,
    );
  }

  void updateReadyStatus(bool isReady) {
    state = state.copyWith(isReady: isReady);
  }

  void reset() {
    state = HealthSyncStatus.initial();
  }
}

/// Health sync status state
class HealthSyncStatus {
  final bool isSyncing;
  final bool isReady;
  final DateTime? lastSyncTime;
  final SyncResult? lastSyncResult;

  const HealthSyncStatus({
    required this.isSyncing,
    required this.isReady,
    this.lastSyncTime,
    this.lastSyncResult,
  });

  factory HealthSyncStatus.initial() {
    return const HealthSyncStatus(isSyncing: false, isReady: false);
  }

  HealthSyncStatus copyWith({
    bool? isSyncing,
    bool? isReady,
    DateTime? lastSyncTime,
    SyncResult? lastSyncResult,
  }) {
    return HealthSyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      isReady: isReady ?? this.isReady,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastSyncResult: lastSyncResult ?? this.lastSyncResult,
    );
  }

  /// Check if there's an error in the last sync result
  bool get hasError => lastSyncResult != null && !lastSyncResult!.success;

  @override
  String toString() {
    return 'HealthSyncStatus(isSyncing: $isSyncing, isReady: $isReady, lastSync: $lastSyncTime)';
  }
}

/// Parameters for syncing health data
class SyncHealthDataParams {
  final List<HealthMetricType>? metricTypes;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool forceSync;

  const SyncHealthDataParams({
    this.metricTypes,
    this.startTime,
    this.endTime,
    this.forceSync = false,
  });

  @override
  String toString() {
    return 'SyncHealthDataParams(metricTypes: $metricTypes, startTime: $startTime, endTime: $endTime, forceSync: $forceSync)';
  }
}

/// Convenience providers for common sync operations

/// Provider for syncing last 24 hours of data
final syncLast24HoursProvider = FutureProvider<SyncResult>((ref) async {
  final params = SyncHealthDataParams(
    startTime: DateTime.now().subtract(const Duration(hours: 24)),
    endTime: DateTime.now(),
  );
  return ref.read(syncHealthDataProvider(params).future);
});

/// Provider for syncing last 7 days of data
final syncLast7DaysProvider = FutureProvider<SyncResult>((ref) async {
  final params = SyncHealthDataParams(
    startTime: DateTime.now().subtract(const Duration(days: 7)),
    endTime: DateTime.now(),
  );
  return ref.read(syncHealthDataProvider(params).future);
});

/// Provider for syncing specific metric type for last 7 days
final syncMetricTypeProvider =
    FutureProvider.family<SyncResult, HealthMetricType>((
      ref,
      metricType,
    ) async {
      final params = SyncHealthDataParams(
        metricTypes: [metricType],
        startTime: DateTime.now().subtract(const Duration(days: 7)),
        endTime: DateTime.now(),
      );
      return ref.read(syncHealthDataProvider(params).future);
    });

/// Provider for force syncing all data
final forceSyncAllDataProvider = FutureProvider<SyncResult>((ref) async {
  final params = SyncHealthDataParams(
    startTime: DateTime.now().subtract(
      const Duration(days: 30),
    ), // Last 30 days
    endTime: DateTime.now(),
    forceSync: true,
  );
  return ref.read(syncHealthDataProvider(params).future);
});
