import '../common/common.dart';
import '../utils/analytics_service.dart';

/// Service for tracking user behavior and app usage patterns
class UserBehaviorService {
  late final AnalyticsService _analytics;
  late final AppLogger _logger;

  // Session tracking
  DateTime? _sessionStartTime;
  String? _currentScreen;
  final Map<String, int> _screenTimeMap = {};
  final Map<String, int> _featureUsageMap = {};

  UserBehaviorService({
    required AnalyticsService analytics,
    required AppLogger logger,
  }) {
    _analytics = analytics;
    _logger = logger;
  }

  /// Initialize user behavior tracking
  Future<void> initialize() async {
    try {
      _logger.info('Initializing UserBehaviorService...');

      // Start session tracking
      await startSession();

      _logger.info('UserBehaviorService initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize UserBehaviorService', error: e);
      rethrow;
    }
  }

  /// Start a new user session
  Future<void> startSession() async {
    try {
      _sessionStartTime = DateTime.now();

      await _analytics.trackEvent('session_start', {
        'timestamp': _sessionStartTime!.toIso8601String(),
        'platform': 'flutter',
      });

      _logger.info('User session started');
    } catch (e) {
      _logger.error('Failed to start session', error: e);
    }
  }

  /// End the current user session
  Future<void> endSession() async {
    try {
      if (_sessionStartTime == null) return;

      final sessionDuration = DateTime.now().difference(_sessionStartTime!);

      await _analytics.trackEvent('session_end', {
        'session_duration_seconds': sessionDuration.inSeconds,
        'session_duration_minutes': sessionDuration.inMinutes,
        'screens_visited': _screenTimeMap.keys.length,
        'features_used': _featureUsageMap.keys.length,
      });

      // Reset session data
      _sessionStartTime = null;
      _currentScreen = null;
      _screenTimeMap.clear();
      _featureUsageMap.clear();

      _logger.info('User session ended: ${sessionDuration.inMinutes} minutes');
    } catch (e) {
      _logger.error('Failed to end session', error: e);
    }
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName,
      {Map<String, dynamic>? properties}) async {
    try {
      // End previous screen tracking
      if (_currentScreen != null) {
        await _endScreenView(_currentScreen!);
      }

      // Start new screen tracking
      _currentScreen = screenName;

      await _analytics.trackScreenView(screenName, properties: {
        'timestamp': DateTime.now().toIso8601String(),
        if (properties != null) ...properties,
      });

      _logger.info('Screen view tracked: $screenName');
    } catch (e) {
      _logger.error('Failed to track screen view: $screenName', error: e);
    }
  }

  /// Track feature usage
  Future<void> trackFeatureUsage(
    String featureName, {
    String? action,
    Map<String, dynamic>? properties,
  }) async {
    try {
      // Increment feature usage count
      _featureUsageMap[featureName] = (_featureUsageMap[featureName] ?? 0) + 1;

      await _analytics.trackEvent('feature_usage', {
        'feature_name': featureName,
        'action': action ?? 'used',
        'usage_count': _featureUsageMap[featureName],
        'timestamp': DateTime.now().toIso8601String(),
        if (properties != null) ...properties,
      });

      _logger.info('Feature usage tracked: $featureName');
    } catch (e) {
      _logger.error('Failed to track feature usage: $featureName', error: e);
    }
  }

  /// Track user action
  Future<void> trackUserAction(
    String action, {
    String? category,
    String? label,
    int? value,
    Map<String, dynamic>? properties,
  }) async {
    try {
      await _analytics.trackUserAction(action, {
        'category': category ?? 'general',
        'label': label,
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
        if (properties != null) ...properties,
      });

      _logger.info('User action tracked: $action');
    } catch (e) {
      _logger.error('Failed to track user action: $action', error: e);
    }
  }

