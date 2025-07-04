import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

/// Utility class for managing notification channels
class NotificationChannels {
  // Channel Keys
  static const String medicationChannel = 'medication_channel';
  static const String healthCheckChannel = 'health_check_channel';
  static const String careGroupChannel = 'care_group_channel';
  static const String systemAlertChannel = 'system_alert_channel';
  static const String generalChannel = 'general_channel';
  static const String emergencyChannel = 'emergency_channel';

  /// Get all notification channels
  static List<NotificationChannel> getAllChannels() {
    return [
      NotificationChannel(
        channelKey: medicationChannel,
        channelName: 'Medication Reminders',
        channelDescription:
            'Notifications for medication schedules and reminders',
        defaultColor: const Color(0xFF2196F3),
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        soundSource: 'resource://raw/medication_sound',
      ),
      NotificationChannel(
        channelKey: healthCheckChannel,
        channelName: 'Health Check Reminders',
        channelDescription:
            'Notifications for daily health check-ins and monitoring',
        defaultColor: const Color(0xFF4CAF50),
        ledColor: Colors.green,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      NotificationChannel(
        channelKey: careGroupChannel,
        channelName: 'Care Group Updates',
        channelDescription:
            'Notifications from your care group members and updates',
        defaultColor: const Color(0xFFFF9800),
        ledColor: Colors.orange,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        playSound: true,
        enableVibration: false,
      ),
      NotificationChannel(
        channelKey: systemAlertChannel,
        channelName: 'System Alerts',
        channelDescription: 'Important system notifications and alerts',
        defaultColor: const Color(0xFFF44336),
        ledColor: Colors.red,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        locked: true, // Cannot be disabled by user
      ),
      NotificationChannel(
        channelKey: emergencyChannel,
        channelName: 'Emergency Alerts',
        channelDescription: 'Critical emergency notifications',
        defaultColor: const Color(0xFFD32F2F),
        ledColor: Colors.red,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        locked: true,
        criticalAlerts: true,
      ),
      NotificationChannel(
        channelKey: generalChannel,
        channelName: 'General Notifications',
        channelDescription: 'General app notifications and updates',
        defaultColor: const Color(0xFF9C27B0),
        ledColor: Colors.purple,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        playSound: true,
        enableVibration: false,
      ),
    ];
  }

  /// Get appropriate channel for message type
  static String getChannelForType(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
      case 'medication':
      case 'prescription':
        return medicationChannel;
      case 'health_check':
      case 'daily_check_in':
      case 'vitals_reminder':
        return healthCheckChannel;
      case 'care_group_update':
      case 'care_group':
      case 'family_update':
        return careGroupChannel;
      case 'system_alert':
      case 'account':
      case 'security':
        return systemAlertChannel;
      case 'emergency':
      case 'critical_alert':
      case 'emergency_contact':
        return emergencyChannel;
      default:
        return generalChannel;
    }
  }

  /// Get channel importance based on message type
  static NotificationImportance getImportanceForType(String messageType) {
    switch (messageType) {
      case 'emergency':
      case 'critical_alert':
        return NotificationImportance.Max;
      case 'medication_reminder':
      case 'health_check':
      case 'system_alert':
        return NotificationImportance.High;
      case 'care_group_update':
      case 'general':
        return NotificationImportance.Default;
      default:
        return NotificationImportance.Default;
    }
  }

  /// Check if channel should wake up screen
  static bool shouldWakeUpScreen(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
      case 'emergency':
      case 'critical_alert':
        return true;
      default:
        return false;
    }
  }

  /// Check if channel should show on lock screen
  static bool shouldShowOnLockScreen(String messageType) {
    switch (messageType) {
      case 'emergency':
      case 'critical_alert':
        return true;
      case 'medication_reminder':
      case 'health_check':
      case 'account':
      case 'security':
        return false; // Privacy sensitive
      default:
        return true;
    }
  }

  /// Get notification priority for different message types
  static int getPriorityForType(String messageType) {
    switch (messageType) {
      case 'emergency':
      case 'critical_alert':
        return 2; // Maximum priority
      case 'medication_reminder':
      case 'health_check':
      case 'system_alert':
        return 1; // High priority
      case 'care_group_update':
        return 0; // Normal priority
      default:
        return -1; // Low priority
    }
  }

  /// Get custom sound for message type
  static String? getSoundForType(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
        return 'resource://raw/medication_reminder';
      case 'emergency':
      case 'critical_alert':
        return 'resource://raw/emergency_alert';
      case 'health_check':
        return 'resource://raw/health_check';
      default:
        return null; // Use default sound
    }
  }

  /// Get vibration pattern for message type
  static List<int>? getVibrationPatternForType(String messageType) {
    switch (messageType) {
      case 'emergency':
      case 'critical_alert':
        return [0, 500, 200, 500, 200, 500]; // Urgent pattern
      case 'medication_reminder':
        return [0, 300, 100, 300]; // Gentle reminder pattern
      case 'health_check':
        return [0, 200, 100, 200]; // Soft pattern
      default:
        return [0, 250]; // Default single vibration
    }
  }
}
