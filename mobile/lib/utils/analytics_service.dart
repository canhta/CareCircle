import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import '../common/common.dart';

/// Analytics service for tracking user interactions and events
/// Provides centralized analytics that can be extended with different providers
class AnalyticsService {
  late final AppLogger _logger;
  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final FirebasePerformance _performance;
  bool _isInitialized = false;

  AnalyticsService() {
    _logger = AppLogger('AnalyticsService');
    _analytics = FirebaseAnalytics.instance;
    _crashlytics = FirebaseCrashlytics.instance;
    _performance = FirebasePerformance.instance;
  }

  bool get isInitialized => _isInitialized;

  /// Initialize analytics service
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.info('AnalyticsService already initialized');
      return;
    }

    try {
      _logger.info('Initializing AnalyticsService...');

      // Initialize Firebase Analytics
      await _analytics.setAnalyticsCollectionEnabled(true);

      // Initialize Firebase Crashlytics
      await _crashlytics.setCrashlyticsCollectionEnabled(true);

      // Initialize Firebase Performance
      await _performance.setPerformanceCollectionEnabled(true);

      _isInitialized = true;
      _logger.info('AnalyticsService initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize AnalyticsService', error: e);
      rethrow;
    }
  }

  /// Track user action/event
  Future<void> trackEvent(
      String eventName, Map<String, dynamic> properties) async {
    if (!_isInitialized) {
      _logger.warning(
          'AnalyticsService not initialized, skipping event: $eventName');
      return;
    }

    _logger.info('Tracking event: $eventName with properties: $properties');

    try {
      // Convert properties to Firebase Analytics compatible format
      final Map<String, Object> analyticsProperties = {};
      for (final entry in properties.entries) {
        if (entry.value is String ||
            entry.value is num ||
            entry.value is bool) {
          analyticsProperties[entry.key] = entry.value;
        } else {
          analyticsProperties[entry.key] = entry.value.toString();
        }
      }

      // Send to Firebase Analytics
      await _analytics.logEvent(
        name: eventName,
        parameters: analyticsProperties,
      );

      _logger.info('Analytics event tracked successfully');
    } catch (e) {
      _logger.error('Failed to track analytics event: $eventName', error: e);

      // Also log to Crashlytics for debugging
      await _crashlytics.recordError(
        e,
        StackTrace.current,
        reason: 'Analytics event tracking failed: $eventName',
      );
    }
  }

  /// Track user action with predefined action types
  Future<void> trackUserAction(
      String action, Map<String, dynamic> properties) async {
    await trackEvent('user_action', {
      'action': action,
      ...properties,
    });
  }

  /// Track notification events
  Future<void> trackNotificationEvent(
      String eventType, Map<String, dynamic> properties) async {
    await trackEvent('notification_event', {
      'event_type': eventType,
      'timestamp': DateTime.now().toIso8601String(),
      ...properties,
    });
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName,
      {Map<String, dynamic>? properties}) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
      if (properties != null) ...properties,
    });
  }

  /// Track medication events
  Future<void> trackMedicationEvent(String action, String medicationId,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('medication_event', {
      'action': action,
      'medication_id': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track emergency events
  Future<void> trackEmergencyEvent(String action, String alertType,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('emergency_event', {
      'action': action,
      'alert_type': alertType,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track health check events
  Future<void> trackHealthCheckEvent(String action, String checkInType,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('health_check_event', {
      'action': action,
      'check_in_type': checkInType,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track care group events
  Future<void> trackCareGroupEvent(String action, String groupId,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('care_group_event', {
      'action': action,
      'group_id': groupId,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track authentication events
  Future<void> trackAuthEvent(String action,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('auth_event', {
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track app lifecycle events
  Future<void> trackAppEvent(String action,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('app_event', {
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Track error events
  Future<void> trackError(String errorType, String errorMessage,
      {Map<String, dynamic>? additionalProperties}) async {
    await trackEvent('error_event', {
      'error_type': errorType,
      'error_message': errorMessage,
      'timestamp': DateTime.now().toIso8601String(),
      if (additionalProperties != null) ...additionalProperties,
    });
  }

  /// Set user properties
  Future<void> setUserProperty(String name, String value) async {
    if (!_isInitialized) {
      _logger.warning(
          'AnalyticsService not initialized, skipping user property: $name');
      return;
    }

    _logger.info('Setting user property: $name = $value');

    try {
      // Set user property in Firebase Analytics
      await _analytics.setUserProperty(name: name, value: value);

      _logger.info('User property set successfully');
    } catch (e) {
      _logger.error('Failed to set user property: $name', error: e);

      // Log error to Crashlytics
      await _crashlytics.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to set user property: $name',
      );
    }
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) {
      _logger.warning('AnalyticsService not initialized, skipping user ID');
      return;
    }

    _logger.info('Setting user ID: $userId');

    try {
      // Set user ID in Firebase Analytics
      await _analytics.setUserId(id: userId);

      // Set user identifier in Crashlytics
      await _crashlytics.setUserIdentifier(userId);

      _logger.info('User ID set successfully');
    } catch (e) {
      _logger.error('Failed to set user ID', error: e);

      // Log error to Crashlytics
      await _crashlytics.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to set user ID',
      );
    }
  }

  /// Track error events and send to Crashlytics
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? additionalData,
    bool fatal = false,
  }) async {
    try {
      _logger.error('Recording error: $reason', error: error);

      // Set custom keys for additional context
      if (additionalData != null) {
        for (final entry in additionalData.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Record the error
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      // Also track as analytics event for non-fatal errors
      if (!fatal) {
        await trackError(
          'non_fatal_error',
          reason ?? error.toString(),
          additionalProperties: additionalData,
        );
      }
    } catch (e) {
      _logger.error('Failed to record error', error: e);
    }
  }

  /// Create and start a performance trace
  Trace? startTrace(String traceName) {
    try {
      final trace = _performance.newTrace(traceName);
      trace.start();
      _logger.info('Started performance trace: $traceName');
      return trace;
    } catch (e) {
      _logger.error('Failed to start trace: $traceName', error: e);
      return null;
    }
  }

  /// Stop a performance trace
  Future<void> stopTrace(Trace? trace) async {
    if (trace == null) return;

    try {
      await trace.stop();
      _logger.info('Stopped performance trace');
    } catch (e) {
      _logger.error('Failed to stop trace', error: e);
    }
  }

  /// Track performance metrics
  Future<void> trackPerformanceMetric(
    String metricName,
    double value, {
    String? unit,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent('performance_metric', {
      'metric_name': metricName,
      'metric_value': value,
      if (unit != null) 'unit': unit,
      'timestamp': DateTime.now().toIso8601String(),
      if (properties != null) ...properties,
    });
  }
}
