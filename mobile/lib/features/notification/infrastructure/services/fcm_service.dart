import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as local_notifications;

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/design/design_tokens.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/models.dart' as notification_models;
import 'notification_api_service.dart';

/// Firebase Cloud Messaging service for push notifications
///
/// Handles:
/// - FCM token management and registration
/// - Foreground message handling
/// - Background message processing
/// - Local notification display
/// - Message action handling
class FCMService {
  final FirebaseMessaging _firebaseMessaging;
  final local_notifications.FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationApiService _apiService;
  final SecureStorageService _secureStorage;
  final _logger = BoundedContextLoggers.notification;

  static const String _fcmTokenKey = 'fcm_token';
  static const String _lastTokenUpdateKey = 'fcm_token_last_update';

  FCMService(
    this._firebaseMessaging,
    this._localNotifications,
    this._apiService,
    this._secureStorage,
  );

  /// Initialize FCM service
  Future<void> initialize() async {
    try {
      _logger.info('Initializing FCM service', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request notification permissions
      await _requestPermissions();

      // Get and register FCM token
      await _initializeFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      _logger.info('FCM service initialized successfully', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to initialize FCM service', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = local_notifications.AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = local_notifications.DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = local_notifications.InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels for different types
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          local_notifications.AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // General notifications channel
      await androidPlugin.createNotificationChannel(
        const local_notifications.AndroidNotificationChannel(
          'general_notifications',
          'General Notifications',
          description: 'General app notifications',
          importance: local_notifications.Importance.defaultImportance,
        ),
      );

      // Medication reminders channel
      await androidPlugin.createNotificationChannel(
        const local_notifications.AndroidNotificationChannel(
          'medication_reminders',
          'Medication Reminders',
          description: 'Medication reminder notifications',
          importance: local_notifications.Importance.high,
          sound: local_notifications.RawResourceAndroidNotificationSound(
            'medication_reminder',
          ),
        ),
      );

      // Health alerts channel
      await androidPlugin.createNotificationChannel(
        const local_notifications.AndroidNotificationChannel(
          'health_alerts',
          'Health Alerts',
          description: 'Health alert notifications',
          importance: local_notifications.Importance.high,
        ),
      );

      // Emergency alerts channel
      await androidPlugin.createNotificationChannel(
        const local_notifications.AndroidNotificationChannel(
          'emergency_alerts',
          'Emergency Alerts',
          description: 'Emergency alert notifications',
          importance: local_notifications.Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          ledColor: CareCircleDesignTokens.errorRed,
        ),
      );
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    _logger.info('Notification permission status', {
      'authorizationStatus': settings.authorizationStatus.name,
      'alert': settings.alert.name,
      'badge': settings.badge.name,
      'sound': settings.sound.name,
      'criticalAlert': settings.criticalAlert.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      _logger.warning('Notification permissions denied by user');
      throw Exception('Notification permissions are required for this app');
    }
  }

  /// Initialize and register FCM token
  Future<void> _initializeFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _registerToken(token);
        await _secureStorage.store(_fcmTokenKey, token);
        await _secureStorage.store(
          _lastTokenUpdateKey,
          DateTime.now().toIso8601String(),
        );

        _logger.info('FCM token obtained and registered', {
          'tokenLength': token.length,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
    } catch (e) {
      _logger.error('Failed to initialize FCM token', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    try {
      _logger.info('FCM token refreshed', {
        'tokenLength': token.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _registerToken(token);
      await _secureStorage.store(_fcmTokenKey, token);
      await _secureStorage.store(
        _lastTokenUpdateKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      _logger.error('Failed to handle token refresh', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Register FCM token with backend
  Future<void> _registerToken(String token) async {
    try {
      await _apiService.registerFcmToken({
        'token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'appVersion': '1.0.0', // TODO: Get from package info
      });

      _logger.info('FCM token registered with backend', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to register FCM token with backend', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Set up message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Handle message opened app (from terminated state)
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Handle initial message (app opened from notification)
    _handleInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    try {
      _logger.info('Received foreground message', {
        'messageId': message.messageId,
        'title': message.notification?.title,
        'hasData': message.data.isNotEmpty,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Show local notification
      await _showLocalNotification(message);

      // Track message received
      await _trackMessageInteraction(message, 'received');
    } catch (e) {
      _logger.error('Failed to handle foreground message', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle message that opened the app
  Future<void> _onMessageOpenedApp(RemoteMessage message) async {
    try {
      _logger.info('App opened from notification', {
        'messageId': message.messageId,
        'title': message.notification?.title,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Track message opened
      await _trackMessageInteraction(message, 'opened');

      // Handle notification action
      await _handleNotificationAction(message);
    } catch (e) {
      _logger.error('Failed to handle message opened app', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle initial message when app is opened from notification
  Future<void> _handleInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _logger.info('App opened from initial notification', {
          'messageId': initialMessage.messageId,
          'title': initialMessage.notification?.title,
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Track message opened
        await _trackMessageInteraction(initialMessage, 'opened');

        // Handle notification action
        await _handleNotificationAction(initialMessage);
      }
    } catch (e) {
      _logger.error('Failed to handle initial message', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      final notificationType = _getNotificationTypeFromData(message.data);
      final channelId = _getChannelIdForType(notificationType);

      final androidDetails = local_notifications.AndroidNotificationDetails(
        channelId,
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: local_notifications.Importance.defaultImportance,
        priority: local_notifications.Priority.defaultPriority,
      );

      const iosDetails = local_notifications.DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = local_notifications.NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        message.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      _logger.error('Failed to show local notification', {
        'messageId': message.messageId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle notification tap
  Future<void> _onNotificationTapped(
    local_notifications.NotificationResponse response,
  ) async {
    try {
      _logger.info('Notification tapped', {
        'notificationId': response.id,
        'actionId': response.actionId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (response.payload != null) {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;

        // Track interaction
        if (data['notificationId'] != null) {
          await _apiService
              .trackNotificationInteraction(data['notificationId'] as String, {
                'interactionType': 'OPENED',
                'timestamp': DateTime.now().toIso8601String(),
                'source': 'local_notification',
              });
        }

        // Handle navigation or action
        await _handleNotificationData(data);
      }
    } catch (e) {
      _logger.error('Failed to handle notification tap', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Track message interaction
  Future<void> _trackMessageInteraction(
    RemoteMessage message,
    String interactionType,
  ) async {
    try {
      final notificationId = message.data['notificationId'];
      if (notificationId != null) {
        await _apiService
            .trackNotificationInteraction(notificationId as String, {
              'interactionType': interactionType.toUpperCase(),
              'timestamp': DateTime.now().toIso8601String(),
              'messageId': message.messageId,
              'source': 'fcm',
            });
      }
    } catch (e) {
      _logger.error('Failed to track message interaction', {
        'messageId': message.messageId,
        'interactionType': interactionType,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Handle notification action based on message data
  Future<void> _handleNotificationAction(RemoteMessage message) async {
    await _handleNotificationData(message.data);
  }

  /// Handle notification data for navigation or actions
  Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    try {
      final action = data['action'] as String?;
      final route = data['route'] as String?;

      if (action != null) {
        switch (action) {
          case 'open_medication':
            // Navigate to medication details
            final medicationId = data['medicationId'] as String?;
            if (medicationId != null) {
              // TODO: Navigate to medication details screen
              _logger.info('Opening medication details', {
                'medicationId': medicationId,
              });
            }
            break;
          case 'open_notifications':
            // Navigate to notification center
            // TODO: Navigate to notification center
            _logger.info('Opening notification center');
            break;
          case 'emergency_action':
            // Handle emergency action
            final alertId = data['alertId'] as String?;
            if (alertId != null) {
              // TODO: Handle emergency alert action
              _logger.info('Handling emergency action', {'alertId': alertId});
            }
            break;
        }
      } else if (route != null) {
        // Navigate to specific route
        // TODO: Use GoRouter to navigate
        _logger.info('Navigating to route', {'route': route});
      }
    } catch (e) {
      _logger.error('Failed to handle notification data', {
        'error': e.toString(),
        'data': data,
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
        // Default to system notification if type not found
        return notification_models.NotificationType.systemNotification;
      }
    }
    return notification_models.NotificationType.systemNotification;
  }

  /// Get notification channel ID for type
  String _getChannelIdForType(notification_models.NotificationType type) {
    switch (type) {
      case notification_models.NotificationType.medicationReminder:
        return 'medication_reminders';
      case notification_models.NotificationType.healthAlert:
        return 'health_alerts';
      case notification_models.NotificationType.emergencyAlert:
        return 'emergency_alerts';
      default:
        return 'general_notifications';
    }
  }

  /// Get current FCM token
  Future<String?> getCurrentToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      _logger.error('Failed to get current FCM token', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      return null;
    }
  }

  /// Unregister FCM token
  Future<void> unregisterToken() async {
    try {
      final token = await getCurrentToken();
      if (token != null) {
        await _apiService.unregisterFcmToken({'token': token});
        await _secureStorage.delete(_fcmTokenKey);
        await _secureStorage.delete(_lastTokenUpdateKey);

        _logger.info('FCM token unregistered', {
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      _logger.error('Failed to unregister FCM token', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.info('Subscribed to topic', {
        'topic': topic,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to subscribe to topic', {
        'topic': topic,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.info('Unsubscribed from topic', {
        'topic': topic,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to unsubscribe from topic', {
        'topic': topic,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }
}
