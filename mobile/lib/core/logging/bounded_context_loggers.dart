import 'package:talker_flutter/talker_flutter.dart';
import 'app_logger.dart';
import 'healthcare_talker_observer.dart';
import 'log_config.dart';

/// Bounded context-specific loggers for DDD architecture
///
/// Each bounded context in the CareCircle application has its own logger
/// instance with context-specific configuration and healthcare compliance.
class BoundedContextLoggers {
  static bool _initialized = false;

  // Context-specific logger instances
  static late final Talker _auth;
  static late final Talker _aiAssistant;
  static late final Talker _healthData;
  static late final Talker _medication;
  static late final Talker _careGroup;
  static late final Talker _notification;
  static late final Talker _navigation;
  static late final Talker _performance;
  static late final Talker _security;
  static late final Talker _compliance;

  /// Initialize all bounded context loggers
  static Future<void> initialize() async {
    if (_initialized) return;

    // Ensure main logger is initialized first
    await AppLogger.initialize();

    // Create context-specific loggers
    _auth = _createContextLogger('AUTH');
    _aiAssistant = _createContextLogger('AI_ASSISTANT');
    _healthData = _createContextLogger('HEALTH_DATA');
    _medication = _createContextLogger('MEDICATION');
    _careGroup = _createContextLogger('CARE_GROUP');
    _notification = _createContextLogger('NOTIFICATION');
    _navigation = _createContextLogger('NAVIGATION');
    _performance = _createContextLogger('PERFORMANCE');
    _security = _createContextLogger('SECURITY');
    _compliance = _createContextLogger('COMPLIANCE');

    _initialized = true;

    // Log successful initialization
    AppLogger.info('Bounded context loggers initialized', {
      'contexts': [
        'AUTH',
        'AI_ASSISTANT',
        'HEALTH_DATA',
        'MEDICATION',
        'CARE_GROUP',
        'NOTIFICATION',
        'NAVIGATION',
        'PERFORMANCE',
        'SECURITY',
        'COMPLIANCE',
      ],
      'totalContexts': 10,
    });
  }

  /// Authentication context logger
  static Talker get auth {
    _ensureInitialized();
    return _auth;
  }

  /// AI Assistant context logger
  static Talker get aiAssistant {
    _ensureInitialized();
    return _aiAssistant;
  }

  /// Health Data context logger
  static Talker get healthData {
    _ensureInitialized();
    return _healthData;
  }

  /// Medication context logger
  static Talker get medication {
    _ensureInitialized();
    return _medication;
  }

  /// Care Group context logger
  static Talker get careGroup {
    _ensureInitialized();
    return _careGroup;
  }

  /// Notification context logger
  static Talker get notification {
    _ensureInitialized();
    return _notification;
  }

  /// Navigation context logger
  static Talker get navigation {
    _ensureInitialized();
    return _navigation;
  }

  /// Performance monitoring logger
  static Talker get performance {
    _ensureInitialized();
    return _performance;
  }

  /// Security context logger
  static Talker get security {
    _ensureInitialized();
    return _security;
  }

  /// Compliance context logger
  static Talker get compliance {
    _ensureInitialized();
    return _compliance;
  }

  /// Create a context-specific logger instance
  static Talker _createContextLogger(String context) {
    return Talker(
      settings: LogConfig.talkerSettings.copyWith(titles: {...LogConfig.talkerSettings.titles, 'context': context}),
      logger: TalkerLogger(settings: LogConfig.talkerLoggerSettings),
      observer: ContextualTalkerObserver(context, null),
    );
  }

  /// Ensure loggers are initialized before use
  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'BoundedContextLoggers must be initialized before use. '
        'Call BoundedContextLoggers.initialize() first.',
      );
    }
  }

  /// Get all context loggers as a map
  static Map<String, Talker> getAllContexts() {
    _ensureInitialized();
    return {
      'AUTH': _auth,
      'AI_ASSISTANT': _aiAssistant,
      'HEALTH_DATA': _healthData,
      'MEDICATION': _medication,
      'CARE_GROUP': _careGroup,
      'NOTIFICATION': _notification,
      'NAVIGATION': _navigation,
      'PERFORMANCE': _performance,
      'SECURITY': _security,
      'COMPLIANCE': _compliance,
    };
  }

  /// Clean up all context loggers
  static void dispose() {
    if (!_initialized) return;

    final contexts = getAllContexts();
    for (final logger in contexts.values) {
      logger.cleanHistory();
    }

    _initialized = false;
  }

  /// Get combined history from all contexts
  static List<TalkerData> getCombinedHistory() {
    _ensureInitialized();

    final allLogs = <TalkerData>[];
    final contexts = getAllContexts();

    for (final logger in contexts.values) {
      allLogs.addAll(logger.history);
    }

    // Sort by timestamp
    allLogs.sort((a, b) => a.time.compareTo(b.time));

    return allLogs;
  }

  /// Clear history for all contexts
  static void clearAllHistory() {
    _ensureInitialized();

    final contexts = getAllContexts();
    for (final logger in contexts.values) {
      logger.cleanHistory();
    }
  }

  /// Get context-specific performance logger
  static PerformanceTalkerObserver getPerformanceObserver() {
    _ensureInitialized();
    return PerformanceTalkerObserver();
  }
}

/// Extension methods for easier logging in bounded contexts
extension BoundedContextLogging on Talker {
  /// Log authentication event with context
  void logAuthEvent(String event, Map<String, dynamic> data) {
    info('[AUTH] $event', data);
  }

  /// Log AI assistant interaction
  void logAiInteraction(String interaction, Map<String, dynamic> context) {
    info('[AI_ASSISTANT] $interaction', context);
  }

  /// Log health data access with strict privacy
  void logHealthDataAccess(String action, Map<String, dynamic> context) {
    info('[HEALTH_DATA] $action', context);
  }

  /// Log medication event
  void logMedicationEvent(String event, Map<String, dynamic> context) {
    info('[MEDICATION] $event', context);
  }

  /// Log care group activity
  void logCareGroupActivity(String activity, Map<String, dynamic> context) {
    info('[CARE_GROUP] $activity', context);
  }

  /// Log notification event
  void logNotificationEvent(String event, Map<String, dynamic> context) {
    info('[NOTIFICATION] $event', context);
  }

  /// Log navigation event
  void logNavigationEvent(String event, Map<String, dynamic> context) {
    info('[NAVIGATION] $event', context);
  }

  /// Log performance metric
  void logPerformanceMetric(String metric, Duration duration, [Map<String, dynamic>? context]) {
    final performanceData = {
      'metric': metric,
      'durationMs': duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
      if (context != null) ...context,
    };
    info('[PERFORMANCE] $metric', performanceData);
  }

  /// Log security event
  void logSecurityEvent(String event, Map<String, dynamic> context) {
    warning('[SECURITY] $event', context);
  }

  /// Log compliance event
  void logComplianceEvent(String event, Map<String, dynamic> context) {
    info('[COMPLIANCE] $event', context);
  }
}
