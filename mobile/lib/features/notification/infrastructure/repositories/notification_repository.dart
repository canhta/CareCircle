import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/exceptions/notification_exceptions.dart';
import '../../domain/models/models.dart' as notification_models;
import '../services/notification_api_service.dart';
import '../services/notification_error_handler.dart';
import '../services/notification_retry_service.dart';
import '../services/notification_validator.dart';

/// Repository for notification data management
///
/// Provides offline-first data access with:
/// - Local caching with Hive
/// - API integration with healthcare-compliant logging
/// - Automatic cache invalidation
/// - Offline support for critical notifications
class NotificationRepository {
  final NotificationApiService _apiService;
  final SecureStorageService _secureStorage;
  final _logger = BoundedContextLoggers.notification;

  // Cache keys
  static const String _notificationsCacheKey = 'notifications_cache';
  static const String _preferencesCacheKey = 'notification_preferences_cache';
  static const String _lastSyncKey = 'notifications_last_sync';

  // Cache expiry duration
  static const Duration _cacheExpiry = Duration(minutes: 15);

  NotificationRepository(this._apiService, this._secureStorage);

  /// Get user notifications with optional filtering
  Future<List<notification_models.Notification>> getNotifications({
    int? limit,
    int? offset,
    bool useCache = true,
  }) async {
    try {
      _logger.info('Fetching user notifications', {
        'operation': 'getNotifications',
        'limit': limit,
        'offset': offset,
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedNotifications();
        if (cached != null && cached.isNotEmpty) {
          _logger.info('Returning cached notifications', {
            'count': cached.length,
            'source': 'cache',
          });
          return cached;
        }
      }

      // Fetch from API
      final response = await _apiService.getNotifications(limit, offset);
      final notifications = response.data;

      // Cache the results
      await _cacheNotifications(notifications);

      // Log access with sanitized summary
      _logger.logHealthDataAccess('Notifications accessed', {
        'dataType': 'notifications',
        'notificationCount': notifications.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return notifications;
    } on DioException catch (e) {
      _logger.error('Failed to fetch notifications', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Return cached data on error
      final cached = await _getCachedNotifications();
      if (cached != null) {
        _logger.info('Returning cached notifications due to API error', {
          'count': cached.length,
        });
        return cached;
      }

      throw _handleError(e);
    }
  }

  /// Get unread notifications
  Future<List<notification_models.Notification>>
  getUnreadNotifications() async {
    try {
      _logger.info('Fetching unread notifications', {
        'operation': 'getUnreadNotifications',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getUnreadNotifications();
      final notifications = response.data;

      _logger.logHealthDataAccess('Unread notifications accessed', {
        'dataType': 'unread_notifications',
        'count': notifications.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return notifications;
    } on DioException catch (e) {
      _logger.error('Failed to fetch unread notifications', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get notification summary
  Future<notification_models.NotificationSummary>
  getNotificationSummary() async {
    try {
      _logger.info('Fetching notification summary', {
        'operation': 'getNotificationSummary',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getNotificationSummary();
      if (response.data == null) {
        throw Exception(
          'Failed to fetch notification summary: No data received',
        );
      }
      return response.data!;
    } on DioException catch (e) {
      _logger.error('Failed to fetch notification summary', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get specific notification by ID
  Future<notification_models.Notification> getNotification(String id) async {
    try {
      _logger.info('Fetching notification details', {
        'operation': 'getNotification',
        'notificationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getNotification(id);
      if (response.data == null) {
        throw Exception('Failed to fetch notification: No data received');
      }
      return response.data!;
    } on DioException catch (e) {
      _logger.error('Failed to fetch notification details', {
        'notificationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Mark notification as read
  Future<notification_models.Notification> markAsRead(String id) async {
    try {
      _logger.info('Marking notification as read', {
        'operation': 'markAsRead',
        'notificationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.markAsRead(id);

      if (response.data == null) {
        throw Exception(
          'Failed to mark notification as read: No data received',
        );
      }

      // Update cache
      await _updateNotificationInCache(response.data!);

      _logger.logHealthDataAccess('Notification marked as read', {
        'dataType': 'notification_interaction',
        'notificationId': id,
        'action': 'mark_read',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return response.data!;
    } on DioException catch (e) {
      _logger.error('Failed to mark notification as read', {
        'notificationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      _logger.info('Marking all notifications as read', {
        'operation': 'markAllAsRead',
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.markAllAsRead();

      // Clear cache to force refresh
      await _clearNotificationCache();

      _logger.logHealthDataAccess('All notifications marked as read', {
        'dataType': 'notification_bulk_operation',
        'action': 'mark_all_read',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      _logger.error('Failed to mark all notifications as read', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Create new notification with comprehensive validation and error handling
  Future<notification_models.Notification> createNotification(
    notification_models.CreateNotificationRequest request,
  ) async {
    // Validate request
    NotificationValidator.validateCreateNotificationRequest(request);

    return NotificationRetryService.executeWithRetry(
      () async {
        try {
          _logger.info('Creating new notification', {
            'operation': 'createNotification',
            'type': request.type.name,
            'priority': request.priority.name,
            'timestamp': DateTime.now().toIso8601String(),
          });

          final response = await _apiService.createNotification(request);
          final notification = response.data;

          if (notification == null) {
            throw NotificationServiceException(
              'Failed to create notification: No data received from server',
              code: 'NO_DATA_RECEIVED',
              details: {'operation': 'createNotification'},
            );
          }

          // Clear cache to force refresh
          await _clearNotificationCache();

          _logger.logHealthDataAccess('Notification created successfully', {
            'dataType': 'notification',
            'notificationId': notification.id,
            'type': notification.type.name,
            'priority': notification.priority.name,
            'timestamp': DateTime.now().toIso8601String(),
          });

          return notification;
        } catch (error, stackTrace) {
          throw NotificationErrorHandler.handleException(
            error,
            stackTrace: stackTrace,
            context: {
              'operation': 'createNotification',
              'requestType': request.type.name,
              'requestPriority': request.priority.name,
            },
          );
        }
      },
      operationName: 'createNotification',
      maxAttempts: 3,
      context: {'type': request.type.name, 'priority': request.priority.name},
    );
  }

  /// Get notification preferences
  Future<notification_models.NotificationPreferences>
  getNotificationPreferences({bool useCache = true}) async {
    try {
      _logger.info('Fetching notification preferences', {
        'operation': 'getNotificationPreferences',
        'useCache': useCache,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try cache first if enabled
      if (useCache) {
        final cached = await _getCachedPreferences();
        if (cached != null) {
          _logger.info('Returning cached preferences', {'source': 'cache'});
          return cached;
        }
      }

      final response = await _apiService.getNotificationPreferences();
      final preferences = response.data;

      if (preferences == null) {
        throw Exception(
          'Failed to fetch notification preferences: No data received',
        );
      }

      // Cache the results
      await _cachePreferences(preferences);

      return preferences;
    } on DioException catch (e) {
      _logger.error('Failed to fetch notification preferences', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Return cached data on error
      final cached = await _getCachedPreferences();
      if (cached != null) {
        return cached;
      }

      throw _handleError(e);
    }
  }

  /// Update notification preferences
  Future<notification_models.NotificationPreferences>
  updateNotificationPreferences(
    notification_models.UpdateNotificationPreferencesRequest request,
  ) async {
    try {
      _logger.info('Updating notification preferences', {
        'operation': 'updateNotificationPreferences',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.updateNotificationPreferences(request);
      final preferences = response.data;

      if (preferences == null) {
        throw Exception(
          'Failed to update notification preferences: No data received',
        );
      }

      // Update cache
      await _cachePreferences(preferences);

      _logger.logHealthDataAccess('Notification preferences updated', {
        'dataType': 'notification_preferences',
        'timestamp': DateTime.now().toIso8601String(),
      });

      return preferences;
    } on DioException catch (e) {
      _logger.error('Failed to update notification preferences', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  // Cache management methods
  Future<List<notification_models.Notification>?>
  _getCachedNotifications() async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      final cachedData = box.get(_notificationsCacheKey);
      final lastSync = box.get(_lastSyncKey);

      if (cachedData != null && lastSync != null) {
        final lastSyncTime = DateTime.parse(lastSync);
        if (DateTime.now().difference(lastSyncTime) < _cacheExpiry) {
          // Parse cached JSON data
          final List<dynamic> jsonList =
              (await _secureStorage.decryptData(cachedData)) as List<dynamic>;
          return jsonList
              .map(
                (json) => notification_models.Notification.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
        }
      }
      return null;
    } catch (e) {
      _logger.warning('Failed to read cached notifications', {
        'error': e.toString(),
      });
      return null;
    }
  }

  Future<void> _cacheNotifications(
    List<notification_models.Notification> notifications,
  ) async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      final jsonList = notifications.map((n) => n.toJson()).toList();
      final encryptedData = await _secureStorage.encryptData(jsonList);

      await box.put(_notificationsCacheKey, encryptedData);
      await box.put(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      _logger.warning('Failed to cache notifications', {'error': e.toString()});
    }
  }

  Future<notification_models.NotificationPreferences?>
  _getCachedPreferences() async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      final cachedData = box.get(_preferencesCacheKey);

      if (cachedData != null) {
        final json =
            await _secureStorage.decryptData(cachedData)
                as Map<String, dynamic>;
        return notification_models.NotificationPreferences.fromJson(json);
      }
      return null;
    } catch (e) {
      _logger.warning('Failed to read cached preferences', {
        'error': e.toString(),
      });
      return null;
    }
  }

  Future<void> _cachePreferences(
    notification_models.NotificationPreferences preferences,
  ) async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      final encryptedData = await _secureStorage.encryptData(
        preferences.toJson(),
      );
      await box.put(_preferencesCacheKey, encryptedData);
    } catch (e) {
      _logger.warning('Failed to cache preferences', {'error': e.toString()});
    }
  }

  Future<void> _updateNotificationInCache(
    notification_models.Notification notification,
  ) async {
    try {
      final cached = await _getCachedNotifications();
      if (cached != null) {
        final index = cached.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          cached[index] = notification;
          await _cacheNotifications(cached);
        }
      }
    } catch (e) {
      _logger.warning('Failed to update notification in cache', {
        'error': e.toString(),
      });
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      _logger.info('Deleting notification', {
        'notificationId': notificationId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.deleteNotification(notificationId);

      // Remove from cache
      await _removeNotificationFromCache(notificationId);

      _logger.info('Notification deleted successfully', {
        'notificationId': notificationId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      _logger.error('Failed to delete notification', {
        'notificationId': notificationId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    } catch (e) {
      _logger.error('Unexpected error deleting notification', {
        'notificationId': notificationId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  Future<void> _removeNotificationFromCache(String notificationId) async {
    try {
      final cached = await _getCachedNotifications();
      if (cached != null) {
        final updated = cached.where((n) => n.id != notificationId).toList();
        await _cacheNotifications(updated);
      }
    } catch (e) {
      _logger.warning('Failed to remove notification from cache', {
        'notificationId': notificationId,
        'error': e.toString(),
      });
    }
  }

  Future<void> _clearNotificationCache() async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      await box.delete(_notificationsCacheKey);
      await box.delete(_lastSyncKey);
    } catch (e) {
      _logger.warning('Failed to clear notification cache', {
        'error': e.toString(),
      });
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Request timeout. Please check your connection.');
      case DioExceptionType.badResponse:
        return Exception(e.response?.data?['message'] ?? 'Request failed');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception(
          'Connection error. Please check your internet connection.',
        );
      default:
        return Exception('An unexpected error occurred');
    }
  }

  /// Get emergency alerts
  Future<List<notification_models.EmergencyAlert>> getEmergencyAlerts() async {
    try {
      _logger.info('Fetching emergency alerts', {
        'operation': 'getEmergencyAlerts',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getEmergencyAlerts(
        null,
        null,
        null,
        null,
      );
      final alerts = response.data;

      _logger.logHealthDataAccess('Emergency alerts accessed', {
        'dataType': 'emergency_alerts',
        'count': alerts.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return alerts;
    } on DioException catch (e) {
      _logger.error('Failed to fetch emergency alerts', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Create emergency alert
  Future<notification_models.EmergencyAlert> createEmergencyAlert(
    notification_models.EmergencyAlert alert,
  ) async {
    try {
      _logger.info('Creating emergency alert', {
        'operation': 'createEmergencyAlert',
        'alertType': alert.alertType.name,
        'severity': alert.severity.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final request = notification_models.CreateEmergencyAlertRequest(
        title: alert.title,
        message: alert.message,
        alertType: alert.alertType,
        severity: alert.severity,
        metadata: alert.metadata,
      );

      final response = await _apiService.createEmergencyAlert(request);
      final createdAlert = response.data;

      if (createdAlert == null) {
        throw Exception('Failed to create emergency alert: No data received');
      }

      _logger.logHealthDataAccess('Emergency alert created', {
        'dataType': 'emergency_alert',
        'alertId': createdAlert.id,
        'alertType': createdAlert.alertType.name,
        'severity': createdAlert.severity.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return createdAlert;
    } on DioException catch (e) {
      _logger.error('Failed to create emergency alert', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get emergency alert history
  Future<List<notification_models.EmergencyAlert>>
  getEmergencyAlertHistory() async {
    try {
      _logger.info('Fetching emergency alert history', {
        'operation': 'getEmergencyAlertHistory',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _apiService.getEmergencyAlerts(
        null,
        null,
        null,
        null,
      );
      final alerts = response.data;

      _logger.logHealthDataAccess('Emergency alert history accessed', {
        'dataType': 'emergency_alert_history',
        'count': alerts.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return alerts;
    } on DioException catch (e) {
      _logger.error('Failed to fetch emergency alert history', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Reset notification preferences to defaults
  Future<void> resetNotificationPreferencesToDefaults() async {
    try {
      _logger.info('Resetting notification preferences to defaults', {
        'operation': 'resetNotificationPreferencesToDefaults',
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _apiService.resetPreferencesToDefault();

      // Clear preferences cache
      await _clearPreferencesCache();

      _logger
          .logHealthDataAccess('Notification preferences reset to defaults', {
            'dataType': 'notification_preferences',
            'action': 'reset_to_defaults',
            'timestamp': DateTime.now().toIso8601String(),
          });
    } on DioException catch (e) {
      _logger.error('Failed to reset notification preferences to defaults', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Clear preferences cache
  Future<void> _clearPreferencesCache() async {
    try {
      final box = await Hive.openBox<String>('notification_cache');
      await box.delete(_preferencesCacheKey);
    } catch (e) {
      _logger.warning('Failed to clear preferences cache', {
        'error': e.toString(),
      });
    }
  }
}
