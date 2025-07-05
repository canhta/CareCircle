import '../common/common.dart';

/// Analytics service for tracking user interactions and events
/// Provides centralized analytics that can be extended with different providers
class AnalyticsService {
  late final AppLogger _logger;
  bool _isInitialized = false;

  AnalyticsService() {
    _logger = AppLogger('AnalyticsService');
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

      // TODO: Initialize actual analytics providers (Firebase Analytics, etc.)

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
      // TODO: Send to actual analytics providers
      // await FirebaseAnalytics.instance.logEvent(name: eventName, parameters: properties);

      // For now, just log the event
      _logger.info('Analytics event tracked successfully');
    } catch (e) {
      _logger.error('Failed to track analytics event: $eventName', error: e);
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
      // TODO: Set user property in actual analytics providers
      // await FirebaseAnalytics.instance.setUserProperty(name: name, value: value);

      _logger.info('User property set successfully');
    } catch (e) {
      _logger.error('Failed to set user property: $name', error: e);
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
      // TODO: Set user ID in actual analytics providers
      // await FirebaseAnalytics.instance.setUserId(id: userId);

      _logger.info('User ID set successfully');
    } catch (e) {
      _logger.error('Failed to set user ID', error: e);
    }
  }
}
