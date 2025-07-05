/// Domain models for Firebase API service
class TokenRegistration {
  final String token;
  final String deviceId;
  final String platform;
  final String? appVersion;
  final String? locale;
  final String? timezone;
  final bool isActive;
  final DateTime registrationDate;
  final DateTime? lastUsed;

  const TokenRegistration({
    required this.token,
    required this.deviceId,
    required this.platform,
    this.appVersion,
    this.locale,
    this.timezone,
    this.isActive = true,
    required this.registrationDate,
    this.lastUsed,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceId': deviceId,
      'platform': platform,
      'appVersion': appVersion,
      'locale': locale,
      'timezone': timezone,
      'isActive': isActive,
      'registrationDate': registrationDate.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  factory TokenRegistration.fromJson(Map<String, dynamic> json) {
    return TokenRegistration(
      token: json['token'] as String,
      deviceId: json['deviceId'] as String,
      platform: json['platform'] as String,
      appVersion: json['appVersion'] as String?,
      locale: json['locale'] as String?,
      timezone: json['timezone'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
    );
  }
}

/// Result for token registration operation
class TokenRegistrationResult {
  final bool success;
  final String? error;
  final String? message;
  final TokenRegistration? registration;

  const TokenRegistrationResult({
    required this.success,
    this.error,
    this.message,
    this.registration,
  });

  factory TokenRegistrationResult.success({
    String? message,
    TokenRegistration? registration,
  }) {
    return TokenRegistrationResult(
      success: true,
      message: message,
      registration: registration,
    );
  }

  factory TokenRegistrationResult.failure(String error) {
    return TokenRegistrationResult(
      success: false,
      error: error,
    );
  }
}

/// Topic subscription information
class TopicSubscription {
  final String topic;
  final bool isSubscribed;
  final DateTime? subscribedAt;
  final DateTime? unsubscribedAt;

  const TopicSubscription({
    required this.topic,
    required this.isSubscribed,
    this.subscribedAt,
    this.unsubscribedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'isSubscribed': isSubscribed,
      'subscribedAt': subscribedAt?.toIso8601String(),
      'unsubscribedAt': unsubscribedAt?.toIso8601String(),
    };
  }

  factory TopicSubscription.fromJson(Map<String, dynamic> json) {
    return TopicSubscription(
      topic: json['topic'] as String,
      isSubscribed: json['isSubscribed'] as bool,
      subscribedAt: json['subscribedAt'] != null
          ? DateTime.parse(json['subscribedAt'] as String)
          : null,
      unsubscribedAt: json['unsubscribedAt'] != null
          ? DateTime.parse(json['unsubscribedAt'] as String)
          : null,
    );
  }
}

/// Result for topic subscription operation
class TopicSubscriptionResult {
  final bool success;
  final String? error;
  final String? message;
  final TopicSubscription? subscription;

  const TopicSubscriptionResult({
    required this.success,
    this.error,
    this.message,
    this.subscription,
  });

  factory TopicSubscriptionResult.success({
    String? message,
    TopicSubscription? subscription,
  }) {
    return TopicSubscriptionResult(
      success: true,
      message: message,
      subscription: subscription,
    );
  }

  factory TopicSubscriptionResult.failure(String error) {
    return TopicSubscriptionResult(
      success: false,
      error: error,
    );
  }
}

/// Test notification configuration
class TestNotification {
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? channelId;
  final List<String>? targetTokens;
  final List<String>? targetTopics;

  const TestNotification({
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.channelId,
    this.targetTokens,
    this.targetTopics,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'data': data,
      'imageUrl': imageUrl,
      'channelId': channelId,
      'targetTokens': targetTokens,
      'targetTopics': targetTopics,
    };
  }
}

/// Result for test notification
class TestNotificationResult {
  final bool success;
  final String? error;
  final String? message;
  final int? recipientCount;
  final String? notificationId;

  const TestNotificationResult({
    required this.success,
    this.error,
    this.message,
    this.recipientCount,
    this.notificationId,
  });

  factory TestNotificationResult.success({
    String? message,
    int? recipientCount,
    String? notificationId,
  }) {
    return TestNotificationResult(
      success: true,
      message: message,
      recipientCount: recipientCount,
      notificationId: notificationId,
    );
  }

  factory TestNotificationResult.failure(String error) {
    return TestNotificationResult(
      success: false,
      error: error,
    );
  }
}

/// Token cleanup information
class CleanupResult {
  final bool success;
  final String? error;
  final int? cleanedTokensCount;
  final List<String>? cleanedTokens;

  const CleanupResult({
    required this.success,
    this.error,
    this.cleanedTokensCount,
    this.cleanedTokens,
  });

  factory CleanupResult.success({
    int? cleanedTokensCount,
    List<String>? cleanedTokens,
  }) {
    return CleanupResult(
      success: true,
      cleanedTokensCount: cleanedTokensCount,
      cleanedTokens: cleanedTokens,
    );
  }

  factory CleanupResult.failure(String error) {
    return CleanupResult(
      success: false,
      error: error,
    );
  }
}

/// Service health information
class ServiceHealth {
  final bool healthy;
  final String status;
  final DateTime timestamp;
  final Map<String, dynamic>? details;

  const ServiceHealth({
    required this.healthy,
    required this.status,
    required this.timestamp,
    this.details,
  });

  factory ServiceHealth.fromJson(Map<String, dynamic> json) {
    return ServiceHealth(
      healthy: json['healthy'] as bool,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as Map<String, dynamic>?,
    );
  }
}

/// Result for service health check
class ServiceHealthResult {
  final bool success;
  final String? error;
  final ServiceHealth? health;

  const ServiceHealthResult({
    required this.success,
    this.error,
    this.health,
  });

  factory ServiceHealthResult.success(ServiceHealth health) {
    return ServiceHealthResult(
      success: true,
      health: health,
    );
  }

  factory ServiceHealthResult.failure(String error) {
    return ServiceHealthResult(
      success: false,
      error: error,
    );
  }
}

/// Enhanced device information
class DeviceInfo {
  final String deviceId;
  final String platform;
  final String? model;
  final String? osVersion;
  final String? appVersion;
  final String? locale;
  final String? timezone;
  final Map<String, dynamic>? additionalInfo;

  const DeviceInfo({
    required this.deviceId,
    required this.platform,
    this.model,
    this.osVersion,
    this.appVersion,
    this.locale,
    this.timezone,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'platform': platform,
      'model': model,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'locale': locale,
      'timezone': timezone,
      'additionalInfo': additionalInfo,
    };
  }
}
