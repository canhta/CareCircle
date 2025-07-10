import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/models.dart';

part 'medication_inventory_api_service.g.dart';

/// API service for medication inventory management
///
/// Provides endpoints for:
/// - Inventory CRUD operations
/// - Stock level monitoring
/// - Expiration tracking
/// - Reorder management
/// - Inventory alerts and statistics
@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class MedicationInventoryApiService {
  factory MedicationInventoryApiService(Dio dio, {String baseUrl}) =
      _MedicationInventoryApiService;

  // Inventory CRUD Operations
  @GET('/medication-inventory')
  Future<InventoryListResponse> getUserInventory(
    @Query('medicationId') String? medicationId,
    @Query('location') String? location,
    @Query('refillStatus') String? refillStatus,
    @Query('lowStock') bool? lowStock,
    @Query('expiringSoon') bool? expiringSoon,
    @Query('expired') bool? expired,
    @Query('expirationDateFrom') String? expirationDateFrom,
    @Query('expirationDateTo') String? expirationDateTo,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('sortBy') String? sortBy,
    @Query('sortOrder') String? sortOrder,
  );

  @POST('/medication-inventory')
  Future<InventoryResponse> createInventory(
    @Body() CreateInventoryRequest request,
  );

  @GET('/medication-inventory/{id}')
  Future<InventoryResponse> getInventory(@Path('id') String id);

  @PUT('/medication-inventory/{id}')
  Future<InventoryResponse> updateInventory(
    @Path('id') String id,
    @Body() UpdateInventoryRequest request,
  );

  @DELETE('/medication-inventory/{id}')
  Future<InventoryResponse> deleteInventory(@Path('id') String id);

  // Inventory Adjustments
  @POST('/medication-inventory/{id}/adjust')
  Future<InventoryResponse> adjustInventoryQuantity(
    @Path('id') String id,
    @Body() InventoryAdjustmentRequest request,
  );

  @POST('/medication-inventory/{id}/restock')
  Future<InventoryResponse> restockInventory(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @POST('/medication-inventory/{id}/consume')
  Future<InventoryResponse> consumeInventory(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  // Inventory Monitoring
  @GET('/medication-inventory/low-stock')
  Future<InventoryListResponse> getLowStockItems(
    @Query('threshold') double? threshold,
  );

  @GET('/medication-inventory/expiring')
  Future<InventoryListResponse> getExpiringItems(
    @Query('days') int? days,
  );

  @GET('/medication-inventory/expired')
  Future<InventoryListResponse> getExpiredItems();

  @GET('/medication-inventory/reorder-needed')
  Future<InventoryListResponse> getReorderNeededItems();

  // Inventory Alerts
  @GET('/medication-inventory/alerts')
  Future<InventoryListResponse> getInventoryAlerts(
    @Query('alertType') String? alertType,
    @Query('isRead') bool? isRead,
    @Query('isResolved') bool? isResolved,
  );

  @POST('/medication-inventory/alerts/{id}/mark-read')
  Future<InventoryResponse> markAlertAsRead(@Path('id') String id);

  @POST('/medication-inventory/alerts/{id}/resolve')
  Future<InventoryResponse> resolveAlert(@Path('id') String id);

  // Inventory Statistics
  @GET('/medication-inventory/statistics')
  Future<InventoryResponse> getInventoryStatistics(
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @GET('/medication-inventory/value-report')
  Future<InventoryResponse> getInventoryValueReport(
    @Query('groupBy') String? groupBy,
  );

  // Batch Operations
  @POST('/medication-inventory/bulk-create')
  Future<InventoryListResponse> createMultipleInventories(
    @Body() Map<String, List<CreateInventoryRequest>> request,
  );

  @POST('/medication-inventory/bulk-update')
  Future<InventoryListResponse> updateMultipleInventories(
    @Body() Map<String, List<Map<String, dynamic>>> request,
  );

  @POST('/medication-inventory/bulk-adjust')
  Future<InventoryListResponse> bulkAdjustInventories(
    @Body() Map<String, List<InventoryAdjustmentRequest>> request,
  );

  // Location Management
  @GET('/medication-inventory/locations')
  Future<InventoryResponse> getInventoryLocations();

  @GET('/medication-inventory/by-location/{location}')
  Future<InventoryListResponse> getInventoryByLocation(
    @Path('location') String location,
  );

  // Refill Management
  @POST('/medication-inventory/{id}/request-refill')
  Future<InventoryResponse> requestRefill(
    @Path('id') String id,
    @Body() Map<String, dynamic> request,
  );

  @POST('/medication-inventory/{id}/cancel-refill')
  Future<InventoryResponse> cancelRefill(@Path('id') String id);

  @GET('/medication-inventory/refill-status')
  Future<InventoryListResponse> getRefillStatus(
    @Query('status') String? status,
  );

  // Inventory History
  @GET('/medication-inventory/{id}/history')
  Future<InventoryListResponse> getInventoryHistory(
    @Path('id') String id,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @GET('/medication-inventory/recent-activity')
  Future<InventoryListResponse> getRecentInventoryActivity(
    @Query('days') int? days,
    @Query('limit') int? limit,
  );
}
