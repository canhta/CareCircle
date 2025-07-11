import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart' as notification_models;

/// Background message handler for Firebase Cloud Messaging
///
/// This handler runs in a separate isolate and must be a top-level function.
/// It handles messages when the app is in the background or terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Hive for background storage
  await Hive.initFlutter();

  final handler = BackgroundMessageHandler();
  await handler.handleBackgroundMessage(message);
}

/// Background message handler class
class BackgroundMessageHandler {
  static const String _backgroundMessagesBox = 'background_messages';
  static const String _notificationCounterKey = 'notification_counter';

  final _logger = BoundedContextLoggers.notification;

  /// Handle background message
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    try {
      _logger.info('Handling background message', {
        'messageId': message.messageId,
        'title': message.notification?.title,
        'hasData': message.data.isNotEmpty,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Store message for later processing
      await _storeBackgroundMessage(message);

      // Show local notification if needed
      await _showBackgroundNotification(message);

      // Update badge count
      await _updateBadgeCount();

      // Process emergency alerts immediately
      if (_isEmergencyAlert(message)) {
        await _handleEmergencyAlert(message);
      }

      _logger.info('Background message handled successfully', {
        'messageId': message.messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to handle background message', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Store background message for later processing
  Future<void> _storeBackgroundMessage(RemoteMessage message) async {
    try {
      final box = await Hive.openBox<String>(_backgroundMessagesBox);

      final messageData = {
        'messageId': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'receivedAt': DateTime.now().toIso8601String(),
        'processed': false,
      };

      await box.put(
        message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        jsonEncode(messageData),
      );

      _logger.info('Background message stored', {
        'messageId': message.messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to store background message', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Show local notification for background message
  Future<void> _showBackgroundNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      // Don't show notification if it's a silent data message
      if (message.data['silent'] == 'true') return;

      final localNotifications = FlutterLocalNotificationsPlugin();

      // Initialize if not already done
      await _initializeLocalNotifications(localNotifications);

      final notificationType = _getNotificationTypeFromData(message.data);
      final androidDetails = _getAndroidNotificationDetails(notificationType);
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await localNotifications.show(
        message.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode({
          ...message.data,
          'messageId': message.messageId,
          'source': 'background',
        }),
      );

      _logger.info('Background notification shown', {
        'messageId': message.messageId,
        'title': notification.title,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to show background notification', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Initialize local notifications for background handler
  Future<void> _initializeLocalNotifications(
    FlutterLocalNotificationsPlugin localNotifications,
  ) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await localNotifications.initialize(initializationSettings);

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels(localNotifications);
    }
  }

  /// Create notification channels for background notifications
  Future<void> _createNotificationChannels(
    FlutterLocalNotificationsPlugin localNotifications,
  ) async {
    final androidPlugin = localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // General notifications channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'general_notifications',
          'General Notifications',
          description: 'General app notifications',
          importance: Importance.defaultImportance,
        ),
      );

      // Medication reminders channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'medication_reminders',
          'Medication Reminders',
          description: 'Medication reminder notifications',
          importance: Importance.high,
        ),
      );

      // Health alerts channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'health_alerts',
          'Health Alerts',
          description: 'Health alert notifications',
          importance: Importance.high,
        ),
      );

      // Emergency alerts channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'emergency_alerts',
          'Emergency Alerts',
          description: 'Emergency alert notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          ledColor: Color.fromARGB(255, 255, 0, 0),
        ),
      );
    }
  }

