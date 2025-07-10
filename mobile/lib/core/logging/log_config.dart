import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../config/app_config.dart';

/// Configuration class for healthcare-compliant logging system
class LogConfig {
  /// Get the appropriate log level based on environment
  static LogLevel get logLevel {
    switch (AppConfig.environment) {
      case 'development':
        return LogLevel.verbose;
      case 'staging':
        return LogLevel.debug;
      case 'production':
        return LogLevel.warning;
      default:
        return LogLevel.info;
    }
  }

  /// Whether to enable file logging
  static bool get enableFileLogging {
    return AppConfig.environment != 'development';
  }

  /// Whether to enable console colors
  static bool get enableConsoleColors {
    return AppConfig.environment == 'development';
  }

  /// Whether to enable detailed stack traces
  static bool get enableStackTraces {
    return AppConfig.environment == 'development';
  }

  /// Maximum number of log entries to keep in memory
  static int get maxHistoryItems {
    switch (AppConfig.environment) {
      case 'development':
        return 1000;
      case 'staging':
        return 500;
      case 'production':
        return 100;
      default:
        return 200;
    }
  }

  /// Whether to enable error alerts in development
  static bool get enableErrorAlerts {
    return AppConfig.environment == 'development';
  }

  /// Whether to enable exception alerts
  static bool get enableExceptionAlerts {
    return true;
  }

  /// Log retention period in days
  static int get logRetentionDays {
    switch (AppConfig.environment) {
      case 'development':
        return 7;
      case 'staging':
        return 30;
      case 'production':
        return 90;
      default:
        return 30;
    }
  }

  /// Healthcare-specific log titles for different contexts
  static Map<String, String> get healthcareLogTitles {
    return {
      'AUTH': '🔐 Auth',
      'AI_ASSISTANT': '🤖 AI Assistant',
      'HEALTH_DATA': '🏥 Health Data',
      'MEDICATION': '💊 Medication',
      'CARE_GROUP': '👥 Care Group',
      'NOTIFICATION': '🔔 Notification',
      'NAVIGATION': '🧭 Navigation',
      'PERFORMANCE': '⚡ Performance',
      'SECURITY': '🛡️ Security',
      'COMPLIANCE': '📋 Compliance',
    };
  }

  /// Healthcare-themed log colors for development
  static Map<String, AnsiPen> get healthcareLogColors {
    return {
      'AUTH': AnsiPen()..blue(),
      'AI_ASSISTANT': AnsiPen()..green(),
      'HEALTH_DATA': AnsiPen()..red(),
      'MEDICATION': AnsiPen()..magenta(),
      'CARE_GROUP': AnsiPen()..cyan(),
      'NOTIFICATION': AnsiPen()..yellow(),
      'NAVIGATION': AnsiPen()..white(),
      'PERFORMANCE': AnsiPen()..gray(),
      'SECURITY': AnsiPen()..red(),
      'COMPLIANCE': AnsiPen()..blue(),
      // Default Talker log types
      TalkerLogType.error.key: AnsiPen()..red(),
      TalkerLogType.warning.key: AnsiPen()..yellow(),
      TalkerLogType.info.key: AnsiPen()..blue(),
      TalkerLogType.debug.key: AnsiPen()..gray(),
      TalkerLogType.verbose.key: AnsiPen()..white(),
      TalkerLogType.critical.key: AnsiPen()..red(),
      'good': AnsiPen()..green(),
    };
  }

  /// Get Talker settings for healthcare compliance
  static TalkerSettings get talkerSettings {
    return TalkerSettings(
      enabled: AppConfig.enableLogging,
      useConsoleLogs: kDebugMode,
      maxHistoryItems: maxHistoryItems,
      titles: healthcareLogTitles,
      colors: healthcareLogColors,
    );
  }

  /// Get Talker logger settings
  static TalkerLoggerSettings get talkerLoggerSettings {
    return TalkerLoggerSettings(
      level: logLevel,
      enableColors: enableConsoleColors,
    );
  }

  /// Get Talker wrapper options
  static TalkerWrapperOptions get talkerWrapperOptions {
    return TalkerWrapperOptions(
      enableErrorAlerts: enableErrorAlerts,
      enableExceptionAlerts: enableExceptionAlerts,
    );
  }
}
