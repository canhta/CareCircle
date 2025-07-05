import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/common.dart';
import '../domain/firebase_messaging_models.dart';
import '../domain/firebase_messaging_repository.dart';

/// Firebase Messaging service implementation
class FirebaseMessagingService implements FirebaseMessagingRepository {
  final FirebaseMessaging _messaging;
  final AppLogger _logger;
  final SecureStorageService _secureStorage;

  // Stream controllers for messaging events
  final StreamController<NotificationMessage> _messageController =
      StreamController<NotificationMessage>.broadcast();
  final StreamController<NotificationMessage> _messageTappedController =
      StreamController<NotificationMessage>.broadcast();
  final StreamController<String> _tokenRefreshController =
      StreamController<String>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Subscriptions
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  // State management
  bool _isInitialized = false;
  String? _currentToken;

  // Event handlers
  Function(NotificationMessage)? _onMessageReceived;
  Function(NotificationMessage)? _onMessageTapped;
  Function(String)? _onTokenRefresh;
  Function(String)? _onError;

  FirebaseMessagingService({
    required AppLogger logger,
    required SecureStorageService secureStorage,
    MessagingConfig? config,
    FirebaseMessaging? messaging,
  })  : _logger = logger,
        _secureStorage = secureStorage,
        _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<Result<void>> initialize() async {
    if (_isInitialized) {
      _logger.info('Firebase Messaging already initialized');
      return Result.success(null);
    }

    try {
      _logger.info('Initializing Firebase Messaging service');

      // Initialize notification channels
      await _initializeNotificationChannels();

      // Request permission
      final permissionResult = await requestPermissions();
      if (permissionResult.isFailure) {
        _logger.warning('Failed to get notification permissions');
      }

      // Set up message handlers
      await _setupMessageHandlers();

      // Get and register token
      final tokenResult = await getToken();
      if (tokenResult.isSuccess && tokenResult.data != null) {
        await _registerToken(tokenResult.data!);
      }

      // Set up token refresh listener
      _onTokenRefreshSubscription = _messaging.onTokenRefresh.listen(
        (String token) async {
          _logger.info('FCM token refreshed');
          _currentToken = token;
          await _registerToken(token);
          _onTokenRefresh?.call(token);
          _tokenRefreshController.add(token);
        },
        onError: (error) {
          _logger.error('Token refresh error', error: error);
          _onError?.call('Token refresh failed: $error');
          _errorController.add('Token refresh failed: $error');
        },
      );

      _isInitialized = true;
      _logger.info('Firebase Messaging initialized successfully');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to initialize Firebase Messaging', error: e);
      return Result.failure(
          Exception('Failed to initialize Firebase Messaging: $e'));
    }
  }

  @override
  Future<Result<String>> getToken() async {
    try {
      if (_currentToken != null) {
        return Result.success(_currentToken!);
      }

      final token = await _messaging.getToken();
      if (token != null) {
        _currentToken = token;
        await _storeTokenLocally(token);
        _logger.info('FCM token retrieved successfully');
        return Result.success(token);
      } else {
        return Result.failure(Exception('Failed to get FCM token'));
      }
    } catch (e) {
      _logger.error('Failed to get FCM token', error: e);
      return Result.failure(Exception('Failed to get FCM token: $e'));
    }
  }