  /// Get Android notification details based on type
  AndroidNotificationDetails _getAndroidNotificationDetails(
    notification_models.NotificationType type,
  ) {
    switch (type) {
      case notification_models.NotificationType.medicationReminder:
        return const AndroidNotificationDetails(
          'medication_reminders',
          'Medication Reminders',
          channelDescription: 'Medication reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_medication',
          color: CareCircleDesignTokens.primaryMedicalBlue,
        );
      case notification_models.NotificationType.healthAlert:
        return const AndroidNotificationDetails(
          'health_alerts',
          'Health Alerts',
          channelDescription: 'Health alert notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_health_alert',
          color: CareCircleDesignTokens.warningOrange,
        );
      case notification_models.NotificationType.emergencyAlert:
        return const AndroidNotificationDetails(
          'emergency_alerts',
          'Emergency Alerts',
          channelDescription: 'Emergency alert notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/ic_emergency',
          color: CareCircleDesignTokens.errorRed,
          enableVibration: true,
          enableLights: true,
          ledColor: CareCircleDesignTokens.errorRed,
          fullScreenIntent: true,
        );
      default:
        return const AndroidNotificationDetails(
          'general_notifications',
          'General Notifications',
          channelDescription: 'General app notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );
    }
  }

  /// Update badge count
  Future<void> _updateBadgeCount() async {
    try {
      final box = await Hive.openBox<int>('notification_settings');
      final currentCount =
          box.get(_notificationCounterKey, defaultValue: 0) ?? 0;
      await box.put(_notificationCounterKey, currentCount + 1);

      _logger.info('Badge count updated', {
        'newCount': currentCount + 1,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to update badge count', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Check if message is an emergency alert
  bool _isEmergencyAlert(RemoteMessage message) {
    final type = message.data['type'] as String?;
    return type?.toUpperCase() == 'EMERGENCY_ALERT';
  }

  /// Handle emergency alert with special processing
  Future<void> _handleEmergencyAlert(RemoteMessage message) async {
    try {
      _logger.info('Handling emergency alert in background', {
        'messageId': message.messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Store emergency alert with high priority flag
      final box = await Hive.openBox<String>('emergency_alerts');
      final alertData = {
        'messageId': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'receivedAt': DateTime.now().toIso8601String(),
        'priority': 'CRITICAL',
        'processed': false,
      };

      await box.put(
        message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        jsonEncode(alertData),
      );

      // Show high-priority notification
      await _showEmergencyNotification(message);

      _logger.info('Emergency alert handled in background', {
        'messageId': message.messageId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to handle emergency alert in background', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Show emergency notification with full screen intent
  Future<void> _showEmergencyNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      final localNotifications = FlutterLocalNotificationsPlugin();
      await _initializeLocalNotifications(localNotifications);

      const androidDetails = AndroidNotificationDetails(
        'emergency_alerts',
        'Emergency Alerts',
        channelDescription: 'Emergency alert notifications',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@drawable/ic_emergency',
        color: CareCircleDesignTokens.errorRed,
        enableVibration: true,
        enableLights: true,
        ledColor: CareCircleDesignTokens.errorRed,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        ongoing: true, // Make it persistent
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await localNotifications.show(
        999999, // Use high ID for emergency alerts
        '🚨 ${notification.title}',
        notification.body,
        notificationDetails,
        payload: jsonEncode({
          ...message.data,
          'messageId': message.messageId,
          'source': 'emergency_background',
        }),
      );
    } catch (e) {
      _logger.error('Failed to show emergency notification', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Get notification type from message data
  notification_models.NotificationType _getNotificationTypeFromData(
    Map<String, dynamic> data,
  ) {
    final typeString = data['type'] as String?;
    if (typeString != null) {
      try {
        return notification_models.NotificationType.values.firstWhere(
          (type) => type.name.toUpperCase() == typeString.toUpperCase(),
        );
      } catch (e) {
        return notification_models.NotificationType.systemNotification;
      }
    }
    return notification_models.NotificationType.systemNotification;
  }

  /// Get stored background messages
  static Future<List<Map<String, dynamic>>>
  getStoredBackgroundMessages() async {
    try {
      final box = await Hive.openBox<String>(_backgroundMessagesBox);
      final messages = <Map<String, dynamic>>[];

      for (final key in box.keys) {
        final messageJson = box.get(key);
        if (messageJson != null) {
          final messageData = jsonDecode(messageJson) as Map<String, dynamic>;
          messages.add(messageData);
        }
      }

      // Sort by received time (newest first)
      messages.sort((a, b) {
        final aTime = DateTime.parse(a['receivedAt'] as String);
        final bTime = DateTime.parse(b['receivedAt'] as String);
        return bTime.compareTo(aTime);
      });

      return messages;
    } catch (e) {
      BoundedContextLoggers.notification.error(
        'Failed to get stored background messages',
        {'error': e.toString(), 'timestamp': DateTime.now().toIso8601String()},
      );
      return [];
    }
  }

  /// Mark background message as processed
  static Future<void> markMessageAsProcessed(String messageId) async {
    try {
      final box = await Hive.openBox<String>(_backgroundMessagesBox);
      final messageJson = box.get(messageId);

      if (messageJson != null) {
        final messageData = jsonDecode(messageJson) as Map<String, dynamic>;
        messageData['processed'] = true;
        messageData['processedAt'] = DateTime.now().toIso8601String();

        await box.put(messageId, jsonEncode(messageData));
      }
    } catch (e) {
      BoundedContextLoggers.notification
          .error('Failed to mark message as processed', {
            'messageId': messageId,
            'error': e.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          });
    }
  }

  /// Clear old background messages
  static Future<void> clearOldBackgroundMessages({int daysToKeep = 7}) async {
    try {
      final box = await Hive.openBox<String>(_backgroundMessagesBox);
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      final keysToDelete = <String>[];

      for (final key in box.keys) {
        final messageJson = box.get(key);
        if (messageJson != null) {
          final messageData = jsonDecode(messageJson) as Map<String, dynamic>;
          final receivedAt = DateTime.parse(
            messageData['receivedAt'] as String,
          );

          if (receivedAt.isBefore(cutoffDate)) {
            keysToDelete.add(key as String);
          }
        }
      }

      for (final key in keysToDelete) {
        await box.delete(key);
      }

      BoundedContextLoggers.notification
          .info('Cleared old background messages', {
            'deletedCount': keysToDelete.length,
            'daysToKeep': daysToKeep,
            'timestamp': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      BoundedContextLoggers.notification.error(
        'Failed to clear old background messages',
        {'error': e.toString(), 'timestamp': DateTime.now().toIso8601String()},
      );
    }
  }
}
