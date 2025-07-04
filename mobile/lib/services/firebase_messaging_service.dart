import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../config/firebase_initializer.dart';
import '../services/auth_service.dart';
import '../utils/notification_channels.dart';

/// Firebase Messaging Service with improved error handling,
/// retry mechanisms, and better notification management
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  FirebaseMessaging? _messaging;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  // Enhanced handlers
  Function(RemoteMessage)? _onForegroundMessage;
  Function(RemoteMessage)? _onMessageTap;
  Function(String)? _onTokenRefresh;
  Function(String)? _onError;

  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  // Token management
  String? _currentToken;
  bool _isInitialized = false;

  /// Initialize Firebase Messaging with enhanced error handling
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('Firebase Messaging already initialized');
      return;
    }

    try {
      _messaging = FirebaseMessaging.instance;
      await _initializeNotificationChannels();
      await _requestPermissions();
      await _setupMessageHandlers();
      await _registerToken();

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      _isInitialized = true;
      debugPrint('Enhanced Firebase Messaging initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Enhanced Firebase Messaging: $e');
      _onError?.call('Failed to initialize Firebase Messaging: $e');
      rethrow;
    }
  }

  /// Initialize notification channels with proper categorization
  Future<void> _initializeNotificationChannels() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      NotificationChannels.getAllChannels(),
    );

    // Set up notification action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onNotificationAction,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onDismissActionReceived,
    );
  }

  /// Enhanced permission request with detailed feedback
  Future<PermissionStatus> _requestPermissions() async {
    try {
      // Request Firebase messaging permissions
      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      debugPrint('Firebase permission status: ${settings.authorizationStatus}');

      // Request system notification permissions
      PermissionStatus systemPermission = PermissionStatus.granted;
      if (Platform.isAndroid) {
        systemPermission = await Permission.notification.request();
      }

      // For iOS, also request APNS token
      if (Platform.isIOS) {
        final apnsToken = await _messaging!.getAPNSToken();
        if (apnsToken != null) {
          debugPrint('APNS token available: ${apnsToken.substring(0, 10)}...');
        } else {
          debugPrint('APNS token not available');
        }
      }

      return systemPermission;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      _onError?.call('Failed to request notification permissions: $e');
      return PermissionStatus.denied;
    }
  }

  /// Setup enhanced message handlers with retry logic
  Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) async {
      debugPrint('Foreground message received: ${message.messageId}');
      debugPrint('Message data: ${message.data}');

      try {
        if (message.notification != null) {
          await _showEnhancedLocalNotification(message);
        }

        // Store message for analytics
        await _storeMessage(message, 'foreground');

        // Call custom handler
        _onForegroundMessage?.call(message);
      } catch (e) {
        debugPrint('Error handling foreground message: $e');
        _onError?.call('Failed to handle foreground message: $e');
      }
    });

    // Handle notification taps when app is in background
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened app: ${message.messageId}');

      try {
        // Store interaction for analytics
        _storeMessageInteraction(message, 'opened_from_background');

        // Call custom handler
        _onMessageTap?.call(message);
      } catch (e) {
        debugPrint('Error handling message tap: $e');
        _onError?.call('Failed to handle message tap: $e');
      }
    });

    // Handle token refresh with retry logic
    _onTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      debugPrint('FCM token refreshed: ${token.substring(0, 20)}...');
      _currentToken = token;

      try {
        await _registerTokenWithRetry(token);
        _onTokenRefresh?.call(token);
      } catch (e) {
        debugPrint('Error handling token refresh: $e');
        _onError?.call('Failed to handle token refresh: $e');
      }
    });

    // Check for initial message (app opened from terminated state)
    try {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('App opened from terminated state via notification');
        await _storeMessageInteraction(
            initialMessage, 'opened_from_terminated');
        _onMessageTap?.call(initialMessage);
      }
    } catch (e) {
      debugPrint('Error checking initial message: $e');
    }
  }

  /// Enhanced local notification with better categorization
  Future<void> _showEnhancedLocalNotification(RemoteMessage message) async {
    try {
      final messageType = message.data['type'] ?? 'general';
      final channelKey = NotificationChannels.getChannelForType(messageType);

      final notificationContent = NotificationContent(
        id: message.hashCode,
        channelKey: channelKey,
        title: message.notification?.title ?? 'CareCircle',
        body: message.notification?.body ?? 'You have a new notification',
        payload:
            message.data.map((key, value) => MapEntry(key, value.toString())),
        notificationLayout: _getNotificationLayout(messageType),
        category: _getNotificationCategory(messageType),
        wakeUpScreen: _shouldWakeUpScreen(messageType),
        locked: _shouldShowOnLockScreen(messageType),
      );

      // Add action buttons for interactive notifications
      final actionButtons = _buildActionButtons(messageType, message.data);

      await AwesomeNotifications().createNotification(
        content: notificationContent,
        actionButtons: actionButtons,
      );
    } catch (e) {
      debugPrint('Error showing enhanced local notification: $e');
      _onError?.call('Failed to show notification: $e');
    }
  }

  /// Get FCM token with retry logic
  Future<String?> getToken() async {
    if (_currentToken != null) {
      return _currentToken;
    }

    try {
      final token = await _messaging!.getToken();
      if (token != null) {
        _currentToken = token;
        debugPrint('FCM token retrieved: ${token.substring(0, 20)}...');
        await _registerTokenWithRetry(token);
      }
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      _onError?.call('Failed to get FCM token: $e');
      return null;
    }
  }

  /// Register token with backend using retry logic
  Future<void> _registerTokenWithRetry(String token) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        await _registerToken(token);
        debugPrint('Token registered successfully on attempt $attempt');
        return;
      } catch (e) {
        debugPrint('Token registration attempt $attempt failed: $e');

        if (attempt == _maxRetries) {
          _onError?.call(
              'Failed to register token after $_maxRetries attempts: $e');
          rethrow;
        }

        await Future.delayed(_retryDelay * attempt);
      }
    }
  }

  /// Register token with backend
  Future<void> _registerToken([String? token]) async {
    try {
      final authService = AuthService();
      final authToken = await authService.getAccessToken();

      if (authToken == null) {
        throw Exception('No authentication token available');
      }

      final fcmToken = token ?? await getToken();
      if (fcmToken == null) {
        throw Exception('No FCM token available');
      }

      final dio = Dio();
      final response = await dio.post(
        '${AppConfig.apiBaseUrl}/firebase/tokens/register',
        data: {
          'token': fcmToken,
          'deviceType': Platform.isIOS ? 'ios' : 'android',
          'deviceInfo': await _getDeviceInfo(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 201) {
        debugPrint('Token registered with backend successfully');
        await _storeTokenLocally(fcmToken);
      } else {
        throw Exception('Backend returned status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error registering token with backend: $e');
      rethrow;
    }
  }

  /// Get enhanced device information
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    // This would typically use device_info_plus package
    return {
      'platform': Platform.operatingSystem,
      'osVersion': Platform.operatingSystemVersion,
      'appVersion': '1.0.0', // Get from package_info_plus
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Store token locally for offline access
  Future<void> _storeTokenLocally(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      await prefs.setString(
          'fcm_token_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error storing token locally: $e');
    }
  }

  /// Subscribe to topic with error handling
  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _messaging!.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');

      // Store subscription locally
      final prefs = await SharedPreferences.getInstance();
      final subscriptions = prefs.getStringList('subscribed_topics') ?? [];
      if (!subscriptions.contains(topic)) {
        subscriptions.add(topic);
        await prefs.setStringList('subscribed_topics', subscriptions);
      }

      return true;
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
      _onError?.call('Failed to subscribe to topic $topic: $e');
      return false;
    }
  }

  /// Unsubscribe from topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging!.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');

      // Remove from local storage
      final prefs = await SharedPreferences.getInstance();
      final subscriptions = prefs.getStringList('subscribed_topics') ?? [];
      subscriptions.remove(topic);
      await prefs.setStringList('subscribed_topics', subscriptions);

      return true;
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
      _onError?.call('Failed to unsubscribe from topic $topic: $e');
      return false;
    }
  }

  /// Store message for analytics and offline access
  Future<void> _storeMessage(RemoteMessage message, String context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = prefs.getStringList('received_messages') ?? [];

      final messageData = {
        'messageId': message.messageId,
        'data': message.data,
        'notification': message.notification != null
            ? {
                'title': message.notification!.title,
                'body': message.notification!.body,
              }
            : null,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      };

      messages.add(jsonEncode(messageData));

      // Keep only last 50 messages
      if (messages.length > 50) {
        messages.removeRange(0, messages.length - 50);
      }

      await prefs.setStringList('received_messages', messages);
    } catch (e) {
      debugPrint('Error storing message: $e');
    }
  }

  /// Store message interaction for analytics
  Future<void> _storeMessageInteraction(
      RemoteMessage message, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final interactions = prefs.getStringList('message_interactions') ?? [];

      final interactionData = {
        'messageId': message.messageId,
        'action': action,
        'data': message.data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      interactions.add(jsonEncode(interactionData));

      // Keep only last 100 interactions
      if (interactions.length > 100) {
        interactions.removeRange(0, interactions.length - 100);
      }

      await prefs.setStringList('message_interactions', interactions);
    } catch (e) {
      debugPrint('Error storing message interaction: $e');
    }
  }

  // Notification event handlers
  static Future<void> _onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    debugPrint('Enhanced notification created: ${receivedNotification.id}');
  }

  static Future<void> _onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    debugPrint('Enhanced notification displayed: ${receivedNotification.id}');
  }

  static Future<void> _onDismissActionReceived(
      ReceivedAction receivedAction) async {
    debugPrint('Enhanced notification dismissed: ${receivedAction.id}');
  }

  static Future<void> _onNotificationAction(
      ReceivedAction receivedAction) async {
    debugPrint(
        'Enhanced notification action: ${receivedAction.buttonKeyPressed}');
    // Handle different notification actions
    await _handleNotificationAction(receivedAction);
  }

  /// Handle notification actions
  static Future<void> _handleNotificationAction(ReceivedAction action) async {
    final actionKey = action.buttonKeyPressed;
    final payload = action.payload;

    switch (actionKey) {
      case 'MARK_TAKEN':
        await _handleMedicationTaken(payload);
        break;
      case 'SNOOZE':
        await _handleSnooze(payload);
        break;
      case 'VIEW_DETAILS':
        await _handleViewDetails(payload);
        break;
      default:
        debugPrint('Unknown notification action: $actionKey');
    }
  }

  /// Utility methods for notification configuration
  NotificationLayout _getNotificationLayout(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
      case 'health_check':
        return NotificationLayout.BigText;
      case 'care_group_update':
        return NotificationLayout.Inbox;
      default:
        return NotificationLayout.Default;
    }
  }

  NotificationCategory _getNotificationCategory(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
        return NotificationCategory.Reminder;
      case 'health_check':
        return NotificationCategory.Alarm;
      case 'care_group_update':
        return NotificationCategory.Social;
      case 'system_alert':
        return NotificationCategory.Status;
      default:
        return NotificationCategory.Message;
    }
  }

  bool _shouldWakeUpScreen(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
      case 'emergency_alert':
        return true;
      default:
        return false;
    }
  }

  bool _shouldShowOnLockScreen(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
      case 'health_check':
      case 'emergency_alert':
        return false; // Don't show sensitive info on lock screen
      default:
        return true;
    }
  }

  List<NotificationActionButton>? _buildActionButtons(
      String messageType, Map<String, dynamic> data) {
    switch (messageType) {
      case 'medication_reminder':
        return [
          NotificationActionButton(
            key: 'MARK_TAKEN',
            label: 'Mark as Taken',
            actionType: ActionType.SilentAction,
            icon: 'resource://drawable/ic_check',
          ),
          NotificationActionButton(
            key: 'SNOOZE',
            label: 'Snooze 15min',
            actionType: ActionType.SilentAction,
            icon: 'resource://drawable/ic_snooze',
          ),
        ];
      case 'health_check':
        return [
          NotificationActionButton(
            key: 'START_CHECK',
            label: 'Start Check',
            actionType: ActionType.Default,
            icon: 'resource://drawable/ic_health',
          ),
        ];
      default:
        return null;
    }
  }

  // Action handlers
  static Future<void> _handleMedicationTaken(
      Map<String, String?>? payload) async {
    // TODO: Implement medication taken logic
    debugPrint('Medication marked as taken: $payload');
  }

  static Future<void> _handleSnooze(Map<String, String?>? payload) async {
    // TODO: Implement snooze logic
    debugPrint('Medication reminder snoozed: $payload');
  }

  static Future<void> _handleViewDetails(Map<String, String?>? payload) async {
    // TODO: Implement view details logic
    debugPrint('View details requested: $payload');
  }

  /// Set custom handlers
  void setForegroundMessageHandler(Function(RemoteMessage) handler) {
    _onForegroundMessage = handler;
  }

  void setMessageTapHandler(Function(RemoteMessage) handler) {
    _onMessageTap = handler;
  }

  void setTokenRefreshHandler(Function(String) handler) {
    _onTokenRefresh = handler;
  }

  void setErrorHandler(Function(String) handler) {
    _onError = handler;
  }

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'hasToken': _currentToken != null,
      'tokenLength': _currentToken?.length ?? 0,
    };
  }

  /// Get stored background messages for debugging
  Future<List<Map<String, dynamic>>> getBackgroundMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = prefs.getStringList('background_messages') ?? [];

      return messages.map((message) {
        try {
          return jsonDecode(message) as Map<String, dynamic>;
        } catch (e) {
          debugPrint('Error parsing background message: $e');
          return <String, dynamic>{};
        }
      }).toList();
    } catch (e) {
      debugPrint('Error getting background messages: $e');
      return [];
    }
  }

  /// Clear stored background messages
  Future<void> clearBackgroundMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('background_messages');
      debugPrint('Background messages cleared');
    } catch (e) {
      debugPrint('Error clearing background messages: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
    _isInitialized = false;
  }
}

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseInitializer.ensureInitialized();

  debugPrint('Enhanced background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');

  // Store the message for later processing
  await _storeBackgroundMessage(message);
}

/// Store background message for later processing
Future<void> _storeBackgroundMessage(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final messages = prefs.getStringList('background_messages') ?? [];

    final messageData = {
      'messageId': message.messageId,
      'data': message.data,
      'notification': message.notification != null
          ? {
              'title': message.notification!.title,
              'body': message.notification!.body,
            }
          : null,
      'timestamp': DateTime.now().toIso8601String(),
    };

    messages.add(jsonEncode(messageData));

    // Keep only last 20 background messages
    if (messages.length > 20) {
      messages.removeAt(0);
    }

    await prefs.setStringList('background_messages', messages);
  } catch (e) {
    debugPrint('Error storing background message: $e');
  }
}
