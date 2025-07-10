// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Time {

 int get hour;// 0-23
 int get minute;
/// Create a copy of Time
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeCopyWith<Time> get copyWith => _$TimeCopyWithImpl<Time>(this as Time, _$identity);

  /// Serializes this Time to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Time&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString() {
  return 'Time(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class $TimeCopyWith<$Res>  {
  factory $TimeCopyWith(Time value, $Res Function(Time) _then) = _$TimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class _$TimeCopyWithImpl<$Res>
    implements $TimeCopyWith<$Res> {
  _$TimeCopyWithImpl(this._self, this._then);

  final Time _self;
  final $Res Function(Time) _then;

/// Create a copy of Time
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Time].
extension TimePatterns on Time {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Time value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Time() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Time value)  $default,){
final _that = this;
switch (_that) {
case _Time():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Time value)?  $default,){
final _that = this;
switch (_that) {
case _Time() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Time() when $default != null:
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute)  $default,) {final _that = this;
switch (_that) {
case _Time():
return $default(_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute)?  $default,) {final _that = this;
switch (_that) {
case _Time() when $default != null:
return $default(_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Time implements Time {
  const _Time({required this.hour, required this.minute});
  factory _Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);

@override final  int hour;
// 0-23
@override final  int minute;

/// Create a copy of Time
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeCopyWith<_Time> get copyWith => __$TimeCopyWithImpl<_Time>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Time&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute);

@override
String toString() {
  return 'Time(hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$TimeCopyWith<$Res> implements $TimeCopyWith<$Res> {
  factory _$TimeCopyWith(_Time value, $Res Function(_Time) _then) = __$TimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute
});




}
/// @nodoc
class __$TimeCopyWithImpl<$Res>
    implements _$TimeCopyWith<$Res> {
  __$TimeCopyWithImpl(this._self, this._then);

  final _Time _self;
  final $Res Function(_Time) _then;

/// Create a copy of Time
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,}) {
  return _then(_Time(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DosageSchedule {

 DosageFrequency get frequency; int get times;// Number of times per frequency period
 List<int> get daysOfWeek;// 0-6, 0 is Sunday
 List<int> get daysOfMonth;// 1-31
 List<Time> get specificTimes; String? get asNeededInstructions; MealRelation? get mealRelation;
/// Create a copy of DosageSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<DosageSchedule> get copyWith => _$DosageScheduleCopyWithImpl<DosageSchedule>(this as DosageSchedule, _$identity);

  /// Serializes this DosageSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DosageSchedule&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.times, times) || other.times == times)&&const DeepCollectionEquality().equals(other.daysOfWeek, daysOfWeek)&&const DeepCollectionEquality().equals(other.daysOfMonth, daysOfMonth)&&const DeepCollectionEquality().equals(other.specificTimes, specificTimes)&&(identical(other.asNeededInstructions, asNeededInstructions) || other.asNeededInstructions == asNeededInstructions)&&(identical(other.mealRelation, mealRelation) || other.mealRelation == mealRelation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frequency,times,const DeepCollectionEquality().hash(daysOfWeek),const DeepCollectionEquality().hash(daysOfMonth),const DeepCollectionEquality().hash(specificTimes),asNeededInstructions,mealRelation);

@override
String toString() {
  return 'DosageSchedule(frequency: $frequency, times: $times, daysOfWeek: $daysOfWeek, daysOfMonth: $daysOfMonth, specificTimes: $specificTimes, asNeededInstructions: $asNeededInstructions, mealRelation: $mealRelation)';
}


}

/// @nodoc
abstract mixin class $DosageScheduleCopyWith<$Res>  {
  factory $DosageScheduleCopyWith(DosageSchedule value, $Res Function(DosageSchedule) _then) = _$DosageScheduleCopyWithImpl;
@useResult
$Res call({
 DosageFrequency frequency, int times, List<int> daysOfWeek, List<int> daysOfMonth, List<Time> specificTimes, String? asNeededInstructions, MealRelation? mealRelation
});




}
/// @nodoc
class _$DosageScheduleCopyWithImpl<$Res>
    implements $DosageScheduleCopyWith<$Res> {
  _$DosageScheduleCopyWithImpl(this._self, this._then);

  final DosageSchedule _self;
  final $Res Function(DosageSchedule) _then;

/// Create a copy of DosageSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frequency = null,Object? times = null,Object? daysOfWeek = null,Object? daysOfMonth = null,Object? specificTimes = null,Object? asNeededInstructions = freezed,Object? mealRelation = freezed,}) {
  return _then(_self.copyWith(
frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as DosageFrequency,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as int,daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,daysOfMonth: null == daysOfMonth ? _self.daysOfMonth : daysOfMonth // ignore: cast_nullable_to_non_nullable
as List<int>,specificTimes: null == specificTimes ? _self.specificTimes : specificTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,asNeededInstructions: freezed == asNeededInstructions ? _self.asNeededInstructions : asNeededInstructions // ignore: cast_nullable_to_non_nullable
as String?,mealRelation: freezed == mealRelation ? _self.mealRelation : mealRelation // ignore: cast_nullable_to_non_nullable
as MealRelation?,
  ));
}

}


/// Adds pattern-matching-related methods to [DosageSchedule].
extension DosageSchedulePatterns on DosageSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DosageSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DosageSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DosageSchedule value)  $default,){
final _that = this;
switch (_that) {
case _DosageSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DosageSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DosageSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DosageFrequency frequency,  int times,  List<int> daysOfWeek,  List<int> daysOfMonth,  List<Time> specificTimes,  String? asNeededInstructions,  MealRelation? mealRelation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DosageSchedule() when $default != null:
return $default(_that.frequency,_that.times,_that.daysOfWeek,_that.daysOfMonth,_that.specificTimes,_that.asNeededInstructions,_that.mealRelation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DosageFrequency frequency,  int times,  List<int> daysOfWeek,  List<int> daysOfMonth,  List<Time> specificTimes,  String? asNeededInstructions,  MealRelation? mealRelation)  $default,) {final _that = this;
switch (_that) {
case _DosageSchedule():
return $default(_that.frequency,_that.times,_that.daysOfWeek,_that.daysOfMonth,_that.specificTimes,_that.asNeededInstructions,_that.mealRelation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DosageFrequency frequency,  int times,  List<int> daysOfWeek,  List<int> daysOfMonth,  List<Time> specificTimes,  String? asNeededInstructions,  MealRelation? mealRelation)?  $default,) {final _that = this;
switch (_that) {
case _DosageSchedule() when $default != null:
return $default(_that.frequency,_that.times,_that.daysOfWeek,_that.daysOfMonth,_that.specificTimes,_that.asNeededInstructions,_that.mealRelation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DosageSchedule implements DosageSchedule {
  const _DosageSchedule({required this.frequency, required this.times, final  List<int> daysOfWeek = const [], final  List<int> daysOfMonth = const [], final  List<Time> specificTimes = const [], this.asNeededInstructions, this.mealRelation}): _daysOfWeek = daysOfWeek,_daysOfMonth = daysOfMonth,_specificTimes = specificTimes;
  factory _DosageSchedule.fromJson(Map<String, dynamic> json) => _$DosageScheduleFromJson(json);

@override final  DosageFrequency frequency;
@override final  int times;
// Number of times per frequency period
 final  List<int> _daysOfWeek;
// Number of times per frequency period
@override@JsonKey() List<int> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfWeek);
}

// 0-6, 0 is Sunday
 final  List<int> _daysOfMonth;
// 0-6, 0 is Sunday
@override@JsonKey() List<int> get daysOfMonth {
  if (_daysOfMonth is EqualUnmodifiableListView) return _daysOfMonth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daysOfMonth);
}

// 1-31
 final  List<Time> _specificTimes;
// 1-31
@override@JsonKey() List<Time> get specificTimes {
  if (_specificTimes is EqualUnmodifiableListView) return _specificTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specificTimes);
}

@override final  String? asNeededInstructions;
@override final  MealRelation? mealRelation;

/// Create a copy of DosageSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DosageScheduleCopyWith<_DosageSchedule> get copyWith => __$DosageScheduleCopyWithImpl<_DosageSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DosageScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DosageSchedule&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.times, times) || other.times == times)&&const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek)&&const DeepCollectionEquality().equals(other._daysOfMonth, _daysOfMonth)&&const DeepCollectionEquality().equals(other._specificTimes, _specificTimes)&&(identical(other.asNeededInstructions, asNeededInstructions) || other.asNeededInstructions == asNeededInstructions)&&(identical(other.mealRelation, mealRelation) || other.mealRelation == mealRelation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,frequency,times,const DeepCollectionEquality().hash(_daysOfWeek),const DeepCollectionEquality().hash(_daysOfMonth),const DeepCollectionEquality().hash(_specificTimes),asNeededInstructions,mealRelation);

@override
String toString() {
  return 'DosageSchedule(frequency: $frequency, times: $times, daysOfWeek: $daysOfWeek, daysOfMonth: $daysOfMonth, specificTimes: $specificTimes, asNeededInstructions: $asNeededInstructions, mealRelation: $mealRelation)';
}


}

/// @nodoc
abstract mixin class _$DosageScheduleCopyWith<$Res> implements $DosageScheduleCopyWith<$Res> {
  factory _$DosageScheduleCopyWith(_DosageSchedule value, $Res Function(_DosageSchedule) _then) = __$DosageScheduleCopyWithImpl;
@override @useResult
$Res call({
 DosageFrequency frequency, int times, List<int> daysOfWeek, List<int> daysOfMonth, List<Time> specificTimes, String? asNeededInstructions, MealRelation? mealRelation
});




}
/// @nodoc
class __$DosageScheduleCopyWithImpl<$Res>
    implements _$DosageScheduleCopyWith<$Res> {
  __$DosageScheduleCopyWithImpl(this._self, this._then);

  final _DosageSchedule _self;
  final $Res Function(_DosageSchedule) _then;

/// Create a copy of DosageSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frequency = null,Object? times = null,Object? daysOfWeek = null,Object? daysOfMonth = null,Object? specificTimes = null,Object? asNeededInstructions = freezed,Object? mealRelation = freezed,}) {
  return _then(_DosageSchedule(
frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as DosageFrequency,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as int,daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,daysOfMonth: null == daysOfMonth ? _self._daysOfMonth : daysOfMonth // ignore: cast_nullable_to_non_nullable
as List<int>,specificTimes: null == specificTimes ? _self._specificTimes : specificTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,asNeededInstructions: freezed == asNeededInstructions ? _self.asNeededInstructions : asNeededInstructions // ignore: cast_nullable_to_non_nullable
as String?,mealRelation: freezed == mealRelation ? _self.mealRelation : mealRelation // ignore: cast_nullable_to_non_nullable
as MealRelation?,
  ));
}


}


