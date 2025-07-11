// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthDevice {

 String get id; String get userId; DeviceType get deviceType; String get manufacturer; String get model; String? get serialNumber; DateTime get lastSyncTimestamp; ConnectionStatus get connectionStatus; int? get batteryLevel; String? get firmware; Map<String, dynamic> get settings; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of HealthDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDeviceCopyWith<HealthDevice> get copyWith => _$HealthDeviceCopyWithImpl<HealthDevice>(this as HealthDevice, _$identity);

  /// Serializes this HealthDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.firmware, firmware) || other.firmware == firmware)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,deviceType,manufacturer,model,serialNumber,lastSyncTimestamp,connectionStatus,batteryLevel,firmware,const DeepCollectionEquality().hash(settings),createdAt,updatedAt);

@override
String toString() {
  return 'HealthDevice(id: $id, userId: $userId, deviceType: $deviceType, manufacturer: $manufacturer, model: $model, serialNumber: $serialNumber, lastSyncTimestamp: $lastSyncTimestamp, connectionStatus: $connectionStatus, batteryLevel: $batteryLevel, firmware: $firmware, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HealthDeviceCopyWith<$Res>  {
  factory $HealthDeviceCopyWith(HealthDevice value, $Res Function(HealthDevice) _then) = _$HealthDeviceCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DeviceType deviceType, String manufacturer, String model, String? serialNumber, DateTime lastSyncTimestamp, ConnectionStatus connectionStatus, int? batteryLevel, String? firmware, Map<String, dynamic> settings, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$HealthDeviceCopyWithImpl<$Res>
    implements $HealthDeviceCopyWith<$Res> {
  _$HealthDeviceCopyWithImpl(this._self, this._then);

  final HealthDevice _self;
  final $Res Function(HealthDevice) _then;

/// Create a copy of HealthDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? deviceType = null,Object? manufacturer = null,Object? model = null,Object? serialNumber = freezed,Object? lastSyncTimestamp = null,Object? connectionStatus = null,Object? batteryLevel = freezed,Object? firmware = freezed,Object? settings = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,lastSyncTimestamp: null == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,batteryLevel: freezed == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int?,firmware: freezed == firmware ? _self.firmware : firmware // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthDevice].
extension HealthDevicePatterns on HealthDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthDevice value)  $default,){
final _that = this;
switch (_that) {
case _HealthDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthDevice value)?  $default,){
final _that = this;
switch (_that) {
case _HealthDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DeviceType deviceType,  String manufacturer,  String model,  String? serialNumber,  DateTime lastSyncTimestamp,  ConnectionStatus connectionStatus,  int? batteryLevel,  String? firmware,  Map<String, dynamic> settings,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthDevice() when $default != null:
return $default(_that.id,_that.userId,_that.deviceType,_that.manufacturer,_that.model,_that.serialNumber,_that.lastSyncTimestamp,_that.connectionStatus,_that.batteryLevel,_that.firmware,_that.settings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DeviceType deviceType,  String manufacturer,  String model,  String? serialNumber,  DateTime lastSyncTimestamp,  ConnectionStatus connectionStatus,  int? batteryLevel,  String? firmware,  Map<String, dynamic> settings,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HealthDevice():
return $default(_that.id,_that.userId,_that.deviceType,_that.manufacturer,_that.model,_that.serialNumber,_that.lastSyncTimestamp,_that.connectionStatus,_that.batteryLevel,_that.firmware,_that.settings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DeviceType deviceType,  String manufacturer,  String model,  String? serialNumber,  DateTime lastSyncTimestamp,  ConnectionStatus connectionStatus,  int? batteryLevel,  String? firmware,  Map<String, dynamic> settings,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HealthDevice() when $default != null:
return $default(_that.id,_that.userId,_that.deviceType,_that.manufacturer,_that.model,_that.serialNumber,_that.lastSyncTimestamp,_that.connectionStatus,_that.batteryLevel,_that.firmware,_that.settings,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthDevice implements HealthDevice {
  const _HealthDevice({required this.id, required this.userId, required this.deviceType, required this.manufacturer, required this.model, this.serialNumber, required this.lastSyncTimestamp, required this.connectionStatus, this.batteryLevel, this.firmware, final  Map<String, dynamic> settings = const {}, required this.createdAt, required this.updatedAt}): _settings = settings;
  factory _HealthDevice.fromJson(Map<String, dynamic> json) => _$HealthDeviceFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DeviceType deviceType;
@override final  String manufacturer;
@override final  String model;
@override final  String? serialNumber;
@override final  DateTime lastSyncTimestamp;
@override final  ConnectionStatus connectionStatus;
@override final  int? batteryLevel;
@override final  String? firmware;
 final  Map<String, dynamic> _settings;
@override@JsonKey() Map<String, dynamic> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of HealthDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDeviceCopyWith<_HealthDevice> get copyWith => __$HealthDeviceCopyWithImpl<_HealthDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceType, deviceType) || other.deviceType == deviceType)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.lastSyncTimestamp, lastSyncTimestamp) || other.lastSyncTimestamp == lastSyncTimestamp)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.firmware, firmware) || other.firmware == firmware)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,deviceType,manufacturer,model,serialNumber,lastSyncTimestamp,connectionStatus,batteryLevel,firmware,const DeepCollectionEquality().hash(_settings),createdAt,updatedAt);

@override
String toString() {
  return 'HealthDevice(id: $id, userId: $userId, deviceType: $deviceType, manufacturer: $manufacturer, model: $model, serialNumber: $serialNumber, lastSyncTimestamp: $lastSyncTimestamp, connectionStatus: $connectionStatus, batteryLevel: $batteryLevel, firmware: $firmware, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HealthDeviceCopyWith<$Res> implements $HealthDeviceCopyWith<$Res> {
  factory _$HealthDeviceCopyWith(_HealthDevice value, $Res Function(_HealthDevice) _then) = __$HealthDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DeviceType deviceType, String manufacturer, String model, String? serialNumber, DateTime lastSyncTimestamp, ConnectionStatus connectionStatus, int? batteryLevel, String? firmware, Map<String, dynamic> settings, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$HealthDeviceCopyWithImpl<$Res>
    implements _$HealthDeviceCopyWith<$Res> {
  __$HealthDeviceCopyWithImpl(this._self, this._then);

  final _HealthDevice _self;
  final $Res Function(_HealthDevice) _then;

/// Create a copy of HealthDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deviceType = null,Object? manufacturer = null,Object? model = null,Object? serialNumber = freezed,Object? lastSyncTimestamp = null,Object? connectionStatus = null,Object? batteryLevel = freezed,Object? firmware = freezed,Object? settings = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_HealthDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceType: null == deviceType ? _self.deviceType : deviceType // ignore: cast_nullable_to_non_nullable
as DeviceType,manufacturer: null == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,lastSyncTimestamp: null == lastSyncTimestamp ? _self.lastSyncTimestamp : lastSyncTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,batteryLevel: freezed == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int?,firmware: freezed == firmware ? _self.firmware : firmware // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
