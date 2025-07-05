import '../../../common/common.dart';
import 'notification_models.dart';

/// Repository interface for notification operations
abstract class NotificationRepository {
  /// Get paginated notifications
  Future<Result<NotificationPaginatedResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  });

  /// Mark a notification as read
  Future<Result<void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Result<void>> markAllAsRead();

  /// Get unread notification count
  Future<Result<int>> getUnreadCount();

  /// Get notification preferences
  Future<Result<NotificationPreferences>> getNotificationPreferences();

  /// Update notification preferences
  Future<Result<void>> updateNotificationPreferences(
    NotificationPreferences preferences,
  );

  /// Send notification response for actionable notifications
  Future<Result<void>> sendNotificationResponse(
    String notificationId,
    String action, {
    Map<String, dynamic>? metadata,
  });

  /// Track notification opened
  Future<Result<void>> trackNotificationOpened(
    String notificationId,
    String channel, {
    Map<String, dynamic>? metadata,
  });

  /// Delete a notification
  Future<Result<void>> deleteNotification(String notificationId);

  /// Delete all notifications
  Future<Result<void>> deleteAllNotifications();

  /// Schedule a local notification
  Future<Result<void>> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, dynamic>? payload,
  });

  /// Cancel a scheduled notification
  Future<Result<void>> cancelScheduledNotification(String notificationId);

  /// Get all scheduled notifications
  Future<Result<List<Map<String, dynamic>>>> getScheduledNotifications();
}
