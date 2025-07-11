import '../../domain/exceptions/notification_exceptions.dart';
import '../../domain/models/models.dart' as notification_models;

/// Comprehensive validation service for notification module
///
/// Provides healthcare-compliant validation with:
/// - Input sanitization and validation
/// - Security checks for user data
/// - Healthcare-specific validation rules
/// - HIPAA compliance considerations
class NotificationValidator {
  /// Validate notification creation request
  static void validateCreateNotificationRequest(
    notification_models.CreateNotificationRequest request,
  ) {
    final errors = <String>[];

    // Validate title
    if (request.title.trim().isEmpty) {
      errors.add('Title is required');
    } else if (request.title.length > 100) {
      errors.add('Title must be 100 characters or less');
    } else if (_containsInvalidCharacters(request.title)) {
      errors.add('Title contains invalid characters');
    }

    // Validate message
    if (request.message.trim().isEmpty) {
      errors.add('Message is required');
    } else if (request.message.length > 500) {
      errors.add('Message must be 500 characters or less');
    } else if (_containsInvalidCharacters(request.message)) {
      errors.add('Message contains invalid characters');
    }

    // Validate type
    if (!_isValidNotificationType(request.type)) {
      errors.add('Invalid notification type');
    }

    // Validate channel
    if (!_isValidNotificationChannel(request.channel)) {
      errors.add('Invalid notification channel');
    }

    // Validate priority
    if (!_isValidNotificationPriority(request.priority)) {
      errors.add('Invalid notification priority');
    }

    // Validate data if present
    if (request.data != null) {
      _validateMetadata(request.data!, errors);
    }

    // Validate scheduled time if present
    if (request.scheduledAt != null) {
      _validateScheduledTime(request.scheduledAt!, errors);
    }

    if (errors.isNotEmpty) {
      throw NotificationValidationException(
        'Validation failed for notification creation',
        code: 'VALIDATION_FAILED',
        validationErrors: errors,
        details: {'requestType': 'CreateNotificationRequest'},
      );
    }
  }

  /// Validate emergency alert creation request
  static void validateCreateEmergencyAlertRequest(
    notification_models.CreateEmergencyAlertRequest request,
  ) {
    final errors = <String>[];

    // Validate title
    if (request.title.trim().isEmpty) {
      errors.add('Emergency alert title is required');
    } else if (request.title.length > 80) {
      errors.add('Emergency alert title must be 80 characters or less');
    }

    // Validate message
    if (request.message.trim().isEmpty) {
      errors.add('Emergency alert message is required');
    } else if (request.message.length > 300) {
      errors.add('Emergency alert message must be 300 characters or less');
    }

    // Validate alert type
    if (!_isValidEmergencyAlertType(request.alertType)) {
      errors.add('Invalid emergency alert type');
    }

    // Validate severity
    if (!_isValidEmergencyAlertSeverity(request.severity)) {
      errors.add('Invalid emergency alert severity');
    }

    // Validate escalation settings
    if (request.escalationTimeoutMinutes != null) {
      if (request.escalationTimeoutMinutes! < 1) {
        errors.add('Escalation timeout must be at least 1 minute');
      } else if (request.escalationTimeoutMinutes! > 60) {
        errors.add('Escalation timeout must be 60 minutes or less');
      }
    }

    // Validate metadata if present
    if (request.metadata != null) {
      _validateMetadata(request.metadata!, errors);
    }

    if (errors.isNotEmpty) {
      throw NotificationValidationException(
        'Validation failed for emergency alert creation',
        code: 'EMERGENCY_VALIDATION_FAILED',
        validationErrors: errors,
        details: {'requestType': 'CreateEmergencyAlertRequest'},
      );
    }
  }

