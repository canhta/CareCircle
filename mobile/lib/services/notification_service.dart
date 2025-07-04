import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_models.dart';
import '../services/auth_service.dart';
import '../config/app_config.dart';

class NotificationService {
  final Dio _dio;
  final AuthService _authService;

  NotificationService(this._dio, this._authService);

  /// Get user notifications with pagination
  Future<NotificationPaginatedResponse> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/notifications',
        queryParameters: {
          'page': page,
          'limit': limit,
          'unreadOnly': unreadOnly.toString(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return NotificationPaginatedResponse.fromJson(data);
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
      throw Exception('Failed to load notifications: $e');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/$notificationId/mark-read',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to mark notification as read: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Get user notification preferences
  Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/notifications/preferences',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return NotificationPreferences.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load preferences: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notification preferences: $e');
      }
      throw Exception('Failed to load notification preferences: $e');
    }
  }

  /// Send a notification response (for actionable notifications)
  Future<void> sendNotificationResponse(
    String notificationId,
    String action, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/$notificationId/respond',
        data: {
          'action': action,
          'metadata': metadata,
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send notification response: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification response: $e');
      }
      throw Exception('Failed to send notification response: $e');
    }
  }

  /// Track notification opened
  Future<void> trackNotificationOpened(
    String notificationId,
    String channel, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/$notificationId/track-opened',
        data: {
          'channel': channel,
          'metadata': metadata,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking notification opened: $e');
      }
      // Don't throw error for tracking failures
    }
  }

  /// Track notification clicked
  Future<void> trackNotificationClicked(
    String notificationId,
    String channel, {
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/$notificationId/track-clicked',
        data: {
          'channel': channel,
          'metadata': metadata,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking notification clicked: $e');
      }
      // Don't throw error for tracking failures
    }
  }

  /// Get delivery statistics
  Future<Map<String, dynamic>> getDeliveryStats({int days = 30}) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      final response = await _dio.get(
        '${AppConfig.apiBaseUrl}/notifications/my-delivery-stats',
        queryParameters: {
          'days': days,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to load delivery stats: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading delivery stats: $e');
      }
      throw Exception('Failed to load delivery stats: $e');
    }
  }

  /// Test endpoints for development
  Future<void> testMedicationReminder() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/test/medication-reminder',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending test medication reminder: $e');
      }
      throw Exception('Failed to send test medication reminder: $e');
    }
  }

  Future<void> testCheckInReminder() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/test/check-in-reminder',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending test check-in reminder: $e');
      }
      throw Exception('Failed to send test check-in reminder: $e');
    }
  }

  Future<void> testHealthInsight() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      await _dio.post(
        '${AppConfig.apiBaseUrl}/notifications/test/health-insight',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending test health insight: $e');
      }
      throw Exception('Failed to send test health insight: $e');
    }
  }
}

/// Notification service extension for easy access
extension NotificationServiceExtension on NotificationService {
  /// Handle notification action based on type
  Future<void> handleNotificationAction(
    NotificationModel notification,
    String action,
  ) async {
    switch (notification.type) {
      case NotificationType.medicationReminder:
        await _handleMedicationAction(notification, action);
        break;
      case NotificationType.checkInReminder:
        await _handleCheckInAction(notification, action);
        break;
      case NotificationType.healthInsight:
        await _handleHealthInsightAction(notification, action);
        break;
      case NotificationType.careGroupUpdate:
        await _handleCareGroupAction(notification, action);
        break;
      default:
        await markAsRead(notification.id);
        break;
    }
  }

  Future<void> _handleMedicationAction(
    NotificationModel notification,
    String action,
  ) async {
    await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'medicationId': notification.metadata?['medicationId'],
        'prescriptionId': notification.metadata?['prescriptionId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _handleCheckInAction(
    NotificationModel notification,
    String action,
  ) async {
    await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'checkInId': notification.metadata?['checkInId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _handleHealthInsightAction(
    NotificationModel notification,
    String action,
  ) async {
    await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'insightId': notification.metadata?['insightId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _handleCareGroupAction(
    NotificationModel notification,
    String action,
  ) async {
    await sendNotificationResponse(
      notification.id,
      action,
      metadata: {
        'careGroupId': notification.metadata?['careGroupId'],
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
