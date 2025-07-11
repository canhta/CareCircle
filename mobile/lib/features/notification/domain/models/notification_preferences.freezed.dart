// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreference {

 String get id; String get userId; ContextType get contextType; NotificationChannel get channel; NotificationFrequency get frequency; bool get enabled; bool get quietHoursEnabled; DateTime? get quietHoursStart; DateTime? get quietHoursEnd; Map<String, dynamic>? get settings; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferenceCopyWith<NotificationPreference> get copyWith => _$NotificationPreferenceCopyWithImpl<NotificationPreference>(this as NotificationPreference, _$identity);

  /// Serializes this NotificationPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreference&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contextType, contextType) || other.contextType == contextType)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,contextType,channel,frequency,enabled,quietHoursEnabled,quietHoursStart,quietHoursEnd,const DeepCollectionEquality().hash(settings),createdAt,updatedAt);

@override
String toString() {
  return 'NotificationPreference(id: $id, userId: $userId, contextType: $contextType, channel: $channel, frequency: $frequency, enabled: $enabled, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferenceCopyWith<$Res>  {
  factory $NotificationPreferenceCopyWith(NotificationPreference value, $Res Function(NotificationPreference) _then) = _$NotificationPreferenceCopyWithImpl;
@useResult
$Res call({
 String id, String userId, ContextType contextType, NotificationChannel channel, NotificationFrequency frequency, bool enabled, bool quietHoursEnabled, DateTime? quietHoursStart, DateTime? quietHoursEnd, Map<String, dynamic>? settings, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$NotificationPreferenceCopyWithImpl<$Res>
    implements $NotificationPreferenceCopyWith<$Res> {
  _$NotificationPreferenceCopyWithImpl(this._self, this._then);

  final NotificationPreference _self;
  final $Res Function(NotificationPreference) _then;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? contextType = null,Object? channel = null,Object? frequency = null,Object? enabled = null,Object? quietHoursEnabled = null,Object? quietHoursStart = freezed,Object? quietHoursEnd = freezed,Object? settings = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contextType: null == contextType ? _self.contextType : contextType // ignore: cast_nullable_to_non_nullable
as ContextType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as NotificationFrequency,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: freezed == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as DateTime?,quietHoursEnd: freezed == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreference].
extension NotificationPreferencePatterns on NotificationPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreference value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreference value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  ContextType contextType,  NotificationChannel channel,  NotificationFrequency frequency,  bool enabled,  bool quietHoursEnabled,  DateTime? quietHoursStart,  DateTime? quietHoursEnd,  Map<String, dynamic>? settings,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
return $default(_that.id,_that.userId,_that.contextType,_that.channel,_that.frequency,_that.enabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.settings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  ContextType contextType,  NotificationChannel channel,  NotificationFrequency frequency,  bool enabled,  bool quietHoursEnabled,  DateTime? quietHoursStart,  DateTime? quietHoursEnd,  Map<String, dynamic>? settings,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreference():
return $default(_that.id,_that.userId,_that.contextType,_that.channel,_that.frequency,_that.enabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.settings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  ContextType contextType,  NotificationChannel channel,  NotificationFrequency frequency,  bool enabled,  bool quietHoursEnabled,  DateTime? quietHoursStart,  DateTime? quietHoursEnd,  Map<String, dynamic>? settings,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreference() when $default != null:
return $default(_that.id,_that.userId,_that.contextType,_that.channel,_that.frequency,_that.enabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.settings,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreference implements NotificationPreference {
  const _NotificationPreference({required this.id, required this.userId, required this.contextType, required this.channel, this.frequency = NotificationFrequency.immediately, this.enabled = true, this.quietHoursEnabled = false, this.quietHoursStart, this.quietHoursEnd, final  Map<String, dynamic>? settings, required this.createdAt, this.updatedAt}): _settings = settings;
  factory _NotificationPreference.fromJson(Map<String, dynamic> json) => _$NotificationPreferenceFromJson(json);

@override final  String id;
@override final  String userId;
@override final  ContextType contextType;
@override final  NotificationChannel channel;
@override@JsonKey() final  NotificationFrequency frequency;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool quietHoursEnabled;
@override final  DateTime? quietHoursStart;
@override final  DateTime? quietHoursEnd;
 final  Map<String, dynamic>? _settings;
@override Map<String, dynamic>? get settings {
  final value = _settings;
  if (value == null) return null;
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferenceCopyWith<_NotificationPreference> get copyWith => __$NotificationPreferenceCopyWithImpl<_NotificationPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreference&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contextType, contextType) || other.contextType == contextType)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,contextType,channel,frequency,enabled,quietHoursEnabled,quietHoursStart,quietHoursEnd,const DeepCollectionEquality().hash(_settings),createdAt,updatedAt);

@override
String toString() {
  return 'NotificationPreference(id: $id, userId: $userId, contextType: $contextType, channel: $channel, frequency: $frequency, enabled: $enabled, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferenceCopyWith<$Res> implements $NotificationPreferenceCopyWith<$Res> {
  factory _$NotificationPreferenceCopyWith(_NotificationPreference value, $Res Function(_NotificationPreference) _then) = __$NotificationPreferenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, ContextType contextType, NotificationChannel channel, NotificationFrequency frequency, bool enabled, bool quietHoursEnabled, DateTime? quietHoursStart, DateTime? quietHoursEnd, Map<String, dynamic>? settings, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$NotificationPreferenceCopyWithImpl<$Res>
    implements _$NotificationPreferenceCopyWith<$Res> {
  __$NotificationPreferenceCopyWithImpl(this._self, this._then);

  final _NotificationPreference _self;
  final $Res Function(_NotificationPreference) _then;

/// Create a copy of NotificationPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? contextType = null,Object? channel = null,Object? frequency = null,Object? enabled = null,Object? quietHoursEnabled = null,Object? quietHoursStart = freezed,Object? quietHoursEnd = freezed,Object? settings = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_NotificationPreference(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contextType: null == contextType ? _self.contextType : contextType // ignore: cast_nullable_to_non_nullable
as ContextType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as NotificationFrequency,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: freezed == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as DateTime?,quietHoursEnd: freezed == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,settings: freezed == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NotificationPreferences {

 String get userId; bool get globalEnabled; bool get doNotDisturbEnabled; DateTime? get doNotDisturbStart; DateTime? get doNotDisturbEnd; List<NotificationPreference> get preferences; EmergencyAlertSettings get emergencySettings; QuietHoursSettings get quietHours; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.globalEnabled, globalEnabled) || other.globalEnabled == globalEnabled)&&(identical(other.doNotDisturbEnabled, doNotDisturbEnabled) || other.doNotDisturbEnabled == doNotDisturbEnabled)&&(identical(other.doNotDisturbStart, doNotDisturbStart) || other.doNotDisturbStart == doNotDisturbStart)&&(identical(other.doNotDisturbEnd, doNotDisturbEnd) || other.doNotDisturbEnd == doNotDisturbEnd)&&const DeepCollectionEquality().equals(other.preferences, preferences)&&(identical(other.emergencySettings, emergencySettings) || other.emergencySettings == emergencySettings)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,globalEnabled,doNotDisturbEnabled,doNotDisturbStart,doNotDisturbEnd,const DeepCollectionEquality().hash(preferences),emergencySettings,quietHours,createdAt,updatedAt);

@override
String toString() {
  return 'NotificationPreferences(userId: $userId, globalEnabled: $globalEnabled, doNotDisturbEnabled: $doNotDisturbEnabled, doNotDisturbStart: $doNotDisturbStart, doNotDisturbEnd: $doNotDisturbEnd, preferences: $preferences, emergencySettings: $emergencySettings, quietHours: $quietHours, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 String userId, bool globalEnabled, bool doNotDisturbEnabled, DateTime? doNotDisturbStart, DateTime? doNotDisturbEnd, List<NotificationPreference> preferences, EmergencyAlertSettings emergencySettings, QuietHoursSettings quietHours, DateTime createdAt, DateTime? updatedAt
});


$EmergencyAlertSettingsCopyWith<$Res> get emergencySettings;$QuietHoursSettingsCopyWith<$Res> get quietHours;

}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? globalEnabled = null,Object? doNotDisturbEnabled = null,Object? doNotDisturbStart = freezed,Object? doNotDisturbEnd = freezed,Object? preferences = null,Object? emergencySettings = null,Object? quietHours = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,globalEnabled: null == globalEnabled ? _self.globalEnabled : globalEnabled // ignore: cast_nullable_to_non_nullable
as bool,doNotDisturbEnabled: null == doNotDisturbEnabled ? _self.doNotDisturbEnabled : doNotDisturbEnabled // ignore: cast_nullable_to_non_nullable
as bool,doNotDisturbStart: freezed == doNotDisturbStart ? _self.doNotDisturbStart : doNotDisturbStart // ignore: cast_nullable_to_non_nullable
as DateTime?,doNotDisturbEnd: freezed == doNotDisturbEnd ? _self.doNotDisturbEnd : doNotDisturbEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<NotificationPreference>,emergencySettings: null == emergencySettings ? _self.emergencySettings : emergencySettings // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSettings,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHoursSettings,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertSettingsCopyWith<$Res> get emergencySettings {
  
  return $EmergencyAlertSettingsCopyWith<$Res>(_self.emergencySettings, (value) {
    return _then(_self.copyWith(emergencySettings: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursSettingsCopyWith<$Res> get quietHours {
  
  return $QuietHoursSettingsCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool globalEnabled,  bool doNotDisturbEnabled,  DateTime? doNotDisturbStart,  DateTime? doNotDisturbEnd,  List<NotificationPreference> preferences,  EmergencyAlertSettings emergencySettings,  QuietHoursSettings quietHours,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.userId,_that.globalEnabled,_that.doNotDisturbEnabled,_that.doNotDisturbStart,_that.doNotDisturbEnd,_that.preferences,_that.emergencySettings,_that.quietHours,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool globalEnabled,  bool doNotDisturbEnabled,  DateTime? doNotDisturbStart,  DateTime? doNotDisturbEnd,  List<NotificationPreference> preferences,  EmergencyAlertSettings emergencySettings,  QuietHoursSettings quietHours,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.userId,_that.globalEnabled,_that.doNotDisturbEnabled,_that.doNotDisturbStart,_that.doNotDisturbEnd,_that.preferences,_that.emergencySettings,_that.quietHours,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool globalEnabled,  bool doNotDisturbEnabled,  DateTime? doNotDisturbStart,  DateTime? doNotDisturbEnd,  List<NotificationPreference> preferences,  EmergencyAlertSettings emergencySettings,  QuietHoursSettings quietHours,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.userId,_that.globalEnabled,_that.doNotDisturbEnabled,_that.doNotDisturbStart,_that.doNotDisturbEnd,_that.preferences,_that.emergencySettings,_that.quietHours,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferences implements NotificationPreferences {
  const _NotificationPreferences({required this.userId, this.globalEnabled = true, this.doNotDisturbEnabled = false, this.doNotDisturbStart, this.doNotDisturbEnd, final  List<NotificationPreference> preferences = const [], this.emergencySettings = const EmergencyAlertSettings(), this.quietHours = const QuietHoursSettings(), required this.createdAt, this.updatedAt}): _preferences = preferences;
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override final  String userId;
@override@JsonKey() final  bool globalEnabled;
@override@JsonKey() final  bool doNotDisturbEnabled;
@override final  DateTime? doNotDisturbStart;
@override final  DateTime? doNotDisturbEnd;
 final  List<NotificationPreference> _preferences;
@override@JsonKey() List<NotificationPreference> get preferences {
  if (_preferences is EqualUnmodifiableListView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferences);
}

@override@JsonKey() final  EmergencyAlertSettings emergencySettings;
@override@JsonKey() final  QuietHoursSettings quietHours;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.globalEnabled, globalEnabled) || other.globalEnabled == globalEnabled)&&(identical(other.doNotDisturbEnabled, doNotDisturbEnabled) || other.doNotDisturbEnabled == doNotDisturbEnabled)&&(identical(other.doNotDisturbStart, doNotDisturbStart) || other.doNotDisturbStart == doNotDisturbStart)&&(identical(other.doNotDisturbEnd, doNotDisturbEnd) || other.doNotDisturbEnd == doNotDisturbEnd)&&const DeepCollectionEquality().equals(other._preferences, _preferences)&&(identical(other.emergencySettings, emergencySettings) || other.emergencySettings == emergencySettings)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,globalEnabled,doNotDisturbEnabled,doNotDisturbStart,doNotDisturbEnd,const DeepCollectionEquality().hash(_preferences),emergencySettings,quietHours,createdAt,updatedAt);

@override
String toString() {
  return 'NotificationPreferences(userId: $userId, globalEnabled: $globalEnabled, doNotDisturbEnabled: $doNotDisturbEnabled, doNotDisturbStart: $doNotDisturbStart, doNotDisturbEnd: $doNotDisturbEnd, preferences: $preferences, emergencySettings: $emergencySettings, quietHours: $quietHours, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool globalEnabled, bool doNotDisturbEnabled, DateTime? doNotDisturbStart, DateTime? doNotDisturbEnd, List<NotificationPreference> preferences, EmergencyAlertSettings emergencySettings, QuietHoursSettings quietHours, DateTime createdAt, DateTime? updatedAt
});


@override $EmergencyAlertSettingsCopyWith<$Res> get emergencySettings;@override $QuietHoursSettingsCopyWith<$Res> get quietHours;

}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? globalEnabled = null,Object? doNotDisturbEnabled = null,Object? doNotDisturbStart = freezed,Object? doNotDisturbEnd = freezed,Object? preferences = null,Object? emergencySettings = null,Object? quietHours = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_NotificationPreferences(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,globalEnabled: null == globalEnabled ? _self.globalEnabled : globalEnabled // ignore: cast_nullable_to_non_nullable
as bool,doNotDisturbEnabled: null == doNotDisturbEnabled ? _self.doNotDisturbEnabled : doNotDisturbEnabled // ignore: cast_nullable_to_non_nullable
as bool,doNotDisturbStart: freezed == doNotDisturbStart ? _self.doNotDisturbStart : doNotDisturbStart // ignore: cast_nullable_to_non_nullable
as DateTime?,doNotDisturbEnd: freezed == doNotDisturbEnd ? _self.doNotDisturbEnd : doNotDisturbEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<NotificationPreference>,emergencySettings: null == emergencySettings ? _self.emergencySettings : emergencySettings // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSettings,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHoursSettings,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertSettingsCopyWith<$Res> get emergencySettings {
  
  return $EmergencyAlertSettingsCopyWith<$Res>(_self.emergencySettings, (value) {
    return _then(_self.copyWith(emergencySettings: value));
  });
}/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursSettingsCopyWith<$Res> get quietHours {
  
  return $QuietHoursSettingsCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}


/// @nodoc
mixin _$EmergencyAlertSettings {

 bool get enabled; bool get overrideQuietHours; bool get soundEnabled; bool get vibrationEnabled; bool get fullScreenAlert; List<String> get emergencyContacts; int get escalationDelayMinutes; bool get autoEscalate;
/// Create a copy of EmergencyAlertSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertSettingsCopyWith<EmergencyAlertSettings> get copyWith => _$EmergencyAlertSettingsCopyWithImpl<EmergencyAlertSettings>(this as EmergencyAlertSettings, _$identity);

  /// Serializes this EmergencyAlertSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.overrideQuietHours, overrideQuietHours) || other.overrideQuietHours == overrideQuietHours)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.fullScreenAlert, fullScreenAlert) || other.fullScreenAlert == fullScreenAlert)&&const DeepCollectionEquality().equals(other.emergencyContacts, emergencyContacts)&&(identical(other.escalationDelayMinutes, escalationDelayMinutes) || other.escalationDelayMinutes == escalationDelayMinutes)&&(identical(other.autoEscalate, autoEscalate) || other.autoEscalate == autoEscalate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,overrideQuietHours,soundEnabled,vibrationEnabled,fullScreenAlert,const DeepCollectionEquality().hash(emergencyContacts),escalationDelayMinutes,autoEscalate);

@override
String toString() {
  return 'EmergencyAlertSettings(enabled: $enabled, overrideQuietHours: $overrideQuietHours, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, fullScreenAlert: $fullScreenAlert, emergencyContacts: $emergencyContacts, escalationDelayMinutes: $escalationDelayMinutes, autoEscalate: $autoEscalate)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertSettingsCopyWith<$Res>  {
  factory $EmergencyAlertSettingsCopyWith(EmergencyAlertSettings value, $Res Function(EmergencyAlertSettings) _then) = _$EmergencyAlertSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool overrideQuietHours, bool soundEnabled, bool vibrationEnabled, bool fullScreenAlert, List<String> emergencyContacts, int escalationDelayMinutes, bool autoEscalate
});




}
/// @nodoc
class _$EmergencyAlertSettingsCopyWithImpl<$Res>
    implements $EmergencyAlertSettingsCopyWith<$Res> {
  _$EmergencyAlertSettingsCopyWithImpl(this._self, this._then);

  final EmergencyAlertSettings _self;
  final $Res Function(EmergencyAlertSettings) _then;

/// Create a copy of EmergencyAlertSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? overrideQuietHours = null,Object? soundEnabled = null,Object? vibrationEnabled = null,Object? fullScreenAlert = null,Object? emergencyContacts = null,Object? escalationDelayMinutes = null,Object? autoEscalate = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,overrideQuietHours: null == overrideQuietHours ? _self.overrideQuietHours : overrideQuietHours // ignore: cast_nullable_to_non_nullable
as bool,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,fullScreenAlert: null == fullScreenAlert ? _self.fullScreenAlert : fullScreenAlert // ignore: cast_nullable_to_non_nullable
as bool,emergencyContacts: null == emergencyContacts ? _self.emergencyContacts : emergencyContacts // ignore: cast_nullable_to_non_nullable
as List<String>,escalationDelayMinutes: null == escalationDelayMinutes ? _self.escalationDelayMinutes : escalationDelayMinutes // ignore: cast_nullable_to_non_nullable
as int,autoEscalate: null == autoEscalate ? _self.autoEscalate : autoEscalate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyAlertSettings].
extension EmergencyAlertSettingsPatterns on EmergencyAlertSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlertSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlertSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlertSettings value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlertSettings value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool overrideQuietHours,  bool soundEnabled,  bool vibrationEnabled,  bool fullScreenAlert,  List<String> emergencyContacts,  int escalationDelayMinutes,  bool autoEscalate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlertSettings() when $default != null:
return $default(_that.enabled,_that.overrideQuietHours,_that.soundEnabled,_that.vibrationEnabled,_that.fullScreenAlert,_that.emergencyContacts,_that.escalationDelayMinutes,_that.autoEscalate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool overrideQuietHours,  bool soundEnabled,  bool vibrationEnabled,  bool fullScreenAlert,  List<String> emergencyContacts,  int escalationDelayMinutes,  bool autoEscalate)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertSettings():
return $default(_that.enabled,_that.overrideQuietHours,_that.soundEnabled,_that.vibrationEnabled,_that.fullScreenAlert,_that.emergencyContacts,_that.escalationDelayMinutes,_that.autoEscalate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool overrideQuietHours,  bool soundEnabled,  bool vibrationEnabled,  bool fullScreenAlert,  List<String> emergencyContacts,  int escalationDelayMinutes,  bool autoEscalate)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertSettings() when $default != null:
return $default(_that.enabled,_that.overrideQuietHours,_that.soundEnabled,_that.vibrationEnabled,_that.fullScreenAlert,_that.emergencyContacts,_that.escalationDelayMinutes,_that.autoEscalate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlertSettings implements EmergencyAlertSettings {
  const _EmergencyAlertSettings({this.enabled = true, this.overrideQuietHours = true, this.soundEnabled = true, this.vibrationEnabled = true, this.fullScreenAlert = true, final  List<String> emergencyContacts = const [], this.escalationDelayMinutes = 5, this.autoEscalate = true}): _emergencyContacts = emergencyContacts;
  factory _EmergencyAlertSettings.fromJson(Map<String, dynamic> json) => _$EmergencyAlertSettingsFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool overrideQuietHours;
@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool vibrationEnabled;
@override@JsonKey() final  bool fullScreenAlert;
 final  List<String> _emergencyContacts;
@override@JsonKey() List<String> get emergencyContacts {
  if (_emergencyContacts is EqualUnmodifiableListView) return _emergencyContacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_emergencyContacts);
}

@override@JsonKey() final  int escalationDelayMinutes;
@override@JsonKey() final  bool autoEscalate;

/// Create a copy of EmergencyAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertSettingsCopyWith<_EmergencyAlertSettings> get copyWith => __$EmergencyAlertSettingsCopyWithImpl<_EmergencyAlertSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlertSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.overrideQuietHours, overrideQuietHours) || other.overrideQuietHours == overrideQuietHours)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.fullScreenAlert, fullScreenAlert) || other.fullScreenAlert == fullScreenAlert)&&const DeepCollectionEquality().equals(other._emergencyContacts, _emergencyContacts)&&(identical(other.escalationDelayMinutes, escalationDelayMinutes) || other.escalationDelayMinutes == escalationDelayMinutes)&&(identical(other.autoEscalate, autoEscalate) || other.autoEscalate == autoEscalate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,overrideQuietHours,soundEnabled,vibrationEnabled,fullScreenAlert,const DeepCollectionEquality().hash(_emergencyContacts),escalationDelayMinutes,autoEscalate);

@override
String toString() {
  return 'EmergencyAlertSettings(enabled: $enabled, overrideQuietHours: $overrideQuietHours, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, fullScreenAlert: $fullScreenAlert, emergencyContacts: $emergencyContacts, escalationDelayMinutes: $escalationDelayMinutes, autoEscalate: $autoEscalate)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertSettingsCopyWith<$Res> implements $EmergencyAlertSettingsCopyWith<$Res> {
  factory _$EmergencyAlertSettingsCopyWith(_EmergencyAlertSettings value, $Res Function(_EmergencyAlertSettings) _then) = __$EmergencyAlertSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool overrideQuietHours, bool soundEnabled, bool vibrationEnabled, bool fullScreenAlert, List<String> emergencyContacts, int escalationDelayMinutes, bool autoEscalate
});




}
/// @nodoc
class __$EmergencyAlertSettingsCopyWithImpl<$Res>
    implements _$EmergencyAlertSettingsCopyWith<$Res> {
  __$EmergencyAlertSettingsCopyWithImpl(this._self, this._then);

  final _EmergencyAlertSettings _self;
  final $Res Function(_EmergencyAlertSettings) _then;

/// Create a copy of EmergencyAlertSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? overrideQuietHours = null,Object? soundEnabled = null,Object? vibrationEnabled = null,Object? fullScreenAlert = null,Object? emergencyContacts = null,Object? escalationDelayMinutes = null,Object? autoEscalate = null,}) {
  return _then(_EmergencyAlertSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,overrideQuietHours: null == overrideQuietHours ? _self.overrideQuietHours : overrideQuietHours // ignore: cast_nullable_to_non_nullable
as bool,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,fullScreenAlert: null == fullScreenAlert ? _self.fullScreenAlert : fullScreenAlert // ignore: cast_nullable_to_non_nullable
as bool,emergencyContacts: null == emergencyContacts ? _self._emergencyContacts : emergencyContacts // ignore: cast_nullable_to_non_nullable
as List<String>,escalationDelayMinutes: null == escalationDelayMinutes ? _self.escalationDelayMinutes : escalationDelayMinutes // ignore: cast_nullable_to_non_nullable
as int,autoEscalate: null == autoEscalate ? _self.autoEscalate : autoEscalate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$QuietHoursSettings {

 bool get enabled; String get startTime;// 24-hour format
 String get endTime;// 24-hour format
 List<int> get activeDays;// 0-6, Sunday = 0
 List<NotificationType> get allowedTypes; bool get allowEmergencyAlerts;
/// Create a copy of QuietHoursSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuietHoursSettingsCopyWith<QuietHoursSettings> get copyWith => _$QuietHoursSettingsCopyWithImpl<QuietHoursSettings>(this as QuietHoursSettings, _$identity);

  /// Serializes this QuietHoursSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuietHoursSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other.activeDays, activeDays)&&const DeepCollectionEquality().equals(other.allowedTypes, allowedTypes)&&(identical(other.allowEmergencyAlerts, allowEmergencyAlerts) || other.allowEmergencyAlerts == allowEmergencyAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,startTime,endTime,const DeepCollectionEquality().hash(activeDays),const DeepCollectionEquality().hash(allowedTypes),allowEmergencyAlerts);

@override
String toString() {
  return 'QuietHoursSettings(enabled: $enabled, startTime: $startTime, endTime: $endTime, activeDays: $activeDays, allowedTypes: $allowedTypes, allowEmergencyAlerts: $allowEmergencyAlerts)';
}


}

/// @nodoc
abstract mixin class $QuietHoursSettingsCopyWith<$Res>  {
  factory $QuietHoursSettingsCopyWith(QuietHoursSettings value, $Res Function(QuietHoursSettings) _then) = _$QuietHoursSettingsCopyWithImpl;
@useResult
$Res call({
 bool enabled, String startTime, String endTime, List<int> activeDays, List<NotificationType> allowedTypes, bool allowEmergencyAlerts
});




}
/// @nodoc
class _$QuietHoursSettingsCopyWithImpl<$Res>
    implements $QuietHoursSettingsCopyWith<$Res> {
  _$QuietHoursSettingsCopyWithImpl(this._self, this._then);

  final QuietHoursSettings _self;
  final $Res Function(QuietHoursSettings) _then;

/// Create a copy of QuietHoursSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? startTime = null,Object? endTime = null,Object? activeDays = null,Object? allowedTypes = null,Object? allowEmergencyAlerts = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as List<int>,allowedTypes: null == allowedTypes ? _self.allowedTypes : allowedTypes // ignore: cast_nullable_to_non_nullable
as List<NotificationType>,allowEmergencyAlerts: null == allowEmergencyAlerts ? _self.allowEmergencyAlerts : allowEmergencyAlerts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuietHoursSettings].
extension QuietHoursSettingsPatterns on QuietHoursSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuietHoursSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuietHoursSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuietHoursSettings value)  $default,){
final _that = this;
switch (_that) {
case _QuietHoursSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuietHoursSettings value)?  $default,){
final _that = this;
switch (_that) {
case _QuietHoursSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String startTime,  String endTime,  List<int> activeDays,  List<NotificationType> allowedTypes,  bool allowEmergencyAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuietHoursSettings() when $default != null:
return $default(_that.enabled,_that.startTime,_that.endTime,_that.activeDays,_that.allowedTypes,_that.allowEmergencyAlerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String startTime,  String endTime,  List<int> activeDays,  List<NotificationType> allowedTypes,  bool allowEmergencyAlerts)  $default,) {final _that = this;
switch (_that) {
case _QuietHoursSettings():
return $default(_that.enabled,_that.startTime,_that.endTime,_that.activeDays,_that.allowedTypes,_that.allowEmergencyAlerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String startTime,  String endTime,  List<int> activeDays,  List<NotificationType> allowedTypes,  bool allowEmergencyAlerts)?  $default,) {final _that = this;
switch (_that) {
case _QuietHoursSettings() when $default != null:
return $default(_that.enabled,_that.startTime,_that.endTime,_that.activeDays,_that.allowedTypes,_that.allowEmergencyAlerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuietHoursSettings implements QuietHoursSettings {
  const _QuietHoursSettings({this.enabled = false, this.startTime = '22:00', this.endTime = '08:00', final  List<int> activeDays = const [], final  List<NotificationType> allowedTypes = const [], this.allowEmergencyAlerts = true}): _activeDays = activeDays,_allowedTypes = allowedTypes;
  factory _QuietHoursSettings.fromJson(Map<String, dynamic> json) => _$QuietHoursSettingsFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  String startTime;
// 24-hour format
@override@JsonKey() final  String endTime;
// 24-hour format
 final  List<int> _activeDays;
// 24-hour format
@override@JsonKey() List<int> get activeDays {
  if (_activeDays is EqualUnmodifiableListView) return _activeDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeDays);
}

// 0-6, Sunday = 0
 final  List<NotificationType> _allowedTypes;
// 0-6, Sunday = 0
@override@JsonKey() List<NotificationType> get allowedTypes {
  if (_allowedTypes is EqualUnmodifiableListView) return _allowedTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedTypes);
}

@override@JsonKey() final  bool allowEmergencyAlerts;

/// Create a copy of QuietHoursSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietHoursSettingsCopyWith<_QuietHoursSettings> get copyWith => __$QuietHoursSettingsCopyWithImpl<_QuietHoursSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuietHoursSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietHoursSettings&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other._activeDays, _activeDays)&&const DeepCollectionEquality().equals(other._allowedTypes, _allowedTypes)&&(identical(other.allowEmergencyAlerts, allowEmergencyAlerts) || other.allowEmergencyAlerts == allowEmergencyAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,startTime,endTime,const DeepCollectionEquality().hash(_activeDays),const DeepCollectionEquality().hash(_allowedTypes),allowEmergencyAlerts);

@override
String toString() {
  return 'QuietHoursSettings(enabled: $enabled, startTime: $startTime, endTime: $endTime, activeDays: $activeDays, allowedTypes: $allowedTypes, allowEmergencyAlerts: $allowEmergencyAlerts)';
}


}

/// @nodoc
abstract mixin class _$QuietHoursSettingsCopyWith<$Res> implements $QuietHoursSettingsCopyWith<$Res> {
  factory _$QuietHoursSettingsCopyWith(_QuietHoursSettings value, $Res Function(_QuietHoursSettings) _then) = __$QuietHoursSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String startTime, String endTime, List<int> activeDays, List<NotificationType> allowedTypes, bool allowEmergencyAlerts
});




}
/// @nodoc
class __$QuietHoursSettingsCopyWithImpl<$Res>
    implements _$QuietHoursSettingsCopyWith<$Res> {
  __$QuietHoursSettingsCopyWithImpl(this._self, this._then);

  final _QuietHoursSettings _self;
  final $Res Function(_QuietHoursSettings) _then;

/// Create a copy of QuietHoursSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? startTime = null,Object? endTime = null,Object? activeDays = null,Object? allowedTypes = null,Object? allowEmergencyAlerts = null,}) {
  return _then(_QuietHoursSettings(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,activeDays: null == activeDays ? _self._activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as List<int>,allowedTypes: null == allowedTypes ? _self._allowedTypes : allowedTypes // ignore: cast_nullable_to_non_nullable
as List<NotificationType>,allowEmergencyAlerts: null == allowEmergencyAlerts ? _self.allowEmergencyAlerts : allowEmergencyAlerts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EmergencyContact {

 String get id; String get name; String get phoneNumber; String? get email; String get relationship; bool get isPrimary; bool get notifyBySms; bool get notifyByEmail; int get priority;// 1 = highest priority
 DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactCopyWith<EmergencyContact> get copyWith => _$EmergencyContactCopyWithImpl<EmergencyContact>(this as EmergencyContact, _$identity);

  /// Serializes this EmergencyContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContact&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.notifyBySms, notifyBySms) || other.notifyBySms == notifyBySms)&&(identical(other.notifyByEmail, notifyByEmail) || other.notifyByEmail == notifyByEmail)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,email,relationship,isPrimary,notifyBySms,notifyByEmail,priority,createdAt,updatedAt);

@override
String toString() {
  return 'EmergencyContact(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, relationship: $relationship, isPrimary: $isPrimary, notifyBySms: $notifyBySms, notifyByEmail: $notifyByEmail, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactCopyWith<$Res>  {
  factory $EmergencyContactCopyWith(EmergencyContact value, $Res Function(EmergencyContact) _then) = _$EmergencyContactCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phoneNumber, String? email, String relationship, bool isPrimary, bool notifyBySms, bool notifyByEmail, int priority, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$EmergencyContactCopyWithImpl<$Res>
    implements $EmergencyContactCopyWith<$Res> {
  _$EmergencyContactCopyWithImpl(this._self, this._then);

  final EmergencyContact _self;
  final $Res Function(EmergencyContact) _then;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? email = freezed,Object? relationship = null,Object? isPrimary = null,Object? notifyBySms = null,Object? notifyByEmail = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,notifyBySms: null == notifyBySms ? _self.notifyBySms : notifyBySms // ignore: cast_nullable_to_non_nullable
as bool,notifyByEmail: null == notifyByEmail ? _self.notifyByEmail : notifyByEmail // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyContact].
extension EmergencyContactPatterns on EmergencyContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContact value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContact value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  String? email,  String relationship,  bool isPrimary,  bool notifyBySms,  bool notifyByEmail,  int priority,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.relationship,_that.isPrimary,_that.notifyBySms,_that.notifyByEmail,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  String? email,  String relationship,  bool isPrimary,  bool notifyBySms,  bool notifyByEmail,  int priority,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContact():
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.relationship,_that.isPrimary,_that.notifyBySms,_that.notifyByEmail,_that.priority,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phoneNumber,  String? email,  String relationship,  bool isPrimary,  bool notifyBySms,  bool notifyByEmail,  int priority,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.email,_that.relationship,_that.isPrimary,_that.notifyBySms,_that.notifyByEmail,_that.priority,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContact implements EmergencyContact {
  const _EmergencyContact({required this.id, required this.name, required this.phoneNumber, this.email, required this.relationship, this.isPrimary = true, this.notifyBySms = true, this.notifyByEmail = false, this.priority = 1, required this.createdAt, this.updatedAt});
  factory _EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phoneNumber;
@override final  String? email;
@override final  String relationship;
@override@JsonKey() final  bool isPrimary;
@override@JsonKey() final  bool notifyBySms;
@override@JsonKey() final  bool notifyByEmail;
@override@JsonKey() final  int priority;
// 1 = highest priority
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactCopyWith<_EmergencyContact> get copyWith => __$EmergencyContactCopyWithImpl<_EmergencyContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContact&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.email, email) || other.email == email)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.notifyBySms, notifyBySms) || other.notifyBySms == notifyBySms)&&(identical(other.notifyByEmail, notifyByEmail) || other.notifyByEmail == notifyByEmail)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,email,relationship,isPrimary,notifyBySms,notifyByEmail,priority,createdAt,updatedAt);

@override
String toString() {
  return 'EmergencyContact(id: $id, name: $name, phoneNumber: $phoneNumber, email: $email, relationship: $relationship, isPrimary: $isPrimary, notifyBySms: $notifyBySms, notifyByEmail: $notifyByEmail, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactCopyWith<$Res> implements $EmergencyContactCopyWith<$Res> {
  factory _$EmergencyContactCopyWith(_EmergencyContact value, $Res Function(_EmergencyContact) _then) = __$EmergencyContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phoneNumber, String? email, String relationship, bool isPrimary, bool notifyBySms, bool notifyByEmail, int priority, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$EmergencyContactCopyWithImpl<$Res>
    implements _$EmergencyContactCopyWith<$Res> {
  __$EmergencyContactCopyWithImpl(this._self, this._then);

  final _EmergencyContact _self;
  final $Res Function(_EmergencyContact) _then;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? email = freezed,Object? relationship = null,Object? isPrimary = null,Object? notifyBySms = null,Object? notifyByEmail = null,Object? priority = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_EmergencyContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,notifyBySms: null == notifyBySms ? _self.notifyBySms : notifyBySms // ignore: cast_nullable_to_non_nullable
as bool,notifyByEmail: null == notifyByEmail ? _self.notifyByEmail : notifyByEmail // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
