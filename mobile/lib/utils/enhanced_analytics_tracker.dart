import '../config/service_locator.dart';
import '../common/logging/app_logger.dart';
import 'analytics_service.dart';

/// Enhanced analytics tracker that provides comprehensive user interaction tracking
/// and health data pattern analysis for the CareCircle app
class EnhancedAnalyticsTracker {
  static final EnhancedAnalyticsTracker _instance =
      EnhancedAnalyticsTracker._internal();
  factory EnhancedAnalyticsTracker() => _instance;
  EnhancedAnalyticsTracker._internal();

  late final AnalyticsService _analytics;
  late final AppLogger _logger;

  final List<AnalyticsEvent> _userJourney = [];
  final Map<String, int> _featureUsageCount = {};
  final Map<String, DateTime> _screenStartTimes = {};
  final Map<String, Duration> _screenTimeAccumulator = {};
  DateTime? _sessionStartTime;
  String? _currentScreen;

  /// Initialize the enhanced analytics tracker
  Future<void> initialize() async {
    _analytics = ServiceLocator.get<AnalyticsService>();
    _logger = ServiceLocator.get<AppLogger>();
    _sessionStartTime = DateTime.now();

    await _analytics.trackAppEvent('session_start', additionalProperties: {
      'session_id': _generateSessionId(),
      'app_version': '1.0.0', // This should come from package info
      'platform': 'mobile',
    });

    _logger.info('Enhanced analytics tracker initialized');
  }

  /// Track screen views with enhanced context
  Future<void> trackScreenView(String screenName,
      {Map<String, dynamic>? properties}) async {
    try {
      // End previous screen tracking
      if (_currentScreen != null) {
        await _endScreenTracking(_currentScreen!);
      }

      // Start new screen tracking
      _currentScreen = screenName;
      _screenStartTimes[screenName] = DateTime.now();

      final enhancedProperties = {
        'screen_name': screenName,
        'journey_step': _userJourney.length,
        'session_duration': _getSessionDuration(),
        'previous_screen':
            _userJourney.isNotEmpty ? _userJourney.last.name : null,
        'navigation_path': _getNavigationPath(),
        if (properties != null) ...properties,
      };

      await _analytics.trackScreenView(screenName,
          properties: enhancedProperties);
      _addToJourney('screen_view', screenName, enhancedProperties);

      _logger.info('Enhanced screen view tracked: $screenName');
    } catch (e) {
      _logger.error('Failed to track enhanced screen view: $screenName',
          error: e);
    }
  }

  /// Track user interactions with detailed context
  Future<void> trackUserInteraction(
    String action,
    String element, {
    String? category,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final enhancedProperties = {
        'action': action,
        'element': element,
        'category': category ?? 'general',
        'screen': _currentScreen,
        'journey_step': _userJourney.length,
        'session_duration': _getSessionDuration(),
        'interaction_sequence': _getRecentInteractions(),
        if (properties != null) ...properties,
      };

      await _analytics.trackUserAction(action, enhancedProperties);
      _addToJourney('user_interaction', '$action:$element', enhancedProperties);

      _logger.info('User interaction tracked: $action on $element');
    } catch (e) {
      _logger.error('Failed to track user interaction: $action', error: e);
    }
  }

  /// Track health data entry patterns
  Future<void> trackHealthDataEntry(
    String dataType,
    dynamic value, {
    String? method,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final enhancedProperties = {
        'data_type': dataType,
        'value': value?.toString(),
        'entry_method': method ?? 'manual',
        'screen': _currentScreen,
        'time_of_day': _getTimeOfDay(),
        'day_of_week': DateTime.now().weekday,
        'session_duration': _getSessionDuration(),
        if (properties != null) ...properties,
      };

      await _analytics.trackEvent('health_data_entry', enhancedProperties);
      _addToJourney('health_data_entry', dataType, enhancedProperties);

      _logger.info('Health data entry tracked: $dataType = $value');
    } catch (e) {
      _logger.error('Failed to track health data entry: $dataType', error: e);
    }
  }

