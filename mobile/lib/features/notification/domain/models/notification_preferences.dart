// Notification preferences models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';
import 'notification.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// Notification preference for specific context and channel
@freezed
abstract class NotificationPreference with _$NotificationPreference {
  const factory NotificationPreference({
    required String id,
    required String userId,
    required ContextType contextType,
    required NotificationChannel channel,
    @Default(NotificationFrequency.immediately) NotificationFrequency frequency,
    @Default(true) bool enabled,
    @Default(false) bool quietHoursEnabled,
    DateTime? quietHoursStart,
    DateTime? quietHoursEnd,
    Map<String, dynamic>? settings,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationPreference;

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
}

/// Comprehensive notification preferences for a user
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required String userId,
    @Default(true) bool globalEnabled,
    @Default(false) bool doNotDisturbEnabled,
    DateTime? doNotDisturbStart,
    DateTime? doNotDisturbEnd,
    @Default([]) List<NotificationPreference> preferences,
    @Default(EmergencyAlertSettings()) EmergencyAlertSettings emergencySettings,
    @Default(QuietHoursSettings()) QuietHoursSettings quietHours,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

/// Emergency alert specific settings
@freezed
abstract class EmergencyAlertSettings with _$EmergencyAlertSettings {
  const factory EmergencyAlertSettings({
    @Default(true) bool enabled,
    @Default(true) bool overrideQuietHours,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default(true) bool fullScreenAlert,
    @Default([]) List<String> emergencyContacts,
    @Default(5) int escalationDelayMinutes,
    @Default(true) bool autoEscalate,
  }) = _EmergencyAlertSettings;

  factory EmergencyAlertSettings.fromJson(Map<String, dynamic> json) =>
      _$EmergencyAlertSettingsFromJson(json);
}

/// Quiet hours settings
@freezed
abstract class QuietHoursSettings with _$QuietHoursSettings {
  const factory QuietHoursSettings({
    @Default(false) bool enabled,
    @Default('22:00') String startTime, // 24-hour format
    @Default('08:00') String endTime, // 24-hour format
    @Default([]) List<int> activeDays, // 0-6, Sunday = 0
    @Default([]) List<NotificationType> allowedTypes,
    @Default(true) bool allowEmergencyAlerts,
  }) = _QuietHoursSettings;

  factory QuietHoursSettings.fromJson(Map<String, dynamic> json) =>
      _$QuietHoursSettingsFromJson(json);
}

/// Emergency contact information
@freezed
abstract class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required String id,
    required String name,
    required String phoneNumber,
    String? email,
    required String relationship,
    @Default(true) bool isPrimary,
    @Default(true) bool notifyBySms,
    @Default(false) bool notifyByEmail,
    @Default(1) int priority, // 1 = highest priority
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}






/// Extensions for convenience methods
extension NotificationPreferencesExtension on NotificationPreferences {
  /// Check if notifications are enabled for a specific context and channel
  bool isEnabledFor(ContextType context, NotificationChannel channel) {
    if (!globalEnabled) return false;

    final preference = preferences.firstWhere(
      (p) => p.contextType == context && p.channel == channel,
      orElse: () => NotificationPreference(
        id: '',
        userId: '',
        contextType: ContextType.system,
        channel: NotificationChannel.inApp,
        createdAt: DateTime.now(),
      ),
    );

    return preference.id.isNotEmpty ? preference.enabled : true;
  }

  /// Check if currently in quiet hours
  bool get isInQuietHours {
    if (!quietHours.enabled) return false;

    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final currentDay = now.weekday % 7; // Convert to 0-6 format

    // Check if today is an active day
    if (quietHours.activeDays.isNotEmpty &&
        !quietHours.activeDays.contains(currentDay)) {
      return false;
    }

    // Check time range
    final start = quietHours.startTime;
    final end = quietHours.endTime;

    if (start.compareTo(end) <= 0) {
      // Same day range (e.g., 22:00 to 23:59)
      return currentTime.compareTo(start) >= 0 &&
          currentTime.compareTo(end) <= 0;
    } else {
      // Overnight range (e.g., 22:00 to 08:00)
      return currentTime.compareTo(start) >= 0 ||
          currentTime.compareTo(end) <= 0;
    }
  }

  /// Check if a notification type is allowed during quiet hours
  bool isAllowedDuringQuietHours(NotificationType type) {
    if (!isInQuietHours) return true;

    if (type == NotificationType.emergencyAlert &&
        quietHours.allowEmergencyAlerts) {
      return true;
    }

    return quietHours.allowedTypes.contains(type);
  }
}

extension QuietHoursSettingsExtension on QuietHoursSettings {
  /// Get display text for active days
  String get activeDaysText {
    if (activeDays.isEmpty) return 'Every day';

    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final sortedDays = List<int>.from(activeDays)..sort();

    if (sortedDays.length == 7) return 'Every day';
    if (sortedDays.length == 5 &&
        !sortedDays.contains(0) &&
        !sortedDays.contains(6)) {
      return 'Weekdays';
    }
    if (sortedDays.length == 2 &&
        sortedDays.contains(0) &&
        sortedDays.contains(6)) {
      return 'Weekends';
    }

    return sortedDays.map((day) => dayNames[day]).join(', ');
  }

  /// Get display text for time range
  String get timeRangeText {
    return '$startTime - $endTime';
  }
}
