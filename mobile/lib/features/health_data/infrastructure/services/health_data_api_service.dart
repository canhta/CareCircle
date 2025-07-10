import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric.dart';
import '../../domain/models/health_profile.dart';
import '../../domain/models/health_device.dart';

/// Healthcare-compliant health data API service with comprehensive logging
///
/// This service handles all health data operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class HealthDataApiService {
  final Dio _dio;

  // Healthcare-compliant logger for health data context
  static final _logger = BoundedContextLoggers.healthData;

  HealthDataApiService(this._dio);

  /// Get user's health profile with privacy-compliant logging
  Future<HealthProfile> getHealthProfile(String userId) async {
    _logger.info('Health profile access initiated', {
      'userId': userId,
      'operation': 'getHealthProfile',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.get('/health-data/profile/$userId');
      final healthProfile = HealthProfile.fromJson(response.data);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Health profile accessed', {
        'userId': userId,
        'dataType': 'health_profile',
        'hasBasicInfo': healthProfile.baselineMetrics.height > 0 || healthProfile.baselineMetrics.weight > 0,
        'hasConditions': healthProfile.healthConditions.isNotEmpty,
        'hasAllergies': healthProfile.allergies.isNotEmpty,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return healthProfile;
    } on DioException catch (e) {
      _logger.error('Health profile access failed', {
        'userId': userId,
        'operation': 'getHealthProfile',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    } catch (e) {
      _logger.error('Unexpected error in health profile access', {
        'userId': userId,
        'operation': 'getHealthProfile',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Update user's health profile with comprehensive logging
  Future<HealthProfile> updateHealthProfile(String userId, HealthProfile profile) async {
    _logger.info('Health profile update initiated', {
      'userId': userId,
      'operation': 'updateHealthProfile',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.put(
        '/health-data/profile/$userId',
        data: profile.toJson(),
      );
      final updatedProfile = HealthProfile.fromJson(response.data);

      _logger.logHealthDataAccess('Health profile updated', {
        'userId': userId,
        'dataType': 'health_profile',
        'operation': 'update',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return updatedProfile;
    } on DioException catch (e) {
      _logger.error('Health profile update failed', {
        'userId': userId,
        'operation': 'updateHealthProfile',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Get health metrics with privacy-compliant filtering
  Future<List<HealthMetric>> getHealthMetrics(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? metricTypes,
    int? limit,
  }) async {
    _logger.info('Health metrics access initiated', {
      'userId': userId,
      'operation': 'getHealthMetrics',
      'hasDateRange': startDate != null && endDate != null,
      'hasMetricFilter': metricTypes != null && metricTypes.isNotEmpty,
      'limit': limit,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final queryParams = <String, dynamic>{
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (metricTypes != null && metricTypes.isNotEmpty) 'metricTypes': metricTypes.join(','),
        if (limit != null) 'limit': limit,
      };

      final response = await _dio.get(
        '/health-data/metrics/$userId',
        queryParameters: queryParams,
      );

      final metrics = (response.data as List)
          .map((json) => HealthMetric.fromJson(json))
          .toList();

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Health metrics accessed', {
        'userId': userId,
        'dataType': 'health_metrics',
        'metricCount': metrics.length,
        'dateRange': startDate != null && endDate != null ? '${startDate.toIso8601String()} to ${endDate.toIso8601String()}' : null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return metrics;
    } on DioException catch (e) {
      _logger.error('Health metrics access failed', {
        'userId': userId,
        'operation': 'getHealthMetrics',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Add new health metric with validation logging
  Future<HealthMetric> addHealthMetric(String userId, HealthMetric metric) async {
    _logger.info('Health metric addition initiated', {
      'userId': userId,
      'operation': 'addHealthMetric',
      'metricType': metric.metricType.name,
      'source': metric.source.name,
      'isManual': metric.isManualEntry,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.post(
        '/health-data/metrics/$userId',
        data: metric.toJson(),
      );
      final addedMetric = HealthMetric.fromJson(response.data);

      _logger.logHealthDataAccess('Health metric added', {
        'userId': userId,
        'dataType': 'health_metric',
        'metricType': metric.metricType.name,
        'operation': 'add',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return addedMetric;
    } on DioException catch (e) {
      _logger.error('Health metric addition failed', {
        'userId': userId,
        'operation': 'addHealthMetric',
        'metricType': metric.metricType.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Get user's health devices
  Future<List<HealthDevice>> getHealthDevices(String userId) async {
    _logger.info('Health devices access initiated', {
      'userId': userId,
      'operation': 'getHealthDevices',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.get('/health-data/devices/$userId');
      final devices = (response.data as List)
          .map((json) => HealthDevice.fromJson(json))
          .toList();

      _logger.logHealthDataAccess('Health devices accessed', {
        'userId': userId,
        'dataType': 'health_devices',
        'deviceCount': devices.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return devices;
    } on DioException catch (e) {
      _logger.error('Health devices access failed', {
        'userId': userId,
        'operation': 'getHealthDevices',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Add or update health device
  Future<HealthDevice> saveHealthDevice(String userId, HealthDevice device) async {
    _logger.info('Health device save initiated', {
      'userId': userId,
      'operation': 'saveHealthDevice',
      'deviceType': device.deviceType.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.post(
        '/health-data/devices/$userId',
        data: device.toJson(),
      );
      final savedDevice = HealthDevice.fromJson(response.data);

      _logger.logHealthDataAccess('Health device saved', {
        'userId': userId,
        'dataType': 'health_device',
        'deviceType': device.deviceType.name,
        'operation': 'save',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return savedDevice;
    } on DioException catch (e) {
      _logger.error('Health device save failed', {
        'userId': userId,
        'operation': 'saveHealthDevice',
        'deviceType': device.deviceType.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Delete health metric
  Future<void> deleteHealthMetric(String userId, String metricId) async {
    _logger.info('Health metric deletion initiated', {
      'userId': userId,
      'metricId': metricId,
      'operation': 'deleteHealthMetric',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      await _dio.delete('/health-data/metrics/$userId/$metricId');

      _logger.logHealthDataAccess('Health metric deleted', {
        'userId': userId,
        'metricId': metricId,
        'dataType': 'health_metric',
        'operation': 'delete',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      _logger.error('Health metric deletion failed', {
        'userId': userId,
        'metricId': metricId,
        'operation': 'deleteHealthMetric',
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }
}

/// Provider for health data API service
final healthDataApiServiceProvider = Provider<HealthDataApiService>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  return HealthDataApiService(dio);
});