  /// Track feature usage with engagement metrics
  Future<void> trackFeatureUsage(
    String featureName, {
    String? action,
    Duration? timeSpent,
    Map<String, dynamic>? properties,
  }) async {
    try {
      _featureUsageCount[featureName] =
          (_featureUsageCount[featureName] ?? 0) + 1;

      final enhancedProperties = {
        'feature_name': featureName,
        'action': action ?? 'accessed',
        'usage_count': _featureUsageCount[featureName],
        'time_spent_seconds': timeSpent?.inSeconds,
        'screen': _currentScreen,
        'session_duration': _getSessionDuration(),
        'user_engagement_level': _calculateEngagementLevel(),
        if (properties != null) ...properties,
      };

      await _analytics.trackEvent('feature_usage', enhancedProperties);
      _addToJourney('feature_usage', featureName, enhancedProperties);

      _logger.info(
          'Feature usage tracked: $featureName (${_featureUsageCount[featureName]} times)');
    } catch (e) {
      _logger.error('Failed to track feature usage: $featureName', error: e);
    }
  }

  /// Track medication adherence patterns
  Future<void> trackMedicationAdherence(
    String medicationId,
    String action, {
    DateTime? scheduledTime,
    DateTime? actualTime,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final delay = scheduledTime != null && actualTime != null
          ? actualTime.difference(scheduledTime)
          : null;

      final enhancedProperties = {
        'medication_id': medicationId,
        'action': action,
        'scheduled_time': scheduledTime?.toIso8601String(),
        'actual_time': actualTime?.toIso8601String(),
        'delay_minutes': delay?.inMinutes,
        'adherence_status': _getAdherenceStatus(delay),
        'time_of_day': _getTimeOfDay(),
        'day_of_week': DateTime.now().weekday,
        if (properties != null) ...properties,
      };

      await _analytics.trackMedicationEvent(action, medicationId,
          additionalProperties: enhancedProperties);
      _addToJourney('medication_adherence', action, enhancedProperties);

      _logger.info('Medication adherence tracked: $action for $medicationId');
    } catch (e) {
      _logger.error('Failed to track medication adherence: $action', error: e);
    }
  }

  /// Track error patterns and user recovery actions
  Future<void> trackErrorRecovery(
    String errorType,
    String recoveryAction, {
    String? errorContext,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final enhancedProperties = {
        'error_type': errorType,
        'recovery_action': recoveryAction,
        'error_context': errorContext,
        'screen': _currentScreen,
        'journey_step': _userJourney.length,
        'session_duration': _getSessionDuration(),
        'user_experience_impact': _calculateErrorImpact(),
        if (properties != null) ...properties,
      };

      await _analytics.trackEvent('error_recovery', enhancedProperties);
      _addToJourney('error_recovery', errorType, enhancedProperties);

      _logger.info('Error recovery tracked: $errorType -> $recoveryAction');
    } catch (e) {
      _logger.error('Failed to track error recovery: $errorType', error: e);
    }
  }

  /// Track user onboarding progress
  Future<void> trackOnboardingProgress(
    String step,
    String status, {
    Duration? timeSpent,
    Map<String, dynamic>? properties,
  }) async {
    try {
      final enhancedProperties = {
        'onboarding_step': step,
        'status': status,
        'time_spent_seconds': timeSpent?.inSeconds,
        'completion_rate': _calculateOnboardingCompletion(step),
        'drop_off_risk': _calculateDropOffRisk(),
        if (properties != null) ...properties,
      };

      await _analytics.trackEvent('onboarding_progress', enhancedProperties);
      _addToJourney('onboarding', step, enhancedProperties);

      _logger.info('Onboarding progress tracked: $step - $status');
    } catch (e) {
      _logger.error('Failed to track onboarding progress: $step', error: e);
    }
  }

  /// End current session tracking
  Future<void> endSession() async {
    try {
      if (_currentScreen != null) {
        await _endScreenTracking(_currentScreen!);
      }

      final sessionDuration = _getSessionDuration();
      await _analytics.trackAppEvent('session_end', additionalProperties: {
        'session_duration_seconds': sessionDuration,
        'screens_visited': _screenTimeAccumulator.keys.length,
        'total_interactions': _userJourney.length,
        'features_used': _featureUsageCount.keys.length,
        'engagement_score': _calculateSessionEngagement(),
      });

      _logger.info(
          'Session ended - Duration: ${sessionDuration}s, Interactions: ${_userJourney.length}');
    } catch (e) {
      _logger.error('Failed to end session tracking', error: e);
    }
  }

