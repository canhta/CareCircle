import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ai/ai_assistant_config.dart';

enum NotificationType {
  healthInsight,
  medicationReminder,
  checkIn,
  emergency,
  educational,
}

class ProactiveNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final Map<String, dynamic> data;
  final bool isUrgent;

  const ProactiveNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledTime,
    this.data = const {},
    this.isUrgent = false,
  });
}

class ProactiveNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to appropriate screen based on notification type
  }

  static Future<void> scheduleHealthInsight({
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, dynamic> data = const {},
  }) async {
    if (!AIAssistantConfig.enableProactiveNotifications) return;

    await _scheduleNotification(
      ProactiveNotification(
        id: 'health_insight_${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.healthInsight,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        data: data,
      ),
    );
  }

  static Future<void> scheduleMedicationReminder({
    required String medicationName,
    required DateTime scheduledTime,
    Map<String, dynamic> data = const {},
  }) async {
    if (!AIAssistantConfig.enableProactiveNotifications) return;

    await _scheduleNotification(
      ProactiveNotification(
        id: 'medication_${medicationName}_${scheduledTime.millisecondsSinceEpoch}',
        type: NotificationType.medicationReminder,
        title: 'Medication Reminder',
        body: 'Time to take your $medicationName',
        scheduledTime: scheduledTime,
        data: data,
        isUrgent: true,
      ),
    );
  }

  static Future<void> scheduleHealthCheckIn({
    required DateTime scheduledTime,
    String? customMessage,
  }) async {
    if (!AIAssistantConfig.enableProactiveNotifications) return;

    await _scheduleNotification(
      ProactiveNotification(
        id: 'check_in_${scheduledTime.millisecondsSinceEpoch}',
        type: NotificationType.checkIn,
        title: 'Health Check-in',
        body:
            customMessage ??
            'How are you feeling today? Your AI assistant is here to help.',
        scheduledTime: scheduledTime,
      ),
    );
  }

  static Future<void> scheduleEmergencyFollowUp({
    required DateTime scheduledTime,
    required String context,
  }) async {
    await _scheduleNotification(
      ProactiveNotification(
        id: 'emergency_followup_${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.emergency,
        title: 'Emergency Follow-up',
        body: 'Checking in after your recent emergency. How are you feeling?',
        scheduledTime: scheduledTime,
        data: {'context': context},
        isUrgent: true,
      ),
    );
  }

  static Future<void> scheduleEducationalContent({
    required String title,
    required String body,
    required DateTime scheduledTime,
    Map<String, dynamic> data = const {},
  }) async {
    if (!AIAssistantConfig.enableProactiveNotifications) return;

    await _scheduleNotification(
      ProactiveNotification(
        id: 'education_${DateTime.now().millisecondsSinceEpoch}',
        type: NotificationType.educational,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        data: data,
      ),
    );
  }

  static Future<void> _scheduleNotification(
    ProactiveNotification notification,
  ) async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      _getChannelId(notification.type),
      _getChannelName(notification.type),
      channelDescription: _getChannelDescription(notification.type),
      importance: notification.isUrgent
          ? Importance.high
          : Importance.defaultImportance,
      priority: notification.isUrgent
          ? Priority.high
          : Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF4285F4), // CareCircle blue
      playSound: true,
      enableVibration: notification.isUrgent,
      category: AndroidNotificationCategory.reminder,
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: notification.isUrgent
          ? InterruptionLevel.critical
          : InterruptionLevel.active,
      categoryIdentifier: notification.type.name,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: notification.id,
    );
  }

  static String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.healthInsight:
        return 'health_insights';
      case NotificationType.medicationReminder:
        return 'medication_reminders';
      case NotificationType.checkIn:
        return 'health_checkins';
      case NotificationType.emergency:
        return 'emergency_notifications';
      case NotificationType.educational:
        return 'educational_content';
    }
  }

  static String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.healthInsight:
        return 'Health Insights';
      case NotificationType.medicationReminder:
        return 'Medication Reminders';
      case NotificationType.checkIn:
        return 'Health Check-ins';
      case NotificationType.emergency:
        return 'Emergency Notifications';
      case NotificationType.educational:
        return 'Educational Content';
    }
  }

  static String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.healthInsight:
        return 'AI-generated insights about your health trends and patterns';
      case NotificationType.medicationReminder:
        return 'Reminders to take your medications on time';
      case NotificationType.checkIn:
        return 'Regular check-ins from your AI health assistant';
      case NotificationType.emergency:
        return 'Critical health notifications and emergency follow-ups';
      case NotificationType.educational:
        return 'Educational health content and tips';
    }
  }

  static Future<void> cancelNotification(String notificationId) async {
    await _notifications.cancel(notificationId.hashCode);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Smart notification scheduling based on user patterns
  static Future<void> scheduleSmartHealthCheckIn({
    required String userId,
    DateTime? preferredTime,
  }) async {
    // Default to 9 AM if no preference
    final checkInTime =
        preferredTime ??
        DateTime.now()
            .add(const Duration(days: 1))
            .copyWith(hour: 9, minute: 0, second: 0, millisecond: 0);

    final messages = [
      'Good morning! How are you feeling today?',
      'Your AI health assistant is here. Any health concerns to discuss?',
      'Time for your daily health check-in. What\'s on your mind?',
      'How has your health been since our last conversation?',
      'Ready to chat about your health and wellness?',
    ];

    final randomMessage =
        messages[DateTime.now().millisecond % messages.length];

    await scheduleHealthCheckIn(
      scheduledTime: checkInTime,
      customMessage: randomMessage,
    );
  }

  // Schedule notifications based on health insights
  static Future<void> scheduleInsightBasedNotifications({
    required List<String> healthTrends,
    required Map<String, dynamic> userPreferences,
  }) async {
    final now = DateTime.now();

    // Schedule trend-based insights
    for (int i = 0; i < healthTrends.length; i++) {
      final trend = healthTrends[i];
      final scheduledTime = now.add(Duration(hours: 2 + i));

      await scheduleHealthInsight(
        title: 'Health Trend Alert',
        body:
            'We noticed a pattern in your $trend. Let\'s discuss what this means.',
        scheduledTime: scheduledTime,
        data: {'trend': trend, 'priority': 'medium'},
      );
    }
  }
}

// Provider for proactive notification service
final proactiveNotificationServiceProvider =
    Provider<ProactiveNotificationService>((ref) {
      return ProactiveNotificationService();
    });
