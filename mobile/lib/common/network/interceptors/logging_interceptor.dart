import 'package:dio/dio.dart';
import '../../logging/app_logger.dart';

/// Logging interceptor for API requests and responses
class LoggingInterceptor extends Interceptor {
  final AppLogger _logger;

  LoggingInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    options.extra['request_start_time'] = startTime;

    _logger.apiRequest(
      options.method,
      options.path,
      headers: _sanitizeHeaders(options.headers),
      body: _sanitizeBody(options.data),
      queryParams: options.queryParameters,
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime =
        response.requestOptions.extra['request_start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    _logger.apiResponse(
      response.requestOptions.method,
      response.requestOptions.path,
      response.statusCode ?? 0,
      body: _sanitizeBody(response.data),
      headers: _sanitizeHeaders(response.headers.map),
      duration: duration,
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime =
        err.requestOptions.extra['request_start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    _logger.apiResponse(
      err.requestOptions.method,
      err.requestOptions.path,
      err.response?.statusCode ?? 0,
      body: _sanitizeBody(err.response?.data),
      headers: _sanitizeHeaders(
          err.response?.headers.map.cast<String, dynamic>() ?? {}),
      duration: duration,
    );

    handler.next(err);
  }

  /// Sanitize headers by removing sensitive information
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    // Remove sensitive headers
    const sensitiveHeaders = [
      'authorization',
      'cookie',
      'x-api-key',
      'x-auth-token',
    ];

    for (final header in sensitiveHeaders) {
      if (sanitized.containsKey(header)) {
        sanitized[header] = '***';
      }
      if (sanitized.containsKey(header.toLowerCase())) {
        sanitized[header.toLowerCase()] = '***';
      }
    }

    return sanitized;
  }

  /// Sanitize request/response body by removing sensitive information
  dynamic _sanitizeBody(dynamic body) {
    if (body == null) return null;

    if (body is Map<String, dynamic>) {
      final sanitized = Map<String, dynamic>.from(body);

      // Remove sensitive fields
      const sensitiveFields = [
        'password',
        'token',
        'refresh_token',
        'access_token',
        'api_key',
        'secret',
        'private_key',
        'ssn',
        'social_security_number',
        'credit_card',
        'card_number',
        'cvv',
        'pin',
      ];

      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '***';
        }
      }

      return sanitized;
    }

    // For non-map bodies, return as is (could be enhanced further)
    return body;
  }
}