  // Private helper methods

  void _addToJourney(
      String eventType, String eventName, Map<String, dynamic> properties) {
    _userJourney.add(AnalyticsEvent(
      name: eventName,
      type: eventType,
      timestamp: DateTime.now(),
      properties: properties,
    ));

    // Keep only last 50 events to prevent memory issues
    if (_userJourney.length > 50) {
      _userJourney.removeAt(0);
    }
  }

  Future<void> _endScreenTracking(String screenName) async {
    final startTime = _screenStartTimes[screenName];
    if (startTime != null) {
      final timeSpent = DateTime.now().difference(startTime);
      _screenTimeAccumulator[screenName] =
          (_screenTimeAccumulator[screenName] ?? Duration.zero) + timeSpent;

      await _analytics.trackEvent('screen_time', {
        'screen_name': screenName,
        'time_spent_seconds': timeSpent.inSeconds,
        'total_time_seconds': _screenTimeAccumulator[screenName]!.inSeconds,
      });

      _screenStartTimes.remove(screenName);
    }
  }

  String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_sessionStartTime?.millisecondsSinceEpoch}';
  }

  int _getSessionDuration() {
    return _sessionStartTime != null
        ? DateTime.now().difference(_sessionStartTime!).inSeconds
        : 0;
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'night';
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  List<String> _getNavigationPath() {
    return _userJourney
        .where((event) => event.type == 'screen_view')
        .map((event) => event.name)
        .take(5)
        .toList();
  }

  List<String> _getRecentInteractions() {
    return _userJourney
        .where((event) => event.type == 'user_interaction')
        .map((event) => event.name)
        .take(3)
        .toList();
  }

  String _calculateEngagementLevel() {
    final interactionCount = _userJourney.length;
    final sessionDuration = _getSessionDuration();

    if (sessionDuration < 30) return 'low';
    if (interactionCount < 5) return 'low';
    if (interactionCount > 20 && sessionDuration > 300) return 'high';
    return 'medium';
  }

  String _getAdherenceStatus(Duration? delay) {
    if (delay == null) return 'unknown';
    if (delay.inMinutes.abs() <= 15) return 'on_time';
    if (delay.inMinutes.abs() <= 60) return 'slightly_late';
    return 'significantly_late';
  }

  String _calculateErrorImpact() {
    final recentErrors =
        _userJourney.where((event) => event.type == 'error_recovery').length;

    if (recentErrors == 0) return 'none';
    if (recentErrors <= 2) return 'low';
    return 'high';
  }

  double _calculateOnboardingCompletion(String currentStep) {
    // This would be based on predefined onboarding steps
    final steps = [
      'welcome',
      'profile',
      'health_data',
      'notifications',
      'complete'
    ];
    final currentIndex = steps.indexOf(currentStep);
    return currentIndex >= 0 ? (currentIndex + 1) / steps.length : 0.0;
  }

  String _calculateDropOffRisk() {
    final sessionDuration = _getSessionDuration();
    final interactionCount = _userJourney.length;

    if (sessionDuration < 60 && interactionCount < 3) return 'high';
    if (sessionDuration < 180 && interactionCount < 8) return 'medium';
    return 'low';
  }

  double _calculateSessionEngagement() {
    final duration = _getSessionDuration();
    final interactions = _userJourney.length;
    final screens = _screenTimeAccumulator.keys.length;

    // Simple engagement score calculation
    return (interactions * 0.4 + screens * 0.3 + (duration / 60) * 0.3)
        .clamp(0.0, 10.0);
  }
}

/// Analytics event data structure
class AnalyticsEvent {
  final String name;
  final String type;
  final DateTime timestamp;
  final Map<String, dynamic> properties;

  AnalyticsEvent({
    required this.name,
    required this.type,
    required this.timestamp,
    required this.properties,
  });
}
