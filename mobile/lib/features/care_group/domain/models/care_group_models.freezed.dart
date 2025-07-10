// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'care_group_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CareGroupSettings {

 bool get allowHealthDataSharing; bool get allowMedicationSharing; bool get requireApprovalForNewMembers; bool get enableTaskNotifications; bool get enableActivityFeed; String get defaultMemberRole; int get inviteExpirationDays;
/// Create a copy of CareGroupSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGroupSettingsCopyWith<CareGroupSettings> get copyWith => _$CareGroupSettingsCopyWithImpl<CareGroupSettings>(this as CareGroupSettings, _$identity);

  /// Serializes this CareGroupSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGroupSettings&&(identical(other.allowHealthDataSharing, allowHealthDataSharing) || other.allowHealthDataSharing == allowHealthDataSharing)&&(identical(other.allowMedicationSharing, allowMedicationSharing) || other.allowMedicationSharing == allowMedicationSharing)&&(identical(other.requireApprovalForNewMembers, requireApprovalForNewMembers) || other.requireApprovalForNewMembers == requireApprovalForNewMembers)&&(identical(other.enableTaskNotifications, enableTaskNotifications) || other.enableTaskNotifications == enableTaskNotifications)&&(identical(other.enableActivityFeed, enableActivityFeed) || other.enableActivityFeed == enableActivityFeed)&&(identical(other.defaultMemberRole, defaultMemberRole) || other.defaultMemberRole == defaultMemberRole)&&(identical(other.inviteExpirationDays, inviteExpirationDays) || other.inviteExpirationDays == inviteExpirationDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowHealthDataSharing,allowMedicationSharing,requireApprovalForNewMembers,enableTaskNotifications,enableActivityFeed,defaultMemberRole,inviteExpirationDays);

@override
String toString() {
  return 'CareGroupSettings(allowHealthDataSharing: $allowHealthDataSharing, allowMedicationSharing: $allowMedicationSharing, requireApprovalForNewMembers: $requireApprovalForNewMembers, enableTaskNotifications: $enableTaskNotifications, enableActivityFeed: $enableActivityFeed, defaultMemberRole: $defaultMemberRole, inviteExpirationDays: $inviteExpirationDays)';
}


}

