// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adherence_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdherenceRecord {

 String get id; String get medicationId; String get scheduleId; String get userId; DateTime get scheduledTime; double get dosage; String get unit; DoseStatus get status; DateTime? get takenAt; String? get skippedReason; String? get notes; String? get reminderId; DateTime get createdAt;
/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceRecordCopyWith<AdherenceRecord> get copyWith => _$AdherenceRecordCopyWithImpl<AdherenceRecord>(this as AdherenceRecord, _$identity);

  /// Serializes this AdherenceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduleId,userId,scheduledTime,dosage,unit,status,takenAt,skippedReason,notes,reminderId,createdAt);

@override
String toString() {
  return 'AdherenceRecord(id: $id, medicationId: $medicationId, scheduleId: $scheduleId, userId: $userId, scheduledTime: $scheduledTime, dosage: $dosage, unit: $unit, status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes, reminderId: $reminderId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdherenceRecordCopyWith<$Res>  {
  factory $AdherenceRecordCopyWith(AdherenceRecord value, $Res Function(AdherenceRecord) _then) = _$AdherenceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, String scheduleId, String userId, DateTime scheduledTime, double dosage, String unit, DoseStatus status, DateTime? takenAt, String? skippedReason, String? notes, String? reminderId, DateTime createdAt
});




}
/// @nodoc
class _$AdherenceRecordCopyWithImpl<$Res>
    implements $AdherenceRecordCopyWith<$Res> {
  _$AdherenceRecordCopyWithImpl(this._self, this._then);

  final AdherenceRecord _self;
  final $Res Function(AdherenceRecord) _then;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? scheduleId = null,Object? userId = null,Object? scheduledTime = null,Object? dosage = null,Object? unit = null,Object? status = null,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,Object? reminderId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceRecord].
