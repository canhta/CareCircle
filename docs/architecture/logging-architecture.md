# CareCircle Mobile Logging Architecture

## Overview

This document defines the comprehensive logging strategy for the CareCircle mobile application, ensuring healthcare compliance, debugging efficiency, and production monitoring capabilities.

## Logging Strategy

### Core Principles

1. **Healthcare Compliance**: All logging must comply with HIPAA and healthcare data privacy regulations
2. **Privacy by Design**: No PII/PHI data should ever appear in logs without explicit sanitization
3. **Structured Logging**: Consistent, machine-readable log formats across all bounded contexts
4. **Performance Aware**: Logging should not impact application performance or user experience
5. **Development Friendly**: Rich debugging information during development with beautiful console output

### Architecture Components

#### 1. Core Logging Infrastructure

**Primary Package**: `talker_flutter` (v4.8.3+)

- **Healthcare Compliance**: Advanced filtering and sanitization capabilities for PII/PHI protection
- **Flutter Integration**: Built-in UI components (TalkerScreen), route observers, and development tools
- **Performance**: Lightweight with async logging, memory management, and background isolates
- **Error Handling**: Comprehensive exception tracking with Firebase Crashlytics integration
- **Development Tools**: Beautiful console output, log viewer UI, and real-time debugging
- **Production Ready**: File output, log rotation, and monitoring service integration

**Secondary Package**: `logger` (v2.4.0+)

- **Lightweight**: Minimal performance impact for basic logging needs
- **Flexible**: Highly configurable filters, printers, and outputs
- **Healthcare-Ready**: Custom filtering capabilities for sensitive data protection
- **Structured Logging**: JSON output support for log aggregation services

#### 2. Healthcare-Specific Components

**Talker-Based Implementation:**

```dart
// Healthcare-compliant Talker configuration
class HealthcareTalkerConfig {
  static Talker createHealthcareTalker() {
    return TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: AppConfig.enableLogging,
        useConsoleLogs: AppConfig.environment == 'development',
        maxHistoryItems: AppConfig.environment == 'production' ? 100 : 500,
        titles: _getHealthcareLogTitles(),
        colors: _getHealthcareLogColors(),
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          level: _getLogLevel(),
          enableColors: AppConfig.environment == 'development',
        ),
        formatter: HealthcareLogFormatter(),
        output: MultiOutput([
          ConsoleOutput(),
          if (AppConfig.environment != 'development') FileOutput(),
          if (AppConfig.environment == 'production') AuditOutput(),
        ]),
      ),
      observer: HealthcareTalkerObserver(),
    );
  }
}

// PII/PHI data sanitization for healthcare compliance
class HealthcareLogSanitizer {
  static const _sensitivePatterns = [
    // Personal identifiers
    r'\b\d{3}-\d{2}-\d{4}\b', // SSN pattern
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', // Email pattern
    r'\b\d{3}-\d{3}-\d{4}\b', // Phone pattern
    // Medical data patterns
    r'\b(blood pressure|bp):\s*\d+/\d+\b',
    r'\b(heart rate|hr):\s*\d+\b',
    r'\b(weight):\s*\d+(\.\d+)?\s*(lbs?|kg)\b',
  ];

  static const _sensitiveFields = [
    'email', 'phone', 'ssn', 'medicalRecordNumber', 'patientId',
    'bloodPressure', 'heartRate', 'weight', 'height', 'bmi',
    'medications', 'diagnoses', 'symptoms', 'allergies', 'conditions',
    'prescriptions', 'dosage', 'frequency', 'notes', 'observations'
  ];

  static String sanitizeMessage(String message) {
    String sanitized = message;

    // Remove sensitive patterns using regex
    for (final pattern in _sensitivePatterns) {
      sanitized = sanitized.replaceAll(RegExp(pattern, caseSensitive: false), '[REDACTED]');
    }

    return sanitized;
  }

  static Map<String, dynamic> sanitizeData(Map<String, dynamic> data) {
    final sanitized = <String, dynamic>{};

    for (final entry in data.entries) {
      if (_sensitiveFields.contains(entry.key.toLowerCase())) {
        sanitized[entry.key] = '[REDACTED]';
      } else if (entry.value is Map<String, dynamic>) {
        sanitized[entry.key] = sanitizeData(entry.value);
      } else if (entry.value is String) {
        sanitized[entry.key] = sanitizeMessage(entry.value);
      } else {
        sanitized[entry.key] = entry.value;
      }
    }

    return sanitized;
  }
}
```

#### 3. Bounded Context Loggers

Each DDD bounded context maintains its own Talker instance with context-specific configuration:

