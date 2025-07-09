import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config.dart';
import '../../../core/logging/logging.dart';
import '../models/health_metric.dart';
import '../models/health_profile.dart';
import '../models/health_device.dart';

/// Healthcare-compliant health data service with comprehensive logging
///
/// This service handles all health data operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class HealthDataService {
  final Dio _dio;

  // Healthcare-compliant logger for health data context
  static final _logger = BoundedContextLoggers.healthData;

  HealthDataService(this._dio);

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
      throw _handleError(e);
    }
  }

  /// Update health profile with comprehensive audit logging
  Future<HealthProfile> updateHealthProfile(String userId, HealthProfile profile) async {
    _logger.info('Health profile update initiated', {
      'userId': userId,
      'operation': 'updateHealthProfile',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      // Create sanitized summary for logging
      final updateSummary = HealthcareLogSanitizer.createSanitizedSummary(
        profile.toJson(),
        allowedFields: ['userId', 'bloodType', 'emergencyContactName'],
      );

      final response = await _dio.put('/health-data/profile/$userId', data: profile.toJson());

      final updatedProfile = HealthProfile.fromJson(response.data);

      _logger.logHealthDataAccess('Health profile updated', {
        'userId': userId,
        'dataType': 'health_profile',
        'operation': 'update',
        'fieldsUpdated': updateSummary.keys.toList(),
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
      throw _handleError(e);
    }
  }

  /// Get health metrics with time-based filtering
  Future<List<HealthMetric>> getHealthMetrics(
    String userId, {
    String? metricType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    _logger.info('Health metrics access initiated', {
      'userId': userId,
      'operation': 'getHealthMetrics',
      'metricType': metricType,
      'hasDateRange': startDate != null && endDate != null,
      'limit': limit,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final queryParams = <String, dynamic>{
        if (metricType != null) 'type': metricType,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
        if (limit != null) 'limit': limit,
      };

      final response = await _dio.get('/health-data/metrics/$userId', queryParameters: queryParams);

      final metrics = (response.data as List).map((json) => HealthMetric.fromJson(json)).toList();

      _logger.logHealthDataAccess('Health metrics accessed', {
        'userId': userId,
        'dataType': 'health_metrics',
        'metricType': metricType ?? 'all',
        'recordCount': metrics.length,
        'dateRange': startDate != null && endDate != null
            ? '${startDate.toIso8601String()} to ${endDate.toIso8601String()}'
            : 'all',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return metrics;
    } on DioException catch (e) {
      _logger.error('Health metrics access failed', {
        'userId': userId,
        'operation': 'getHealthMetrics',
        'metricType': metricType,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Record new health metric with validation logging
  Future<HealthMetric> recordHealthMetric(String userId, HealthMetric metric) async {
    _logger.info('Health metric recording initiated', {
      'userId': userId,
      'operation': 'recordHealthMetric',
      'metricType': metric.metricType.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      // Sanitize metric data for logging
      final sanitizedMetric = HealthcareLogSanitizer.createSanitizedSummary(
        metric.toJson(),
        allowedFields: ['type', 'unit', 'timestamp', 'source'],
      );

      final response = await _dio.post('/health-data/metrics/$userId', data: metric.toJson());

      final recordedMetric = HealthMetric.fromJson(response.data);

      _logger.logHealthDataAccess('Health metric recorded', {
        'userId': userId,
        'dataType': 'health_metric',
        'operation': 'create',
        'metricType': metric.metricType.name,
        'source': sanitizedMetric['source'] ?? 'manual',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return recordedMetric;
    } on DioException catch (e) {
      _logger.error('Health metric recording failed', {
        'userId': userId,
        'operation': 'recordHealthMetric',
        'metricType': metric.metricType.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get connected health devices
  Future<List<HealthDevice>> getHealthDevices(String userId) async {
    _logger.info('Health devices access initiated', {
      'userId': userId,
      'operation': 'getHealthDevices',
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await _dio.get('/health-data/devices/$userId');
      final devices = (response.data as List).map((json) => HealthDevice.fromJson(json)).toList();

      _logger.logHealthDataAccess('Health devices accessed', {
        'userId': userId,
        'dataType': 'health_devices',
        'deviceCount': devices.length,
        'deviceTypes': devices.map((d) => d.deviceType.name).toSet().toList(),
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
      throw _handleError(e);
    }
  }

  /// Handle Dio errors with healthcare context
  Exception _handleError(DioException e) {
    final errorContext = {
      'errorType': e.type.name,
      'statusCode': e.response?.statusCode,
      'message': e.message,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _logger.error('Health data service error', errorContext);

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Health data service timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Authentication required for health data access.');
        } else if (statusCode == 403) {
          return Exception('Access denied to health data.');
        } else if (statusCode == 404) {
          return Exception('Health data not found.');
        }
        return Exception('Health data service error: ${e.response?.statusMessage}');
      case DioExceptionType.cancel:
        return Exception('Health data request was cancelled.');
      case DioExceptionType.unknown:
      default:
        return Exception('Network error accessing health data.');
    }
  }
}

/// Provider for health data service
final healthDataServiceProvider = Provider<HealthDataService>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  return HealthDataService(dio);
});
