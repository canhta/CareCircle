import 'package:firebase_performance/firebase_performance.dart';
import '../common/common.dart';
import '../utils/analytics_service.dart';

/// Service for monitoring app performance and tracking metrics
class PerformanceMonitoringService {
  late final FirebasePerformance _performance;
  late final AnalyticsService _analytics;
  late final AppLogger _logger;

  // Active traces
  final Map<String, Trace> _activeTraces = {};
  final Map<String, HttpMetric> _activeHttpMetrics = {};

  // Performance metrics
  DateTime? _appStartTime;
  final Map<String, DateTime> _screenLoadTimes = {};

  PerformanceMonitoringService({
    required AnalyticsService analytics,
    required AppLogger logger,
  }) {
    _performance = FirebasePerformance.instance;
    _analytics = analytics;
    _logger = logger;
  }

  /// Initialize performance monitoring
  Future<void> initialize() async {
    try {
      _logger.info('Initializing PerformanceMonitoringService...');
      
      // Enable performance collection
      await _performance.setPerformanceCollectionEnabled(true);
      
      // Record app start time
      _appStartTime = DateTime.now();
      
      _logger.info('PerformanceMonitoringService initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize PerformanceMonitoringService', error: e);
      rethrow;
    }
  }

  /// Start a custom trace
  Future<String?> startTrace(String traceName, {Map<String, String>? attributes}) async {
    try {
      if (_activeTraces.containsKey(traceName)) {
        _logger.warning('Trace $traceName is already active');
        return traceName;
      }

      final trace = _performance.newTrace(traceName);
      
      // Add custom attributes
      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value);
        }
      }

      await trace.start();
      _activeTraces[traceName] = trace;

      _logger.info('Started performance trace: $traceName');
      return traceName;
    } catch (e) {
      _logger.error('Failed to start trace: $traceName', error: e);
      return null;
    }
  }

  /// Stop a custom trace
  Future<void> stopTrace(String traceName, {Map<String, int>? metrics}) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace == null) {
        _logger.warning('No active trace found: $traceName');
        return;
      }

      // Add custom metrics
      if (metrics != null) {
        for (final entry in metrics.entries) {
          trace.setMetric(entry.key, entry.value);
        }
      }

      await trace.stop();
      _activeTraces.remove(traceName);

      _logger.info('Stopped performance trace: $traceName');
    } catch (e) {
      _logger.error('Failed to stop trace: $traceName', error: e);
    }
  }

  /// Start HTTP metric tracking
  Future<String?> startHttpMetric(
    String url,
    HttpMethod method, {
    Map<String, String>? attributes,
  }) async {
    try {
      final metricKey = '${method.name}_${url.hashCode}';
      
      if (_activeHttpMetrics.containsKey(metricKey)) {
        _logger.warning('HTTP metric $metricKey is already active');
        return metricKey;
      }

      final httpMetric = _performance.newHttpMetric(url, method);
      
      // Add custom attributes
      if (attributes != null) {
        for (final entry in attributes.entries) {
          httpMetric.putAttribute(entry.key, entry.value);
        }
      }

      await httpMetric.start();
      _activeHttpMetrics[metricKey] = httpMetric;

      _logger.info('Started HTTP metric: $url');
      return metricKey;
    } catch (e) {
      _logger.error('Failed to start HTTP metric: $url', error: e);
      return null;
    }
  }

  /// Stop HTTP metric tracking
  Future<void> stopHttpMetric(
    String metricKey, {
    int? httpResponseCode,
    int? requestPayloadSize,
    int? responsePayloadSize,
    String? responseContentType,
  }) async {
    try {
      final httpMetric = _activeHttpMetrics[metricKey];
      if (httpMetric == null) {
        _logger.warning('No active HTTP metric found: $metricKey');
        return;
      }

      // Set response details
      if (httpResponseCode != null) {
        httpMetric.httpResponseCode = httpResponseCode;
      }
      if (requestPayloadSize != null) {
        httpMetric.requestPayloadSize = requestPayloadSize;
      }
      if (responsePayloadSize != null) {
        httpMetric.responsePayloadSize = responsePayloadSize;
      }
      if (responseContentType != null) {
        httpMetric.responseContentType = responseContentType;
      }

      await httpMetric.stop();
      _activeHttpMetrics.remove(metricKey);

      _logger.info('Stopped HTTP metric: $metricKey');
    } catch (e) {
      _logger.error('Failed to stop HTTP metric: $metricKey', error: e);
    }
  }

  /// Track app startup time
  Future<void> trackAppStartup() async {
    try {
      if (_appStartTime == null) return;

      final startupDuration = DateTime.now().difference(_appStartTime!);
      
      await _analytics.trackPerformanceMetric(
        'app_startup_time',
        startupDuration.inMilliseconds.toDouble(),
        unit: 'ms',
        properties: {
          'startup_duration_ms': startupDuration.inMilliseconds,
          'startup_duration_seconds': startupDuration.inSeconds,
        },
      );

      _logger.info('App startup time tracked: ${startupDuration.inMilliseconds}ms');
    } catch (e) {
      _logger.error('Failed to track app startup time', error: e);
    }
  }

  /// Track screen load time
  Future<void> trackScreenLoad(String screenName) async {
    try {
      final loadTime = DateTime.now();
      _screenLoadTimes[screenName] = loadTime;

      // Start a trace for screen loading
      await startTrace('screen_load_$screenName', attributes: {
        'screen_name': screenName,
      });

      _logger.info('Started tracking screen load: $screenName');
    } catch (e) {
      _logger.error('Failed to track screen load: $screenName', error: e);
    }
  }

  /// Complete screen load tracking
  Future<void> completeScreenLoad(String screenName) async {
    try {
      final startTime = _screenLoadTimes[screenName];
      if (startTime == null) {
        _logger.warning('No screen load start time found for: $screenName');
        return;
      }

      final loadDuration = DateTime.now().difference(startTime);
      
      // Stop the screen load trace
      await stopTrace('screen_load_$screenName', metrics: {
        'load_time_ms': loadDuration.inMilliseconds,
      });

      // Track in analytics
      await _analytics.trackPerformanceMetric(
        'screen_load_time',
        loadDuration.inMilliseconds.toDouble(),
        unit: 'ms',
        properties: {
          'screen_name': screenName,
          'load_duration_ms': loadDuration.inMilliseconds,
        },
      );

      _screenLoadTimes.remove(screenName);
      _logger.info('Screen load completed: $screenName (${loadDuration.inMilliseconds}ms)');
    } catch (e) {
      _logger.error('Failed to complete screen load tracking: $screenName', error: e);
    }
  }

  /// Track database operation performance
  Future<void> trackDatabaseOperation(
    String operation,
    Future<dynamic> Function() databaseCall, {
    String? tableName,
    Map<String, dynamic>? context,
  }) async {
    final traceName = 'db_$operation${tableName != null ? '_$tableName' : ''}';
    
    try {
      // Start trace
      await startTrace(traceName, attributes: {
        'operation': operation,
        if (tableName != null) 'table': tableName,
      });

      final startTime = DateTime.now();
      
      // Execute database operation
      await databaseCall();
      
      final duration = DateTime.now().difference(startTime);
      
      // Stop trace with metrics
      await stopTrace(traceName, metrics: {
        'duration_ms': duration.inMilliseconds,
      });

      // Track in analytics
      await _analytics.trackPerformanceMetric(
        'database_operation',
        duration.inMilliseconds.toDouble(),
        unit: 'ms',
        properties: {
          'operation': operation,
          'table_name': tableName,
          'duration_ms': duration.inMilliseconds,
          if (context != null) ...context,
        },
      );

      _logger.info('Database operation tracked: $operation (${duration.inMilliseconds}ms)');
    } catch (e) {
      // Stop trace even if operation failed
      await stopTrace(traceName);
      
      _logger.error('Database operation failed: $operation', error: e);
      rethrow;
    }
  }

  /// Track API call performance
  Future<T> trackApiCall<T>(
    String endpoint,
    HttpMethod method,
    Future<T> Function() apiCall, {
    Map<String, dynamic>? context,
  }) async {
    String? metricKey;
    
    try {
      // Start HTTP metric
      metricKey = await startHttpMetric(endpoint, method, attributes: {
        'endpoint': endpoint,
        'method': method.name,
      });

      final startTime = DateTime.now();
      
      // Execute API call
      final result = await apiCall();
      
      final duration = DateTime.now().difference(startTime);
      
      // Stop HTTP metric with success
      if (metricKey != null) {
        await stopHttpMetric(metricKey, httpResponseCode: 200);
      }

      // Track in analytics
      await _analytics.trackPerformanceMetric(
        'api_call',
        duration.inMilliseconds.toDouble(),
        unit: 'ms',
        properties: {
          'endpoint': endpoint,
          'method': method.name,
          'duration_ms': duration.inMilliseconds,
          'success': true,
          if (context != null) ...context,
        },
      );

      _logger.info('API call tracked: $endpoint (${duration.inMilliseconds}ms)');
      return result;
    } catch (e) {
      // Stop HTTP metric with error
      if (metricKey != null) {
        await stopHttpMetric(metricKey, httpResponseCode: 500);
      }

      // Track error in analytics
      await _analytics.trackPerformanceMetric(
        'api_call',
        0,
        unit: 'ms',
        properties: {
          'endpoint': endpoint,
          'method': method.name,
          'success': false,
          'error': e.toString(),
          if (context != null) ...context,
        },
      );

      _logger.error('API call failed: $endpoint', error: e);
      rethrow;
    }
  }

  /// Track memory usage
  Future<void> trackMemoryUsage() async {
    try {
      // Note: Actual memory tracking would require platform-specific implementation
      // This is a placeholder for demonstration
      
      await _analytics.trackPerformanceMetric(
        'memory_usage',
        0, // Placeholder value
        unit: 'MB',
        properties: {
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      _logger.info('Memory usage tracked');
    } catch (e) {
      _logger.error('Failed to track memory usage', error: e);
    }
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    return {
      'active_traces': _activeTraces.keys.toList(),
      'active_http_metrics': _activeHttpMetrics.keys.toList(),
      'app_start_time': _appStartTime?.toIso8601String(),
      'pending_screen_loads': _screenLoadTimes.keys.toList(),
    };
  }

  /// Clean up resources
  Future<void> dispose() async {
    try {
      // Stop all active traces
      for (final traceName in _activeTraces.keys.toList()) {
        await stopTrace(traceName);
      }

      // Stop all active HTTP metrics
      for (final metricKey in _activeHttpMetrics.keys.toList()) {
        await stopHttpMetric(metricKey);
      }

      _logger.info('PerformanceMonitoringService disposed');
    } catch (e) {
      _logger.error('Failed to dispose PerformanceMonitoringService', error: e);
    }
  }
}
