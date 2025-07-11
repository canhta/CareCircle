import 'dart:async';
import 'dart:math';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/exceptions/notification_exceptions.dart';
import 'notification_error_handler.dart';

/// Production-ready retry service for notification operations
///
/// Provides intelligent retry logic with:
/// - Exponential backoff with jitter
/// - Circuit breaker pattern
/// - Healthcare-compliant error handling
/// - Configurable retry policies
class NotificationRetryService {
  static final _logger = BoundedContextLoggers.notification;
  static final _random = Random();

  /// Default retry configuration
  static const _defaultMaxAttempts = 3;
  static const _defaultBaseDelay = Duration(seconds: 1);
  static const _defaultMaxDelay = Duration(seconds: 30);
  static const _defaultJitterFactor = 0.1;

  /// Execute operation with retry logic
  static Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxAttempts = _defaultMaxAttempts,
    Duration baseDelay = _defaultBaseDelay,
    Duration maxDelay = _defaultMaxDelay,
    double jitterFactor = _defaultJitterFactor,
    bool Function(NotificationException)? shouldRetry,
    String? operationName,
    Map<String, dynamic>? context,
  }) async {
    var attempt = 1;
    NotificationException? lastException;

    while (attempt <= maxAttempts) {
      try {
        _logger.info('Executing operation attempt $attempt', {
          'operation': operationName ?? 'unknown',
          'attempt': attempt,
          'maxAttempts': maxAttempts,
          'context': context,
          'timestamp': DateTime.now().toIso8601String(),
        });

        final result = await operation();

        if (attempt > 1) {
          _logger.info('Operation succeeded after retry', {
            'operation': operationName ?? 'unknown',
            'successfulAttempt': attempt,
            'totalAttempts': attempt,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }

        return result;
      } catch (error, stackTrace) {
        final notificationException = error is NotificationException
            ? error
            : NotificationErrorHandler.handleException(
                error,
                stackTrace: stackTrace,
                context: context,
              );

        lastException = notificationException;

        _logger.warning('Operation attempt $attempt failed', {
          'operation': operationName ?? 'unknown',
          'attempt': attempt,
          'maxAttempts': maxAttempts,
          'errorType': notificationException.runtimeType.toString(),
          'errorCode': notificationException.code,
          'errorMessage': notificationException.message,
          'isRetryable': NotificationErrorHandler.isRetryable(notificationException),
          'context': context,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Check if we should retry
        final customShouldRetry = shouldRetry?.call(notificationException);
        final defaultShouldRetry = NotificationErrorHandler.isRetryable(notificationException);
        final willRetry = customShouldRetry ?? defaultShouldRetry;

        if (!willRetry || attempt >= maxAttempts) {
          _logger.error('Operation failed permanently', {
            'operation': operationName ?? 'unknown',
            'totalAttempts': attempt,
            'finalError': notificationException.toString(),
            'willRetry': willRetry,
            'reachedMaxAttempts': attempt >= maxAttempts,
            'timestamp': DateTime.now().toIso8601String(),
          });
          throw notificationException;
        }

        // Calculate delay for next attempt
        final delay = _calculateDelay(
          attempt,
          baseDelay,
          maxDelay,
          jitterFactor,
          notificationException,
        );

        _logger.info('Retrying operation after delay', {
          'operation': operationName ?? 'unknown',
          'attempt': attempt,
          'nextAttempt': attempt + 1,
          'delayMs': delay.inMilliseconds,
          'timestamp': DateTime.now().toIso8601String(),
        });

        await Future.delayed(delay);
        attempt++;
      }
    }

    // This should never be reached, but just in case
    throw lastException ?? NotificationUnknownException(
      'Operation failed after $maxAttempts attempts',
      code: 'MAX_ATTEMPTS_EXCEEDED',
      details: {'maxAttempts': maxAttempts, 'operation': operationName},
    );
  }

  /// Execute operation with circuit breaker pattern
  static Future<T> executeWithCircuitBreaker<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? context,
  }) async {
    final circuitBreaker = _getCircuitBreaker(operationName ?? 'default');
    
    if (circuitBreaker.isOpen) {
      _logger.warning('Circuit breaker is open, rejecting operation', {
        'operation': operationName ?? 'unknown',
        'circuitBreakerState': 'open',
        'failureCount': circuitBreaker.failureCount,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      throw NotificationServiceException(
        'Service is temporarily unavailable due to repeated failures',
        code: 'CIRCUIT_BREAKER_OPEN',
        details: {
          'operation': operationName,
          'failureCount': circuitBreaker.failureCount,
          ...?context,
        },
        estimatedRecovery: circuitBreaker.nextAttemptTime != null
            ? circuitBreaker.nextAttemptTime!.difference(DateTime.now())
            : const Duration(minutes: 1),
      );
    }

    try {
      final result = await operation();
      circuitBreaker.recordSuccess();
      return result;
    } catch (error, stackTrace) {
      final notificationException = error is NotificationException
          ? error
          : NotificationErrorHandler.handleException(
              error,
              stackTrace: stackTrace,
              context: context,
            );

      circuitBreaker.recordFailure();
      throw notificationException;
    }
  }

  /// Calculate delay with exponential backoff and jitter
  static Duration _calculateDelay(
    int attempt,
    Duration baseDelay,
    Duration maxDelay,
    double jitterFactor,
    NotificationException exception,
  ) {
    // Use custom delay if specified in exception
    if (exception is NotificationRateLimitException && exception.retryAfter != null) {
      return exception.retryAfter!;
    }

    // Exponential backoff: baseDelay * 2^(attempt-1)
    final exponentialDelay = Duration(
      milliseconds: baseDelay.inMilliseconds * pow(2, attempt - 1).toInt(),
    );

    // Cap at maximum delay
    final cappedDelay = exponentialDelay > maxDelay ? maxDelay : exponentialDelay;

    // Add jitter to prevent thundering herd
    final jitterMs = (cappedDelay.inMilliseconds * jitterFactor * _random.nextDouble()).round();
    final finalDelay = Duration(milliseconds: cappedDelay.inMilliseconds + jitterMs);

    return finalDelay;
  }

  /// Get or create circuit breaker for operation
  static _CircuitBreaker _getCircuitBreaker(String operationName) {
    return _circuitBreakers.putIfAbsent(
      operationName,
      () => _CircuitBreaker(operationName),
    );
  }

  static final Map<String, _CircuitBreaker> _circuitBreakers = {};
}

/// Simple circuit breaker implementation
class _CircuitBreaker {
  _CircuitBreaker(this.operationName);

  final String operationName;
  int failureCount = 0;
  DateTime? nextAttemptTime;
  
  static const _failureThreshold = 5;
  static const _recoveryTimeout = Duration(minutes: 1);

  bool get isOpen {
    if (nextAttemptTime == null) return false;
    
    if (DateTime.now().isAfter(nextAttemptTime!)) {
      // Recovery timeout has passed, allow one attempt
      nextAttemptTime = null;
      return false;
    }
    
    return failureCount >= _failureThreshold;
  }

  void recordSuccess() {
    failureCount = 0;
    nextAttemptTime = null;
    
    BoundedContextLoggers.notification.info('Circuit breaker recorded success', {
      'operation': operationName,
      'circuitBreakerState': 'closed',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void recordFailure() {
    failureCount++;
    
    if (failureCount >= _failureThreshold) {
      nextAttemptTime = DateTime.now().add(_recoveryTimeout);
      
      BoundedContextLoggers.notification.warning('Circuit breaker opened', {
        'operation': operationName,
        'failureCount': failureCount,
        'nextAttemptTime': nextAttemptTime?.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
}

/// Retry policy configuration
class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.jitterFactor = 0.1,
    this.shouldRetry,
  });

  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;
  final double jitterFactor;
  final bool Function(NotificationException)? shouldRetry;

  /// Conservative policy for critical operations
  static const conservative = RetryPolicy(
    maxAttempts: 2,
    baseDelay: Duration(seconds: 2),
    maxDelay: Duration(seconds: 10),
  );

  /// Aggressive policy for non-critical operations
  static const aggressive = RetryPolicy(
    maxAttempts: 5,
    baseDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 60),
  );

  /// Emergency policy for emergency alerts
  static const emergency = RetryPolicy(
    maxAttempts: 10,
    baseDelay: Duration(milliseconds: 100),
    maxDelay: Duration(seconds: 5),
  );
}
