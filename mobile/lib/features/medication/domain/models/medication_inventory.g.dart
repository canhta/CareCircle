// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationInventory _$MedicationInventoryFromJson(Map<String, dynamic> json) =>
    _MedicationInventory(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      userId: json['userId'] as String,
      currentQuantity: (json['currentQuantity'] as num).toDouble(),
      unit: json['unit'] as String,
      reorderThreshold: (json['reorderThreshold'] as num).toDouble(),
      reorderAmount: (json['reorderAmount'] as num).toDouble(),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      location: json['location'] as String?,
      batchNumber: json['batchNumber'] as String?,
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      cost: (json['cost'] as num?)?.toDouble(),
      refillStatus: $enumDecodeNullable(
        _$RefillStatusEnumMap,
        json['refillStatus'],
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MedicationInventoryToJson(
  _MedicationInventory instance,
) => <String, dynamic>{
  'id': instance.id,
  'medicationId': instance.medicationId,
  'userId': instance.userId,
  'currentQuantity': instance.currentQuantity,
  'unit': instance.unit,
  'reorderThreshold': instance.reorderThreshold,
  'reorderAmount': instance.reorderAmount,
  'expirationDate': instance.expirationDate?.toIso8601String(),
  'location': instance.location,
  'batchNumber': instance.batchNumber,
  'purchaseDate': instance.purchaseDate?.toIso8601String(),
  'cost': instance.cost,
  'refillStatus': _$RefillStatusEnumMap[instance.refillStatus],
  'lastUpdated': instance.lastUpdated.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$RefillStatusEnumMap = {
  RefillStatus.available: 'AVAILABLE',
  RefillStatus.pending: 'PENDING',
  RefillStatus.ordered: 'ORDERED',
  RefillStatus.delayed: 'DELAYED',
  RefillStatus.unavailable: 'UNAVAILABLE',
};

_CreateInventoryRequest _$CreateInventoryRequestFromJson(
  Map<String, dynamic> json,
) => _CreateInventoryRequest(
  medicationId: json['medicationId'] as String,
  currentQuantity: (json['currentQuantity'] as num).toDouble(),
  unit: json['unit'] as String,
  reorderThreshold: (json['reorderThreshold'] as num).toDouble(),
  reorderAmount: (json['reorderAmount'] as num).toDouble(),
  expirationDate: json['expirationDate'] == null
      ? null
      : DateTime.parse(json['expirationDate'] as String),
  location: json['location'] as String?,
  batchNumber: json['batchNumber'] as String?,
  purchaseDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  cost: (json['cost'] as num?)?.toDouble(),
  refillStatus: $enumDecodeNullable(
    _$RefillStatusEnumMap,
    json['refillStatus'],
  ),
);

Map<String, dynamic> _$CreateInventoryRequestToJson(
  _CreateInventoryRequest instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'currentQuantity': instance.currentQuantity,
  'unit': instance.unit,
  'reorderThreshold': instance.reorderThreshold,
  'reorderAmount': instance.reorderAmount,
  'expirationDate': instance.expirationDate?.toIso8601String(),
  'location': instance.location,
  'batchNumber': instance.batchNumber,
  'purchaseDate': instance.purchaseDate?.toIso8601String(),
  'cost': instance.cost,
  'refillStatus': _$RefillStatusEnumMap[instance.refillStatus],
};

_UpdateInventoryRequest _$UpdateInventoryRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateInventoryRequest(
  currentQuantity: (json['currentQuantity'] as num?)?.toDouble(),
  unit: json['unit'] as String?,
  reorderThreshold: (json['reorderThreshold'] as num?)?.toDouble(),
  reorderAmount: (json['reorderAmount'] as num?)?.toDouble(),
  expirationDate: json['expirationDate'] == null
      ? null
      : DateTime.parse(json['expirationDate'] as String),
  location: json['location'] as String?,
  batchNumber: json['batchNumber'] as String?,
  purchaseDate: json['purchaseDate'] == null
      ? null
      : DateTime.parse(json['purchaseDate'] as String),
  cost: (json['cost'] as num?)?.toDouble(),
  refillStatus: $enumDecodeNullable(
    _$RefillStatusEnumMap,
    json['refillStatus'],
  ),
);

Map<String, dynamic> _$UpdateInventoryRequestToJson(
  _UpdateInventoryRequest instance,
) => <String, dynamic>{
  'currentQuantity': instance.currentQuantity,
  'unit': instance.unit,
  'reorderThreshold': instance.reorderThreshold,
  'reorderAmount': instance.reorderAmount,
  'expirationDate': instance.expirationDate?.toIso8601String(),
  'location': instance.location,
  'batchNumber': instance.batchNumber,
  'purchaseDate': instance.purchaseDate?.toIso8601String(),
  'cost': instance.cost,
  'refillStatus': _$RefillStatusEnumMap[instance.refillStatus],
};

_InventoryAdjustmentRequest _$InventoryAdjustmentRequestFromJson(
  Map<String, dynamic> json,
) => _InventoryAdjustmentRequest(
  adjustment: (json['adjustment'] as num).toDouble(),
  reason: json['reason'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$InventoryAdjustmentRequestToJson(
  _InventoryAdjustmentRequest instance,
) => <String, dynamic>{
  'adjustment': instance.adjustment,
  'reason': instance.reason,
  'notes': instance.notes,
};

_InventoryAlert _$InventoryAlertFromJson(Map<String, dynamic> json) =>
    _InventoryAlert(
      id: json['id'] as String,
      inventoryId: json['inventoryId'] as String,
      medicationId: json['medicationId'] as String,
      alertType: $enumDecode(_$InventoryAlertTypeEnumMap, json['alertType']),
      message: json['message'] as String,
      alertDate: DateTime.parse(json['alertDate'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isResolved: json['isResolved'] as bool? ?? false,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolvedBy: json['resolvedBy'] as String?,
    );

Map<String, dynamic> _$InventoryAlertToJson(_InventoryAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventoryId': instance.inventoryId,
      'medicationId': instance.medicationId,
      'alertType': _$InventoryAlertTypeEnumMap[instance.alertType]!,
      'message': instance.message,
      'alertDate': instance.alertDate.toIso8601String(),
      'isRead': instance.isRead,
      'isResolved': instance.isResolved,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'resolvedBy': instance.resolvedBy,
    };

const _$InventoryAlertTypeEnumMap = {
  InventoryAlertType.lowStock: 'LOW_STOCK',
  InventoryAlertType.expiringSoon: 'EXPIRING_SOON',
  InventoryAlertType.expired: 'EXPIRED',
  InventoryAlertType.reorderNeeded: 'REORDER_NEEDED',
};

_InventoryStatistics _$InventoryStatisticsFromJson(Map<String, dynamic> json) =>
    _InventoryStatistics(
      totalItems: (json['totalItems'] as num).toInt(),
      lowStockItems: (json['lowStockItems'] as num).toInt(),
      expiredItems: (json['expiredItems'] as num).toInt(),
      expiringSoonItems: (json['expiringSoonItems'] as num).toInt(),
      totalValue: (json['totalValue'] as num).toDouble(),
      itemsByLocation: Map<String, int>.from(json['itemsByLocation'] as Map),
      itemsByRefillStatus: (json['itemsByRefillStatus'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry(
              $enumDecode(_$RefillStatusEnumMap, k),
              (e as num).toInt(),
            ),
          ),
      reorderNeededCount: (json['reorderNeededCount'] as num).toInt(),
    );

Map<String, dynamic> _$InventoryStatisticsToJson(
  _InventoryStatistics instance,
) => <String, dynamic>{
  'totalItems': instance.totalItems,
  'lowStockItems': instance.lowStockItems,
  'expiredItems': instance.expiredItems,
  'expiringSoonItems': instance.expiringSoonItems,
  'totalValue': instance.totalValue,
  'itemsByLocation': instance.itemsByLocation,
  'itemsByRefillStatus': instance.itemsByRefillStatus.map(
    (k, e) => MapEntry(_$RefillStatusEnumMap[k]!, e),
  ),
  'reorderNeededCount': instance.reorderNeededCount,
};

_InventoryResponse _$InventoryResponseFromJson(Map<String, dynamic> json) =>
    _InventoryResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : MedicationInventory.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$InventoryResponseToJson(_InventoryResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
      'error': instance.error,
    };

_InventoryListResponse _$InventoryListResponseFromJson(
  Map<String, dynamic> json,
) => _InventoryListResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MedicationInventory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$InventoryListResponseToJson(
  _InventoryListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'total': instance.total,
  'message': instance.message,
  'error': instance.error,
};