extension AdherenceRecordPatterns on AdherenceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  String scheduleId,  String userId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduleId,_that.userId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  String scheduleId,  String userId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecord():
return $default(_that.id,_that.medicationId,_that.scheduleId,_that.userId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  String scheduleId,  String userId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
return $default(_that.id,_that.medicationId,_that.scheduleId,_that.userId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceRecord implements AdherenceRecord {
  const _AdherenceRecord({required this.id, required this.medicationId, required this.scheduleId, required this.userId, required this.scheduledTime, required this.dosage, required this.unit, required this.status, this.takenAt, this.skippedReason, this.notes, this.reminderId, required this.createdAt});
  factory _AdherenceRecord.fromJson(Map<String, dynamic> json) => _$AdherenceRecordFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  String scheduleId;
@override final  String userId;
@override final  DateTime scheduledTime;
@override final  double dosage;
@override final  String unit;
@override final  DoseStatus status;
@override final  DateTime? takenAt;
@override final  String? skippedReason;
@override final  String? notes;
@override final  String? reminderId;
@override final  DateTime createdAt;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceRecordCopyWith<_AdherenceRecord> get copyWith => __$AdherenceRecordCopyWithImpl<_AdherenceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,scheduleId,userId,scheduledTime,dosage,unit,status,takenAt,skippedReason,notes,reminderId,createdAt);

@override
String toString() {
  return 'AdherenceRecord(id: $id, medicationId: $medicationId, scheduleId: $scheduleId, userId: $userId, scheduledTime: $scheduledTime, dosage: $dosage, unit: $unit, status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes, reminderId: $reminderId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdherenceRecordCopyWith<$Res> implements $AdherenceRecordCopyWith<$Res> {
  factory _$AdherenceRecordCopyWith(_AdherenceRecord value, $Res Function(_AdherenceRecord) _then) = __$AdherenceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, String scheduleId, String userId, DateTime scheduledTime, double dosage, String unit, DoseStatus status, DateTime? takenAt, String? skippedReason, String? notes, String? reminderId, DateTime createdAt
});




}
/// @nodoc
class __$AdherenceRecordCopyWithImpl<$Res>
    implements _$AdherenceRecordCopyWith<$Res> {
  __$AdherenceRecordCopyWithImpl(this._self, this._then);

  final _AdherenceRecord _self;
  final $Res Function(_AdherenceRecord) _then;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? scheduleId = null,Object? userId = null,Object? scheduledTime = null,Object? dosage = null,Object? unit = null,Object? status = null,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,Object? reminderId = freezed,Object? createdAt = null,}) {
  return _then(_AdherenceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateAdherenceRecordRequest {

 String get medicationId; String get scheduleId; DateTime get scheduledTime; double get dosage; String get unit; DoseStatus get status; DateTime? get takenAt; String? get skippedReason; String? get notes; String? get reminderId;
/// Create a copy of CreateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAdherenceRecordRequestCopyWith<CreateAdherenceRecordRequest> get copyWith => _$CreateAdherenceRecordRequestCopyWithImpl<CreateAdherenceRecordRequest>(this as CreateAdherenceRecordRequest, _$identity);

  /// Serializes this CreateAdherenceRecordRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAdherenceRecordRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,scheduledTime,dosage,unit,status,takenAt,skippedReason,notes,reminderId);

@override
String toString() {
  return 'CreateAdherenceRecordRequest(medicationId: $medicationId, scheduleId: $scheduleId, scheduledTime: $scheduledTime, dosage: $dosage, unit: $unit, status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes, reminderId: $reminderId)';
}


}

/// @nodoc
abstract mixin class $CreateAdherenceRecordRequestCopyWith<$Res>  {
  factory $CreateAdherenceRecordRequestCopyWith(CreateAdherenceRecordRequest value, $Res Function(CreateAdherenceRecordRequest) _then) = _$CreateAdherenceRecordRequestCopyWithImpl;
@useResult
$Res call({
 String medicationId, String scheduleId, DateTime scheduledTime, double dosage, String unit, DoseStatus status, DateTime? takenAt, String? skippedReason, String? notes, String? reminderId
});




}
/// @nodoc
class _$CreateAdherenceRecordRequestCopyWithImpl<$Res>
    implements $CreateAdherenceRecordRequestCopyWith<$Res> {
  _$CreateAdherenceRecordRequestCopyWithImpl(this._self, this._then);

  final CreateAdherenceRecordRequest _self;
  final $Res Function(CreateAdherenceRecordRequest) _then;

/// Create a copy of CreateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? scheduleId = null,Object? scheduledTime = null,Object? dosage = null,Object? unit = null,Object? status = null,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,Object? reminderId = freezed,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAdherenceRecordRequest].
extension CreateAdherenceRecordRequestPatterns on CreateAdherenceRecordRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAdherenceRecordRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAdherenceRecordRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAdherenceRecordRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  String scheduleId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  String scheduleId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId)  $default,) {final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest():
return $default(_that.medicationId,_that.scheduleId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  String scheduleId,  DateTime scheduledTime,  double dosage,  String unit,  DoseStatus status,  DateTime? takenAt,  String? skippedReason,  String? notes,  String? reminderId)?  $default,) {final _that = this;
switch (_that) {
case _CreateAdherenceRecordRequest() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.scheduledTime,_that.dosage,_that.unit,_that.status,_that.takenAt,_that.skippedReason,_that.notes,_that.reminderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAdherenceRecordRequest implements CreateAdherenceRecordRequest {
  const _CreateAdherenceRecordRequest({required this.medicationId, required this.scheduleId, required this.scheduledTime, required this.dosage, required this.unit, this.status = DoseStatus.scheduled, this.takenAt, this.skippedReason, this.notes, this.reminderId});
  factory _CreateAdherenceRecordRequest.fromJson(Map<String, dynamic> json) => _$CreateAdherenceRecordRequestFromJson(json);

@override final  String medicationId;
@override final  String scheduleId;
@override final  DateTime scheduledTime;
@override final  double dosage;
@override final  String unit;
@override@JsonKey() final  DoseStatus status;
@override final  DateTime? takenAt;
@override final  String? skippedReason;
@override final  String? notes;
@override final  String? reminderId;

/// Create a copy of CreateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAdherenceRecordRequestCopyWith<_CreateAdherenceRecordRequest> get copyWith => __$CreateAdherenceRecordRequestCopyWithImpl<_CreateAdherenceRecordRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAdherenceRecordRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAdherenceRecordRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.reminderId, reminderId) || other.reminderId == reminderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,scheduledTime,dosage,unit,status,takenAt,skippedReason,notes,reminderId);

@override
String toString() {
  return 'CreateAdherenceRecordRequest(medicationId: $medicationId, scheduleId: $scheduleId, scheduledTime: $scheduledTime, dosage: $dosage, unit: $unit, status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes, reminderId: $reminderId)';
}


}

/// @nodoc
abstract mixin class _$CreateAdherenceRecordRequestCopyWith<$Res> implements $CreateAdherenceRecordRequestCopyWith<$Res> {
  factory _$CreateAdherenceRecordRequestCopyWith(_CreateAdherenceRecordRequest value, $Res Function(_CreateAdherenceRecordRequest) _then) = __$CreateAdherenceRecordRequestCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, String scheduleId, DateTime scheduledTime, double dosage, String unit, DoseStatus status, DateTime? takenAt, String? skippedReason, String? notes, String? reminderId
});




}
/// @nodoc
class __$CreateAdherenceRecordRequestCopyWithImpl<$Res>
    implements _$CreateAdherenceRecordRequestCopyWith<$Res> {
  __$CreateAdherenceRecordRequestCopyWithImpl(this._self, this._then);

  final _CreateAdherenceRecordRequest _self;
  final $Res Function(_CreateAdherenceRecordRequest) _then;

/// Create a copy of CreateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? scheduleId = null,Object? scheduledTime = null,Object? dosage = null,Object? unit = null,Object? status = null,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,Object? reminderId = freezed,}) {
  return _then(_CreateAdherenceRecordRequest(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,reminderId: freezed == reminderId ? _self.reminderId : reminderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateAdherenceRecordRequest {

 DoseStatus? get status; DateTime? get takenAt; String? get skippedReason; String? get notes;
/// Create a copy of UpdateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAdherenceRecordRequestCopyWith<UpdateAdherenceRecordRequest> get copyWith => _$UpdateAdherenceRecordRequestCopyWithImpl<UpdateAdherenceRecordRequest>(this as UpdateAdherenceRecordRequest, _$identity);

  /// Serializes this UpdateAdherenceRecordRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAdherenceRecordRequest&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,takenAt,skippedReason,notes);

@override
String toString() {
  return 'UpdateAdherenceRecordRequest(status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $UpdateAdherenceRecordRequestCopyWith<$Res>  {
  factory $UpdateAdherenceRecordRequestCopyWith(UpdateAdherenceRecordRequest value, $Res Function(UpdateAdherenceRecordRequest) _then) = _$UpdateAdherenceRecordRequestCopyWithImpl;
@useResult
$Res call({
 DoseStatus? status, DateTime? takenAt, String? skippedReason, String? notes
});




}
/// @nodoc
class _$UpdateAdherenceRecordRequestCopyWithImpl<$Res>
    implements $UpdateAdherenceRecordRequestCopyWith<$Res> {
  _$UpdateAdherenceRecordRequestCopyWithImpl(this._self, this._then);

  final UpdateAdherenceRecordRequest _self;
  final $Res Function(UpdateAdherenceRecordRequest) _then;

/// Create a copy of UpdateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAdherenceRecordRequest].
extension UpdateAdherenceRecordRequestPatterns on UpdateAdherenceRecordRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAdherenceRecordRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAdherenceRecordRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAdherenceRecordRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DoseStatus? status,  DateTime? takenAt,  String? skippedReason,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest() when $default != null:
return $default(_that.status,_that.takenAt,_that.skippedReason,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DoseStatus? status,  DateTime? takenAt,  String? skippedReason,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest():
return $default(_that.status,_that.takenAt,_that.skippedReason,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DoseStatus? status,  DateTime? takenAt,  String? skippedReason,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAdherenceRecordRequest() when $default != null:
return $default(_that.status,_that.takenAt,_that.skippedReason,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAdherenceRecordRequest implements UpdateAdherenceRecordRequest {
  const _UpdateAdherenceRecordRequest({this.status, this.takenAt, this.skippedReason, this.notes});
  factory _UpdateAdherenceRecordRequest.fromJson(Map<String, dynamic> json) => _$UpdateAdherenceRecordRequestFromJson(json);

@override final  DoseStatus? status;
@override final  DateTime? takenAt;
@override final  String? skippedReason;
@override final  String? notes;

/// Create a copy of UpdateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAdherenceRecordRequestCopyWith<_UpdateAdherenceRecordRequest> get copyWith => __$UpdateAdherenceRecordRequestCopyWithImpl<_UpdateAdherenceRecordRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAdherenceRecordRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdherenceRecordRequest&&(identical(other.status, status) || other.status == status)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.skippedReason, skippedReason) || other.skippedReason == skippedReason)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,takenAt,skippedReason,notes);

@override
String toString() {
  return 'UpdateAdherenceRecordRequest(status: $status, takenAt: $takenAt, skippedReason: $skippedReason, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$UpdateAdherenceRecordRequestCopyWith<$Res> implements $UpdateAdherenceRecordRequestCopyWith<$Res> {
  factory _$UpdateAdherenceRecordRequestCopyWith(_UpdateAdherenceRecordRequest value, $Res Function(_UpdateAdherenceRecordRequest) _then) = __$UpdateAdherenceRecordRequestCopyWithImpl;
@override @useResult
$Res call({
 DoseStatus? status, DateTime? takenAt, String? skippedReason, String? notes
});




}
/// @nodoc
class __$UpdateAdherenceRecordRequestCopyWithImpl<$Res>
    implements _$UpdateAdherenceRecordRequestCopyWith<$Res> {
  __$UpdateAdherenceRecordRequestCopyWithImpl(this._self, this._then);

  final _UpdateAdherenceRecordRequest _self;
  final $Res Function(_UpdateAdherenceRecordRequest) _then;

/// Create a copy of UpdateAdherenceRecordRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? takenAt = freezed,Object? skippedReason = freezed,Object? notes = freezed,}) {
  return _then(_UpdateAdherenceRecordRequest(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,skippedReason: freezed == skippedReason ? _self.skippedReason : skippedReason // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdherenceStatistics {

 String get medicationId; int get totalDoses; int get takenDoses; int get missedDoses; int get skippedDoses; int get lateDoses; double get adherencePercentage; int get currentStreak; int get longestStreak; DateTime? get lastDoseTime; DateTime? get nextDoseTime; Map<String, int> get weeklyStats; Map<String, double> get monthlyTrends;
/// Create a copy of AdherenceStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceStatisticsCopyWith<AdherenceStatistics> get copyWith => _$AdherenceStatisticsCopyWithImpl<AdherenceStatistics>(this as AdherenceStatistics, _$identity);

  /// Serializes this AdherenceStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceStatistics&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.takenDoses, takenDoses) || other.takenDoses == takenDoses)&&(identical(other.missedDoses, missedDoses) || other.missedDoses == missedDoses)&&(identical(other.skippedDoses, skippedDoses) || other.skippedDoses == skippedDoses)&&(identical(other.lateDoses, lateDoses) || other.lateDoses == lateDoses)&&(identical(other.adherencePercentage, adherencePercentage) || other.adherencePercentage == adherencePercentage)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastDoseTime, lastDoseTime) || other.lastDoseTime == lastDoseTime)&&(identical(other.nextDoseTime, nextDoseTime) || other.nextDoseTime == nextDoseTime)&&const DeepCollectionEquality().equals(other.weeklyStats, weeklyStats)&&const DeepCollectionEquality().equals(other.monthlyTrends, monthlyTrends));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,totalDoses,takenDoses,missedDoses,skippedDoses,lateDoses,adherencePercentage,currentStreak,longestStreak,lastDoseTime,nextDoseTime,const DeepCollectionEquality().hash(weeklyStats),const DeepCollectionEquality().hash(monthlyTrends));

@override
String toString() {
  return 'AdherenceStatistics(medicationId: $medicationId, totalDoses: $totalDoses, takenDoses: $takenDoses, missedDoses: $missedDoses, skippedDoses: $skippedDoses, lateDoses: $lateDoses, adherencePercentage: $adherencePercentage, currentStreak: $currentStreak, longestStreak: $longestStreak, lastDoseTime: $lastDoseTime, nextDoseTime: $nextDoseTime, weeklyStats: $weeklyStats, monthlyTrends: $monthlyTrends)';
}


}

/// @nodoc
abstract mixin class $AdherenceStatisticsCopyWith<$Res>  {
  factory $AdherenceStatisticsCopyWith(AdherenceStatistics value, $Res Function(AdherenceStatistics) _then) = _$AdherenceStatisticsCopyWithImpl;
@useResult
$Res call({
 String medicationId, int totalDoses, int takenDoses, int missedDoses, int skippedDoses, int lateDoses, double adherencePercentage, int currentStreak, int longestStreak, DateTime? lastDoseTime, DateTime? nextDoseTime, Map<String, int> weeklyStats, Map<String, double> monthlyTrends
});




}
/// @nodoc
class _$AdherenceStatisticsCopyWithImpl<$Res>
    implements $AdherenceStatisticsCopyWith<$Res> {
  _$AdherenceStatisticsCopyWithImpl(this._self, this._then);

  final AdherenceStatistics _self;
  final $Res Function(AdherenceStatistics) _then;

/// Create a copy of AdherenceStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? totalDoses = null,Object? takenDoses = null,Object? missedDoses = null,Object? skippedDoses = null,Object? lateDoses = null,Object? adherencePercentage = null,Object? currentStreak = null,Object? longestStreak = null,Object? lastDoseTime = freezed,Object? nextDoseTime = freezed,Object? weeklyStats = null,Object? monthlyTrends = null,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,takenDoses: null == takenDoses ? _self.takenDoses : takenDoses // ignore: cast_nullable_to_non_nullable
as int,missedDoses: null == missedDoses ? _self.missedDoses : missedDoses // ignore: cast_nullable_to_non_nullable
as int,skippedDoses: null == skippedDoses ? _self.skippedDoses : skippedDoses // ignore: cast_nullable_to_non_nullable
as int,lateDoses: null == lateDoses ? _self.lateDoses : lateDoses // ignore: cast_nullable_to_non_nullable
as int,adherencePercentage: null == adherencePercentage ? _self.adherencePercentage : adherencePercentage // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastDoseTime: freezed == lastDoseTime ? _self.lastDoseTime : lastDoseTime // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDoseTime: freezed == nextDoseTime ? _self.nextDoseTime : nextDoseTime // ignore: cast_nullable_to_non_nullable
as DateTime?,weeklyStats: null == weeklyStats ? _self.weeklyStats : weeklyStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,monthlyTrends: null == monthlyTrends ? _self.monthlyTrends : monthlyTrends // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceStatistics].
extension AdherenceStatisticsPatterns on AdherenceStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceStatistics value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  int totalDoses,  int takenDoses,  int missedDoses,  int skippedDoses,  int lateDoses,  double adherencePercentage,  int currentStreak,  int longestStreak,  DateTime? lastDoseTime,  DateTime? nextDoseTime,  Map<String, int> weeklyStats,  Map<String, double> monthlyTrends)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceStatistics() when $default != null:
return $default(_that.medicationId,_that.totalDoses,_that.takenDoses,_that.missedDoses,_that.skippedDoses,_that.lateDoses,_that.adherencePercentage,_that.currentStreak,_that.longestStreak,_that.lastDoseTime,_that.nextDoseTime,_that.weeklyStats,_that.monthlyTrends);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  int totalDoses,  int takenDoses,  int missedDoses,  int skippedDoses,  int lateDoses,  double adherencePercentage,  int currentStreak,  int longestStreak,  DateTime? lastDoseTime,  DateTime? nextDoseTime,  Map<String, int> weeklyStats,  Map<String, double> monthlyTrends)  $default,) {final _that = this;
switch (_that) {
case _AdherenceStatistics():
return $default(_that.medicationId,_that.totalDoses,_that.takenDoses,_that.missedDoses,_that.skippedDoses,_that.lateDoses,_that.adherencePercentage,_that.currentStreak,_that.longestStreak,_that.lastDoseTime,_that.nextDoseTime,_that.weeklyStats,_that.monthlyTrends);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  int totalDoses,  int takenDoses,  int missedDoses,  int skippedDoses,  int lateDoses,  double adherencePercentage,  int currentStreak,  int longestStreak,  DateTime? lastDoseTime,  DateTime? nextDoseTime,  Map<String, int> weeklyStats,  Map<String, double> monthlyTrends)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceStatistics() when $default != null:
return $default(_that.medicationId,_that.totalDoses,_that.takenDoses,_that.missedDoses,_that.skippedDoses,_that.lateDoses,_that.adherencePercentage,_that.currentStreak,_that.longestStreak,_that.lastDoseTime,_that.nextDoseTime,_that.weeklyStats,_that.monthlyTrends);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceStatistics implements AdherenceStatistics {
  const _AdherenceStatistics({required this.medicationId, required this.totalDoses, required this.takenDoses, required this.missedDoses, required this.skippedDoses, required this.lateDoses, required this.adherencePercentage, required this.currentStreak, required this.longestStreak, required this.lastDoseTime, required this.nextDoseTime, final  Map<String, int> weeklyStats = const {}, final  Map<String, double> monthlyTrends = const {}}): _weeklyStats = weeklyStats,_monthlyTrends = monthlyTrends;
  factory _AdherenceStatistics.fromJson(Map<String, dynamic> json) => _$AdherenceStatisticsFromJson(json);

@override final  String medicationId;
@override final  int totalDoses;
@override final  int takenDoses;
@override final  int missedDoses;
@override final  int skippedDoses;
@override final  int lateDoses;
@override final  double adherencePercentage;
@override final  int currentStreak;
@override final  int longestStreak;
@override final  DateTime? lastDoseTime;
@override final  DateTime? nextDoseTime;
 final  Map<String, int> _weeklyStats;
@override@JsonKey() Map<String, int> get weeklyStats {
  if (_weeklyStats is EqualUnmodifiableMapView) return _weeklyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_weeklyStats);
}

 final  Map<String, double> _monthlyTrends;
@override@JsonKey() Map<String, double> get monthlyTrends {
  if (_monthlyTrends is EqualUnmodifiableMapView) return _monthlyTrends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monthlyTrends);
}


/// Create a copy of AdherenceStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceStatisticsCopyWith<_AdherenceStatistics> get copyWith => __$AdherenceStatisticsCopyWithImpl<_AdherenceStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceStatistics&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.takenDoses, takenDoses) || other.takenDoses == takenDoses)&&(identical(other.missedDoses, missedDoses) || other.missedDoses == missedDoses)&&(identical(other.skippedDoses, skippedDoses) || other.skippedDoses == skippedDoses)&&(identical(other.lateDoses, lateDoses) || other.lateDoses == lateDoses)&&(identical(other.adherencePercentage, adherencePercentage) || other.adherencePercentage == adherencePercentage)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastDoseTime, lastDoseTime) || other.lastDoseTime == lastDoseTime)&&(identical(other.nextDoseTime, nextDoseTime) || other.nextDoseTime == nextDoseTime)&&const DeepCollectionEquality().equals(other._weeklyStats, _weeklyStats)&&const DeepCollectionEquality().equals(other._monthlyTrends, _monthlyTrends));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,totalDoses,takenDoses,missedDoses,skippedDoses,lateDoses,adherencePercentage,currentStreak,longestStreak,lastDoseTime,nextDoseTime,const DeepCollectionEquality().hash(_weeklyStats),const DeepCollectionEquality().hash(_monthlyTrends));

@override
String toString() {
  return 'AdherenceStatistics(medicationId: $medicationId, totalDoses: $totalDoses, takenDoses: $takenDoses, missedDoses: $missedDoses, skippedDoses: $skippedDoses, lateDoses: $lateDoses, adherencePercentage: $adherencePercentage, currentStreak: $currentStreak, longestStreak: $longestStreak, lastDoseTime: $lastDoseTime, nextDoseTime: $nextDoseTime, weeklyStats: $weeklyStats, monthlyTrends: $monthlyTrends)';
}


}

/// @nodoc
abstract mixin class _$AdherenceStatisticsCopyWith<$Res> implements $AdherenceStatisticsCopyWith<$Res> {
  factory _$AdherenceStatisticsCopyWith(_AdherenceStatistics value, $Res Function(_AdherenceStatistics) _then) = __$AdherenceStatisticsCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, int totalDoses, int takenDoses, int missedDoses, int skippedDoses, int lateDoses, double adherencePercentage, int currentStreak, int longestStreak, DateTime? lastDoseTime, DateTime? nextDoseTime, Map<String, int> weeklyStats, Map<String, double> monthlyTrends
});




}
/// @nodoc
class __$AdherenceStatisticsCopyWithImpl<$Res>
    implements _$AdherenceStatisticsCopyWith<$Res> {
  __$AdherenceStatisticsCopyWithImpl(this._self, this._then);

  final _AdherenceStatistics _self;
  final $Res Function(_AdherenceStatistics) _then;

/// Create a copy of AdherenceStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? totalDoses = null,Object? takenDoses = null,Object? missedDoses = null,Object? skippedDoses = null,Object? lateDoses = null,Object? adherencePercentage = null,Object? currentStreak = null,Object? longestStreak = null,Object? lastDoseTime = freezed,Object? nextDoseTime = freezed,Object? weeklyStats = null,Object? monthlyTrends = null,}) {
  return _then(_AdherenceStatistics(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,takenDoses: null == takenDoses ? _self.takenDoses : takenDoses // ignore: cast_nullable_to_non_nullable
as int,missedDoses: null == missedDoses ? _self.missedDoses : missedDoses // ignore: cast_nullable_to_non_nullable
as int,skippedDoses: null == skippedDoses ? _self.skippedDoses : skippedDoses // ignore: cast_nullable_to_non_nullable
as int,lateDoses: null == lateDoses ? _self.lateDoses : lateDoses // ignore: cast_nullable_to_non_nullable
as int,adherencePercentage: null == adherencePercentage ? _self.adherencePercentage : adherencePercentage // ignore: cast_nullable_to_non_nullable
as double,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastDoseTime: freezed == lastDoseTime ? _self.lastDoseTime : lastDoseTime // ignore: cast_nullable_to_non_nullable
as DateTime?,nextDoseTime: freezed == nextDoseTime ? _self.nextDoseTime : nextDoseTime // ignore: cast_nullable_to_non_nullable
as DateTime?,weeklyStats: null == weeklyStats ? _self._weeklyStats : weeklyStats // ignore: cast_nullable_to_non_nullable
as Map<String, int>,monthlyTrends: null == monthlyTrends ? _self._monthlyTrends : monthlyTrends // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}


/// @nodoc
mixin _$AdherenceTrendPoint {

 DateTime get date; double get adherenceRate; int get totalDoses; int get completedDoses;
/// Create a copy of AdherenceTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceTrendPointCopyWith<AdherenceTrendPoint> get copyWith => _$AdherenceTrendPointCopyWithImpl<AdherenceTrendPoint>(this as AdherenceTrendPoint, _$identity);

  /// Serializes this AdherenceTrendPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceTrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.adherenceRate, adherenceRate) || other.adherenceRate == adherenceRate)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.completedDoses, completedDoses) || other.completedDoses == completedDoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,adherenceRate,totalDoses,completedDoses);

@override
String toString() {
  return 'AdherenceTrendPoint(date: $date, adherenceRate: $adherenceRate, totalDoses: $totalDoses, completedDoses: $completedDoses)';
}


}

/// @nodoc
abstract mixin class $AdherenceTrendPointCopyWith<$Res>  {
  factory $AdherenceTrendPointCopyWith(AdherenceTrendPoint value, $Res Function(AdherenceTrendPoint) _then) = _$AdherenceTrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double adherenceRate, int totalDoses, int completedDoses
});




}
/// @nodoc
class _$AdherenceTrendPointCopyWithImpl<$Res>
    implements $AdherenceTrendPointCopyWith<$Res> {
  _$AdherenceTrendPointCopyWithImpl(this._self, this._then);

  final AdherenceTrendPoint _self;
  final $Res Function(AdherenceTrendPoint) _then;

/// Create a copy of AdherenceTrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? adherenceRate = null,Object? totalDoses = null,Object? completedDoses = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,adherenceRate: null == adherenceRate ? _self.adherenceRate : adherenceRate // ignore: cast_nullable_to_non_nullable
as double,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,completedDoses: null == completedDoses ? _self.completedDoses : completedDoses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceTrendPoint].
extension AdherenceTrendPointPatterns on AdherenceTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceTrendPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double adherenceRate,  int totalDoses,  int completedDoses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceTrendPoint() when $default != null:
return $default(_that.date,_that.adherenceRate,_that.totalDoses,_that.completedDoses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double adherenceRate,  int totalDoses,  int completedDoses)  $default,) {final _that = this;
switch (_that) {
case _AdherenceTrendPoint():
return $default(_that.date,_that.adherenceRate,_that.totalDoses,_that.completedDoses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double adherenceRate,  int totalDoses,  int completedDoses)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceTrendPoint() when $default != null:
return $default(_that.date,_that.adherenceRate,_that.totalDoses,_that.completedDoses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceTrendPoint implements AdherenceTrendPoint {
  const _AdherenceTrendPoint({required this.date, required this.adherenceRate, required this.totalDoses, required this.completedDoses});
  factory _AdherenceTrendPoint.fromJson(Map<String, dynamic> json) => _$AdherenceTrendPointFromJson(json);

@override final  DateTime date;
@override final  double adherenceRate;
@override final  int totalDoses;
@override final  int completedDoses;

/// Create a copy of AdherenceTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceTrendPointCopyWith<_AdherenceTrendPoint> get copyWith => __$AdherenceTrendPointCopyWithImpl<_AdherenceTrendPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceTrendPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceTrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.adherenceRate, adherenceRate) || other.adherenceRate == adherenceRate)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.completedDoses, completedDoses) || other.completedDoses == completedDoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,adherenceRate,totalDoses,completedDoses);

@override
String toString() {
  return 'AdherenceTrendPoint(date: $date, adherenceRate: $adherenceRate, totalDoses: $totalDoses, completedDoses: $completedDoses)';
}


}

/// @nodoc
abstract mixin class _$AdherenceTrendPointCopyWith<$Res> implements $AdherenceTrendPointCopyWith<$Res> {
  factory _$AdherenceTrendPointCopyWith(_AdherenceTrendPoint value, $Res Function(_AdherenceTrendPoint) _then) = __$AdherenceTrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double adherenceRate, int totalDoses, int completedDoses
});




}
/// @nodoc
class __$AdherenceTrendPointCopyWithImpl<$Res>
    implements _$AdherenceTrendPointCopyWith<$Res> {
  __$AdherenceTrendPointCopyWithImpl(this._self, this._then);

  final _AdherenceTrendPoint _self;
  final $Res Function(_AdherenceTrendPoint) _then;

/// Create a copy of AdherenceTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? adherenceRate = null,Object? totalDoses = null,Object? completedDoses = null,}) {
  return _then(_AdherenceTrendPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,adherenceRate: null == adherenceRate ? _self.adherenceRate : adherenceRate // ignore: cast_nullable_to_non_nullable
as double,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,completedDoses: null == completedDoses ? _self.completedDoses : completedDoses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdherenceReport {

 String get userId; DateTime get startDate; DateTime get endDate; AdherenceStatistics get overallStats; List<AdherenceStatistics> get medicationStats; List<AdherenceTrendPoint> get trendData; List<AdherenceRecord> get recentRecords;
/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceReportCopyWith<AdherenceReport> get copyWith => _$AdherenceReportCopyWithImpl<AdherenceReport>(this as AdherenceReport, _$identity);

  /// Serializes this AdherenceReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats)&&const DeepCollectionEquality().equals(other.medicationStats, medicationStats)&&const DeepCollectionEquality().equals(other.trendData, trendData)&&const DeepCollectionEquality().equals(other.recentRecords, recentRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,startDate,endDate,overallStats,const DeepCollectionEquality().hash(medicationStats),const DeepCollectionEquality().hash(trendData),const DeepCollectionEquality().hash(recentRecords));

@override
String toString() {
  return 'AdherenceReport(userId: $userId, startDate: $startDate, endDate: $endDate, overallStats: $overallStats, medicationStats: $medicationStats, trendData: $trendData, recentRecords: $recentRecords)';
}


}

/// @nodoc
abstract mixin class $AdherenceReportCopyWith<$Res>  {
  factory $AdherenceReportCopyWith(AdherenceReport value, $Res Function(AdherenceReport) _then) = _$AdherenceReportCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime startDate, DateTime endDate, AdherenceStatistics overallStats, List<AdherenceStatistics> medicationStats, List<AdherenceTrendPoint> trendData, List<AdherenceRecord> recentRecords
});


$AdherenceStatisticsCopyWith<$Res> get overallStats;

}
/// @nodoc
class _$AdherenceReportCopyWithImpl<$Res>
    implements $AdherenceReportCopyWith<$Res> {
  _$AdherenceReportCopyWithImpl(this._self, this._then);

  final AdherenceReport _self;
  final $Res Function(AdherenceReport) _then;

/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? startDate = null,Object? endDate = null,Object? overallStats = null,Object? medicationStats = null,Object? trendData = null,Object? recentRecords = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as AdherenceStatistics,medicationStats: null == medicationStats ? _self.medicationStats : medicationStats // ignore: cast_nullable_to_non_nullable
as List<AdherenceStatistics>,trendData: null == trendData ? _self.trendData : trendData // ignore: cast_nullable_to_non_nullable
as List<AdherenceTrendPoint>,recentRecords: null == recentRecords ? _self.recentRecords : recentRecords // ignore: cast_nullable_to_non_nullable
as List<AdherenceRecord>,
  ));
}
/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceStatisticsCopyWith<$Res> get overallStats {
  
  return $AdherenceStatisticsCopyWith<$Res>(_self.overallStats, (value) {
    return _then(_self.copyWith(overallStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdherenceReport].
extension AdherenceReportPatterns on AdherenceReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceReport value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceReport value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime startDate,  DateTime endDate,  AdherenceStatistics overallStats,  List<AdherenceStatistics> medicationStats,  List<AdherenceTrendPoint> trendData,  List<AdherenceRecord> recentRecords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceReport() when $default != null:
return $default(_that.userId,_that.startDate,_that.endDate,_that.overallStats,_that.medicationStats,_that.trendData,_that.recentRecords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime startDate,  DateTime endDate,  AdherenceStatistics overallStats,  List<AdherenceStatistics> medicationStats,  List<AdherenceTrendPoint> trendData,  List<AdherenceRecord> recentRecords)  $default,) {final _that = this;
switch (_that) {
case _AdherenceReport():
return $default(_that.userId,_that.startDate,_that.endDate,_that.overallStats,_that.medicationStats,_that.trendData,_that.recentRecords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime startDate,  DateTime endDate,  AdherenceStatistics overallStats,  List<AdherenceStatistics> medicationStats,  List<AdherenceTrendPoint> trendData,  List<AdherenceRecord> recentRecords)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceReport() when $default != null:
return $default(_that.userId,_that.startDate,_that.endDate,_that.overallStats,_that.medicationStats,_that.trendData,_that.recentRecords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceReport implements AdherenceReport {
  const _AdherenceReport({required this.userId, required this.startDate, required this.endDate, required this.overallStats, final  List<AdherenceStatistics> medicationStats = const [], final  List<AdherenceTrendPoint> trendData = const [], final  List<AdherenceRecord> recentRecords = const []}): _medicationStats = medicationStats,_trendData = trendData,_recentRecords = recentRecords;
  factory _AdherenceReport.fromJson(Map<String, dynamic> json) => _$AdherenceReportFromJson(json);

@override final  String userId;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  AdherenceStatistics overallStats;
 final  List<AdherenceStatistics> _medicationStats;
@override@JsonKey() List<AdherenceStatistics> get medicationStats {
  if (_medicationStats is EqualUnmodifiableListView) return _medicationStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicationStats);
}

 final  List<AdherenceTrendPoint> _trendData;
@override@JsonKey() List<AdherenceTrendPoint> get trendData {
  if (_trendData is EqualUnmodifiableListView) return _trendData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trendData);
}

 final  List<AdherenceRecord> _recentRecords;
@override@JsonKey() List<AdherenceRecord> get recentRecords {
  if (_recentRecords is EqualUnmodifiableListView) return _recentRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentRecords);
}


/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceReportCopyWith<_AdherenceReport> get copyWith => __$AdherenceReportCopyWithImpl<_AdherenceReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceReport&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats)&&const DeepCollectionEquality().equals(other._medicationStats, _medicationStats)&&const DeepCollectionEquality().equals(other._trendData, _trendData)&&const DeepCollectionEquality().equals(other._recentRecords, _recentRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,startDate,endDate,overallStats,const DeepCollectionEquality().hash(_medicationStats),const DeepCollectionEquality().hash(_trendData),const DeepCollectionEquality().hash(_recentRecords));

@override
String toString() {
  return 'AdherenceReport(userId: $userId, startDate: $startDate, endDate: $endDate, overallStats: $overallStats, medicationStats: $medicationStats, trendData: $trendData, recentRecords: $recentRecords)';
}


}

/// @nodoc
abstract mixin class _$AdherenceReportCopyWith<$Res> implements $AdherenceReportCopyWith<$Res> {
  factory _$AdherenceReportCopyWith(_AdherenceReport value, $Res Function(_AdherenceReport) _then) = __$AdherenceReportCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime startDate, DateTime endDate, AdherenceStatistics overallStats, List<AdherenceStatistics> medicationStats, List<AdherenceTrendPoint> trendData, List<AdherenceRecord> recentRecords
});


@override $AdherenceStatisticsCopyWith<$Res> get overallStats;

}
/// @nodoc
class __$AdherenceReportCopyWithImpl<$Res>
    implements _$AdherenceReportCopyWith<$Res> {
  __$AdherenceReportCopyWithImpl(this._self, this._then);

  final _AdherenceReport _self;
  final $Res Function(_AdherenceReport) _then;

/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? startDate = null,Object? endDate = null,Object? overallStats = null,Object? medicationStats = null,Object? trendData = null,Object? recentRecords = null,}) {
  return _then(_AdherenceReport(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as AdherenceStatistics,medicationStats: null == medicationStats ? _self._medicationStats : medicationStats // ignore: cast_nullable_to_non_nullable
as List<AdherenceStatistics>,trendData: null == trendData ? _self._trendData : trendData // ignore: cast_nullable_to_non_nullable
as List<AdherenceTrendPoint>,recentRecords: null == recentRecords ? _self._recentRecords : recentRecords // ignore: cast_nullable_to_non_nullable
as List<AdherenceRecord>,
  ));
}

/// Create a copy of AdherenceReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceStatisticsCopyWith<$Res> get overallStats {
  
  return $AdherenceStatisticsCopyWith<$Res>(_self.overallStats, (value) {
    return _then(_self.copyWith(overallStats: value));
  });
}
}


/// @nodoc
mixin _$AdherenceQueryParams {

 String? get medicationId; String? get scheduleId; DoseStatus? get status; DateTime? get startDate; DateTime? get endDate; int get limit; int get offset; String get sortBy; String get sortOrder;
/// Create a copy of AdherenceQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceQueryParamsCopyWith<AdherenceQueryParams> get copyWith => _$AdherenceQueryParamsCopyWithImpl<AdherenceQueryParams>(this as AdherenceQueryParams, _$identity);

  /// Serializes this AdherenceQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,status,startDate,endDate,limit,offset,sortBy,sortOrder);

@override
String toString() {
  return 'AdherenceQueryParams(medicationId: $medicationId, scheduleId: $scheduleId, status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset, sortBy: $sortBy, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $AdherenceQueryParamsCopyWith<$Res>  {
  factory $AdherenceQueryParamsCopyWith(AdherenceQueryParams value, $Res Function(AdherenceQueryParams) _then) = _$AdherenceQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? medicationId, String? scheduleId, DoseStatus? status, DateTime? startDate, DateTime? endDate, int limit, int offset, String sortBy, String sortOrder
});




}
/// @nodoc
class _$AdherenceQueryParamsCopyWithImpl<$Res>
    implements $AdherenceQueryParamsCopyWith<$Res> {
  _$AdherenceQueryParamsCopyWithImpl(this._self, this._then);

  final AdherenceQueryParams _self;
  final $Res Function(AdherenceQueryParams) _then;

/// Create a copy of AdherenceQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = freezed,Object? scheduleId = freezed,Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = null,Object? offset = null,Object? sortBy = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceQueryParams].
extension AdherenceQueryParamsPatterns on AdherenceQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int limit,  int offset,  String sortBy,  String sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int limit,  int offset,  String sortBy,  String sortOrder)  $default,) {final _that = this;
switch (_that) {
case _AdherenceQueryParams():
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int limit,  int offset,  String sortBy,  String sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceQueryParams implements AdherenceQueryParams {
  const _AdherenceQueryParams({this.medicationId, this.scheduleId, this.status, this.startDate, this.endDate, this.limit = 50, this.offset = 0, this.sortBy = 'scheduledTime', this.sortOrder = 'desc'});
  factory _AdherenceQueryParams.fromJson(Map<String, dynamic> json) => _$AdherenceQueryParamsFromJson(json);

@override final  String? medicationId;
@override final  String? scheduleId;
@override final  DoseStatus? status;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override@JsonKey() final  int limit;
@override@JsonKey() final  int offset;
@override@JsonKey() final  String sortBy;
@override@JsonKey() final  String sortOrder;

/// Create a copy of AdherenceQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceQueryParamsCopyWith<_AdherenceQueryParams> get copyWith => __$AdherenceQueryParamsCopyWithImpl<_AdherenceQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,status,startDate,endDate,limit,offset,sortBy,sortOrder);

@override
String toString() {
  return 'AdherenceQueryParams(medicationId: $medicationId, scheduleId: $scheduleId, status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset, sortBy: $sortBy, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$AdherenceQueryParamsCopyWith<$Res> implements $AdherenceQueryParamsCopyWith<$Res> {
  factory _$AdherenceQueryParamsCopyWith(_AdherenceQueryParams value, $Res Function(_AdherenceQueryParams) _then) = __$AdherenceQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? medicationId, String? scheduleId, DoseStatus? status, DateTime? startDate, DateTime? endDate, int limit, int offset, String sortBy, String sortOrder
});




}
/// @nodoc
class __$AdherenceQueryParamsCopyWithImpl<$Res>
    implements _$AdherenceQueryParamsCopyWith<$Res> {
  __$AdherenceQueryParamsCopyWithImpl(this._self, this._then);

  final _AdherenceQueryParams _self;
  final $Res Function(_AdherenceQueryParams) _then;

/// Create a copy of AdherenceQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = freezed,Object? scheduleId = freezed,Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = null,Object? offset = null,Object? sortBy = null,Object? sortOrder = null,}) {
  return _then(_AdherenceQueryParams(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AdherenceRecordResponse {

 bool get success; AdherenceRecord? get data; String? get message; String? get error;
/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceRecordResponseCopyWith<AdherenceRecordResponse> get copyWith => _$AdherenceRecordResponseCopyWithImpl<AdherenceRecordResponse>(this as AdherenceRecordResponse, _$identity);

  /// Serializes this AdherenceRecordResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceRecordResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceRecordResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdherenceRecordResponseCopyWith<$Res>  {
  factory $AdherenceRecordResponseCopyWith(AdherenceRecordResponse value, $Res Function(AdherenceRecordResponse) _then) = _$AdherenceRecordResponseCopyWithImpl;
@useResult
$Res call({
 bool success, AdherenceRecord? data, String? message, String? error
});


$AdherenceRecordCopyWith<$Res>? get data;

}
/// @nodoc
class _$AdherenceRecordResponseCopyWithImpl<$Res>
    implements $AdherenceRecordResponseCopyWith<$Res> {
  _$AdherenceRecordResponseCopyWithImpl(this._self, this._then);

  final AdherenceRecordResponse _self;
  final $Res Function(AdherenceRecordResponse) _then;

/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceRecord?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceRecordCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceRecordCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdherenceRecordResponse].
extension AdherenceRecordResponsePatterns on AdherenceRecordResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceRecordResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceRecordResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceRecordResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecordResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceRecordResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecordResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  AdherenceRecord? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceRecordResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  AdherenceRecord? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecordResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  AdherenceRecord? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecordResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceRecordResponse implements AdherenceRecordResponse {
  const _AdherenceRecordResponse({required this.success, this.data, this.message, this.error});
  factory _AdherenceRecordResponse.fromJson(Map<String, dynamic> json) => _$AdherenceRecordResponseFromJson(json);

@override final  bool success;
@override final  AdherenceRecord? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceRecordResponseCopyWith<_AdherenceRecordResponse> get copyWith => __$AdherenceRecordResponseCopyWithImpl<_AdherenceRecordResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceRecordResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceRecordResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceRecordResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdherenceRecordResponseCopyWith<$Res> implements $AdherenceRecordResponseCopyWith<$Res> {
  factory _$AdherenceRecordResponseCopyWith(_AdherenceRecordResponse value, $Res Function(_AdherenceRecordResponse) _then) = __$AdherenceRecordResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, AdherenceRecord? data, String? message, String? error
});


@override $AdherenceRecordCopyWith<$Res>? get data;

}
/// @nodoc
class __$AdherenceRecordResponseCopyWithImpl<$Res>
    implements _$AdherenceRecordResponseCopyWith<$Res> {
  __$AdherenceRecordResponseCopyWithImpl(this._self, this._then);

  final _AdherenceRecordResponse _self;
  final $Res Function(_AdherenceRecordResponse) _then;

/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_AdherenceRecordResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceRecord?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdherenceRecordResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceRecordCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceRecordCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AdherenceRecordListResponse {

 bool get success; List<AdherenceRecord> get data; int? get count; int? get total; String? get message; String? get error;
/// Create a copy of AdherenceRecordListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceRecordListResponseCopyWith<AdherenceRecordListResponse> get copyWith => _$AdherenceRecordListResponseCopyWithImpl<AdherenceRecordListResponse>(this as AdherenceRecordListResponse, _$identity);

  /// Serializes this AdherenceRecordListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceRecordListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,total,message,error);

@override
String toString() {
  return 'AdherenceRecordListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdherenceRecordListResponseCopyWith<$Res>  {
  factory $AdherenceRecordListResponseCopyWith(AdherenceRecordListResponse value, $Res Function(AdherenceRecordListResponse) _then) = _$AdherenceRecordListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<AdherenceRecord> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class _$AdherenceRecordListResponseCopyWithImpl<$Res>
    implements $AdherenceRecordListResponseCopyWith<$Res> {
  _$AdherenceRecordListResponseCopyWithImpl(this._self, this._then);

  final AdherenceRecordListResponse _self;
  final $Res Function(AdherenceRecordListResponse) _then;

/// Create a copy of AdherenceRecordListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<AdherenceRecord>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceRecordListResponse].
extension AdherenceRecordListResponsePatterns on AdherenceRecordListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceRecordListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceRecordListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceRecordListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecordListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceRecordListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecordListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<AdherenceRecord> data,  int? count,  int? total,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceRecordListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<AdherenceRecord> data,  int? count,  int? total,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecordListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<AdherenceRecord> data,  int? count,  int? total,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecordListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceRecordListResponse implements AdherenceRecordListResponse {
  const _AdherenceRecordListResponse({required this.success, final  List<AdherenceRecord> data = const [], this.count, this.total, this.message, this.error}): _data = data;
  factory _AdherenceRecordListResponse.fromJson(Map<String, dynamic> json) => _$AdherenceRecordListResponseFromJson(json);

@override final  bool success;
 final  List<AdherenceRecord> _data;
@override@JsonKey() List<AdherenceRecord> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  int? total;
@override final  String? message;
@override final  String? error;

/// Create a copy of AdherenceRecordListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceRecordListResponseCopyWith<_AdherenceRecordListResponse> get copyWith => __$AdherenceRecordListResponseCopyWithImpl<_AdherenceRecordListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceRecordListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceRecordListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,total,message,error);

@override
String toString() {
  return 'AdherenceRecordListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdherenceRecordListResponseCopyWith<$Res> implements $AdherenceRecordListResponseCopyWith<$Res> {
  factory _$AdherenceRecordListResponseCopyWith(_AdherenceRecordListResponse value, $Res Function(_AdherenceRecordListResponse) _then) = __$AdherenceRecordListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<AdherenceRecord> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class __$AdherenceRecordListResponseCopyWithImpl<$Res>
    implements _$AdherenceRecordListResponseCopyWith<$Res> {
  __$AdherenceRecordListResponseCopyWithImpl(this._self, this._then);

  final _AdherenceRecordListResponse _self;
  final $Res Function(_AdherenceRecordListResponse) _then;

/// Create a copy of AdherenceRecordListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_AdherenceRecordListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<AdherenceRecord>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdherenceStatisticsResponse {

 bool get success; AdherenceStatistics? get data; String? get message; String? get error;
/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceStatisticsResponseCopyWith<AdherenceStatisticsResponse> get copyWith => _$AdherenceStatisticsResponseCopyWithImpl<AdherenceStatisticsResponse>(this as AdherenceStatisticsResponse, _$identity);

  /// Serializes this AdherenceStatisticsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceStatisticsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceStatisticsResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdherenceStatisticsResponseCopyWith<$Res>  {
  factory $AdherenceStatisticsResponseCopyWith(AdherenceStatisticsResponse value, $Res Function(AdherenceStatisticsResponse) _then) = _$AdherenceStatisticsResponseCopyWithImpl;
@useResult
$Res call({
 bool success, AdherenceStatistics? data, String? message, String? error
});


$AdherenceStatisticsCopyWith<$Res>? get data;

}
/// @nodoc
class _$AdherenceStatisticsResponseCopyWithImpl<$Res>
    implements $AdherenceStatisticsResponseCopyWith<$Res> {
  _$AdherenceStatisticsResponseCopyWithImpl(this._self, this._then);

  final AdherenceStatisticsResponse _self;
  final $Res Function(AdherenceStatisticsResponse) _then;

/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceStatistics?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceStatisticsCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceStatisticsCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdherenceStatisticsResponse].
extension AdherenceStatisticsResponsePatterns on AdherenceStatisticsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceStatisticsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceStatisticsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceStatisticsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  AdherenceStatistics? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  AdherenceStatistics? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  AdherenceStatistics? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceStatisticsResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceStatisticsResponse implements AdherenceStatisticsResponse {
  const _AdherenceStatisticsResponse({required this.success, this.data, this.message, this.error});
  factory _AdherenceStatisticsResponse.fromJson(Map<String, dynamic> json) => _$AdherenceStatisticsResponseFromJson(json);

@override final  bool success;
@override final  AdherenceStatistics? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceStatisticsResponseCopyWith<_AdherenceStatisticsResponse> get copyWith => __$AdherenceStatisticsResponseCopyWithImpl<_AdherenceStatisticsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceStatisticsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceStatisticsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceStatisticsResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdherenceStatisticsResponseCopyWith<$Res> implements $AdherenceStatisticsResponseCopyWith<$Res> {
  factory _$AdherenceStatisticsResponseCopyWith(_AdherenceStatisticsResponse value, $Res Function(_AdherenceStatisticsResponse) _then) = __$AdherenceStatisticsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, AdherenceStatistics? data, String? message, String? error
});


@override $AdherenceStatisticsCopyWith<$Res>? get data;

}
/// @nodoc
class __$AdherenceStatisticsResponseCopyWithImpl<$Res>
    implements _$AdherenceStatisticsResponseCopyWith<$Res> {
  __$AdherenceStatisticsResponseCopyWithImpl(this._self, this._then);

  final _AdherenceStatisticsResponse _self;
  final $Res Function(_AdherenceStatisticsResponse) _then;

/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_AdherenceStatisticsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceStatistics?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdherenceStatisticsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceStatisticsCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceStatisticsCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AdherenceReportResponse {

 bool get success; AdherenceReport? get data; String? get message; String? get error;
/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceReportResponseCopyWith<AdherenceReportResponse> get copyWith => _$AdherenceReportResponseCopyWithImpl<AdherenceReportResponse>(this as AdherenceReportResponse, _$identity);

  /// Serializes this AdherenceReportResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceReportResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceReportResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdherenceReportResponseCopyWith<$Res>  {
  factory $AdherenceReportResponseCopyWith(AdherenceReportResponse value, $Res Function(AdherenceReportResponse) _then) = _$AdherenceReportResponseCopyWithImpl;
@useResult
$Res call({
 bool success, AdherenceReport? data, String? message, String? error
});


$AdherenceReportCopyWith<$Res>? get data;

}
/// @nodoc
class _$AdherenceReportResponseCopyWithImpl<$Res>
    implements $AdherenceReportResponseCopyWith<$Res> {
  _$AdherenceReportResponseCopyWithImpl(this._self, this._then);

  final AdherenceReportResponse _self;
  final $Res Function(AdherenceReportResponse) _then;

/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceReport?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceReportCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceReportCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdherenceReportResponse].
extension AdherenceReportResponsePatterns on AdherenceReportResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceReportResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceReportResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceReportResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceReportResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceReportResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceReportResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  AdherenceReport? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceReportResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  AdherenceReport? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdherenceReportResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  AdherenceReport? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceReportResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceReportResponse implements AdherenceReportResponse {
  const _AdherenceReportResponse({required this.success, this.data, this.message, this.error});
  factory _AdherenceReportResponse.fromJson(Map<String, dynamic> json) => _$AdherenceReportResponseFromJson(json);

@override final  bool success;
@override final  AdherenceReport? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceReportResponseCopyWith<_AdherenceReportResponse> get copyWith => __$AdherenceReportResponseCopyWithImpl<_AdherenceReportResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceReportResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceReportResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'AdherenceReportResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdherenceReportResponseCopyWith<$Res> implements $AdherenceReportResponseCopyWith<$Res> {
  factory _$AdherenceReportResponseCopyWith(_AdherenceReportResponse value, $Res Function(_AdherenceReportResponse) _then) = __$AdherenceReportResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, AdherenceReport? data, String? message, String? error
});


@override $AdherenceReportCopyWith<$Res>? get data;

}
/// @nodoc
class __$AdherenceReportResponseCopyWithImpl<$Res>
    implements _$AdherenceReportResponseCopyWith<$Res> {
  __$AdherenceReportResponseCopyWithImpl(this._self, this._then);

  final _AdherenceReportResponse _self;
  final $Res Function(_AdherenceReportResponse) _then;

/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_AdherenceReportResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AdherenceReport?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdherenceReportResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceReportCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $AdherenceReportCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
