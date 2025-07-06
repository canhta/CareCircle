import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../common/common.dart';
import '../config/service_locator.dart';
import '../features/firebase_messaging/firebase_messaging.dart';
import '../features/medication/data/medication_service.dart';
import '../utils/analytics_service.dart';

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

      // Process any offline actions
      await processOfflineActions();

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
        NotificationChannel(
          channelGroupKey: 'carecircle_group',
          channelKey: 'health_check_channel',
          channelName: 'Health Check Reminders',
          channelDescription: 'Reminders for daily health check-ins',
          defaultColor: const Color(0xFF4CAF50),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelGroupKey: 'carecircle_group',
          channelKey: 'care_group_channel',
          channelName: 'Care Group Updates',
          channelDescription: 'Updates from care groups',
          defaultColor: const Color(0xFF673AB7),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
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
      case 'check_in_reminder':
        return 'health_check_channel';
      case 'care_group_update':
        return 'care_group_channel';
      default:
        return 'carecircle_channel';
    }
  }

  /// Process medication reminder
  Future<void> _processMedicationReminder(RemoteMessage message) async {
    final medicationId = message.data['medication_id'];
    final medicationName = message.data['medication_name'];
    final dosage = message.data['dosage'];

    _logger.info('Processing medication reminder for: $medicationId');

    try {
      // Create actions for the notification
      final actionButtons = <NotificationActionButton>[
        NotificationActionButton(
          key: 'TAKE_MEDICATION',
          label: 'Take',
          color: Colors.green,
        ),
        NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
        ),
        NotificationActionButton(
          key: 'SKIP',
          label: 'Skip',
          color: Colors.red,
        ),
      ];

      // Show actionable notification for medication
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: medicationId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
          channelKey: 'medication_channel',
          title: 'Medication Reminder',
          body: medicationName != null
              ? dosage != null
                  ? 'Time to take $medicationName ($dosage)'
                  : 'Time to take $medicationName'
              : 'Your medication is due',
          payload: {
            'type': 'medication_reminder',
            'medication_id': medicationId ?? '',
          },
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
        ),
        actionButtons: actionButtons,
      );

      _logger.info('Medication reminder notification created');
    } catch (e) {
      _logger.error('Error processing medication reminder', error: e);
    }
  }

  /// Process emergency alert
  Future<void> _processEmergencyAlert(RemoteMessage message) async {
    final alertType = message.data['alert_type'];
    final patientId = message.data['patient_id'];
    final patientName = message.data['patient_name'];
    final emergencyDetails = message.data['details'];

    _logger.info('Processing emergency alert: $alertType');

    try {
      // Create emergency notification with high priority
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch,
          channelKey: 'emergency_channel',
          title: 'EMERGENCY ALERT',
          body: patientName != null
              ? '$patientName needs immediate attention!'
              : 'Emergency situation detected!',
          payload: {
            'type': 'emergency_alert',
            'alert_type': alertType ?? 'unknown',
            'patient_id': patientId ?? '',
            'details': emergencyDetails ?? '',
          },
          notificationLayout: NotificationLayout.BigText,
          category: NotificationCategory.Alarm,
          wakeUpScreen: true,
          fullScreenIntent: true,
          criticalAlert: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'CALL_EMERGENCY',
            label: 'Call 911',
            color: Colors.red,
            isDangerousOption: true,
          ),
          NotificationActionButton(
            key: 'NOTIFY_CONTACTS',
            label: 'Notify Contacts',
            color: Colors.orange,
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
          ),
        ],
      );

      _logger.info('Emergency alert notification created');
    } catch (e) {
      _logger.error('Error processing emergency alert', error: e);
    }
  }

  /// Process check-in reminder
  Future<void> _processCheckInReminder(RemoteMessage message) async {
    final checkInType = message.data['check_in_type'] ?? 'daily';
    final patientId = message.data['patient_id'];

    _logger.info('Processing check-in reminder: $checkInType');

    try {
      // Determine notification content based on check-in type
      String title;
      String body;

      switch (checkInType) {
        case 'daily':
          title = 'Daily Health Check-in';
          body = 'Time for your daily health check-in';
          break;
        case 'symptoms':
          title = 'Symptom Check';
          body = 'Please log any symptoms you\'re experiencing';
          break;
        case 'vitals':
          title = 'Vital Signs Check';
          body = 'Time to record your vital signs';
          break;
        default:
          title = 'Health Check-in';
          body = 'Time for your scheduled health check-in';
      }

      // Create notification for check-in reminder
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: checkInType.hashCode +
              DateTime.now().millisecondsSinceEpoch % 1000,
          channelKey: 'health_check_channel',
          title: title,
          body: body,
          payload: {
            'type': 'check_in_reminder',
            'check_in_type': checkInType,
            'patient_id': patientId ?? '',
          },
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'COMPLETE_CHECKIN',
            label: 'Complete Now',
            color: Colors.blue,
          ),
          NotificationActionButton(
            key: 'REMIND_LATER',
            label: 'Later',
          ),
        ],
      );

      _logger.info('Check-in reminder notification created');
    } catch (e) {
      _logger.error('Error processing check-in reminder', error: e);
    }
  }

  /// Process care group update
  Future<void> _processCareGroupUpdate(RemoteMessage message) async {
    final groupId = message.data['group_id'];
    final updateType = message.data['update_type'] ?? 'general';
    final senderId = message.data['sender_id'];
    final senderName = message.data['sender_name'];
    final updateContent = message.data['content'];

    _logger.info('Processing care group update for: $groupId');

    try {
      // Determine notification content based on update type
      String title;
      String body;

      switch (updateType) {
        case 'message':
          title = senderName != null
              ? 'Message from $senderName'
              : 'New Message in Care Group';
          body = updateContent ?? 'You have a new message in your care group';
          break;
        case 'status_change':
          title = 'Status Change Alert';
          body = updateContent ??
              'There\'s been a status change in your care group';
          break;
        case 'emergency':
          title = 'EMERGENCY: Care Group Alert';
          body = updateContent ?? 'Emergency situation in your care group!';
          break;
        default:
          title = 'Care Group Update';
          body = updateContent ?? 'You have an update in your care group';
      }

      // Create notification for care group update
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: groupId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
          channelKey: 'care_group_channel',
          title: title,
          body: body,
          payload: {
            'type': 'care_group_update',
            'group_id': groupId ?? '',
            'update_type': updateType,
            'sender_id': senderId ?? '',
          },
          notificationLayout: updateType == 'emergency'
              ? NotificationLayout.BigText
              : NotificationLayout.Default,
          category: updateType == 'emergency'
              ? NotificationCategory.Alarm
              : NotificationCategory.Social,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'VIEW_UPDATE',
            label: 'View',
            color: Colors.blue,
          ),
          NotificationActionButton(
            key: 'REPLY',
            label: 'Reply',
          ),
        ],
      );

      _logger.info('Care group update notification created');
    } catch (e) {
      _logger.error('Error processing care group update', error: e);
    }
  }

  /// Get stored messages from local storage
  Future<Result<List<NotificationMessage>>> getStoredMessages() async {
    try {
      _logger.info('Getting stored messages');
      return await _messagingService.getStoredMessages();
    } catch (e) {
      _logger.error('Failed to get stored messages', error: e);
      return Result.failure(Exception('Failed to get stored messages: $e'));
    }
  }

  /// Clear stored messages from local storage
  Future<Result<void>> clearStoredMessages() async {
    try {
      _logger.info('Clearing stored messages');
      return await _messagingService.clearStoredMessages();
    } catch (e) {
      _logger.error('Failed to clear stored messages', error: e);
      return Result.failure(Exception('Failed to clear stored messages: $e'));
    }
  }

  /// Process a notification message
  Future<void> processMessage(NotificationMessage message) async {
    try {
      _logger.info('Processing message: ${message.messageId}');

      // Show notification if title or body exists
      if (message.title != null || message.body != null) {
        await _showNotificationFromMessage(message);
      }

      // Handle different message types based on data
      if (message.data != null && message.data!.isNotEmpty) {
        await _processMessageDataFromNotificationMessage(message);
      }

      _logger.info('Message processed successfully');
    } catch (e) {
      _logger.error('Error processing message', error: e);
    }
  }

  /// Show notification from NotificationMessage
  Future<void> _showNotificationFromMessage(NotificationMessage message) async {
    final messageType = message.data?['type'] ?? 'default';
    String channelKey = _getChannelKeyForMessageType(messageType);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: channelKey,
        title: message.title ?? 'CareCircle',
        body: message.body ?? 'New notification',
        payload: message.data
                ?.map((key, value) => MapEntry(key, value.toString())) ??
            {},
        notificationLayout: NotificationLayout.Default,
        actionType: ActionType.Default,
      ),
    );
  }

  /// Process message data based on type from NotificationMessage
  Future<void> _processMessageDataFromNotificationMessage(
      NotificationMessage message) async {
    final messageType = message.data?['type'];

    // Convert NotificationMessage to RemoteMessage for compatibility with existing handlers
    final remoteMessage = RemoteMessage(
      messageId: message.messageId,
      data: message.data ?? {},
      notification: (message.title != null || message.body != null)
          ? RemoteNotification(
              title: message.title,
              body: message.body,
            )
          : null,
      sentTime: message.sentTime,
    );

    switch (messageType) {
      case 'medication_reminder':
        await _processMedicationReminder(remoteMessage);
        break;
      case 'emergency_alert':
        await _processEmergencyAlert(remoteMessage);
        break;
      case 'check_in_reminder':
        await _processCheckInReminder(remoteMessage);
        break;
      case 'care_group_update':
        await _processCareGroupUpdate(remoteMessage);
        break;
      default:
        _logger.warning('Unknown message type: $messageType');
    }
  }

  /// Schedule a medication reminder notification
  Future<void> scheduleMedicationReminder({
    required String medicationId,
    required DateTime scheduledTime,
    bool isSnoozed = false,
    String? medicationName,
    String? dosage,
  }) async {
    try {
      final id =
          medicationId.hashCode + scheduledTime.millisecondsSinceEpoch % 100000;
      final title = isSnoozed
          ? 'Medication Reminder (Snoozed)'
          : 'Time to take your medication';

      final body = medicationName != null
          ? dosage != null
              ? 'Time to take $medicationName ($dosage)'
              : 'Time to take $medicationName'
          : 'Your scheduled medication is due';

      _logger.info(
          'Scheduling medication reminder for $medicationId at ${scheduledTime.toIso8601String()}');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'medication_channel',
          title: title,
          body: body,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          payload: {
            'type': 'medication_reminder',
            'medication_id': medicationId,
            'is_snoozed': isSnoozed.toString(),
          },
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledTime),
        actionButtons: [
          NotificationActionButton(
            key: 'TAKE_MEDICATION',
            label: 'Take',
            color: Colors.green,
          ),
          NotificationActionButton(
            key: 'SNOOZE',
            label: 'Snooze',
          ),
          NotificationActionButton(
            key: 'SKIP',
            label: 'Skip',
            color: Colors.red,
          ),
        ],
      );

      _logger.info('Medication reminder scheduled successfully');
    } catch (e) {
      _logger.error('Failed to schedule medication reminder', error: e);
    }
  }

  /// Schedule a check-in reminder notification
  Future<void> scheduleCheckInReminder({
    required String checkInType,
    required DateTime scheduledTime,
  }) async {
    try {
      final id =
          checkInType.hashCode + scheduledTime.millisecondsSinceEpoch % 100000;

      String title;
      String body;

      switch (checkInType) {
        case 'daily':
          title = 'Daily Health Check-in';
          body = 'Time for your daily health check-in';
          break;
        case 'symptoms':
          title = 'Symptom Check';
          body = 'Please log any symptoms you\'re experiencing';
          break;
        case 'vitals':
          title = 'Vital Signs Check';
          body = 'Time to record your vital signs';
          break;
        default:
          title = 'Health Check-in';
          body = 'Time for your scheduled health check-in';
      }

      _logger.info(
          'Scheduling check-in reminder for $checkInType at ${scheduledTime.toIso8601String()}');

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'health_check_channel',
          title: title,
          body: body,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          payload: {
            'type': 'check_in_reminder',
            'check_in_type': checkInType,
          },
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledTime),
        actionButtons: [
          NotificationActionButton(
            key: 'COMPLETE_CHECKIN',
            label: 'Complete Now',
            color: Colors.blue,
          ),
          NotificationActionButton(
            key: 'REMIND_LATER',
            label: 'Later',
          ),
        ],
      );

      _logger.info('Check-in reminder scheduled successfully');
    } catch (e) {
      _logger.error('Failed to schedule check-in reminder', error: e);
    }
  }

  /// Process offline actions stored in secure storage
  Future<void> processOfflineActions() async {
    _logger.info('Processing offline actions');

    try {
      // Get SecureStorageService instance
      final secureStorage =
          await ServiceLocator.getAsync<SecureStorageService>();

      // Get stored offline actions
      final actionsJson = await secureStorage.readString('offline_actions');
      if (actionsJson == null || actionsJson.isEmpty) {
        _logger.info('No offline actions found');
        return;
      }

      // Parse stored actions
      final List<dynamic> actionsList = jsonDecode(actionsJson);
      _logger.info('Found ${actionsList.length} offline actions');

      if (actionsList.isEmpty) {
        return;
      }

      // Process each action
      for (final action in actionsList) {
        final actionType = action['action_type'];
        final data = action['data'];
        final timestamp = action['timestamp'];

        _logger.info('Processing offline action: $actionType from $timestamp');

        // Process different action types
        switch (actionType) {
          case 'medication_taken':
            await _processMedicationTakenOffline(data);
            break;
          case 'medication_skipped':
            await _processMedicationSkippedOffline(data);
            break;
          case 'medication_snoozed':
            await _processMedicationSnoozedOffline(data);
            break;
          default:
            _logger.warning('Unknown offline action type: $actionType');
        }
      }

      // Clear processed actions
      await secureStorage.delete('offline_actions');
      _logger.info('Offline actions processed and cleared');
    } catch (e) {
      _logger.error('Error processing offline actions', error: e);
    }
  }

  /// Process medication taken action from offline storage
  Future<void> _processMedicationTakenOffline(Map<String, dynamic> data) async {
    final medicationId = data['medication_id'];
    final takenAtStr = data['taken_at'];

    _logger.info('Processing offline medication taken: $medicationId');

    try {
      // Get medication service
      final medicationService = ServiceLocator.get<MedicationService>();

      // Convert timestamp string to DateTime
      final takenAt = DateTime.parse(takenAtStr);

      // Mark medication as taken via API
      final result = await medicationService.markMedicationTaken(
        medicationId: medicationId,
        takenAt: takenAt,
      );

      if (result.isSuccess) {
        _logger.info(
            'Successfully processed offline medication taken: $medicationId');

        // Track analytics
        final analyticsService = ServiceLocator.get<AnalyticsService>();
        await analyticsService.trackMedicationEvent(
          'medication_taken_offline',
          medicationId,
          additionalProperties: {
            'source': 'offline_processing',
            'original_time': takenAtStr,
            'processed_time': DateTime.now().toIso8601String(),
          },
        );
      } else {
        _logger.error('Failed to process offline medication taken',
            error: result.exception?.toString());
      }
    } catch (e) {
      _logger.error('Error processing offline medication taken', error: e);
    }
  }

  /// Process medication skipped action from offline storage
  Future<void> _processMedicationSkippedOffline(
      Map<String, dynamic> data) async {
    final medicationId = data['medication_id'];
    final skippedAtStr = data['skipped_at'];

    _logger.info('Processing offline medication skipped: $medicationId');

    try {
      // Get medication service
      final medicationService = ServiceLocator.get<MedicationService>();

      // Convert timestamp string to DateTime
      final skippedAt = DateTime.parse(skippedAtStr);

      // Mark medication as skipped via API
      final result = await medicationService.skipMedicationDose(
        medicationId: medicationId,
        skippedAt: skippedAt,
        reason: 'skipped_from_notification_offline',
      );

      if (result.isSuccess) {
        _logger.info(
            'Successfully processed offline medication skipped: $medicationId');

        // Track analytics
        final analyticsService = ServiceLocator.get<AnalyticsService>();
        await analyticsService.trackMedicationEvent(
          'medication_skipped_offline',
          medicationId,
          additionalProperties: {
            'source': 'offline_processing',
            'original_time': skippedAtStr,
            'processed_time': DateTime.now().toIso8601String(),
          },
        );
      } else {
        _logger.error('Failed to process offline medication skipped',
            error: result.exception?.toString());
      }
    } catch (e) {
      _logger.error('Error processing offline medication skipped', error: e);
    }
  }

  /// Process medication snoozed action from offline storage
  Future<void> _processMedicationSnoozedOffline(
      Map<String, dynamic> data) async {
    final medicationId = data['medication_id'];
    final snoozedAtStr = data['snoozed_at'];
    final snoozeDuration = data['snooze_duration'] ?? 15;

    _logger.info('Processing offline medication snoozed: $medicationId');

    try {
      // Schedule a new reminder notification
      final snoozedAt = DateTime.parse(snoozedAtStr);
      final newReminderTime = snoozedAt.add(Duration(minutes: snoozeDuration));

      // Only schedule if the new time is in the future
      if (newReminderTime.isAfter(DateTime.now())) {
        await scheduleMedicationReminder(
          medicationId: medicationId,
          scheduledTime: newReminderTime,
          isSnoozed: true,
        );

        _logger.info(
            'Successfully processed offline medication snoozed: $medicationId');

        // Track analytics
        final analyticsService = ServiceLocator.get<AnalyticsService>();
        await analyticsService.trackMedicationEvent(
          'medication_snoozed_offline',
          medicationId,
          additionalProperties: {
            'source': 'offline_processing',
            'original_time': snoozedAtStr,
            'new_reminder_time': newReminderTime.toIso8601String(),
            'processed_time': DateTime.now().toIso8601String(),
          },
        );
      } else {
        _logger.info('Skipping offline snooze as new time is in the past');
      }
    } catch (e) {
      _logger.error('Error processing offline medication snoozed', error: e);
    }
  }
}
