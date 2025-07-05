import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../common/common.dart';
import '../utils/analytics_service.dart';

/// Service for centralized error tracking and reporting
class ErrorTrackingService {
  late final FirebaseCrashlytics _crashlytics;
  late final AnalyticsService _analytics;
  late final AppLogger _logger;

  ErrorTrackingService({
    required AnalyticsService analytics,
    required AppLogger logger,
  }) {
    _crashlytics = FirebaseCrashlytics.instance;
    _analytics = analytics;
    _logger = logger;
  }

  /// Initialize error tracking service
  Future<void> initialize() async {
    try {
      _logger.info('Initializing ErrorTrackingService...');
      
      // Enable Crashlytics collection
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      
      _logger.info('ErrorTrackingService initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize ErrorTrackingService', error: e);
      rethrow;
    }
  }

  /// Record a non-fatal error
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
    String? userId,
    String? userEmail,
  }) async {
    try {
      _logger.error('Recording non-fatal error: $reason', error: error);

      // Set user context if provided
      if (userId != null) {
        await _crashlytics.setUserIdentifier(userId);
      }

      // Set custom keys for additional context
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Add app-specific context
      await _setAppContext();

      // Record the error
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );

      // Track in analytics for monitoring
      await _analytics.trackError(
        'non_fatal_error',
        reason ?? error.toString(),
        additionalProperties: {
          'error_type': error.runtimeType.toString(),
          'has_stack_trace': stackTrace != null,
          if (context != null) ...context,
        },
      );
    } catch (e) {
      _logger.error('Failed to record error', error: e);
    }
  }

  /// Record a fatal error
  Future<void> recordFatalError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
  }) async {
    try {
      _logger.error('Recording fatal error: $reason', error: error);

      // Set custom keys for additional context
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Add app-specific context
      await _setAppContext();

      // Record the fatal error
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: true,
      );
    } catch (e) {
      _logger.error('Failed to record fatal error', error: e);
    }
  }

  /// Record a Flutter error
  Future<void> recordFlutterError(FlutterErrorDetails errorDetails) async {
    try {
      _logger.error('Recording Flutter error', error: errorDetails.exception);

      // Add Flutter-specific context
      await _crashlytics.setCustomKey('flutter_error_library', errorDetails.library ?? 'unknown');
      await _crashlytics.setCustomKey('flutter_error_context', errorDetails.context?.toString() ?? 'unknown');

      // Add app-specific context
      await _setAppContext();

      // Record the Flutter error
      await _crashlytics.recordFlutterError(errorDetails);

      // Track in analytics
      await _analytics.trackError(
        'flutter_error',
        errorDetails.exception.toString(),
        additionalProperties: {
          'library': errorDetails.library ?? 'unknown',
          'context': errorDetails.context?.toString() ?? 'unknown',
        },
      );
    } catch (e) {
      _logger.error('Failed to record Flutter error', error: e);
    }
  }

  /// Log a custom message to Crashlytics
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      _logger.info('Logged to Crashlytics: $message');
    } catch (e) {
      _logger.error('Failed to log to Crashlytics', error: e);
    }
  }

  /// Set user information for crash reports
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? name,
  }) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      
      if (email != null) {
        await _crashlytics.setCustomKey('user_email', email);
      }
      
      if (name != null) {
        await _crashlytics.setCustomKey('user_name', name);
      }

      _logger.info('User info set for crash reports: $userId');
    } catch (e) {
      _logger.error('Failed to set user info', error: e);
    }
  }

  /// Clear user information
  Future<void> clearUserInfo() async {
    try {
      await _crashlytics.setUserIdentifier('');
      await _crashlytics.setCustomKey('user_email', '');
      await _crashlytics.setCustomKey('user_name', '');
      
      _logger.info('User info cleared from crash reports');
    } catch (e) {
      _logger.error('Failed to clear user info', error: e);
    }
  }

  /// Record a network error
  Future<void> recordNetworkError(
    String endpoint,
    int? statusCode,
    String? errorMessage, {
    Map<String, dynamic>? requestData,
  }) async {
    try {
      final context = {
        'endpoint': endpoint,
        'status_code': statusCode ?? 0,
        'error_message': errorMessage ?? 'Unknown network error',
        if (requestData != null) 'request_data': requestData.toString(),
      };

      await recordError(
        'NetworkError',
        StackTrace.current,
        reason: 'Network request failed: $endpoint',
        context: context,
      );

      // Also track as analytics event
      await _analytics.trackEvent('network_error', context);
    } catch (e) {
      _logger.error('Failed to record network error', error: e);
    }
  }

  /// Record an authentication error
  Future<void> recordAuthError(
    String action,
    String errorMessage, {
    Map<String, dynamic>? context,
  }) async {
    try {
      final errorContext = {
        'auth_action': action,
        'error_message': errorMessage,
        if (context != null) ...context,
      };

      await recordError(
        'AuthenticationError',
        StackTrace.current,
        reason: 'Authentication failed: $action',
        context: errorContext,
      );

      // Track in analytics (without sensitive data)
      await _analytics.trackEvent('auth_error', {
        'action': action,
        'error_type': 'authentication_error',
      });
    } catch (e) {
      _logger.error('Failed to record auth error', error: e);
    }
  }

  /// Record a database error
  Future<void> recordDatabaseError(
    String operation,
    String errorMessage, {
    String? tableName,
    Map<String, dynamic>? context,
  }) async {
    try {
      final errorContext = {
        'db_operation': operation,
        'error_message': errorMessage,
        if (tableName != null) 'table_name': tableName,
        if (context != null) ...context,
      };

      await recordError(
        'DatabaseError',
        StackTrace.current,
        reason: 'Database operation failed: $operation',
        context: errorContext,
      );
    } catch (e) {
      _logger.error('Failed to record database error', error: e);
    }
  }

  /// Check if there are unsent crash reports
  Future<bool> hasUnsentReports() async {
    try {
      return await _crashlytics.checkForUnsentReports();
    } catch (e) {
      _logger.error('Failed to check for unsent reports', error: e);
      return false;
    }
  }

  /// Send unsent crash reports
  Future<void> sendUnsentReports() async {
    try {
      await _crashlytics.sendUnsentReports();
      _logger.info('Sent unsent crash reports');
    } catch (e) {
      _logger.error('Failed to send unsent reports', error: e);
    }
  }

  /// Delete unsent crash reports
  Future<void> deleteUnsentReports() async {
    try {
      await _crashlytics.deleteUnsentReports();
      _logger.info('Deleted unsent crash reports');
    } catch (e) {
      _logger.error('Failed to delete unsent reports', error: e);
    }
  }

  /// Set app-specific context for crash reports
  Future<void> _setAppContext() async {
    try {
      await _crashlytics.setCustomKey('app_version', '1.0.0');
      await _crashlytics.setCustomKey('platform', 'flutter');
      await _crashlytics.setCustomKey('timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      _logger.error('Failed to set app context', error: e);
    }
  }
}
