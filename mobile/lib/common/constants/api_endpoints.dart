import 'package:flutter/foundation.dart';

/// API endpoints and configuration constants
class ApiEndpoints {
  // Private constructor to prevent instantiation
  const ApiEndpoints._();

  /// Base URL for API requests
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kDebugMode
        ? 'http://10.0.2.2:3000/api/v1'
        : 'https://api.carecircle.com/api/v1',
  );

  /// API version
  static const String version = 'v1';

  /// Request timeout in milliseconds
  static const int timeoutMs = 30000;

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String socialLogin = '/auth/social-login';

  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String userPreferences = '/users/preferences';
  static const String userSettings = '/users/settings';
  static const String deleteAccount = '/users/delete-account';

  // Care Group endpoints
  static const String careGroups = '/care-groups';
  static const String createCareGroup = '/care-groups';
  static const String careGroupMembers = '/care-groups/{id}/members';
  static const String joinCareGroup = '/care-groups/{id}/join';
  static const String leaveCareGroup = '/care-groups/{id}/leave';
  static const String careGroupInvitations = '/care-groups/{id}/invitations';
  static const String careGroupSettings = '/care-groups/{id}/settings';

  // Daily Check-in endpoints
  static const String dailyCheckIns = '/daily-check-ins';
  static const String submitCheckIn = '/daily-check-ins';
  static const String checkInHistory = '/daily-check-ins/history';
  static const String checkInStats = '/daily-check-ins/stats';
  static const String checkInQuestions = '/daily-check-ins/questions';

  // Health Records endpoints
  static const String healthRecords = '/health-records';
  static const String healthData = '/health-records/data';
  static const String healthMetrics = '/health-records/metrics';
  static const String healthTrends = '/health-records/trends';
  static const String syncHealthData = '/health-records/sync';

  // Health Data endpoints (specific to device health data)
  static const String healthDataSync = '/health-data/sync';
  static const String healthDataQuery = '/health-data/query';
  static const String healthDataDelete = '/health-data/delete';
  static const String healthSyncStatus = '/health-data/sync-status';

  // Prescription endpoints
  static const String prescriptionScan = '/prescriptions/scan';
  static const String prescriptions = '/prescriptions';
  static const String prescription = '/prescriptions/{id}';
  static const String patientPrescriptions =
      '/prescriptions/patient/{patientId}';
  static const String activePrescriptions = '/prescriptions/active';
  static const String expiringSoonPrescriptions =
      '/prescriptions/expiring-soon';
  static const String markPrescriptionCompleted =
      '/prescriptions/{id}/complete';
  static const String markPrescriptionCancelled = '/prescriptions/{id}/cancel';
  static const String uploadPrescriptionImage = '/prescriptions/upload-image';
  static const String prescriptionStats = '/prescriptions/stats';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String markNotificationAsRead = '/notifications/{id}/mark-read';
  static const String markAllNotificationsAsRead =
      '/notifications/mark-all-read';
  static const String unreadNotificationsCount = '/notifications/unread-count';
  static const String notificationPreferences = '/notifications/preferences';
  static const String notificationResponse = '/notifications/{id}/respond';
  static const String trackNotificationOpened =
      '/notifications/{id}/track-opened';
  static const String trackNotificationClicked =
      '/notifications/{id}/track-clicked';
  static const String deleteNotification = '/notifications/{id}';
  static const String deleteAllNotifications = '/notifications/delete-all';
  static const String notificationDeliveryStats =
      '/notifications/my-delivery-stats';

  // Test notification endpoints
  static const String testMedicationReminder =
      '/notifications/test/medication-reminder';
  static const String testCheckInReminder =
      '/notifications/test/check-in-reminder';
  static const String testHealthInsight = '/notifications/test/health-insight';

  // Insights endpoints
  static const String insights = '/insights';
  static const String healthInsights = '/insights/health';
  static const String careGroupInsights = '/insights/care-groups';
  static const String personalizedInsights = '/insights/personalized';

  // Subscription endpoints
  static const String subscriptionPlans = '/subscriptions/plans';
  static const String userSubscription = '/subscriptions/current';
  static const String subscribeToplan = '/subscriptions/subscribe';
  static const String cancelSubscription = '/subscriptions/cancel';
  static const String updateAutoRenewal = '/subscriptions/auto-renewal';
  static const String subscriptionUsage = '/subscriptions/usage';
  static const String paymentHistory = '/subscriptions/payment-history';
  static const String restorePurchases = '/subscriptions/restore-purchases';
  static const String verifyPurchase = '/subscriptions/verify-purchase';
  static const String subscriptionFeatures = '/subscriptions/features/{planId}';
  static const String checkFeatureAvailability =
      '/subscriptions/features/check/{featureId}';
  static const String subscriptionAnalytics = '/subscriptions/analytics';

  // File upload endpoints
  static const String uploadFile = '/files/upload';
  static const String uploadImage = '/files/upload/image';
  static const String uploadDocument = '/files/upload/document';

  // Privacy and consent endpoints
  static const String consentSettings = '/privacy/consent-settings';
  static const String consentHistory = '/privacy/consent-history';
  static const String accessLog = '/privacy/access-log';
  static const String dataExport = '/privacy/data-export';
  static const String accountDeletion = '/privacy/account-deletion';

  // Utility methods

  /// Build full URL with base URL
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }

  /// Replace path parameters in endpoint
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  /// Build paginated endpoint
  static String buildPaginatedUrl(
    String endpoint, {
    int page = 1,
    int limit = 20,
    Map<String, String>? additionalParams,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (additionalParams != null) {
      params.addAll(additionalParams);
    }

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$endpoint?$queryString';
  }
}
