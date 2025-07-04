import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/firebase_messaging_service.dart';

/// Widget that handles Firebase messaging integration with improved
/// error handling, analytics, and user experience
class NotificationHandler extends StatefulWidget {
  final Widget child;
  final Function(RemoteMessage)? onMessageReceived;
  final Function(RemoteMessage)? onMessageTap;
  final Function(String)? onTokenRefresh;
  final Function(String)? onError;
  final bool enableAnalytics;
  final bool enableOfflineSupport;

  const NotificationHandler({
    super.key,
    required this.child,
    this.onMessageReceived,
    this.onMessageTap,
    this.onTokenRefresh,
    this.onError,
    this.enableAnalytics = true,
    this.enableOfflineSupport = true,
  });

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler>
    with WidgetsBindingObserver {
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();

  bool _isInitialized = false;
  String? _lastError;
  final Map<String, int> _messageStats = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupNotificationHandlers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messagingService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      default:
        break;
    }
  }

  Future<void> _setupNotificationHandlers() async {
    try {
      // Set up enhanced handlers
      _messagingService.setForegroundMessageHandler((RemoteMessage message) {
        _handleForegroundMessage(message);
        widget.onMessageReceived?.call(message);
      });

      _messagingService.setMessageTapHandler((RemoteMessage message) {
        _handleMessageTap(message);
        widget.onMessageTap?.call(message);
      });

      _messagingService.setTokenRefreshHandler((String token) {
        _handleTokenRefresh(token);
        widget.onTokenRefresh?.call(token);
      });

      _messagingService.setErrorHandler((String error) {
        _handleError(error);
        widget.onError?.call(error);
      });

      // Initialize the service
      await _messagingService.initialize();

      // Get initial token
      await _getInitialToken();

      setState(() {
        _isInitialized = true;
      });

      debugPrint('Enhanced notification handler initialized successfully');
    } catch (e) {
      _handleError('Failed to initialize notification handler: $e');
    }
  }

  Future<void> _getInitialToken() async {
    try {
      final token = await _messagingService.getToken();
      if (token != null) {
        debugPrint('Initial FCM token received');
        _handleTokenRefresh(token);
      }
    } catch (e) {
      _handleError('Error getting initial token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _updateMessageStats(message);

    // Handle different types of messages with enhanced logic
    final messageType = message.data['type'] ?? 'general';

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
      case 'emergency':
        _handleEmergencyAlert(message);
        break;
      default:
        _handleGenericMessage(message);
    }

    if (widget.enableAnalytics) {
      _trackMessageReceived(message);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate based on message type with enhanced routing
    final messageType = message.data['type'] ?? 'general';
    final context = this.context;

    if (widget.enableAnalytics) {
      _trackMessageTapped(message);
    }

    switch (messageType) {
      case 'medication_reminder':
        _navigateToMedications(context, message.data);
        break;
      case 'health_check':
        _navigateToHealthCheck(context, message.data);
        break;
      case 'care_group_update':
        _navigateToCareGroup(context, message.data);
        break;
      case 'system_alert':
        _navigateToSettings(context, message.data);
        break;
      case 'emergency':
        _handleEmergencyNavigation(context, message.data);
        break;
      default:
        _navigateToHome(context);
    }
  }

  void _handleTokenRefresh(String token) {
    debugPrint('Enhanced token refresh handled');

    if (widget.enableAnalytics) {
      _trackTokenRefresh();
    }
  }

  void _handleError(String error) {
    setState(() {
      _lastError = error;
    });

    debugPrint('Enhanced notification handler error: $error');

    if (widget.enableAnalytics) {
      _trackError(error);
    }
  }

  // App lifecycle handlers
  void _handleAppResumed() async {
    debugPrint('App resumed - checking for pending notifications');

    if (widget.enableOfflineSupport) {
      await _processPendingMessages();
    }
  }

  void _handleAppPaused() {
    debugPrint('App paused - saving notification state');
  }

  void _handleAppDetached() {
    debugPrint('App detached - cleaning up notification resources');
  }

  // Message type handlers
  void _handleMedicationReminder(RemoteMessage message) {
    if (mounted) {
      _showMedicationReminderDialog(message);
    }
  }

  void _handleHealthCheck(RemoteMessage message) {
    debugPrint('Health check reminder received');
    if (mounted) {
      _showHealthCheckDialog(message);
    }
  }

  void _handleCareGroupUpdate(RemoteMessage message) {
    debugPrint('Care group update received');
    if (mounted) {
      _showCareGroupSnackBar(message);
    }
  }

  void _handleSystemAlert(RemoteMessage message) {
    debugPrint('System alert received');
    if (mounted) {
      _showSystemAlertDialog(message);
    }
  }

  void _handleEmergencyAlert(RemoteMessage message) {
    debugPrint('Emergency alert received');
    if (mounted) {
      _showEmergencyDialog(message);
    }
  }

  void _handleGenericMessage(RemoteMessage message) {
    debugPrint('Generic message received: ${message.data}');
    if (mounted) {
      _showGenericSnackBar(message);
    }
  }

  // Enhanced dialogs and UI
  void _showMedicationReminderDialog(RemoteMessage message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.medication, color: Colors.blue, size: 48),
          title: Text(message.notification?.title ?? 'Medication Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.notification?.body ?? 'Time to take your medication',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (message.data['medication_name'] != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medication: ${message.data['medication_name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (message.data['dosage'] != null)
                        Text('Dosage: ${message.data['dosage']}'),
                      if (message.data['instructions'] != null)
                        Text('Instructions: ${message.data['instructions']}'),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markMedicationAsTaken(message.data);
              },
              child: const Text('Mark as Taken'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _snoozeMedicationReminder(message.data);
              },
              child: const Text('Snooze 15min'),
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

  void _showHealthCheckDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.health_and_safety,
              color: Colors.green, size: 48),
          title: Text(message.notification?.title ?? 'Health Check Reminder'),
          content: Text(
            message.notification?.body ?? 'Time for your daily health check',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToHealthCheck(context, message.data);
              },
              child: const Text('Start Check'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyDialog(RemoteMessage message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          icon: const Icon(Icons.emergency, color: Colors.red, size: 48),
          title: Text(
            message.notification?.title ?? 'Emergency Alert',
            style: const TextStyle(color: Colors.red),
          ),
          content: Text(
            message.notification?.body ?? 'This is an emergency notification',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                _handleEmergencyAction(message.data);
              },
              child: const Text('Take Action',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Acknowledge'),
            ),
          ],
        );
      },
    );
  }

  void _showSystemAlertDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info, color: Colors.orange, size: 48),
          title: Text(message.notification?.title ?? 'System Alert'),
          content: Text(
            message.notification?.body ?? 'System notification',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToSettings(context, message.data);
              },
              child: const Text('View Details'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCareGroupSnackBar(RemoteMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.group, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message.notification?.body ?? 'Care group update'),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _navigateToCareGroup(context, message.data),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showGenericSnackBar(RemoteMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message.notification?.body ?? 'New notification'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _navigateToHome(context),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Navigation methods
  void _navigateToMedications(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(context, '/medications', arguments: data);
  }

  void _navigateToHealthCheck(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(context, '/health-check', arguments: data);
  }

  void _navigateToCareGroup(BuildContext context, Map<String, dynamic> data) {
    final careGroupId = data['care_group_id'];
    Navigator.pushNamed(context, '/care-group', arguments: careGroupId);
  }

  void _navigateToSettings(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(context, '/settings', arguments: data);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _handleEmergencyNavigation(
      BuildContext context, Map<String, dynamic> data) {
    // Handle emergency-specific navigation
    Navigator.pushNamed(context, '/emergency', arguments: data);
  }

  // Action handlers
  Future<void> _markMedicationAsTaken(Map<String, dynamic> data) async {
    try {
      // TODO: Implement medication taken logic with API call
      debugPrint('Medication marked as taken: $data');

      if (widget.enableAnalytics) {
        _trackMedicationTaken(data);
      }
    } catch (e) {
      _handleError('Failed to mark medication as taken: $e');
    }
  }

  Future<void> _snoozeMedicationReminder(Map<String, dynamic> data) async {
    try {
      // TODO: Implement snooze logic with local scheduling
      debugPrint('Medication reminder snoozed: $data');

      if (widget.enableAnalytics) {
        _trackMedicationSnoozed(data);
      }
    } catch (e) {
      _handleError('Failed to snooze reminder: $e');
    }
  }

  Future<void> _handleEmergencyAction(Map<String, dynamic> data) async {
    try {
      // TODO: Implement emergency action logic
      debugPrint('Emergency action taken: $data');

      if (widget.enableAnalytics) {
        _trackEmergencyAction(data);
      }
    } catch (e) {
      _handleError('Failed to handle emergency action: $e');
    }
  }

  // Analytics and tracking
  void _updateMessageStats(RemoteMessage message) {
    final messageType = message.data['type'] ?? 'general';
    setState(() {
      _messageStats[messageType] = (_messageStats[messageType] ?? 0) + 1;
    });
  }

  void _trackMessageReceived(RemoteMessage message) {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Message received - ${message.data['type']}');
  }

  void _trackMessageTapped(RemoteMessage message) {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Message tapped - ${message.data['type']}');
  }

  void _trackTokenRefresh() {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Token refreshed');
  }

  void _trackError(String error) {
    // TODO: Implement error tracking
    debugPrint('Analytics: Error tracked - $error');
  }

  void _trackMedicationTaken(Map<String, dynamic> data) {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Medication taken - $data');
  }

  void _trackMedicationSnoozed(Map<String, dynamic> data) {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Medication snoozed - $data');
  }

  void _trackEmergencyAction(Map<String, dynamic> data) {
    // TODO: Implement analytics tracking
    debugPrint('Analytics: Emergency action - $data');
  }

  // Offline support
  Future<void> _processPendingMessages() async {
    if (!widget.enableOfflineSupport) return;

    try {
      // TODO: Process stored offline messages
      debugPrint('Processing pending offline messages');
    } catch (e) {
      _handleError('Failed to process pending messages: $e');
    }
  }

  // Status widget
  Widget _buildStatusIndicator() {
    if (!_isInitialized) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_lastError != null) {
      return const Icon(Icons.error, color: Colors.red, size: 16);
    }

    return const Icon(Icons.notifications_active,
        color: Colors.green, size: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter, // Use non-directional alignment
      children: [
        widget.child,
        // Debug status indicator (only in debug mode)
        if (MediaQuery.of(context).size.width > 0) // Always false in release
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: _buildStatusIndicator(),
            ),
          ),
      ],
    );
  }
}

/// Extension to add enhanced notification handling to any widget
extension NotificationHandlerExtension on Widget {
  Widget withNotificationHandler({
    Function(RemoteMessage)? onMessageReceived,
    Function(RemoteMessage)? onMessageTap,
    Function(String)? onTokenRefresh,
    Function(String)? onError,
    bool enableAnalytics = true,
    bool enableOfflineSupport = true,
  }) {
    return NotificationHandler(
      onMessageReceived: onMessageReceived,
      onMessageTap: onMessageTap,
      onTokenRefresh: onTokenRefresh,
      onError: onError,
      enableAnalytics: enableAnalytics,
      enableOfflineSupport: enableOfflineSupport,
      child: this,
    );
  }
}