  /// Track button tap
  Future<void> trackButtonTap(
    String buttonName, {
    String? screenName,
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'button_tap',
      category: 'interaction',
      label: buttonName,
      properties: {
        'button_name': buttonName,
        'screen_name': screenName ?? _currentScreen ?? 'unknown',
        if (properties != null) ...properties,
      },
    );
  }

  /// Track form submission
  Future<void> trackFormSubmission(
    String formName, {
    bool success = true,
    String? errorMessage,
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'form_submission',
      category: 'form',
      label: formName,
      properties: {
        'form_name': formName,
        'success': success,
        'error_message': errorMessage,
        if (properties != null) ...properties,
      },
    );
  }

  /// Track search behavior
  Future<void> trackSearch(
    String query, {
    String? category,
    int? resultsCount,
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'search',
      category: 'search',
      label: query,
      properties: {
        'query': query,
        'category': category,
        'results_count': resultsCount,
        if (properties != null) ...properties,
      },
    );
  }

  /// Track navigation behavior
  Future<void> trackNavigation(
    String from,
    String to, {
    String? method,
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'navigation',
      category: 'navigation',
      properties: {
        'from_screen': from,
        'to_screen': to,
        'method': method ?? 'unknown',
        if (properties != null) ...properties,
      },
    );
  }

  /// Track onboarding progress
  Future<void> trackOnboardingStep(
    String stepName, {
    int? stepNumber,
    bool completed = false,
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'onboarding_step',
      category: 'onboarding',
      label: stepName,
      properties: {
        'step_name': stepName,
        'step_number': stepNumber,
        'completed': completed,
        if (properties != null) ...properties,
      },
    );
  }

  /// Track user preferences changes
  Future<void> trackPreferenceChange(
    String preferenceName,
    dynamic oldValue,
    dynamic newValue, {
    Map<String, dynamic>? properties,
  }) async {
    await trackUserAction(
      'preference_change',
      category: 'settings',
      label: preferenceName,
      properties: {
        'preference_name': preferenceName,
        'old_value': oldValue?.toString(),
        'new_value': newValue?.toString(),
        if (properties != null) ...properties,
      },
    );
  }

  /// Track app lifecycle events
  Future<void> trackAppLifecycle(String event) async {
    await _analytics.trackAppEvent(event, additionalProperties: {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track performance metrics
  Future<void> trackPerformanceMetric(
    String metricName,
    double value, {
    String? unit,
    Map<String, dynamic>? properties,
  }) async {
    await _analytics.trackEvent('performance_metric', {
      'metric_name': metricName,
      'value': value,
      'unit': unit ?? 'ms',
      'timestamp': DateTime.now().toIso8601String(),
      if (properties != null) ...properties,
    });
  }

  /// Get user behavior summary
  Future<Map<String, dynamic>> getBehaviorSummary() async {
    try {
      final sessionDuration = _sessionStartTime != null
          ? DateTime.now().difference(_sessionStartTime!)
          : Duration.zero;

      return {
        'session_duration_minutes': sessionDuration.inMinutes,
        'screens_visited': _screenTimeMap.keys.length,
        'features_used': _featureUsageMap.keys.length,
        'current_screen': _currentScreen,
        'screen_time_map': Map.from(_screenTimeMap),
        'feature_usage_map': Map.from(_featureUsageMap),
      };
    } catch (e) {
      _logger.error('Failed to get behavior summary', error: e);
      return {};
    }
  }

  /// End screen view tracking
  Future<void> _endScreenView(String screenName) async {
    try {
      // Calculate time spent on screen (simplified)
      final timeSpent = 30; // Placeholder - in a real app, track actual time
      _screenTimeMap[screenName] =
          (_screenTimeMap[screenName] ?? 0) + timeSpent;

      await _analytics.trackEvent('screen_time', {
        'screen_name': screenName,
        'time_spent_seconds': timeSpent,
      });
    } catch (e) {
      _logger.error('Failed to end screen view: $screenName', error: e);
    }
  }
}
