import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'dart:io';

/// Enhanced logging service with multiple outputs and filtering
class AppLogger {
  static AppLogger? _instance;
  late final Logger _logger;
  late final String _loggerName;

  AppLogger._internal(this._loggerName);

  /// Factory constructor for creating named logger instances
  factory AppLogger([String name = 'CareCircle']) {
    _instance ??= AppLogger._internal(name);
    return _instance!;
  }

  /// Initialize logger with custom configuration
  void initialize({
    LogLevel level = LogLevel.info,
    bool isDevelopment = kDebugMode,
    bool enableFileLogging = false,
    String? logFilePath,
  }) {
    final outputs = <LogOutput>[
      ConsoleOutput(),
    ];

    // Add file output in production or when explicitly enabled
    if (enableFileLogging || !isDevelopment) {
      if (logFilePath != null) {
        outputs.add(FileOutput(file: File(logFilePath)));
      }
    }

    _logger = Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(
        methodCount: isDevelopment ? 3 : 1,
        errorMethodCount: isDevelopment ? 8 : 3,
        lineLength: 120,
        colors: isDevelopment,
        printEmojis: isDevelopment,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        excludeBox: {
          Level.trace: true,
          Level.debug: !isDevelopment,
        },
      ),
      output: MultiOutput(outputs),
      level: _mapLogLevel(level),
    );

    info('Logger initialized for $_loggerName');
  }

  /// Map custom log level to logger level
  Level _mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return Level.trace;
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.fatal:
        return Level.fatal;
    }
  }

  /// Log trace messages (most verbose)
  void trace(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.t(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log debug messages
  void debug(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.d(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log info messages
  void info(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.i(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.w(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.e(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log fatal messages (most severe)
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    _logger.f(_formatMessage(message, data),
        error: error, stackTrace: stackTrace);
  }

  /// Log API request
  void apiRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) {
    if (kDebugMode) {
      final logData = <String, dynamic>{
        'method': method,
        'endpoint': endpoint,
        if (headers != null) 'headers': headers,
        if (body != null) 'body': body,
        if (queryParams != null) 'queryParams': queryParams,
      };

      debug('API Request: $method $endpoint', data: logData);
    }
  }

  /// Log API response
  void apiResponse(
    String method,
    String endpoint,
    int statusCode, {
    dynamic body,
    Map<String, dynamic>? headers,
    Duration? duration,
  }) {
    final logData = <String, dynamic>{
      'method': method,
      'endpoint': endpoint,
      'statusCode': statusCode,
      if (headers != null) 'headers': headers,
      if (body != null) 'body': body,
      if (duration != null) 'duration': '${duration.inMilliseconds}ms',
    };

    if (statusCode >= 200 && statusCode < 300) {
      debug('API Response: $method $endpoint [$statusCode]', data: logData);
    } else if (statusCode >= 400) {
      error('API Error: $method $endpoint [$statusCode]', data: logData);
    } else {
      info('API Response: $method $endpoint [$statusCode]', data: logData);
    }
  }

  /// Log navigation events
  void navigation(String route, {Map<String, dynamic>? params}) {
    final logData = <String, dynamic>{
      'route': route,
      if (params != null) 'params': params,
    };

    debug('Navigation: $route', data: logData);
  }

  /// Log user actions
  void userAction(String action, {Map<String, dynamic>? details}) {
    final logData = <String, dynamic>{
      'action': action,
      if (details != null) 'details': details,
    };

    info('User Action: $action', data: logData);
  }

  /// Log performance metrics
  void performance(String operation, Duration duration,
      {Map<String, dynamic>? metrics}) {
    final logData = <String, dynamic>{
      'operation': operation,
      'duration': '${duration.inMilliseconds}ms',
      if (metrics != null) ...metrics,
    };

    info('Performance: $operation took ${duration.inMilliseconds}ms',
        data: logData);
  }

  /// Format message with additional data
  String _formatMessage(String message, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return message;
    }

    final dataString =
        data.entries.map((e) => '${e.key}: ${e.value}').join(', ');

    return '$message | $dataString';
  }

  /// Close logger and cleanup resources
  void dispose() {
    _logger.close();
  }
}

/// Custom log levels
enum LogLevel {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Custom logger filter for production
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return true;
    }

    // In production, only log warnings and above
    return event.level.index >= Level.warning.index;
  }
}

/// File output for logger
class FileOutput extends LogOutput {
  final File file;

  FileOutput({required this.file});

  @override
  void output(OutputEvent event) {
    if (file.existsSync()) {
      file.writeAsStringSync(
        '${event.lines.join('\n')}\n',
        mode: FileMode.append,
      );
    }
  }
}