```dart
class BoundedContextLoggers {
  static late final Talker _mainTalker;

  // Initialize all loggers with shared healthcare configuration
  static void initialize() {
    _mainTalker = HealthcareTalkerConfig.createHealthcareTalker();
  }

  // Bounded context-specific loggers
  static Talker get auth => _createContextLogger('AUTH');
  static Talker get aiAssistant => _createContextLogger('AI_ASSISTANT');
  static Talker get healthData => _createContextLogger('HEALTH_DATA');
  static Talker get medication => _createContextLogger('MEDICATION');
  static Talker get careGroup => _createContextLogger('CARE_GROUP');
  static Talker get notification => _createContextLogger('NOTIFICATION');

  static Talker _createContextLogger(String context) {
    return Talker(
      settings: _mainTalker.settings.copyWith(
        titles: {
          ..._mainTalker.settings.titles,
          'context': context,
        },
      ),
      logger: _mainTalker.logger,
      observer: ContextualTalkerObserver(context, _mainTalker.observer),
    );
  }
}

// Context-aware observer for better debugging
class ContextualTalkerObserver extends TalkerObserver {
  final String context;
  final TalkerObserver? parentObserver;

  ContextualTalkerObserver(this.context, this.parentObserver);

  @override
  void onLog(TalkerData log) {
    // Add context information to all logs
    final contextualLog = log.copyWith(
      message: '[$context] ${log.message}',
    );

    parentObserver?.onLog(contextualLog);
  }

  @override
  void onError(TalkerError error) {
    final contextualError = error.copyWith(
      message: '[$context] ${error.message}',
    );

    parentObserver?.onError(contextualError);
  }
}
```

#### 4. Talker Flutter Integration

**Route Observation for Navigation Logging:**

```dart
// Add to MaterialApp for automatic route logging
MaterialApp.router(
  routerConfig: router,
  navigatorObservers: [
    TalkerRouteObserver(BoundedContextLoggers.navigation),
  ],
);
```

**Development UI Integration:**

```dart
// Add Talker screen for development debugging
class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      talker: BoundedContextLoggers._mainTalker,
      theme: TalkerScreenTheme(
        logColors: {
          TalkerLogType.error.key: CareCircleDesignTokens.criticalAlert,
          TalkerLogType.warning.key: CareCircleDesignTokens.warningAlert,
          TalkerLogType.info.key: CareCircleDesignTokens.primaryBlue,
        },
      ),
    );
  }
}
```

**Error Boundary Integration:**

```dart
// Wrap app with TalkerWrapper for global error handling
TalkerWrapper(
  talker: BoundedContextLoggers._mainTalker,
  options: const TalkerWrapperOptions(
    enableErrorAlerts: AppConfig.environment == 'development',
    enableExceptionAlerts: true,
  ),
  child: CareCircleApp(),
);
```

## Log Levels and Usage

### Development Environment

- **TRACE**: Detailed execution flow and variable states
- **DEBUG**: Development debugging information
- **INFO**: General application events and user actions
- **WARNING**: Recoverable errors and performance issues
- **ERROR**: Application errors requiring attention
- **FATAL**: Critical system failures

### Production Environment

- **WARNING**: Recoverable errors and performance issues
- **ERROR**: Application errors requiring attention
- **FATAL**: Critical system failures

## Integration Patterns

### Service Layer Integration

**Talker-Based Service Logging:**

```dart
class AuthService {
  static final _talker = BoundedContextLoggers.auth;

  Future<AuthResponse> loginWithFirebaseToken(String idToken) async {
    _talker.info('Firebase login initiated');

    try {
      final response = await _performFirebaseLogin(idToken);

      // Log success with sanitized data
      _talker.info('Firebase login successful', {
        'userId': response.user.id,
        'method': 'firebase',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return response;
    } catch (e, stackTrace) {
      // Use Talker's handle method for comprehensive error logging
      _talker.handle(e, stackTrace, 'Firebase login failed');

      // Additional context logging
      _talker.error('Login failure details', {
        'method': 'firebase',
        'errorType': e.runtimeType.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      rethrow;
    }
  }

  Future<void> logout() async {
    _talker.info('Logout initiated');

    try {
      await _firebaseAuthService.signOut();
      await clearStoredData();

      _talker.info('Logout completed successfully');
    } catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Logout failed');
      // Continue with local cleanup even if remote logout fails
      await clearStoredData();
    }
  }
}
```

### Provider Layer Integration

**Riverpod with Talker Integration:**