  @override
  Future<Result<bool>> areNotificationsEnabled() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      final isEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;
      return Result.success(isEnabled);
    } catch (e) {
      _logger.error('Failed to check notification settings', error: e);
      return Result.failure(
          Exception('Failed to check notification settings: $e'));
    }
  }

  @override
  Future<Result<NotificationPermissionStatus>> requestPermissions() async {
    try {
      _logger.info('Requesting notification permissions');

      // Request Firebase Messaging permissions
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      // Request system-level permissions
      await Permission.notification.request();

      NotificationPermissionStatus status;
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          status = NotificationPermissionStatus.granted;
          break;
        case AuthorizationStatus.provisional:
          status = NotificationPermissionStatus.provisional;
          break;
        case AuthorizationStatus.denied:
          status = NotificationPermissionStatus.denied;
          break;
        case AuthorizationStatus.notDetermined:
          status = NotificationPermissionStatus.notDetermined;
          break;
      }

      _logger.info('Notification permission status: ${status.name}');
      return Result.success(status);
    } catch (e) {
      _logger.error('Failed to request permissions', error: e);
      return Result.failure(Exception('Failed to request permissions: $e'));
    }
  }

  @override
  Future<Result<void>> subscribeToTopic(String topic) async {
    try {
      _logger.info('Subscribing to topic: $topic');
      await _messaging.subscribeToTopic(topic);
      _logger.info('Successfully subscribed to topic: $topic');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to subscribe to topic: $topic', error: e);
      return Result.failure(Exception('Failed to subscribe to topic: $e'));
    }
  }

  @override
  Future<Result<void>> unsubscribeFromTopic(String topic) async {
    try {
      _logger.info('Unsubscribing from topic: $topic');
      await _messaging.unsubscribeFromTopic(topic);
      _logger.info('Successfully unsubscribed from topic: $topic');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to unsubscribe from topic: $topic', error: e);
      return Result.failure(Exception('Failed to unsubscribe from topic: $e'));
    }
  }

  @override
  Future<Result<void>> sendMessage(NotificationMessage message) async {
    try {
      // In a real implementation, this would send the message to your backend
      // For now, we'll just log it
      _logger.info('Sending message: ${message.toJson()}');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to send message', error: e);
      return Result.failure(Exception('Failed to send message: $e'));
    }
  }

  @override
  Future<Result<List<NotificationMessage>>> getStoredMessages() async {
    try {
      final messagesJson = await _secureStorage.readString('stored_messages');
      if (messagesJson != null) {
        final List<dynamic> messagesList = jsonDecode(messagesJson);
        final messages = messagesList
            .map((json) => NotificationMessage.fromRemoteMessage(
                  RemoteMessage.fromMap(json),
                ))
            .toList();
        return Result.success(messages);
      }
      return Result.success([]);
    } catch (e) {
      _logger.error('Failed to get stored messages', error: e);
      return Result.failure(Exception('Failed to get stored messages: $e'));
    }
  }

  @override
  Future<Result<void>> clearStoredMessages() async {
    try {
      await _secureStorage.delete('stored_messages');
      _logger.info('Stored messages cleared');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to clear stored messages', error: e);
      return Result.failure(Exception('Failed to clear stored messages: $e'));
    }
  }

  @override
  Future<Result<void>> trackMessageInteraction(
      MessageInteraction interaction) async {
    try {
      _logger.info('Tracking message interaction: ${interaction.toJson()}');
      // In a real implementation, this would send the interaction to your analytics service
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to track message interaction', error: e);
      return Result.failure(
          Exception('Failed to track message interaction: $e'));
    }
  }

  @override
  void setOnMessageReceived(Function(NotificationMessage) handler) {
    _onMessageReceived = handler;
  }

  @override
  void setOnMessageTapped(Function(NotificationMessage) handler) {
    _onMessageTapped = handler;
  }

  @override
  void setOnTokenRefresh(Function(String) handler) {
    _onTokenRefresh = handler;
  }

  @override
  void setOnError(Function(String) handler) {
    _onError = handler;
  }

  @override
  Future<Result<MessagingDeviceInfo>> getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return Result.success(MessagingDeviceInfo(
          platform: 'android',
          deviceId: androidInfo.id,
          model: androidInfo.model,
          osVersion: androidInfo.version.release,
          appVersion: '1.0.0', // You would get this from package info
          locale: Platform.localeName,
          timezone: DateTime.now().timeZoneName,
        ));
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return Result.success(MessagingDeviceInfo(
          platform: 'ios',
          deviceId: iosInfo.identifierForVendor,
          model: iosInfo.model,
          osVersion: iosInfo.systemVersion,
          appVersion: '1.0.0', // You would get this from package info
          locale: Platform.localeName,
          timezone: DateTime.now().timeZoneName,
        ));
      }

      return Result.success(MessagingDeviceInfo(
        platform: Platform.operatingSystem,
        locale: Platform.localeName,
        timezone: DateTime.now().timeZoneName,
      ));
    } catch (e) {
      _logger.error('Failed to get device info', error: e);
      return Result.failure(Exception('Failed to get device info: $e'));
    }
  }

  @override
  Future<Result<void>> dispose() async {
    try {
      _logger.info('Disposing Firebase Messaging service');

      await _onMessageSubscription?.cancel();
      await _onMessageOpenedAppSubscription?.cancel();
      await _onTokenRefreshSubscription?.cancel();

      await _messageController.close();
      await _messageTappedController.close();
      await _tokenRefreshController.close();
      await _errorController.close();

      _isInitialized = false;
      _logger.info('Firebase Messaging service disposed');
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to dispose Firebase Messaging service', error: e);
      return Result.failure(
          Exception('Failed to dispose Firebase Messaging service: $e'));
    }
  }

  // Private helper methods
  Future<void> _initializeNotificationChannels() async {
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Basic notification channel',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            criticalAlerts: true,
          ),
          NotificationChannel(
            channelKey: 'medication_channel',
            channelName: 'Medication Reminders',
            channelDescription: 'Medication reminder notifications',
            defaultColor: const Color(0xFF4CAF50),
            ledColor: Colors.green,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            criticalAlerts: true,
          ),
          NotificationChannel(
            channelKey: 'health_channel',
            channelName: 'Health Updates',
            channelDescription: 'Health-related notifications',
            defaultColor: const Color(0xFF2196F3),
            ledColor: Colors.blue,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
          ),
        ],
      );
    } catch (e) {
      _logger.error('Failed to initialize notification channels', error: e);
    }
  }

  Future<void> _setupMessageHandlers() async {
    try {
      // Handle foreground messages
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          _logger.info('Received foreground message: ${message.messageId}');

          final notificationMessage =
              NotificationMessage.fromRemoteMessage(message);
          await _storeMessage(notificationMessage);
          await _showLocalNotification(notificationMessage);

          _onMessageReceived?.call(notificationMessage);
          _messageController.add(notificationMessage);
        },
        onError: (error) {
          _logger.error('Foreground message error', error: error);
          _onError?.call('Foreground message error: $error');
          _errorController.add('Foreground message error: $error');
        },
      );

      // Handle background/terminated app messages
      _onMessageOpenedAppSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) async {
          _logger.info('Message opened app: ${message.messageId}');

          final notificationMessage =
              NotificationMessage.fromRemoteMessage(message);
          await trackMessageInteraction(MessageInteraction(
            messageId: message.messageId ?? '',
            interactionType: 'opened_app',
            timestamp: DateTime.now(),
          ));

          _onMessageTapped?.call(notificationMessage);
          _messageTappedController.add(notificationMessage);
        },
        onError: (error) {
          _logger.error('Message opened app error', error: error);
          _onError?.call('Message opened app error: $error');
          _errorController.add('Message opened app error: $error');
        },
      );

      // Handle initial message (app opened from terminated state)
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _logger.info(
            'App opened from terminated state with message: ${initialMessage.messageId}');

        final notificationMessage =
            NotificationMessage.fromRemoteMessage(initialMessage);
        await trackMessageInteraction(MessageInteraction(
          messageId: initialMessage.messageId ?? '',
          interactionType: 'opened_from_terminated',
          timestamp: DateTime.now(),
        ));

        _onMessageTapped?.call(notificationMessage);
        _messageTappedController.add(notificationMessage);
      }
    } catch (e) {
      _logger.error('Failed to setup message handlers', error: e);
    }
  }

  Future<void> _showLocalNotification(NotificationMessage message) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.messageId.hashCode,
          channelKey: message.channelId ?? 'basic_channel',
          title: message.title,
          body: message.body,
          payload: message.data
              ?.map((key, value) => MapEntry(key, value.toString())),
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          category: NotificationCategory.Message,
          autoDismissible: true,
          showWhen: true,
          criticalAlert: true,
        ),
      );
    } catch (e) {
      _logger.error('Failed to show local notification', error: e);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      _logger.info('Registering FCM token with server');
      // In a real implementation, this would send the token to your backend
      await _storeTokenLocally(token);
      _logger.info('FCM token registered successfully');
    } catch (e) {
      _logger.error('Failed to register FCM token', error: e);
    }
  }

  Future<void> _storeTokenLocally(String token) async {
    try {
      await _secureStorage.writeString('fcm_token', token);
    } catch (e) {
      _logger.error('Failed to store FCM token locally', error: e);
    }
  }

  Future<void> _storeMessage(NotificationMessage message) async {
    try {
      final messagesJson = await _secureStorage.readString('stored_messages');
      List<dynamic> messages = [];

      if (messagesJson != null) {
        messages = jsonDecode(messagesJson);
      }

      messages.add(message.toJson());

      // Keep only the last 100 messages
      if (messages.length > 100) {
        messages = messages.sublist(messages.length - 100);
      }

      await _secureStorage.writeString('stored_messages', jsonEncode(messages));
    } catch (e) {
      _logger.error('Failed to store message', error: e);
    }
  }
}
