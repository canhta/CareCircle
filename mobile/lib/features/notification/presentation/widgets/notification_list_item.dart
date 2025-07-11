import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design/design_tokens.dart';
import '../../domain/models/notification.dart' as notification_models;

/// Notification list item widget
///
/// Displays a notification in a list with:
/// - Type icon and priority indicator
/// - Title and message
/// - Timestamp and read status
/// - Swipe actions for mark as read/delete
class NotificationListItem extends StatelessWidget {
  final notification_models.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationListItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMarkAsRead?.call();
        } else {
          onDelete?.call();
        }
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _getBorderColor(),
            width: notification.status == notification_models.NotificationStatus.read ? 0.5 : 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: notification.status == notification_models.NotificationStatus.read
                  ? Colors.white
                  : CareCircleDesignTokens.primaryMedicalBlue.withOpacity(0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildContent(),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isLeft 
            ? CareCircleDesignTokens.successGreen 
            : CareCircleDesignTokens.errorRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isLeft ? Icons.mark_email_read : Icons.delete,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildTypeIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.status == notification_models.NotificationStatus.read
                            ? FontWeight.w500
                            : FontWeight.w600,
                        color: CareCircleDesignTokens.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildPriorityIndicator(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                notification.type.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getTypeColor(),
                ),
              ),
            ],
          ),
        ),
        _buildReadStatusIndicator(),
      ],
    );
  }

  Widget _buildTypeIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          notification.type.icon,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    if (notification.priority == notification_models.NotificationPriority.normal ||
        notification.priority == notification_models.NotificationPriority.low) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getPriorityColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        notification.priority.displayName.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildReadStatusIndicator() {
    if (notification.status == notification_models.NotificationStatus.read) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.primaryMedicalBlue,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      notification.message,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: notification.status == notification_models.NotificationStatus.read
            ? CareCircleDesignTokens.textSecondary
            : CareCircleDesignTokens.textPrimary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: CareCircleDesignTokens.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimestamp(notification.createdAt),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CareCircleDesignTokens.textSecondary,
          ),
        ),
        const Spacer(),
        _buildChannelIndicator(),
        if (notification.status == notification_models.NotificationStatus.read) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.check_circle,
            size: 16,
            color: CareCircleDesignTokens.successGreen,
          ),
        ],
      ],
    );
  }

  Widget _buildChannelIndicator() {
    IconData icon;
    switch (notification.channel) {
      case notification_models.NotificationChannel.push:
        icon = Icons.notifications;
        break;
      case notification_models.NotificationChannel.email:
        icon = Icons.email;
        break;
      case notification_models.NotificationChannel.sms:
        icon = Icons.sms;
        break;
      case notification_models.NotificationChannel.inApp:
        icon = Icons.app_registration;
        break;
    }

    return Icon(
      icon,
      size: 14,
      color: CareCircleDesignTokens.textSecondary,
    );
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case notification_models.NotificationType.medicationReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.healthAlert:
        return CareCircleDesignTokens.warningOrange;
      case notification_models.NotificationType.emergencyAlert:
        return CareCircleDesignTokens.errorRed;
      case notification_models.NotificationType.appointmentReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.taskReminder:
        return CareCircleDesignTokens.successGreen;
      case notification_models.NotificationType.careGroupUpdate:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.systemNotification:
        return CareCircleDesignTokens.textSecondary;
    }
  }

  Color _getPriorityColor() {
    switch (notification.priority) {
      case notification_models.NotificationPriority.low:
        return CareCircleDesignTokens.successGreen;
      case notification_models.NotificationPriority.normal:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationPriority.high:
        return CareCircleDesignTokens.warningOrange;
      case notification_models.NotificationPriority.urgent:
        return CareCircleDesignTokens.errorRed;
    }
  }

  Color _getBorderColor() {
    if (notification.priority == notification_models.NotificationPriority.urgent) {
      return CareCircleDesignTokens.errorRed;
    } else if (notification.priority == notification_models.NotificationPriority.high) {
      return CareCircleDesignTokens.warningOrange;
    } else if (notification.status != notification_models.NotificationStatus.read) {
      return CareCircleDesignTokens.primaryMedicalBlue;
    } else {
      return CareCircleDesignTokens.borderLight;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}

/// Extension for notification type colors and icons
extension NotificationTypeUI on notification_models.NotificationType {
  Color get color {
    switch (this) {
      case notification_models.NotificationType.medicationReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.healthAlert:
        return CareCircleDesignTokens.warningOrange;
      case notification_models.NotificationType.emergencyAlert:
        return CareCircleDesignTokens.errorRed;
      case notification_models.NotificationType.appointmentReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.taskReminder:
        return CareCircleDesignTokens.successGreen;
      case notification_models.NotificationType.careGroupUpdate:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationType.systemNotification:
        return CareCircleDesignTokens.textSecondary;
    }
  }
}

/// Extension for notification priority colors
extension NotificationPriorityUI on notification_models.NotificationPriority {
  Color get color {
    switch (this) {
      case notification_models.NotificationPriority.low:
        return CareCircleDesignTokens.successGreen;
      case notification_models.NotificationPriority.normal:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case notification_models.NotificationPriority.high:
        return CareCircleDesignTokens.warningOrange;
      case notification_models.NotificationPriority.urgent:
        return CareCircleDesignTokens.errorRed;
    }
  }
}