/// @nodoc
abstract mixin class $CareGroupSettingsCopyWith<$Res>  {
  factory $CareGroupSettingsCopyWith(CareGroupSettings value, $Res Function(CareGroupSettings) _then) = _$CareGroupSettingsCopyWithImpl;
@useResult
$Res call({
 bool allowHealthDataSharing, bool allowMedicationSharing, bool requireApprovalForNewMembers, bool enableTaskNotifications, bool enableActivityFeed, String defaultMemberRole, int inviteExpirationDays
});




}
/// @nodoc
class _$CareGroupSettingsCopyWithImpl<$Res>
    implements $CareGroupSettingsCopyWith<$Res> {
  _$CareGroupSettingsCopyWithImpl(this._self, this._then);

  final CareGroupSettings _self;
  final $Res Function(CareGroupSettings) _then;

/// Create a copy of CareGroupSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allowHealthDataSharing = null,Object? allowMedicationSharing = null,Object? requireApprovalForNewMembers = null,Object? enableTaskNotifications = null,Object? enableActivityFeed = null,Object? defaultMemberRole = null,Object? inviteExpirationDays = null,}) {
  return _then(_self.copyWith(
allowHealthDataSharing: null == allowHealthDataSharing ? _self.allowHealthDataSharing : allowHealthDataSharing // ignore: cast_nullable_to_non_nullable
as bool,allowMedicationSharing: null == allowMedicationSharing ? _self.allowMedicationSharing : allowMedicationSharing // ignore: cast_nullable_to_non_nullable
as bool,requireApprovalForNewMembers: null == requireApprovalForNewMembers ? _self.requireApprovalForNewMembers : requireApprovalForNewMembers // ignore: cast_nullable_to_non_nullable
as bool,enableTaskNotifications: null == enableTaskNotifications ? _self.enableTaskNotifications : enableTaskNotifications // ignore: cast_nullable_to_non_nullable
as bool,enableActivityFeed: null == enableActivityFeed ? _self.enableActivityFeed : enableActivityFeed // ignore: cast_nullable_to_non_nullable
as bool,defaultMemberRole: null == defaultMemberRole ? _self.defaultMemberRole : defaultMemberRole // ignore: cast_nullable_to_non_nullable
as String,inviteExpirationDays: null == inviteExpirationDays ? _self.inviteExpirationDays : inviteExpirationDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CareGroupSettings].
extension CareGroupSettingsPatterns on CareGroupSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareGroupSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareGroupSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareGroupSettings value)  $default,){
final _that = this;
switch (_that) {
case _CareGroupSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareGroupSettings value)?  $default,){
final _that = this;
switch (_that) {
case _CareGroupSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allowHealthDataSharing,  bool allowMedicationSharing,  bool requireApprovalForNewMembers,  bool enableTaskNotifications,  bool enableActivityFeed,  String defaultMemberRole,  int inviteExpirationDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareGroupSettings() when $default != null:
return $default(_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.requireApprovalForNewMembers,_that.enableTaskNotifications,_that.enableActivityFeed,_that.defaultMemberRole,_that.inviteExpirationDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allowHealthDataSharing,  bool allowMedicationSharing,  bool requireApprovalForNewMembers,  bool enableTaskNotifications,  bool enableActivityFeed,  String defaultMemberRole,  int inviteExpirationDays)  $default,) {final _that = this;
switch (_that) {
case _CareGroupSettings():
return $default(_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.requireApprovalForNewMembers,_that.enableTaskNotifications,_that.enableActivityFeed,_that.defaultMemberRole,_that.inviteExpirationDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allowHealthDataSharing,  bool allowMedicationSharing,  bool requireApprovalForNewMembers,  bool enableTaskNotifications,  bool enableActivityFeed,  String defaultMemberRole,  int inviteExpirationDays)?  $default,) {final _that = this;
switch (_that) {
case _CareGroupSettings() when $default != null:
return $default(_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.requireApprovalForNewMembers,_that.enableTaskNotifications,_that.enableActivityFeed,_that.defaultMemberRole,_that.inviteExpirationDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareGroupSettings implements CareGroupSettings {
  const _CareGroupSettings({this.allowHealthDataSharing = true, this.allowMedicationSharing = true, this.requireApprovalForNewMembers = false, this.enableTaskNotifications = true, this.enableActivityFeed = true, this.defaultMemberRole = 'CAREGIVER', this.inviteExpirationDays = 30});
  factory _CareGroupSettings.fromJson(Map<String, dynamic> json) => _$CareGroupSettingsFromJson(json);

@override@JsonKey() final  bool allowHealthDataSharing;
@override@JsonKey() final  bool allowMedicationSharing;
@override@JsonKey() final  bool requireApprovalForNewMembers;
@override@JsonKey() final  bool enableTaskNotifications;
@override@JsonKey() final  bool enableActivityFeed;
@override@JsonKey() final  String defaultMemberRole;
@override@JsonKey() final  int inviteExpirationDays;

/// Create a copy of CareGroupSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareGroupSettingsCopyWith<_CareGroupSettings> get copyWith => __$CareGroupSettingsCopyWithImpl<_CareGroupSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareGroupSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareGroupSettings&&(identical(other.allowHealthDataSharing, allowHealthDataSharing) || other.allowHealthDataSharing == allowHealthDataSharing)&&(identical(other.allowMedicationSharing, allowMedicationSharing) || other.allowMedicationSharing == allowMedicationSharing)&&(identical(other.requireApprovalForNewMembers, requireApprovalForNewMembers) || other.requireApprovalForNewMembers == requireApprovalForNewMembers)&&(identical(other.enableTaskNotifications, enableTaskNotifications) || other.enableTaskNotifications == enableTaskNotifications)&&(identical(other.enableActivityFeed, enableActivityFeed) || other.enableActivityFeed == enableActivityFeed)&&(identical(other.defaultMemberRole, defaultMemberRole) || other.defaultMemberRole == defaultMemberRole)&&(identical(other.inviteExpirationDays, inviteExpirationDays) || other.inviteExpirationDays == inviteExpirationDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allowHealthDataSharing,allowMedicationSharing,requireApprovalForNewMembers,enableTaskNotifications,enableActivityFeed,defaultMemberRole,inviteExpirationDays);

@override
String toString() {
  return 'CareGroupSettings(allowHealthDataSharing: $allowHealthDataSharing, allowMedicationSharing: $allowMedicationSharing, requireApprovalForNewMembers: $requireApprovalForNewMembers, enableTaskNotifications: $enableTaskNotifications, enableActivityFeed: $enableActivityFeed, defaultMemberRole: $defaultMemberRole, inviteExpirationDays: $inviteExpirationDays)';
}


}

/// @nodoc
abstract mixin class _$CareGroupSettingsCopyWith<$Res> implements $CareGroupSettingsCopyWith<$Res> {
  factory _$CareGroupSettingsCopyWith(_CareGroupSettings value, $Res Function(_CareGroupSettings) _then) = __$CareGroupSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool allowHealthDataSharing, bool allowMedicationSharing, bool requireApprovalForNewMembers, bool enableTaskNotifications, bool enableActivityFeed, String defaultMemberRole, int inviteExpirationDays
});




}
/// @nodoc
class __$CareGroupSettingsCopyWithImpl<$Res>
    implements _$CareGroupSettingsCopyWith<$Res> {
  __$CareGroupSettingsCopyWithImpl(this._self, this._then);

  final _CareGroupSettings _self;
  final $Res Function(_CareGroupSettings) _then;

/// Create a copy of CareGroupSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allowHealthDataSharing = null,Object? allowMedicationSharing = null,Object? requireApprovalForNewMembers = null,Object? enableTaskNotifications = null,Object? enableActivityFeed = null,Object? defaultMemberRole = null,Object? inviteExpirationDays = null,}) {
  return _then(_CareGroupSettings(
allowHealthDataSharing: null == allowHealthDataSharing ? _self.allowHealthDataSharing : allowHealthDataSharing // ignore: cast_nullable_to_non_nullable
as bool,allowMedicationSharing: null == allowMedicationSharing ? _self.allowMedicationSharing : allowMedicationSharing // ignore: cast_nullable_to_non_nullable
as bool,requireApprovalForNewMembers: null == requireApprovalForNewMembers ? _self.requireApprovalForNewMembers : requireApprovalForNewMembers // ignore: cast_nullable_to_non_nullable
as bool,enableTaskNotifications: null == enableTaskNotifications ? _self.enableTaskNotifications : enableTaskNotifications // ignore: cast_nullable_to_non_nullable
as bool,enableActivityFeed: null == enableActivityFeed ? _self.enableActivityFeed : enableActivityFeed // ignore: cast_nullable_to_non_nullable
as bool,defaultMemberRole: null == defaultMemberRole ? _self.defaultMemberRole : defaultMemberRole // ignore: cast_nullable_to_non_nullable
as String,inviteExpirationDays: null == inviteExpirationDays ? _self.inviteExpirationDays : inviteExpirationDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MemberNotificationPreferences {

 bool get taskAssignments; bool get taskReminders; bool get groupActivity; bool get healthUpdates; bool get medicationReminders; bool get dailyDigest; String get urgentAlerts;
/// Create a copy of MemberNotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberNotificationPreferencesCopyWith<MemberNotificationPreferences> get copyWith => _$MemberNotificationPreferencesCopyWithImpl<MemberNotificationPreferences>(this as MemberNotificationPreferences, _$identity);

  /// Serializes this MemberNotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberNotificationPreferences&&(identical(other.taskAssignments, taskAssignments) || other.taskAssignments == taskAssignments)&&(identical(other.taskReminders, taskReminders) || other.taskReminders == taskReminders)&&(identical(other.groupActivity, groupActivity) || other.groupActivity == groupActivity)&&(identical(other.healthUpdates, healthUpdates) || other.healthUpdates == healthUpdates)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.dailyDigest, dailyDigest) || other.dailyDigest == dailyDigest)&&(identical(other.urgentAlerts, urgentAlerts) || other.urgentAlerts == urgentAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskAssignments,taskReminders,groupActivity,healthUpdates,medicationReminders,dailyDigest,urgentAlerts);

@override
String toString() {
  return 'MemberNotificationPreferences(taskAssignments: $taskAssignments, taskReminders: $taskReminders, groupActivity: $groupActivity, healthUpdates: $healthUpdates, medicationReminders: $medicationReminders, dailyDigest: $dailyDigest, urgentAlerts: $urgentAlerts)';
}


}

/// @nodoc
abstract mixin class $MemberNotificationPreferencesCopyWith<$Res>  {
  factory $MemberNotificationPreferencesCopyWith(MemberNotificationPreferences value, $Res Function(MemberNotificationPreferences) _then) = _$MemberNotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool taskAssignments, bool taskReminders, bool groupActivity, bool healthUpdates, bool medicationReminders, bool dailyDigest, String urgentAlerts
});




}
/// @nodoc
class _$MemberNotificationPreferencesCopyWithImpl<$Res>
    implements $MemberNotificationPreferencesCopyWith<$Res> {
  _$MemberNotificationPreferencesCopyWithImpl(this._self, this._then);

  final MemberNotificationPreferences _self;
  final $Res Function(MemberNotificationPreferences) _then;

/// Create a copy of MemberNotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskAssignments = null,Object? taskReminders = null,Object? groupActivity = null,Object? healthUpdates = null,Object? medicationReminders = null,Object? dailyDigest = null,Object? urgentAlerts = null,}) {
  return _then(_self.copyWith(
taskAssignments: null == taskAssignments ? _self.taskAssignments : taskAssignments // ignore: cast_nullable_to_non_nullable
as bool,taskReminders: null == taskReminders ? _self.taskReminders : taskReminders // ignore: cast_nullable_to_non_nullable
as bool,groupActivity: null == groupActivity ? _self.groupActivity : groupActivity // ignore: cast_nullable_to_non_nullable
as bool,healthUpdates: null == healthUpdates ? _self.healthUpdates : healthUpdates // ignore: cast_nullable_to_non_nullable
as bool,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,dailyDigest: null == dailyDigest ? _self.dailyDigest : dailyDigest // ignore: cast_nullable_to_non_nullable
as bool,urgentAlerts: null == urgentAlerts ? _self.urgentAlerts : urgentAlerts // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberNotificationPreferences].
extension MemberNotificationPreferencesPatterns on MemberNotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberNotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberNotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberNotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _MemberNotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberNotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _MemberNotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool taskAssignments,  bool taskReminders,  bool groupActivity,  bool healthUpdates,  bool medicationReminders,  bool dailyDigest,  String urgentAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberNotificationPreferences() when $default != null:
return $default(_that.taskAssignments,_that.taskReminders,_that.groupActivity,_that.healthUpdates,_that.medicationReminders,_that.dailyDigest,_that.urgentAlerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool taskAssignments,  bool taskReminders,  bool groupActivity,  bool healthUpdates,  bool medicationReminders,  bool dailyDigest,  String urgentAlerts)  $default,) {final _that = this;
switch (_that) {
case _MemberNotificationPreferences():
return $default(_that.taskAssignments,_that.taskReminders,_that.groupActivity,_that.healthUpdates,_that.medicationReminders,_that.dailyDigest,_that.urgentAlerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool taskAssignments,  bool taskReminders,  bool groupActivity,  bool healthUpdates,  bool medicationReminders,  bool dailyDigest,  String urgentAlerts)?  $default,) {final _that = this;
switch (_that) {
case _MemberNotificationPreferences() when $default != null:
return $default(_that.taskAssignments,_that.taskReminders,_that.groupActivity,_that.healthUpdates,_that.medicationReminders,_that.dailyDigest,_that.urgentAlerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberNotificationPreferences implements MemberNotificationPreferences {
  const _MemberNotificationPreferences({this.taskAssignments = true, this.taskReminders = true, this.groupActivity = true, this.healthUpdates = true, this.medicationReminders = true, this.dailyDigest = false, this.urgentAlerts = 'IMMEDIATE'});
  factory _MemberNotificationPreferences.fromJson(Map<String, dynamic> json) => _$MemberNotificationPreferencesFromJson(json);

@override@JsonKey() final  bool taskAssignments;
@override@JsonKey() final  bool taskReminders;
@override@JsonKey() final  bool groupActivity;
@override@JsonKey() final  bool healthUpdates;
@override@JsonKey() final  bool medicationReminders;
@override@JsonKey() final  bool dailyDigest;
@override@JsonKey() final  String urgentAlerts;

/// Create a copy of MemberNotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberNotificationPreferencesCopyWith<_MemberNotificationPreferences> get copyWith => __$MemberNotificationPreferencesCopyWithImpl<_MemberNotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberNotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberNotificationPreferences&&(identical(other.taskAssignments, taskAssignments) || other.taskAssignments == taskAssignments)&&(identical(other.taskReminders, taskReminders) || other.taskReminders == taskReminders)&&(identical(other.groupActivity, groupActivity) || other.groupActivity == groupActivity)&&(identical(other.healthUpdates, healthUpdates) || other.healthUpdates == healthUpdates)&&(identical(other.medicationReminders, medicationReminders) || other.medicationReminders == medicationReminders)&&(identical(other.dailyDigest, dailyDigest) || other.dailyDigest == dailyDigest)&&(identical(other.urgentAlerts, urgentAlerts) || other.urgentAlerts == urgentAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskAssignments,taskReminders,groupActivity,healthUpdates,medicationReminders,dailyDigest,urgentAlerts);

@override
String toString() {
  return 'MemberNotificationPreferences(taskAssignments: $taskAssignments, taskReminders: $taskReminders, groupActivity: $groupActivity, healthUpdates: $healthUpdates, medicationReminders: $medicationReminders, dailyDigest: $dailyDigest, urgentAlerts: $urgentAlerts)';
}


}

/// @nodoc
abstract mixin class _$MemberNotificationPreferencesCopyWith<$Res> implements $MemberNotificationPreferencesCopyWith<$Res> {
  factory _$MemberNotificationPreferencesCopyWith(_MemberNotificationPreferences value, $Res Function(_MemberNotificationPreferences) _then) = __$MemberNotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool taskAssignments, bool taskReminders, bool groupActivity, bool healthUpdates, bool medicationReminders, bool dailyDigest, String urgentAlerts
});




}
/// @nodoc
class __$MemberNotificationPreferencesCopyWithImpl<$Res>
    implements _$MemberNotificationPreferencesCopyWith<$Res> {
  __$MemberNotificationPreferencesCopyWithImpl(this._self, this._then);

  final _MemberNotificationPreferences _self;
  final $Res Function(_MemberNotificationPreferences) _then;

/// Create a copy of MemberNotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskAssignments = null,Object? taskReminders = null,Object? groupActivity = null,Object? healthUpdates = null,Object? medicationReminders = null,Object? dailyDigest = null,Object? urgentAlerts = null,}) {
  return _then(_MemberNotificationPreferences(
taskAssignments: null == taskAssignments ? _self.taskAssignments : taskAssignments // ignore: cast_nullable_to_non_nullable
as bool,taskReminders: null == taskReminders ? _self.taskReminders : taskReminders // ignore: cast_nullable_to_non_nullable
as bool,groupActivity: null == groupActivity ? _self.groupActivity : groupActivity // ignore: cast_nullable_to_non_nullable
as bool,healthUpdates: null == healthUpdates ? _self.healthUpdates : healthUpdates // ignore: cast_nullable_to_non_nullable
as bool,medicationReminders: null == medicationReminders ? _self.medicationReminders : medicationReminders // ignore: cast_nullable_to_non_nullable
as bool,dailyDigest: null == dailyDigest ? _self.dailyDigest : dailyDigest // ignore: cast_nullable_to_non_nullable
as bool,urgentAlerts: null == urgentAlerts ? _self.urgentAlerts : urgentAlerts // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CareGroupMember {

 String get id; String get groupId; String get userId; String get displayName; String? get email; String? get photoUrl; MemberRole get role; String? get customTitle; DateTime get joinedAt; String? get invitedBy; bool get isActive; DateTime? get lastActive; MemberNotificationPreferences get notificationPreferences;
/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGroupMemberCopyWith<CareGroupMember> get copyWith => _$CareGroupMemberCopyWithImpl<CareGroupMember>(this as CareGroupMember, _$identity);

  /// Serializes this CareGroupMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGroupMember&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastActive, lastActive) || other.lastActive == lastActive)&&(identical(other.notificationPreferences, notificationPreferences) || other.notificationPreferences == notificationPreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,userId,displayName,email,photoUrl,role,customTitle,joinedAt,invitedBy,isActive,lastActive,notificationPreferences);

@override
String toString() {
  return 'CareGroupMember(id: $id, groupId: $groupId, userId: $userId, displayName: $displayName, email: $email, photoUrl: $photoUrl, role: $role, customTitle: $customTitle, joinedAt: $joinedAt, invitedBy: $invitedBy, isActive: $isActive, lastActive: $lastActive, notificationPreferences: $notificationPreferences)';
}


}

/// @nodoc
abstract mixin class $CareGroupMemberCopyWith<$Res>  {
  factory $CareGroupMemberCopyWith(CareGroupMember value, $Res Function(CareGroupMember) _then) = _$CareGroupMemberCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String userId, String displayName, String? email, String? photoUrl, MemberRole role, String? customTitle, DateTime joinedAt, String? invitedBy, bool isActive, DateTime? lastActive, MemberNotificationPreferences notificationPreferences
});


$MemberNotificationPreferencesCopyWith<$Res> get notificationPreferences;

}
/// @nodoc
class _$CareGroupMemberCopyWithImpl<$Res>
    implements $CareGroupMemberCopyWith<$Res> {
  _$CareGroupMemberCopyWithImpl(this._self, this._then);

  final CareGroupMember _self;
  final $Res Function(CareGroupMember) _then;

/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? userId = null,Object? displayName = null,Object? email = freezed,Object? photoUrl = freezed,Object? role = null,Object? customTitle = freezed,Object? joinedAt = null,Object? invitedBy = freezed,Object? isActive = null,Object? lastActive = freezed,Object? notificationPreferences = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastActive: freezed == lastActive ? _self.lastActive : lastActive // ignore: cast_nullable_to_non_nullable
as DateTime?,notificationPreferences: null == notificationPreferences ? _self.notificationPreferences : notificationPreferences // ignore: cast_nullable_to_non_nullable
as MemberNotificationPreferences,
  ));
}
/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberNotificationPreferencesCopyWith<$Res> get notificationPreferences {
  
  return $MemberNotificationPreferencesCopyWith<$Res>(_self.notificationPreferences, (value) {
    return _then(_self.copyWith(notificationPreferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [CareGroupMember].
extension CareGroupMemberPatterns on CareGroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareGroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareGroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareGroupMember value)  $default,){
final _that = this;
switch (_that) {
case _CareGroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareGroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _CareGroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String userId,  String displayName,  String? email,  String? photoUrl,  MemberRole role,  String? customTitle,  DateTime joinedAt,  String? invitedBy,  bool isActive,  DateTime? lastActive,  MemberNotificationPreferences notificationPreferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareGroupMember() when $default != null:
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.customTitle,_that.joinedAt,_that.invitedBy,_that.isActive,_that.lastActive,_that.notificationPreferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String userId,  String displayName,  String? email,  String? photoUrl,  MemberRole role,  String? customTitle,  DateTime joinedAt,  String? invitedBy,  bool isActive,  DateTime? lastActive,  MemberNotificationPreferences notificationPreferences)  $default,) {final _that = this;
switch (_that) {
case _CareGroupMember():
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.customTitle,_that.joinedAt,_that.invitedBy,_that.isActive,_that.lastActive,_that.notificationPreferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String userId,  String displayName,  String? email,  String? photoUrl,  MemberRole role,  String? customTitle,  DateTime joinedAt,  String? invitedBy,  bool isActive,  DateTime? lastActive,  MemberNotificationPreferences notificationPreferences)?  $default,) {final _that = this;
switch (_that) {
case _CareGroupMember() when $default != null:
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.email,_that.photoUrl,_that.role,_that.customTitle,_that.joinedAt,_that.invitedBy,_that.isActive,_that.lastActive,_that.notificationPreferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareGroupMember implements CareGroupMember {
  const _CareGroupMember({required this.id, required this.groupId, required this.userId, required this.displayName, this.email, this.photoUrl, required this.role, this.customTitle, required this.joinedAt, this.invitedBy, required this.isActive, this.lastActive, this.notificationPreferences = const MemberNotificationPreferences()});
  factory _CareGroupMember.fromJson(Map<String, dynamic> json) => _$CareGroupMemberFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String userId;
@override final  String displayName;
@override final  String? email;
@override final  String? photoUrl;
@override final  MemberRole role;
@override final  String? customTitle;
@override final  DateTime joinedAt;
@override final  String? invitedBy;
@override final  bool isActive;
@override final  DateTime? lastActive;
@override@JsonKey() final  MemberNotificationPreferences notificationPreferences;

/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareGroupMemberCopyWith<_CareGroupMember> get copyWith => __$CareGroupMemberCopyWithImpl<_CareGroupMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareGroupMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareGroupMember&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastActive, lastActive) || other.lastActive == lastActive)&&(identical(other.notificationPreferences, notificationPreferences) || other.notificationPreferences == notificationPreferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,userId,displayName,email,photoUrl,role,customTitle,joinedAt,invitedBy,isActive,lastActive,notificationPreferences);

@override
String toString() {
  return 'CareGroupMember(id: $id, groupId: $groupId, userId: $userId, displayName: $displayName, email: $email, photoUrl: $photoUrl, role: $role, customTitle: $customTitle, joinedAt: $joinedAt, invitedBy: $invitedBy, isActive: $isActive, lastActive: $lastActive, notificationPreferences: $notificationPreferences)';
}


}

/// @nodoc
abstract mixin class _$CareGroupMemberCopyWith<$Res> implements $CareGroupMemberCopyWith<$Res> {
  factory _$CareGroupMemberCopyWith(_CareGroupMember value, $Res Function(_CareGroupMember) _then) = __$CareGroupMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String userId, String displayName, String? email, String? photoUrl, MemberRole role, String? customTitle, DateTime joinedAt, String? invitedBy, bool isActive, DateTime? lastActive, MemberNotificationPreferences notificationPreferences
});


@override $MemberNotificationPreferencesCopyWith<$Res> get notificationPreferences;

}
/// @nodoc
class __$CareGroupMemberCopyWithImpl<$Res>
    implements _$CareGroupMemberCopyWith<$Res> {
  __$CareGroupMemberCopyWithImpl(this._self, this._then);

  final _CareGroupMember _self;
  final $Res Function(_CareGroupMember) _then;

/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? userId = null,Object? displayName = null,Object? email = freezed,Object? photoUrl = freezed,Object? role = null,Object? customTitle = freezed,Object? joinedAt = null,Object? invitedBy = freezed,Object? isActive = null,Object? lastActive = freezed,Object? notificationPreferences = null,}) {
  return _then(_CareGroupMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,invitedBy: freezed == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastActive: freezed == lastActive ? _self.lastActive : lastActive // ignore: cast_nullable_to_non_nullable
as DateTime?,notificationPreferences: null == notificationPreferences ? _self.notificationPreferences : notificationPreferences // ignore: cast_nullable_to_non_nullable
as MemberNotificationPreferences,
  ));
}

/// Create a copy of CareGroupMember
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberNotificationPreferencesCopyWith<$Res> get notificationPreferences {
  
  return $MemberNotificationPreferencesCopyWith<$Res>(_self.notificationPreferences, (value) {
    return _then(_self.copyWith(notificationPreferences: value));
  });
}
}


/// @nodoc
mixin _$CareRecipient {

 String get id; String get groupId; String get userId; String get displayName; String? get relationship; DateTime? get dateOfBirth; String? get medicalConditions; String? get emergencyContact; String? get primaryPhysician; String? get insuranceInfo; bool get allowHealthDataSharing; bool get allowMedicationSharing; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of CareRecipient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareRecipientCopyWith<CareRecipient> get copyWith => _$CareRecipientCopyWithImpl<CareRecipient>(this as CareRecipient, _$identity);

  /// Serializes this CareRecipient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareRecipient&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.medicalConditions, medicalConditions) || other.medicalConditions == medicalConditions)&&(identical(other.emergencyContact, emergencyContact) || other.emergencyContact == emergencyContact)&&(identical(other.primaryPhysician, primaryPhysician) || other.primaryPhysician == primaryPhysician)&&(identical(other.insuranceInfo, insuranceInfo) || other.insuranceInfo == insuranceInfo)&&(identical(other.allowHealthDataSharing, allowHealthDataSharing) || other.allowHealthDataSharing == allowHealthDataSharing)&&(identical(other.allowMedicationSharing, allowMedicationSharing) || other.allowMedicationSharing == allowMedicationSharing)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,userId,displayName,relationship,dateOfBirth,medicalConditions,emergencyContact,primaryPhysician,insuranceInfo,allowHealthDataSharing,allowMedicationSharing,createdAt,updatedAt);

@override
String toString() {
  return 'CareRecipient(id: $id, groupId: $groupId, userId: $userId, displayName: $displayName, relationship: $relationship, dateOfBirth: $dateOfBirth, medicalConditions: $medicalConditions, emergencyContact: $emergencyContact, primaryPhysician: $primaryPhysician, insuranceInfo: $insuranceInfo, allowHealthDataSharing: $allowHealthDataSharing, allowMedicationSharing: $allowMedicationSharing, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CareRecipientCopyWith<$Res>  {
  factory $CareRecipientCopyWith(CareRecipient value, $Res Function(CareRecipient) _then) = _$CareRecipientCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String userId, String displayName, String? relationship, DateTime? dateOfBirth, String? medicalConditions, String? emergencyContact, String? primaryPhysician, String? insuranceInfo, bool allowHealthDataSharing, bool allowMedicationSharing, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$CareRecipientCopyWithImpl<$Res>
    implements $CareRecipientCopyWith<$Res> {
  _$CareRecipientCopyWithImpl(this._self, this._then);

  final CareRecipient _self;
  final $Res Function(CareRecipient) _then;

/// Create a copy of CareRecipient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? userId = null,Object? displayName = null,Object? relationship = freezed,Object? dateOfBirth = freezed,Object? medicalConditions = freezed,Object? emergencyContact = freezed,Object? primaryPhysician = freezed,Object? insuranceInfo = freezed,Object? allowHealthDataSharing = null,Object? allowMedicationSharing = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,medicalConditions: freezed == medicalConditions ? _self.medicalConditions : medicalConditions // ignore: cast_nullable_to_non_nullable
as String?,emergencyContact: freezed == emergencyContact ? _self.emergencyContact : emergencyContact // ignore: cast_nullable_to_non_nullable
as String?,primaryPhysician: freezed == primaryPhysician ? _self.primaryPhysician : primaryPhysician // ignore: cast_nullable_to_non_nullable
as String?,insuranceInfo: freezed == insuranceInfo ? _self.insuranceInfo : insuranceInfo // ignore: cast_nullable_to_non_nullable
as String?,allowHealthDataSharing: null == allowHealthDataSharing ? _self.allowHealthDataSharing : allowHealthDataSharing // ignore: cast_nullable_to_non_nullable
as bool,allowMedicationSharing: null == allowMedicationSharing ? _self.allowMedicationSharing : allowMedicationSharing // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CareRecipient].
extension CareRecipientPatterns on CareRecipient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareRecipient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareRecipient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareRecipient value)  $default,){
final _that = this;
switch (_that) {
case _CareRecipient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareRecipient value)?  $default,){
final _that = this;
switch (_that) {
case _CareRecipient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String userId,  String displayName,  String? relationship,  DateTime? dateOfBirth,  String? medicalConditions,  String? emergencyContact,  String? primaryPhysician,  String? insuranceInfo,  bool allowHealthDataSharing,  bool allowMedicationSharing,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareRecipient() when $default != null:
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.relationship,_that.dateOfBirth,_that.medicalConditions,_that.emergencyContact,_that.primaryPhysician,_that.insuranceInfo,_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String userId,  String displayName,  String? relationship,  DateTime? dateOfBirth,  String? medicalConditions,  String? emergencyContact,  String? primaryPhysician,  String? insuranceInfo,  bool allowHealthDataSharing,  bool allowMedicationSharing,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CareRecipient():
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.relationship,_that.dateOfBirth,_that.medicalConditions,_that.emergencyContact,_that.primaryPhysician,_that.insuranceInfo,_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String userId,  String displayName,  String? relationship,  DateTime? dateOfBirth,  String? medicalConditions,  String? emergencyContact,  String? primaryPhysician,  String? insuranceInfo,  bool allowHealthDataSharing,  bool allowMedicationSharing,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CareRecipient() when $default != null:
return $default(_that.id,_that.groupId,_that.userId,_that.displayName,_that.relationship,_that.dateOfBirth,_that.medicalConditions,_that.emergencyContact,_that.primaryPhysician,_that.insuranceInfo,_that.allowHealthDataSharing,_that.allowMedicationSharing,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareRecipient implements CareRecipient {
  const _CareRecipient({required this.id, required this.groupId, required this.userId, required this.displayName, this.relationship, this.dateOfBirth, this.medicalConditions, this.emergencyContact, this.primaryPhysician, this.insuranceInfo, this.allowHealthDataSharing = true, this.allowMedicationSharing = true, required this.createdAt, required this.updatedAt});
  factory _CareRecipient.fromJson(Map<String, dynamic> json) => _$CareRecipientFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String userId;
@override final  String displayName;
@override final  String? relationship;
@override final  DateTime? dateOfBirth;
@override final  String? medicalConditions;
@override final  String? emergencyContact;
@override final  String? primaryPhysician;
@override final  String? insuranceInfo;
@override@JsonKey() final  bool allowHealthDataSharing;
@override@JsonKey() final  bool allowMedicationSharing;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of CareRecipient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareRecipientCopyWith<_CareRecipient> get copyWith => __$CareRecipientCopyWithImpl<_CareRecipient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareRecipientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareRecipient&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.medicalConditions, medicalConditions) || other.medicalConditions == medicalConditions)&&(identical(other.emergencyContact, emergencyContact) || other.emergencyContact == emergencyContact)&&(identical(other.primaryPhysician, primaryPhysician) || other.primaryPhysician == primaryPhysician)&&(identical(other.insuranceInfo, insuranceInfo) || other.insuranceInfo == insuranceInfo)&&(identical(other.allowHealthDataSharing, allowHealthDataSharing) || other.allowHealthDataSharing == allowHealthDataSharing)&&(identical(other.allowMedicationSharing, allowMedicationSharing) || other.allowMedicationSharing == allowMedicationSharing)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,userId,displayName,relationship,dateOfBirth,medicalConditions,emergencyContact,primaryPhysician,insuranceInfo,allowHealthDataSharing,allowMedicationSharing,createdAt,updatedAt);

@override
String toString() {
  return 'CareRecipient(id: $id, groupId: $groupId, userId: $userId, displayName: $displayName, relationship: $relationship, dateOfBirth: $dateOfBirth, medicalConditions: $medicalConditions, emergencyContact: $emergencyContact, primaryPhysician: $primaryPhysician, insuranceInfo: $insuranceInfo, allowHealthDataSharing: $allowHealthDataSharing, allowMedicationSharing: $allowMedicationSharing, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CareRecipientCopyWith<$Res> implements $CareRecipientCopyWith<$Res> {
  factory _$CareRecipientCopyWith(_CareRecipient value, $Res Function(_CareRecipient) _then) = __$CareRecipientCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String userId, String displayName, String? relationship, DateTime? dateOfBirth, String? medicalConditions, String? emergencyContact, String? primaryPhysician, String? insuranceInfo, bool allowHealthDataSharing, bool allowMedicationSharing, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$CareRecipientCopyWithImpl<$Res>
    implements _$CareRecipientCopyWith<$Res> {
  __$CareRecipientCopyWithImpl(this._self, this._then);

  final _CareRecipient _self;
  final $Res Function(_CareRecipient) _then;

/// Create a copy of CareRecipient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? userId = null,Object? displayName = null,Object? relationship = freezed,Object? dateOfBirth = freezed,Object? medicalConditions = freezed,Object? emergencyContact = freezed,Object? primaryPhysician = freezed,Object? insuranceInfo = freezed,Object? allowHealthDataSharing = null,Object? allowMedicationSharing = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CareRecipient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,medicalConditions: freezed == medicalConditions ? _self.medicalConditions : medicalConditions // ignore: cast_nullable_to_non_nullable
as String?,emergencyContact: freezed == emergencyContact ? _self.emergencyContact : emergencyContact // ignore: cast_nullable_to_non_nullable
as String?,primaryPhysician: freezed == primaryPhysician ? _self.primaryPhysician : primaryPhysician // ignore: cast_nullable_to_non_nullable
as String?,insuranceInfo: freezed == insuranceInfo ? _self.insuranceInfo : insuranceInfo // ignore: cast_nullable_to_non_nullable
as String?,allowHealthDataSharing: null == allowHealthDataSharing ? _self.allowHealthDataSharing : allowHealthDataSharing // ignore: cast_nullable_to_non_nullable
as bool,allowMedicationSharing: null == allowMedicationSharing ? _self.allowMedicationSharing : allowMedicationSharing // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CareTask {

 String get id; String get groupId; String get title; String? get description; TaskPriority get priority; TaskStatus get status; String get assignedTo; String get createdBy; String? get careRecipientId; DateTime get createdAt; DateTime get dueDate; DateTime? get completedAt; String? get completionNotes; List<String>? get attachments; bool get isRecurring; String? get recurrencePattern; DateTime? get nextDueDate;
/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareTaskCopyWith<CareTask> get copyWith => _$CareTaskCopyWithImpl<CareTask>(this as CareTask, _$identity);

  /// Serializes this CareTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareTask&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.careRecipientId, careRecipientId) || other.careRecipientId == careRecipientId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.completionNotes, completionNotes) || other.completionNotes == completionNotes)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrencePattern, recurrencePattern) || other.recurrencePattern == recurrencePattern)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,title,description,priority,status,assignedTo,createdBy,careRecipientId,createdAt,dueDate,completedAt,completionNotes,const DeepCollectionEquality().hash(attachments),isRecurring,recurrencePattern,nextDueDate);

@override
String toString() {
  return 'CareTask(id: $id, groupId: $groupId, title: $title, description: $description, priority: $priority, status: $status, assignedTo: $assignedTo, createdBy: $createdBy, careRecipientId: $careRecipientId, createdAt: $createdAt, dueDate: $dueDate, completedAt: $completedAt, completionNotes: $completionNotes, attachments: $attachments, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern, nextDueDate: $nextDueDate)';
}


}

/// @nodoc
abstract mixin class $CareTaskCopyWith<$Res>  {
  factory $CareTaskCopyWith(CareTask value, $Res Function(CareTask) _then) = _$CareTaskCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String title, String? description, TaskPriority priority, TaskStatus status, String assignedTo, String createdBy, String? careRecipientId, DateTime createdAt, DateTime dueDate, DateTime? completedAt, String? completionNotes, List<String>? attachments, bool isRecurring, String? recurrencePattern, DateTime? nextDueDate
});




}
/// @nodoc
class _$CareTaskCopyWithImpl<$Res>
    implements $CareTaskCopyWith<$Res> {
  _$CareTaskCopyWithImpl(this._self, this._then);

  final CareTask _self;
  final $Res Function(CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? title = null,Object? description = freezed,Object? priority = null,Object? status = null,Object? assignedTo = null,Object? createdBy = null,Object? careRecipientId = freezed,Object? createdAt = null,Object? dueDate = null,Object? completedAt = freezed,Object? completionNotes = freezed,Object? attachments = freezed,Object? isRecurring = null,Object? recurrencePattern = freezed,Object? nextDueDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,careRecipientId: freezed == careRecipientId ? _self.careRecipientId : careRecipientId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completionNotes: freezed == completionNotes ? _self.completionNotes : completionNotes // ignore: cast_nullable_to_non_nullable
as String?,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>?,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,recurrencePattern: freezed == recurrencePattern ? _self.recurrencePattern : recurrencePattern // ignore: cast_nullable_to_non_nullable
as String?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CareTask].
extension CareTaskPatterns on CareTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareTask value)  $default,){
final _that = this;
switch (_that) {
case _CareTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareTask value)?  $default,){
final _that = this;
switch (_that) {
case _CareTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String title,  String? description,  TaskPriority priority,  TaskStatus status,  String assignedTo,  String createdBy,  String? careRecipientId,  DateTime createdAt,  DateTime dueDate,  DateTime? completedAt,  String? completionNotes,  List<String>? attachments,  bool isRecurring,  String? recurrencePattern,  DateTime? nextDueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.id,_that.groupId,_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.createdBy,_that.careRecipientId,_that.createdAt,_that.dueDate,_that.completedAt,_that.completionNotes,_that.attachments,_that.isRecurring,_that.recurrencePattern,_that.nextDueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String title,  String? description,  TaskPriority priority,  TaskStatus status,  String assignedTo,  String createdBy,  String? careRecipientId,  DateTime createdAt,  DateTime dueDate,  DateTime? completedAt,  String? completionNotes,  List<String>? attachments,  bool isRecurring,  String? recurrencePattern,  DateTime? nextDueDate)  $default,) {final _that = this;
switch (_that) {
case _CareTask():
return $default(_that.id,_that.groupId,_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.createdBy,_that.careRecipientId,_that.createdAt,_that.dueDate,_that.completedAt,_that.completionNotes,_that.attachments,_that.isRecurring,_that.recurrencePattern,_that.nextDueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String title,  String? description,  TaskPriority priority,  TaskStatus status,  String assignedTo,  String createdBy,  String? careRecipientId,  DateTime createdAt,  DateTime dueDate,  DateTime? completedAt,  String? completionNotes,  List<String>? attachments,  bool isRecurring,  String? recurrencePattern,  DateTime? nextDueDate)?  $default,) {final _that = this;
switch (_that) {
case _CareTask() when $default != null:
return $default(_that.id,_that.groupId,_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.createdBy,_that.careRecipientId,_that.createdAt,_that.dueDate,_that.completedAt,_that.completionNotes,_that.attachments,_that.isRecurring,_that.recurrencePattern,_that.nextDueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareTask implements CareTask {
  const _CareTask({required this.id, required this.groupId, required this.title, this.description, required this.priority, required this.status, required this.assignedTo, required this.createdBy, this.careRecipientId, required this.createdAt, required this.dueDate, this.completedAt, this.completionNotes, final  List<String>? attachments, this.isRecurring = false, this.recurrencePattern, this.nextDueDate}): _attachments = attachments;
  factory _CareTask.fromJson(Map<String, dynamic> json) => _$CareTaskFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String title;
@override final  String? description;
@override final  TaskPriority priority;
@override final  TaskStatus status;
@override final  String assignedTo;
@override final  String createdBy;
@override final  String? careRecipientId;
@override final  DateTime createdAt;
@override final  DateTime dueDate;
@override final  DateTime? completedAt;
@override final  String? completionNotes;
 final  List<String>? _attachments;
@override List<String>? get attachments {
  final value = _attachments;
  if (value == null) return null;
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isRecurring;
@override final  String? recurrencePattern;
@override final  DateTime? nextDueDate;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareTaskCopyWith<_CareTask> get copyWith => __$CareTaskCopyWithImpl<_CareTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareTask&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.careRecipientId, careRecipientId) || other.careRecipientId == careRecipientId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.completionNotes, completionNotes) || other.completionNotes == completionNotes)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrencePattern, recurrencePattern) || other.recurrencePattern == recurrencePattern)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,title,description,priority,status,assignedTo,createdBy,careRecipientId,createdAt,dueDate,completedAt,completionNotes,const DeepCollectionEquality().hash(_attachments),isRecurring,recurrencePattern,nextDueDate);

@override
String toString() {
  return 'CareTask(id: $id, groupId: $groupId, title: $title, description: $description, priority: $priority, status: $status, assignedTo: $assignedTo, createdBy: $createdBy, careRecipientId: $careRecipientId, createdAt: $createdAt, dueDate: $dueDate, completedAt: $completedAt, completionNotes: $completionNotes, attachments: $attachments, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern, nextDueDate: $nextDueDate)';
}


}

/// @nodoc
abstract mixin class _$CareTaskCopyWith<$Res> implements $CareTaskCopyWith<$Res> {
  factory _$CareTaskCopyWith(_CareTask value, $Res Function(_CareTask) _then) = __$CareTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String title, String? description, TaskPriority priority, TaskStatus status, String assignedTo, String createdBy, String? careRecipientId, DateTime createdAt, DateTime dueDate, DateTime? completedAt, String? completionNotes, List<String>? attachments, bool isRecurring, String? recurrencePattern, DateTime? nextDueDate
});




}
/// @nodoc
class __$CareTaskCopyWithImpl<$Res>
    implements _$CareTaskCopyWith<$Res> {
  __$CareTaskCopyWithImpl(this._self, this._then);

  final _CareTask _self;
  final $Res Function(_CareTask) _then;

/// Create a copy of CareTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? title = null,Object? description = freezed,Object? priority = null,Object? status = null,Object? assignedTo = null,Object? createdBy = null,Object? careRecipientId = freezed,Object? createdAt = null,Object? dueDate = null,Object? completedAt = freezed,Object? completionNotes = freezed,Object? attachments = freezed,Object? isRecurring = null,Object? recurrencePattern = freezed,Object? nextDueDate = freezed,}) {
  return _then(_CareTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,careRecipientId: freezed == careRecipientId ? _self.careRecipientId : careRecipientId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completionNotes: freezed == completionNotes ? _self.completionNotes : completionNotes // ignore: cast_nullable_to_non_nullable
as String?,attachments: freezed == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>?,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,recurrencePattern: freezed == recurrencePattern ? _self.recurrencePattern : recurrencePattern // ignore: cast_nullable_to_non_nullable
as String?,nextDueDate: freezed == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CareGroupActivity {

 String get id; String get groupId; ActivityType get type; String get performedBy; String? get performedByName; String get description; Map<String, dynamic>? get metadata; DateTime get timestamp; bool get isImportant;
/// Create a copy of CareGroupActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGroupActivityCopyWith<CareGroupActivity> get copyWith => _$CareGroupActivityCopyWithImpl<CareGroupActivity>(this as CareGroupActivity, _$identity);

  /// Serializes this CareGroupActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGroupActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.performedByName, performedByName) || other.performedByName == performedByName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isImportant, isImportant) || other.isImportant == isImportant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,type,performedBy,performedByName,description,const DeepCollectionEquality().hash(metadata),timestamp,isImportant);

@override
String toString() {
  return 'CareGroupActivity(id: $id, groupId: $groupId, type: $type, performedBy: $performedBy, performedByName: $performedByName, description: $description, metadata: $metadata, timestamp: $timestamp, isImportant: $isImportant)';
}


}

/// @nodoc
abstract mixin class $CareGroupActivityCopyWith<$Res>  {
  factory $CareGroupActivityCopyWith(CareGroupActivity value, $Res Function(CareGroupActivity) _then) = _$CareGroupActivityCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, ActivityType type, String performedBy, String? performedByName, String description, Map<String, dynamic>? metadata, DateTime timestamp, bool isImportant
});




}
/// @nodoc
class _$CareGroupActivityCopyWithImpl<$Res>
    implements $CareGroupActivityCopyWith<$Res> {
  _$CareGroupActivityCopyWithImpl(this._self, this._then);

  final CareGroupActivity _self;
  final $Res Function(CareGroupActivity) _then;

/// Create a copy of CareGroupActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? type = null,Object? performedBy = null,Object? performedByName = freezed,Object? description = null,Object? metadata = freezed,Object? timestamp = null,Object? isImportant = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,performedByName: freezed == performedByName ? _self.performedByName : performedByName // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isImportant: null == isImportant ? _self.isImportant : isImportant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CareGroupActivity].
extension CareGroupActivityPatterns on CareGroupActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareGroupActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareGroupActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareGroupActivity value)  $default,){
final _that = this;
switch (_that) {
case _CareGroupActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareGroupActivity value)?  $default,){
final _that = this;
switch (_that) {
case _CareGroupActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  ActivityType type,  String performedBy,  String? performedByName,  String description,  Map<String, dynamic>? metadata,  DateTime timestamp,  bool isImportant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareGroupActivity() when $default != null:
return $default(_that.id,_that.groupId,_that.type,_that.performedBy,_that.performedByName,_that.description,_that.metadata,_that.timestamp,_that.isImportant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  ActivityType type,  String performedBy,  String? performedByName,  String description,  Map<String, dynamic>? metadata,  DateTime timestamp,  bool isImportant)  $default,) {final _that = this;
switch (_that) {
case _CareGroupActivity():
return $default(_that.id,_that.groupId,_that.type,_that.performedBy,_that.performedByName,_that.description,_that.metadata,_that.timestamp,_that.isImportant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  ActivityType type,  String performedBy,  String? performedByName,  String description,  Map<String, dynamic>? metadata,  DateTime timestamp,  bool isImportant)?  $default,) {final _that = this;
switch (_that) {
case _CareGroupActivity() when $default != null:
return $default(_that.id,_that.groupId,_that.type,_that.performedBy,_that.performedByName,_that.description,_that.metadata,_that.timestamp,_that.isImportant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareGroupActivity implements CareGroupActivity {
  const _CareGroupActivity({required this.id, required this.groupId, required this.type, required this.performedBy, this.performedByName, required this.description, final  Map<String, dynamic>? metadata, required this.timestamp, this.isImportant = false}): _metadata = metadata;
  factory _CareGroupActivity.fromJson(Map<String, dynamic> json) => _$CareGroupActivityFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  ActivityType type;
@override final  String performedBy;
@override final  String? performedByName;
@override final  String description;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime timestamp;
@override@JsonKey() final  bool isImportant;

/// Create a copy of CareGroupActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareGroupActivityCopyWith<_CareGroupActivity> get copyWith => __$CareGroupActivityCopyWithImpl<_CareGroupActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareGroupActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareGroupActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.type, type) || other.type == type)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.performedByName, performedByName) || other.performedByName == performedByName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isImportant, isImportant) || other.isImportant == isImportant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,type,performedBy,performedByName,description,const DeepCollectionEquality().hash(_metadata),timestamp,isImportant);

@override
String toString() {
  return 'CareGroupActivity(id: $id, groupId: $groupId, type: $type, performedBy: $performedBy, performedByName: $performedByName, description: $description, metadata: $metadata, timestamp: $timestamp, isImportant: $isImportant)';
}


}

/// @nodoc
abstract mixin class _$CareGroupActivityCopyWith<$Res> implements $CareGroupActivityCopyWith<$Res> {
  factory _$CareGroupActivityCopyWith(_CareGroupActivity value, $Res Function(_CareGroupActivity) _then) = __$CareGroupActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, ActivityType type, String performedBy, String? performedByName, String description, Map<String, dynamic>? metadata, DateTime timestamp, bool isImportant
});




}
/// @nodoc
class __$CareGroupActivityCopyWithImpl<$Res>
    implements _$CareGroupActivityCopyWith<$Res> {
  __$CareGroupActivityCopyWithImpl(this._self, this._then);

  final _CareGroupActivity _self;
  final $Res Function(_CareGroupActivity) _then;

/// Create a copy of CareGroupActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? type = null,Object? performedBy = null,Object? performedByName = freezed,Object? description = null,Object? metadata = freezed,Object? timestamp = null,Object? isImportant = null,}) {
  return _then(_CareGroupActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActivityType,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,performedByName: freezed == performedByName ? _self.performedByName : performedByName // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isImportant: null == isImportant ? _self.isImportant : isImportant // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CareGroup {

 String get id; String get name; String? get description; String get createdBy; DateTime get createdAt; DateTime get updatedAt; List<CareGroupMember> get members; List<CareRecipient> get careRecipients; bool get isActive; CareGroupSettings get settings; String? get inviteCode; DateTime? get inviteExpiration; int get memberCount; int get activeTaskCount;
/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareGroupCopyWith<CareGroup> get copyWith => _$CareGroupCopyWithImpl<CareGroup>(this as CareGroup, _$identity);

  /// Serializes this CareGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.careRecipients, careRecipients)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.inviteExpiration, inviteExpiration) || other.inviteExpiration == inviteExpiration)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.activeTaskCount, activeTaskCount) || other.activeTaskCount == activeTaskCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,createdBy,createdAt,updatedAt,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(careRecipients),isActive,settings,inviteCode,inviteExpiration,memberCount,activeTaskCount);

@override
String toString() {
  return 'CareGroup(id: $id, name: $name, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, members: $members, careRecipients: $careRecipients, isActive: $isActive, settings: $settings, inviteCode: $inviteCode, inviteExpiration: $inviteExpiration, memberCount: $memberCount, activeTaskCount: $activeTaskCount)';
}


}

/// @nodoc
abstract mixin class $CareGroupCopyWith<$Res>  {
  factory $CareGroupCopyWith(CareGroup value, $Res Function(CareGroup) _then) = _$CareGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String createdBy, DateTime createdAt, DateTime updatedAt, List<CareGroupMember> members, List<CareRecipient> careRecipients, bool isActive, CareGroupSettings settings, String? inviteCode, DateTime? inviteExpiration, int memberCount, int activeTaskCount
});


$CareGroupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$CareGroupCopyWithImpl<$Res>
    implements $CareGroupCopyWith<$Res> {
  _$CareGroupCopyWithImpl(this._self, this._then);

  final CareGroup _self;
  final $Res Function(CareGroup) _then;

/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? members = null,Object? careRecipients = null,Object? isActive = null,Object? settings = null,Object? inviteCode = freezed,Object? inviteExpiration = freezed,Object? memberCount = null,Object? activeTaskCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<CareGroupMember>,careRecipients: null == careRecipients ? _self.careRecipients : careRecipients // ignore: cast_nullable_to_non_nullable
as List<CareRecipient>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as CareGroupSettings,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,inviteExpiration: freezed == inviteExpiration ? _self.inviteExpiration : inviteExpiration // ignore: cast_nullable_to_non_nullable
as DateTime?,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,activeTaskCount: null == activeTaskCount ? _self.activeTaskCount : activeTaskCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareGroupSettingsCopyWith<$Res> get settings {
  
  return $CareGroupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [CareGroup].
extension CareGroupPatterns on CareGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CareGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CareGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CareGroup value)  $default,){
final _that = this;
switch (_that) {
case _CareGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CareGroup value)?  $default,){
final _that = this;
switch (_that) {
case _CareGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  List<CareGroupMember> members,  List<CareRecipient> careRecipients,  bool isActive,  CareGroupSettings settings,  String? inviteCode,  DateTime? inviteExpiration,  int memberCount,  int activeTaskCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CareGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.createdBy,_that.createdAt,_that.updatedAt,_that.members,_that.careRecipients,_that.isActive,_that.settings,_that.inviteCode,_that.inviteExpiration,_that.memberCount,_that.activeTaskCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  List<CareGroupMember> members,  List<CareRecipient> careRecipients,  bool isActive,  CareGroupSettings settings,  String? inviteCode,  DateTime? inviteExpiration,  int memberCount,  int activeTaskCount)  $default,) {final _that = this;
switch (_that) {
case _CareGroup():
return $default(_that.id,_that.name,_that.description,_that.createdBy,_that.createdAt,_that.updatedAt,_that.members,_that.careRecipients,_that.isActive,_that.settings,_that.inviteCode,_that.inviteExpiration,_that.memberCount,_that.activeTaskCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String createdBy,  DateTime createdAt,  DateTime updatedAt,  List<CareGroupMember> members,  List<CareRecipient> careRecipients,  bool isActive,  CareGroupSettings settings,  String? inviteCode,  DateTime? inviteExpiration,  int memberCount,  int activeTaskCount)?  $default,) {final _that = this;
switch (_that) {
case _CareGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.createdBy,_that.createdAt,_that.updatedAt,_that.members,_that.careRecipients,_that.isActive,_that.settings,_that.inviteCode,_that.inviteExpiration,_that.memberCount,_that.activeTaskCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CareGroup implements CareGroup {
  const _CareGroup({required this.id, required this.name, this.description, required this.createdBy, required this.createdAt, required this.updatedAt, required final  List<CareGroupMember> members, required final  List<CareRecipient> careRecipients, required this.isActive, this.settings = const CareGroupSettings(), this.inviteCode, this.inviteExpiration, this.memberCount = 0, this.activeTaskCount = 0}): _members = members,_careRecipients = careRecipients;
  factory _CareGroup.fromJson(Map<String, dynamic> json) => _$CareGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String createdBy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<CareGroupMember> _members;
@override List<CareGroupMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<CareRecipient> _careRecipients;
@override List<CareRecipient> get careRecipients {
  if (_careRecipients is EqualUnmodifiableListView) return _careRecipients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_careRecipients);
}

@override final  bool isActive;
@override@JsonKey() final  CareGroupSettings settings;
@override final  String? inviteCode;
@override final  DateTime? inviteExpiration;
@override@JsonKey() final  int memberCount;
@override@JsonKey() final  int activeTaskCount;

/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareGroupCopyWith<_CareGroup> get copyWith => __$CareGroupCopyWithImpl<_CareGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._careRecipients, _careRecipients)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.inviteExpiration, inviteExpiration) || other.inviteExpiration == inviteExpiration)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.activeTaskCount, activeTaskCount) || other.activeTaskCount == activeTaskCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,createdBy,createdAt,updatedAt,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_careRecipients),isActive,settings,inviteCode,inviteExpiration,memberCount,activeTaskCount);

