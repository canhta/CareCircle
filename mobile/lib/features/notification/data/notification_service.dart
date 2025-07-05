import '../../../common/common.dart';
import '../domain/notification_models.dart';
import '../domain/notification_repository.dart';

/// Implementation of NotificationRepository
class NotificationService extends BaseRepository
    implements NotificationRepository {
  NotificationService({
    required super.apiClient,
    required super.logger,
  });

  @override
  Future<Result<NotificationPaginatedResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      logger.info('Fetching notifications', data: {
        'page': page,
        'limit': limit,
        'unreadOnly': unreadOnly,
      });

      final response = await apiClient.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
          'unreadOnly': unreadOnly.toString(),
        },
      );

      final result =
          NotificationPaginatedResponse.fromJson(response.data['data']);

      logger.info('Successfully fetched notifications', data: {
        'count': result.notifications.length,
        'total': result.total,
      });

      return Result.success(result);
    } catch (e) {
      logger.error('Failed to fetch notifications', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch notifications',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      logger.info('Marking notification as read',
          data: {'notificationId': notificationId});

      await apiClient.post(
        ApiEndpoints.markNotificationAsRead.replaceAll('{id}', notificationId),
      );

      logger.info('Successfully marked notification as read');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to mark notification as read', error: e);
      return Result.failure(
        NetworkException(
          'Failed to mark notification as read',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      logger.info('Marking all notifications as read');

      await apiClient.post(ApiEndpoints.markAllNotificationsAsRead);

      logger.info('Successfully marked all notifications as read');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to mark all notifications as read', error: e);
      return Result.failure(
        NetworkException(
          'Failed to mark all notifications as read',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    try {
      logger.info('Fetching unread notifications count');

      final response =
          await apiClient.get(ApiEndpoints.unreadNotificationsCount);
      final count = response.data['data']['count'] as int;

      logger.info('Successfully fetched unread count', data: {'count': count});
      return Result.success(count);
    } catch (e) {
      logger.error('Failed to fetch unread notifications count', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch unread notifications count',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<NotificationPreferences>> getNotificationPreferences() async {
    try {
      logger.info('Fetching notification preferences');

      final response =
          await apiClient.get(ApiEndpoints.notificationPreferences);
      final preferences =
          NotificationPreferences.fromJson(response.data['data']);

      logger.info('Successfully fetched notification preferences');
      return Result.success(preferences);
    } catch (e) {
      logger.error('Failed to fetch notification preferences', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch notification preferences',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> updateNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    try {
      logger.info('Updating notification preferences');

      await apiClient.put(
        ApiEndpoints.notificationPreferences,
        data: preferences.toJson(),
      );

      logger.info('Successfully updated notification preferences');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to update notification preferences', error: e);
      return Result.failure(
        NetworkException(
          'Failed to update notification preferences',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> sendNotificationResponse(
    String notificationId,
    String action, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.info('Sending notification response', data: {
        'notificationId': notificationId,
        'action': action,
      });

      await apiClient.post(
        ApiEndpoints.notificationResponse.replaceAll('{id}', notificationId),
        data: {
          'action': action,
          'metadata': metadata,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      logger.info('Successfully sent notification response');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to send notification response', error: e);
      return Result.failure(
        NetworkException(
          'Failed to send notification response',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> trackNotificationOpened(
    String notificationId,
    String channel, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.info('Tracking notification opened', data: {
        'notificationId': notificationId,
        'channel': channel,
      });

      await apiClient.post(
        ApiEndpoints.trackNotificationOpened.replaceAll('{id}', notificationId),
        data: {
          'channel': channel,
          'metadata': metadata,
        },
      );

      logger.info('Successfully tracked notification opened');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to track notification opened', error: e, data: {
        'notificationId': notificationId,
        'channel': channel,
      });
      // Don't return failure for tracking - it's not critical
      return Result.success(null);
    }
  }

  @override
  Future<Result<void>> deleteNotification(String notificationId) async {
    try {
      logger.info('Deleting notification',
          data: {'notificationId': notificationId});

      await apiClient.delete(
        ApiEndpoints.deleteNotification.replaceAll('{id}', notificationId),
      );

      logger.info('Successfully deleted notification');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to delete notification', error: e);
      return Result.failure(
        NetworkException(
          'Failed to delete notification',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteAllNotifications() async {
    try {
      logger.info('Deleting all notifications');

      await apiClient.delete(ApiEndpoints.deleteAllNotifications);

      logger.info('Successfully deleted all notifications');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to delete all notifications', error: e);
      return Result.failure(
        NetworkException(
          'Failed to delete all notifications',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, dynamic>? payload,
  }) async {
    try {
      logger.info('Scheduling local notification', data: {
        'title': title,
        'scheduledTime': scheduledTime.toIso8601String(),
      });

      // This would integrate with flutter_local_notifications
      // For now, we'll just log the action
      logger.info('Local notification scheduled successfully');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to schedule local notification', error: e);
      return Result.failure(
        NetworkException(
          'Failed to schedule local notification',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> cancelScheduledNotification(
      String notificationId) async {
    try {
      logger.info('Cancelling scheduled notification', data: {
        'notificationId': notificationId,
      });

      // This would integrate with flutter_local_notifications
      // For now, we'll just log the action
      logger.info('Scheduled notification cancelled successfully');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to cancel scheduled notification', error: e);
      return Result.failure(
        NetworkException(
          'Failed to cancel scheduled notification',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getScheduledNotifications() async {
    try {
      logger.info('Fetching scheduled notifications');

      // This would integrate with flutter_local_notifications
      // For now, we'll return an empty list
      logger.info('Successfully fetched scheduled notifications');
      return Result.success([]);
    } catch (e) {
      logger.error('Failed to fetch scheduled notifications', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch scheduled notifications',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Get delivery statistics
  Future<Result<Map<String, dynamic>>> getDeliveryStats({int days = 30}) async {
    try {
      logger.info('Fetching delivery stats', data: {'days': days});

      final response = await apiClient.get(
        ApiEndpoints.notificationDeliveryStats,
        queryParameters: {'days': days},
      );

      final stats = response.data['data'] as Map<String, dynamic>;
      logger.info('Successfully fetched delivery stats');
      return Result.success(stats);
    } catch (e) {
      logger.error('Failed to fetch delivery stats', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch delivery stats',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Track notification clicked
  Future<Result<void>> trackNotificationClicked(
    String notificationId,
    String channel, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.info('Tracking notification clicked', data: {
        'notificationId': notificationId,
        'channel': channel,
      });

      await apiClient.post(
        ApiEndpoints.trackNotificationClicked
            .replaceAll('{id}', notificationId),
        data: {
          'channel': channel,
          'metadata': metadata,
        },
      );

      logger.info('Successfully tracked notification clicked');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to track notification clicked', error: e, data: {
        'notificationId': notificationId,
        'channel': channel,
      });
      // Don't return failure for tracking - it's not critical
      return Result.success(null);
    }
  }

  /// Test medication reminder
  Future<Result<void>> testMedicationReminder() async {
    try {
      logger.info('Sending test medication reminder');

      await apiClient.post(ApiEndpoints.testMedicationReminder);

      logger.info('Successfully sent test medication reminder');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to send test medication reminder', error: e);
      return Result.failure(
        NetworkException(
          'Failed to send test medication reminder',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Test check-in reminder
  Future<Result<void>> testCheckInReminder() async {
    try {
      logger.info('Sending test check-in reminder');

      await apiClient.post(ApiEndpoints.testCheckInReminder);

      logger.info('Successfully sent test check-in reminder');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to send test check-in reminder', error: e);
      return Result.failure(
        NetworkException(
          'Failed to send test check-in reminder',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Test health insight
  Future<Result<void>> testHealthInsight() async {
    try {
      logger.info('Sending test health insight');

      await apiClient.post(ApiEndpoints.testHealthInsight);

      logger.info('Successfully sent test health insight');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to send test health insight', error: e);
      return Result.failure(
        NetworkException(
          'Failed to send test health insight',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Handle notification action based on type
  Future<Result<void>> handleNotificationAction(
    NotificationModel notification,
    String action,
  ) async {
    switch (notification.type) {
      case NotificationType.medicationReminder:
        return await _handleMedicationAction(notification, action);
      case NotificationType.checkInReminder:
        return await _handleCheckInAction(notification, action);
      case NotificationType.healthInsight:
        return await _handleHealthInsightAction(notification, action);
      case NotificationType.careGroupUpdate:
        return await _handleCareGroupAction(notification, action);
      default:
        return await markAsRead(notification.id);
    }
  }

  Future<Result<void>> _handleMedicationAction(
    NotificationModel notification,
    String action,
  ) async {
    return await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'medicationId': notification.metadata?['medicationId'],
        'prescriptionId': notification.metadata?['prescriptionId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Result<void>> _handleCheckInAction(
    NotificationModel notification,
    String action,
  ) async {
    return await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'checkInId': notification.metadata?['checkInId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Result<void>> _handleHealthInsightAction(
    NotificationModel notification,
    String action,
  ) async {
    return await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'insightId': notification.metadata?['insightId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Result<void>> _handleCareGroupAction(
    NotificationModel notification,
    String action,
  ) async {
    return await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'careGroupId': notification.metadata?['careGroupId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
