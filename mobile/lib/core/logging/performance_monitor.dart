import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'bounded_context_loggers.dart';

/// Healthcare-compliant performance monitoring system
///
/// This class provides comprehensive performance tracking for the CareCircle
/// mobile application, focusing on healthcare-critical operations and user experience.
class PerformanceMonitor {
  static final _logger = BoundedContextLoggers.performance;
  static final Map<String, DateTime> _operationStartTimes = {};
  static final Map<String, List<Duration>> _operationHistory = {};
  static Timer? _memoryMonitorTimer;
  static Timer? _performanceReportTimer;

  /// Initialize performance monitoring
  static void initialize() {
    _logger.info('Performance monitoring initialized', {
      'platform': Platform.operatingSystem,
      'isDebugMode': kDebugMode,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Start periodic monitoring in debug mode
    if (kDebugMode) {
      _startPeriodicMonitoring();
    }
  }

  /// Start timing an operation
  static void startOperation(
    String operationId, {
    Map<String, dynamic>? context,
  }) {
    _operationStartTimes[operationId] = DateTime.now();

    _logger.logPerformanceMetric('Operation started', Duration.zero, {
      'operationId': operationId,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// End timing an operation and log performance metrics
  static Duration endOperation(
    String operationId, {
    Map<String, dynamic>? context,
  }) {
    final startTime = _operationStartTimes.remove(operationId);
    if (startTime == null) {
      _logger.warning('Operation end called without start', {
        'operationId': operationId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return Duration.zero;
    }

    final duration = DateTime.now().difference(startTime);

    // Store in history for analysis
    _operationHistory.putIfAbsent(operationId, () => []).add(duration);

    // Keep only last 100 measurements per operation
    if (_operationHistory[operationId]!.length > 100) {
      _operationHistory[operationId]!.removeAt(0);
    }

    // Log performance metric
    _logger.logPerformanceMetric('Operation completed', duration, {
      'operationId': operationId,
      'durationMs': duration.inMilliseconds,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Check for performance issues
    _checkPerformanceThresholds(operationId, duration);

    return duration;
  }

  /// Time a future operation
  static Future<T> timeOperation<T>(
    String operationId,
    Future<T> Function() operation, {
    Map<String, dynamic>? context,
  }) async {
    startOperation(operationId, context: context);

    try {
      final result = await operation();
      endOperation(operationId, context: context);
      return result;
    } catch (e) {
      endOperation(operationId, context: {...?context, 'error': e.toString()});
      rethrow;
    }
  }

  /// Time a synchronous operation
  static T timeSync<T>(
    String operationId,
    T Function() operation, {
    Map<String, dynamic>? context,
  }) {
    startOperation(operationId, context: context);

    try {
      final result = operation();
      endOperation(operationId, context: context);
      return result;
    } catch (e) {
      endOperation(operationId, context: {...?context, 'error': e.toString()});
      rethrow;
    }
  }

  /// Log API call performance
  static void logApiCall(
    String endpoint,
    String method,
    Duration duration,
    int statusCode, {
    Map<String, dynamic>? context,
  }) {
    _logger.logPerformanceMetric('API call completed', duration, {
      'endpoint': endpoint,
      'method': method,
      'statusCode': statusCode,
      'durationMs': duration.inMilliseconds,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Check for slow API calls
    if (duration.inMilliseconds > 5000) {
      _logger.warning('Slow API call detected', {
        'endpoint': endpoint,
        'method': method,
        'durationMs': duration.inMilliseconds,
        'statusCode': statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Log screen rendering performance
  static void logScreenRender(String screenName, Duration renderTime) {
    _logger.logPerformanceMetric('Screen render completed', renderTime, {
      'screenName': screenName,
      'renderTimeMs': renderTime.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Check for slow screen renders
    if (renderTime.inMilliseconds > 1000) {
      _logger.warning('Slow screen render detected', {
        'screenName': screenName,
        'renderTimeMs': renderTime.inMilliseconds,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Log database operation performance
  static void logDatabaseOperation(
    String operation,
    String table,
    Duration duration, {
    int? recordCount,
    Map<String, dynamic>? context,
  }) {
    _logger.logPerformanceMetric('Database operation completed', duration, {
      'operation': operation,
      'table': table,
      'durationMs': duration.inMilliseconds,
      'recordCount': recordCount,
      'context': context ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Get performance statistics for an operation
  static Map<String, dynamic> getOperationStats(String operationId) {
    final history = _operationHistory[operationId];
    if (history == null || history.isEmpty) {
      return {'error': 'No data available for operation: $operationId'};
    }

    final durations = history.map((d) => d.inMilliseconds).toList();
    durations.sort();

    final count = durations.length;
    final sum = durations.reduce((a, b) => a + b);
    final average = sum / count;
    final median = count % 2 == 0
        ? (durations[count ~/ 2 - 1] + durations[count ~/ 2]) / 2
        : durations[count ~/ 2].toDouble();
    final min = durations.first;
    final max = durations.last;
    final p95 = durations[(count * 0.95).floor()];

    return {
      'operationId': operationId,
      'count': count,
      'averageMs': average.round(),
      'medianMs': median.round(),
      'minMs': min,
      'maxMs': max,
      'p95Ms': p95,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Get all performance statistics
  static Map<String, dynamic> getAllStats() {
    final stats = <String, dynamic>{};

    for (final operationId in _operationHistory.keys) {
      stats[operationId] = getOperationStats(operationId);
    }

    return {
      'operations': stats,
      'totalOperations': _operationHistory.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Start periodic monitoring
  static void _startPeriodicMonitoring() {
    // Memory monitoring every 30 seconds
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _logMemoryUsage();
    });

    // Performance report every 5 minutes
    _performanceReportTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _generatePerformanceReport();
    });
  }

  /// Log current memory usage
  static void _logMemoryUsage() {
    // This is a simplified memory logging - in production you might want
    // to use more sophisticated memory profiling tools
    _logger.info('Memory usage check', {
      'timestamp': DateTime.now().toIso8601String(),
      'note': 'Memory profiling requires additional tools in production',
    });
  }

  /// Generate periodic performance report
  static void _generatePerformanceReport() {
    final stats = getAllStats();

    _logger.info('Performance report generated', {
      'totalOperations': stats['totalOperations'],
      'reportTimestamp': DateTime.now().toIso8601String(),
    });

    // Log top 5 slowest operations
    final operations = stats['operations'] as Map<String, dynamic>;
    final sortedOps = operations.entries.toList()
      ..sort(
        (a, b) => (b.value['averageMs'] as int).compareTo(
          a.value['averageMs'] as int,
        ),
      );

    final top5 = sortedOps
        .take(5)
        .map(
          (e) => {
            'operation': e.key,
            'averageMs': e.value['averageMs'],
            'count': e.value['count'],
          },
        )
        .toList();

    if (top5.isNotEmpty) {
      _logger.info('Top 5 slowest operations', {
        'operations': top5,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Check performance thresholds and alert if exceeded
  static void _checkPerformanceThresholds(
    String operationId,
    Duration duration,
  ) {
    final thresholds = <String, int>{
      'api_call': 5000,
      'database_query': 1000,
      'screen_render': 1000,
      'auth_operation': 3000,
      'health_data_sync': 10000,
    };

    for (final entry in thresholds.entries) {
      if (operationId.contains(entry.key) &&
          duration.inMilliseconds > entry.value) {
        _logger.warning('Performance threshold exceeded', {
          'operationId': operationId,
          'durationMs': duration.inMilliseconds,
          'thresholdMs': entry.value,
          'category': entry.key,
          'timestamp': DateTime.now().toIso8601String(),
        });
        break;
      }
    }
  }

  /// Dispose of performance monitoring resources
  static void dispose() {
    _memoryMonitorTimer?.cancel();
    _performanceReportTimer?.cancel();
    _operationStartTimes.clear();
    _operationHistory.clear();

    _logger.info('Performance monitoring disposed', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
