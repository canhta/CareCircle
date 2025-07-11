/// Base exception for all notification-related errors
abstract class NotificationException implements Exception {
  const NotificationException(this.message, {this.code, this.details});

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'NotificationException: $message';
}

/// Network-related notification errors
class NotificationNetworkException extends NotificationException {
  const NotificationNetworkException(
    super.message, {
    super.code,
    super.details,
    this.statusCode,
    this.isRetryable = true,
  });

  final int? statusCode;
  final bool isRetryable;

  @override
  String toString() => 'NotificationNetworkException: $message (Status: $statusCode)';
}

/// Authentication/authorization errors
class NotificationAuthException extends NotificationException {
  const NotificationAuthException(
    super.message, {
    super.code,
    super.details,
    this.requiresReauth = false,
  });

  final bool requiresReauth;

  @override
  String toString() => 'NotificationAuthException: $message';
}

/// Data validation errors
class NotificationValidationException extends NotificationException {
  const NotificationValidationException(
    super.message, {
    super.code,
    super.details,
    this.field,
    this.validationErrors,
  });

  final String? field;
  final List<String>? validationErrors;

  @override
  String toString() => 'NotificationValidationException: $message (Field: $field)';
}

/// Cache-related errors
class NotificationCacheException extends NotificationException {
  const NotificationCacheException(
    super.message, {
    super.code,
    super.details,
    this.cacheKey,
  });

  final String? cacheKey;

  @override
  String toString() => 'NotificationCacheException: $message (Key: $cacheKey)';
}

/// Permission-related errors
class NotificationPermissionException extends NotificationException {
  const NotificationPermissionException(
    super.message, {
    super.code,
    super.details,
    this.permissionType,
    this.canRequestAgain = true,
  });

  final String? permissionType;
  final bool canRequestAgain;

  @override
  String toString() => 'NotificationPermissionException: $message (Type: $permissionType)';
}

/// Emergency alert specific errors
class EmergencyAlertException extends NotificationException {
  const EmergencyAlertException(
    super.message, {
    super.code,
    super.details,
    this.alertId,
    this.severity,
  });

  final String? alertId;
  final String? severity;

  @override
  String toString() => 'EmergencyAlertException: $message (Alert: $alertId)';
}

/// Template processing errors
class NotificationTemplateException extends NotificationException {
  const NotificationTemplateException(
    super.message, {
    super.code,
    super.details,
    this.templateId,
    this.missingVariables,
  });

  final String? templateId;
  final List<String>? missingVariables;

  @override
  String toString() => 'NotificationTemplateException: $message (Template: $templateId)';
}

/// Rate limiting errors
class NotificationRateLimitException extends NotificationException {
  const NotificationRateLimitException(
    super.message, {
    super.code,
    super.details,
    this.retryAfter,
    this.limit,
  });

  final Duration? retryAfter;
  final int? limit;

  @override
  String toString() => 'NotificationRateLimitException: $message (Retry after: $retryAfter)';
}

/// Healthcare compliance errors
class NotificationComplianceException extends NotificationException {
  const NotificationComplianceException(
    super.message, {
    super.code,
    super.details,
    this.complianceType,
    this.requiredAction,
  });

  final String? complianceType;
  final String? requiredAction;

  @override
  String toString() => 'NotificationComplianceException: $message (Type: $complianceType)';
}

/// Service unavailable errors
class NotificationServiceException extends NotificationException {
  const NotificationServiceException(
    super.message, {
    super.code,
    super.details,
    this.serviceName,
    this.estimatedRecovery,
  });

  final String? serviceName;
  final Duration? estimatedRecovery;

  @override
  String toString() => 'NotificationServiceException: $message (Service: $serviceName)';
}

/// Configuration errors
class NotificationConfigException extends NotificationException {
  const NotificationConfigException(
    super.message, {
    super.code,
    super.details,
    this.configKey,
    this.expectedType,
  });

  final String? configKey;
  final String? expectedType;

  @override
  String toString() => 'NotificationConfigException: $message (Key: $configKey)';
}

/// Unknown/unexpected errors
class NotificationUnknownException extends NotificationException {
  const NotificationUnknownException(
    super.message, {
    super.code,
    super.details,
    this.originalException,
    this.stackTrace,
  });

  final Object? originalException;
  final StackTrace? stackTrace;

  @override
  String toString() => 'NotificationUnknownException: $message (Original: $originalException)';
}
