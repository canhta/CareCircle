// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateNotificationRequest {

 String get title; String get message; NotificationType get type; NotificationPriority get priority; NotificationChannel get channel; String? get userId; Map<String, dynamic>? get data; DateTime? get scheduledAt; List<String>? get tags;
/// Create a copy of CreateNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateNotificationRequestCopyWith<CreateNotificationRequest> get copyWith => _$CreateNotificationRequestCopyWithImpl<CreateNotificationRequest>(this as CreateNotificationRequest, _$identity);

  /// Serializes this CreateNotificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateNotificationRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,type,priority,channel,userId,const DeepCollectionEquality().hash(data),scheduledAt,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'CreateNotificationRequest(title: $title, message: $message, type: $type, priority: $priority, channel: $channel, userId: $userId, data: $data, scheduledAt: $scheduledAt, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $CreateNotificationRequestCopyWith<$Res>  {
  factory $CreateNotificationRequestCopyWith(CreateNotificationRequest value, $Res Function(CreateNotificationRequest) _then) = _$CreateNotificationRequestCopyWithImpl;
@useResult
$Res call({
 String title, String message, NotificationType type, NotificationPriority priority, NotificationChannel channel, String? userId, Map<String, dynamic>? data, DateTime? scheduledAt, List<String>? tags
});




}
/// @nodoc
class _$CreateNotificationRequestCopyWithImpl<$Res>
    implements $CreateNotificationRequestCopyWith<$Res> {
  _$CreateNotificationRequestCopyWithImpl(this._self, this._then);

  final CreateNotificationRequest _self;
  final $Res Function(CreateNotificationRequest) _then;

/// Create a copy of CreateNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? message = null,Object? type = null,Object? priority = null,Object? channel = null,Object? userId = freezed,Object? data = freezed,Object? scheduledAt = freezed,Object? tags = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateNotificationRequest].
extension CreateNotificationRequestPatterns on CreateNotificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateNotificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateNotificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateNotificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateNotificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateNotificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  String? userId,  Map<String, dynamic>? data,  DateTime? scheduledAt,  List<String>? tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateNotificationRequest() when $default != null:
return $default(_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.userId,_that.data,_that.scheduledAt,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  String? userId,  Map<String, dynamic>? data,  DateTime? scheduledAt,  List<String>? tags)  $default,) {final _that = this;
switch (_that) {
case _CreateNotificationRequest():
return $default(_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.userId,_that.data,_that.scheduledAt,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  String? userId,  Map<String, dynamic>? data,  DateTime? scheduledAt,  List<String>? tags)?  $default,) {final _that = this;
switch (_that) {
case _CreateNotificationRequest() when $default != null:
return $default(_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.userId,_that.data,_that.scheduledAt,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateNotificationRequest implements CreateNotificationRequest {
  const _CreateNotificationRequest({required this.title, required this.message, required this.type, required this.priority, required this.channel, this.userId, final  Map<String, dynamic>? data, this.scheduledAt, final  List<String>? tags}): _data = data,_tags = tags;
  factory _CreateNotificationRequest.fromJson(Map<String, dynamic> json) => _$CreateNotificationRequestFromJson(json);

@override final  String title;
@override final  String message;
@override final  NotificationType type;
@override final  NotificationPriority priority;
@override final  NotificationChannel channel;
@override final  String? userId;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? scheduledAt;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CreateNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateNotificationRequestCopyWith<_CreateNotificationRequest> get copyWith => __$CreateNotificationRequestCopyWithImpl<_CreateNotificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateNotificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateNotificationRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,type,priority,channel,userId,const DeepCollectionEquality().hash(_data),scheduledAt,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'CreateNotificationRequest(title: $title, message: $message, type: $type, priority: $priority, channel: $channel, userId: $userId, data: $data, scheduledAt: $scheduledAt, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$CreateNotificationRequestCopyWith<$Res> implements $CreateNotificationRequestCopyWith<$Res> {
  factory _$CreateNotificationRequestCopyWith(_CreateNotificationRequest value, $Res Function(_CreateNotificationRequest) _then) = __$CreateNotificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String message, NotificationType type, NotificationPriority priority, NotificationChannel channel, String? userId, Map<String, dynamic>? data, DateTime? scheduledAt, List<String>? tags
});




}
/// @nodoc
class __$CreateNotificationRequestCopyWithImpl<$Res>
    implements _$CreateNotificationRequestCopyWith<$Res> {
  __$CreateNotificationRequestCopyWithImpl(this._self, this._then);

  final _CreateNotificationRequest _self;
  final $Res Function(_CreateNotificationRequest) _then;

/// Create a copy of CreateNotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,Object? type = null,Object? priority = null,Object? channel = null,Object? userId = freezed,Object? data = freezed,Object? scheduledAt = freezed,Object? tags = freezed,}) {
  return _then(_CreateNotificationRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateNotificationPreferencesRequest {

 bool? get globalEnabled; QuietHoursSettings? get quietHours; EmergencyAlertSettings? get emergencySettings; Map<String, bool>? get channelPreferences; Map<String, bool>? get typePreferences; Map<String, bool>? get contextPreferences;
/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateNotificationPreferencesRequestCopyWith<UpdateNotificationPreferencesRequest> get copyWith => _$UpdateNotificationPreferencesRequestCopyWithImpl<UpdateNotificationPreferencesRequest>(this as UpdateNotificationPreferencesRequest, _$identity);

  /// Serializes this UpdateNotificationPreferencesRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateNotificationPreferencesRequest&&(identical(other.globalEnabled, globalEnabled) || other.globalEnabled == globalEnabled)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.emergencySettings, emergencySettings) || other.emergencySettings == emergencySettings)&&const DeepCollectionEquality().equals(other.channelPreferences, channelPreferences)&&const DeepCollectionEquality().equals(other.typePreferences, typePreferences)&&const DeepCollectionEquality().equals(other.contextPreferences, contextPreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,globalEnabled,quietHours,emergencySettings,const DeepCollectionEquality().hash(channelPreferences),const DeepCollectionEquality().hash(typePreferences),const DeepCollectionEquality().hash(contextPreferences));

@override
String toString() {
  return 'UpdateNotificationPreferencesRequest(globalEnabled: $globalEnabled, quietHours: $quietHours, emergencySettings: $emergencySettings, channelPreferences: $channelPreferences, typePreferences: $typePreferences, contextPreferences: $contextPreferences)';
}


}

/// @nodoc
abstract mixin class $UpdateNotificationPreferencesRequestCopyWith<$Res>  {
  factory $UpdateNotificationPreferencesRequestCopyWith(UpdateNotificationPreferencesRequest value, $Res Function(UpdateNotificationPreferencesRequest) _then) = _$UpdateNotificationPreferencesRequestCopyWithImpl;
@useResult
$Res call({
 bool? globalEnabled, QuietHoursSettings? quietHours, EmergencyAlertSettings? emergencySettings, Map<String, bool>? channelPreferences, Map<String, bool>? typePreferences, Map<String, bool>? contextPreferences
});


$QuietHoursSettingsCopyWith<$Res>? get quietHours;$EmergencyAlertSettingsCopyWith<$Res>? get emergencySettings;

}
/// @nodoc
class _$UpdateNotificationPreferencesRequestCopyWithImpl<$Res>
    implements $UpdateNotificationPreferencesRequestCopyWith<$Res> {
  _$UpdateNotificationPreferencesRequestCopyWithImpl(this._self, this._then);

  final UpdateNotificationPreferencesRequest _self;
  final $Res Function(UpdateNotificationPreferencesRequest) _then;

/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? globalEnabled = freezed,Object? quietHours = freezed,Object? emergencySettings = freezed,Object? channelPreferences = freezed,Object? typePreferences = freezed,Object? contextPreferences = freezed,}) {
  return _then(_self.copyWith(
globalEnabled: freezed == globalEnabled ? _self.globalEnabled : globalEnabled // ignore: cast_nullable_to_non_nullable
as bool?,quietHours: freezed == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHoursSettings?,emergencySettings: freezed == emergencySettings ? _self.emergencySettings : emergencySettings // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSettings?,channelPreferences: freezed == channelPreferences ? _self.channelPreferences : channelPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,typePreferences: freezed == typePreferences ? _self.typePreferences : typePreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,contextPreferences: freezed == contextPreferences ? _self.contextPreferences : contextPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}
/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursSettingsCopyWith<$Res>? get quietHours {
    if (_self.quietHours == null) {
    return null;
  }

  return $QuietHoursSettingsCopyWith<$Res>(_self.quietHours!, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertSettingsCopyWith<$Res>? get emergencySettings {
    if (_self.emergencySettings == null) {
    return null;
  }

  return $EmergencyAlertSettingsCopyWith<$Res>(_self.emergencySettings!, (value) {
    return _then(_self.copyWith(emergencySettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateNotificationPreferencesRequest].
extension UpdateNotificationPreferencesRequestPatterns on UpdateNotificationPreferencesRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateNotificationPreferencesRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateNotificationPreferencesRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateNotificationPreferencesRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? globalEnabled,  QuietHoursSettings? quietHours,  EmergencyAlertSettings? emergencySettings,  Map<String, bool>? channelPreferences,  Map<String, bool>? typePreferences,  Map<String, bool>? contextPreferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest() when $default != null:
return $default(_that.globalEnabled,_that.quietHours,_that.emergencySettings,_that.channelPreferences,_that.typePreferences,_that.contextPreferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? globalEnabled,  QuietHoursSettings? quietHours,  EmergencyAlertSettings? emergencySettings,  Map<String, bool>? channelPreferences,  Map<String, bool>? typePreferences,  Map<String, bool>? contextPreferences)  $default,) {final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest():
return $default(_that.globalEnabled,_that.quietHours,_that.emergencySettings,_that.channelPreferences,_that.typePreferences,_that.contextPreferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? globalEnabled,  QuietHoursSettings? quietHours,  EmergencyAlertSettings? emergencySettings,  Map<String, bool>? channelPreferences,  Map<String, bool>? typePreferences,  Map<String, bool>? contextPreferences)?  $default,) {final _that = this;
switch (_that) {
case _UpdateNotificationPreferencesRequest() when $default != null:
return $default(_that.globalEnabled,_that.quietHours,_that.emergencySettings,_that.channelPreferences,_that.typePreferences,_that.contextPreferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateNotificationPreferencesRequest implements UpdateNotificationPreferencesRequest {
  const _UpdateNotificationPreferencesRequest({this.globalEnabled, this.quietHours, this.emergencySettings, final  Map<String, bool>? channelPreferences, final  Map<String, bool>? typePreferences, final  Map<String, bool>? contextPreferences}): _channelPreferences = channelPreferences,_typePreferences = typePreferences,_contextPreferences = contextPreferences;
  factory _UpdateNotificationPreferencesRequest.fromJson(Map<String, dynamic> json) => _$UpdateNotificationPreferencesRequestFromJson(json);

@override final  bool? globalEnabled;
@override final  QuietHoursSettings? quietHours;
@override final  EmergencyAlertSettings? emergencySettings;
 final  Map<String, bool>? _channelPreferences;
@override Map<String, bool>? get channelPreferences {
  final value = _channelPreferences;
  if (value == null) return null;
  if (_channelPreferences is EqualUnmodifiableMapView) return _channelPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, bool>? _typePreferences;
@override Map<String, bool>? get typePreferences {
  final value = _typePreferences;
  if (value == null) return null;
  if (_typePreferences is EqualUnmodifiableMapView) return _typePreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, bool>? _contextPreferences;
@override Map<String, bool>? get contextPreferences {
  final value = _contextPreferences;
  if (value == null) return null;
  if (_contextPreferences is EqualUnmodifiableMapView) return _contextPreferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateNotificationPreferencesRequestCopyWith<_UpdateNotificationPreferencesRequest> get copyWith => __$UpdateNotificationPreferencesRequestCopyWithImpl<_UpdateNotificationPreferencesRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateNotificationPreferencesRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateNotificationPreferencesRequest&&(identical(other.globalEnabled, globalEnabled) || other.globalEnabled == globalEnabled)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.emergencySettings, emergencySettings) || other.emergencySettings == emergencySettings)&&const DeepCollectionEquality().equals(other._channelPreferences, _channelPreferences)&&const DeepCollectionEquality().equals(other._typePreferences, _typePreferences)&&const DeepCollectionEquality().equals(other._contextPreferences, _contextPreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,globalEnabled,quietHours,emergencySettings,const DeepCollectionEquality().hash(_channelPreferences),const DeepCollectionEquality().hash(_typePreferences),const DeepCollectionEquality().hash(_contextPreferences));

@override
String toString() {
  return 'UpdateNotificationPreferencesRequest(globalEnabled: $globalEnabled, quietHours: $quietHours, emergencySettings: $emergencySettings, channelPreferences: $channelPreferences, typePreferences: $typePreferences, contextPreferences: $contextPreferences)';
}


}

/// @nodoc
abstract mixin class _$UpdateNotificationPreferencesRequestCopyWith<$Res> implements $UpdateNotificationPreferencesRequestCopyWith<$Res> {
  factory _$UpdateNotificationPreferencesRequestCopyWith(_UpdateNotificationPreferencesRequest value, $Res Function(_UpdateNotificationPreferencesRequest) _then) = __$UpdateNotificationPreferencesRequestCopyWithImpl;
@override @useResult
$Res call({
 bool? globalEnabled, QuietHoursSettings? quietHours, EmergencyAlertSettings? emergencySettings, Map<String, bool>? channelPreferences, Map<String, bool>? typePreferences, Map<String, bool>? contextPreferences
});


@override $QuietHoursSettingsCopyWith<$Res>? get quietHours;@override $EmergencyAlertSettingsCopyWith<$Res>? get emergencySettings;

}
/// @nodoc
class __$UpdateNotificationPreferencesRequestCopyWithImpl<$Res>
    implements _$UpdateNotificationPreferencesRequestCopyWith<$Res> {
  __$UpdateNotificationPreferencesRequestCopyWithImpl(this._self, this._then);

  final _UpdateNotificationPreferencesRequest _self;
  final $Res Function(_UpdateNotificationPreferencesRequest) _then;

/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? globalEnabled = freezed,Object? quietHours = freezed,Object? emergencySettings = freezed,Object? channelPreferences = freezed,Object? typePreferences = freezed,Object? contextPreferences = freezed,}) {
  return _then(_UpdateNotificationPreferencesRequest(
globalEnabled: freezed == globalEnabled ? _self.globalEnabled : globalEnabled // ignore: cast_nullable_to_non_nullable
as bool?,quietHours: freezed == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHoursSettings?,emergencySettings: freezed == emergencySettings ? _self.emergencySettings : emergencySettings // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSettings?,channelPreferences: freezed == channelPreferences ? _self._channelPreferences : channelPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,typePreferences: freezed == typePreferences ? _self._typePreferences : typePreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,contextPreferences: freezed == contextPreferences ? _self._contextPreferences : contextPreferences // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,
  ));
}

/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursSettingsCopyWith<$Res>? get quietHours {
    if (_self.quietHours == null) {
    return null;
  }

  return $QuietHoursSettingsCopyWith<$Res>(_self.quietHours!, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}/// Create a copy of UpdateNotificationPreferencesRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertSettingsCopyWith<$Res>? get emergencySettings {
    if (_self.emergencySettings == null) {
    return null;
  }

  return $EmergencyAlertSettingsCopyWith<$Res>(_self.emergencySettings!, (value) {
    return _then(_self.copyWith(emergencySettings: value));
  });
}
}


/// @nodoc
mixin _$UpdatePreferenceRequest {

 bool get enabled; Map<String, dynamic>? get settings;
/// Create a copy of UpdatePreferenceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePreferenceRequestCopyWith<UpdatePreferenceRequest> get copyWith => _$UpdatePreferenceRequestCopyWithImpl<UpdatePreferenceRequest>(this as UpdatePreferenceRequest, _$identity);

  /// Serializes this UpdatePreferenceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePreferenceRequest&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'UpdatePreferenceRequest(enabled: $enabled, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $UpdatePreferenceRequestCopyWith<$Res>  {
  factory $UpdatePreferenceRequestCopyWith(UpdatePreferenceRequest value, $Res Function(UpdatePreferenceRequest) _then) = _$UpdatePreferenceRequestCopyWithImpl;
@useResult
$Res call({
 bool enabled, Map<String, dynamic>? settings
});




}
/// @nodoc
class _$UpdatePreferenceRequestCopyWithImpl<$Res>
    implements $UpdatePreferenceRequestCopyWith<$Res> {
  _$UpdatePreferenceRequestCopyWithImpl(this._self, this._then);

  final UpdatePreferenceRequest _self;
  final $Res Function(UpdatePreferenceRequest) _then;

/// Create a copy of UpdatePreferenceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? settings = freezed,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePreferenceRequest].
extension UpdatePreferenceRequestPatterns on UpdatePreferenceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePreferenceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePreferenceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePreferenceRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePreferenceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePreferenceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePreferenceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  Map<String, dynamic>? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePreferenceRequest() when $default != null:
return $default(_that.enabled,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  Map<String, dynamic>? settings)  $default,) {final _that = this;
switch (_that) {
case _UpdatePreferenceRequest():
return $default(_that.enabled,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  Map<String, dynamic>? settings)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePreferenceRequest() when $default != null:
return $default(_that.enabled,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePreferenceRequest implements UpdatePreferenceRequest {
  const _UpdatePreferenceRequest({required this.enabled, final  Map<String, dynamic>? settings}): _settings = settings;
  factory _UpdatePreferenceRequest.fromJson(Map<String, dynamic> json) => _$UpdatePreferenceRequestFromJson(json);

@override final  bool enabled;
 final  Map<String, dynamic>? _settings;
@override Map<String, dynamic>? get settings {
  final value = _settings;
  if (value == null) return null;
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of UpdatePreferenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePreferenceRequestCopyWith<_UpdatePreferenceRequest> get copyWith => __$UpdatePreferenceRequestCopyWithImpl<_UpdatePreferenceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePreferenceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePreferenceRequest&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._settings, _settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_settings));

@override
String toString() {
  return 'UpdatePreferenceRequest(enabled: $enabled, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$UpdatePreferenceRequestCopyWith<$Res> implements $UpdatePreferenceRequestCopyWith<$Res> {
  factory _$UpdatePreferenceRequestCopyWith(_UpdatePreferenceRequest value, $Res Function(_UpdatePreferenceRequest) _then) = __$UpdatePreferenceRequestCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, Map<String, dynamic>? settings
});




}
/// @nodoc
class __$UpdatePreferenceRequestCopyWithImpl<$Res>
    implements _$UpdatePreferenceRequestCopyWith<$Res> {
  __$UpdatePreferenceRequestCopyWithImpl(this._self, this._then);

  final _UpdatePreferenceRequest _self;
  final $Res Function(_UpdatePreferenceRequest) _then;

/// Create a copy of UpdatePreferenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? settings = freezed,}) {
  return _then(_UpdatePreferenceRequest(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,settings: freezed == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$CreateEmergencyAlertRequest {

 String get title; String get message; EmergencyAlertSeverity get severity; EmergencyAlertType get alertType; String? get userId; String? get careGroupId; Map<String, dynamic>? get metadata; List<String>? get affectedUsers; bool? get requiresAcknowledgment; int? get escalationTimeoutMinutes;
/// Create a copy of CreateEmergencyAlertRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateEmergencyAlertRequestCopyWith<CreateEmergencyAlertRequest> get copyWith => _$CreateEmergencyAlertRequestCopyWithImpl<CreateEmergencyAlertRequest>(this as CreateEmergencyAlertRequest, _$identity);

  /// Serializes this CreateEmergencyAlertRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateEmergencyAlertRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.careGroupId, careGroupId) || other.careGroupId == careGroupId)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.affectedUsers, affectedUsers)&&(identical(other.requiresAcknowledgment, requiresAcknowledgment) || other.requiresAcknowledgment == requiresAcknowledgment)&&(identical(other.escalationTimeoutMinutes, escalationTimeoutMinutes) || other.escalationTimeoutMinutes == escalationTimeoutMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,severity,alertType,userId,careGroupId,const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(affectedUsers),requiresAcknowledgment,escalationTimeoutMinutes);

@override
String toString() {
  return 'CreateEmergencyAlertRequest(title: $title, message: $message, severity: $severity, alertType: $alertType, userId: $userId, careGroupId: $careGroupId, metadata: $metadata, affectedUsers: $affectedUsers, requiresAcknowledgment: $requiresAcknowledgment, escalationTimeoutMinutes: $escalationTimeoutMinutes)';
}


}

/// @nodoc
abstract mixin class $CreateEmergencyAlertRequestCopyWith<$Res>  {
  factory $CreateEmergencyAlertRequestCopyWith(CreateEmergencyAlertRequest value, $Res Function(CreateEmergencyAlertRequest) _then) = _$CreateEmergencyAlertRequestCopyWithImpl;
@useResult
$Res call({
 String title, String message, EmergencyAlertSeverity severity, EmergencyAlertType alertType, String? userId, String? careGroupId, Map<String, dynamic>? metadata, List<String>? affectedUsers, bool? requiresAcknowledgment, int? escalationTimeoutMinutes
});




}
/// @nodoc
class _$CreateEmergencyAlertRequestCopyWithImpl<$Res>
    implements $CreateEmergencyAlertRequestCopyWith<$Res> {
  _$CreateEmergencyAlertRequestCopyWithImpl(this._self, this._then);

  final CreateEmergencyAlertRequest _self;
  final $Res Function(CreateEmergencyAlertRequest) _then;

/// Create a copy of CreateEmergencyAlertRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? message = null,Object? severity = null,Object? alertType = null,Object? userId = freezed,Object? careGroupId = freezed,Object? metadata = freezed,Object? affectedUsers = freezed,Object? requiresAcknowledgment = freezed,Object? escalationTimeoutMinutes = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSeverity,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as EmergencyAlertType,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,careGroupId: freezed == careGroupId ? _self.careGroupId : careGroupId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,affectedUsers: freezed == affectedUsers ? _self.affectedUsers : affectedUsers // ignore: cast_nullable_to_non_nullable
as List<String>?,requiresAcknowledgment: freezed == requiresAcknowledgment ? _self.requiresAcknowledgment : requiresAcknowledgment // ignore: cast_nullable_to_non_nullable
as bool?,escalationTimeoutMinutes: freezed == escalationTimeoutMinutes ? _self.escalationTimeoutMinutes : escalationTimeoutMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateEmergencyAlertRequest].
extension CreateEmergencyAlertRequestPatterns on CreateEmergencyAlertRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateEmergencyAlertRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateEmergencyAlertRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateEmergencyAlertRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String message,  EmergencyAlertSeverity severity,  EmergencyAlertType alertType,  String? userId,  String? careGroupId,  Map<String, dynamic>? metadata,  List<String>? affectedUsers,  bool? requiresAcknowledgment,  int? escalationTimeoutMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest() when $default != null:
return $default(_that.title,_that.message,_that.severity,_that.alertType,_that.userId,_that.careGroupId,_that.metadata,_that.affectedUsers,_that.requiresAcknowledgment,_that.escalationTimeoutMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String message,  EmergencyAlertSeverity severity,  EmergencyAlertType alertType,  String? userId,  String? careGroupId,  Map<String, dynamic>? metadata,  List<String>? affectedUsers,  bool? requiresAcknowledgment,  int? escalationTimeoutMinutes)  $default,) {final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest():
return $default(_that.title,_that.message,_that.severity,_that.alertType,_that.userId,_that.careGroupId,_that.metadata,_that.affectedUsers,_that.requiresAcknowledgment,_that.escalationTimeoutMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String message,  EmergencyAlertSeverity severity,  EmergencyAlertType alertType,  String? userId,  String? careGroupId,  Map<String, dynamic>? metadata,  List<String>? affectedUsers,  bool? requiresAcknowledgment,  int? escalationTimeoutMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CreateEmergencyAlertRequest() when $default != null:
return $default(_that.title,_that.message,_that.severity,_that.alertType,_that.userId,_that.careGroupId,_that.metadata,_that.affectedUsers,_that.requiresAcknowledgment,_that.escalationTimeoutMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateEmergencyAlertRequest implements CreateEmergencyAlertRequest {
  const _CreateEmergencyAlertRequest({required this.title, required this.message, required this.severity, required this.alertType, this.userId, this.careGroupId, final  Map<String, dynamic>? metadata, final  List<String>? affectedUsers, this.requiresAcknowledgment, this.escalationTimeoutMinutes}): _metadata = metadata,_affectedUsers = affectedUsers;
  factory _CreateEmergencyAlertRequest.fromJson(Map<String, dynamic> json) => _$CreateEmergencyAlertRequestFromJson(json);

@override final  String title;
@override final  String message;
@override final  EmergencyAlertSeverity severity;
@override final  EmergencyAlertType alertType;
@override final  String? userId;
@override final  String? careGroupId;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String>? _affectedUsers;
@override List<String>? get affectedUsers {
  final value = _affectedUsers;
  if (value == null) return null;
  if (_affectedUsers is EqualUnmodifiableListView) return _affectedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? requiresAcknowledgment;
@override final  int? escalationTimeoutMinutes;

/// Create a copy of CreateEmergencyAlertRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateEmergencyAlertRequestCopyWith<_CreateEmergencyAlertRequest> get copyWith => __$CreateEmergencyAlertRequestCopyWithImpl<_CreateEmergencyAlertRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateEmergencyAlertRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateEmergencyAlertRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.careGroupId, careGroupId) || other.careGroupId == careGroupId)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other._affectedUsers, _affectedUsers)&&(identical(other.requiresAcknowledgment, requiresAcknowledgment) || other.requiresAcknowledgment == requiresAcknowledgment)&&(identical(other.escalationTimeoutMinutes, escalationTimeoutMinutes) || other.escalationTimeoutMinutes == escalationTimeoutMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,severity,alertType,userId,careGroupId,const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(_affectedUsers),requiresAcknowledgment,escalationTimeoutMinutes);

@override
String toString() {
  return 'CreateEmergencyAlertRequest(title: $title, message: $message, severity: $severity, alertType: $alertType, userId: $userId, careGroupId: $careGroupId, metadata: $metadata, affectedUsers: $affectedUsers, requiresAcknowledgment: $requiresAcknowledgment, escalationTimeoutMinutes: $escalationTimeoutMinutes)';
}


}

/// @nodoc
abstract mixin class _$CreateEmergencyAlertRequestCopyWith<$Res> implements $CreateEmergencyAlertRequestCopyWith<$Res> {
  factory _$CreateEmergencyAlertRequestCopyWith(_CreateEmergencyAlertRequest value, $Res Function(_CreateEmergencyAlertRequest) _then) = __$CreateEmergencyAlertRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String message, EmergencyAlertSeverity severity, EmergencyAlertType alertType, String? userId, String? careGroupId, Map<String, dynamic>? metadata, List<String>? affectedUsers, bool? requiresAcknowledgment, int? escalationTimeoutMinutes
});




}
/// @nodoc
class __$CreateEmergencyAlertRequestCopyWithImpl<$Res>
    implements _$CreateEmergencyAlertRequestCopyWith<$Res> {
  __$CreateEmergencyAlertRequestCopyWithImpl(this._self, this._then);

  final _CreateEmergencyAlertRequest _self;
  final $Res Function(_CreateEmergencyAlertRequest) _then;

/// Create a copy of CreateEmergencyAlertRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,Object? severity = null,Object? alertType = null,Object? userId = freezed,Object? careGroupId = freezed,Object? metadata = freezed,Object? affectedUsers = freezed,Object? requiresAcknowledgment = freezed,Object? escalationTimeoutMinutes = freezed,}) {
  return _then(_CreateEmergencyAlertRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSeverity,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as EmergencyAlertType,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,careGroupId: freezed == careGroupId ? _self.careGroupId : careGroupId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,affectedUsers: freezed == affectedUsers ? _self._affectedUsers : affectedUsers // ignore: cast_nullable_to_non_nullable
as List<String>?,requiresAcknowledgment: freezed == requiresAcknowledgment ? _self.requiresAcknowledgment : requiresAcknowledgment // ignore: cast_nullable_to_non_nullable
as bool?,escalationTimeoutMinutes: freezed == escalationTimeoutMinutes ? _self.escalationTimeoutMinutes : escalationTimeoutMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$EmergencyAlertActionRequest {

 String get actionType; String? get notes; Map<String, dynamic>? get actionData;@JsonKey(name: 'performed_by') String? get performedBy;
/// Create a copy of EmergencyAlertActionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertActionRequestCopyWith<EmergencyAlertActionRequest> get copyWith => _$EmergencyAlertActionRequestCopyWithImpl<EmergencyAlertActionRequest>(this as EmergencyAlertActionRequest, _$identity);

  /// Serializes this EmergencyAlertActionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlertActionRequest&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.actionData, actionData)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionType,notes,const DeepCollectionEquality().hash(actionData),performedBy);

@override
String toString() {
  return 'EmergencyAlertActionRequest(actionType: $actionType, notes: $notes, actionData: $actionData, performedBy: $performedBy)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertActionRequestCopyWith<$Res>  {
  factory $EmergencyAlertActionRequestCopyWith(EmergencyAlertActionRequest value, $Res Function(EmergencyAlertActionRequest) _then) = _$EmergencyAlertActionRequestCopyWithImpl;
@useResult
$Res call({
 String actionType, String? notes, Map<String, dynamic>? actionData,@JsonKey(name: 'performed_by') String? performedBy
});




}
/// @nodoc
class _$EmergencyAlertActionRequestCopyWithImpl<$Res>
    implements $EmergencyAlertActionRequestCopyWith<$Res> {
  _$EmergencyAlertActionRequestCopyWithImpl(this._self, this._then);

  final EmergencyAlertActionRequest _self;
  final $Res Function(EmergencyAlertActionRequest) _then;

/// Create a copy of EmergencyAlertActionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionType = null,Object? notes = freezed,Object? actionData = freezed,Object? performedBy = freezed,}) {
  return _then(_self.copyWith(
actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,actionData: freezed == actionData ? _self.actionData : actionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,performedBy: freezed == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyAlertActionRequest].
extension EmergencyAlertActionRequestPatterns on EmergencyAlertActionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlertActionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlertActionRequest value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlertActionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actionType,  String? notes,  Map<String, dynamic>? actionData, @JsonKey(name: 'performed_by')  String? performedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest() when $default != null:
return $default(_that.actionType,_that.notes,_that.actionData,_that.performedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actionType,  String? notes,  Map<String, dynamic>? actionData, @JsonKey(name: 'performed_by')  String? performedBy)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest():
return $default(_that.actionType,_that.notes,_that.actionData,_that.performedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actionType,  String? notes,  Map<String, dynamic>? actionData, @JsonKey(name: 'performed_by')  String? performedBy)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertActionRequest() when $default != null:
return $default(_that.actionType,_that.notes,_that.actionData,_that.performedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlertActionRequest implements EmergencyAlertActionRequest {
  const _EmergencyAlertActionRequest({required this.actionType, this.notes, final  Map<String, dynamic>? actionData, @JsonKey(name: 'performed_by') this.performedBy}): _actionData = actionData;
  factory _EmergencyAlertActionRequest.fromJson(Map<String, dynamic> json) => _$EmergencyAlertActionRequestFromJson(json);

@override final  String actionType;
@override final  String? notes;
 final  Map<String, dynamic>? _actionData;
@override Map<String, dynamic>? get actionData {
  final value = _actionData;
  if (value == null) return null;
  if (_actionData is EqualUnmodifiableMapView) return _actionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'performed_by') final  String? performedBy;

/// Create a copy of EmergencyAlertActionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertActionRequestCopyWith<_EmergencyAlertActionRequest> get copyWith => __$EmergencyAlertActionRequestCopyWithImpl<_EmergencyAlertActionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertActionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlertActionRequest&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._actionData, _actionData)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionType,notes,const DeepCollectionEquality().hash(_actionData),performedBy);

@override
String toString() {
  return 'EmergencyAlertActionRequest(actionType: $actionType, notes: $notes, actionData: $actionData, performedBy: $performedBy)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertActionRequestCopyWith<$Res> implements $EmergencyAlertActionRequestCopyWith<$Res> {
  factory _$EmergencyAlertActionRequestCopyWith(_EmergencyAlertActionRequest value, $Res Function(_EmergencyAlertActionRequest) _then) = __$EmergencyAlertActionRequestCopyWithImpl;
@override @useResult
$Res call({
 String actionType, String? notes, Map<String, dynamic>? actionData,@JsonKey(name: 'performed_by') String? performedBy
});




}
/// @nodoc
class __$EmergencyAlertActionRequestCopyWithImpl<$Res>
    implements _$EmergencyAlertActionRequestCopyWith<$Res> {
  __$EmergencyAlertActionRequestCopyWithImpl(this._self, this._then);

  final _EmergencyAlertActionRequest _self;
  final $Res Function(_EmergencyAlertActionRequest) _then;

/// Create a copy of EmergencyAlertActionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionType = null,Object? notes = freezed,Object? actionData = freezed,Object? performedBy = freezed,}) {
  return _then(_EmergencyAlertActionRequest(
actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,actionData: freezed == actionData ? _self._actionData : actionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,performedBy: freezed == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateTemplateRequest {

 String get name; String get subject; String get content; NotificationType get type; NotificationChannel get channel; String? get description; Map<String, String>? get variables; bool? get isActive; Map<String, dynamic>? get metadata;
/// Create a copy of CreateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTemplateRequestCopyWith<CreateTemplateRequest> get copyWith => _$CreateTemplateRequestCopyWithImpl<CreateTemplateRequest>(this as CreateTemplateRequest, _$identity);

  /// Serializes this CreateTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,subject,content,type,channel,description,const DeepCollectionEquality().hash(variables),isActive,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'CreateTemplateRequest(name: $name, subject: $subject, content: $content, type: $type, channel: $channel, description: $description, variables: $variables, isActive: $isActive, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CreateTemplateRequestCopyWith<$Res>  {
  factory $CreateTemplateRequestCopyWith(CreateTemplateRequest value, $Res Function(CreateTemplateRequest) _then) = _$CreateTemplateRequestCopyWithImpl;
@useResult
$Res call({
 String name, String subject, String content, NotificationType type, NotificationChannel channel, String? description, Map<String, String>? variables, bool? isActive, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$CreateTemplateRequestCopyWithImpl<$Res>
    implements $CreateTemplateRequestCopyWith<$Res> {
  _$CreateTemplateRequestCopyWithImpl(this._self, this._then);

  final CreateTemplateRequest _self;
  final $Res Function(CreateTemplateRequest) _then;

/// Create a copy of CreateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? subject = null,Object? content = null,Object? type = null,Object? channel = null,Object? description = freezed,Object? variables = freezed,Object? isActive = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,variables: freezed == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTemplateRequest].
extension CreateTemplateRequestPatterns on CreateTemplateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTemplateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTemplateRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTemplateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTemplateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String subject,  String content,  NotificationType type,  NotificationChannel channel,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
return $default(_that.name,_that.subject,_that.content,_that.type,_that.channel,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String subject,  String content,  NotificationType type,  NotificationChannel channel,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _CreateTemplateRequest():
return $default(_that.name,_that.subject,_that.content,_that.type,_that.channel,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String subject,  String content,  NotificationType type,  NotificationChannel channel,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
return $default(_that.name,_that.subject,_that.content,_that.type,_that.channel,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTemplateRequest implements CreateTemplateRequest {
  const _CreateTemplateRequest({required this.name, required this.subject, required this.content, required this.type, required this.channel, this.description, final  Map<String, String>? variables, this.isActive, final  Map<String, dynamic>? metadata}): _variables = variables,_metadata = metadata;
  factory _CreateTemplateRequest.fromJson(Map<String, dynamic> json) => _$CreateTemplateRequestFromJson(json);

@override final  String name;
@override final  String subject;
@override final  String content;
@override final  NotificationType type;
@override final  NotificationChannel channel;
@override final  String? description;
 final  Map<String, String>? _variables;
@override Map<String, String>? get variables {
  final value = _variables;
  if (value == null) return null;
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? isActive;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CreateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTemplateRequestCopyWith<_CreateTemplateRequest> get copyWith => __$CreateTemplateRequestCopyWithImpl<_CreateTemplateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTemplateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,subject,content,type,channel,description,const DeepCollectionEquality().hash(_variables),isActive,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'CreateTemplateRequest(name: $name, subject: $subject, content: $content, type: $type, channel: $channel, description: $description, variables: $variables, isActive: $isActive, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CreateTemplateRequestCopyWith<$Res> implements $CreateTemplateRequestCopyWith<$Res> {
  factory _$CreateTemplateRequestCopyWith(_CreateTemplateRequest value, $Res Function(_CreateTemplateRequest) _then) = __$CreateTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String subject, String content, NotificationType type, NotificationChannel channel, String? description, Map<String, String>? variables, bool? isActive, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$CreateTemplateRequestCopyWithImpl<$Res>
    implements _$CreateTemplateRequestCopyWith<$Res> {
  __$CreateTemplateRequestCopyWithImpl(this._self, this._then);

  final _CreateTemplateRequest _self;
  final $Res Function(_CreateTemplateRequest) _then;

/// Create a copy of CreateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? subject = null,Object? content = null,Object? type = null,Object? channel = null,Object? description = freezed,Object? variables = freezed,Object? isActive = freezed,Object? metadata = freezed,}) {
  return _then(_CreateTemplateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,variables: freezed == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$UpdateTemplateRequest {

 String? get name; String? get subject; String? get content; String? get description; Map<String, String>? get variables; bool? get isActive; Map<String, dynamic>? get metadata;
/// Create a copy of UpdateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTemplateRequestCopyWith<UpdateTemplateRequest> get copyWith => _$UpdateTemplateRequestCopyWithImpl<UpdateTemplateRequest>(this as UpdateTemplateRequest, _$identity);

  /// Serializes this UpdateTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.content, content) || other.content == content)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,subject,content,description,const DeepCollectionEquality().hash(variables),isActive,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'UpdateTemplateRequest(name: $name, subject: $subject, content: $content, description: $description, variables: $variables, isActive: $isActive, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $UpdateTemplateRequestCopyWith<$Res>  {
  factory $UpdateTemplateRequestCopyWith(UpdateTemplateRequest value, $Res Function(UpdateTemplateRequest) _then) = _$UpdateTemplateRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? subject, String? content, String? description, Map<String, String>? variables, bool? isActive, Map<String, dynamic>? metadata
});




}
/// @nodoc
class _$UpdateTemplateRequestCopyWithImpl<$Res>
    implements $UpdateTemplateRequestCopyWith<$Res> {
  _$UpdateTemplateRequestCopyWithImpl(this._self, this._then);

  final UpdateTemplateRequest _self;
  final $Res Function(UpdateTemplateRequest) _then;

/// Create a copy of UpdateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? subject = freezed,Object? content = freezed,Object? description = freezed,Object? variables = freezed,Object? isActive = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,variables: freezed == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTemplateRequest].
extension UpdateTemplateRequestPatterns on UpdateTemplateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTemplateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTemplateRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTemplateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTemplateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? subject,  String? content,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
return $default(_that.name,_that.subject,_that.content,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? subject,  String? content,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)  $default,) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest():
return $default(_that.name,_that.subject,_that.content,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? subject,  String? content,  String? description,  Map<String, String>? variables,  bool? isActive,  Map<String, dynamic>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
return $default(_that.name,_that.subject,_that.content,_that.description,_that.variables,_that.isActive,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTemplateRequest implements UpdateTemplateRequest {
  const _UpdateTemplateRequest({this.name, this.subject, this.content, this.description, final  Map<String, String>? variables, this.isActive, final  Map<String, dynamic>? metadata}): _variables = variables,_metadata = metadata;
  factory _UpdateTemplateRequest.fromJson(Map<String, dynamic> json) => _$UpdateTemplateRequestFromJson(json);

@override final  String? name;
@override final  String? subject;
@override final  String? content;
@override final  String? description;
 final  Map<String, String>? _variables;
@override Map<String, String>? get variables {
  final value = _variables;
  if (value == null) return null;
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? isActive;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of UpdateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTemplateRequestCopyWith<_UpdateTemplateRequest> get copyWith => __$UpdateTemplateRequestCopyWithImpl<_UpdateTemplateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTemplateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.content, content) || other.content == content)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,subject,content,description,const DeepCollectionEquality().hash(_variables),isActive,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'UpdateTemplateRequest(name: $name, subject: $subject, content: $content, description: $description, variables: $variables, isActive: $isActive, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$UpdateTemplateRequestCopyWith<$Res> implements $UpdateTemplateRequestCopyWith<$Res> {
  factory _$UpdateTemplateRequestCopyWith(_UpdateTemplateRequest value, $Res Function(_UpdateTemplateRequest) _then) = __$UpdateTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? subject, String? content, String? description, Map<String, String>? variables, bool? isActive, Map<String, dynamic>? metadata
});




}
/// @nodoc
class __$UpdateTemplateRequestCopyWithImpl<$Res>
    implements _$UpdateTemplateRequestCopyWith<$Res> {
  __$UpdateTemplateRequestCopyWithImpl(this._self, this._then);

  final _UpdateTemplateRequest _self;
  final $Res Function(_UpdateTemplateRequest) _then;

/// Create a copy of UpdateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? subject = freezed,Object? content = freezed,Object? description = freezed,Object? variables = freezed,Object? isActive = freezed,Object? metadata = freezed,}) {
  return _then(_UpdateTemplateRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,variables: freezed == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$RenderTemplateRequest {

 Map<String, dynamic> get variables; String? get locale; Map<String, dynamic>? get context;
/// Create a copy of RenderTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderTemplateRequestCopyWith<RenderTemplateRequest> get copyWith => _$RenderTemplateRequestCopyWithImpl<RenderTemplateRequest>(this as RenderTemplateRequest, _$identity);

  /// Serializes this RenderTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderTemplateRequest&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other.context, context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(variables),locale,const DeepCollectionEquality().hash(context));

@override
String toString() {
  return 'RenderTemplateRequest(variables: $variables, locale: $locale, context: $context)';
}


}

/// @nodoc
abstract mixin class $RenderTemplateRequestCopyWith<$Res>  {
  factory $RenderTemplateRequestCopyWith(RenderTemplateRequest value, $Res Function(RenderTemplateRequest) _then) = _$RenderTemplateRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> variables, String? locale, Map<String, dynamic>? context
});




}
/// @nodoc
class _$RenderTemplateRequestCopyWithImpl<$Res>
    implements $RenderTemplateRequestCopyWith<$Res> {
  _$RenderTemplateRequestCopyWithImpl(this._self, this._then);

  final RenderTemplateRequest _self;
  final $Res Function(RenderTemplateRequest) _then;

/// Create a copy of RenderTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variables = null,Object? locale = freezed,Object? context = freezed,}) {
  return _then(_self.copyWith(
variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderTemplateRequest].
extension RenderTemplateRequestPatterns on RenderTemplateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderTemplateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderTemplateRequest value)  $default,){
final _that = this;
switch (_that) {
case _RenderTemplateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderTemplateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> variables,  String? locale,  Map<String, dynamic>? context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
return $default(_that.variables,_that.locale,_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> variables,  String? locale,  Map<String, dynamic>? context)  $default,) {final _that = this;
switch (_that) {
case _RenderTemplateRequest():
return $default(_that.variables,_that.locale,_that.context);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> variables,  String? locale,  Map<String, dynamic>? context)?  $default,) {final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
return $default(_that.variables,_that.locale,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderTemplateRequest implements RenderTemplateRequest {
  const _RenderTemplateRequest({required final  Map<String, dynamic> variables, this.locale, final  Map<String, dynamic>? context}): _variables = variables,_context = context;
  factory _RenderTemplateRequest.fromJson(Map<String, dynamic> json) => _$RenderTemplateRequestFromJson(json);

 final  Map<String, dynamic> _variables;
@override Map<String, dynamic> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

@override final  String? locale;
 final  Map<String, dynamic>? _context;
@override Map<String, dynamic>? get context {
  final value = _context;
  if (value == null) return null;
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of RenderTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderTemplateRequestCopyWith<_RenderTemplateRequest> get copyWith => __$RenderTemplateRequestCopyWithImpl<_RenderTemplateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderTemplateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderTemplateRequest&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other._context, _context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_variables),locale,const DeepCollectionEquality().hash(_context));

@override
String toString() {
  return 'RenderTemplateRequest(variables: $variables, locale: $locale, context: $context)';
}


}

/// @nodoc
abstract mixin class _$RenderTemplateRequestCopyWith<$Res> implements $RenderTemplateRequestCopyWith<$Res> {
  factory _$RenderTemplateRequestCopyWith(_RenderTemplateRequest value, $Res Function(_RenderTemplateRequest) _then) = __$RenderTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> variables, String? locale, Map<String, dynamic>? context
});




}
/// @nodoc
class __$RenderTemplateRequestCopyWithImpl<$Res>
    implements _$RenderTemplateRequestCopyWith<$Res> {
  __$RenderTemplateRequestCopyWithImpl(this._self, this._then);

  final _RenderTemplateRequest _self;
  final $Res Function(_RenderTemplateRequest) _then;

/// Create a copy of RenderTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variables = null,Object? locale = freezed,Object? context = freezed,}) {
  return _then(_RenderTemplateRequest(
variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,context: freezed == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
