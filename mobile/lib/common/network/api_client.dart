import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../logging/app_logger.dart';
import '../storage/secure_storage_service.dart';
import '../constants/api_endpoints.dart';
import 'network_exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Centralized API client following Flutter best practices
/// Singleton pattern with dependency injection support
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  late final SecureStorageService _secureStorage;
  late final AppLogger _logger;
  late final Connectivity _connectivity;

  ApiClient._internal();

  /// Factory constructor for singleton pattern
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Initialize the API client with dependencies
  Future<void> initialize({
    required SecureStorageService secureStorage,
    required AppLogger logger,
    String? baseUrl,
    int? timeout,
  }) async {
    _secureStorage = secureStorage;
    _logger = logger;
    _connectivity = Connectivity();

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: Duration(milliseconds: timeout ?? 30000),
        receiveTimeout: Duration(milliseconds: timeout ?? 30000),
        sendTimeout: Duration(milliseconds: timeout ?? 30000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order of execution
    _dio.interceptors.addAll([
      AuthInterceptor(secureStorage: _secureStorage),
      LoggingInterceptor(logger: _logger),
      ErrorInterceptor(logger: _logger),
    ]);

    _logger.info('ApiClient initialized successfully');
  }

  /// Check network connectivity
  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Generic GET request
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PATCH request
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file with progress tracking
  Future<Response<T>> uploadFile<T>(
    String endpoint,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.post<T>(
        endpoint,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Download file with progress tracking
  Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _ensureConnectivity();

      final response = await _dio.download(
        endpoint,
        savePath,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Ensure network connectivity
  Future<void> _ensureConnectivity() async {
    if (!await _isConnected()) {
      throw NetworkException(
        'No internet connection available',
        type: NetworkExceptionType.noConnection,
      );
    }
  }

  /// Handle and transform errors
  NetworkException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(
            'Request timeout',
            type: NetworkExceptionType.timeout,
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.badResponse:
          return NetworkException(
            error.response?.data?['message'] ?? 'Server error',
            type: NetworkExceptionType.server,
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.cancel:
          return NetworkException(
            'Request cancelled',
            type: NetworkExceptionType.cancel,
          );
        case DioExceptionType.unknown:
          return NetworkException(
            'Network error occurred',
            type: NetworkExceptionType.unknown,
          );
        default:
          return NetworkException(
            'Unknown error occurred',
            type: NetworkExceptionType.unknown,
          );
      }
    }

    return NetworkException(
      error.toString(),
      type: NetworkExceptionType.unknown,
    );
  }

  /// Clear cached data and reset client
  void clearCache() {
    _dio.interceptors.clear();
    _logger.info('ApiClient cache cleared');
  }

  /// Dispose resources
  void dispose() {
    _dio.close();
    _logger.info('ApiClient disposed');
  }
}
