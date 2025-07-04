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

/// Top-level function to handle background messages
/// This function MUST be top-level (not inside a class) and annotated with @pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized using centralized initializer
  await FirebaseInitializer.ensureInitialized();

  debugPrint('Handling a background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');

  if (message.notification != null) {
    debugPrint(
      'Message also contained a notification: ${message.notification}',
    );
  }

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

    // Keep only last 10 messages
    if (messages.length > 10) {
      messages.removeAt(0);
    }

    await prefs.setStringList('background_messages', messages);
  } catch (e) {
    debugPrint('Error storing background message: $e');
  }
}

/// Firebase Messaging Service
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  FirebaseMessaging? _messaging;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  // Notification handlers
  Function(RemoteMessage)? _onForegroundMessage;
  Function(RemoteMessage)? _onMessageTap;
  Function(String)? _onTokenRefresh;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    try {
      _messaging = FirebaseMessaging.instance;
      await _initializeLocalNotifications();
      await _requestPermissions();
      await _setupMessageHandlers();

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      debugPrint('Firebase Messaging initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase Messaging: $e');
      rethrow;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    // Initialize AwesomeNotifications
    await AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled notifications',
          channelDescription:
              'Notification channel for scheduled notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    // Set up notification action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onNotificationTap,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onDismissActionReceived,
    );
  }

  // Notification event handlers
  static Future<void> _onNotificationCreated(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  static Future<void> _onNotificationDisplayed(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
  }

  static Future<void> _onDismissActionReceived(
      ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed: ${receivedAction.id}');
  }

  static Future<void> _onNotificationTap(ReceivedAction receivedAction) async {
    debugPrint('Notification tapped: ${receivedAction.payload}');
    // Handle notification tap
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
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

      debugPrint('User granted permission: ${settings.authorizationStatus}');

      // Request system notification permissions
      if (Platform.isAndroid) {
        await Permission.notification.request();
      }

      // For iOS, also request APNS token
      if (Platform.isIOS) {
        final apnsToken = await _messaging!.getAPNSToken();
        if (apnsToken != null) {
          debugPrint('APNS token available: ${apnsToken.substring(0, 10)}...');
        }
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  /// Setup message handlers
  Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );
        // Show local notification for foreground messages
        _showLocalNotification(message);
      }

      // Call custom handler if set
      _onForegroundMessage?.call(message);
    });

    // Handle notification taps when app is in background
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint('Message data: ${message.data}');

      // Call custom handler if set
      _onMessageTap?.call(message);
    });

    // Handle token refresh
    _onTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      debugPrint('FCM token refreshed: ${token.substring(0, 20)}...');
      _onTokenRefresh?.call(token);
      _sendTokenToServer(token);
    });

    // Check for initial message (app opened from terminated state)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state via notification');
      _onMessageTap?.call(initialMessage);
    }
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode,
          channelKey: 'basic_channel',
          title: message.notification?.title ?? 'CareCircle',
          body: message.notification?.body ?? 'You have a new notification',
          payload:
              message.data.map((key, value) => MapEntry(key, value.toString())),
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Get FCM token
  Future<String?> getToken() async {
    try {
      final token = await _messaging!.getToken();
      debugPrint('FCM token: ${token?.substring(0, 20)}...');
      if (token != null) {
        await _sendTokenToServer(token);
      }
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Send token to server
  Future<void> _sendTokenToServer(String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '${AppConfig.apiBaseUrl}/api/notifications/register-token',
        data: {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'timestamp': DateTime.now().toIso8601String(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await _getAuthToken()}',
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Token sent to server successfully');
      } else {
        debugPrint('Failed to send token to server: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending token to server: $e');
    }
  }

  /// Get authentication token
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      debugPrint('Error getting auth token: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging!.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging!.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Set custom message handlers
  void setForegroundMessageHandler(Function(RemoteMessage) handler) {
    _onForegroundMessage = handler;
  }

  void setMessageTapHandler(Function(RemoteMessage) handler) {
    _onMessageTap = handler;
  }

  void setTokenRefreshHandler(Function(String) handler) {
    _onTokenRefresh = handler;
  }

  /// Get stored background messages
  Future<List<Map<String, dynamic>>> getBackgroundMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = prefs.getStringList('background_messages') ?? [];
      return messages
          .map((msg) => jsonDecode(msg) as Map<String, dynamic>)
          .toList();
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
    } catch (e) {
      debugPrint('Error clearing background messages: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    _onTokenRefreshSubscription?.cancel();
  }
}
