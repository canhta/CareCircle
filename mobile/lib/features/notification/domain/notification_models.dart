/// Domain models for notification feature
enum NotificationType {
  medicationReminder,
  checkInReminder,
  healthInsight,
  careGroupUpdate,
  systemAlert,
  appointmentReminder,
  emergencyAlert,
  aiRecommendation,
  socialUpdate,
  achievementUnlocked,
}

enum NotificationChannel {
  push,
  email,
  sms,
  inApp,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final List<NotificationChannel> channels;
  final NotificationPriority priority;
  final String? actionUrl;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final bool isActionable;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.channels,
    required this.priority,
    this.actionUrl,
    required this.createdAt,
    this.sentAt,
    this.readAt,
    this.updatedAt,
    this.metadata,
    this.isActionable = false,
  }) : isRead = readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _parseNotificationType(json['type'] as String),
      channels: (json['channel'] as List<dynamic>?)
              ?.map((e) => _parseNotificationChannel(e as String))
              .toList() ??
          [NotificationChannel.inApp],
      priority: _parseNotificationPriority(json['priority'] as String),
      actionUrl: json['actionUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isActionable: json['isActionable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'channel': channels.map((e) => e.name).toList(),
      'priority': priority.name,
      'actionUrl': actionUrl,
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
      'isActionable': isActionable,
    };
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'medication_reminder':
        return NotificationType.medicationReminder;
      case 'check_in_reminder':
        return NotificationType.checkInReminder;
      case 'health_insight':
        return NotificationType.healthInsight;
      case 'care_group_update':
        return NotificationType.careGroupUpdate;
      case 'system_alert':
        return NotificationType.systemAlert;
      case 'appointment_reminder':
        return NotificationType.appointmentReminder;
      case 'emergency_alert':
        return NotificationType.emergencyAlert;
      case 'ai_recommendation':
        return NotificationType.aiRecommendation;
      case 'social_update':
        return NotificationType.socialUpdate;
      case 'achievement_unlocked':
        return NotificationType.achievementUnlocked;
      default:
        return NotificationType.systemAlert;
    }
  }

  static NotificationChannel _parseNotificationChannel(String channel) {
    switch (channel.toLowerCase()) {
      case 'push':
        return NotificationChannel.push;
      case 'email':
        return NotificationChannel.email;
      case 'sms':
        return NotificationChannel.sms;
      case 'in_app':
        return NotificationChannel.inApp;
      default:
        return NotificationChannel.inApp;
    }
  }

  static NotificationPriority _parseNotificationPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return NotificationPriority.low;
      case 'normal':
        return NotificationPriority.normal;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.normal;
    }
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    List<NotificationChannel>? channels,
    NotificationPriority? priority,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    bool? isActionable,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      channels: channels ?? this.channels,
      priority: priority ?? this.priority,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
      isActionable: isActionable ?? this.isActionable,
    );
  }
}

class NotificationPreferences {
  final bool medicationReminders;
  final bool checkInReminders;
  final bool aiInsights;
  final bool careGroupUpdates;
  final NotificationChannelPreferences channels;
  final QuietHours? quietHours;

  NotificationPreferences({
    required this.medicationReminders,
    required this.checkInReminders,
    required this.aiInsights,
    required this.careGroupUpdates,
    required this.channels,
    this.quietHours,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      medicationReminders: json['medicationReminders'] as bool,
      checkInReminders: json['checkInReminders'] as bool,
      aiInsights: json['aiInsights'] as bool,
      careGroupUpdates: json['careGroupUpdates'] as bool,
      channels: NotificationChannelPreferences.fromJson(
          json['channels'] as Map<String, dynamic>),
      quietHours: json['quietHours'] != null
          ? QuietHours.fromJson(json['quietHours'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationReminders': medicationReminders,
      'checkInReminders': checkInReminders,
      'aiInsights': aiInsights,
      'careGroupUpdates': careGroupUpdates,
      'channels': channels.toJson(),
      'quietHours': quietHours?.toJson(),
    };
  }
}

class NotificationChannelPreferences {
  final bool push;
  final bool email;
  final bool sms;
  final bool inApp;

  NotificationChannelPreferences({
    required this.push,
    required this.email,
    required this.sms,
    required this.inApp,
  });

  factory NotificationChannelPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationChannelPreferences(
      push: json['push'] as bool,
      email: json['email'] as bool,
      sms: json['sms'] as bool,
      inApp: json['inApp'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push': push,
      'email': email,
      'sms': sms,
      'inApp': inApp,
    };
  }
}

class QuietHours {
  final bool enabled;
  final String start;
  final String end;

  QuietHours({
    required this.enabled,
    required this.start,
    required this.end,
  });

  factory QuietHours.fromJson(Map<String, dynamic> json) {
    return QuietHours(
      enabled: json['enabled'] as bool,
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'start': start,
      'end': end,
    };
  }
}

class NotificationResponse {
  final String id;
  final String action;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  NotificationResponse({
    required this.id,
    required this.action,
    this.metadata,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class NotificationPaginatedResponse {
  final List<NotificationModel> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  NotificationPaginatedResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory NotificationPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return NotificationPaginatedResponse(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }
}
