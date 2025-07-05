import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../common/common.dart';
import '../features/firebase_messaging/firebase_messaging.dart';

/// Centralized notification management service
/// Handles both local notifications and Firebase messaging
class NotificationManager {
  final AppLogger _logger;
  final FirebaseMessagingService _messagingService;

  bool _isInitialized = false;

  NotificationManager({
    required AppLogger logger,
    required FirebaseMessagingService messagingService,
  })  : _logger = logger,
        _messagingService = messagingService;

  bool get isInitialized => _isInitialized;

  /// Initialize notification manager
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.info('NotificationManager already initialized');
      return;
    }

    try {
      _logger.info('Initializing NotificationManager...');

      // Initialize awesome notifications channels
      await _initializeNotificationChannels();

      // Set up Firebase messaging handlers
      await _setupFirebaseMessageHandlers();

      _isInitialized = true;
      _logger.info('NotificationManager initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize NotificationManager', error: e);
      rethrow;
    }
  }

  /// Initialize notification channels
  Future<void> _initializeNotificationChannels() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'carecircle_group',
          channelKey: 'carecircle_channel',
          channelName: 'CareCircle Notifications',
          channelDescription: 'Notifications for CareCircle app',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'carecircle_group',
          channelKey: 'medication_channel',
          channelName: 'Medication Reminders',
          channelDescription: 'Reminders for taking medications',
          defaultColor: const Color(0xFF2196F3),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'carecircle_group',
          channelKey: 'emergency_channel',
          channelName: 'Emergency Alerts',
          channelDescription: 'Critical emergency notifications',
          defaultColor: const Color(0xFFFF5722),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'carecircle_group',
          channelGroupName: 'CareCircle',
        ),
      ],
    );
  }

  /// Set up Firebase message handlers
  Future<void> _setupFirebaseMessageHandlers() async {
    // Note: Background message handler is set in main.dart
    // FirebaseMessaging.onBackgroundMessage() should only be called once

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
  }

  /// Handle background Firebase messages
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    _logger.info('Handling background message: ${message.messageId}');

    // Show notification
    await _showNotification(message);

    // Handle different message types
    await _processMessageData(message);
  }

  /// Handle foreground Firebase messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.info('Handling foreground message: ${message.messageId}');

    // Show notification
    await _showNotification(message);

    // Handle different message types
    await _processMessageData(message);
  }

  /// Handle message tap (when user taps notification)
  Future<void> _handleMessageTap(RemoteMessage message) async {
    _logger.info('Message tapped: ${message.messageId}');

    // Handle navigation based on message type
    await _handleMessageNavigation(message);
  }

  /// Show notification using awesome notifications
  Future<void> _showNotification(RemoteMessage message) async {
    final messageType = message.data['type'] ?? 'default';
    String channelKey = _getChannelKeyForMessageType(messageType);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: channelKey,
        title: message.notification?.title ?? 'CareCircle',
        body: message.notification?.body ?? 'New notification',
        payload:
            message.data.map((key, value) => MapEntry(key, value.toString())),
        notificationLayout: NotificationLayout.Default,
        actionType: ActionType.Default,
      ),
    );
  }

  /// Process message data based on type
  Future<void> _processMessageData(RemoteMessage message) async {
    final messageType = message.data['type'];

    switch (messageType) {
      case 'medication_reminder':
        await _processMedicationReminder(message);
        break;
      case 'emergency_alert':
        await _processEmergencyAlert(message);
        break;
      case 'check_in_reminder':
        await _processCheckInReminder(message);
        break;
      case 'care_group_update':
        await _processCareGroupUpdate(message);
        break;
      default:
        _logger.warning('Unknown message type: $messageType');
    }
  }

  /// Handle navigation based on message type
  Future<void> _handleMessageNavigation(RemoteMessage message) async {
    final messageType = message.data['type'];

    // This would typically use a navigation service
    // For now, we'll just log the intended navigation
    switch (messageType) {
      case 'medication_reminder':
        _logger.info('Should navigate to medications screen');
        break;
      case 'emergency_alert':
        _logger.info('Should navigate to emergency screen');
        break;
      case 'check_in_reminder':
        _logger.info('Should navigate to health check screen');
        break;
      case 'care_group_update':
        _logger.info('Should navigate to care group screen');
        break;
      default:
        _logger.warning('No navigation handler for message type: $messageType');
    }
  }

  /// Get appropriate channel key for message type
  String _getChannelKeyForMessageType(String messageType) {
    switch (messageType) {
      case 'medication_reminder':
        return 'medication_channel';
      case 'emergency_alert':
        return 'emergency_channel';
      default:
        return 'carecircle_channel';
    }
  }

  /// Process medication reminder
  Future<void> _processMedicationReminder(RemoteMessage message) async {
    final medicationId = message.data['medication_id'];
    _logger.info('Processing medication reminder for: $medicationId');

    // TODO: Implement medication reminder logic
    // - Update medication status
    // - Schedule snooze if needed
    // - Track analytics
  }

  /// Process emergency alert
  Future<void> _processEmergencyAlert(RemoteMessage message) async {
    final alertType = message.data['alert_type'];
    _logger.info('Processing emergency alert: $alertType');

    // TODO: Implement emergency alert logic
    // - Show critical alert
    // - Notify emergency contacts
    // - Track analytics
  }

  /// Process check-in reminder
  Future<void> _processCheckInReminder(RemoteMessage message) async {
    final checkInType = message.data['check_in_type'];
    _logger.info('Processing check-in reminder: $checkInType');

    // TODO: Implement check-in reminder logic
    // - Update reminder status
    // - Track analytics
  }

  /// Process care group update
  Future<void> _processCareGroupUpdate(RemoteMessage message) async {
    final groupId = message.data['group_id'];
    _logger.info('Processing care group update for: $groupId');

    // TODO: Implement care group update logic
    // - Update group data
    // - Notify group members
    // - Track analytics
  }
}
