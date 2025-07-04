import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firebase_messaging_service.dart';

/// Widget that handles Firebase messaging integration
class NotificationHandler extends StatefulWidget {
  final Widget child;
  final Function(RemoteMessage)? onMessageReceived;
  final Function(RemoteMessage)? onMessageTap;
  final Function(String)? onTokenRefresh;

  const NotificationHandler({
    super.key,
    required this.child,
    this.onMessageReceived,
    this.onMessageTap,
    this.onTokenRefresh,
  });

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();

  @override
  void initState() {
    super.initState();
    _setupNotificationHandlers();
  }

  void _setupNotificationHandlers() {
    // Set up custom handlers
    _messagingService.setForegroundMessageHandler((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.data}');
      _handleForegroundMessage(message);
      widget.onMessageReceived?.call(message);
    });

    _messagingService.setMessageTapHandler((RemoteMessage message) {
      debugPrint('Message tapped: ${message.data}');
      _handleMessageTap(message);
      widget.onMessageTap?.call(message);
    });

    _messagingService.setTokenRefreshHandler((String token) {
      debugPrint('Token refreshed: ${token.substring(0, 20)}...');
      widget.onTokenRefresh?.call(token);
    });

    // Get initial token
    _getInitialToken();
  }

  Future<void> _getInitialToken() async {
    try {
      final token = await _messagingService.getToken();
      if (token != null) {
        debugPrint('Initial FCM token received');
      }
    } catch (e) {
      debugPrint('Error getting initial token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle different types of messages
    final messageType = message.data['type'];
    
    switch (messageType) {
      case 'medication_reminder':
        _handleMedicationReminder(message);
        break;
      case 'health_check':
        _handleHealthCheck(message);
        break;
      case 'care_group_update':
        _handleCareGroupUpdate(message);
        break;
      case 'system_alert':
        _handleSystemAlert(message);
        break;
      default:
        _handleGenericMessage(message);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate based on message type
    final messageType = message.data['type'];
    final context = this.context;
    
    switch (messageType) {
      case 'medication_reminder':
        Navigator.pushNamed(context, '/medications');
        break;
      case 'health_check':
        Navigator.pushNamed(context, '/health-check');
        break;
      case 'care_group_update':
        final careGroupId = message.data['care_group_id'];
        Navigator.pushNamed(context, '/care-group', arguments: careGroupId);
        break;
      case 'system_alert':
        Navigator.pushNamed(context, '/settings');
        break;
      default:
        Navigator.pushNamed(context, '/home');
    }
  }

  void _handleMedicationReminder(RemoteMessage message) {
    // Show medication reminder dialog or notification
    if (mounted) {
      _showMedicationReminderDialog(message);
    }
  }

  void _handleHealthCheck(RemoteMessage message) {
    // Handle health check reminder
    debugPrint('Health check reminder received');
  }

  void _handleCareGroupUpdate(RemoteMessage message) {
    // Handle care group updates
    debugPrint('Care group update received');
  }

  void _handleSystemAlert(RemoteMessage message) {
    // Handle system alerts
    debugPrint('System alert received');
  }

  void _handleGenericMessage(RemoteMessage message) {
    // Handle generic messages
    debugPrint('Generic message received: ${message.data}');
  }

  void _showMedicationReminderDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.notification?.title ?? 'Medication Reminder'),
          content: Text(message.notification?.body ?? 'Time to take your medication'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Mark as taken
                _markMedicationAsTaken(message.data);
              },
              child: const Text('Taken'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Snooze for later
                _snoozeMedicationReminder(message.data);
              },
              child: const Text('Snooze'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _markMedicationAsTaken(Map<String, dynamic> data) async {
    // TODO: Implement medication taken logic
    debugPrint('Medication marked as taken: $data');
  }

  Future<void> _snoozeMedicationReminder(Map<String, dynamic> data) async {
    // TODO: Implement snooze logic
    debugPrint('Medication reminder snoozed: $data');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _messagingService.dispose();
    super.dispose();
  }
}

/// Extension to add notification handling to any widget
extension NotificationHandlerExtension on Widget {
  Widget withNotificationHandler({
    Function(RemoteMessage)? onMessageReceived,
    Function(RemoteMessage)? onMessageTap,
    Function(String)? onTokenRefresh,
  }) {
    return NotificationHandler(
      onMessageReceived: onMessageReceived,
      onMessageTap: onMessageTap,
      onTokenRefresh: onTokenRefresh,
      child: this,
    );
  }
}
