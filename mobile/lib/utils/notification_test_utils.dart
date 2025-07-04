import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/firebase_messaging_service.dart';
import '../config/app_config.dart';

/// Utility class for testing Firebase notifications
class NotificationTestUtils {
  static final FirebaseMessagingService _messagingService =
      FirebaseMessagingService();

  /// Test notification permissions
  static Future<void> testNotificationPermissions() async {
    try {
      final token = await _messagingService.getToken();
      if (token != null) {
        debugPrint('✅ FCM Token received: ${token.substring(0, 30)}...');
        return;
      }
      debugPrint('❌ Failed to get FCM token');
    } catch (e) {
      debugPrint('❌ Error testing permissions: $e');
    }
  }

  /// Send a test notification from the server
  static Future<void> sendTestNotification({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final token = await _messagingService.getToken();
      if (token == null) {
        debugPrint('❌ No FCM token available');
        return;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/api/notifications/send-test'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'notification': {'title': title, 'body': body},
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Test notification sent successfully');
      } else {
        debugPrint(
          '❌ Failed to send test notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error sending test notification: $e');
    }
  }

  /// Test topic subscription
  static Future<void> testTopicSubscription(String topic) async {
    try {
      await _messagingService.subscribeToTopic(topic);
      debugPrint('✅ Successfully subscribed to topic: $topic');

      // Wait a moment then unsubscribe
      await Future.delayed(const Duration(seconds: 2));
      await _messagingService.unsubscribeFromTopic(topic);
      debugPrint('✅ Successfully unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error testing topic subscription: $e');
    }
  }

  /// Show notification test dialog
  static void showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Firebase Notification Test'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Test Firebase Cloud Messaging functionality:'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await testNotificationPermissions();
                },
                child: const Text('Test Permissions'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await sendTestNotification(
                    title: 'Test Notification',
                    body: 'This is a test notification from CareCircle',
                    data: {
                      'type': 'test',
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );
                },
                child: const Text('Send Test Notification'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await testTopicSubscription('test_topic');
                },
                child: const Text('Test Topic Subscription'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await sendTestNotification(
                    title: 'Medication Reminder',
                    body: 'Time to take your morning medication',
                    data: {
                      'type': 'medication_reminder',
                      'medication_id': 'test_med_123',
                      'scheduled_time': DateTime.now().toIso8601String(),
                    },
                  );
                },
                child: const Text('Test Medication Reminder'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Get background messages for debugging
  static Future<void> showBackgroundMessages(BuildContext context) async {
    try {
      final messages = await _messagingService.getBackgroundMessages();

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Background Messages'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: messages.isEmpty
                  ? const Center(child: Text('No background messages'))
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              message['notification']?['title'] ?? 'No title',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['notification']?['body'] ?? 'No body',
                                ),
                                Text('Data: ${message['data']}'),
                                Text('Time: ${message['timestamp']}'),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _messagingService.clearBackgroundMessages();
                  Navigator.of(context).pop();
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Error showing background messages: $e');
    }
  }
}

/// Test Widget for debugging notifications
class NotificationTestWidget extends StatefulWidget {
  const NotificationTestWidget({super.key});

  @override
  State<NotificationTestWidget> createState() => _NotificationTestWidgetState();
}

class _NotificationTestWidgetState extends State<NotificationTestWidget> {
  String _tokenStatus = 'Checking...';
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    try {
      final token = await FirebaseMessagingService().getToken();
      setState(() {
        if (token != null) {
          _tokenStatus = 'Token: ${token.substring(0, 30)}...';
          _permissionsGranted = true;
        } else {
          _tokenStatus = 'No token available';
          _permissionsGranted = false;
        }
      });
    } catch (e) {
      setState(() {
        _tokenStatus = 'Error: $e';
        _permissionsGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _permissionsGranted ? Icons.check_circle : Icons.error,
                  color: _permissionsGranted ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Firebase Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_tokenStatus),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      NotificationTestUtils.showTestDialog(context),
                  child: const Text('Test Notifications'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      NotificationTestUtils.showBackgroundMessages(context),
                  child: const Text('Background Messages'),
                ),
                ElevatedButton(
                  onPressed: _checkStatus,
                  child: const Text('Refresh Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
