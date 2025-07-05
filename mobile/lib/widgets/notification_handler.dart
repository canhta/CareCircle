import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../common/common.dart';
import '../config/service_locator.dart';
import '../utils/notification_manager.dart';
import '../utils/navigation_service.dart';
import '../utils/analytics_service.dart';

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
  late final NotificationManager _notificationManager;

  @override
  void initState() {
    super.initState();
    _logger = ServiceLocator.get<AppLogger>();
    _notificationManager = ServiceLocator.get<NotificationManager>();
    _setupNotificationListeners();
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

  /// Handle notification actions (tap, button press, etc.)
  @pragma('vm:entry-point')
  static Future<void> _onNotificationAction(
      ReceivedAction receivedAction) async {
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
    final medicationId = action.payload?['medication_id'];

    logger.info('Handling medication reminder action for: $medicationId');

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
    final alertType = action.payload?['alert_type'];

    logger.info('Handling emergency alert action: $alertType');

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
    final checkInType = action.payload?['check_in_type'];

    logger.info('Handling check-in reminder action: $checkInType');

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
    final groupId = action.payload?['group_id'];

    logger.info('Handling care group update action for: $groupId');

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
    logger.info('Notification created: ${notification.id}');

    // Track analytics
    await _trackNotificationEvent('notification_created', {
      'notification_id': notification.id.toString(),
      'channel_key': notification.channelKey ?? 'unknown',
      'title': notification.title ?? 'no_title',
    });
  }

  /// Called when notification is displayed
  @pragma('vm:entry-point')
  static Future<void> _onNotificationDisplayed(
      ReceivedNotification notification) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Notification displayed: ${notification.id}');

    // Track analytics
    await _trackNotificationEvent('notification_displayed', {
      'notification_id': notification.id.toString(),
      'channel_key': notification.channelKey ?? 'unknown',
    });
  }

  /// Called when notification is dismissed
  @pragma('vm:entry-point')
  static Future<void> _onNotificationDismissed(ReceivedAction action) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Notification dismissed: ${action.id}');

    // Track analytics
    await _trackNotificationEvent('notification_dismissed', {
      'notification_id': action.id.toString(),
      'channel_key': action.channelKey ?? 'unknown',
    });
  }

  // Medication reminder actions
  static Future<void> _markMedicationTaken(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Marking medication taken: $medicationId');

    // Track analytics
    await analyticsService.trackMedicationEvent(
        'medication_taken', medicationId ?? 'unknown');

    // TODO: Implement API call to mark medication as taken
    // TODO: Update local state
  }

  static Future<void> _snoozeMedicationReminder(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Snoozing medication reminder: $medicationId');

    // Track analytics
    await analyticsService.trackMedicationEvent(
        'medication_snoozed', medicationId ?? 'unknown');

    // TODO: Implement snooze logic with local scheduling
  }

  static Future<void> _skipMedicationReminder(String? medicationId) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Skipping medication reminder: $medicationId');

    // Track analytics
    await analyticsService.trackMedicationEvent(
        'medication_skipped', medicationId ?? 'unknown');

    // TODO: Implement skip logic
    // TODO: Track analytics
  }

  // Emergency alert actions
  static Future<void> _callEmergencyServices() async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Calling emergency services');

    // TODO: Implement emergency call logic
    // TODO: Track analytics
  }

  static Future<void> _notifyEmergencyContacts() async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Notifying emergency contacts');

    // TODO: Implement emergency contact notification
    // TODO: Track analytics
  }

  static Future<void> _dismissEmergencyAlert() async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Dismissing emergency alert');

    // TODO: Implement emergency alert dismissal
    // TODO: Track analytics
  }

  // Check-in reminder actions
  static Future<void> _completeCheckIn(String? checkInType) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Completing check-in: $checkInType');

    // TODO: Implement check-in completion
    // TODO: Track analytics
  }

  static Future<void> _remindCheckInLater(String? checkInType) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Reminding check-in later: $checkInType');

    // TODO: Implement check-in reminder scheduling
    // TODO: Track analytics
  }

  // Care group update actions
  static Future<void> _viewCareGroupUpdate(String? groupId) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Viewing care group update: $groupId');

    // TODO: Implement care group update viewing
    // TODO: Track analytics
  }

  static Future<void> _replyCareGroupUpdate(String? groupId) async {
    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Replying to care group update: $groupId');

    // TODO: Implement care group update reply
    // TODO: Track analytics
  }

  // Analytics tracking
  static Future<void> _trackNotificationEvent(
      String eventName, Map<String, dynamic> properties) async {
    final logger = ServiceLocator.get<AppLogger>();
    final analyticsService = ServiceLocator.get<AnalyticsService>();

    logger.info('Analytics event: $eventName with properties: $properties');

    // Track with analytics service
    await analyticsService.trackNotificationEvent(eventName, properties);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    // Clean up notification listeners if needed
    super.dispose();
  }
}
