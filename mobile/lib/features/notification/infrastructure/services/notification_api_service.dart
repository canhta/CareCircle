import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/api_requests.dart';
import '../../domain/models/api_responses.dart';

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
  Future<NotificationResponse> createNotification(
    @Body() CreateNotificationRequest request,
  );

  @GET('/notifications')
  Future<NotificationListResponse> getNotifications(
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET('/notifications/summary')
  Future<NotificationSummaryResponse> getNotificationSummary();

  @GET('/notifications/unread')
  Future<NotificationListResponse> getUnreadNotifications();

  @GET('/notifications/type/{type}')
  Future<NotificationListResponse> getNotificationsByType(
    @Path('type') String type,
  );

  @GET('/notifications/priority/{priority}')
  Future<NotificationListResponse> getNotificationsByPriority(
    @Path('priority') String priority,
  );

  @GET('/notifications/{id}')
  Future<NotificationResponse> getNotification(@Path('id') String id);

  @PUT('/notifications/{id}/read')
  Future<NotificationResponse> markAsRead(@Path('id') String id);

  @PUT('/notifications/{id}/unread')
  Future<NotificationResponse> markAsUnread(@Path('id') String id);

  @DELETE('/notifications/{id}')
  Future<NotificationResponse> deleteNotification(@Path('id') String id);

  @POST('/notifications/mark-all-read')
  Future<NotificationListResponse> markAllAsRead();

  @DELETE('/notifications/clear-all')
  Future<NotificationListResponse> clearAllNotifications();

  // Healthcare-specific notification endpoints
  @POST('/notifications/health-alert')
  Future<NotificationResponse> createHealthAlert(
    @Body() Map<String, dynamic> request,
  );

  @POST('/notifications/medication-reminder')
  Future<NotificationResponse> createMedicationReminder(
    @Body() Map<String, dynamic> request,
  );

  // Notification Preferences Operations
  @GET('/notification-preferences')
  Future<NotificationPreferencesResponse> getNotificationPreferences();

  @PUT('/notification-preferences')
  Future<NotificationPreferencesResponse> updateNotificationPreferences(
    @Body() UpdateNotificationPreferencesRequest request,
  );

  @PUT('/notification-preferences/{contextType}/{channel}')
  Future<NotificationPreferencesResponse> updateSpecificPreference(
    @Path('contextType') String contextType,
    @Path('channel') String channel,
    @Body() UpdatePreferenceRequest request,
  );

  @POST('/notification-preferences/reset')
  Future<NotificationPreferencesResponse> resetPreferencesToDefault();

  // Emergency Contact Operations
  @GET('/emergency-contacts')
  Future<EmergencyContactListResponse> getEmergencyContacts();

  @POST('/emergency-contacts')
  Future<EmergencyContactResponse> createEmergencyContact(
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-contacts/{id}')
  Future<EmergencyContactResponse> updateEmergencyContact(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @DELETE('/emergency-contacts/{id}')
  Future<EmergencyContactResponse> deleteEmergencyContact(
    @Path('id') String id,
  );

  // Emergency Alert Operations
  @GET('/emergency-alerts')
  Future<EmergencyAlertListResponse> getEmergencyAlerts(
    @Query('status') String? status,
    @Query('severity') String? severity,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET('/emergency-alerts/{id}')
  Future<EmergencyAlertResponse> getEmergencyAlert(@Path('id') String id);

  @POST('/emergency-alerts')
  Future<EmergencyAlertResponse> createEmergencyAlert(
    @Body() CreateEmergencyAlertRequest request,
  );

  @PUT('/emergency-alerts/{id}/acknowledge')
  Future<EmergencyAlertResponse> acknowledgeEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-alerts/{id}/resolve')
  Future<EmergencyAlertResponse> resolveEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @PUT('/emergency-alerts/{id}/escalate')
  Future<EmergencyAlertResponse> escalateEmergencyAlert(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @POST('/emergency-alerts/{id}/action')
  Future<EmergencyAlertResponse> performEmergencyAlertAction(
    @Path('id') String id,
    @Body() EmergencyAlertActionRequest request,
  );

  // Template Operations
  @GET('/notification-templates')
  Future<NotificationTemplateListResponse> getNotificationTemplates(
    @Query('type') String? type,
    @Query('channel') String? channel,
    @Query('active') bool? active,
  );

  @GET('/notification-templates/{id}')
  Future<NotificationTemplateResponse> getNotificationTemplate(
    @Path('id') String id,
  );

  @POST('/notification-templates')
  Future<NotificationTemplateResponse> createNotificationTemplate(
    @Body() CreateTemplateRequest request,
  );

  @PUT('/notification-templates/{id}')
  Future<NotificationTemplateResponse> updateNotificationTemplate(
    @Path('id') String id,
    @Body() UpdateTemplateRequest request,
  );

  @DELETE('/notification-templates/{id}')
  Future<NotificationTemplateResponse> deleteNotificationTemplate(
    @Path('id') String id,
  );

  @POST('/notification-templates/{id}/render')
  Future<RenderedTemplateResponse> renderTemplate(
    @Path('id') String id,
    @Body() RenderTemplateRequest request,
  );

  // FCM Token Management
  @POST('/fcm/register-token')
  Future<GenericResponse> registerFcmToken(@Body() Map<String, String> request);

  @DELETE('/fcm/unregister-token')
  Future<GenericResponse> unregisterFcmToken(
    @Body() Map<String, String> request,
  );

  @PUT('/fcm/update-token')
  Future<GenericResponse> updateFcmToken(@Body() Map<String, String> request);

  // Notification Interaction Tracking
  @POST('/notifications/{id}/interactions')
  Future<GenericResponse> trackNotificationInteraction(
    @Path('id') String notificationId,
    @Body() Map<String, dynamic> request,
  );

  @GET('/notifications/{id}/interactions')
  Future<GenericResponse> getNotificationInteractions(
    @Path('id') String notificationId,
  );

  // Notification Statistics
  @GET('/notifications/stats/summary')
  Future<GenericResponse> getNotificationStats(
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @GET('/notifications/stats/delivery')
  Future<GenericResponse> getDeliveryStats(
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  // Batch Operations
  @POST('/notifications/batch/mark-read')
  Future<NotificationListResponse> batchMarkAsRead(
    @Body() Map<String, List<String>> request,
  );

  @POST('/notifications/batch/delete')
  Future<NotificationListResponse> batchDeleteNotifications(
    @Body() Map<String, List<String>> request,
  );

  // Test Notification (for development/testing)
  @POST('/notifications/test')
  Future<NotificationResponse> sendTestNotification(
    @Body() Map<String, dynamic> request,
  );
}