```dart
class AuthNotifier extends StateNotifier<AuthState> {
  static final _talker = BoundedContextLoggers.auth;

  Future<void> signInWithGoogle() async {
    _talker.debug('Google sign-in initiated');

    // Log state transition
    _talker.info('Auth state transition', {
      'from': state.status.name,
      'to': 'loading',
      'action': 'signInWithGoogle',
    });

    state = state.copyWith(status: AuthStatus.loading);

    try {
      final result = await _authService.signInWithGoogle();

      _talker.info('Google sign-in successful', {
        'userId': result.user.id,
        'provider': 'google',
        'userType': result.user.userType.name,
      });

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
      );

      _talker.info('Auth state updated', {
        'status': 'authenticated',
        'hasUser': state.user != null,
      });

    } catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Google sign-in failed');

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );

      _talker.warning('Auth state reset due to error', {
        'status': 'unauthenticated',
        'errorMessage': e.toString(),
      });
    }
  }
}
```

**AI Assistant Service Integration:**

```dart
class AiAssistantServiceImpl extends AiAssistantService {
  static final _talker = BoundedContextLoggers.aiAssistant;

  @override
  Future<SendMessageResponse> sendMessage(
    String conversationId,
    String content,
  ) async {
    // Sanitize message content before logging
    final sanitizedContent = HealthcareLogSanitizer.sanitizeMessage(content);

    _talker.info('AI message send initiated', {
      'conversationId': conversationId,
      'messageLength': content.length,
      'sanitizedPreview': sanitizedContent.substring(0, min(50, sanitizedContent.length)),
    });

    try {
      final request = SendMessageRequest(content: content);
      final response = await _service.sendMessage(conversationId, request);

      _talker.info('AI message sent successfully', {
        'conversationId': conversationId,
        'responseId': response.message.id,
        'responseLength': response.message.content.length,
        'processingTime': response.processingTimeMs,
      });

      return response;
    } catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'AI message send failed');

      _talker.error('AI service error details', {
        'conversationId': conversationId,
        'errorType': e.runtimeType.toString(),
        'isNetworkError': e is DioException,
      });

      throw _handleError(e as DioException);
    }
  }
}
```

## Configuration Management

### Environment-Based Configuration

```dart
class LogConfig {
  static Level get logLevel {
    switch (AppConfig.environment) {
      case 'development':
        return Level.trace;
      case 'staging':
        return Level.debug;
      case 'production':
        return Level.warning;
      default:
        return Level.info;
    }
  }

  static bool get enableFileLogging {
    return AppConfig.environment != 'development';
  }

  static bool get enableConsoleColors {
    return AppConfig.environment == 'development';
  }
}
```

## Healthcare Compliance Requirements

### Data Privacy Protection

- All health-related data must be sanitized before logging
- User identifiers should be anonymized or hashed
- Medication names and dosages must not appear in logs
- Biometric data (heart rate, blood pressure) must be excluded

### Audit Trail Requirements

- Authentication events must be logged with timestamps
- Health data access must be tracked (without content)
- Medication changes must be audited
- Care group modifications must be recorded

### Data Retention Policies

- Development logs: 7 days retention
- Staging logs: 30 days retention
- Production logs: 90 days retention (compliance requirement)
- Audit logs: 7 years retention (healthcare regulation)

## Performance Considerations

### Asynchronous Logging

- Use background isolates for file I/O operations
- Implement log buffering to reduce disk writes
- Batch log entries for network transmission

### Memory Management

- Implement log rotation to prevent disk space issues
- Use circular buffers for in-memory log storage
- Compress archived log files

### Network Efficiency

- Aggregate logs before transmission to monitoring services
- Use compression for log data transfer
- Implement retry logic with exponential backoff

## Monitoring and Alerting

### Critical Error Detection

- Automatic alerting for FATAL level errors
- Performance degradation monitoring
- Authentication failure pattern detection
- Health data synchronization issues

### Development Tools

- Real-time log streaming during development
- Log filtering and search capabilities
- Performance metrics and timing information
- Memory usage tracking

## Implementation Checklist

- [ ] Install logging dependencies (logger, talker_flutter)
- [ ] Create core logging infrastructure
- [ ] Implement healthcare-specific log filtering
- [ ] Setup bounded context loggers
- [ ] Integrate logging across all services
- [ ] Add environment-based configuration
- [ ] Implement log sanitization and privacy protection
- [ ] Setup file output and log rotation
- [ ] Add performance monitoring
- [ ] Create development debugging tools
- [ ] Implement compliance audit logging
- [ ] Add automated testing for logging components

## Security Considerations

### Log Storage Security

- Encrypt log files at rest
- Secure transmission of logs to monitoring services
- Access control for log viewing and analysis
- Regular security audits of logging infrastructure

### Sensitive Data Protection

- Never log authentication tokens or passwords
- Sanitize all user input before logging
- Implement data masking for PII/PHI
- Regular compliance reviews of log content

---

**Note**: This logging architecture must be implemented with careful attention to healthcare compliance requirements. All logging implementations should be reviewed by the compliance team before production deployment.
