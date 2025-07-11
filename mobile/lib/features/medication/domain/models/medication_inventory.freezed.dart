// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MedicationInventory {

 String get id; String get medicationId; String get userId; double get currentQuantity; String get unit; double get reorderThreshold; double get reorderAmount; DateTime? get expirationDate; String? get location; String? get batchNumber; DateTime? get purchaseDate; double? get cost; RefillStatus? get refillStatus; DateTime get lastUpdated; DateTime get createdAt;
/// Create a copy of MedicationInventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationInventoryCopyWith<MedicationInventory> get copyWith => _$MedicationInventoryCopyWithImpl<MedicationInventory>(this as MedicationInventory, _$identity);

  /// Serializes this MedicationInventory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationInventory&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,userId,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus,lastUpdated,createdAt);

@override
String toString() {
  return 'MedicationInventory(id: $id, medicationId: $medicationId, userId: $userId, currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus, lastUpdated: $lastUpdated, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MedicationInventoryCopyWith<$Res>  {
  factory $MedicationInventoryCopyWith(MedicationInventory value, $Res Function(MedicationInventory) _then) = _$MedicationInventoryCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, String userId, double currentQuantity, String unit, double reorderThreshold, double reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus, DateTime lastUpdated, DateTime createdAt
});




}
/// @nodoc
class _$MedicationInventoryCopyWithImpl<$Res>
    implements $MedicationInventoryCopyWith<$Res> {
  _$MedicationInventoryCopyWithImpl(this._self, this._then);

  final MedicationInventory _self;
  final $Res Function(MedicationInventory) _then;

/// Create a copy of MedicationInventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? userId = null,Object? currentQuantity = null,Object? unit = null,Object? reorderThreshold = null,Object? reorderAmount = null,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,Object? lastUpdated = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,reorderAmount: null == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationInventory].
extension MedicationInventoryPatterns on MedicationInventory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationInventory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationInventory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationInventory value)  $default,){
final _that = this;
switch (_that) {
case _MedicationInventory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationInventory value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationInventory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  String userId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus,  DateTime lastUpdated,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationInventory() when $default != null:
return $default(_that.id,_that.medicationId,_that.userId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus,_that.lastUpdated,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  String userId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus,  DateTime lastUpdated,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationInventory():
return $default(_that.id,_that.medicationId,_that.userId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus,_that.lastUpdated,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  String userId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus,  DateTime lastUpdated,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationInventory() when $default != null:
return $default(_that.id,_that.medicationId,_that.userId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus,_that.lastUpdated,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationInventory implements MedicationInventory {
  const _MedicationInventory({required this.id, required this.medicationId, required this.userId, required this.currentQuantity, required this.unit, required this.reorderThreshold, required this.reorderAmount, this.expirationDate, this.location, this.batchNumber, this.purchaseDate, this.cost, this.refillStatus, required this.lastUpdated, required this.createdAt});
  factory _MedicationInventory.fromJson(Map<String, dynamic> json) => _$MedicationInventoryFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  String userId;
@override final  double currentQuantity;
@override final  String unit;
@override final  double reorderThreshold;
@override final  double reorderAmount;
@override final  DateTime? expirationDate;
@override final  String? location;
@override final  String? batchNumber;
@override final  DateTime? purchaseDate;
@override final  double? cost;
@override final  RefillStatus? refillStatus;
@override final  DateTime lastUpdated;
@override final  DateTime createdAt;

/// Create a copy of MedicationInventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationInventoryCopyWith<_MedicationInventory> get copyWith => __$MedicationInventoryCopyWithImpl<_MedicationInventory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationInventoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationInventory&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,userId,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus,lastUpdated,createdAt);

@override
String toString() {
  return 'MedicationInventory(id: $id, medicationId: $medicationId, userId: $userId, currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus, lastUpdated: $lastUpdated, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationInventoryCopyWith<$Res> implements $MedicationInventoryCopyWith<$Res> {
  factory _$MedicationInventoryCopyWith(_MedicationInventory value, $Res Function(_MedicationInventory) _then) = __$MedicationInventoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, String userId, double currentQuantity, String unit, double reorderThreshold, double reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus, DateTime lastUpdated, DateTime createdAt
});




}
/// @nodoc
class __$MedicationInventoryCopyWithImpl<$Res>
    implements _$MedicationInventoryCopyWith<$Res> {
  __$MedicationInventoryCopyWithImpl(this._self, this._then);

  final _MedicationInventory _self;
  final $Res Function(_MedicationInventory) _then;

/// Create a copy of MedicationInventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? userId = null,Object? currentQuantity = null,Object? unit = null,Object? reorderThreshold = null,Object? reorderAmount = null,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,Object? lastUpdated = null,Object? createdAt = null,}) {
  return _then(_MedicationInventory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,reorderAmount: null == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateInventoryRequest {

 String get medicationId; double get currentQuantity; String get unit; double get reorderThreshold; double get reorderAmount; DateTime? get expirationDate; String? get location; String? get batchNumber; DateTime? get purchaseDate; double? get cost; RefillStatus? get refillStatus;
/// Create a copy of CreateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateInventoryRequestCopyWith<CreateInventoryRequest> get copyWith => _$CreateInventoryRequestCopyWithImpl<CreateInventoryRequest>(this as CreateInventoryRequest, _$identity);

  /// Serializes this CreateInventoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateInventoryRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus);

@override
String toString() {
  return 'CreateInventoryRequest(medicationId: $medicationId, currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus)';
}


}

/// @nodoc
abstract mixin class $CreateInventoryRequestCopyWith<$Res>  {
  factory $CreateInventoryRequestCopyWith(CreateInventoryRequest value, $Res Function(CreateInventoryRequest) _then) = _$CreateInventoryRequestCopyWithImpl;
@useResult
$Res call({
 String medicationId, double currentQuantity, String unit, double reorderThreshold, double reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus
});




}
/// @nodoc
class _$CreateInventoryRequestCopyWithImpl<$Res>
    implements $CreateInventoryRequestCopyWith<$Res> {
  _$CreateInventoryRequestCopyWithImpl(this._self, this._then);

  final CreateInventoryRequest _self;
  final $Res Function(CreateInventoryRequest) _then;

/// Create a copy of CreateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? currentQuantity = null,Object? unit = null,Object? reorderThreshold = null,Object? reorderAmount = null,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,reorderAmount: null == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateInventoryRequest].
extension CreateInventoryRequestPatterns on CreateInventoryRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateInventoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateInventoryRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateInventoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateInventoryRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateInventoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateInventoryRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateInventoryRequest() when $default != null:
return $default(_that.medicationId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)  $default,) {final _that = this;
switch (_that) {
case _CreateInventoryRequest():
return $default(_that.medicationId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  double currentQuantity,  String unit,  double reorderThreshold,  double reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)?  $default,) {final _that = this;
switch (_that) {
case _CreateInventoryRequest() when $default != null:
return $default(_that.medicationId,_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateInventoryRequest implements CreateInventoryRequest {
  const _CreateInventoryRequest({required this.medicationId, required this.currentQuantity, required this.unit, required this.reorderThreshold, required this.reorderAmount, this.expirationDate, this.location, this.batchNumber, this.purchaseDate, this.cost, this.refillStatus});
  factory _CreateInventoryRequest.fromJson(Map<String, dynamic> json) => _$CreateInventoryRequestFromJson(json);

@override final  String medicationId;
@override final  double currentQuantity;
@override final  String unit;
@override final  double reorderThreshold;
@override final  double reorderAmount;
@override final  DateTime? expirationDate;
@override final  String? location;
@override final  String? batchNumber;
@override final  DateTime? purchaseDate;
@override final  double? cost;
@override final  RefillStatus? refillStatus;

/// Create a copy of CreateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateInventoryRequestCopyWith<_CreateInventoryRequest> get copyWith => __$CreateInventoryRequestCopyWithImpl<_CreateInventoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateInventoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateInventoryRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus);

@override
String toString() {
  return 'CreateInventoryRequest(medicationId: $medicationId, currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus)';
}


}

/// @nodoc
abstract mixin class _$CreateInventoryRequestCopyWith<$Res> implements $CreateInventoryRequestCopyWith<$Res> {
  factory _$CreateInventoryRequestCopyWith(_CreateInventoryRequest value, $Res Function(_CreateInventoryRequest) _then) = __$CreateInventoryRequestCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, double currentQuantity, String unit, double reorderThreshold, double reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus
});




}
/// @nodoc
class __$CreateInventoryRequestCopyWithImpl<$Res>
    implements _$CreateInventoryRequestCopyWith<$Res> {
  __$CreateInventoryRequestCopyWithImpl(this._self, this._then);

  final _CreateInventoryRequest _self;
  final $Res Function(_CreateInventoryRequest) _then;

/// Create a copy of CreateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? currentQuantity = null,Object? unit = null,Object? reorderThreshold = null,Object? reorderAmount = null,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,}) {
  return _then(_CreateInventoryRequest(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,currentQuantity: null == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,reorderThreshold: null == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double,reorderAmount: null == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,
  ));
}


}


/// @nodoc
mixin _$UpdateInventoryRequest {

 double? get currentQuantity; String? get unit; double? get reorderThreshold; double? get reorderAmount; DateTime? get expirationDate; String? get location; String? get batchNumber; DateTime? get purchaseDate; double? get cost; RefillStatus? get refillStatus;
/// Create a copy of UpdateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInventoryRequestCopyWith<UpdateInventoryRequest> get copyWith => _$UpdateInventoryRequestCopyWithImpl<UpdateInventoryRequest>(this as UpdateInventoryRequest, _$identity);

  /// Serializes this UpdateInventoryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInventoryRequest&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus);

@override
String toString() {
  return 'UpdateInventoryRequest(currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus)';
}


}

/// @nodoc
abstract mixin class $UpdateInventoryRequestCopyWith<$Res>  {
  factory $UpdateInventoryRequestCopyWith(UpdateInventoryRequest value, $Res Function(UpdateInventoryRequest) _then) = _$UpdateInventoryRequestCopyWithImpl;
@useResult
$Res call({
 double? currentQuantity, String? unit, double? reorderThreshold, double? reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus
});




}
/// @nodoc
class _$UpdateInventoryRequestCopyWithImpl<$Res>
    implements $UpdateInventoryRequestCopyWith<$Res> {
  _$UpdateInventoryRequestCopyWithImpl(this._self, this._then);

  final UpdateInventoryRequest _self;
  final $Res Function(UpdateInventoryRequest) _then;

/// Create a copy of UpdateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentQuantity = freezed,Object? unit = freezed,Object? reorderThreshold = freezed,Object? reorderAmount = freezed,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,}) {
  return _then(_self.copyWith(
currentQuantity: freezed == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,reorderThreshold: freezed == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double?,reorderAmount: freezed == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateInventoryRequest].
extension UpdateInventoryRequestPatterns on UpdateInventoryRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInventoryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInventoryRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInventoryRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInventoryRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInventoryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInventoryRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? currentQuantity,  String? unit,  double? reorderThreshold,  double? reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInventoryRequest() when $default != null:
return $default(_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? currentQuantity,  String? unit,  double? reorderThreshold,  double? reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)  $default,) {final _that = this;
switch (_that) {
case _UpdateInventoryRequest():
return $default(_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? currentQuantity,  String? unit,  double? reorderThreshold,  double? reorderAmount,  DateTime? expirationDate,  String? location,  String? batchNumber,  DateTime? purchaseDate,  double? cost,  RefillStatus? refillStatus)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInventoryRequest() when $default != null:
return $default(_that.currentQuantity,_that.unit,_that.reorderThreshold,_that.reorderAmount,_that.expirationDate,_that.location,_that.batchNumber,_that.purchaseDate,_that.cost,_that.refillStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateInventoryRequest implements UpdateInventoryRequest {
  const _UpdateInventoryRequest({this.currentQuantity, this.unit, this.reorderThreshold, this.reorderAmount, this.expirationDate, this.location, this.batchNumber, this.purchaseDate, this.cost, this.refillStatus});
  factory _UpdateInventoryRequest.fromJson(Map<String, dynamic> json) => _$UpdateInventoryRequestFromJson(json);

@override final  double? currentQuantity;
@override final  String? unit;
@override final  double? reorderThreshold;
@override final  double? reorderAmount;
@override final  DateTime? expirationDate;
@override final  String? location;
@override final  String? batchNumber;
@override final  DateTime? purchaseDate;
@override final  double? cost;
@override final  RefillStatus? refillStatus;

/// Create a copy of UpdateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInventoryRequestCopyWith<_UpdateInventoryRequest> get copyWith => __$UpdateInventoryRequestCopyWithImpl<_UpdateInventoryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateInventoryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInventoryRequest&&(identical(other.currentQuantity, currentQuantity) || other.currentQuantity == currentQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.reorderThreshold, reorderThreshold) || other.reorderThreshold == reorderThreshold)&&(identical(other.reorderAmount, reorderAmount) || other.reorderAmount == reorderAmount)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.location, location) || other.location == location)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.refillStatus, refillStatus) || other.refillStatus == refillStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentQuantity,unit,reorderThreshold,reorderAmount,expirationDate,location,batchNumber,purchaseDate,cost,refillStatus);

@override
String toString() {
  return 'UpdateInventoryRequest(currentQuantity: $currentQuantity, unit: $unit, reorderThreshold: $reorderThreshold, reorderAmount: $reorderAmount, expirationDate: $expirationDate, location: $location, batchNumber: $batchNumber, purchaseDate: $purchaseDate, cost: $cost, refillStatus: $refillStatus)';
}


}

/// @nodoc
abstract mixin class _$UpdateInventoryRequestCopyWith<$Res> implements $UpdateInventoryRequestCopyWith<$Res> {
  factory _$UpdateInventoryRequestCopyWith(_UpdateInventoryRequest value, $Res Function(_UpdateInventoryRequest) _then) = __$UpdateInventoryRequestCopyWithImpl;
@override @useResult
$Res call({
 double? currentQuantity, String? unit, double? reorderThreshold, double? reorderAmount, DateTime? expirationDate, String? location, String? batchNumber, DateTime? purchaseDate, double? cost, RefillStatus? refillStatus
});




}
/// @nodoc
class __$UpdateInventoryRequestCopyWithImpl<$Res>
    implements _$UpdateInventoryRequestCopyWith<$Res> {
  __$UpdateInventoryRequestCopyWithImpl(this._self, this._then);

  final _UpdateInventoryRequest _self;
  final $Res Function(_UpdateInventoryRequest) _then;

/// Create a copy of UpdateInventoryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentQuantity = freezed,Object? unit = freezed,Object? reorderThreshold = freezed,Object? reorderAmount = freezed,Object? expirationDate = freezed,Object? location = freezed,Object? batchNumber = freezed,Object? purchaseDate = freezed,Object? cost = freezed,Object? refillStatus = freezed,}) {
  return _then(_UpdateInventoryRequest(
currentQuantity: freezed == currentQuantity ? _self.currentQuantity : currentQuantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,reorderThreshold: freezed == reorderThreshold ? _self.reorderThreshold : reorderThreshold // ignore: cast_nullable_to_non_nullable
as double?,reorderAmount: freezed == reorderAmount ? _self.reorderAmount : reorderAmount // ignore: cast_nullable_to_non_nullable
as double?,expirationDate: freezed == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,refillStatus: freezed == refillStatus ? _self.refillStatus : refillStatus // ignore: cast_nullable_to_non_nullable
as RefillStatus?,
  ));
}


}


/// @nodoc
mixin _$InventoryAdjustmentRequest {

 double get adjustment; String get reason; String? get notes;
/// Create a copy of InventoryAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryAdjustmentRequestCopyWith<InventoryAdjustmentRequest> get copyWith => _$InventoryAdjustmentRequestCopyWithImpl<InventoryAdjustmentRequest>(this as InventoryAdjustmentRequest, _$identity);

  /// Serializes this InventoryAdjustmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryAdjustmentRequest&&(identical(other.adjustment, adjustment) || other.adjustment == adjustment)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adjustment,reason,notes);

@override
String toString() {
  return 'InventoryAdjustmentRequest(adjustment: $adjustment, reason: $reason, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $InventoryAdjustmentRequestCopyWith<$Res>  {
  factory $InventoryAdjustmentRequestCopyWith(InventoryAdjustmentRequest value, $Res Function(InventoryAdjustmentRequest) _then) = _$InventoryAdjustmentRequestCopyWithImpl;
@useResult
$Res call({
 double adjustment, String reason, String? notes
});




}
/// @nodoc
class _$InventoryAdjustmentRequestCopyWithImpl<$Res>
    implements $InventoryAdjustmentRequestCopyWith<$Res> {
  _$InventoryAdjustmentRequestCopyWithImpl(this._self, this._then);

  final InventoryAdjustmentRequest _self;
  final $Res Function(InventoryAdjustmentRequest) _then;

/// Create a copy of InventoryAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? adjustment = null,Object? reason = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
adjustment: null == adjustment ? _self.adjustment : adjustment // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryAdjustmentRequest].
extension InventoryAdjustmentRequestPatterns on InventoryAdjustmentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryAdjustmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryAdjustmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryAdjustmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double adjustment,  String reason,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest() when $default != null:
return $default(_that.adjustment,_that.reason,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double adjustment,  String reason,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest():
return $default(_that.adjustment,_that.reason,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double adjustment,  String reason,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _InventoryAdjustmentRequest() when $default != null:
return $default(_that.adjustment,_that.reason,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryAdjustmentRequest implements InventoryAdjustmentRequest {
  const _InventoryAdjustmentRequest({required this.adjustment, required this.reason, this.notes});
  factory _InventoryAdjustmentRequest.fromJson(Map<String, dynamic> json) => _$InventoryAdjustmentRequestFromJson(json);

@override final  double adjustment;
@override final  String reason;
@override final  String? notes;

/// Create a copy of InventoryAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryAdjustmentRequestCopyWith<_InventoryAdjustmentRequest> get copyWith => __$InventoryAdjustmentRequestCopyWithImpl<_InventoryAdjustmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryAdjustmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryAdjustmentRequest&&(identical(other.adjustment, adjustment) || other.adjustment == adjustment)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,adjustment,reason,notes);

@override
String toString() {
  return 'InventoryAdjustmentRequest(adjustment: $adjustment, reason: $reason, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$InventoryAdjustmentRequestCopyWith<$Res> implements $InventoryAdjustmentRequestCopyWith<$Res> {
  factory _$InventoryAdjustmentRequestCopyWith(_InventoryAdjustmentRequest value, $Res Function(_InventoryAdjustmentRequest) _then) = __$InventoryAdjustmentRequestCopyWithImpl;
@override @useResult
$Res call({
 double adjustment, String reason, String? notes
});




}
/// @nodoc
class __$InventoryAdjustmentRequestCopyWithImpl<$Res>
    implements _$InventoryAdjustmentRequestCopyWith<$Res> {
  __$InventoryAdjustmentRequestCopyWithImpl(this._self, this._then);

  final _InventoryAdjustmentRequest _self;
  final $Res Function(_InventoryAdjustmentRequest) _then;

/// Create a copy of InventoryAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? adjustment = null,Object? reason = null,Object? notes = freezed,}) {
  return _then(_InventoryAdjustmentRequest(
adjustment: null == adjustment ? _self.adjustment : adjustment // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventoryAlert {

 String get id; String get inventoryId; String get medicationId; InventoryAlertType get alertType; String get message; DateTime get alertDate; bool get isRead; bool get isResolved; DateTime? get resolvedAt; String? get resolvedBy;
/// Create a copy of InventoryAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryAlertCopyWith<InventoryAlert> get copyWith => _$InventoryAlertCopyWithImpl<InventoryAlert>(this as InventoryAlert, _$identity);

  /// Serializes this InventoryAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.message, message) || other.message == message)&&(identical(other.alertDate, alertDate) || other.alertDate == alertDate)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,medicationId,alertType,message,alertDate,isRead,isResolved,resolvedAt,resolvedBy);

@override
String toString() {
  return 'InventoryAlert(id: $id, inventoryId: $inventoryId, medicationId: $medicationId, alertType: $alertType, message: $message, alertDate: $alertDate, isRead: $isRead, isResolved: $isResolved, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy)';
}


}

/// @nodoc
abstract mixin class $InventoryAlertCopyWith<$Res>  {
  factory $InventoryAlertCopyWith(InventoryAlert value, $Res Function(InventoryAlert) _then) = _$InventoryAlertCopyWithImpl;
@useResult
$Res call({
 String id, String inventoryId, String medicationId, InventoryAlertType alertType, String message, DateTime alertDate, bool isRead, bool isResolved, DateTime? resolvedAt, String? resolvedBy
});




}
/// @nodoc
class _$InventoryAlertCopyWithImpl<$Res>
    implements $InventoryAlertCopyWith<$Res> {
  _$InventoryAlertCopyWithImpl(this._self, this._then);

  final InventoryAlert _self;
  final $Res Function(InventoryAlert) _then;

/// Create a copy of InventoryAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inventoryId = null,Object? medicationId = null,Object? alertType = null,Object? message = null,Object? alertDate = null,Object? isRead = null,Object? isResolved = null,Object? resolvedAt = freezed,Object? resolvedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as InventoryAlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,alertDate: null == alertDate ? _self.alertDate : alertDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryAlert].
extension InventoryAlertPatterns on InventoryAlert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryAlert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryAlert value)  $default,){
final _that = this;
switch (_that) {
case _InventoryAlert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryAlert value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryAlert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inventoryId,  String medicationId,  InventoryAlertType alertType,  String message,  DateTime alertDate,  bool isRead,  bool isResolved,  DateTime? resolvedAt,  String? resolvedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryAlert() when $default != null:
return $default(_that.id,_that.inventoryId,_that.medicationId,_that.alertType,_that.message,_that.alertDate,_that.isRead,_that.isResolved,_that.resolvedAt,_that.resolvedBy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inventoryId,  String medicationId,  InventoryAlertType alertType,  String message,  DateTime alertDate,  bool isRead,  bool isResolved,  DateTime? resolvedAt,  String? resolvedBy)  $default,) {final _that = this;
switch (_that) {
case _InventoryAlert():
return $default(_that.id,_that.inventoryId,_that.medicationId,_that.alertType,_that.message,_that.alertDate,_that.isRead,_that.isResolved,_that.resolvedAt,_that.resolvedBy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inventoryId,  String medicationId,  InventoryAlertType alertType,  String message,  DateTime alertDate,  bool isRead,  bool isResolved,  DateTime? resolvedAt,  String? resolvedBy)?  $default,) {final _that = this;
switch (_that) {
case _InventoryAlert() when $default != null:
return $default(_that.id,_that.inventoryId,_that.medicationId,_that.alertType,_that.message,_that.alertDate,_that.isRead,_that.isResolved,_that.resolvedAt,_that.resolvedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryAlert implements InventoryAlert {
  const _InventoryAlert({required this.id, required this.inventoryId, required this.medicationId, required this.alertType, required this.message, required this.alertDate, this.isRead = false, this.isResolved = false, this.resolvedAt, this.resolvedBy});
  factory _InventoryAlert.fromJson(Map<String, dynamic> json) => _$InventoryAlertFromJson(json);

@override final  String id;
@override final  String inventoryId;
@override final  String medicationId;
@override final  InventoryAlertType alertType;
@override final  String message;
@override final  DateTime alertDate;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isResolved;
@override final  DateTime? resolvedAt;
@override final  String? resolvedBy;

/// Create a copy of InventoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryAlertCopyWith<_InventoryAlert> get copyWith => __$InventoryAlertCopyWithImpl<_InventoryAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.message, message) || other.message == message)&&(identical(other.alertDate, alertDate) || other.alertDate == alertDate)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,medicationId,alertType,message,alertDate,isRead,isResolved,resolvedAt,resolvedBy);

@override
String toString() {
  return 'InventoryAlert(id: $id, inventoryId: $inventoryId, medicationId: $medicationId, alertType: $alertType, message: $message, alertDate: $alertDate, isRead: $isRead, isResolved: $isResolved, resolvedAt: $resolvedAt, resolvedBy: $resolvedBy)';
}


}

/// @nodoc
abstract mixin class _$InventoryAlertCopyWith<$Res> implements $InventoryAlertCopyWith<$Res> {
  factory _$InventoryAlertCopyWith(_InventoryAlert value, $Res Function(_InventoryAlert) _then) = __$InventoryAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String inventoryId, String medicationId, InventoryAlertType alertType, String message, DateTime alertDate, bool isRead, bool isResolved, DateTime? resolvedAt, String? resolvedBy
});




}
/// @nodoc
class __$InventoryAlertCopyWithImpl<$Res>
    implements _$InventoryAlertCopyWith<$Res> {
  __$InventoryAlertCopyWithImpl(this._self, this._then);

  final _InventoryAlert _self;
  final $Res Function(_InventoryAlert) _then;

/// Create a copy of InventoryAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inventoryId = null,Object? medicationId = null,Object? alertType = null,Object? message = null,Object? alertDate = null,Object? isRead = null,Object? isResolved = null,Object? resolvedAt = freezed,Object? resolvedBy = freezed,}) {
  return _then(_InventoryAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as InventoryAlertType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,alertDate: null == alertDate ? _self.alertDate : alertDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventoryStatistics {

 int get totalItems; int get lowStockItems; int get expiredItems; int get expiringSoonItems; double get totalValue; Map<String, int> get itemsByLocation; Map<RefillStatus, int> get itemsByRefillStatus; int get reorderNeededCount;
/// Create a copy of InventoryStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStatisticsCopyWith<InventoryStatistics> get copyWith => _$InventoryStatisticsCopyWithImpl<InventoryStatistics>(this as InventoryStatistics, _$identity);

  /// Serializes this InventoryStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStatistics&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.lowStockItems, lowStockItems) || other.lowStockItems == lowStockItems)&&(identical(other.expiredItems, expiredItems) || other.expiredItems == expiredItems)&&(identical(other.expiringSoonItems, expiringSoonItems) || other.expiringSoonItems == expiringSoonItems)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&const DeepCollectionEquality().equals(other.itemsByLocation, itemsByLocation)&&const DeepCollectionEquality().equals(other.itemsByRefillStatus, itemsByRefillStatus)&&(identical(other.reorderNeededCount, reorderNeededCount) || other.reorderNeededCount == reorderNeededCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,lowStockItems,expiredItems,expiringSoonItems,totalValue,const DeepCollectionEquality().hash(itemsByLocation),const DeepCollectionEquality().hash(itemsByRefillStatus),reorderNeededCount);

@override
String toString() {
  return 'InventoryStatistics(totalItems: $totalItems, lowStockItems: $lowStockItems, expiredItems: $expiredItems, expiringSoonItems: $expiringSoonItems, totalValue: $totalValue, itemsByLocation: $itemsByLocation, itemsByRefillStatus: $itemsByRefillStatus, reorderNeededCount: $reorderNeededCount)';
}


}

/// @nodoc
abstract mixin class $InventoryStatisticsCopyWith<$Res>  {
  factory $InventoryStatisticsCopyWith(InventoryStatistics value, $Res Function(InventoryStatistics) _then) = _$InventoryStatisticsCopyWithImpl;
@useResult
$Res call({
 int totalItems, int lowStockItems, int expiredItems, int expiringSoonItems, double totalValue, Map<String, int> itemsByLocation, Map<RefillStatus, int> itemsByRefillStatus, int reorderNeededCount
});




}
/// @nodoc
class _$InventoryStatisticsCopyWithImpl<$Res>
    implements $InventoryStatisticsCopyWith<$Res> {
  _$InventoryStatisticsCopyWithImpl(this._self, this._then);

  final InventoryStatistics _self;
  final $Res Function(InventoryStatistics) _then;

/// Create a copy of InventoryStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalItems = null,Object? lowStockItems = null,Object? expiredItems = null,Object? expiringSoonItems = null,Object? totalValue = null,Object? itemsByLocation = null,Object? itemsByRefillStatus = null,Object? reorderNeededCount = null,}) {
  return _then(_self.copyWith(
totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self.lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as int,expiredItems: null == expiredItems ? _self.expiredItems : expiredItems // ignore: cast_nullable_to_non_nullable
as int,expiringSoonItems: null == expiringSoonItems ? _self.expiringSoonItems : expiringSoonItems // ignore: cast_nullable_to_non_nullable
as int,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double,itemsByLocation: null == itemsByLocation ? _self.itemsByLocation : itemsByLocation // ignore: cast_nullable_to_non_nullable
as Map<String, int>,itemsByRefillStatus: null == itemsByRefillStatus ? _self.itemsByRefillStatus : itemsByRefillStatus // ignore: cast_nullable_to_non_nullable
as Map<RefillStatus, int>,reorderNeededCount: null == reorderNeededCount ? _self.reorderNeededCount : reorderNeededCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryStatistics].
extension InventoryStatisticsPatterns on InventoryStatistics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryStatistics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryStatistics value)  $default,){
final _that = this;
switch (_that) {
case _InventoryStatistics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryStatistics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalItems,  int lowStockItems,  int expiredItems,  int expiringSoonItems,  double totalValue,  Map<String, int> itemsByLocation,  Map<RefillStatus, int> itemsByRefillStatus,  int reorderNeededCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryStatistics() when $default != null:
return $default(_that.totalItems,_that.lowStockItems,_that.expiredItems,_that.expiringSoonItems,_that.totalValue,_that.itemsByLocation,_that.itemsByRefillStatus,_that.reorderNeededCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalItems,  int lowStockItems,  int expiredItems,  int expiringSoonItems,  double totalValue,  Map<String, int> itemsByLocation,  Map<RefillStatus, int> itemsByRefillStatus,  int reorderNeededCount)  $default,) {final _that = this;
switch (_that) {
case _InventoryStatistics():
return $default(_that.totalItems,_that.lowStockItems,_that.expiredItems,_that.expiringSoonItems,_that.totalValue,_that.itemsByLocation,_that.itemsByRefillStatus,_that.reorderNeededCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalItems,  int lowStockItems,  int expiredItems,  int expiringSoonItems,  double totalValue,  Map<String, int> itemsByLocation,  Map<RefillStatus, int> itemsByRefillStatus,  int reorderNeededCount)?  $default,) {final _that = this;
switch (_that) {
case _InventoryStatistics() when $default != null:
return $default(_that.totalItems,_that.lowStockItems,_that.expiredItems,_that.expiringSoonItems,_that.totalValue,_that.itemsByLocation,_that.itemsByRefillStatus,_that.reorderNeededCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryStatistics implements InventoryStatistics {
  const _InventoryStatistics({required this.totalItems, required this.lowStockItems, required this.expiredItems, required this.expiringSoonItems, required this.totalValue, required final  Map<String, int> itemsByLocation, required final  Map<RefillStatus, int> itemsByRefillStatus, required this.reorderNeededCount}): _itemsByLocation = itemsByLocation,_itemsByRefillStatus = itemsByRefillStatus;
  factory _InventoryStatistics.fromJson(Map<String, dynamic> json) => _$InventoryStatisticsFromJson(json);

@override final  int totalItems;
@override final  int lowStockItems;
@override final  int expiredItems;
@override final  int expiringSoonItems;
@override final  double totalValue;
 final  Map<String, int> _itemsByLocation;
@override Map<String, int> get itemsByLocation {
  if (_itemsByLocation is EqualUnmodifiableMapView) return _itemsByLocation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_itemsByLocation);
}

 final  Map<RefillStatus, int> _itemsByRefillStatus;
@override Map<RefillStatus, int> get itemsByRefillStatus {
  if (_itemsByRefillStatus is EqualUnmodifiableMapView) return _itemsByRefillStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_itemsByRefillStatus);
}

@override final  int reorderNeededCount;

/// Create a copy of InventoryStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStatisticsCopyWith<_InventoryStatistics> get copyWith => __$InventoryStatisticsCopyWithImpl<_InventoryStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryStatistics&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.lowStockItems, lowStockItems) || other.lowStockItems == lowStockItems)&&(identical(other.expiredItems, expiredItems) || other.expiredItems == expiredItems)&&(identical(other.expiringSoonItems, expiringSoonItems) || other.expiringSoonItems == expiringSoonItems)&&(identical(other.totalValue, totalValue) || other.totalValue == totalValue)&&const DeepCollectionEquality().equals(other._itemsByLocation, _itemsByLocation)&&const DeepCollectionEquality().equals(other._itemsByRefillStatus, _itemsByRefillStatus)&&(identical(other.reorderNeededCount, reorderNeededCount) || other.reorderNeededCount == reorderNeededCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,lowStockItems,expiredItems,expiringSoonItems,totalValue,const DeepCollectionEquality().hash(_itemsByLocation),const DeepCollectionEquality().hash(_itemsByRefillStatus),reorderNeededCount);

@override
String toString() {
  return 'InventoryStatistics(totalItems: $totalItems, lowStockItems: $lowStockItems, expiredItems: $expiredItems, expiringSoonItems: $expiringSoonItems, totalValue: $totalValue, itemsByLocation: $itemsByLocation, itemsByRefillStatus: $itemsByRefillStatus, reorderNeededCount: $reorderNeededCount)';
}


}

/// @nodoc
abstract mixin class _$InventoryStatisticsCopyWith<$Res> implements $InventoryStatisticsCopyWith<$Res> {
  factory _$InventoryStatisticsCopyWith(_InventoryStatistics value, $Res Function(_InventoryStatistics) _then) = __$InventoryStatisticsCopyWithImpl;
@override @useResult
$Res call({
 int totalItems, int lowStockItems, int expiredItems, int expiringSoonItems, double totalValue, Map<String, int> itemsByLocation, Map<RefillStatus, int> itemsByRefillStatus, int reorderNeededCount
});




}
/// @nodoc
class __$InventoryStatisticsCopyWithImpl<$Res>
    implements _$InventoryStatisticsCopyWith<$Res> {
  __$InventoryStatisticsCopyWithImpl(this._self, this._then);

  final _InventoryStatistics _self;
  final $Res Function(_InventoryStatistics) _then;

/// Create a copy of InventoryStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalItems = null,Object? lowStockItems = null,Object? expiredItems = null,Object? expiringSoonItems = null,Object? totalValue = null,Object? itemsByLocation = null,Object? itemsByRefillStatus = null,Object? reorderNeededCount = null,}) {
  return _then(_InventoryStatistics(
totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,lowStockItems: null == lowStockItems ? _self.lowStockItems : lowStockItems // ignore: cast_nullable_to_non_nullable
as int,expiredItems: null == expiredItems ? _self.expiredItems : expiredItems // ignore: cast_nullable_to_non_nullable
as int,expiringSoonItems: null == expiringSoonItems ? _self.expiringSoonItems : expiringSoonItems // ignore: cast_nullable_to_non_nullable
as int,totalValue: null == totalValue ? _self.totalValue : totalValue // ignore: cast_nullable_to_non_nullable
as double,itemsByLocation: null == itemsByLocation ? _self._itemsByLocation : itemsByLocation // ignore: cast_nullable_to_non_nullable
as Map<String, int>,itemsByRefillStatus: null == itemsByRefillStatus ? _self._itemsByRefillStatus : itemsByRefillStatus // ignore: cast_nullable_to_non_nullable
as Map<RefillStatus, int>,reorderNeededCount: null == reorderNeededCount ? _self.reorderNeededCount : reorderNeededCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InventoryResponse {

 bool get success; MedicationInventory? get data; String? get message; String? get error;
/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryResponseCopyWith<InventoryResponse> get copyWith => _$InventoryResponseCopyWithImpl<InventoryResponse>(this as InventoryResponse, _$identity);

  /// Serializes this InventoryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'InventoryResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $InventoryResponseCopyWith<$Res>  {
  factory $InventoryResponseCopyWith(InventoryResponse value, $Res Function(InventoryResponse) _then) = _$InventoryResponseCopyWithImpl;
@useResult
$Res call({
 bool success, MedicationInventory? data, String? message, String? error
});


$MedicationInventoryCopyWith<$Res>? get data;

}
/// @nodoc
class _$InventoryResponseCopyWithImpl<$Res>
    implements $InventoryResponseCopyWith<$Res> {
  _$InventoryResponseCopyWithImpl(this._self, this._then);

  final InventoryResponse _self;
  final $Res Function(InventoryResponse) _then;

/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MedicationInventory?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationInventoryCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationInventoryCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryResponse].
extension InventoryResponsePatterns on InventoryResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryResponse value)  $default,){
final _that = this;
switch (_that) {
case _InventoryResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  MedicationInventory? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  MedicationInventory? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _InventoryResponse():
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  MedicationInventory? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _InventoryResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryResponse implements InventoryResponse {
  const _InventoryResponse({required this.success, this.data, this.message, this.error});
  factory _InventoryResponse.fromJson(Map<String, dynamic> json) => _$InventoryResponseFromJson(json);

@override final  bool success;
@override final  MedicationInventory? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryResponseCopyWith<_InventoryResponse> get copyWith => __$InventoryResponseCopyWithImpl<_InventoryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'InventoryResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$InventoryResponseCopyWith<$Res> implements $InventoryResponseCopyWith<$Res> {
  factory _$InventoryResponseCopyWith(_InventoryResponse value, $Res Function(_InventoryResponse) _then) = __$InventoryResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, MedicationInventory? data, String? message, String? error
});


@override $MedicationInventoryCopyWith<$Res>? get data;

}
/// @nodoc
class __$InventoryResponseCopyWithImpl<$Res>
    implements _$InventoryResponseCopyWith<$Res> {
  __$InventoryResponseCopyWithImpl(this._self, this._then);

  final _InventoryResponse _self;
  final $Res Function(_InventoryResponse) _then;

/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_InventoryResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MedicationInventory?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InventoryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationInventoryCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationInventoryCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$InventoryListResponse {

 bool get success; List<MedicationInventory> get data; int? get count; int? get total; String? get message; String? get error;
/// Create a copy of InventoryListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryListResponseCopyWith<InventoryListResponse> get copyWith => _$InventoryListResponseCopyWithImpl<InventoryListResponse>(this as InventoryListResponse, _$identity);

  /// Serializes this InventoryListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,total,message,error);

@override
String toString() {
  return 'InventoryListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $InventoryListResponseCopyWith<$Res>  {
  factory $InventoryListResponseCopyWith(InventoryListResponse value, $Res Function(InventoryListResponse) _then) = _$InventoryListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<MedicationInventory> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class _$InventoryListResponseCopyWithImpl<$Res>
    implements $InventoryListResponseCopyWith<$Res> {
  _$InventoryListResponseCopyWithImpl(this._self, this._then);

  final InventoryListResponse _self;
  final $Res Function(InventoryListResponse) _then;

/// Create a copy of InventoryListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationInventory>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryListResponse].
extension InventoryListResponsePatterns on InventoryListResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryListResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryListResponse value)  $default,){
final _that = this;
switch (_that) {
case _InventoryListResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryListResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<MedicationInventory> data,  int? count,  int? total,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<MedicationInventory> data,  int? count,  int? total,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _InventoryListResponse():
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<MedicationInventory> data,  int? count,  int? total,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _InventoryListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryListResponse implements InventoryListResponse {
  const _InventoryListResponse({required this.success, final  List<MedicationInventory> data = const [], this.count, this.total, this.message, this.error}): _data = data;
  factory _InventoryListResponse.fromJson(Map<String, dynamic> json) => _$InventoryListResponseFromJson(json);

@override final  bool success;
 final  List<MedicationInventory> _data;
@override@JsonKey() List<MedicationInventory> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  int? total;
@override final  String? message;
@override final  String? error;

/// Create a copy of InventoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryListResponseCopyWith<_InventoryListResponse> get copyWith => __$InventoryListResponseCopyWithImpl<_InventoryListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,total,message,error);

@override
String toString() {
  return 'InventoryListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$InventoryListResponseCopyWith<$Res> implements $InventoryListResponseCopyWith<$Res> {
  factory _$InventoryListResponseCopyWith(_InventoryListResponse value, $Res Function(_InventoryListResponse) _then) = __$InventoryListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<MedicationInventory> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class __$InventoryListResponseCopyWithImpl<$Res>
    implements _$InventoryListResponseCopyWith<$Res> {
  __$InventoryListResponseCopyWithImpl(this._self, this._then);

  final _InventoryListResponse _self;
  final $Res Function(_InventoryListResponse) _then;

/// Create a copy of InventoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_InventoryListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationInventory>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
