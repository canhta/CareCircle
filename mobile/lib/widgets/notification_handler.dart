import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../common/common.dart';
import '../config/service_locator.dart';
import '../utils/notification_manager.dart';
import '../utils/navigation_service.dart';
import '../utils/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/medication/data/medication_service.dart';
import 'dart:convert';

/// Widget that handles notification interactions and actions
/// Provides a centralized way to handle notification taps, actions, and lifecycle
class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({
    super.key,
    required this.child,
  });

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  late final AppLogger _logger;
  NotificationManager? _notificationManager;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _logger = ServiceLocator.get<AppLogger>();
    _initializeNotificationManager();
  }

  Future<void> _initializeNotificationManager() async {
    try {
      _logger.info('Getting NotificationManager from ServiceLocator');
      _notificationManager =
          await ServiceLocator.getAsync<NotificationManager>();
      _setupNotificationListeners();
      _processOfflineMessages();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      _logger.error('Failed to get NotificationManager', error: e);
    }
  }

  /// Set up notification action listeners
  void _setupNotificationListeners() {
    // Listen for notification taps
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onNotificationAction,
      onNotificationCreatedMethod: _onNotificationCreated,
      onNotificationDisplayedMethod: _onNotificationDisplayed,
      onDismissActionReceivedMethod: _onNotificationDismissed,
    );
  }

  /// Process any stored offline messages
  Future<void> _processOfflineMessages() async {
    if (_notificationManager == null) {
      _logger.error(
          'NotificationManager is null, cannot process offline messages');
      return;
    }

    try {
      final messageResult = await _notificationManager!.getStoredMessages();
      if (messageResult.isSuccess && messageResult.data != null) {
        final messages = messageResult.data!;

        if (messages.isNotEmpty) {
          _logger.info('Processing ${messages.length} stored offline messages');

          for (final message in messages) {
            // Process each message
            await _notificationManager!.processMessage(message);
          }

          // Clear processed messages
          await _notificationManager!.clearStoredMessages();
        }
      }
    } catch (e) {
      _logger.error('Error processing offline messages', error: e);
    }
  }

  /// Handle notification actions (tap, button press, etc.)
  @pragma('vm:entry-point')
  static Future<void> _onNotificationAction(
      ReceivedAction receivedAction) async {
    // Get a static logger instance
    final logger = ServiceLocator.get<AppLogger>();

    logger.info('Notification action received: ${receivedAction.actionType}');

    // Get the payload data
    final payload = receivedAction.payload ?? {};
    final messageType = payload['type'] ?? 'unknown';

    switch (messageType) {
      case 'medication_reminder':
        await _handleMedicationReminderAction(receivedAction);
        break;
      case 'emergency_alert':
        await _handleEmergencyAlertAction(receivedAction);
        break;
      case 'check_in_reminder':
        await _handleCheckInReminderAction(receivedAction);
        break;
      case 'care_group_update':
        await _handleCareGroupUpdateAction(receivedAction);
        break;
      default:
        logger.warning('Unknown notification action type: $messageType');
    }
  }

  /// Handle medication reminder actions
  static Future<void> _handleMedicationReminderAction(
      ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    final medicationId = action.payload?['medication_id'];

    logger.info('Handling medication reminder action for: $medicationId');

    // Track analytics for medication reminder interaction
    await analyticsService.trackMedicationEvent(
      'medication_reminder_interaction',
      medicationId ?? 'unknown',
      additionalProperties: {
        'action': action.buttonKeyPressed,
        'time': DateTime.now().toIso8601String(),
      },
    );

    switch (action.buttonKeyPressed) {
      case 'TAKE_MEDICATION':
        await _markMedicationTaken(medicationId);
        break;
      case 'SNOOZE':
        await _snoozeMedicationReminder(medicationId);
        break;
      case 'SKIP':
        await _skipMedicationReminder(medicationId);
        break;
      default:
        // Just tapped the notification - navigate to medications screen
        logger.info('Navigate to medications screen');
        final navigationService = ServiceLocator.get<NavigationService>();
        await navigationService.navigateFromNotification(
            'medication_reminder', action.payload ?? {});
    }
  }

  /// Handle emergency alert actions
  static Future<void> _handleEmergencyAlertAction(ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    final alertType = action.payload?['alert_type'] ?? 'unknown';

    logger.info('Handling emergency alert action: $alertType');

    // Track analytics for emergency alert interaction
    await analyticsService.trackEmergencyEvent(
      'emergency_alert_interaction',
      alertType,
      additionalProperties: {
        'action': action.buttonKeyPressed,
        'time': DateTime.now().toIso8601String(),
      },
    );

    switch (action.buttonKeyPressed) {
      case 'CALL_EMERGENCY':
        await _callEmergencyServices();
        break;
      case 'NOTIFY_CONTACTS':
        await _notifyEmergencyContacts();
        break;
      case 'DISMISS':
        await _dismissEmergencyAlert();
        break;
      default:
        // Navigate to emergency screen
        logger.info('Navigate to emergency screen');
        final navigationService = ServiceLocator.get<NavigationService>();
        await navigationService.navigateFromNotification(
            'emergency_alert', action.payload ?? {});
    }
  }

  /// Handle check-in reminder actions
  static Future<void> _handleCheckInReminderAction(
      ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    final checkInType = action.payload?['check_in_type'] ?? 'daily';

    logger.info('Handling check-in reminder action: $checkInType');

    // Track analytics for check-in reminder interaction
    await analyticsService.trackHealthCheckEvent(
      'check_in_reminder_interaction',
      checkInType,
      additionalProperties: {
        'action': action.buttonKeyPressed,
        'time': DateTime.now().toIso8601String(),
      },
    );

    switch (action.buttonKeyPressed) {
      case 'COMPLETE_CHECKIN':
        await _completeCheckIn(checkInType);
        break;
      case 'REMIND_LATER':
        await _remindCheckInLater(checkInType);
        break;
      default:
        // Navigate to health check screen
        logger.info('Navigate to health check screen');
        final navigationService = ServiceLocator.get<NavigationService>();
        await navigationService.navigateFromNotification(
            'check_in_reminder', action.payload ?? {});
    }
  }

  /// Handle care group update actions
  static Future<void> _handleCareGroupUpdateAction(
      ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    final groupId = action.payload?['group_id'] ?? 'unknown';

    logger.info('Handling care group update action for: $groupId');

    // Track analytics for care group update interaction
    await analyticsService.trackCareGroupEvent(
      'care_group_update_interaction',
      groupId,
      additionalProperties: {
        'action': action.buttonKeyPressed,
        'time': DateTime.now().toIso8601String(),
      },
    );

    switch (action.buttonKeyPressed) {
      case 'VIEW_UPDATE':
        await _viewCareGroupUpdate(groupId);
        break;
      case 'REPLY':
        await _replyCareGroupUpdate(groupId);
        break;
      default:
        // Navigate to care group screen
        logger.info('Navigate to care group screen');
        final navigationService = ServiceLocator.get<NavigationService>();
        await navigationService.navigateFromNotification(
            'care_group_update', action.payload ?? {});
    }
  }

  /// Called when notification is created
  @pragma('vm:entry-point')
  static Future<void> _onNotificationCreated(
      ReceivedNotification notification) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    logger.info('Notification created: ${notification.id}');

    // Track analytics
    await analyticsService.trackNotificationEvent('notification_created', {
      'notification_id': notification.id.toString(),
      'channel_key': notification.channelKey ?? 'unknown',
      'title': notification.title ?? 'no_title',
      'type': notification.payload?['type'] ?? 'unknown',
    });
  }

  /// Called when notification is displayed
  @pragma('vm:entry-point')
  static Future<void> _onNotificationDisplayed(
      ReceivedNotification notification) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    logger.info('Notification displayed: ${notification.id}');

    // Track analytics
    await analyticsService.trackNotificationEvent('notification_displayed', {
      'notification_id': notification.id.toString(),
      'channel_key': notification.channelKey ?? 'unknown',
      'display_time': DateTime.now().toIso8601String(),
      'type': notification.payload?['type'] ?? 'unknown',
    });
  }

  /// Called when notification is dismissed
  @pragma('vm:entry-point')
  static Future<void> _onNotificationDismissed(ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();
    logger.info('Notification dismissed: ${action.id}');

    // Track analytics
    await analyticsService.trackNotificationEvent('notification_dismissed', {
      'notification_id': action.id.toString(),
      'channel_key': action.channelKey ?? 'unknown',
      'dismiss_time': DateTime.now().toIso8601String(),
      'type': action.payload?['type'] ?? 'unknown',
    });
  }

  // Medication reminder actions
  static Future<void> _markMedicationTaken(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Marking medication taken: $medicationId');

    if (medicationId == null) {
      logger.warning('Cannot mark medication as taken: medicationId is null');
      return;
    }

    try {
      // Get medication service
      final medicationService = ServiceLocator.get<MedicationService>();

      // Mark medication as taken via API
      final result = await medicationService.markMedicationTaken(
        medicationId: medicationId,
        takenAt: DateTime.now(),
      );

      if (result.isSuccess) {
        logger.info('Successfully marked medication as taken: $medicationId');

        // Track analytics
        await analyticsService.trackMedicationEvent(
          'medication_taken',
          medicationId,
          additionalProperties: {
            'source': 'notification',
            'time': DateTime.now().toIso8601String(),
          },
        );
      } else {
        logger.error('Failed to mark medication as taken',
            error: result.exception?.toString());

        // Store action for offline processing
        await _storeOfflineAction('medication_taken', {
          'medication_id': medicationId,
          'taken_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      logger.error('Error marking medication as taken', error: e);

      // Store action for offline processing
      await _storeOfflineAction('medication_taken', {
        'medication_id': medicationId,
        'taken_at': DateTime.now().toIso8601String(),
      });
    }
  }

  static Future<void> _snoozeMedicationReminder(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Snoozing medication reminder: $medicationId');

    if (medicationId == null) {
      logger.warning('Cannot snooze reminder: medicationId is null');
      return;
    }

    // Default snooze time: 15 minutes
    final snoozeTime = DateTime.now().add(const Duration(minutes: 15));

    try {
      // Get notification manager
      final notificationManager = ServiceLocator.get<NotificationManager>();

      // Schedule a new reminder
      await notificationManager.scheduleMedicationReminder(
        medicationId: medicationId,
        scheduledTime: snoozeTime,
        isSnoozed: true,
      );

      // Track analytics
      await analyticsService.trackMedicationEvent(
        'medication_snoozed',
        medicationId,
        additionalProperties: {
          'snooze_time': snoozeTime.toIso8601String(),
          'source': 'notification',
        },
      );

      logger.info(
          'Medication reminder snoozed until: ${snoozeTime.toIso8601String()}');
    } catch (e) {
      logger.error('Error snoozing medication reminder', error: e);
    }
  }

  static Future<void> _skipMedicationReminder(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Skipping medication reminder: $medicationId');

    if (medicationId == null) {
      logger.warning('Cannot skip reminder: medicationId is null');
      return;
    }

    try {
      // Get medication service
      final medicationService = ServiceLocator.get<MedicationService>();

      // Mark medication as skipped via API
      final result = await medicationService.skipMedicationDose(
        medicationId: medicationId,
        skippedAt: DateTime.now(),
        reason: 'skipped_from_notification',
      );

      if (result.isSuccess) {
        logger.info('Successfully skipped medication: $medicationId');

        // Track analytics
        await analyticsService.trackMedicationEvent(
          'medication_skipped',
          medicationId,
          additionalProperties: {
            'source': 'notification',
            'time': DateTime.now().toIso8601String(),
          },
        );
      } else {
        logger.error('Failed to skip medication',
            error: result.exception?.toString());

        // Store action for offline processing
        await _storeOfflineAction('medication_skipped', {
          'medication_id': medicationId,
          'skipped_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      logger.error('Error skipping medication reminder', error: e);

      // Store action for offline processing
      await _storeOfflineAction('medication_skipped', {
        'medication_id': medicationId,
        'skipped_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // Emergency alert actions
  static Future<void> _callEmergencyServices() async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Calling emergency services');

    try {
      // Launch phone call to emergency number
      final emergencyNumber = '911'; // This should be configurable per region
      final url = Uri.parse('tel:$emergencyNumber');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        logger.info('Launched emergency call to: $emergencyNumber');

        // Track analytics
        await analyticsService.trackEmergencyEvent(
          'emergency_call_initiated',
          'emergency_call',
          additionalProperties: {
            'number': emergencyNumber,
            'time': DateTime.now().toIso8601String(),
            'source': 'notification',
          },
        );
      } else {
        logger.error('Could not launch emergency call: $url');
      }
    } catch (e) {
      logger.error('Error calling emergency services', error: e);
    }
  }

  static Future<void> _notifyEmergencyContacts() async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Notifying emergency contacts');

    try {
      // In a real implementation, this would get emergency contacts from a service
      // and send SMS/notifications to them

      // Mock implementation for now
      logger.info('Emergency contacts would be notified here');

      // Track analytics
      await analyticsService.trackEmergencyEvent(
        'emergency_contacts_notified',
        'emergency_contacts',
        additionalProperties: {
          'time': DateTime.now().toIso8601String(),
          'source': 'notification',
        },
      );
    } catch (e) {
      logger.error('Error notifying emergency contacts', error: e);
    }
  }

  static Future<void> _dismissEmergencyAlert() async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Dismissing emergency alert');

    try {
      // Track analytics for dismissal
      await analyticsService.trackEmergencyEvent(
        'emergency_alert_dismissed',
        'emergency_dismissal',
        additionalProperties: {
          'time': DateTime.now().toIso8601String(),
          'source': 'notification',
        },
      );
    } catch (e) {
      logger.error('Error dismissing emergency alert', error: e);
    }
  }

  // Check-in reminder actions
  static Future<void> _completeCheckIn(String? checkInType) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Completing check-in: $checkInType');

    // Navigate to the check-in form
    final navigationService = ServiceLocator.get<NavigationService>();
    await navigationService.navigateFromNotification(
      'check_in_completion',
      {'check_in_type': checkInType ?? 'daily'},
    );

    // Track analytics
    await analyticsService.trackHealthCheckEvent(
      'check_in_completed',
      checkInType ?? 'unknown',
      additionalProperties: {
        'time': DateTime.now().toIso8601String(),
        'source': 'notification',
      },
    );
  }

  static Future<void> _remindCheckInLater(String? checkInType) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Reminding check-in later: $checkInType');

    // Reschedule check-in for 1 hour later
    final rescheduleTime = DateTime.now().add(const Duration(hours: 1));

    try {
      // Get notification manager
      final notificationManager = ServiceLocator.get<NotificationManager>();

      // Schedule a new check-in reminder
      await notificationManager.scheduleCheckInReminder(
        checkInType: checkInType ?? 'daily',
        scheduledTime: rescheduleTime,
      );

      logger.info(
          'Check-in reminder rescheduled for: ${rescheduleTime.toIso8601String()}');

      // Track analytics
      await analyticsService.trackHealthCheckEvent(
        'check_in_rescheduled',
        checkInType ?? 'unknown',
        additionalProperties: {
          'rescheduled_time': rescheduleTime.toIso8601String(),
          'source': 'notification',
        },
      );
    } catch (e) {
      logger.error('Error rescheduling check-in reminder', error: e);
    }
  }

  // Care group update actions
  static Future<void> _viewCareGroupUpdate(String? groupId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Viewing care group update: $groupId');

    if (groupId == null || groupId == 'unknown') {
      logger
          .warning('Cannot view care group update: groupId is null or unknown');
      return;
    }

    try {
      // Navigate to care group details
      final navigationService = ServiceLocator.get<NavigationService>();
      await navigationService.navigateFromNotification(
        'care_group_detail',
        {'group_id': groupId},
      );

      // Track analytics
      await analyticsService.trackCareGroupEvent(
        'care_group_update_viewed',
        groupId,
        additionalProperties: {
          'time': DateTime.now().toIso8601String(),
          'source': 'notification',
        },
      );
    } catch (e) {
      logger.error('Error viewing care group update', error: e);
    }
  }

  static Future<void> _replyCareGroupUpdate(String? groupId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Replying to care group update: $groupId');

    if (groupId == null || groupId == 'unknown') {
      logger.warning(
          'Cannot reply to care group update: groupId is null or unknown');
      return;
    }

    try {
      // Navigate to reply screen
      final navigationService = ServiceLocator.get<NavigationService>();
      await navigationService.navigateFromNotification(
        'care_group_reply',
        {'group_id': groupId},
      );

      // Track analytics
      await analyticsService.trackCareGroupEvent(
        'care_group_update_reply_started',
        groupId,
        additionalProperties: {
          'time': DateTime.now().toIso8601String(),
          'source': 'notification',
        },
      );
    } catch (e) {
      logger.error('Error replying to care group update', error: e);
    }
  }

  // Store offline action for later processing
  static Future<void> _storeOfflineAction(
      String actionType, Map<String, dynamic> data) async {
    final logger = ServiceLocator.get<AppLogger>();
    final secureStorage = ServiceLocator.get<SecureStorageService>();

    try {
      // Get existing offline actions
      String? existingActionsJson =
          await secureStorage.readString('offline_actions');
      List<Map<String, dynamic>> offlineActions = [];

      if (existingActionsJson != null) {
        final decoded = jsonDecode(existingActionsJson);
        offlineActions = List<Map<String, dynamic>>.from(decoded);
      }

      // Add new action
      offlineActions.add({
        'action_type': actionType,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Save updated list
      await secureStorage.writeString(
        'offline_actions',
        jsonEncode(offlineActions),
      );

      logger.info('Stored offline action: $actionType');
    } catch (e) {
      logger.error('Failed to store offline action', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? widget.child
        : const SizedBox(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  void dispose() {
    // Clean up notification listeners if needed
    super.dispose();
  }
}
