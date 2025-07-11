// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthMetric {

 String get id; String get userId; HealthMetricType get metricType; double get value; String get unit; DateTime get timestamp; DataSource get source; String? get deviceId; String? get notes; bool get isManualEntry; ValidationStatus get validationStatus; Map<String, dynamic> get metadata; DateTime get createdAt;
/// Create a copy of HealthMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthMetricCopyWith<HealthMetric> get copyWith => _$HealthMetricCopyWithImpl<HealthMetric>(this as HealthMetric, _$identity);

  /// Serializes this HealthMetric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthMetric&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.source, source) || other.source == source)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isManualEntry, isManualEntry) || other.isManualEntry == isManualEntry)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,metricType,value,unit,timestamp,source,deviceId,notes,isManualEntry,validationStatus,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'HealthMetric(id: $id, userId: $userId, metricType: $metricType, value: $value, unit: $unit, timestamp: $timestamp, source: $source, deviceId: $deviceId, notes: $notes, isManualEntry: $isManualEntry, validationStatus: $validationStatus, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $HealthMetricCopyWith<$Res>  {
  factory $HealthMetricCopyWith(HealthMetric value, $Res Function(HealthMetric) _then) = _$HealthMetricCopyWithImpl;
@useResult
$Res call({
 String id, String userId, HealthMetricType metricType, double value, String unit, DateTime timestamp, DataSource source, String? deviceId, String? notes, bool isManualEntry, ValidationStatus validationStatus, Map<String, dynamic> metadata, DateTime createdAt
});




}
/// @nodoc
class _$HealthMetricCopyWithImpl<$Res>
    implements $HealthMetricCopyWith<$Res> {
  _$HealthMetricCopyWithImpl(this._self, this._then);

  final HealthMetric _self;
  final $Res Function(HealthMetric) _then;

/// Create a copy of HealthMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? metricType = null,Object? value = null,Object? unit = null,Object? timestamp = null,Object? source = null,Object? deviceId = freezed,Object? notes = freezed,Object? isManualEntry = null,Object? validationStatus = null,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as HealthMetricType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isManualEntry: null == isManualEntry ? _self.isManualEntry : isManualEntry // ignore: cast_nullable_to_non_nullable
as bool,validationStatus: null == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as ValidationStatus,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthMetric].
extension HealthMetricPatterns on HealthMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthMetric value)  $default,){
final _that = this;
switch (_that) {
case _HealthMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthMetric value)?  $default,){
final _that = this;
switch (_that) {
case _HealthMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  HealthMetricType metricType,  double value,  String unit,  DateTime timestamp,  DataSource source,  String? deviceId,  String? notes,  bool isManualEntry,  ValidationStatus validationStatus,  Map<String, dynamic> metadata,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthMetric() when $default != null:
return $default(_that.id,_that.userId,_that.metricType,_that.value,_that.unit,_that.timestamp,_that.source,_that.deviceId,_that.notes,_that.isManualEntry,_that.validationStatus,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  HealthMetricType metricType,  double value,  String unit,  DateTime timestamp,  DataSource source,  String? deviceId,  String? notes,  bool isManualEntry,  ValidationStatus validationStatus,  Map<String, dynamic> metadata,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _HealthMetric():
return $default(_that.id,_that.userId,_that.metricType,_that.value,_that.unit,_that.timestamp,_that.source,_that.deviceId,_that.notes,_that.isManualEntry,_that.validationStatus,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  HealthMetricType metricType,  double value,  String unit,  DateTime timestamp,  DataSource source,  String? deviceId,  String? notes,  bool isManualEntry,  ValidationStatus validationStatus,  Map<String, dynamic> metadata,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _HealthMetric() when $default != null:
return $default(_that.id,_that.userId,_that.metricType,_that.value,_that.unit,_that.timestamp,_that.source,_that.deviceId,_that.notes,_that.isManualEntry,_that.validationStatus,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthMetric implements HealthMetric {
  const _HealthMetric({required this.id, required this.userId, required this.metricType, required this.value, required this.unit, required this.timestamp, required this.source, this.deviceId, this.notes, required this.isManualEntry, required this.validationStatus, final  Map<String, dynamic> metadata = const {}, required this.createdAt}): _metadata = metadata;
  factory _HealthMetric.fromJson(Map<String, dynamic> json) => _$HealthMetricFromJson(json);

@override final  String id;
@override final  String userId;
@override final  HealthMetricType metricType;
@override final  double value;
@override final  String unit;
@override final  DateTime timestamp;
@override final  DataSource source;
@override final  String? deviceId;
@override final  String? notes;
@override final  bool isManualEntry;
@override final  ValidationStatus validationStatus;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override final  DateTime createdAt;

/// Create a copy of HealthMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthMetricCopyWith<_HealthMetric> get copyWith => __$HealthMetricCopyWithImpl<_HealthMetric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthMetricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthMetric&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.source, source) || other.source == source)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isManualEntry, isManualEntry) || other.isManualEntry == isManualEntry)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,metricType,value,unit,timestamp,source,deviceId,notes,isManualEntry,validationStatus,const DeepCollectionEquality().hash(_metadata),createdAt);

@override
String toString() {
  return 'HealthMetric(id: $id, userId: $userId, metricType: $metricType, value: $value, unit: $unit, timestamp: $timestamp, source: $source, deviceId: $deviceId, notes: $notes, isManualEntry: $isManualEntry, validationStatus: $validationStatus, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HealthMetricCopyWith<$Res> implements $HealthMetricCopyWith<$Res> {
  factory _$HealthMetricCopyWith(_HealthMetric value, $Res Function(_HealthMetric) _then) = __$HealthMetricCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, HealthMetricType metricType, double value, String unit, DateTime timestamp, DataSource source, String? deviceId, String? notes, bool isManualEntry, ValidationStatus validationStatus, Map<String, dynamic> metadata, DateTime createdAt
});




}
/// @nodoc
class __$HealthMetricCopyWithImpl<$Res>
    implements _$HealthMetricCopyWith<$Res> {
  __$HealthMetricCopyWithImpl(this._self, this._then);

  final _HealthMetric _self;
  final $Res Function(_HealthMetric) _then;

/// Create a copy of HealthMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? metricType = null,Object? value = null,Object? unit = null,Object? timestamp = null,Object? source = null,Object? deviceId = freezed,Object? notes = freezed,Object? isManualEntry = null,Object? validationStatus = null,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_HealthMetric(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as HealthMetricType,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,isManualEntry: null == isManualEntry ? _self.isManualEntry : isManualEntry // ignore: cast_nullable_to_non_nullable
as bool,validationStatus: null == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as ValidationStatus,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
