import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'bounded_context_loggers.dart';
import 'healthcare_log_sanitizer.dart';

/// Healthcare-compliant error tracking system with Firebase Crashlytics integration
///
/// This class provides comprehensive error tracking for the CareCircle mobile
/// application while maintaining HIPAA compliance and healthcare data privacy.
class ErrorTracker {
  static final _logger = BoundedContextLoggers.security;
  static bool _initialized = false;
  static FirebaseCrashlytics? _crashlytics;

  /// Initialize error tracking system
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      _crashlytics = FirebaseCrashlytics.instance;

      // Enable crashlytics collection in release mode
      await _crashlytics!.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Set up Flutter error handling
      FlutterError.onError = (FlutterErrorDetails details) {
        _handleFlutterError(details);
      };

      // Set up platform error handling
      PlatformDispatcher.instance.onError = (error, stack) {
        _handlePlatformError(error, stack);
        return true;
      };

      _initialized = true;

      _logger.info('Error tracking system initialized', {
        'crashlyticsEnabled': !kDebugMode,
        'flutterErrorHandlerSet': true,
        'platformErrorHandlerSet': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize error tracking', {
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Record a non-fatal error with healthcare compliance
  static Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
    bool isFatal = false,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Sanitize context data for healthcare compliance
    final sanitizedContext = context != null
        ? HealthcareLogSanitizer.sanitizeData(context)
        : <String, dynamic>{};

    // Add healthcare-specific metadata
    sanitizedContext.addAll({
      'timestamp': DateTime.now().toIso8601String(),
      'isFatal': isFatal,
      'reason': reason ?? 'Unknown error',
      'errorType': error.runtimeType.toString(),
    });

    // Log to our healthcare logger
    _logger.error('Error recorded', {
      'error': error.toString(),
      'reason': reason,
      'isFatal': isFatal,
      'context': sanitizedContext,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      // Set custom keys for Crashlytics
      await _setCustomKeys(sanitizedContext);

      // Record to Firebase Crashlytics
      if (_crashlytics != null) {
        await _crashlytics!.recordError(
          error,
          stackTrace,
          reason: reason,
          information: sanitizedContext.entries
              .map((e) => DiagnosticsProperty(e.key, e.value))
              .toList(),
          fatal: isFatal,
        );
      }
    } catch (e) {
      _logger.error('Failed to record error to Crashlytics', {
        'originalError': error.toString(),
        'crashlyticsError': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Record authentication error
  static Future<void> recordAuthError(
    dynamic error,
    StackTrace? stackTrace, {
    String? authMethod,
    String? userId,
    Map<String, dynamic>? context,
  }) async {
    final authContext = {
      'category': 'authentication',
      'authMethod': authMethod ?? 'unknown',
      'hasUserId': userId != null,
      ...?context,
    };

    await recordError(
      error,
      stackTrace,
      reason: 'Authentication error',
      context: authContext,
    );

    // Log specific auth error
    BoundedContextLoggers.auth.error('Authentication error recorded', {
      'authMethod': authMethod,
      'error': error.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Record health data error
  static Future<void> recordHealthDataError(
    dynamic error,
    StackTrace? stackTrace, {
    String? operation,
    String? dataType,
    Map<String, dynamic>? context,
  }) async {
    final healthContext = {
      'category': 'health_data',
      'operation': operation ?? 'unknown',
      'dataType': dataType ?? 'unknown',
      ...?context,
    };

    await recordError(
      error,
      stackTrace,
      reason: 'Health data error',
      context: healthContext,
    );

    // Log specific health data error
    BoundedContextLoggers.healthData.error('Health data error recorded', {
      'operation': operation,
      'dataType': dataType,
      'error': error.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Record AI assistant error
  static Future<void> recordAIAssistantError(
    dynamic error,
    StackTrace? stackTrace, {
    String? conversationId,
    String? operation,
    Map<String, dynamic>? context,
  }) async {
    final aiContext = {
      'category': 'ai_assistant',
      'operation': operation ?? 'unknown',
      'hasConversationId': conversationId != null,
      ...?context,
    };

    await recordError(
      error,
      stackTrace,
      reason: 'AI Assistant error',
      context: aiContext,
    );

    // Log specific AI error
    BoundedContextLoggers.aiAssistant.error('AI Assistant error recorded', {
      'operation': operation,
      'error': error.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Record navigation error
  static Future<void> recordNavigationError(
    dynamic error,
    StackTrace? stackTrace, {
    String? route,
    String? operation,
    Map<String, dynamic>? context,
  }) async {
    final navContext = {
      'category': 'navigation',
      'route': route ?? 'unknown',
      'operation': operation ?? 'unknown',
      ...?context,
    };

    await recordError(
      error,
      stackTrace,
      reason: 'Navigation error',
      context: navContext,
    );

    // Log specific navigation error
    BoundedContextLoggers.navigation.error('Navigation error recorded', {
      'route': route,
      'operation': operation,
      'error': error.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Set user identifier for error tracking
  static Future<void> setUserIdentifier(String userId) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      await _crashlytics?.setUserIdentifier(userId);

      _logger.info('User identifier set for error tracking', {
        'hasUserId': userId.isNotEmpty,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to set user identifier', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Clear user identifier (on logout)
  static Future<void> clearUserIdentifier() async {
    if (!_initialized) return;

    try {
      await _crashlytics?.setUserIdentifier('');

      _logger.info('User identifier cleared from error tracking', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to clear user identifier', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Log custom event for error analysis
  static Future<void> logCustomEvent(
    String eventName,
    Map<String, dynamic> parameters,
  ) async {
    if (!_initialized) {
      await initialize();
    }

    // Sanitize parameters for healthcare compliance
    final sanitizedParams = HealthcareLogSanitizer.sanitizeData(parameters);

    try {
      await _crashlytics?.log('$eventName: ${sanitizedParams.toString()}');

      _logger.info('Custom event logged', {
        'eventName': eventName,
        'parameters': sanitizedParams,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to log custom event', {
        'eventName': eventName,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log to our system first
    _logger.error('Flutter error occurred', {
      'error': details.exception.toString(),
      'library': details.library ?? 'unknown',
      'context': details.context?.toString() ?? 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Record to Crashlytics
    recordError(
      details.exception,
      details.stack,
      reason: 'Flutter framework error',
      context: {
        'library': details.library ?? 'unknown',
        'context': details.context?.toString() ?? 'unknown',
        'silent': details.silent,
      },
    );

    // Also report to Flutter's default error handler in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle platform-specific errors
  static bool _handlePlatformError(Object error, StackTrace stack) {
    // Log to our system
    _logger.error('Platform error occurred', {
      'error': error.toString(),
      'errorType': error.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Record to Crashlytics
    recordError(
      error,
      stack,
      reason: 'Platform error',
      context: {'errorType': error.runtimeType.toString(), 'platform': 'dart'},
    );

    return true;
  }

  /// Set custom keys for Crashlytics
  static Future<void> _setCustomKeys(Map<String, dynamic> context) async {
    if (_crashlytics == null) return;

    try {
      for (final entry in context.entries) {
        final value = entry.value;
        if (value is String) {
          await _crashlytics!.setCustomKey(entry.key, value);
        } else if (value is int) {
          await _crashlytics!.setCustomKey(entry.key, value);
        } else if (value is double) {
          await _crashlytics!.setCustomKey(entry.key, value);
        } else if (value is bool) {
          await _crashlytics!.setCustomKey(entry.key, value);
        } else {
          await _crashlytics!.setCustomKey(entry.key, value.toString());
        }
      }
    } catch (e) {
      _logger.error('Failed to set custom keys', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Test crash reporting (debug only)
  static Future<void> testCrash() async {
    if (!kDebugMode) return;

    _logger.warning('Test crash initiated (debug mode only)', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    await recordError(
      Exception('Test crash for error tracking verification'),
      StackTrace.current,
      reason: 'Test crash',
      context: {'test': true, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  /// Get error tracking status
  static Map<String, dynamic> getStatus() {
    return {
      'initialized': _initialized,
      'crashlyticsEnabled': _crashlytics != null && !kDebugMode,
      'flutterErrorHandlerActive': FlutterError.onError != null,
      'platformErrorHandlerActive': PlatformDispatcher.instance.onError != null,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
