import 'package:dio/dio.dart';
import '../../logging/app_logger.dart';
import '../network_exceptions.dart';

/// Error handling interceptor for standardized error responses
class ErrorInterceptor extends Interceptor {
  final AppLogger _logger;

  ErrorInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final networkException = _handleDioError(err);

    _logger.error(
      'Network error occurred',
      error: networkException,
      data: {
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
        'statusCode': err.response?.statusCode,
        'type': networkException.type.toString(),
      },
    );

    // Convert DioException to NetworkException for consistent error handling
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: networkException,
    ));
  }

  /// Handle different types of Dio errors
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Request timeout. Please check your internet connection and try again.',
          type: NetworkExceptionType.timeout,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return NetworkException(
          'Request was cancelled',
          type: NetworkExceptionType.cancel,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'Connection failed. Please check your internet connection.',
          type: NetworkExceptionType.noConnection,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Certificate verification failed. Please check your network security settings.',
          type: NetworkExceptionType.unknown,
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.unknown:
        return NetworkException(
          'An unexpected error occurred. Please try again.',
          type: NetworkExceptionType.unknown,
          statusCode: error.response?.statusCode,
        );
    }
  }

  /// Handle bad response errors based on status code
  NetworkException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'An error occurred';

    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['detail'] ?? message;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Bad request. Please check your input.',
          type: NetworkExceptionType.badRequest,
          statusCode: statusCode,
          data: data,
        );

      case 401:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Authentication failed. Please log in again.',
          type: NetworkExceptionType.unauthorized,
          statusCode: statusCode,
          data: data,
        );

      case 403:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Access denied. You don\'t have permission to perform this action.',
          type: NetworkExceptionType.forbidden,
          statusCode: statusCode,
          data: data,
        );

      case 404:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'The requested resource was not found.',
          type: NetworkExceptionType.notFound,
          statusCode: statusCode,
          data: data,
        );

      case 409:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Conflict occurred. The resource already exists.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );

      case 422:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Validation failed. Please check your input.',
          type: NetworkExceptionType.badRequest,
          statusCode: statusCode,
          data: data,
        );

      case 429:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Too many requests. Please try again later.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );

      case 500:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Internal server error. Please try again later.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );

      case 502:
        return NetworkException(
          message.isNotEmpty ? message : 'Bad gateway. Please try again later.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );

      case 503:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Service unavailable. Please try again later.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );

      case 504:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Gateway timeout. Please try again later.',
          type: NetworkExceptionType.timeout,
          statusCode: statusCode,
          data: data,
        );

      default:
        return NetworkException(
          message.isNotEmpty
              ? message
              : 'Server error occurred. Please try again later.',
          type: NetworkExceptionType.server,
          statusCode: statusCode,
          data: data,
        );
    }
  }
}
