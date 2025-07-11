import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart' as notification_models;
import '../providers/notification_providers.dart';

/// Notification Detail Screen
///
/// Displays detailed information about a specific notification:
/// - Full notification content
/// - Metadata and context information
/// - Action buttons (mark as read, delete, etc.)
/// - Related actions based on notification type
class NotificationDetailScreen extends ConsumerStatefulWidget {
  final String notificationId;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
  });

  @override
  ConsumerState<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  final _logger = BoundedContextLoggers.notification;

  @override
  void initState() {
    super.initState();
    
    // Log screen access
    _logger.info('Notification detail accessed', {
      'notificationId': widget.notificationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareCircleDesignTokens.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      foregroundColor: Colors.white,
      title: const Text(
        'Notification Details',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'mark_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read, size: 20),
                  SizedBox(width: 12),
                  Text('Mark as Read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'mark_unread',
              child: Row(
                children: [
                  Icon(Icons.mark_email_unread, size: 20),
                  SizedBox(width: 12),
                  Text('Mark as Unread'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder<notification_models.Notification>(
      future: _getNotification(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        } else if (!snapshot.hasData) {
          return _buildNotFoundState();
        }

        final notification = snapshot.data!;
        return _buildNotificationDetail(notification);
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading notification...',
            style: TextStyle(
              fontSize: 16,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: CareCircleDesignTokens.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: CareCircleDesignTokens.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Notification not found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This notification may have been deleted or is no longer available.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDetail(Notification notification) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotificationHeader(notification),
          const SizedBox(height: 24),
          _buildNotificationContent(notification),
          const SizedBox(height: 24),
          _buildNotificationMetadata(notification),
          if (notification.context != null && notification.context!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildContextInformation(notification.context!),
          ],
          const SizedBox(height: 24),
          _buildActionButtons(notification),
        ],
      ),
    );
  }

  Widget _buildNotificationHeader(Notification notification) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getTypeColor(notification.type),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    notification.type.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.type.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(notification.type),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: CareCircleDesignTokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPriorityBadge(notification.priority),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusIndicator(notification),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(NotificationPriority priority) {
    if (priority == NotificationPriority.normal || 
        priority == NotificationPriority.low) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(priority),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.displayName.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Notification notification) {
    IconData icon;
    Color color;
    String text;

    switch (notification.status) {
      case NotificationStatus.read:
        icon = Icons.check_circle;
        color = CareCircleDesignTokens.successGreen;
        text = 'Read';
        break;
      case NotificationStatus.delivered:
        icon = Icons.check;
        color = CareCircleDesignTokens.primaryMedicalBlue;
        text = 'Delivered';
        break;
      case NotificationStatus.pending:
        icon = Icons.schedule;
        color = CareCircleDesignTokens.warningOrange;
        text = 'Pending';
        break;
      case NotificationStatus.failed:
        icon = Icons.error;
        color = CareCircleDesignTokens.errorRed;
        text = 'Failed';
        break;
      case NotificationStatus.expired:
        icon = Icons.access_time;
        color = CareCircleDesignTokens.textSecondary;
        text = 'Expired';
        break;
      case NotificationStatus.sent:
        icon = Icons.send;
        color = CareCircleDesignTokens.primaryMedicalBlue;
        text = 'Sent';
        break;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const Spacer(),
        Text(
          DateFormat('MMM d, y • h:mm a').format(notification.createdAt),
          style: TextStyle(
            fontSize: 12,
            color: CareCircleDesignTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationContent(Notification notification) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            notification.message,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationMetadata(Notification notification) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildMetadataRow('Channel', _getChannelDisplayName(notification.channel)),
          _buildMetadataRow('Priority', notification.priority.displayName),
          _buildMetadataRow('Created', DateFormat('MMM d, y • h:mm a').format(notification.createdAt)),
          if (notification.scheduledFor != null)
            _buildMetadataRow('Scheduled For', DateFormat('MMM d, y • h:mm a').format(notification.scheduledFor!)),
          if (notification.deliveredAt != null)
            _buildMetadataRow('Delivered', DateFormat('MMM d, y • h:mm a').format(notification.deliveredAt!)),
          if (notification.readAt != null)
            _buildMetadataRow('Read', DateFormat('MMM d, y • h:mm a').format(notification.readAt!)),
          if (notification.expiresAt != null)
            _buildMetadataRow('Expires', DateFormat('MMM d, y • h:mm a').format(notification.expiresAt!)),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CareCircleDesignTokens.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CareCircleDesignTokens.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextInformation(Map<String, dynamic> context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...context.entries.map((entry) => 
            _buildMetadataRow(entry.key, entry.value.toString())),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Notification notification) {
    return Column(
      children: [
        if (notification.status != NotificationStatus.read)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _markAsRead(notification),
              icon: const Icon(Icons.mark_email_read),
              label: const Text('Mark as Read'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _deleteNotification(notification),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CareCircleDesignTokens.errorRed,
                  side: BorderSide(color: CareCircleDesignTokens.errorRed),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareNotification(notification),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                  side: BorderSide(color: CareCircleDesignTokens.primaryMedicalBlue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Notification> _getNotification() async {
    final repository = ref.read(notificationRepositoryProvider);
    return repository.getNotification(widget.notificationId);
  }

  Future<void> _markAsRead(Notification notification) async {
    try {
      await ref.read(notificationNotifierProvider.notifier)
          .markAsRead(notification.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marked as read'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.errorRed,
          ),
        );
      }
    }
  }

  void _deleteNotification(Notification notification) {
    // TODO: Implement delete notification
    _logger.info('Delete notification requested', {
      'notificationId': notification.id,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _shareNotification(Notification notification) {
    // TODO: Implement share notification
    _logger.info('Share notification requested', {
      'notificationId': notification.id,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _handleMenuAction(String action) {
    // TODO: Implement menu actions
    _logger.info('Menu action selected', {
      'action': action,
      'notificationId': widget.notificationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case NotificationType.healthAlert:
        return CareCircleDesignTokens.warningOrange;
      case NotificationType.emergencyAlert:
        return CareCircleDesignTokens.errorRed;
      case NotificationType.appointmentReminder:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case NotificationType.taskReminder:
        return CareCircleDesignTokens.successGreen;
      case NotificationType.careGroupUpdate:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case NotificationType.systemNotification:
        return CareCircleDesignTokens.textSecondary;
    }
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return CareCircleDesignTokens.successGreen;
      case NotificationPriority.normal:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case NotificationPriority.high:
        return CareCircleDesignTokens.warningOrange;
      case NotificationPriority.urgent:
        return CareCircleDesignTokens.errorRed;
    }
  }

  String _getChannelDisplayName(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.push:
        return 'Push Notification';
      case NotificationChannel.email:
        return 'Email';
      case NotificationChannel.sms:
        return 'SMS';
      case NotificationChannel.inApp:
        return 'In-App';
    }
  }
}
