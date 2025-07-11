import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/models.dart' as notification_models;
import '../../infrastructure/repositories/notification_repository.dart';
import '../../infrastructure/services/notification_api_service.dart';
import '../../infrastructure/services/fcm_service.dart';

// Healthcare-compliant logger for notification context
final _logger = BoundedContextLoggers.notification;

/// Provider for secure storage service
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider for notification API service
final notificationApiServiceProvider = Provider<NotificationApiService>((ref) {
  final dio = ref.read(dioProvider);
  return NotificationApiService(dio);
});

/// Provider for notification repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiService = ref.read(notificationApiServiceProvider);
  final secureStorage = ref.read(secureStorageServiceProvider);
  return NotificationRepository(apiService, secureStorage);
});

/// Provider for Firebase Messaging instance
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

/// Provider for Flutter Local Notifications
final flutterLocalNotificationsProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
    });

/// Provider for FCM service
final fcmServiceProvider = Provider<FCMService>((ref) {
  final firebaseMessaging = ref.read(firebaseMessagingProvider);
  final localNotifications = ref.read(flutterLocalNotificationsProvider);
  final apiService = ref.read(notificationApiServiceProvider);
  final secureStorage = ref.read(secureStorageServiceProvider);

  return FCMService(
    firebaseMessaging,
    localNotifications,
    apiService,
    secureStorage,
  );
});

/// Provider for user notifications list
final notificationsProvider =
    FutureProvider<List<notification_models.Notification>>((ref) async {
      final repository = ref.read(notificationRepositoryProvider);
      return repository.getNotifications();
    });

/// Provider for unread notifications
final unreadNotificationsProvider =
    FutureProvider<List<notification_models.Notification>>((ref) async {
      final repository = ref.read(notificationRepositoryProvider);
      return repository.getUnreadNotifications();
    });

/// Provider for notification summary
final notificationSummaryProvider =
    FutureProvider<notification_models.NotificationSummary>((ref) async {
      final repository = ref.read(notificationRepositoryProvider);
      return repository.getNotificationSummary();
    });

/// Provider for notification preferences
final notificationPreferencesProvider =
    FutureProvider<notification_models.NotificationPreferences>((ref) async {
      final repository = ref.read(notificationRepositoryProvider);
      return repository.getNotificationPreferences();
    });

/// State provider for notification filters
final notificationTypeFilterProvider =
    StateProvider<notification_models.NotificationType?>((ref) => null);
final notificationPriorityFilterProvider =
    StateProvider<notification_models.NotificationPriority?>((ref) => null);
final notificationStatusFilterProvider =
    StateProvider<notification_models.NotificationStatus?>((ref) => null);
final notificationSearchTermProvider = StateProvider<String>((ref) => '');

/// State provider for notification center UI state
final notificationCenterTabProvider = StateProvider<int>((ref) => 0);
final showOnlyUnreadProvider = StateProvider<bool>((ref) => false);

