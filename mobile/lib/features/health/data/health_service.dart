import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/common.dart';
import '../../../config/app_config.dart';
import '../domain/health_models.dart';
import '../domain/health_repository.dart';

/// Health service implementation
class HealthService extends BaseRepository implements HealthRepository {
  final Health _health = Health();
  final SecureStorageService _secureStorage;
  bool _isConfigured = false;

  HealthService({
    required super.apiClient,
    required super.logger,
    required SecureStorageService secureStorage,
  }) : _secureStorage = secureStorage;

  static const String _lastSyncTimeKey = 'health_last_sync_time';

  @override
  Future<Result<void>> initialize() async {
    if (_isConfigured) return const Result.success(null);

    try {
      // Check if HealthKit is enabled in configuration
      if (!AppConfig.enableHealthKit) {
        logger.info('HealthKit is disabled in configuration');
        return const Result.failure(
          NetworkException(
            'HealthKit is disabled in configuration',
            type: NetworkExceptionType.unknown,
          ),
        );
      }

      await _health.configure();
      _isConfigured = true;
      logger.info('Health service initialized successfully');
      return const Result.success(null);
    } catch (e) {
      logger.error('Failed to initialize health service', error: e);
      return Result.failure(
        NetworkException(
          'Failed to initialize health service: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  bool get isAvailable => _isConfigured;

  @override
  Future<Result<HealthPermissions>> requestPermissions(
    List<CareCircleHealthDataType> types,
  ) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      // Request activity recognition permission first (required for Android)
      final activityPermission = await Permission.activityRecognition.request();
      final locationPermission = await Permission.location.request();

      if (activityPermission != PermissionStatus.granted) {
        logger.warning('Activity recognition permission denied');
      }

      if (locationPermission != PermissionStatus.granted) {
        logger.warning('Location permission denied');
      }

      // Convert to Flutter Health types
      final healthTypes =
          types.map((type) => healthDataTypeMap[type]!).toList();

      // Request health data permissions
      final bool hasPermissions = await _health.requestAuthorization(
        healthTypes,
        permissions:
            healthTypes.map((type) => HealthDataAccess.READ_WRITE).toList(),
      );

      // Build permissions map
      final permissionsMap = <CareCircleHealthDataType, bool>{};
      for (final type in types) {
        permissionsMap[type] = hasPermissions;
      }

      final permissions = HealthPermissions(permissions: permissionsMap);

      if (hasPermissions) {
        logger
            .info('Health permissions granted for ${types.length} data types');
      } else {
        logger.warning('Health permissions denied');
      }

      return Result.success(permissions);
    } catch (e) {
      logger.error('Error requesting health permissions', error: e);
      return Result.failure(
        NetworkException(
          'Error requesting health permissions: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<HealthPermissions>> checkPermissions(
    List<CareCircleHealthDataType> types,
  ) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final healthTypes =
          types.map((type) => healthDataTypeMap[type]!).toList();

      final bool? hasPermissions = await _health.hasPermissions(
        healthTypes,
        permissions:
            healthTypes.map((type) => HealthDataAccess.READ_WRITE).toList(),
      );

      // Build permissions map
      final permissionsMap = <CareCircleHealthDataType, bool>{};
      for (final type in types) {
        permissionsMap[type] = hasPermissions ?? false;
      }

      final permissions = HealthPermissions(permissions: permissionsMap);

      return Result.success(permissions);
    } catch (e) {
      logger.error('Error checking health permissions', error: e);
      return Result.failure(
        NetworkException(
          'Error checking health permissions: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<CareCircleHealthData>>> getHealthData(
    HealthDataRequest request,
  ) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final healthTypes =
          request.types.map((type) => healthDataTypeMap[type]!).toList();

      final List<HealthDataPoint> healthData =
          await _health.getHealthDataFromTypes(
        types: healthTypes,
        startTime: request.startDate,
        endTime: request.endDate,
      );

      // Remove duplicates and convert to CareCircle format
      final List<HealthDataPoint> uniqueData =
          _health.removeDuplicates(healthData);

      final List<CareCircleHealthData> result = [];
      for (final dataPoint in uniqueData) {
        try {
          final careCircleData =
              CareCircleHealthData.fromHealthDataPoint(dataPoint);
          result.add(careCircleData);
        } catch (e) {
          logger.warning('Skipping unsupported data point', error: e);
          // Continue processing other data points
        }
      }

      // Apply limit if specified
      if (request.limit != null && result.length > request.limit!) {
        result.removeRange(request.limit!, result.length);
      }

      logger.info('Successfully retrieved ${result.length} health data points');
      return Result.success(result);
    } catch (e) {
      logger.error('Error getting health data', error: e);
      return Result.failure(
        NetworkException(
          'Error getting health data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<int>> getTotalSteps({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final steps = await _health.getTotalStepsInInterval(startDate, endDate);

      if (steps != null) {
        logger.info('Retrieved total steps: $steps');
        return Result.success(steps);
      } else {
        logger.warning('No step data available for the specified period');
        return const Result.success(0);
      }
    } catch (e) {
      logger.error('Error getting total steps', error: e);
      return Result.failure(
        NetworkException(
          'Error getting total steps: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> writeHealthData(CareCircleHealthData healthData) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final healthType = healthDataTypeMap[healthData.type]!;

      final success = await _health.writeHealthData(
        value: healthData.value,
        type: healthType,
        startTime: healthData.timestamp,
        endTime: healthData.timestamp,
      );

      if (success) {
        logger.info('Successfully wrote health data: ${healthData.type}');
      } else {
        logger.warning('Failed to write health data: ${healthData.type}');
      }

      return Result.success(success);
    } catch (e) {
      logger.error('Error writing health data', error: e);
      return Result.failure(
        NetworkException(
          'Error writing health data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> writeBloodPressure({
    required double systolic,
    required double diastolic,
    required DateTime timestamp,
  }) async {
    try {
      if (!_isConfigured) {
        final initResult = await initialize();
        if (initResult.isFailure) {
          return Result.failure(initResult.exception!);
        }
      }

      final success = await _health.writeBloodPressure(
        systolic: systolic.toInt(),
        diastolic: diastolic.toInt(),
        startTime: timestamp,
      );

      if (success) {
        logger.info('Successfully wrote blood pressure data');
      } else {
        logger.warning('Failed to write blood pressure data');
      }

      return Result.success(success);
    } catch (e) {
      logger.error('Error writing blood pressure data', error: e);
      return Result.failure(
        NetworkException(
          'Error writing blood pressure data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<HealthSyncStatus>> syncToBackend(
    List<CareCircleHealthData> healthData,
  ) async {
    try {
      logger.info('Syncing ${healthData.length} health data points to backend');

      final response = await apiClient.post(
        ApiEndpoints.healthDataSync,
        data: {
          'healthData': healthData.map((data) => data.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final syncStatus = HealthSyncStatus.fromJson(response.data);
      logger.info('Health data sync completed successfully');

      return Result.success(syncStatus);
    } catch (e) {
      logger.error('Error syncing health data to backend', error: e);
      return Result.failure(
        NetworkException(
          'Error syncing health data: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<HealthSyncStatus>> getSyncStatus() async {
    try {
      logger.info('Getting health sync status from backend');

      final response = await apiClient.get(ApiEndpoints.healthSyncStatus);
      final syncStatus = HealthSyncStatus.fromJson(response.data);

      return Result.success(syncStatus);
    } catch (e) {
      logger.error('Error getting health sync status', error: e);
      return Result.failure(
        NetworkException(
          'Error getting sync status: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<HealthSyncStatus>> performSync() async {
    try {
      logger.info('Starting complete health data sync');

      final now = DateTime.now();
      final lastSyncResult = await getLastSyncTime();
      final lastSync =
          lastSyncResult.data ?? now.subtract(const Duration(days: 30));

      // Define the health data types we want to sync
      const typesToSync = [
        CareCircleHealthDataType.steps,
        CareCircleHealthDataType.heartRate,
        CareCircleHealthDataType.weight,
        CareCircleHealthDataType.sleepAsleep,
        CareCircleHealthDataType.activeEnergyBurned,
        CareCircleHealthDataType.distanceWalkingRunning,
      ];

      // Create health data request
      final request = HealthDataRequest(
        types: typesToSync,
        startDate: lastSync,
        endDate: now,
      );

      // Get health data from device
      final healthDataResult = await getHealthData(request);
      if (healthDataResult.isFailure) {
        return Result.failure(healthDataResult.exception!);
      }

      final healthData = healthDataResult.data!;

      // Sync to backend
      final syncResult = await syncToBackend(healthData);
      if (syncResult.isFailure) {
        return Result.failure(syncResult.exception!);
      }

      final syncStatus = syncResult.data!;

      // Update last sync time
      await setLastSyncTime(now);

      logger.info(
          'Complete health sync finished successfully with ${healthData.length} data points');
      return Result.success(syncStatus);
    } catch (e) {
      logger.error('Error during complete health sync', error: e);
      return Result.failure(
        NetworkException(
          'Error during complete health sync: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<DateTime?>> getLastSyncTime() async {
    try {
      final timestampString = await _secureStorage.readString(_lastSyncTimeKey);
      if (timestampString != null) {
        final timestamp = DateTime.parse(timestampString);
        return Result.success(timestamp);
      }
      return const Result.success(null);
    } catch (e) {
      logger.error('Error getting last sync time', error: e);
      return Result.failure(
        NetworkException(
          'Error getting last sync time: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> setLastSyncTime(DateTime timestamp) async {
    try {
      await _secureStorage.writeString(
          _lastSyncTimeKey, timestamp.toIso8601String());
      logger.info('Updated last sync time to $timestamp');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error setting last sync time', error: e);
      return Result.failure(
        NetworkException(
          'Error setting last sync time: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<CareCircleHealthData>>> getHealthDataFromBackend(
    HealthDataRequest request,
  ) async {
    try {
      logger.info('Getting health data from backend');

      final response = await apiClient.post(
        ApiEndpoints.healthDataQuery,
        data: request.toJson(),
      );

      final healthDataList = (response.data['healthData'] as List)
          .map((data) => CareCircleHealthData.fromJson(data))
          .toList();

      logger.info(
          'Retrieved ${healthDataList.length} health data points from backend');
      return Result.success(healthDataList);
    } catch (e) {
      logger.error('Error getting health data from backend', error: e);
      return Result.failure(
        NetworkException(
          'Error getting health data from backend: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteHealthDataFromBackend(
    List<String> healthDataIds,
  ) async {
    try {
      logger.info(
          'Deleting ${healthDataIds.length} health data records from backend');

      await apiClient.delete(
        ApiEndpoints.healthDataDelete,
        data: {'healthDataIds': healthDataIds},
      );

      logger.info('Successfully deleted health data records from backend');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error deleting health data from backend', error: e);
      return Result.failure(
        NetworkException(
          'Error deleting health data from backend: $e',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }
}
