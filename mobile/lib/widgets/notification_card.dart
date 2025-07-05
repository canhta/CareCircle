import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../features/notification/domain/notification_models.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final Function(String)? onAction;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: isUnread ? 2 : 1,
        color: isUnread
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(),
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isUnread
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                        notification.priority),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isUnread
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                _formatTime(notification.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              _buildPriorityChip(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (notification.isActionable) ...[
                  const SizedBox(height: 12),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.medicationReminder:
        iconData = Icons.medication;
        iconColor = Colors.blue;
        break;
      case NotificationType.checkInReminder:
        iconData = Icons.health_and_safety;
        iconColor = Colors.green;
        break;
      case NotificationType.healthInsight:
        iconData = Icons.insights;
        iconColor = Colors.purple;
        break;
      case NotificationType.careGroupUpdate:
        iconData = Icons.group;
        iconColor = Colors.orange;
        break;
      case NotificationType.systemAlert:
        iconData = Icons.warning;
        iconColor = Colors.red;
        break;
      case NotificationType.appointmentReminder:
        iconData = Icons.event;
        iconColor = Colors.teal;
        break;
      case NotificationType.emergencyAlert:
        iconData = Icons.emergency;
        iconColor = Colors.red;
        break;
      case NotificationType.aiRecommendation:
        iconData = Icons.auto_awesome;
        iconColor = Colors.indigo;
        break;
      case NotificationType.socialUpdate:
        iconData = Icons.people;
        iconColor = Colors.pink;
        break;
      case NotificationType.achievementUnlocked:
        iconData = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildPriorityChip() {
    if (notification.priority == NotificationPriority.normal) {
      return const SizedBox.shrink();
    }

    String label;
    Color color;

    switch (notification.priority) {
      case NotificationPriority.low:
        label = 'Low';
        color = Colors.grey;
        break;
      case NotificationPriority.high:
        label = 'High';
        color = Colors.orange;
        break;
      case NotificationPriority.urgent:
        label = 'Urgent';
        color = Colors.red;
        break;
      case NotificationPriority.normal:
        return const SizedBox.shrink();
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: color),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildActionButtons() {
    switch (notification.type) {
      case NotificationType.medicationReminder:
        return Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => onAction?.call('taken'),
              icon: const Icon(Icons.check_circle, size: 16),
              label: const Text('Taken'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => onAction?.call('snooze'),
              icon: const Icon(Icons.snooze, size: 16),
              label: const Text('Snooze'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => onAction?.call('view'),
              child: const Text('View'),
            ),
          ],
        );

      case NotificationType.checkInReminder:
        return Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => onAction?.call('start_checkin'),
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Start Check-in'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => onAction?.call('remind_later'),
              child: const Text('Later'),
            ),
          ],
        );

      case NotificationType.careGroupUpdate:
        return Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => onAction?.call('view_update'),
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('View Update'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => onAction?.call('dismiss'),
              child: const Text('Dismiss'),
            ),
          ],
        );

      case NotificationType.healthInsight:
        return Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => onAction?.call('view_insight'),
              icon: const Icon(Icons.insights, size: 16),
              label: const Text('View Details'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => onAction?.call('share'),
              child: const Text('Share'),
            ),
          ],
        );

      default:
        return Row(
          children: [
            ElevatedButton(
              onPressed: () => onAction?.call('view'),
              child: const Text('View'),
            ),
          ],
        );
    }
  }

  Color _getPriorityColor(NotificationPriority priority) {
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
