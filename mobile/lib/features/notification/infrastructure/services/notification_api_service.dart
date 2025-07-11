import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/models.dart' as notification_models;

part 'notification_api_service.g.dart';

/// API service for notification operations
///
/// Provides endpoints for:
/// - Notification CRUD operations
/// - Notification preferences management
/// - Emergency alert operations
/// - Template management
/// - FCM token management
@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio, {String baseUrl}) =
      _NotificationApiService;

  // Notification CRUD Operations
  @POST('/notifications')
  Future<notification_models.NotificationResponse> createNotification(
    @Body() notification_models.CreateNotificationRequest request,
  );

  @GET('/notifications')
  Future<notification_models.NotificationListResponse> getNotifications(
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET('/notifications/summary')
  Future<notification_models.NotificationSummaryResponse> getNotificationSummary();

  @GET('/notifications/unread')
  Future<notification_models.NotificationListResponse> getUnreadNotifications();

  @GET('/notifications/type/{type}')
  Future<notification_models.NotificationListResponse> getNotificationsByType(
    @Path('type') String type,
  );

  @GET('/notifications/priority/{priority}')
  Future<notification_models.NotificationListResponse> getNotificationsByPriority(
    @Path('priority') String priority,
  );

  @GET('/notifications/{id}')
  Future<notification_models.NotificationResponse> getNotification(@Path('id') String id);

  @PUT('/notifications/{id}/read')
  Future<notification_models.NotificationResponse> markAsRead(@Path('id') String id);

  @PUT('/notifications/{id}/unread')
  Future<notification_models.NotificationResponse> markAsUnread(@Path('id') String id);

  @DELETE('/notifications/{id}')
  Future<notification_models.NotificationResponse> deleteNotification(@Path('id') String id);

  @POST('/notifications/mark-all-read')
  Future<notification_models.NotificationListResponse> markAllAsRead();

  @DELETE('/notifications/clear-all')
  Future<notification_models.NotificationListResponse> clearAllNotifications();

  // Healthcare-specific notification endpoints
  @POST('/notifications/health-alert')
  Future<notification_models.NotificationResponse> createHealthAlert(
    @Body() Map<String, dynamic> request,
  );

  @POST('/notifications/medication-reminder')
  Future<notification_models.NotificationResponse> createMedicationReminder(
    @Body() Map<String, dynamic> request,
  );



  // Notification Preferences Operations
  @GET('/notification-preferences')
  Future<notification_models.NotificationPreferencesResponse> getNotificationPreferences();

  @PUT('/notification-preferences')
  Future<notification_models.NotificationPreferencesResponse> updateNotificationPreferences(
    @Body() notification_models.UpdateNotificationPreferencesRequest request,
  );

  @PUT('/notification-preferences/{contextType}/{channel}')
  Future<notification_models.NotificationPreferencesResponse> updateSpecificPreference(
    @Path('contextType') String contextType,
    @Path('channel') String channel,
    @Body() notification_models.UpdatePreferenceRequest request,
  );

  @POST('/notification-preferences/reset')
  Future<notification_models.NotificationPreferencesResponse> resetPreferencesToDefault();

  // Emergency Contact Operations
  @GET('/emergency-contacts')
  Future<notification_models.EmergencyContactListResponse> getEmergencyContacts();

  @POST('/emergency-contacts')
  Future<notification_models.EmergencyContactResponse> createEmergencyContact(
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-contacts/{id}')
  Future<notification_models.EmergencyContactResponse> updateEmergencyContact(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @DELETE('/emergency-contacts/{id}')
  Future<notification_models.EmergencyContactResponse> deleteEmergencyContact(
    @Path('id') String id,
  );

  // Emergency Alert Operations
  @GET('/emergency-alerts')
  Future<notification_models.EmergencyAlertListResponse> getEmergencyAlerts(
    @Query('status') String? status,
    @Query('severity') String? severity,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET('/emergency-alerts/{id}')
  Future<notification_models.EmergencyAlertResponse> getEmergencyAlert(@Path('id') String id);

  @POST('/emergency-alerts')
  Future<notification_models.EmergencyAlertResponse> createEmergencyAlert(
    @Body() notification_models.CreateEmergencyAlertRequest request,
  );

  @PUT('/emergency-alerts/{id}/acknowledge')
  Future<notification_models.EmergencyAlertResponse> acknowledgeEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-alerts/{id}/resolve')
  Future<notification_models.EmergencyAlertResponse> resolveEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-alerts/{id}/escalate')
  Future<notification_models.EmergencyAlertResponse> escalateEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @POST('/emergency-alerts/{id}/action')
  Future<notification_models.EmergencyAlertResponse> performEmergencyAlertAction(
    @Path('id') String id,
    @Body() notification_models.EmergencyAlertActionRequest request,
  );

  // Template Operations
  @GET('/notification-templates')
  Future<notification_models.NotificationTemplateListResponse> getNotificationTemplates(
    @Query('type') String? type,
    @Query('channel') String? channel,
    @Query('active') bool? active,
  );

  @GET('/notification-templates/{id}')
  Future<notification_models.NotificationTemplateResponse> getNotificationTemplate(
    @Path('id') String id,
  );

  @POST('/notification-templates')
  Future<notification_models.NotificationTemplateResponse> createNotificationTemplate(
    @Body() notification_models.CreateTemplateRequest request,
  );

  @PUT('/notification-templates/{id}')
  Future<notification_models.NotificationTemplateResponse> updateNotificationTemplate(
    @Path('id') String id,
    @Body() notification_models.UpdateTemplateRequest request,
  );

  @DELETE('/notification-templates/{id}')
  Future<notification_models.NotificationTemplateResponse> deleteNotificationTemplate(
    @Path('id') String id,
  );

  @POST('/notification-templates/{id}/render')
  Future<notification_models.RenderedTemplateResponse> renderTemplate(
    @Path('id') String id,
    @Body() notification_models.RenderTemplateRequest request,
  );

  // FCM Token Management
  @POST('/fcm/register-token')
  Future<Map<String, dynamic>> registerFcmToken(
    @Body() Map<String, String> request,
  );

  @DELETE('/fcm/unregister-token')
  Future<Map<String, dynamic>> unregisterFcmToken(
    @Body() Map<String, String> request,
  );

  @PUT('/fcm/update-token')
  Future<Map<String, dynamic>> updateFcmToken(
    @Body() Map<String, String> request,
  );

  // Notification Interaction Tracking
  @POST('/notifications/{id}/interactions')
  Future<Map<String, dynamic>> trackNotificationInteraction(
    @Path('id') String notificationId,
    @Body() Map<String, dynamic> request,
  );

  @GET('/notifications/{id}/interactions')
  Future<Map<String, dynamic>> getNotificationInteractions(
    @Path('id') String notificationId,
  );

  // Notification Statistics
  @GET('/notifications/stats/summary')
  Future<Map<String, dynamic>> getNotificationStats(
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @GET('/notifications/stats/delivery')
  Future<Map<String, dynamic>> getDeliveryStats(
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  // Batch Operations
  @POST('/notifications/batch/mark-read')
  Future<notification_models.NotificationListResponse> batchMarkAsRead(
    @Body() Map<String, List<String>> request,
  );

  @POST('/notifications/batch/delete')
  Future<notification_models.NotificationListResponse> batchDeleteNotifications(
    @Body() Map<String, List<String>> request,
  );

  // Test Notification (for development/testing)
  @POST('/notifications/test')
  Future<notification_models.NotificationResponse> sendTestNotification(
    @Body() Map<String, dynamic> request,
  );
}
