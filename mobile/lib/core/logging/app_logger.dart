import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'log_config.dart';
import 'healthcare_talker_observer.dart';
import 'healthcare_log_sanitizer.dart';

/// Main application logger with healthcare-specific configuration
///
/// This class provides the primary logging interface for the CareCircle
/// mobile application, ensuring HIPAA compliance and healthcare data privacy.
class AppLogger {
  static Talker? _instance;
  static bool _initialized = false;

  /// Get the singleton Talker instance
  static Talker get instance {
    if (!_initialized) {
      throw StateError('AppLogger must be initialized before use. Call AppLogger.initialize() first.');
    }
    return _instance!;
  }

  /// Initialize the healthcare-compliant logging system
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Create Talker instance with healthcare configuration
      _instance = await _createHealthcareTalker();
      _initialized = true;

      // Log successful initialization
      _instance!.info('Healthcare logging system initialized', {
        'environment': LogConfig.talkerSettings.enabled ? 'enabled' : 'disabled',
        'logLevel': LogConfig.logLevel.name,
        'fileLogging': LogConfig.enableFileLogging,
        'maxHistory': LogConfig.maxHistoryItems,
      });
    } catch (e, stackTrace) {
      // Fallback to basic console logging if initialization fails
      debugPrint('Failed to initialize AppLogger: $e');
      debugPrint('StackTrace: $stackTrace');

      // Create minimal Talker instance
      _instance = Talker(
        settings: TalkerSettings(enabled: kDebugMode),
        observer: const HealthcareTalkerObserver(),
      );
      _initialized = true;
    }
  }

  /// Create a healthcare-compliant Talker instance
  static Future<Talker> _createHealthcareTalker() async {
    return TalkerFlutter.init(
      settings: LogConfig.talkerSettings,
      logger: TalkerLogger(settings: LogConfig.talkerLoggerSettings),
      observer: const HealthcareTalkerObserver(),
    );
  }

  /// Log an info message with optional data
  static void info(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
      instance.info('$message | Data: $sanitizedData');
    } else {
      instance.info(message);
    }
  }

  /// Log a debug message with optional data
  static void debug(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
      instance.debug('$message | Data: $sanitizedData');
    } else {
      instance.debug(message);
    }
  }

  /// Log a warning message with optional data
  static void warning(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
      instance.warning('$message | Data: $sanitizedData');
    } else {
      instance.warning(message);
    }
  }

  /// Log an error message with optional data
  static void error(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
      instance.error('$message | Data: $sanitizedData');
    } else {
      instance.error(message);
    }
  }

  /// Log a critical message with optional data
  static void critical(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      final sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
      instance.critical('$message | Data: $sanitizedData');
    } else {
      instance.critical(message);
    }
  }

  /// Handle exceptions with automatic sanitization
  static void handleException(
    dynamic exception,
    StackTrace? stackTrace, [
    String? message,
    Map<String, dynamic>? data,
  ]) {
    final sanitizedMessage = message != null ? HealthcareLogSanitizer.sanitizeMessage(message) : 'Exception occurred';

    Map<String, dynamic>? sanitizedData;
    if (data != null) {
      sanitizedData = HealthcareLogSanitizer.sanitizeData(data);
    }

    instance.handle(
      exception,
      stackTrace,
      sanitizedData != null ? '$sanitizedMessage | Data: $sanitizedData' : sanitizedMessage,
    );
  }

  /// Log authentication events (with special handling for sensitive data)
  static void logAuthEvent(String event, Map<String, dynamic> data) {
    final sanitizedData = HealthcareLogSanitizer.createSanitizedSummary(
      data,
      allowedFields: ['method', 'provider', 'userType', 'timestamp'],
    );

    instance.info('[AUTH] $event', sanitizedData);
  }

  /// Log health data access (with strict sanitization)
  static void logHealthDataAccess(String action, Map<String, dynamic> context) {
    final sanitizedContext = HealthcareLogSanitizer.createSanitizedSummary(
      context,
      allowedFields: ['userId', 'dataType', 'timestamp', 'source'],
    );

    instance.info('[HEALTH_DATA] $action', sanitizedContext);
  }

  /// Log performance metrics
  static void logPerformance(String operation, Duration duration, [Map<String, dynamic>? context]) {
    final performanceData = <String, dynamic>{
      'operation': operation,
      'durationMs': duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (context != null) {
      final sanitizedContext = HealthcareLogSanitizer.sanitizeData(context);
      performanceData.addAll(sanitizedContext);
    }

    instance.info('[PERFORMANCE] $operation completed', performanceData);
  }

  /// Clean up resources
  static void dispose() {
    _instance?.cleanHistory();
    _initialized = false;
    _instance = null;
  }

  /// Get current log history (sanitized)
  static List<TalkerData> getHistory() {
    return instance.history.map((log) {
      final sanitizedMessage = HealthcareLogSanitizer.sanitizeMessage(log.message ?? '');
      return TalkerLog(sanitizedMessage, title: log.title, time: log.time, logLevel: log.logLevel);
    }).toList();
  }

  /// Clear log history
  static void clearHistory() {
    instance.cleanHistory();
  }
}