@override
String toString() {
  return 'CareGroup(id: $id, name: $name, description: $description, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, members: $members, careRecipients: $careRecipients, isActive: $isActive, settings: $settings, inviteCode: $inviteCode, inviteExpiration: $inviteExpiration, memberCount: $memberCount, activeTaskCount: $activeTaskCount)';
}


}

/// @nodoc
abstract mixin class _$CareGroupCopyWith<$Res> implements $CareGroupCopyWith<$Res> {
  factory _$CareGroupCopyWith(_CareGroup value, $Res Function(_CareGroup) _then) = __$CareGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String createdBy, DateTime createdAt, DateTime updatedAt, List<CareGroupMember> members, List<CareRecipient> careRecipients, bool isActive, CareGroupSettings settings, String? inviteCode, DateTime? inviteExpiration, int memberCount, int activeTaskCount
});


@override $CareGroupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$CareGroupCopyWithImpl<$Res>
    implements _$CareGroupCopyWith<$Res> {
  __$CareGroupCopyWithImpl(this._self, this._then);

  final _CareGroup _self;
  final $Res Function(_CareGroup) _then;

/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? members = null,Object? careRecipients = null,Object? isActive = null,Object? settings = null,Object? inviteCode = freezed,Object? inviteExpiration = freezed,Object? memberCount = null,Object? activeTaskCount = null,}) {
  return _then(_CareGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CareGroupMember>,careRecipients: null == careRecipients ? _self._careRecipients : careRecipients // ignore: cast_nullable_to_non_nullable
as List<CareRecipient>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as CareGroupSettings,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,inviteExpiration: freezed == inviteExpiration ? _self.inviteExpiration : inviteExpiration // ignore: cast_nullable_to_non_nullable
as DateTime?,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,activeTaskCount: null == activeTaskCount ? _self.activeTaskCount : activeTaskCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CareGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareGroupSettingsCopyWith<$Res> get settings {
  
  return $CareGroupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// @nodoc
mixin _$CreateCareGroupRequest {

 String get name; String? get description; CareGroupSettings get settings;
/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCareGroupRequestCopyWith<CreateCareGroupRequest> get copyWith => _$CreateCareGroupRequestCopyWithImpl<CreateCareGroupRequest>(this as CreateCareGroupRequest, _$identity);

  /// Serializes this CreateCareGroupRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCareGroupRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,settings);

@override
String toString() {
  return 'CreateCareGroupRequest(name: $name, description: $description, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $CreateCareGroupRequestCopyWith<$Res>  {
  factory $CreateCareGroupRequestCopyWith(CreateCareGroupRequest value, $Res Function(CreateCareGroupRequest) _then) = _$CreateCareGroupRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? description, CareGroupSettings settings
});


$CareGroupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$CreateCareGroupRequestCopyWithImpl<$Res>
    implements $CreateCareGroupRequestCopyWith<$Res> {
  _$CreateCareGroupRequestCopyWithImpl(this._self, this._then);

  final CreateCareGroupRequest _self;
  final $Res Function(CreateCareGroupRequest) _then;

/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? settings = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as CareGroupSettings,
  ));
}
/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareGroupSettingsCopyWith<$Res> get settings {
  
  return $CareGroupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateCareGroupRequest].
extension CreateCareGroupRequestPatterns on CreateCareGroupRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCareGroupRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCareGroupRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCareGroupRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateCareGroupRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCareGroupRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCareGroupRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  CareGroupSettings settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCareGroupRequest() when $default != null:
return $default(_that.name,_that.description,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  CareGroupSettings settings)  $default,) {final _that = this;
switch (_that) {
case _CreateCareGroupRequest():
return $default(_that.name,_that.description,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  CareGroupSettings settings)?  $default,) {final _that = this;
switch (_that) {
case _CreateCareGroupRequest() when $default != null:
return $default(_that.name,_that.description,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCareGroupRequest implements CreateCareGroupRequest {
  const _CreateCareGroupRequest({required this.name, this.description, this.settings = const CareGroupSettings()});
  factory _CreateCareGroupRequest.fromJson(Map<String, dynamic> json) => _$CreateCareGroupRequestFromJson(json);

@override final  String name;
@override final  String? description;
@override@JsonKey() final  CareGroupSettings settings;

/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCareGroupRequestCopyWith<_CreateCareGroupRequest> get copyWith => __$CreateCareGroupRequestCopyWithImpl<_CreateCareGroupRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCareGroupRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCareGroupRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,settings);

@override
String toString() {
  return 'CreateCareGroupRequest(name: $name, description: $description, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$CreateCareGroupRequestCopyWith<$Res> implements $CreateCareGroupRequestCopyWith<$Res> {
  factory _$CreateCareGroupRequestCopyWith(_CreateCareGroupRequest value, $Res Function(_CreateCareGroupRequest) _then) = __$CreateCareGroupRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, CareGroupSettings settings
});


@override $CareGroupSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$CreateCareGroupRequestCopyWithImpl<$Res>
    implements _$CreateCareGroupRequestCopyWith<$Res> {
  __$CreateCareGroupRequestCopyWithImpl(this._self, this._then);

  final _CreateCareGroupRequest _self;
  final $Res Function(_CreateCareGroupRequest) _then;

/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? settings = null,}) {
  return _then(_CreateCareGroupRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as CareGroupSettings,
  ));
}

/// Create a copy of CreateCareGroupRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareGroupSettingsCopyWith<$Res> get settings {
  
  return $CareGroupSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// @nodoc
mixin _$InviteMemberRequest {

 String get email; MemberRole get role; String? get customTitle; String? get personalMessage;
/// Create a copy of InviteMemberRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteMemberRequestCopyWith<InviteMemberRequest> get copyWith => _$InviteMemberRequestCopyWithImpl<InviteMemberRequest>(this as InviteMemberRequest, _$identity);

  /// Serializes this InviteMemberRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteMemberRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.personalMessage, personalMessage) || other.personalMessage == personalMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,role,customTitle,personalMessage);

@override
String toString() {
  return 'InviteMemberRequest(email: $email, role: $role, customTitle: $customTitle, personalMessage: $personalMessage)';
}


}

/// @nodoc
abstract mixin class $InviteMemberRequestCopyWith<$Res>  {
  factory $InviteMemberRequestCopyWith(InviteMemberRequest value, $Res Function(InviteMemberRequest) _then) = _$InviteMemberRequestCopyWithImpl;
@useResult
$Res call({
 String email, MemberRole role, String? customTitle, String? personalMessage
});




}
/// @nodoc
class _$InviteMemberRequestCopyWithImpl<$Res>
    implements $InviteMemberRequestCopyWith<$Res> {
  _$InviteMemberRequestCopyWithImpl(this._self, this._then);

  final InviteMemberRequest _self;
  final $Res Function(InviteMemberRequest) _then;

/// Create a copy of InviteMemberRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? role = null,Object? customTitle = freezed,Object? personalMessage = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,personalMessage: freezed == personalMessage ? _self.personalMessage : personalMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteMemberRequest].
extension InviteMemberRequestPatterns on InviteMemberRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteMemberRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteMemberRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteMemberRequest value)  $default,){
final _that = this;
switch (_that) {
case _InviteMemberRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteMemberRequest value)?  $default,){
final _that = this;
switch (_that) {
case _InviteMemberRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  MemberRole role,  String? customTitle,  String? personalMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteMemberRequest() when $default != null:
return $default(_that.email,_that.role,_that.customTitle,_that.personalMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  MemberRole role,  String? customTitle,  String? personalMessage)  $default,) {final _that = this;
switch (_that) {
case _InviteMemberRequest():
return $default(_that.email,_that.role,_that.customTitle,_that.personalMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  MemberRole role,  String? customTitle,  String? personalMessage)?  $default,) {final _that = this;
switch (_that) {
case _InviteMemberRequest() when $default != null:
return $default(_that.email,_that.role,_that.customTitle,_that.personalMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteMemberRequest implements InviteMemberRequest {
  const _InviteMemberRequest({required this.email, required this.role, this.customTitle, this.personalMessage});
  factory _InviteMemberRequest.fromJson(Map<String, dynamic> json) => _$InviteMemberRequestFromJson(json);

@override final  String email;
@override final  MemberRole role;
@override final  String? customTitle;
@override final  String? personalMessage;

/// Create a copy of InviteMemberRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteMemberRequestCopyWith<_InviteMemberRequest> get copyWith => __$InviteMemberRequestCopyWithImpl<_InviteMemberRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteMemberRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteMemberRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.customTitle, customTitle) || other.customTitle == customTitle)&&(identical(other.personalMessage, personalMessage) || other.personalMessage == personalMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,role,customTitle,personalMessage);

@override
String toString() {
  return 'InviteMemberRequest(email: $email, role: $role, customTitle: $customTitle, personalMessage: $personalMessage)';
}


}

/// @nodoc
abstract mixin class _$InviteMemberRequestCopyWith<$Res> implements $InviteMemberRequestCopyWith<$Res> {
  factory _$InviteMemberRequestCopyWith(_InviteMemberRequest value, $Res Function(_InviteMemberRequest) _then) = __$InviteMemberRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, MemberRole role, String? customTitle, String? personalMessage
});




}
/// @nodoc
class __$InviteMemberRequestCopyWithImpl<$Res>
    implements _$InviteMemberRequestCopyWith<$Res> {
  __$InviteMemberRequestCopyWithImpl(this._self, this._then);

  final _InviteMemberRequest _self;
  final $Res Function(_InviteMemberRequest) _then;

/// Create a copy of InviteMemberRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? role = null,Object? customTitle = freezed,Object? personalMessage = freezed,}) {
  return _then(_InviteMemberRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,customTitle: freezed == customTitle ? _self.customTitle : customTitle // ignore: cast_nullable_to_non_nullable
as String?,personalMessage: freezed == personalMessage ? _self.personalMessage : personalMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateTaskRequest {

 String get title; String? get description; TaskPriority get priority; String get assignedTo; String? get careRecipientId; DateTime get dueDate; bool get isRecurring; String? get recurrencePattern;
/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTaskRequestCopyWith<CreateTaskRequest> get copyWith => _$CreateTaskRequestCopyWithImpl<CreateTaskRequest>(this as CreateTaskRequest, _$identity);

  /// Serializes this CreateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.careRecipientId, careRecipientId) || other.careRecipientId == careRecipientId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrencePattern, recurrencePattern) || other.recurrencePattern == recurrencePattern));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,assignedTo,careRecipientId,dueDate,isRecurring,recurrencePattern);

@override
String toString() {
  return 'CreateTaskRequest(title: $title, description: $description, priority: $priority, assignedTo: $assignedTo, careRecipientId: $careRecipientId, dueDate: $dueDate, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern)';
}


}

/// @nodoc
abstract mixin class $CreateTaskRequestCopyWith<$Res>  {
  factory $CreateTaskRequestCopyWith(CreateTaskRequest value, $Res Function(CreateTaskRequest) _then) = _$CreateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? description, TaskPriority priority, String assignedTo, String? careRecipientId, DateTime dueDate, bool isRecurring, String? recurrencePattern
});




}
/// @nodoc
class _$CreateTaskRequestCopyWithImpl<$Res>
    implements $CreateTaskRequestCopyWith<$Res> {
  _$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final CreateTaskRequest _self;
  final $Res Function(CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? priority = null,Object? assignedTo = null,Object? careRecipientId = freezed,Object? dueDate = null,Object? isRecurring = null,Object? recurrencePattern = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,careRecipientId: freezed == careRecipientId ? _self.careRecipientId : careRecipientId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,recurrencePattern: freezed == recurrencePattern ? _self.recurrencePattern : recurrencePattern // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTaskRequest].
extension CreateTaskRequestPatterns on CreateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  TaskPriority priority,  String assignedTo,  String? careRecipientId,  DateTime dueDate,  bool isRecurring,  String? recurrencePattern)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.assignedTo,_that.careRecipientId,_that.dueDate,_that.isRecurring,_that.recurrencePattern);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  TaskPriority priority,  String assignedTo,  String? careRecipientId,  DateTime dueDate,  bool isRecurring,  String? recurrencePattern)  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest():
return $default(_that.title,_that.description,_that.priority,_that.assignedTo,_that.careRecipientId,_that.dueDate,_that.isRecurring,_that.recurrencePattern);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  TaskPriority priority,  String assignedTo,  String? careRecipientId,  DateTime dueDate,  bool isRecurring,  String? recurrencePattern)?  $default,) {final _that = this;
switch (_that) {
case _CreateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.assignedTo,_that.careRecipientId,_that.dueDate,_that.isRecurring,_that.recurrencePattern);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTaskRequest implements CreateTaskRequest {
  const _CreateTaskRequest({required this.title, this.description, required this.priority, required this.assignedTo, this.careRecipientId, required this.dueDate, this.isRecurring = false, this.recurrencePattern});
  factory _CreateTaskRequest.fromJson(Map<String, dynamic> json) => _$CreateTaskRequestFromJson(json);

@override final  String title;
@override final  String? description;
@override final  TaskPriority priority;
@override final  String assignedTo;
@override final  String? careRecipientId;
@override final  DateTime dueDate;
@override@JsonKey() final  bool isRecurring;
@override final  String? recurrencePattern;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTaskRequestCopyWith<_CreateTaskRequest> get copyWith => __$CreateTaskRequestCopyWithImpl<_CreateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.careRecipientId, careRecipientId) || other.careRecipientId == careRecipientId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrencePattern, recurrencePattern) || other.recurrencePattern == recurrencePattern));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,assignedTo,careRecipientId,dueDate,isRecurring,recurrencePattern);

