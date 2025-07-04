import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// Top-level function to handle background messages
/// This function MUST be top-level (not inside a class) and annotated with @pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp();

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
  FlutterLocalNotificationsPlugin? _localNotifications;
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
    _localNotifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // Remove the deprecated onDidReceiveLocalNotification parameter
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Local notification tapped: ${response.payload}');
        await _handleNotificationTap(response.payload);
      },
    );
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
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'care_circle_channel',
        'CareCircle Notifications',
        channelDescription: 'Notifications for CareCircle app',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iOSNotificationDetails,
      );

      await _localNotifications!.show(
        message.hashCode,
        message.notification?.title ?? 'CareCircle',
        message.notification?.body ?? 'You have a new notification',
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Handle notification tap
  Future<void> _handleNotificationTap(String? payload) async {
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        final message = RemoteMessage(
          messageId: data['messageId'],
          data: Map<String, String>.from(data['data'] ?? {}),
        );
        _onMessageTap?.call(message);
      } catch (e) {
        debugPrint('Error handling notification tap: $e');
      }
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
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/api/notifications/register-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: jsonEncode({
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'timestamp': DateTime.now().toIso8601String(),
        }),
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
