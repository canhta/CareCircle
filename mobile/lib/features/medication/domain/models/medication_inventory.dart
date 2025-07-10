// Medication inventory models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_inventory.freezed.dart';
part 'medication_inventory.g.dart';

/// Refill status types (matches backend Prisma enum)
enum RefillStatus {
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('PENDING')
  pending,
  @JsonValue('ORDERED')
  ordered,
  @JsonValue('DELAYED')
  delayed,
  @JsonValue('UNAVAILABLE')
  unavailable,
}

/// Extension for RefillStatus display names and colors
extension RefillStatusExtension on RefillStatus {
  String get displayName {
    switch (this) {
      case RefillStatus.available:
        return 'Available';
      case RefillStatus.pending:
        return 'Pending';
      case RefillStatus.ordered:
        return 'Ordered';
      case RefillStatus.delayed:
        return 'Delayed';
      case RefillStatus.unavailable:
        return 'Unavailable';
    }
  }

  String get icon {
    switch (this) {
      case RefillStatus.available:
        return '✅';
      case RefillStatus.pending:
        return '⏳';
      case RefillStatus.ordered:
        return '📦';
      case RefillStatus.delayed:
        return '⚠️';
      case RefillStatus.unavailable:
        return '❌';
    }
  }

  String get colorHex {
    switch (this) {
      case RefillStatus.available:
        return '#4CAF50'; // Green
      case RefillStatus.pending:
        return '#FF9800'; // Orange
      case RefillStatus.ordered:
        return '#2196F3'; // Blue
      case RefillStatus.delayed:
        return '#FF5722'; // Deep Orange
      case RefillStatus.unavailable:
        return '#F44336'; // Red
    }
  }
}

/// Main medication inventory entity
@freezed
abstract class MedicationInventory with _$MedicationInventory {
  const factory MedicationInventory({
    required String id,
    required String medicationId,
    required String userId,
    required double currentQuantity,
    required String unit,
    required double reorderThreshold,
    required double reorderAmount,
    DateTime? expirationDate,
    String? location,
    String? batchNumber,
    DateTime? purchaseDate,
    double? cost,
    RefillStatus? refillStatus,
    required DateTime lastUpdated,
    required DateTime createdAt,
  }) = _MedicationInventory;

  factory MedicationInventory.fromJson(Map<String, dynamic> json) =>
      _$MedicationInventoryFromJson(json);
}

/// Medication inventory creation request DTO
@freezed
abstract class CreateInventoryRequest with _$CreateInventoryRequest {
  const factory CreateInventoryRequest({
    required String medicationId,
    required double currentQuantity,
    required String unit,
    required double reorderThreshold,
    required double reorderAmount,
    DateTime? expirationDate,
    String? location,
    String? batchNumber,
    DateTime? purchaseDate,
    double? cost,
    RefillStatus? refillStatus,
  }) = _CreateInventoryRequest;

  factory CreateInventoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInventoryRequestFromJson(json);
}

/// Medication inventory update request DTO
@freezed
abstract class UpdateInventoryRequest with _$UpdateInventoryRequest {
  const factory UpdateInventoryRequest({
    double? currentQuantity,
    String? unit,
    double? reorderThreshold,
    double? reorderAmount,
    DateTime? expirationDate,
    String? location,
    String? batchNumber,
    DateTime? purchaseDate,
    double? cost,
    RefillStatus? refillStatus,
  }) = _UpdateInventoryRequest;

  factory UpdateInventoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateInventoryRequestFromJson(json);
}

/// Inventory adjustment request DTO
@freezed
abstract class InventoryAdjustmentRequest with _$InventoryAdjustmentRequest {
  const factory InventoryAdjustmentRequest({
    required double adjustment,
    required String reason,
    String? notes,
  }) = _InventoryAdjustmentRequest;

  factory InventoryAdjustmentRequest.fromJson(Map<String, dynamic> json) =>
      _$InventoryAdjustmentRequestFromJson(json);
}

/// Inventory alert types
enum InventoryAlertType {
  @JsonValue('LOW_STOCK')
  lowStock,
  @JsonValue('EXPIRING_SOON')
  expiringSoon,
  @JsonValue('EXPIRED')
  expired,
  @JsonValue('REORDER_NEEDED')
  reorderNeeded,
}

/// Inventory alert model
@freezed
abstract class InventoryAlert with _$InventoryAlert {
  const factory InventoryAlert({
    required String id,
    required String inventoryId,
    required String medicationId,
    required InventoryAlertType alertType,
    required String message,
    required DateTime alertDate,
    @Default(false) bool isRead,
    @Default(false) bool isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
  }) = _InventoryAlert;

  factory InventoryAlert.fromJson(Map<String, dynamic> json) =>
      _$InventoryAlertFromJson(json);
}

/// Inventory statistics DTO
@freezed
abstract class InventoryStatistics with _$InventoryStatistics {
  const factory InventoryStatistics({
    required int totalItems,
    required int lowStockItems,
    required int expiredItems,
    required int expiringSoonItems,
    required double totalValue,
    required Map<String, int> itemsByLocation,
    required Map<RefillStatus, int> itemsByRefillStatus,
    required int reorderNeededCount,
  }) = _InventoryStatistics;

  factory InventoryStatistics.fromJson(Map<String, dynamic> json) =>
      _$InventoryStatisticsFromJson(json);
}

/// API response wrapper for inventory operations
@freezed
abstract class InventoryResponse with _$InventoryResponse {
  const factory InventoryResponse({
    required bool success,
    MedicationInventory? data,
    String? message,
    String? error,
  }) = _InventoryResponse;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryResponseFromJson(json);
}

/// API response wrapper for inventory list operations
@freezed
abstract class InventoryListResponse with _$InventoryListResponse {
  const factory InventoryListResponse({
    required bool success,
    @Default([]) List<MedicationInventory> data,
    int? count,
    int? total,
    String? message,
    String? error,
  }) = _InventoryListResponse;

  factory InventoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryListResponseFromJson(json);
}

/// Inventory query parameters DTO
@freezed
abstract class InventoryQueryParams with _$InventoryQueryParams {
  const factory InventoryQueryParams({
    String? medicationId,
    String? location,
    RefillStatus? refillStatus,
    bool? lowStock,
    bool? expiringSoon,
    bool? expired,
    DateTime? expirationDateFrom,
    DateTime? expirationDateTo,
    @Default(50) int limit,
    @Default(0) int offset,
    @Default('lastUpdated') String sortBy,
    @Default('desc') String sortOrder,
  }) = _InventoryQueryParams;

  factory InventoryQueryParams.fromJson(Map<String, dynamic> json) =>
      _$InventoryQueryParamsFromJson(json);
}
