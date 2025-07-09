import 'package:dio/dio.dart';
import '../logging/performance_monitor.dart';
import '../logging/bounded_context_loggers.dart';

/// Performance monitoring interceptor for Dio HTTP client
/// 
/// This interceptor automatically tracks API call performance and logs
/// metrics for healthcare-critical operations.
class PerformanceDioInterceptor extends Interceptor {
  static final _logger = BoundedContextLoggers.performance;
  final Map<RequestOptions, DateTime> _requestStartTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Record request start time
    _requestStartTimes[options] = DateTime.now();
    
    // Log request initiation
    _logger.info('API request initiated', {
      'method': options.method,
      'path': options.path,
      'hasData': options.data != null,
      'hasQueryParams': options.queryParameters.isNotEmpty,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Start performance monitoring
    final operationId = 'api_call_${options.method}_${_sanitizePath(options.path)}';
    PerformanceMonitor.startOperation(operationId, context: {
      'method': options.method,
      'path': options.path,
      'baseUrl': options.baseUrl,
    });

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _requestStartTimes.remove(response.requestOptions);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final options = response.requestOptions;
      
      // Log API call performance
      PerformanceMonitor.logApiCall(
        options.path,
        options.method,
        duration,
        response.statusCode ?? 0,
        context: {
          'responseSize': _getResponseSize(response),
          'contentType': response.headers.value('content-type'),
        },
      );

      // End performance monitoring
      final operationId = 'api_call_${options.method}_${_sanitizePath(options.path)}';
      PerformanceMonitor.endOperation(operationId, context: {
        'statusCode': response.statusCode,
        'success': true,
        'responseSize': _getResponseSize(response),
      });

      // Log successful response
      _logger.info('API request completed', {
        'method': options.method,
        'path': options.path,
        'statusCode': response.statusCode,
        'durationMs': duration.inMilliseconds,
        'responseSize': _getResponseSize(response),
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Check for slow requests
      if (duration.inMilliseconds > 3000) {
        _logger.warning('Slow API request detected', {
          'method': options.method,
          'path': options.path,
          'durationMs': duration.inMilliseconds,
          'statusCode': response.statusCode,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _requestStartTimes.remove(err.requestOptions);
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      final options = err.requestOptions;
      
      // Log API call error performance
      PerformanceMonitor.logApiCall(
        options.path,
        options.method,
        duration,
        err.response?.statusCode ?? 0,
        context: {
          'error': err.type.name,
          'errorMessage': err.message,
        },
      );

      // End performance monitoring with error context
      final operationId = 'api_call_${options.method}_${_sanitizePath(options.path)}';
      PerformanceMonitor.endOperation(operationId, context: {
        'statusCode': err.response?.statusCode ?? 0,
        'success': false,
        'error': err.type.name,
        'errorMessage': err.message,
      });

      // Log error details
      _logger.error('API request failed', {
        'method': options.method,
        'path': options.path,
        'errorType': err.type.name,
        'statusCode': err.response?.statusCode,
        'durationMs': duration.inMilliseconds,
        'errorMessage': err.message,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Log timeout errors specifically
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        _logger.warning('API timeout detected', {
          'method': options.method,
          'path': options.path,
          'timeoutType': err.type.name,
          'durationMs': duration.inMilliseconds,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    }

    handler.next(err);
  }

  /// Sanitize path for operation ID (remove dynamic segments)
  String _sanitizePath(String path) {
    return path
        .replaceAll(RegExp(r'/[0-9a-f-]{36}'), '/{id}') // UUIDs
        .replaceAll(RegExp(r'/\d+'), '/{id}') // Numeric IDs
        .replaceAll('/', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
  }

  /// Get response size for logging
  int _getResponseSize(Response response) {
    if (response.data is String) {
      return (response.data as String).length;
    } else if (response.data is List) {
      return (response.data as List).length;
    } else if (response.data is Map) {
      return (response.data as Map).length;
    }
    return 0;
  }
}

/// Healthcare-specific API performance analyzer
class HealthcareApiPerformanceAnalyzer {
  static final _logger = BoundedContextLoggers.performance;

  /// Analyze API performance patterns for healthcare operations
  static void analyzeHealthcareApiPerformance() {
    final stats = PerformanceMonitor.getAllStats();
    final operations = stats['operations'] as Map<String, dynamic>;

    // Analyze healthcare-critical endpoints
    final healthcareEndpoints = operations.entries.where((entry) =>
        entry.key.contains('health_data') ||
        entry.key.contains('medication') ||
        entry.key.contains('auth') ||
        entry.key.contains('ai_assistant'));

    if (healthcareEndpoints.isEmpty) {
      _logger.info('No healthcare API performance data available', {
        'timestamp': DateTime.now().toIso8601String(),
      });
      return;
    }

    final analysis = <String, dynamic>{};
    
    for (final endpoint in healthcareEndpoints) {
      final endpointStats = endpoint.value as Map<String, dynamic>;
      final averageMs = endpointStats['averageMs'] as int;
      final p95Ms = endpointStats['p95Ms'] as int;
      final count = endpointStats['count'] as int;

      // Categorize performance
      String performanceCategory;
      if (averageMs < 500) {
        performanceCategory = 'excellent';
      } else if (averageMs < 1000) {
        performanceCategory = 'good';
      } else if (averageMs < 2000) {
        performanceCategory = 'fair';
      } else {
        performanceCategory = 'poor';
      }

      analysis[endpoint.key] = {
        'averageMs': averageMs,
        'p95Ms': p95Ms,
        'count': count,
        'category': performanceCategory,
        'needsOptimization': averageMs > 1000 || p95Ms > 2000,
      };
    }

    _logger.info('Healthcare API performance analysis', {
      'analysis': analysis,
      'totalEndpoints': analysis.length,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Identify endpoints needing optimization
    final needsOptimization = analysis.entries
        .where((entry) => entry.value['needsOptimization'] == true)
        .map((entry) => {
          'endpoint': entry.key,
          'averageMs': entry.value['averageMs'],
          'p95Ms': entry.value['p95Ms'],
        })
        .toList();

    if (needsOptimization.isNotEmpty) {
      _logger.warning('Healthcare endpoints needing optimization', {
        'endpoints': needsOptimization,
        'count': needsOptimization.length,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Generate healthcare performance report
  static Map<String, dynamic> generateHealthcarePerformanceReport() {
    final stats = PerformanceMonitor.getAllStats();
    final operations = stats['operations'] as Map<String, dynamic>;

    // Filter healthcare operations
    final healthcareOps = <String, dynamic>{};
    for (final entry in operations.entries) {
      if (_isHealthcareOperation(entry.key)) {
        healthcareOps[entry.key] = entry.value;
      }
    }

    // Calculate overall healthcare API health
    if (healthcareOps.isEmpty) {
      return {
        'status': 'no_data',
        'message': 'No healthcare API performance data available',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    final averages = healthcareOps.values
        .map((op) => op['averageMs'] as int)
        .toList();
    
    final overallAverage = averages.reduce((a, b) => a + b) / averages.length;
    
    String healthStatus;
    if (overallAverage < 800) {
      healthStatus = 'healthy';
    } else if (overallAverage < 1500) {
      healthStatus = 'warning';
    } else {
      healthStatus = 'critical';
    }

    return {
      'status': healthStatus,
      'overallAverageMs': overallAverage.round(),
      'totalOperations': healthcareOps.length,
      'operations': healthcareOps,
      'recommendations': _generateRecommendations(healthcareOps),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Check if operation is healthcare-related
  static bool _isHealthcareOperation(String operationId) {
    final healthcareKeywords = [
      'health_data',
      'medication',
      'auth',
      'ai_assistant',
      'care_group',
      'notification',
      'profile',
      'vitals',
      'prescription',
    ];

    return healthcareKeywords.any((keyword) => operationId.contains(keyword));
  }

  /// Generate performance optimization recommendations
  static List<String> _generateRecommendations(Map<String, dynamic> operations) {
    final recommendations = <String>[];

    for (final entry in operations.entries) {
      final stats = entry.value as Map<String, dynamic>;
      final averageMs = stats['averageMs'] as int;
      final operationId = entry.key;

      if (averageMs > 2000) {
        recommendations.add('Optimize $operationId - average response time ${averageMs}ms is too high');
      } else if (averageMs > 1000) {
        recommendations.add('Monitor $operationId - response time ${averageMs}ms could be improved');
      }
    }

    if (recommendations.isEmpty) {
      recommendations.add('All healthcare APIs are performing within acceptable limits');
    }

    return recommendations;
  }
}