  /// Validate notification preferences update
  static void validateUpdateNotificationPreferencesRequest(
    notification_models.UpdateNotificationPreferencesRequest request,
  ) {
    final errors = <String>[];

    // Validate quiet hours if present
    if (request.quietHours != null) {
      _validateQuietHours(request.quietHours!, errors);
    }

    // Validate emergency settings if present
    if (request.emergencySettings != null) {
      _validateEmergencySettings(request.emergencySettings!, errors);
    }

    // Validate channel preferences if present
    if (request.channelPreferences != null) {
      _validateChannelPreferences(request.channelPreferences!, errors);
    }

    // Validate type preferences if present
    if (request.typePreferences != null) {
      _validateTypePreferences(request.typePreferences!, errors);
    }

    if (errors.isNotEmpty) {
      throw NotificationValidationException(
        'Validation failed for notification preferences update',
        code: 'PREFERENCES_VALIDATION_FAILED',
        validationErrors: errors,
        details: {'requestType': 'UpdateNotificationPreferencesRequest'},
      );
    }
  }

  /// Validate template creation request
  static void validateCreateTemplateRequest(
    notification_models.CreateTemplateRequest request,
  ) {
    final errors = <String>[];

    // Validate name
    if (request.name.trim().isEmpty) {
      errors.add('Template name is required');
    } else if (request.name.length > 50) {
      errors.add('Template name must be 50 characters or less');
    } else if (!_isValidTemplateName(request.name)) {
      errors.add('Template name contains invalid characters');
    }

    // Validate subject template
    if (request.subject.trim().isEmpty) {
      errors.add('Subject template is required');
    } else if (request.subject.length > 100) {
      errors.add('Subject template must be 100 characters or less');
    }

    // Validate content template
    if (request.content.trim().isEmpty) {
      errors.add('Content template is required');
    } else if (request.content.length > 500) {
      errors.add('Content template must be 500 characters or less');
    }

    // Validate template variables
    _validateTemplateVariables(request.subject, request.content, errors);

    // Validate variables if present
    if (request.variables != null) {
      _validateTemplateVariableMap(request.variables!, errors);
    }

    if (errors.isNotEmpty) {
      throw NotificationValidationException(
        'Validation failed for template creation',
        code: 'TEMPLATE_VALIDATION_FAILED',
        validationErrors: errors,
        details: {'requestType': 'CreateTemplateRequest'},
      );
    }
  }

  /// Check for invalid characters in text input
  static bool _containsInvalidCharacters(String text) {
    // Allow alphanumeric, spaces, and common punctuation
    final validPattern = RegExp(r'^[a-zA-Z0-9\s\.,!?\-\(\)\[\]]+$');
    return !validPattern.hasMatch(text);
  }

  /// Validate notification type
  static bool _isValidNotificationType(
    notification_models.NotificationType type,
  ) {
    return notification_models.NotificationType.values.contains(type);
  }

  /// Validate notification channel
  static bool _isValidNotificationChannel(
    notification_models.NotificationChannel channel,
  ) {
    return notification_models.NotificationChannel.values.contains(channel);
  }

  /// Validate notification priority
  static bool _isValidNotificationPriority(
    notification_models.NotificationPriority priority,
  ) {
    return notification_models.NotificationPriority.values.contains(priority);
  }

  /// Validate emergency alert type
  static bool _isValidEmergencyAlertType(
    notification_models.EmergencyAlertType type,
  ) {
    return notification_models.EmergencyAlertType.values.contains(type);
  }

  /// Validate emergency alert severity
  static bool _isValidEmergencyAlertSeverity(
    notification_models.EmergencyAlertSeverity severity,
  ) {
    return notification_models.EmergencyAlertSeverity.values.contains(severity);
  }

  /// Validate metadata
  static void _validateMetadata(
    Map<String, dynamic> metadata,
    List<String> errors,
  ) {
    if (metadata.length > 10) {
      errors.add('Metadata cannot have more than 10 entries');
    }

    for (final entry in metadata.entries) {
      if (entry.key.length > 50) {
        errors.add(
          'Metadata key "${entry.key}" is too long (max 50 characters)',
        );
      }
      if (entry.value.toString().length > 200) {
        errors.add(
          'Metadata value for "${entry.key}" is too long (max 200 characters)',
        );
      }
    }
  }

