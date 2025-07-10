import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'healthcare_log_sanitizer.dart';

/// Healthcare-compliant Talker observer that ensures all logs are sanitized
/// and comply with HIPAA and healthcare privacy regulations
class HealthcareTalkerObserver extends TalkerObserver {
  /// Create a healthcare-compliant Talker observer
  const HealthcareTalkerObserver();

  @override
  void onLog(TalkerData log) {
    // Sanitize the log message before processing
    final sanitizedMessage = HealthcareLogSanitizer.sanitizeMessage(
      log.message ?? '',
    );

    // Create sanitized log data
    final sanitizedLog = _createSanitizedLog(log, sanitizedMessage);

    // Only process in debug mode or for critical logs
    if (kDebugMode || _isCriticalLog(log)) {
      super.onLog(sanitizedLog);
    }
  }

  @override
  void onError(TalkerError err) {
    // Sanitize error message and stack trace
    final sanitizedMessage = HealthcareLogSanitizer.sanitizeMessage(
      err.message ?? '',
    );
    final sanitizedStackTrace = _sanitizeStackTrace(err.stackTrace);

    // Create sanitized error
    final sanitizedError = TalkerError(
      err.error is Error ? err.error as Error : Error(),
      stackTrace: sanitizedStackTrace,
      message: sanitizedMessage,
      title: err.title,
    );

    super.onError(sanitizedError);
  }

  @override
  void onException(TalkerException err) {
    // Sanitize exception message and stack trace
    final sanitizedMessage = HealthcareLogSanitizer.sanitizeMessage(
      err.message ?? '',
    );
    final sanitizedStackTrace = _sanitizeStackTrace(err.stackTrace);

    // Create sanitized exception
    final sanitizedException = TalkerException(
      err.exception is Exception
          ? err.exception as Exception
          : Exception('Unknown exception'),
      stackTrace: sanitizedStackTrace,
      message: sanitizedMessage,
      title: err.title,
    );

    super.onException(sanitizedException);
  }

  /// Create a sanitized version of TalkerData
  TalkerData _createSanitizedLog(TalkerData original, String sanitizedMessage) {
    return TalkerLog(
      sanitizedMessage,
      title: original.title,
      logLevel: original.logLevel,
    );
  }

  /// Check if a log is critical and should always be processed
  bool _isCriticalLog(TalkerData log) {
    return log.logLevel == LogLevel.error ||
        log.logLevel == LogLevel.critical ||
        log.title?.toLowerCase().contains('security') == true ||
        log.title?.toLowerCase().contains('compliance') == true;
  }

  /// Sanitize stack trace to remove sensitive information
  StackTrace? _sanitizeStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return null;

    final stackTraceString = stackTrace.toString();
    final sanitizedStackTrace = HealthcareLogSanitizer.sanitizeMessage(
      stackTraceString,
    );

    // Return a custom stack trace with sanitized content
    return _SanitizedStackTrace(sanitizedStackTrace);
  }
}

/// Custom stack trace implementation for sanitized stack traces
class _SanitizedStackTrace implements StackTrace {
  final String _sanitizedTrace;

  const _SanitizedStackTrace(this._sanitizedTrace);

  @override
  String toString() => _sanitizedTrace;
}

/// Context-aware Talker observer for bounded contexts
class ContextualTalkerObserver extends HealthcareTalkerObserver {
  final String context;
  final TalkerObserver? parentObserver;

  const ContextualTalkerObserver(this.context, this.parentObserver);

  @override
  void onLog(TalkerData log) {
    // Add context information to all logs
    final contextualMessage = '[$context] ${log.message}';
    final contextualLog = _createContextualLog(log, contextualMessage);

    // Process with healthcare sanitization
    super.onLog(contextualLog);

    // Forward to parent observer if available
    parentObserver?.onLog(contextualLog);
  }

  @override
  void onError(TalkerError err) {
    // Add context to error
    final contextualMessage = '[$context] ${err.message ?? ''}';
    final contextualError = TalkerError(
      err.error is Error ? err.error as Error : Error(),
      stackTrace: err.stackTrace,
      message: contextualMessage,
      title: err.title,
    );

    // Process with healthcare sanitization
    super.onError(contextualError);

    // Forward to parent observer if available
    parentObserver?.onError(contextualError);
  }

  @override
  void onException(TalkerException err) {
    // Add context to exception
    final contextualMessage = '[$context] ${err.message ?? ''}';
    final contextualException = TalkerException(
      err.exception is Exception
          ? err.exception as Exception
          : Exception('Unknown exception'),
      stackTrace: err.stackTrace,
      message: contextualMessage,
      title: err.title,
    );

    // Process with healthcare sanitization
    super.onException(contextualException);

    // Forward to parent observer if available
    parentObserver?.onException(contextualException);
  }

  /// Create a contextual log with context information
  TalkerData _createContextualLog(
    TalkerData original,
    String contextualMessage,
  ) {
    return TalkerLog(
      contextualMessage,
      title: original.title,
      logLevel: original.logLevel,
    );
  }
}

/// Performance monitoring observer for healthcare applications
class PerformanceTalkerObserver extends HealthcareTalkerObserver {
  final Map<String, DateTime> _operationStartTimes = {};

  /// Start timing an operation
  void startOperation(String operationId) {
    _operationStartTimes[operationId] = DateTime.now();
  }

  /// End timing an operation and log the duration
  void endOperation(String operationId, {String? context}) {
    final startTime = _operationStartTimes.remove(operationId);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final contextPrefix = context != null ? '[$context] ' : '';

      final performanceLog = TalkerLog(
        '${contextPrefix}Operation "$operationId" completed in ${duration.inMilliseconds}ms',
        title: 'PERFORMANCE',
        logLevel: LogLevel.info,
      );

      onLog(performanceLog);
    }
  }

  /// Log memory usage information
  void logMemoryUsage(String context) {
    // This would require additional memory profiling packages
    // For now, we'll log a placeholder
    final memoryLog = TalkerLog(
      '[$context] Memory usage check',
      title: 'PERFORMANCE',
      logLevel: LogLevel.debug,
    );

    onLog(memoryLog);
  }
}
