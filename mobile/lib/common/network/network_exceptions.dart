/// Network exception types
enum NetworkExceptionType {
  /// No internet connection
  noConnection,

  /// Request timeout
  timeout,

  /// Server error (4xx, 5xx)
  server,

  /// Request cancelled
  cancel,

  /// Authentication error
  unauthorized,

  /// Bad request
  badRequest,

  /// Not found
  notFound,

  /// Forbidden
  forbidden,

  /// Unknown error
  unknown,
}

/// Custom network exception class for better error handling
class NetworkException implements Exception {
  final String message;
  final NetworkExceptionType type;
  final int? statusCode;
  final dynamic data;

  const NetworkException(
    this.message, {
    required this.type,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    return 'NetworkException: $message (Type: $type, Status: $statusCode)';
  }

  /// Create exception from status code
  factory NetworkException.fromStatusCode(int statusCode, String message) {
    NetworkExceptionType type;

    switch (statusCode) {
      case 400:
        type = NetworkExceptionType.badRequest;
        break;
      case 401:
        type = NetworkExceptionType.unauthorized;
        break;
      case 403:
        type = NetworkExceptionType.forbidden;
        break;
      case 404:
        type = NetworkExceptionType.notFound;
        break;
      case >= 500:
        type = NetworkExceptionType.server;
        break;
      default:
        type = NetworkExceptionType.unknown;
    }

    return NetworkException(
      message,
      type: type,
      statusCode: statusCode,
    );
  }

  /// Check if exception is due to no internet connection
  bool get isNoConnection => type == NetworkExceptionType.noConnection;

  /// Check if exception is due to server error
  bool get isServerError => type == NetworkExceptionType.server;

  /// Check if exception is due to authentication issues
  bool get isUnauthorized => type == NetworkExceptionType.unauthorized;

  /// Check if exception is due to timeout
  bool get isTimeout => type == NetworkExceptionType.timeout;

  /// Check if exception is due to bad request
  bool get isBadRequest => type == NetworkExceptionType.badRequest;

  /// Check if exception is due to not found
  bool get isNotFound => type == NetworkExceptionType.notFound;

  /// Check if exception is due to forbidden access
  bool get isForbidden => type == NetworkExceptionType.forbidden;

  /// Get user-friendly error message
  String get userFriendlyMessage {
    switch (type) {
      case NetworkExceptionType.noConnection:
        return 'No internet connection. Please check your network and try again.';
      case NetworkExceptionType.timeout:
        return 'Request timed out. Please try again.';
      case NetworkExceptionType.server:
        return 'Server error occurred. Please try again later.';
      case NetworkExceptionType.unauthorized:
        return 'Authentication failed. Please log in again.';
      case NetworkExceptionType.badRequest:
        return 'Invalid request. Please check your input.';
      case NetworkExceptionType.notFound:
        return 'The requested resource was not found.';
      case NetworkExceptionType.forbidden:
        return 'Access denied. You don\'t have permission to perform this action.';
      case NetworkExceptionType.cancel:
        return 'Request was cancelled.';
      case NetworkExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