  /// Validate scheduled time
  static void _validateScheduledTime(
    DateTime scheduledFor,
    List<String> errors,
  ) {
    final now = DateTime.now();
    final maxFuture = now.add(const Duration(days: 365));

    if (scheduledFor.isBefore(now)) {
      errors.add('Scheduled time cannot be in the past');
    } else if (scheduledFor.isAfter(maxFuture)) {
      errors.add('Scheduled time cannot be more than 1 year in the future');
    }
  }

  /// Validate quiet hours settings
  static void _validateQuietHours(
    notification_models.QuietHoursSettings quietHours,
    List<String> errors,
  ) {
    // Validate start and end times are valid time strings
    try {
      final startParts = quietHours.startTime.split(':');
      final endParts = quietHours.endTime.split(':');

      final startHour = int.parse(startParts[0]);
      final endHour = int.parse(endParts[0]);

      if (startHour < 0 || startHour > 23) {
        errors.add('Invalid quiet hours start time');
      }
      if (endHour < 0 || endHour > 23) {
        errors.add('Invalid quiet hours end time');
      }
    } catch (e) {
      errors.add('Invalid time format for quiet hours');
    }

    if (quietHours.activeDays.isEmpty) {
      errors.add('At least one day must be selected for quiet hours');
    }
  }

  /// Validate emergency settings
  static void _validateEmergencySettings(
    notification_models.EmergencyAlertSettings settings,
    List<String> errors,
  ) {
    // Emergency settings validation logic
    if (settings.escalationDelayMinutes < 1 ||
        settings.escalationDelayMinutes > 60) {
      errors.add('Emergency escalation delay must be between 1 and 60 minutes');
    }
  }

  /// Validate channel preferences
  static void _validateChannelPreferences(
    Map<String, bool> preferences,
    List<String> errors,
  ) {
    final validChannels = notification_models.NotificationChannel.values
        .map((e) => e.name)
        .toSet();
    for (final channel in preferences.keys) {
      if (!validChannels.contains(channel)) {
        errors.add('Invalid notification channel: $channel');
      }
    }
  }

  /// Validate type preferences
  static void _validateTypePreferences(
    Map<String, bool> preferences,
    List<String> errors,
  ) {
    final validTypes = notification_models.NotificationType.values
        .map((e) => e.name)
        .toSet();
    for (final type in preferences.keys) {
      if (!validTypes.contains(type)) {
        errors.add('Invalid notification type: $type');
      }
    }
  }

  /// Validate template name
  static bool _isValidTemplateName(String name) {
    final validPattern = RegExp(r'^[a-zA-Z0-9_\-]+$');
    return validPattern.hasMatch(name);
  }

  /// Validate template variables
  static void _validateTemplateVariables(
    String titleTemplate,
    String messageTemplate,
    List<String> errors,
  ) {
    final variablePattern = RegExp(r'\{\{(\w+)\}\}');

    final titleVariables = variablePattern
        .allMatches(titleTemplate)
        .map((m) => m.group(1)!)
        .toSet();
    final messageVariables = variablePattern
        .allMatches(messageTemplate)
        .map((m) => m.group(1)!)
        .toSet();

    // Check for invalid variable names
    final invalidVariables = [
      ...titleVariables,
      ...messageVariables,
    ].where((v) => !_isValidVariableName(v));
    if (invalidVariables.isNotEmpty) {
      errors.add('Invalid template variables: ${invalidVariables.join(', ')}');
    }
  }

  /// Validate template variable map
  static void _validateTemplateVariableMap(
    Map<String, String> variables,
    List<String> errors,
  ) {
    for (final entry in variables.entries) {
      if (!_isValidVariableName(entry.key)) {
        errors.add('Invalid variable name: ${entry.key}');
      }
      if (entry.value.length > 100) {
        errors.add(
          'Variable description for "${entry.key}" is too long (max 100 characters)',
        );
      }
    }
  }

  /// Check if variable name is valid
  static bool _isValidVariableName(String name) {
    final validPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    return validPattern.hasMatch(name) && name.length <= 30;
  }
}
