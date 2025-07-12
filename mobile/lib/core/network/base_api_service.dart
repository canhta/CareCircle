// Base API service with standardized patterns and error handling
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/app_config.dart';
import '../logging/bounded_context_loggers.dart';
import '../compliance/healthcare_compliance_service.dart';

/// Base API service providing standardized patterns for all API services
///
/// Features:
/// - Consistent error handling
/// - Healthcare-compliant logging
/// - Performance monitoring
/// - Automatic retry logic
/// - Request/response sanitization
abstract class BaseApiService {
  late final Dio _dio;
  late final Talker _logger;
  late final HealthcareComplianceService _complianceService;

  /// Service name for logging context
  String get serviceName;

  /// Base URL for the service (defaults to main API)
  String get baseUrl => AppConfig.apiBaseUrl;

  BaseApiService({Dio? dio, Talker? logger}) {
    _dio = dio ?? _createDefaultDio();
    _logger = logger ?? BoundedContextLoggers.network;
    _complianceService = HealthcareComplianceService();
  }

  /// Create default Dio instance with standard configuration
  Dio _createDefaultDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  /// Make a GET request with standardized error handling
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
    String? operationName,
  }) async {
    return _makeRequest<T>(
      () => _dio.get(path, queryParameters: queryParameters, options: options),
      fromJson: fromJson,
      operationName: operationName ?? 'GET $path',
    );
  }

  /// Make a POST request with standardized error handling
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
    String? operationName,
  }) async {
    return _makeRequest<T>(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
      operationName: operationName ?? 'POST $path',
    );
  }

  /// Make a PUT request with standardized error handling
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
    String? operationName,
  }) async {
    return _makeRequest<T>(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
      operationName: operationName ?? 'PUT $path',
    );
  }

  /// Make a DELETE request with standardized error handling
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) fromJson,
    String? operationName,
  }) async {
    return _makeRequest<T>(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      fromJson: fromJson,
      operationName: operationName ?? 'DELETE $path',
    );
  }

  /// Make a request without expecting a response body (for void operations)
  Future<void> makeVoidRequest(
    Future<Response> Function() requestFunction, {
    String? operationName,
  }) async {
    await _makeRequest<void>(
      requestFunction,
      fromJson: (_) {},
      operationName: operationName ?? 'void request',
    );
  }

  /// Core request method with error handling and logging
  Future<T> _makeRequest<T>(
    Future<Response> Function() requestFunction, {
    required T Function(dynamic) fromJson,
    required String operationName,
    int maxRetries = 3,
  }) async {
    final startTime = DateTime.now();

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        _logger.info('API request started', {
          'service': serviceName,
          'operation': operationName,
          'attempt': attempt,
          'timestamp': startTime.toIso8601String(),
        });

        final response = await requestFunction();
        final duration = DateTime.now().difference(startTime);

        // Log successful request
        _logger.info('API request successful', {
          'service': serviceName,
          'operation': operationName,
          'statusCode': response.statusCode,
          'durationMs': duration.inMilliseconds,
          'attempt': attempt,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Parse response
        if (response.data == null) {
          return fromJson(null);
        } else {
          return fromJson(response.data);
        }
      } on DioException catch (e) {
        final duration = DateTime.now().difference(startTime);
        final isLastAttempt = attempt == maxRetries;

        // Log error with healthcare-compliant sanitization
        final sanitizedError = _complianceService
            .createCompliantLogMessage('API request failed', {
              'service': serviceName,
              'operation': operationName,
              'attempt': attempt,
              'maxRetries': maxRetries,
              'errorType': e.type.name,
              'statusCode': e.response?.statusCode,
              'durationMs': duration.inMilliseconds,
              'isLastAttempt': isLastAttempt,
              'timestamp': DateTime.now().toIso8601String(),
            });

        if (isLastAttempt) {
          _logger.error(sanitizedError);
        } else {
          _logger.warning(sanitizedError);
        }

        // Handle specific error types
        if (_shouldRetry(e) && !isLastAttempt) {
          final retryDelay = _calculateRetryDelay(attempt);
          _logger.info('Retrying request', {
            'service': serviceName,
            'operation': operationName,
            'attempt': attempt + 1,
            'retryDelayMs': retryDelay.inMilliseconds,
            'timestamp': DateTime.now().toIso8601String(),
          });

          await Future.delayed(retryDelay);
          continue;
        }

        // Transform DioException to standardized API exception
        throw _transformDioException(e, operationName);
      } catch (e) {
        final duration = DateTime.now().difference(startTime);

        _logger.error('Unexpected API error', {
          'service': serviceName,
          'operation': operationName,
          'attempt': attempt,
          'errorType': e.runtimeType.toString(),
          'durationMs': duration.inMilliseconds,
          'timestamp': DateTime.now().toIso8601String(),
        });

        throw ApiException(
          message: 'Unexpected error occurred',
          statusCode: 0,
          operation: operationName,
          originalError: e,
        );
      }
    }

    // This should never be reached due to the loop structure
    throw ApiException(
      message: 'Maximum retry attempts exceeded',
      statusCode: 0,
      operation: operationName,
    );
  }

  /// Determine if an error should trigger a retry
  bool _shouldRetry(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // Retry on server errors (5xx) but not client errors (4xx)
        final statusCode = e.response?.statusCode ?? 0;
        return statusCode >= 500 && statusCode < 600;
      default:
        return false;
    }
  }

  /// Calculate retry delay with exponential backoff
  Duration _calculateRetryDelay(int attempt) {
    final baseDelay = Duration(milliseconds: 1000); // 1 second
    final multiplier = 1 << (attempt - 1); // 2^(attempt-1) using bit shift
    final exponentialDelay = Duration(
      milliseconds: baseDelay.inMilliseconds * multiplier,
    );

    // Cap at 30 seconds
    return exponentialDelay.inMilliseconds > 30000
        ? Duration(seconds: 30)
        : exponentialDelay;
  }

  /// Transform DioException to standardized ApiException
  ApiException _transformDioException(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Request timeout - please check your connection',
          statusCode: 0,
          operation: operation,
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error - please check your internet connection',
          statusCode: 0,
          operation: operation,
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _getErrorMessageForStatusCode(statusCode);
        return ApiException(
          message: message,
          statusCode: statusCode,
          operation: operation,
          originalError: e,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred',
          statusCode: 0,
          operation: operation,
          originalError: e,
        );
    }
  }

  /// Get user-friendly error message for HTTP status codes
  String _getErrorMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request - please check your input';
      case 401:
        return 'Authentication required - please sign in again';
      case 403:
        return 'Access denied - you don\'t have permission for this action';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Conflict - the resource already exists or has been modified';
      case 422:
        return 'Invalid data - please check your input';
      case 429:
        return 'Too many requests - please try again later';
      case 500:
        return 'Server error - please try again later';
      case 502:
      case 503:
      case 504:
        return 'Service temporarily unavailable - please try again later';
      default:
        return 'An error occurred (HTTP $statusCode)';
    }
  }
}

/// Standardized API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String operation;
  final dynamic originalError;

  const ApiException({
    required this.message,
    required this.statusCode,
    required this.operation,
    this.originalError,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Operation: $operation)';
  }
}