@override
String toString() {
  return 'CreateTaskRequest(title: $title, description: $description, priority: $priority, assignedTo: $assignedTo, careRecipientId: $careRecipientId, dueDate: $dueDate, isRecurring: $isRecurring, recurrencePattern: $recurrencePattern)';
}


}

/// @nodoc
abstract mixin class _$CreateTaskRequestCopyWith<$Res> implements $CreateTaskRequestCopyWith<$Res> {
  factory _$CreateTaskRequestCopyWith(_CreateTaskRequest value, $Res Function(_CreateTaskRequest) _then) = __$CreateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, TaskPriority priority, String assignedTo, String? careRecipientId, DateTime dueDate, bool isRecurring, String? recurrencePattern
});




}
/// @nodoc
class __$CreateTaskRequestCopyWithImpl<$Res>
    implements _$CreateTaskRequestCopyWith<$Res> {
  __$CreateTaskRequestCopyWithImpl(this._self, this._then);

  final _CreateTaskRequest _self;
  final $Res Function(_CreateTaskRequest) _then;

/// Create a copy of CreateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? priority = null,Object? assignedTo = null,Object? careRecipientId = freezed,Object? dueDate = null,Object? isRecurring = null,Object? recurrencePattern = freezed,}) {
  return _then(_CreateTaskRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,assignedTo: null == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String,careRecipientId: freezed == careRecipientId ? _self.careRecipientId : careRecipientId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,isRecurring: null == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool,recurrencePattern: freezed == recurrencePattern ? _self.recurrencePattern : recurrencePattern // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateTaskRequest {

 String? get title; String? get description; TaskPriority? get priority; TaskStatus? get status; String? get assignedTo; DateTime? get dueDate; String? get completionNotes;
/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskRequestCopyWith<UpdateTaskRequest> get copyWith => _$UpdateTaskRequestCopyWithImpl<UpdateTaskRequest>(this as UpdateTaskRequest, _$identity);

  /// Serializes this UpdateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completionNotes, completionNotes) || other.completionNotes == completionNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,status,assignedTo,dueDate,completionNotes);

@override
String toString() {
  return 'UpdateTaskRequest(title: $title, description: $description, priority: $priority, status: $status, assignedTo: $assignedTo, dueDate: $dueDate, completionNotes: $completionNotes)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskRequestCopyWith<$Res>  {
  factory $UpdateTaskRequestCopyWith(UpdateTaskRequest value, $Res Function(UpdateTaskRequest) _then) = _$UpdateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, TaskPriority? priority, TaskStatus? status, String? assignedTo, DateTime? dueDate, String? completionNotes
});




}
/// @nodoc
class _$UpdateTaskRequestCopyWithImpl<$Res>
    implements $UpdateTaskRequestCopyWith<$Res> {
  _$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final UpdateTaskRequest _self;
  final $Res Function(UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? priority = freezed,Object? status = freezed,Object? assignedTo = freezed,Object? dueDate = freezed,Object? completionNotes = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completionNotes: freezed == completionNotes ? _self.completionNotes : completionNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskRequest].
extension UpdateTaskRequestPatterns on UpdateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskPriority? priority,  TaskStatus? status,  String? assignedTo,  DateTime? dueDate,  String? completionNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.dueDate,_that.completionNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskPriority? priority,  TaskStatus? status,  String? assignedTo,  DateTime? dueDate,  String? completionNotes)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest():
return $default(_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.dueDate,_that.completionNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  TaskPriority? priority,  TaskStatus? status,  String? assignedTo,  DateTime? dueDate,  String? completionNotes)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.title,_that.description,_that.priority,_that.status,_that.assignedTo,_that.dueDate,_that.completionNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskRequest implements UpdateTaskRequest {
  const _UpdateTaskRequest({this.title, this.description, this.priority, this.status, this.assignedTo, this.dueDate, this.completionNotes});
  factory _UpdateTaskRequest.fromJson(Map<String, dynamic> json) => _$UpdateTaskRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  TaskPriority? priority;
@override final  TaskStatus? status;
@override final  String? assignedTo;
@override final  DateTime? dueDate;
@override final  String? completionNotes;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskRequestCopyWith<_UpdateTaskRequest> get copyWith => __$UpdateTaskRequestCopyWithImpl<_UpdateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completionNotes, completionNotes) || other.completionNotes == completionNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,priority,status,assignedTo,dueDate,completionNotes);

@override
String toString() {
  return 'UpdateTaskRequest(title: $title, description: $description, priority: $priority, status: $status, assignedTo: $assignedTo, dueDate: $dueDate, completionNotes: $completionNotes)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskRequestCopyWith<$Res> implements $UpdateTaskRequestCopyWith<$Res> {
  factory _$UpdateTaskRequestCopyWith(_UpdateTaskRequest value, $Res Function(_UpdateTaskRequest) _then) = __$UpdateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, TaskPriority? priority, TaskStatus? status, String? assignedTo, DateTime? dueDate, String? completionNotes
});




}
/// @nodoc
class __$UpdateTaskRequestCopyWithImpl<$Res>
    implements _$UpdateTaskRequestCopyWith<$Res> {
  __$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final _UpdateTaskRequest _self;
  final $Res Function(_UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? priority = freezed,Object? status = freezed,Object? assignedTo = freezed,Object? dueDate = freezed,Object? completionNotes = freezed,}) {
  return _then(_UpdateTaskRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completionNotes: freezed == completionNotes ? _self.completionNotes : completionNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