/// Notifier for notification CRUD operations
class NotificationNotifier
    extends StateNotifier<AsyncValue<List<notification_models.Notification>>> {
  final NotificationRepository _repository;
  final Ref _ref;

  NotificationNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  /// Load notifications from repository
  Future<void> loadNotifications({bool forceRefresh = false}) async {
    try {
      state = const AsyncValue.loading();
      final notifications = await _repository.getNotifications(
        useCache: !forceRefresh,
      );
      state = AsyncValue.data(notifications);

      _logger.info('Notifications loaded successfully', {
        'count': notifications.length,
        'forceRefresh': forceRefresh,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _logger.error('Failed to load notifications', {
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);

      // Update local state
      state = state.whenData((notifications) {
        return notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(
              status: notification_models.NotificationStatus.read,
              readAt: DateTime.now(),
            );
          }
          return notification;
        }).toList();
      });

      // Invalidate related providers
      _ref.invalidate(unreadNotificationsProvider);
      _ref.invalidate(notificationSummaryProvider);

      _logger.info('Notification marked as read', {
        'notificationId': notificationId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to mark notification as read', {
        'notificationId': notificationId,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Create new notification
  Future<void> createNotification(
    notification_models.CreateNotificationRequest request,
  ) async {
    try {
      final notification = await _repository.createNotification(request);

      // Add to local state
      state = state.whenData((notifications) {
        return [notification, ...notifications];
      });

      // Invalidate related providers
      _ref.invalidate(unreadNotificationsProvider);
      _ref.invalidate(notificationSummaryProvider);

      _logger.info('Notification created successfully', {
        'notificationId': notification.id,
        'type': notification.type.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to create notification', {
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);

      // Remove from local state
      state = state.whenData((notifications) {
        return notifications.where((n) => n.id != notificationId).toList();
      });

      // Invalidate related providers
      _ref.invalidate(unreadNotificationsProvider);
      _ref.invalidate(notificationSummaryProvider);

      _logger.info('Notification deleted successfully', {
        'notificationId': notificationId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      _logger.error('Failed to delete notification', {
        'notificationId': notificationId,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await loadNotifications(forceRefresh: true);
  }
}

/// Provider for notification notifier
final notificationNotifierProvider =
    StateNotifierProvider<
      NotificationNotifier,
      AsyncValue<List<notification_models.Notification>>
    >((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return NotificationNotifier(repository, ref);
    });

/// Notifier for notification preferences
class NotificationPreferencesNotifier
    extends
        StateNotifier<AsyncValue<notification_models.NotificationPreferences>> {
  final NotificationRepository _repository;
  final Ref _ref;

  NotificationPreferencesNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadPreferences();
  }

  /// Load notification preferences
  Future<void> loadPreferences({bool forceRefresh = false}) async {
    try {
      state = const AsyncValue.loading();
      final preferences = await _repository.getNotificationPreferences(
        useCache: !forceRefresh,
      );
      state = AsyncValue.data(preferences);

      _logger.info('Notification preferences loaded successfully', {
        'forceRefresh': forceRefresh,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _logger.error('Failed to load notification preferences', {
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Update notification preferences
  Future<void> updatePreferences(
    notification_models.UpdateNotificationPreferencesRequest request,
  ) async {
    try {
      final preferences = await _repository.updateNotificationPreferences(
        request,
      );
      state = AsyncValue.data(preferences);

      // Invalidate related providers when preferences change
      _ref.invalidate(notificationSummaryProvider);

      _logger.info('Notification preferences updated successfully', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      _logger.error('Failed to update notification preferences', {
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Toggle global notifications
  Future<void> toggleGlobalNotifications(bool enabled) async {
    try {
      final request = notification_models.UpdateNotificationPreferencesRequest(
        globalEnabled: enabled,
      );
      await updatePreferences(request);
    } catch (error) {
      rethrow;
    }
  }

  /// Update context-specific preference
  Future<void> updateContextPreference(
    notification_models.ContextType contextType,
    bool enabled,
  ) async {
    try {
      // Create a context preference update
      final contextPreferences = <String, bool>{
        contextType.name: enabled,
      };

      final request = notification_models.UpdateNotificationPreferencesRequest(
        contextPreferences: contextPreferences,
      );
      await updatePreferences(request);
    } catch (error) {
      rethrow;
    }
  }

  /// Update quiet hours settings
  Future<void> updateQuietHours(
    notification_models.QuietHoursSettings quietHours,
  ) async {
    try {
      final request = notification_models.UpdateNotificationPreferencesRequest(
        quietHours: quietHours,
      );
      await updatePreferences(request);
    } catch (error) {
      rethrow;
    }
  }

  /// Update emergency alert settings
  Future<void> updateEmergencySettings(
    notification_models.EmergencyAlertSettings emergencySettings,
  ) async {
    try {
      final request = notification_models.UpdateNotificationPreferencesRequest(
        emergencySettings: emergencySettings,
      );
      await updatePreferences(request);
    } catch (error) {
      rethrow;
    }
  }

  /// Refresh preferences
  Future<void> refresh() async {
    await loadPreferences(forceRefresh: true);
  }
}

/// Provider for notification preferences notifier
final notificationPreferencesNotifierProvider =
    StateNotifierProvider<
      NotificationPreferencesNotifier,
      AsyncValue<notification_models.NotificationPreferences>
    >((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return NotificationPreferencesNotifier(repository, ref);
    });

/// Computed provider for filtered notifications
final filteredNotificationsProvider =
    Provider<AsyncValue<List<notification_models.Notification>>>((ref) {
      final notifications = ref.watch(notificationNotifierProvider);
      final typeFilter = ref.watch(notificationTypeFilterProvider);
      final priorityFilter = ref.watch(notificationPriorityFilterProvider);
      final statusFilter = ref.watch(notificationStatusFilterProvider);
      final searchTerm = ref.watch(notificationSearchTermProvider);
      final showOnlyUnread = ref.watch(showOnlyUnreadProvider);

      return notifications.when(
        data: (notifs) {
          var filtered = notifs.where((notification) {
            // Type filter
            if (typeFilter != null && notification.type != typeFilter) {
              return false;
            }

            // Priority filter
            if (priorityFilter != null &&
                notification.priority != priorityFilter) {
              return false;
            }

            // Status filter
            if (statusFilter != null && notification.status != statusFilter) {
              return false;
            }

            // Unread filter
            if (showOnlyUnread &&
                notification.status ==
                    notification_models.NotificationStatus.read) {
              return false;
            }

            // Search term filter
            if (searchTerm.isNotEmpty) {
              final searchLower = searchTerm.toLowerCase();
              if (!notification.title.toLowerCase().contains(searchLower) &&
                  !notification.message.toLowerCase().contains(searchLower)) {
                return false;
              }
            }

            return true;
          }).toList();

          // Sort by creation date (newest first)
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return AsyncValue.data(filtered);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    });

/// Provider for notification statistics
final notificationStatisticsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final notifications = await ref.watch(notificationsProvider.future);

  final stats = {
    'total': notifications.length,
    'unread': notifications
        .where((n) => n.status != notification_models.NotificationStatus.read)
        .length,
    'byType': <String, int>{},
    'byPriority': <String, int>{},
    'byStatus': <String, int>{},
    'todayCount': notifications
        .where(
          (n) => n.createdAt.isAfter(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
        )
        .length,
    'thisWeekCount': notifications
        .where(
          (n) => n.createdAt.isAfter(
            DateTime.now().subtract(const Duration(days: 7)),
          ),
        )
        .length,
  };

  // Count by type
  final byType = stats['byType'] as Map<String, int>;
  for (final notification in notifications) {
    final type = notification.type.displayName;
    byType[type] = (byType[type] ?? 0) + 1;
  }

  // Count by priority
  final byPriority = stats['byPriority'] as Map<String, int>;
  for (final notification in notifications) {
    final priority = notification.priority.displayName;
    byPriority[priority] = (byPriority[priority] ?? 0) + 1;
  }

  // Count by status
  final byStatus = stats['byStatus'] as Map<String, int>;
  for (final notification in notifications) {
    final status = notification.status.name;
    byStatus[status] = (byStatus[status] ?? 0) + 1;
  }

  return stats;
});

/// Provider for unread notification count
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final summary = await ref.watch(notificationSummaryProvider.future);
  return summary.unread;
});

/// Provider for notification service initialization
final notificationServiceProvider = FutureProvider<void>((ref) async {
  final fcmService = ref.read(fcmServiceProvider);
  await fcmService.initialize();

  _logger.info('Notification service initialized', {
    'timestamp': DateTime.now().toIso8601String(),
  });
});