/// @nodoc
mixin _$ReminderSettings {

 int get advanceMinutes;// Minutes before scheduled time to remind
 int get repeatMinutes;// Minutes between repeat reminders
 int get maxReminders;// Maximum number of reminders
 bool get soundEnabled; bool get vibrationEnabled; CriticalityLevel get criticalityLevel;
/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<ReminderSettings> get copyWith => _$ReminderSettingsCopyWithImpl<ReminderSettings>(this as ReminderSettings, _$identity);

  /// Serializes this ReminderSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderSettings&&(identical(other.advanceMinutes, advanceMinutes) || other.advanceMinutes == advanceMinutes)&&(identical(other.repeatMinutes, repeatMinutes) || other.repeatMinutes == repeatMinutes)&&(identical(other.maxReminders, maxReminders) || other.maxReminders == maxReminders)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.criticalityLevel, criticalityLevel) || other.criticalityLevel == criticalityLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,advanceMinutes,repeatMinutes,maxReminders,soundEnabled,vibrationEnabled,criticalityLevel);

@override
String toString() {
  return 'ReminderSettings(advanceMinutes: $advanceMinutes, repeatMinutes: $repeatMinutes, maxReminders: $maxReminders, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, criticalityLevel: $criticalityLevel)';
}


}

/// @nodoc
abstract mixin class $ReminderSettingsCopyWith<$Res>  {
  factory $ReminderSettingsCopyWith(ReminderSettings value, $Res Function(ReminderSettings) _then) = _$ReminderSettingsCopyWithImpl;
@useResult
$Res call({
 int advanceMinutes, int repeatMinutes, int maxReminders, bool soundEnabled, bool vibrationEnabled, CriticalityLevel criticalityLevel
});




}
/// @nodoc
class _$ReminderSettingsCopyWithImpl<$Res>
    implements $ReminderSettingsCopyWith<$Res> {
  _$ReminderSettingsCopyWithImpl(this._self, this._then);

  final ReminderSettings _self;
  final $Res Function(ReminderSettings) _then;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? advanceMinutes = null,Object? repeatMinutes = null,Object? maxReminders = null,Object? soundEnabled = null,Object? vibrationEnabled = null,Object? criticalityLevel = null,}) {
  return _then(_self.copyWith(
advanceMinutes: null == advanceMinutes ? _self.advanceMinutes : advanceMinutes // ignore: cast_nullable_to_non_nullable
as int,repeatMinutes: null == repeatMinutes ? _self.repeatMinutes : repeatMinutes // ignore: cast_nullable_to_non_nullable
as int,maxReminders: null == maxReminders ? _self.maxReminders : maxReminders // ignore: cast_nullable_to_non_nullable
as int,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,criticalityLevel: null == criticalityLevel ? _self.criticalityLevel : criticalityLevel // ignore: cast_nullable_to_non_nullable
as CriticalityLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderSettings].
extension ReminderSettingsPatterns on ReminderSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderSettings value)  $default,){
final _that = this;
switch (_that) {
case _ReminderSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int advanceMinutes,  int repeatMinutes,  int maxReminders,  bool soundEnabled,  bool vibrationEnabled,  CriticalityLevel criticalityLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
return $default(_that.advanceMinutes,_that.repeatMinutes,_that.maxReminders,_that.soundEnabled,_that.vibrationEnabled,_that.criticalityLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int advanceMinutes,  int repeatMinutes,  int maxReminders,  bool soundEnabled,  bool vibrationEnabled,  CriticalityLevel criticalityLevel)  $default,) {final _that = this;
switch (_that) {
case _ReminderSettings():
return $default(_that.advanceMinutes,_that.repeatMinutes,_that.maxReminders,_that.soundEnabled,_that.vibrationEnabled,_that.criticalityLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int advanceMinutes,  int repeatMinutes,  int maxReminders,  bool soundEnabled,  bool vibrationEnabled,  CriticalityLevel criticalityLevel)?  $default,) {final _that = this;
switch (_that) {
case _ReminderSettings() when $default != null:
return $default(_that.advanceMinutes,_that.repeatMinutes,_that.maxReminders,_that.soundEnabled,_that.vibrationEnabled,_that.criticalityLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderSettings implements ReminderSettings {
  const _ReminderSettings({this.advanceMinutes = 15, this.repeatMinutes = 15, this.maxReminders = 3, this.soundEnabled = true, this.vibrationEnabled = true, this.criticalityLevel = CriticalityLevel.medium});
  factory _ReminderSettings.fromJson(Map<String, dynamic> json) => _$ReminderSettingsFromJson(json);

@override@JsonKey() final  int advanceMinutes;
// Minutes before scheduled time to remind
@override@JsonKey() final  int repeatMinutes;
// Minutes between repeat reminders
@override@JsonKey() final  int maxReminders;
// Maximum number of reminders
@override@JsonKey() final  bool soundEnabled;
@override@JsonKey() final  bool vibrationEnabled;
@override@JsonKey() final  CriticalityLevel criticalityLevel;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderSettingsCopyWith<_ReminderSettings> get copyWith => __$ReminderSettingsCopyWithImpl<_ReminderSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderSettings&&(identical(other.advanceMinutes, advanceMinutes) || other.advanceMinutes == advanceMinutes)&&(identical(other.repeatMinutes, repeatMinutes) || other.repeatMinutes == repeatMinutes)&&(identical(other.maxReminders, maxReminders) || other.maxReminders == maxReminders)&&(identical(other.soundEnabled, soundEnabled) || other.soundEnabled == soundEnabled)&&(identical(other.vibrationEnabled, vibrationEnabled) || other.vibrationEnabled == vibrationEnabled)&&(identical(other.criticalityLevel, criticalityLevel) || other.criticalityLevel == criticalityLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,advanceMinutes,repeatMinutes,maxReminders,soundEnabled,vibrationEnabled,criticalityLevel);

@override
String toString() {
  return 'ReminderSettings(advanceMinutes: $advanceMinutes, repeatMinutes: $repeatMinutes, maxReminders: $maxReminders, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, criticalityLevel: $criticalityLevel)';
}


}

/// @nodoc
abstract mixin class _$ReminderSettingsCopyWith<$Res> implements $ReminderSettingsCopyWith<$Res> {
  factory _$ReminderSettingsCopyWith(_ReminderSettings value, $Res Function(_ReminderSettings) _then) = __$ReminderSettingsCopyWithImpl;
@override @useResult
$Res call({
 int advanceMinutes, int repeatMinutes, int maxReminders, bool soundEnabled, bool vibrationEnabled, CriticalityLevel criticalityLevel
});




}
/// @nodoc
class __$ReminderSettingsCopyWithImpl<$Res>
    implements _$ReminderSettingsCopyWith<$Res> {
  __$ReminderSettingsCopyWithImpl(this._self, this._then);

  final _ReminderSettings _self;
  final $Res Function(_ReminderSettings) _then;

/// Create a copy of ReminderSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? advanceMinutes = null,Object? repeatMinutes = null,Object? maxReminders = null,Object? soundEnabled = null,Object? vibrationEnabled = null,Object? criticalityLevel = null,}) {
  return _then(_ReminderSettings(
advanceMinutes: null == advanceMinutes ? _self.advanceMinutes : advanceMinutes // ignore: cast_nullable_to_non_nullable
as int,repeatMinutes: null == repeatMinutes ? _self.repeatMinutes : repeatMinutes // ignore: cast_nullable_to_non_nullable
as int,maxReminders: null == maxReminders ? _self.maxReminders : maxReminders // ignore: cast_nullable_to_non_nullable
as int,soundEnabled: null == soundEnabled ? _self.soundEnabled : soundEnabled // ignore: cast_nullable_to_non_nullable
as bool,vibrationEnabled: null == vibrationEnabled ? _self.vibrationEnabled : vibrationEnabled // ignore: cast_nullable_to_non_nullable
as bool,criticalityLevel: null == criticalityLevel ? _self.criticalityLevel : criticalityLevel // ignore: cast_nullable_to_non_nullable
as CriticalityLevel,
  ));
}


}


/// @nodoc
mixin _$MedicationSchedule {

 String get id; String get medicationId; String get userId; String get instructions; bool get remindersEnabled; DateTime get startDate; DateTime? get endDate; DosageSchedule get schedule; List<Time> get reminderTimes; ReminderSettings get reminderSettings; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<MedicationSchedule> get copyWith => _$MedicationScheduleCopyWithImpl<MedicationSchedule>(this as MedicationSchedule, _$identity);

  /// Serializes this MedicationSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.reminderTimes, reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,userId,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(reminderTimes),reminderSettings,createdAt,updatedAt);

@override
String toString() {
  return 'MedicationSchedule(id: $id, medicationId: $medicationId, userId: $userId, instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MedicationScheduleCopyWith<$Res>  {
  factory $MedicationScheduleCopyWith(MedicationSchedule value, $Res Function(MedicationSchedule) _then) = _$MedicationScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, String userId, String instructions, bool remindersEnabled, DateTime startDate, DateTime? endDate, DosageSchedule schedule, List<Time> reminderTimes, ReminderSettings reminderSettings, DateTime createdAt, DateTime updatedAt
});


$DosageScheduleCopyWith<$Res> get schedule;$ReminderSettingsCopyWith<$Res> get reminderSettings;

}
/// @nodoc
class _$MedicationScheduleCopyWithImpl<$Res>
    implements $MedicationScheduleCopyWith<$Res> {
  _$MedicationScheduleCopyWithImpl(this._self, this._then);

  final MedicationSchedule _self;
  final $Res Function(MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? userId = null,Object? instructions = null,Object? remindersEnabled = null,Object? startDate = null,Object? endDate = freezed,Object? schedule = null,Object? reminderTimes = null,Object? reminderSettings = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule,reminderTimes: null == reminderTimes ? _self.reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,reminderSettings: null == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res> get schedule {
  
  return $DosageScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res> get reminderSettings {
  
  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationSchedule].
extension MedicationSchedulePatterns on MedicationSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationSchedule value)  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  String userId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.userId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  String userId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule():
return $default(_that.id,_that.medicationId,_that.userId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  String userId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MedicationSchedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.userId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationSchedule implements MedicationSchedule {
  const _MedicationSchedule({required this.id, required this.medicationId, required this.userId, required this.instructions, this.remindersEnabled = true, required this.startDate, this.endDate, required this.schedule, final  List<Time> reminderTimes = const [], this.reminderSettings = const ReminderSettings(), required this.createdAt, required this.updatedAt}): _reminderTimes = reminderTimes;
  factory _MedicationSchedule.fromJson(Map<String, dynamic> json) => _$MedicationScheduleFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  String userId;
@override final  String instructions;
@override@JsonKey() final  bool remindersEnabled;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  DosageSchedule schedule;
 final  List<Time> _reminderTimes;
@override@JsonKey() List<Time> get reminderTimes {
  if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderTimes);
}

@override@JsonKey() final  ReminderSettings reminderSettings;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationScheduleCopyWith<_MedicationSchedule> get copyWith => __$MedicationScheduleCopyWithImpl<_MedicationSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,userId,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(_reminderTimes),reminderSettings,createdAt,updatedAt);

@override
String toString() {
  return 'MedicationSchedule(id: $id, medicationId: $medicationId, userId: $userId, instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationScheduleCopyWith<$Res> implements $MedicationScheduleCopyWith<$Res> {
  factory _$MedicationScheduleCopyWith(_MedicationSchedule value, $Res Function(_MedicationSchedule) _then) = __$MedicationScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, String userId, String instructions, bool remindersEnabled, DateTime startDate, DateTime? endDate, DosageSchedule schedule, List<Time> reminderTimes, ReminderSettings reminderSettings, DateTime createdAt, DateTime updatedAt
});


@override $DosageScheduleCopyWith<$Res> get schedule;@override $ReminderSettingsCopyWith<$Res> get reminderSettings;

}
/// @nodoc
class __$MedicationScheduleCopyWithImpl<$Res>
    implements _$MedicationScheduleCopyWith<$Res> {
  __$MedicationScheduleCopyWithImpl(this._self, this._then);

  final _MedicationSchedule _self;
  final $Res Function(_MedicationSchedule) _then;

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? userId = null,Object? instructions = null,Object? remindersEnabled = null,Object? startDate = null,Object? endDate = freezed,Object? schedule = null,Object? reminderTimes = null,Object? reminderSettings = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MedicationSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule,reminderTimes: null == reminderTimes ? _self._reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,reminderSettings: null == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res> get schedule {
  
  return $DosageScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of MedicationSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res> get reminderSettings {
  
  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// @nodoc
mixin _$CreateScheduleRequest {

 String get medicationId; String get instructions; bool get remindersEnabled; DateTime get startDate; DateTime? get endDate; DosageSchedule get schedule; List<Time> get reminderTimes; ReminderSettings get reminderSettings;
/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateScheduleRequestCopyWith<CreateScheduleRequest> get copyWith => _$CreateScheduleRequestCopyWithImpl<CreateScheduleRequest>(this as CreateScheduleRequest, _$identity);

  /// Serializes this CreateScheduleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateScheduleRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.reminderTimes, reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(reminderTimes),reminderSettings);

@override
String toString() {
  return 'CreateScheduleRequest(medicationId: $medicationId, instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings)';
}


}

/// @nodoc
abstract mixin class $CreateScheduleRequestCopyWith<$Res>  {
  factory $CreateScheduleRequestCopyWith(CreateScheduleRequest value, $Res Function(CreateScheduleRequest) _then) = _$CreateScheduleRequestCopyWithImpl;
@useResult
$Res call({
 String medicationId, String instructions, bool remindersEnabled, DateTime startDate, DateTime? endDate, DosageSchedule schedule, List<Time> reminderTimes, ReminderSettings reminderSettings
});


$DosageScheduleCopyWith<$Res> get schedule;$ReminderSettingsCopyWith<$Res> get reminderSettings;

}
/// @nodoc
class _$CreateScheduleRequestCopyWithImpl<$Res>
    implements $CreateScheduleRequestCopyWith<$Res> {
  _$CreateScheduleRequestCopyWithImpl(this._self, this._then);

  final CreateScheduleRequest _self;
  final $Res Function(CreateScheduleRequest) _then;

/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? instructions = null,Object? remindersEnabled = null,Object? startDate = null,Object? endDate = freezed,Object? schedule = null,Object? reminderTimes = null,Object? reminderSettings = null,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule,reminderTimes: null == reminderTimes ? _self.reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,reminderSettings: null == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings,
  ));
}
/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res> get schedule {
  
  return $DosageScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res> get reminderSettings {
  
  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateScheduleRequest].
extension CreateScheduleRequestPatterns on CreateScheduleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateScheduleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateScheduleRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateScheduleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateScheduleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateScheduleRequest() when $default != null:
return $default(_that.medicationId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings)  $default,) {final _that = this;
switch (_that) {
case _CreateScheduleRequest():
return $default(_that.medicationId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  String instructions,  bool remindersEnabled,  DateTime startDate,  DateTime? endDate,  DosageSchedule schedule,  List<Time> reminderTimes,  ReminderSettings reminderSettings)?  $default,) {final _that = this;
switch (_that) {
case _CreateScheduleRequest() when $default != null:
return $default(_that.medicationId,_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateScheduleRequest implements CreateScheduleRequest {
  const _CreateScheduleRequest({required this.medicationId, required this.instructions, this.remindersEnabled = true, required this.startDate, this.endDate, required this.schedule, final  List<Time> reminderTimes = const [], this.reminderSettings = const ReminderSettings()}): _reminderTimes = reminderTimes;
  factory _CreateScheduleRequest.fromJson(Map<String, dynamic> json) => _$CreateScheduleRequestFromJson(json);

@override final  String medicationId;
@override final  String instructions;
@override@JsonKey() final  bool remindersEnabled;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  DosageSchedule schedule;
 final  List<Time> _reminderTimes;
@override@JsonKey() List<Time> get reminderTimes {
  if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reminderTimes);
}

@override@JsonKey() final  ReminderSettings reminderSettings;

/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateScheduleRequestCopyWith<_CreateScheduleRequest> get copyWith => __$CreateScheduleRequestCopyWithImpl<_CreateScheduleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateScheduleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateScheduleRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(_reminderTimes),reminderSettings);

@override
String toString() {
  return 'CreateScheduleRequest(medicationId: $medicationId, instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings)';
}


}

/// @nodoc
abstract mixin class _$CreateScheduleRequestCopyWith<$Res> implements $CreateScheduleRequestCopyWith<$Res> {
  factory _$CreateScheduleRequestCopyWith(_CreateScheduleRequest value, $Res Function(_CreateScheduleRequest) _then) = __$CreateScheduleRequestCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, String instructions, bool remindersEnabled, DateTime startDate, DateTime? endDate, DosageSchedule schedule, List<Time> reminderTimes, ReminderSettings reminderSettings
});


@override $DosageScheduleCopyWith<$Res> get schedule;@override $ReminderSettingsCopyWith<$Res> get reminderSettings;

}
/// @nodoc
class __$CreateScheduleRequestCopyWithImpl<$Res>
    implements _$CreateScheduleRequestCopyWith<$Res> {
  __$CreateScheduleRequestCopyWithImpl(this._self, this._then);

  final _CreateScheduleRequest _self;
  final $Res Function(_CreateScheduleRequest) _then;

/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? instructions = null,Object? remindersEnabled = null,Object? startDate = null,Object? endDate = freezed,Object? schedule = null,Object? reminderTimes = null,Object? reminderSettings = null,}) {
  return _then(_CreateScheduleRequest(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,remindersEnabled: null == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule,reminderTimes: null == reminderTimes ? _self._reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>,reminderSettings: null == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings,
  ));
}

/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res> get schedule {
  
  return $DosageScheduleCopyWith<$Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of CreateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res> get reminderSettings {
  
  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// @nodoc
mixin _$UpdateScheduleRequest {

 String? get instructions; bool? get remindersEnabled; DateTime? get startDate; DateTime? get endDate; DosageSchedule? get schedule; List<Time>? get reminderTimes; ReminderSettings? get reminderSettings;
/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateScheduleRequestCopyWith<UpdateScheduleRequest> get copyWith => _$UpdateScheduleRequestCopyWithImpl<UpdateScheduleRequest>(this as UpdateScheduleRequest, _$identity);

  /// Serializes this UpdateScheduleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateScheduleRequest&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other.reminderTimes, reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(reminderTimes),reminderSettings);

@override
String toString() {
  return 'UpdateScheduleRequest(instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings)';
}


}

/// @nodoc
abstract mixin class $UpdateScheduleRequestCopyWith<$Res>  {
  factory $UpdateScheduleRequestCopyWith(UpdateScheduleRequest value, $Res Function(UpdateScheduleRequest) _then) = _$UpdateScheduleRequestCopyWithImpl;
@useResult
$Res call({
 String? instructions, bool? remindersEnabled, DateTime? startDate, DateTime? endDate, DosageSchedule? schedule, List<Time>? reminderTimes, ReminderSettings? reminderSettings
});


$DosageScheduleCopyWith<$Res>? get schedule;$ReminderSettingsCopyWith<$Res>? get reminderSettings;

}
/// @nodoc
class _$UpdateScheduleRequestCopyWithImpl<$Res>
    implements $UpdateScheduleRequestCopyWith<$Res> {
  _$UpdateScheduleRequestCopyWithImpl(this._self, this._then);

  final UpdateScheduleRequest _self;
  final $Res Function(UpdateScheduleRequest) _then;

/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instructions = freezed,Object? remindersEnabled = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? schedule = freezed,Object? reminderTimes = freezed,Object? reminderSettings = freezed,}) {
  return _then(_self.copyWith(
instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,remindersEnabled: freezed == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule?,reminderTimes: freezed == reminderTimes ? _self.reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>?,reminderSettings: freezed == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings?,
  ));
}
/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $DosageScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res>? get reminderSettings {
    if (_self.reminderSettings == null) {
    return null;
  }

  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings!, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateScheduleRequest].
extension UpdateScheduleRequestPatterns on UpdateScheduleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateScheduleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateScheduleRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateScheduleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateScheduleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateScheduleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? instructions,  bool? remindersEnabled,  DateTime? startDate,  DateTime? endDate,  DosageSchedule? schedule,  List<Time>? reminderTimes,  ReminderSettings? reminderSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateScheduleRequest() when $default != null:
return $default(_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? instructions,  bool? remindersEnabled,  DateTime? startDate,  DateTime? endDate,  DosageSchedule? schedule,  List<Time>? reminderTimes,  ReminderSettings? reminderSettings)  $default,) {final _that = this;
switch (_that) {
case _UpdateScheduleRequest():
return $default(_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? instructions,  bool? remindersEnabled,  DateTime? startDate,  DateTime? endDate,  DosageSchedule? schedule,  List<Time>? reminderTimes,  ReminderSettings? reminderSettings)?  $default,) {final _that = this;
switch (_that) {
case _UpdateScheduleRequest() when $default != null:
return $default(_that.instructions,_that.remindersEnabled,_that.startDate,_that.endDate,_that.schedule,_that.reminderTimes,_that.reminderSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateScheduleRequest implements UpdateScheduleRequest {
  const _UpdateScheduleRequest({this.instructions, this.remindersEnabled, this.startDate, this.endDate, this.schedule, final  List<Time>? reminderTimes, this.reminderSettings}): _reminderTimes = reminderTimes;
  factory _UpdateScheduleRequest.fromJson(Map<String, dynamic> json) => _$UpdateScheduleRequestFromJson(json);

@override final  String? instructions;
@override final  bool? remindersEnabled;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  DosageSchedule? schedule;
 final  List<Time>? _reminderTimes;
@override List<Time>? get reminderTimes {
  final value = _reminderTimes;
  if (value == null) return null;
  if (_reminderTimes is EqualUnmodifiableListView) return _reminderTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ReminderSettings? reminderSettings;

/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateScheduleRequestCopyWith<_UpdateScheduleRequest> get copyWith => __$UpdateScheduleRequestCopyWithImpl<_UpdateScheduleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateScheduleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateScheduleRequest&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.remindersEnabled, remindersEnabled) || other.remindersEnabled == remindersEnabled)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&const DeepCollectionEquality().equals(other._reminderTimes, _reminderTimes)&&(identical(other.reminderSettings, reminderSettings) || other.reminderSettings == reminderSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,instructions,remindersEnabled,startDate,endDate,schedule,const DeepCollectionEquality().hash(_reminderTimes),reminderSettings);

@override
String toString() {
  return 'UpdateScheduleRequest(instructions: $instructions, remindersEnabled: $remindersEnabled, startDate: $startDate, endDate: $endDate, schedule: $schedule, reminderTimes: $reminderTimes, reminderSettings: $reminderSettings)';
}


}

/// @nodoc
abstract mixin class _$UpdateScheduleRequestCopyWith<$Res> implements $UpdateScheduleRequestCopyWith<$Res> {
  factory _$UpdateScheduleRequestCopyWith(_UpdateScheduleRequest value, $Res Function(_UpdateScheduleRequest) _then) = __$UpdateScheduleRequestCopyWithImpl;
@override @useResult
$Res call({
 String? instructions, bool? remindersEnabled, DateTime? startDate, DateTime? endDate, DosageSchedule? schedule, List<Time>? reminderTimes, ReminderSettings? reminderSettings
});


@override $DosageScheduleCopyWith<$Res>? get schedule;@override $ReminderSettingsCopyWith<$Res>? get reminderSettings;

}
/// @nodoc
class __$UpdateScheduleRequestCopyWithImpl<$Res>
    implements _$UpdateScheduleRequestCopyWith<$Res> {
  __$UpdateScheduleRequestCopyWithImpl(this._self, this._then);

  final _UpdateScheduleRequest _self;
  final $Res Function(_UpdateScheduleRequest) _then;

/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instructions = freezed,Object? remindersEnabled = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? schedule = freezed,Object? reminderTimes = freezed,Object? reminderSettings = freezed,}) {
  return _then(_UpdateScheduleRequest(
instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,remindersEnabled: freezed == remindersEnabled ? _self.remindersEnabled : remindersEnabled // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as DosageSchedule?,reminderTimes: freezed == reminderTimes ? _self._reminderTimes : reminderTimes // ignore: cast_nullable_to_non_nullable
as List<Time>?,reminderSettings: freezed == reminderSettings ? _self.reminderSettings : reminderSettings // ignore: cast_nullable_to_non_nullable
as ReminderSettings?,
  ));
}

/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DosageScheduleCopyWith<$Res>? get schedule {
    if (_self.schedule == null) {
    return null;
  }

  return $DosageScheduleCopyWith<$Res>(_self.schedule!, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of UpdateScheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReminderSettingsCopyWith<$Res>? get reminderSettings {
    if (_self.reminderSettings == null) {
    return null;
  }

  return $ReminderSettingsCopyWith<$Res>(_self.reminderSettings!, (value) {
    return _then(_self.copyWith(reminderSettings: value));
  });
}
}


/// @nodoc
mixin _$ScheduleResponse {

 bool get success; MedicationSchedule? get data; String? get message; String? get error;
/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleResponseCopyWith<ScheduleResponse> get copyWith => _$ScheduleResponseCopyWithImpl<ScheduleResponse>(this as ScheduleResponse, _$identity);

  /// Serializes this ScheduleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'ScheduleResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $ScheduleResponseCopyWith<$Res>  {
  factory $ScheduleResponseCopyWith(ScheduleResponse value, $Res Function(ScheduleResponse) _then) = _$ScheduleResponseCopyWithImpl;
@useResult
$Res call({
 bool success, MedicationSchedule? data, String? message, String? error
});


$MedicationScheduleCopyWith<$Res>? get data;

}
/// @nodoc
class _$ScheduleResponseCopyWithImpl<$Res>
    implements $ScheduleResponseCopyWith<$Res> {
  _$ScheduleResponseCopyWithImpl(this._self, this._then);

  final ScheduleResponse _self;
  final $Res Function(ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MedicationSchedule?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationScheduleCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleResponse].
extension ScheduleResponsePatterns on ScheduleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  MedicationSchedule? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  MedicationSchedule? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  MedicationSchedule? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleResponse implements ScheduleResponse {
  const _ScheduleResponse({required this.success, this.data, this.message, this.error});
  factory _ScheduleResponse.fromJson(Map<String, dynamic> json) => _$ScheduleResponseFromJson(json);

@override final  bool success;
@override final  MedicationSchedule? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleResponseCopyWith<_ScheduleResponse> get copyWith => __$ScheduleResponseCopyWithImpl<_ScheduleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'ScheduleResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ScheduleResponseCopyWith<$Res> implements $ScheduleResponseCopyWith<$Res> {
  factory _$ScheduleResponseCopyWith(_ScheduleResponse value, $Res Function(_ScheduleResponse) _then) = __$ScheduleResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, MedicationSchedule? data, String? message, String? error
});


@override $MedicationScheduleCopyWith<$Res>? get data;

}
/// @nodoc
class __$ScheduleResponseCopyWithImpl<$Res>
    implements _$ScheduleResponseCopyWith<$Res> {
  __$ScheduleResponseCopyWithImpl(this._self, this._then);

  final _ScheduleResponse _self;
  final $Res Function(_ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_ScheduleResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MedicationSchedule?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationScheduleCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationScheduleCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ScheduleListResponse {

 bool get success; List<MedicationSchedule> get data; int? get count; int? get total; String? get message; String? get error;
/// Create a copy of ScheduleListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleListResponseCopyWith<ScheduleListResponse> get copyWith => _$ScheduleListResponseCopyWithImpl<ScheduleListResponse>(this as ScheduleListResponse, _$identity);

  /// Serializes this ScheduleListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,total,message,error);

@override
String toString() {
  return 'ScheduleListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $ScheduleListResponseCopyWith<$Res>  {
  factory $ScheduleListResponseCopyWith(ScheduleListResponse value, $Res Function(ScheduleListResponse) _then) = _$ScheduleListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<MedicationSchedule> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class _$ScheduleListResponseCopyWithImpl<$Res>
    implements $ScheduleListResponseCopyWith<$Res> {
  _$ScheduleListResponseCopyWithImpl(this._self, this._then);

  final ScheduleListResponse _self;
  final $Res Function(ScheduleListResponse) _then;

/// Create a copy of ScheduleListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationSchedule>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleListResponse].
extension ScheduleListResponsePatterns on ScheduleListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<MedicationSchedule> data,  int? count,  int? total,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<MedicationSchedule> data,  int? count,  int? total,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ScheduleListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<MedicationSchedule> data,  int? count,  int? total,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleListResponse implements ScheduleListResponse {
  const _ScheduleListResponse({required this.success, final  List<MedicationSchedule> data = const [], this.count, this.total, this.message, this.error}): _data = data;
  factory _ScheduleListResponse.fromJson(Map<String, dynamic> json) => _$ScheduleListResponseFromJson(json);

@override final  bool success;
 final  List<MedicationSchedule> _data;
@override@JsonKey() List<MedicationSchedule> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  int? total;
@override final  String? message;
@override final  String? error;

/// Create a copy of ScheduleListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleListResponseCopyWith<_ScheduleListResponse> get copyWith => __$ScheduleListResponseCopyWithImpl<_ScheduleListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,total,message,error);

@override
String toString() {
  return 'ScheduleListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ScheduleListResponseCopyWith<$Res> implements $ScheduleListResponseCopyWith<$Res> {
  factory _$ScheduleListResponseCopyWith(_ScheduleListResponse value, $Res Function(_ScheduleListResponse) _then) = __$ScheduleListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<MedicationSchedule> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class __$ScheduleListResponseCopyWithImpl<$Res>
    implements _$ScheduleListResponseCopyWith<$Res> {
  __$ScheduleListResponseCopyWithImpl(this._self, this._then);

  final _ScheduleListResponse _self;
  final $Res Function(_ScheduleListResponse) _then;

/// Create a copy of ScheduleListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_ScheduleListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<MedicationSchedule>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
