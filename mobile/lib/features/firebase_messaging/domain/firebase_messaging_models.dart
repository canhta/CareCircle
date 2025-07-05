import 'package:firebase_messaging/firebase_messaging.dart';

/// Domain models for Firebase Messaging
class NotificationMessage {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final DateTime? sentTime;
  final String? imageUrl;
  final String? sound;
  final String? category;
  final String? threadId;
  final int? badge;
  final String? channelId;
  final String? tag;
  final String? color;
  final String? clickAction;
  final String? collapseKey;
  final String priority;
  final DateTime receivedTime;

  const NotificationMessage({
    this.messageId,
    this.title,
    this.body,
    this.data,
    this.sentTime,
    this.imageUrl,
    this.sound,
    this.category,
    this.threadId,
    this.badge,
    this.channelId,
    this.tag,
    this.color,
    this.clickAction,
    this.collapseKey,
    this.priority = 'normal',
    required this.receivedTime,
  });

  factory NotificationMessage.fromRemoteMessage(RemoteMessage message) {
    return NotificationMessage(
      messageId: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      sentTime: message.sentTime,
      imageUrl: message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      sound: message.notification?.android?.sound ??
          message.notification?.apple?.sound?.name,
      category: message.category,
      threadId: message.threadId,
      badge: int.tryParse(message.notification?.apple?.badge ?? '0'),
      channelId: message.notification?.android?.channelId,
      tag: message.notification?.android?.tag,
      color: message.notification?.android?.color,
      clickAction: message.notification?.android?.clickAction,
      collapseKey: message.collapseKey,
      priority: 'normal', // Default priority as string
      receivedTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'title': title,
      'body': body,
      'data': data,
      'sentTime': sentTime?.toIso8601String(),
      'imageUrl': imageUrl,
      'sound': sound,
      'category': category,
      'threadId': threadId,
      'badge': badge,
      'channelId': channelId,
      'tag': tag,
      'color': color,
      'clickAction': clickAction,
      'collapseKey': collapseKey,
      'priority': priority,
      'receivedTime': receivedTime.toIso8601String(),
    };
  }
}

/// Device information for messaging
class MessagingDeviceInfo {
  final String platform;
  final String? deviceId;
  final String? model;
  final String? osVersion;
  final String? appVersion;
  final String? locale;
  final String? timezone;

  const MessagingDeviceInfo({
    required this.platform,
    this.deviceId,
    this.model,
    this.osVersion,
    this.appVersion,
    this.locale,
    this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'deviceId': deviceId,
      'model': model,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'locale': locale,
      'timezone': timezone,
    };
  }
}

/// Notification permission status
enum NotificationPermissionStatus {
  granted,
  denied,
  notDetermined,
  provisional,
}

/// Messaging configuration
class MessagingConfig {
  final bool enableAutoInit;
  final bool enableLocalNotifications;
  final int maxRetries;
  final Duration retryDelay;
  final List<String> defaultTopics;
  final bool enableAnalytics;

  const MessagingConfig({
    this.enableAutoInit = true,
    this.enableLocalNotifications = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.defaultTopics = const [],
    this.enableAnalytics = true,
  });
}

/// Message interaction tracking
class MessageInteraction {
  final String messageId;
  final String interactionType;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  const MessageInteraction({
    required this.messageId,
    required this.interactionType,
    required this.timestamp,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'interactionType': interactionType,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }
}

/// Messaging result wrapper
class MessagingResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final Exception? exception;

  const MessagingResult.success(this.data)
      : success = true,
        error = null,
        exception = null;

  const MessagingResult.failure(this.error, [this.exception])
      : success = false,
        data = null;

  bool get isSuccess => success;
  bool get isFailure => !success;
}
