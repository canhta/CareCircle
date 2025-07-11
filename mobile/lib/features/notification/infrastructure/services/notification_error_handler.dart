import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/exceptions/notification_exceptions.dart';

/// Comprehensive error handler for notification module
///
/// Provides production-ready error handling with:
/// - Healthcare compliance logging
/// - Retry logic and fallback mechanisms
/// - User-friendly error messages
/// - Error categorization and reporting
class NotificationErrorHandler {
  static final _logger = BoundedContextLoggers.notification;

  /// Convert various exceptions to notification-specific exceptions
  static NotificationException handleException(
    Object error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _logger.error('Handling notification error', {
      'errorType': error.runtimeType.toString(),
      'error': error.toString(),
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
    });

    switch (error) {
      case DioException():
        return _handleDioException(error, context);
      case SocketException():
        return _handleSocketException(error, context);
      case FormatException():
        return _handleFormatException(error, context);
      case NotificationException():
        return error;
      default:
        return NotificationUnknownException(
          'An unexpected error occurred: ${error.toString()}',
          code: 'UNKNOWN_ERROR',
          details: context,
          originalException: error,
          stackTrace: stackTrace,
        );
    }
  }

  /// Handle Dio HTTP exceptions
  static NotificationException _handleDioException(
    DioException error,
    Map<String, dynamic>? context,
  ) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NotificationNetworkException(
          'Network timeout occurred. Please check your connection and try again.',
          code: 'NETWORK_TIMEOUT',
          statusCode: statusCode,
          details: {'type': error.type.name, ...?context},
          isRetryable: true,
        );

      case DioExceptionType.connectionError:
        return NotificationNetworkException(
          'Unable to connect to notification service. Please check your internet connection.',
          code: 'CONNECTION_ERROR',
          statusCode: statusCode,
          details: {'type': error.type.name, ...?context},
          isRetryable: true,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(statusCode, responseData, context);

      case DioExceptionType.cancel:
        return NotificationNetworkException(
          'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
          statusCode: statusCode,
          details: {'type': error.type.name, ...?context},
          isRetryable: false,
        );

      default:
        return NotificationNetworkException(
          'Network error occurred: ${error.message}',
          code: 'NETWORK_ERROR',
          statusCode: statusCode,
          details: {'type': error.type.name, ...?context},
          isRetryable: true,
        );
    }
  }

  /// Handle HTTP response errors
  static NotificationException _handleBadResponse(
    int? statusCode,
    dynamic responseData,
    Map<String, dynamic>? context,
  ) {
    switch (statusCode) {
      case 400:
        return NotificationValidationException(
          'Invalid request data. Please check your input and try again.',
          code: 'BAD_REQUEST',
          details: {'statusCode': statusCode, 'response': responseData, ...?context},
        );

      case 401:
        return NotificationAuthException(
          'Authentication required. Please sign in again.',
          code: 'UNAUTHORIZED',
          details: {'statusCode': statusCode, 'response': responseData, ...?context},
          requiresReauth: true,
        );

      case 403:
        return NotificationAuthException(
          'Access denied. You do not have permission to perform this action.',
          code: 'FORBIDDEN',
          details: {'statusCode': statusCode, 'response': responseData, ...?context},
        );

      case 404:
        return NotificationNetworkException(
          'The requested resource was not found.',
          code: 'NOT_FOUND',
          statusCode: statusCode,
          details: {'response': responseData, ...?context},
          isRetryable: false,
        );

      case 429:
        final retryAfter = _extractRetryAfter(responseData);
        return NotificationRateLimitException(
          'Too many requests. Please wait before trying again.',
          code: 'RATE_LIMITED',
          details: {'statusCode': statusCode, 'response': responseData, ...?context},
          retryAfter: retryAfter,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return NotificationServiceException(
          'Service temporarily unavailable. Please try again later.',
          code: 'SERVICE_ERROR',
          details: {'statusCode': statusCode, 'response': responseData, ...?context},
          serviceName: 'notification-api',
          estimatedRecovery: const Duration(minutes: 5),
        );

      default:
        return NotificationNetworkException(
          'Server error occurred (${statusCode ?? 'unknown'}). Please try again.',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
          details: {'response': responseData, ...?context},
          isRetryable: statusCode != null && statusCode >= 500,
        );
    }
  }

  /// Handle socket exceptions
  static NotificationException _handleSocketException(
    SocketException error,
    Map<String, dynamic>? context,
  ) {
    return NotificationNetworkException(
      'No internet connection available. Please check your network settings.',
      code: 'NO_INTERNET',
      details: {'message': error.message, ...?context},
      isRetryable: true,
    );
  }



  /// Handle format exceptions
  static NotificationException _handleFormatException(
    FormatException error,
    Map<String, dynamic>? context,
  ) {
    return NotificationValidationException(
      'Invalid data format received. Please try again.',
      code: 'FORMAT_ERROR',
      details: {'message': error.message, 'source': error.source, ...?context},
    );
  }

  /// Extract retry-after duration from response
  static Duration? _extractRetryAfter(dynamic responseData) {
    try {
      if (responseData is Map<String, dynamic>) {
        final retryAfterSeconds = responseData['retryAfter'] as int?;
        if (retryAfterSeconds != null) {
          return Duration(seconds: retryAfterSeconds);
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }
    return null;
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(NotificationException error) {
    switch (error) {
      case NotificationNetworkException _:
        final networkError = error as NotificationNetworkException;
        if (!networkError.isRetryable) {
          return 'This action cannot be completed right now. Please contact support if the problem persists.';
        }
        return 'Connection problem. Please check your internet and try again.';

      case NotificationAuthException _:
        return 'Please sign in again to continue.';

      case NotificationValidationException _:
        return 'Please check your input and try again.';

      case NotificationPermissionException _:
        return 'Please enable notifications in your device settings to use this feature.';

      case NotificationRateLimitException _:
        return 'You\'re doing that too often. Please wait a moment and try again.';

      case NotificationServiceException _:
        return 'Service is temporarily unavailable. Please try again in a few minutes.';

      case EmergencyAlertException _:
        return 'Unable to process emergency alert. Please contact support immediately.';

      default:
        return 'Something went wrong. Please try again or contact support if the problem persists.';
    }
  }

  /// Check if error is retryable
  static bool isRetryable(NotificationException error) {
    switch (error) {
      case NotificationNetworkException _:
        return (error as NotificationNetworkException).isRetryable;
      case NotificationServiceException _:
      case NotificationRateLimitException _:
        return true;
      case NotificationAuthException _:
      case NotificationValidationException _:
      case NotificationPermissionException _:
      case NotificationComplianceException _:
        return false;
      default:
        return false;
    }
  }

  /// Get recommended retry delay
  static Duration getRetryDelay(NotificationException error, int attemptCount) {
    if (error is NotificationRateLimitException && error.retryAfter != null) {
      return error.retryAfter!;
    }

    // Exponential backoff with jitter
    final baseDelay = Duration(seconds: 2 * (1 << (attemptCount - 1)));
    final jitter = Duration(milliseconds: (baseDelay.inMilliseconds * 0.1).round());
    return baseDelay + jitter;
  }
}
