import 'package:flutter/material.dart';
import '../features/notification/domain/notification_models.dart';

class NotificationUtils {
  /// Get the display name for a notification type
  static String getNotificationTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return 'Medication Reminder';
      case NotificationType.checkInReminder:
        return 'Daily Check-in';
      case NotificationType.healthInsight:
        return 'Health Insight';
      case NotificationType.careGroupUpdate:
        return 'Care Group Update';
      case NotificationType.systemAlert:
        return 'System Alert';
      case NotificationType.appointmentReminder:
        return 'Appointment Reminder';
      case NotificationType.emergencyAlert:
        return 'Emergency Alert';
      case NotificationType.aiRecommendation:
        return 'AI Recommendation';
      case NotificationType.socialUpdate:
        return 'Social Update';
      case NotificationType.achievementUnlocked:
        return 'Achievement Unlocked';
    }
  }

  /// Get the icon for a notification type
  static IconData getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return Icons.medication;
      case NotificationType.checkInReminder:
        return Icons.health_and_safety;
      case NotificationType.healthInsight:
        return Icons.insights;
      case NotificationType.careGroupUpdate:
        return Icons.group;
      case NotificationType.systemAlert:
        return Icons.warning;
      case NotificationType.appointmentReminder:
        return Icons.event;
      case NotificationType.emergencyAlert:
        return Icons.emergency;
      case NotificationType.aiRecommendation:
        return Icons.auto_awesome;
      case NotificationType.socialUpdate:
        return Icons.people;
      case NotificationType.achievementUnlocked:
        return Icons.emoji_events;
    }
  }

  /// Get the color for a notification type
  static Color getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return Colors.blue;
      case NotificationType.checkInReminder:
        return Colors.green;
      case NotificationType.healthInsight:
        return Colors.purple;
      case NotificationType.careGroupUpdate:
        return Colors.orange;
      case NotificationType.systemAlert:
        return Colors.red;
      case NotificationType.appointmentReminder:
        return Colors.teal;
      case NotificationType.emergencyAlert:
        return Colors.red;
      case NotificationType.aiRecommendation:
        return Colors.indigo;
      case NotificationType.socialUpdate:
        return Colors.pink;
      case NotificationType.achievementUnlocked:
        return Colors.amber;
    }
  }

  /// Get the display name for a notification priority
  static String getNotificationPriorityName(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  /// Get the color for a notification priority
  static Color getNotificationPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Colors.grey;
      case NotificationPriority.normal:
        return Colors.blue;
      case NotificationPriority.high:
        return Colors.orange;
      case NotificationPriority.urgent:
        return Colors.red;
    }
  }

  /// Format relative time for notifications
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }

  /// Check if a notification should show action buttons
  static bool isActionable(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.medicationReminder:
      case NotificationType.checkInReminder:
      case NotificationType.careGroupUpdate:
      case NotificationType.healthInsight:
        return true;
      default:
        return false;
    }
  }

  /// Get appropriate actions for a notification type
  static List<NotificationAction> getNotificationActions(
      NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return [
          NotificationAction(
              'taken', 'Taken', Icons.check_circle, Colors.green),
          NotificationAction('snooze', 'Snooze', Icons.snooze, Colors.orange),
          NotificationAction('view', 'View', Icons.visibility, Colors.blue),
        ];

      case NotificationType.checkInReminder:
        return [
          NotificationAction('start_checkin', 'Start Check-in',
              Icons.play_arrow, Colors.green),
          NotificationAction(
              'remind_later', 'Later', Icons.schedule, Colors.grey),
        ];

      case NotificationType.careGroupUpdate:
        return [
          NotificationAction(
              'view_update', 'View Update', Icons.visibility, Colors.blue),
          NotificationAction('dismiss', 'Dismiss', Icons.close, Colors.grey),
        ];

      case NotificationType.healthInsight:
        return [
          NotificationAction(
              'view_insight', 'View Details', Icons.insights, Colors.purple),
          NotificationAction('share', 'Share', Icons.share, Colors.blue),
        ];

      default:
        return [
          NotificationAction('view', 'View', Icons.visibility, Colors.blue),
        ];
    }
  }

  /// Create a mock notification for testing
  static NotificationModel createMockNotification({
    required NotificationType type,
    NotificationPriority priority = NotificationPriority.normal,
    bool isRead = false,
  }) {
    final now = DateTime.now();

    return NotificationModel(
      id: 'mock-${type.name}-${now.millisecondsSinceEpoch}',
      title: _getMockTitle(type),
      message: _getMockMessage(type),
      type: type,
      channels: [NotificationChannel.inApp, NotificationChannel.push],
      priority: priority,
      createdAt: now.subtract(Duration(minutes: DateTime.now().minute % 60)),
      readAt: isRead ? now.subtract(const Duration(minutes: 5)) : null,
      isActionable: isActionable(NotificationModel(
        id: '',
        title: '',
        message: '',
        type: type,
        channels: [],
        priority: priority,
        createdAt: now,
      )),
    );
  }

  static String _getMockTitle(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return 'Time for your medication';
      case NotificationType.checkInReminder:
        return 'Daily check-in reminder';
      case NotificationType.healthInsight:
        return 'Your health summary is ready';
      case NotificationType.careGroupUpdate:
        return 'New update from your care group';
      case NotificationType.systemAlert:
        return 'System maintenance scheduled';
      case NotificationType.appointmentReminder:
        return 'Upcoming appointment reminder';
      case NotificationType.emergencyAlert:
        return 'Emergency alert';
      case NotificationType.aiRecommendation:
        return 'New health recommendation';
      case NotificationType.socialUpdate:
        return 'Someone shared an update';
      case NotificationType.achievementUnlocked:
        return 'Achievement unlocked!';
    }
  }

  static String _getMockMessage(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return "Don't forget to take your Metformin 500mg. It's important for managing your blood sugar levels.";
      case NotificationType.checkInReminder:
        return "How are you feeling today? Complete your daily check-in to track your health progress.";
      case NotificationType.healthInsight:
        return "Based on your recent activity, we've noticed some interesting patterns in your health data.";
      case NotificationType.careGroupUpdate:
        return "Dr. Smith has shared new information about your treatment plan. Tap to view details.";
      case NotificationType.systemAlert:
        return "We'll be performing scheduled maintenance tonight from 2-4 AM. Some features may be temporarily unavailable.";
      case NotificationType.appointmentReminder:
        return "You have an appointment with Dr. Johnson tomorrow at 2:00 PM. Don't forget to bring your medication list.";
      case NotificationType.emergencyAlert:
        return "Important: Your recent health readings require immediate attention. Please contact your healthcare provider.";
      case NotificationType.aiRecommendation:
        return "Based on your sleep and activity patterns, we recommend adjusting your bedtime routine for better rest.";
      case NotificationType.socialUpdate:
        return "Your daughter Sarah shared an update about your medication schedule. See what's new in your care group.";
      case NotificationType.achievementUnlocked:
        return "Congratulations! You've completed 7 days of consistent daily check-ins. Keep up the great work!";
    }
  }
}

/// Represents a notification action with display properties
class NotificationAction {
  final String action;
  final String label;
  final IconData icon;
  final Color color;

  const NotificationAction(
    this.action,
    this.label,
    this.icon,
    this.color,
  );
}
