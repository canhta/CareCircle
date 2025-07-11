// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaselineMetrics {

 double get height; double get weight; double get bmi; double get restingHeartRate; BloodPressure get bloodPressure; double get bloodGlucose;
/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaselineMetricsCopyWith<BaselineMetrics> get copyWith => _$BaselineMetricsCopyWithImpl<BaselineMetrics>(this as BaselineMetrics, _$identity);

  /// Serializes this BaselineMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaselineMetrics&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.restingHeartRate, restingHeartRate) || other.restingHeartRate == restingHeartRate)&&(identical(other.bloodPressure, bloodPressure) || other.bloodPressure == bloodPressure)&&(identical(other.bloodGlucose, bloodGlucose) || other.bloodGlucose == bloodGlucose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,height,weight,bmi,restingHeartRate,bloodPressure,bloodGlucose);

@override
String toString() {
  return 'BaselineMetrics(height: $height, weight: $weight, bmi: $bmi, restingHeartRate: $restingHeartRate, bloodPressure: $bloodPressure, bloodGlucose: $bloodGlucose)';
}


}

/// @nodoc
abstract mixin class $BaselineMetricsCopyWith<$Res>  {
  factory $BaselineMetricsCopyWith(BaselineMetrics value, $Res Function(BaselineMetrics) _then) = _$BaselineMetricsCopyWithImpl;
@useResult
$Res call({
 double height, double weight, double bmi, double restingHeartRate, BloodPressure bloodPressure, double bloodGlucose
});


$BloodPressureCopyWith<$Res> get bloodPressure;

}
/// @nodoc
class _$BaselineMetricsCopyWithImpl<$Res>
    implements $BaselineMetricsCopyWith<$Res> {
  _$BaselineMetricsCopyWithImpl(this._self, this._then);

  final BaselineMetrics _self;
  final $Res Function(BaselineMetrics) _then;

/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? height = null,Object? weight = null,Object? bmi = null,Object? restingHeartRate = null,Object? bloodPressure = null,Object? bloodGlucose = null,}) {
  return _then(_self.copyWith(
height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,restingHeartRate: null == restingHeartRate ? _self.restingHeartRate : restingHeartRate // ignore: cast_nullable_to_non_nullable
as double,bloodPressure: null == bloodPressure ? _self.bloodPressure : bloodPressure // ignore: cast_nullable_to_non_nullable
as BloodPressure,bloodGlucose: null == bloodGlucose ? _self.bloodGlucose : bloodGlucose // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BloodPressureCopyWith<$Res> get bloodPressure {
  
  return $BloodPressureCopyWith<$Res>(_self.bloodPressure, (value) {
    return _then(_self.copyWith(bloodPressure: value));
  });
}
}


/// Adds pattern-matching-related methods to [BaselineMetrics].
extension BaselineMetricsPatterns on BaselineMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaselineMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaselineMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaselineMetrics value)  $default,){
final _that = this;
switch (_that) {
case _BaselineMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaselineMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _BaselineMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double height,  double weight,  double bmi,  double restingHeartRate,  BloodPressure bloodPressure,  double bloodGlucose)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaselineMetrics() when $default != null:
return $default(_that.height,_that.weight,_that.bmi,_that.restingHeartRate,_that.bloodPressure,_that.bloodGlucose);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double height,  double weight,  double bmi,  double restingHeartRate,  BloodPressure bloodPressure,  double bloodGlucose)  $default,) {final _that = this;
switch (_that) {
case _BaselineMetrics():
return $default(_that.height,_that.weight,_that.bmi,_that.restingHeartRate,_that.bloodPressure,_that.bloodGlucose);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double height,  double weight,  double bmi,  double restingHeartRate,  BloodPressure bloodPressure,  double bloodGlucose)?  $default,) {final _that = this;
switch (_that) {
case _BaselineMetrics() when $default != null:
return $default(_that.height,_that.weight,_that.bmi,_that.restingHeartRate,_that.bloodPressure,_that.bloodGlucose);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BaselineMetrics implements BaselineMetrics {
  const _BaselineMetrics({required this.height, required this.weight, required this.bmi, required this.restingHeartRate, required this.bloodPressure, required this.bloodGlucose});
  factory _BaselineMetrics.fromJson(Map<String, dynamic> json) => _$BaselineMetricsFromJson(json);

@override final  double height;
@override final  double weight;
@override final  double bmi;
@override final  double restingHeartRate;
@override final  BloodPressure bloodPressure;
@override final  double bloodGlucose;

/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaselineMetricsCopyWith<_BaselineMetrics> get copyWith => __$BaselineMetricsCopyWithImpl<_BaselineMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BaselineMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaselineMetrics&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.restingHeartRate, restingHeartRate) || other.restingHeartRate == restingHeartRate)&&(identical(other.bloodPressure, bloodPressure) || other.bloodPressure == bloodPressure)&&(identical(other.bloodGlucose, bloodGlucose) || other.bloodGlucose == bloodGlucose));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,height,weight,bmi,restingHeartRate,bloodPressure,bloodGlucose);

@override
String toString() {
  return 'BaselineMetrics(height: $height, weight: $weight, bmi: $bmi, restingHeartRate: $restingHeartRate, bloodPressure: $bloodPressure, bloodGlucose: $bloodGlucose)';
}


}

/// @nodoc
abstract mixin class _$BaselineMetricsCopyWith<$Res> implements $BaselineMetricsCopyWith<$Res> {
  factory _$BaselineMetricsCopyWith(_BaselineMetrics value, $Res Function(_BaselineMetrics) _then) = __$BaselineMetricsCopyWithImpl;
@override @useResult
$Res call({
 double height, double weight, double bmi, double restingHeartRate, BloodPressure bloodPressure, double bloodGlucose
});


@override $BloodPressureCopyWith<$Res> get bloodPressure;

}
/// @nodoc
class __$BaselineMetricsCopyWithImpl<$Res>
    implements _$BaselineMetricsCopyWith<$Res> {
  __$BaselineMetricsCopyWithImpl(this._self, this._then);

  final _BaselineMetrics _self;
  final $Res Function(_BaselineMetrics) _then;

/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? height = null,Object? weight = null,Object? bmi = null,Object? restingHeartRate = null,Object? bloodPressure = null,Object? bloodGlucose = null,}) {
  return _then(_BaselineMetrics(
height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,bmi: null == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double,restingHeartRate: null == restingHeartRate ? _self.restingHeartRate : restingHeartRate // ignore: cast_nullable_to_non_nullable
as double,bloodPressure: null == bloodPressure ? _self.bloodPressure : bloodPressure // ignore: cast_nullable_to_non_nullable
as BloodPressure,bloodGlucose: null == bloodGlucose ? _self.bloodGlucose : bloodGlucose // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of BaselineMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BloodPressureCopyWith<$Res> get bloodPressure {
  
  return $BloodPressureCopyWith<$Res>(_self.bloodPressure, (value) {
    return _then(_self.copyWith(bloodPressure: value));
  });
}
}


/// @nodoc
mixin _$BloodPressure {

 double get systolic; double get diastolic;
/// Create a copy of BloodPressure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodPressureCopyWith<BloodPressure> get copyWith => _$BloodPressureCopyWithImpl<BloodPressure>(this as BloodPressure, _$identity);

  /// Serializes this BloodPressure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodPressure&&(identical(other.systolic, systolic) || other.systolic == systolic)&&(identical(other.diastolic, diastolic) || other.diastolic == diastolic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systolic,diastolic);

@override
String toString() {
  return 'BloodPressure(systolic: $systolic, diastolic: $diastolic)';
}


}

/// @nodoc
abstract mixin class $BloodPressureCopyWith<$Res>  {
  factory $BloodPressureCopyWith(BloodPressure value, $Res Function(BloodPressure) _then) = _$BloodPressureCopyWithImpl;
@useResult
$Res call({
 double systolic, double diastolic
});




}
/// @nodoc
class _$BloodPressureCopyWithImpl<$Res>
    implements $BloodPressureCopyWith<$Res> {
  _$BloodPressureCopyWithImpl(this._self, this._then);

  final BloodPressure _self;
  final $Res Function(BloodPressure) _then;

/// Create a copy of BloodPressure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? systolic = null,Object? diastolic = null,}) {
  return _then(_self.copyWith(
systolic: null == systolic ? _self.systolic : systolic // ignore: cast_nullable_to_non_nullable
as double,diastolic: null == diastolic ? _self.diastolic : diastolic // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BloodPressure].
extension BloodPressurePatterns on BloodPressure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodPressure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodPressure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodPressure value)  $default,){
final _that = this;
switch (_that) {
case _BloodPressure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodPressure value)?  $default,){
final _that = this;
switch (_that) {
case _BloodPressure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double systolic,  double diastolic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodPressure() when $default != null:
return $default(_that.systolic,_that.diastolic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double systolic,  double diastolic)  $default,) {final _that = this;
switch (_that) {
case _BloodPressure():
return $default(_that.systolic,_that.diastolic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double systolic,  double diastolic)?  $default,) {final _that = this;
switch (_that) {
case _BloodPressure() when $default != null:
return $default(_that.systolic,_that.diastolic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BloodPressure implements BloodPressure {
  const _BloodPressure({required this.systolic, required this.diastolic});
  factory _BloodPressure.fromJson(Map<String, dynamic> json) => _$BloodPressureFromJson(json);

@override final  double systolic;
@override final  double diastolic;

/// Create a copy of BloodPressure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodPressureCopyWith<_BloodPressure> get copyWith => __$BloodPressureCopyWithImpl<_BloodPressure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BloodPressureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodPressure&&(identical(other.systolic, systolic) || other.systolic == systolic)&&(identical(other.diastolic, diastolic) || other.diastolic == diastolic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systolic,diastolic);

@override
String toString() {
  return 'BloodPressure(systolic: $systolic, diastolic: $diastolic)';
}


}

/// @nodoc
abstract mixin class _$BloodPressureCopyWith<$Res> implements $BloodPressureCopyWith<$Res> {
  factory _$BloodPressureCopyWith(_BloodPressure value, $Res Function(_BloodPressure) _then) = __$BloodPressureCopyWithImpl;
@override @useResult
$Res call({
 double systolic, double diastolic
});




}
/// @nodoc
class __$BloodPressureCopyWithImpl<$Res>
    implements _$BloodPressureCopyWith<$Res> {
  __$BloodPressureCopyWithImpl(this._self, this._then);

  final _BloodPressure _self;
  final $Res Function(_BloodPressure) _then;

/// Create a copy of BloodPressure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? systolic = null,Object? diastolic = null,}) {
  return _then(_BloodPressure(
systolic: null == systolic ? _self.systolic : systolic // ignore: cast_nullable_to_non_nullable
as double,diastolic: null == diastolic ? _self.diastolic : diastolic // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$HealthCondition {

 String get name; DateTime? get diagnosisDate; bool get isCurrent; String get severity;// 'mild', 'moderate', 'severe'
 List<String>? get medications; String? get notes;
/// Create a copy of HealthCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthConditionCopyWith<HealthCondition> get copyWith => _$HealthConditionCopyWithImpl<HealthCondition>(this as HealthCondition, _$identity);

  /// Serializes this HealthCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthCondition&&(identical(other.name, name) || other.name == name)&&(identical(other.diagnosisDate, diagnosisDate) || other.diagnosisDate == diagnosisDate)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.severity, severity) || other.severity == severity)&&const DeepCollectionEquality().equals(other.medications, medications)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,diagnosisDate,isCurrent,severity,const DeepCollectionEquality().hash(medications),notes);

@override
String toString() {
  return 'HealthCondition(name: $name, diagnosisDate: $diagnosisDate, isCurrent: $isCurrent, severity: $severity, medications: $medications, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $HealthConditionCopyWith<$Res>  {
  factory $HealthConditionCopyWith(HealthCondition value, $Res Function(HealthCondition) _then) = _$HealthConditionCopyWithImpl;
@useResult
$Res call({
 String name, DateTime? diagnosisDate, bool isCurrent, String severity, List<String>? medications, String? notes
});




}
/// @nodoc
class _$HealthConditionCopyWithImpl<$Res>
    implements $HealthConditionCopyWith<$Res> {
  _$HealthConditionCopyWithImpl(this._self, this._then);

  final HealthCondition _self;
  final $Res Function(HealthCondition) _then;

/// Create a copy of HealthCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? diagnosisDate = freezed,Object? isCurrent = null,Object? severity = null,Object? medications = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,diagnosisDate: freezed == diagnosisDate ? _self.diagnosisDate : diagnosisDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthCondition].
extension HealthConditionPatterns on HealthCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthCondition value)  $default,){
final _that = this;
switch (_that) {
case _HealthCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthCondition value)?  $default,){
final _that = this;
switch (_that) {
case _HealthCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DateTime? diagnosisDate,  bool isCurrent,  String severity,  List<String>? medications,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthCondition() when $default != null:
return $default(_that.name,_that.diagnosisDate,_that.isCurrent,_that.severity,_that.medications,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DateTime? diagnosisDate,  bool isCurrent,  String severity,  List<String>? medications,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _HealthCondition():
return $default(_that.name,_that.diagnosisDate,_that.isCurrent,_that.severity,_that.medications,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DateTime? diagnosisDate,  bool isCurrent,  String severity,  List<String>? medications,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _HealthCondition() when $default != null:
return $default(_that.name,_that.diagnosisDate,_that.isCurrent,_that.severity,_that.medications,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthCondition implements HealthCondition {
  const _HealthCondition({required this.name, this.diagnosisDate, required this.isCurrent, required this.severity, final  List<String>? medications, this.notes}): _medications = medications;
  factory _HealthCondition.fromJson(Map<String, dynamic> json) => _$HealthConditionFromJson(json);

@override final  String name;
@override final  DateTime? diagnosisDate;
@override final  bool isCurrent;
@override final  String severity;
// 'mild', 'moderate', 'severe'
 final  List<String>? _medications;
// 'mild', 'moderate', 'severe'
@override List<String>? get medications {
  final value = _medications;
  if (value == null) return null;
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? notes;

/// Create a copy of HealthCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthConditionCopyWith<_HealthCondition> get copyWith => __$HealthConditionCopyWithImpl<_HealthCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthCondition&&(identical(other.name, name) || other.name == name)&&(identical(other.diagnosisDate, diagnosisDate) || other.diagnosisDate == diagnosisDate)&&(identical(other.isCurrent, isCurrent) || other.isCurrent == isCurrent)&&(identical(other.severity, severity) || other.severity == severity)&&const DeepCollectionEquality().equals(other._medications, _medications)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,diagnosisDate,isCurrent,severity,const DeepCollectionEquality().hash(_medications),notes);

@override
String toString() {
  return 'HealthCondition(name: $name, diagnosisDate: $diagnosisDate, isCurrent: $isCurrent, severity: $severity, medications: $medications, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$HealthConditionCopyWith<$Res> implements $HealthConditionCopyWith<$Res> {
  factory _$HealthConditionCopyWith(_HealthCondition value, $Res Function(_HealthCondition) _then) = __$HealthConditionCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime? diagnosisDate, bool isCurrent, String severity, List<String>? medications, String? notes
});




}
/// @nodoc
class __$HealthConditionCopyWithImpl<$Res>
    implements _$HealthConditionCopyWith<$Res> {
  __$HealthConditionCopyWithImpl(this._self, this._then);

  final _HealthCondition _self;
  final $Res Function(_HealthCondition) _then;

/// Create a copy of HealthCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? diagnosisDate = freezed,Object? isCurrent = null,Object? severity = null,Object? medications = freezed,Object? notes = freezed,}) {
  return _then(_HealthCondition(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,diagnosisDate: freezed == diagnosisDate ? _self.diagnosisDate : diagnosisDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isCurrent: null == isCurrent ? _self.isCurrent : isCurrent // ignore: cast_nullable_to_non_nullable
as bool,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,medications: freezed == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<String>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Allergy {

 String get allergen; String get reactionType; String get severity;
/// Create a copy of Allergy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllergyCopyWith<Allergy> get copyWith => _$AllergyCopyWithImpl<Allergy>(this as Allergy, _$identity);

  /// Serializes this Allergy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Allergy&&(identical(other.allergen, allergen) || other.allergen == allergen)&&(identical(other.reactionType, reactionType) || other.reactionType == reactionType)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allergen,reactionType,severity);

@override
String toString() {
  return 'Allergy(allergen: $allergen, reactionType: $reactionType, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $AllergyCopyWith<$Res>  {
  factory $AllergyCopyWith(Allergy value, $Res Function(Allergy) _then) = _$AllergyCopyWithImpl;
@useResult
$Res call({
 String allergen, String reactionType, String severity
});




}
/// @nodoc
class _$AllergyCopyWithImpl<$Res>
    implements $AllergyCopyWith<$Res> {
  _$AllergyCopyWithImpl(this._self, this._then);

  final Allergy _self;
  final $Res Function(Allergy) _then;

/// Create a copy of Allergy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allergen = null,Object? reactionType = null,Object? severity = null,}) {
  return _then(_self.copyWith(
allergen: null == allergen ? _self.allergen : allergen // ignore: cast_nullable_to_non_nullable
as String,reactionType: null == reactionType ? _self.reactionType : reactionType // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Allergy].
extension AllergyPatterns on Allergy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Allergy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Allergy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Allergy value)  $default,){
final _that = this;
switch (_that) {
case _Allergy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Allergy value)?  $default,){
final _that = this;
switch (_that) {
case _Allergy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String allergen,  String reactionType,  String severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Allergy() when $default != null:
return $default(_that.allergen,_that.reactionType,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String allergen,  String reactionType,  String severity)  $default,) {final _that = this;
switch (_that) {
case _Allergy():
return $default(_that.allergen,_that.reactionType,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String allergen,  String reactionType,  String severity)?  $default,) {final _that = this;
switch (_that) {
case _Allergy() when $default != null:
return $default(_that.allergen,_that.reactionType,_that.severity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Allergy implements Allergy {
  const _Allergy({required this.allergen, required this.reactionType, required this.severity});
  factory _Allergy.fromJson(Map<String, dynamic> json) => _$AllergyFromJson(json);

@override final  String allergen;
@override final  String reactionType;
@override final  String severity;

/// Create a copy of Allergy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AllergyCopyWith<_Allergy> get copyWith => __$AllergyCopyWithImpl<_Allergy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllergyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Allergy&&(identical(other.allergen, allergen) || other.allergen == allergen)&&(identical(other.reactionType, reactionType) || other.reactionType == reactionType)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allergen,reactionType,severity);

@override
String toString() {
  return 'Allergy(allergen: $allergen, reactionType: $reactionType, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$AllergyCopyWith<$Res> implements $AllergyCopyWith<$Res> {
  factory _$AllergyCopyWith(_Allergy value, $Res Function(_Allergy) _then) = __$AllergyCopyWithImpl;
@override @useResult
$Res call({
 String allergen, String reactionType, String severity
});




}
/// @nodoc
class __$AllergyCopyWithImpl<$Res>
    implements _$AllergyCopyWith<$Res> {
  __$AllergyCopyWithImpl(this._self, this._then);

  final _Allergy _self;
  final $Res Function(_Allergy) _then;

/// Create a copy of Allergy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allergen = null,Object? reactionType = null,Object? severity = null,}) {
  return _then(_Allergy(
allergen: null == allergen ? _self.allergen : allergen // ignore: cast_nullable_to_non_nullable
as String,reactionType: null == reactionType ? _self.reactionType : reactionType // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RiskFactor {

 String get type; String get description; String get riskLevel;
/// Create a copy of RiskFactor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiskFactorCopyWith<RiskFactor> get copyWith => _$RiskFactorCopyWithImpl<RiskFactor>(this as RiskFactor, _$identity);

  /// Serializes this RiskFactor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiskFactor&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,riskLevel);

@override
String toString() {
  return 'RiskFactor(type: $type, description: $description, riskLevel: $riskLevel)';
}


}

/// @nodoc
abstract mixin class $RiskFactorCopyWith<$Res>  {
  factory $RiskFactorCopyWith(RiskFactor value, $Res Function(RiskFactor) _then) = _$RiskFactorCopyWithImpl;
@useResult
$Res call({
 String type, String description, String riskLevel
});




}
/// @nodoc
class _$RiskFactorCopyWithImpl<$Res>
    implements $RiskFactorCopyWith<$Res> {
  _$RiskFactorCopyWithImpl(this._self, this._then);

  final RiskFactor _self;
  final $Res Function(RiskFactor) _then;

/// Create a copy of RiskFactor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? description = null,Object? riskLevel = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RiskFactor].
extension RiskFactorPatterns on RiskFactor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiskFactor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiskFactor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiskFactor value)  $default,){
final _that = this;
switch (_that) {
case _RiskFactor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiskFactor value)?  $default,){
final _that = this;
switch (_that) {
case _RiskFactor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String description,  String riskLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiskFactor() when $default != null:
return $default(_that.type,_that.description,_that.riskLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String description,  String riskLevel)  $default,) {final _that = this;
switch (_that) {
case _RiskFactor():
return $default(_that.type,_that.description,_that.riskLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String description,  String riskLevel)?  $default,) {final _that = this;
switch (_that) {
case _RiskFactor() when $default != null:
return $default(_that.type,_that.description,_that.riskLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiskFactor implements RiskFactor {
  const _RiskFactor({required this.type, required this.description, required this.riskLevel});
  factory _RiskFactor.fromJson(Map<String, dynamic> json) => _$RiskFactorFromJson(json);

@override final  String type;
@override final  String description;
@override final  String riskLevel;

/// Create a copy of RiskFactor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiskFactorCopyWith<_RiskFactor> get copyWith => __$RiskFactorCopyWithImpl<_RiskFactor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiskFactorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiskFactor&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,description,riskLevel);

@override
String toString() {
  return 'RiskFactor(type: $type, description: $description, riskLevel: $riskLevel)';
}


}

/// @nodoc
abstract mixin class _$RiskFactorCopyWith<$Res> implements $RiskFactorCopyWith<$Res> {
  factory _$RiskFactorCopyWith(_RiskFactor value, $Res Function(_RiskFactor) _then) = __$RiskFactorCopyWithImpl;
@override @useResult
$Res call({
 String type, String description, String riskLevel
});




}
/// @nodoc
class __$RiskFactorCopyWithImpl<$Res>
    implements _$RiskFactorCopyWith<$Res> {
  __$RiskFactorCopyWithImpl(this._self, this._then);

  final _RiskFactor _self;
  final $Res Function(_RiskFactor) _then;

/// Create a copy of RiskFactor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? description = null,Object? riskLevel = null,}) {
  return _then(_RiskFactor(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HealthGoal {

 String get id; String get metricType; double get targetValue; String get unit; DateTime get startDate; DateTime get targetDate; double get currentValue; double get progress;// 0-100%
 String get status;// 'active', 'achieved', 'behind', 'abandoned'
 String get recurrence;
/// Create a copy of HealthGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthGoalCopyWith<HealthGoal> get copyWith => _$HealthGoalCopyWithImpl<HealthGoal>(this as HealthGoal, _$identity);

  /// Serializes this HealthGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,metricType,targetValue,unit,startDate,targetDate,currentValue,progress,status,recurrence);

@override
String toString() {
  return 'HealthGoal(id: $id, metricType: $metricType, targetValue: $targetValue, unit: $unit, startDate: $startDate, targetDate: $targetDate, currentValue: $currentValue, progress: $progress, status: $status, recurrence: $recurrence)';
}


}

/// @nodoc
abstract mixin class $HealthGoalCopyWith<$Res>  {
  factory $HealthGoalCopyWith(HealthGoal value, $Res Function(HealthGoal) _then) = _$HealthGoalCopyWithImpl;
@useResult
$Res call({
 String id, String metricType, double targetValue, String unit, DateTime startDate, DateTime targetDate, double currentValue, double progress, String status, String recurrence
});




}
/// @nodoc
class _$HealthGoalCopyWithImpl<$Res>
    implements $HealthGoalCopyWith<$Res> {
  _$HealthGoalCopyWithImpl(this._self, this._then);

  final HealthGoal _self;
  final $Res Function(HealthGoal) _then;

/// Create a copy of HealthGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? metricType = null,Object? targetValue = null,Object? unit = null,Object? startDate = null,Object? targetDate = null,Object? currentValue = null,Object? progress = null,Object? status = null,Object? recurrence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as String,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthGoal].
extension HealthGoalPatterns on HealthGoal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthGoal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthGoal value)  $default,){
final _that = this;
switch (_that) {
case _HealthGoal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthGoal value)?  $default,){
final _that = this;
switch (_that) {
case _HealthGoal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String metricType,  double targetValue,  String unit,  DateTime startDate,  DateTime targetDate,  double currentValue,  double progress,  String status,  String recurrence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthGoal() when $default != null:
return $default(_that.id,_that.metricType,_that.targetValue,_that.unit,_that.startDate,_that.targetDate,_that.currentValue,_that.progress,_that.status,_that.recurrence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String metricType,  double targetValue,  String unit,  DateTime startDate,  DateTime targetDate,  double currentValue,  double progress,  String status,  String recurrence)  $default,) {final _that = this;
switch (_that) {
case _HealthGoal():
return $default(_that.id,_that.metricType,_that.targetValue,_that.unit,_that.startDate,_that.targetDate,_that.currentValue,_that.progress,_that.status,_that.recurrence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String metricType,  double targetValue,  String unit,  DateTime startDate,  DateTime targetDate,  double currentValue,  double progress,  String status,  String recurrence)?  $default,) {final _that = this;
switch (_that) {
case _HealthGoal() when $default != null:
return $default(_that.id,_that.metricType,_that.targetValue,_that.unit,_that.startDate,_that.targetDate,_that.currentValue,_that.progress,_that.status,_that.recurrence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthGoal implements HealthGoal {
  const _HealthGoal({required this.id, required this.metricType, required this.targetValue, required this.unit, required this.startDate, required this.targetDate, required this.currentValue, required this.progress, required this.status, required this.recurrence});
  factory _HealthGoal.fromJson(Map<String, dynamic> json) => _$HealthGoalFromJson(json);

@override final  String id;
@override final  String metricType;
@override final  double targetValue;
@override final  String unit;
@override final  DateTime startDate;
@override final  DateTime targetDate;
@override final  double currentValue;
@override final  double progress;
// 0-100%
@override final  String status;
// 'active', 'achieved', 'behind', 'abandoned'
@override final  String recurrence;

/// Create a copy of HealthGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthGoalCopyWith<_HealthGoal> get copyWith => __$HealthGoalCopyWithImpl<_HealthGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthGoalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthGoal&&(identical(other.id, id) || other.id == id)&&(identical(other.metricType, metricType) || other.metricType == metricType)&&(identical(other.targetValue, targetValue) || other.targetValue == targetValue)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,metricType,targetValue,unit,startDate,targetDate,currentValue,progress,status,recurrence);

@override
String toString() {
  return 'HealthGoal(id: $id, metricType: $metricType, targetValue: $targetValue, unit: $unit, startDate: $startDate, targetDate: $targetDate, currentValue: $currentValue, progress: $progress, status: $status, recurrence: $recurrence)';
}


}

/// @nodoc
abstract mixin class _$HealthGoalCopyWith<$Res> implements $HealthGoalCopyWith<$Res> {
  factory _$HealthGoalCopyWith(_HealthGoal value, $Res Function(_HealthGoal) _then) = __$HealthGoalCopyWithImpl;
@override @useResult
$Res call({
 String id, String metricType, double targetValue, String unit, DateTime startDate, DateTime targetDate, double currentValue, double progress, String status, String recurrence
});




}
/// @nodoc
class __$HealthGoalCopyWithImpl<$Res>
    implements _$HealthGoalCopyWith<$Res> {
  __$HealthGoalCopyWithImpl(this._self, this._then);

  final _HealthGoal _self;
  final $Res Function(_HealthGoal) _then;

/// Create a copy of HealthGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? metricType = null,Object? targetValue = null,Object? unit = null,Object? startDate = null,Object? targetDate = null,Object? currentValue = null,Object? progress = null,Object? status = null,Object? recurrence = null,}) {
  return _then(_HealthGoal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,metricType: null == metricType ? _self.metricType : metricType // ignore: cast_nullable_to_non_nullable
as String,targetValue: null == targetValue ? _self.targetValue : targetValue // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as double,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HealthProfile {

 String get id; String get userId; BaselineMetrics get baselineMetrics; List<HealthCondition> get healthConditions; List<Allergy> get allergies; List<RiskFactor> get riskFactors; List<HealthGoal> get healthGoals; DateTime get createdAt; DateTime get lastUpdated;
/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthProfileCopyWith<HealthProfile> get copyWith => _$HealthProfileCopyWithImpl<HealthProfile>(this as HealthProfile, _$identity);

  /// Serializes this HealthProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.baselineMetrics, baselineMetrics) || other.baselineMetrics == baselineMetrics)&&const DeepCollectionEquality().equals(other.healthConditions, healthConditions)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&const DeepCollectionEquality().equals(other.riskFactors, riskFactors)&&const DeepCollectionEquality().equals(other.healthGoals, healthGoals)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,baselineMetrics,const DeepCollectionEquality().hash(healthConditions),const DeepCollectionEquality().hash(allergies),const DeepCollectionEquality().hash(riskFactors),const DeepCollectionEquality().hash(healthGoals),createdAt,lastUpdated);

@override
String toString() {
  return 'HealthProfile(id: $id, userId: $userId, baselineMetrics: $baselineMetrics, healthConditions: $healthConditions, allergies: $allergies, riskFactors: $riskFactors, healthGoals: $healthGoals, createdAt: $createdAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $HealthProfileCopyWith<$Res>  {
  factory $HealthProfileCopyWith(HealthProfile value, $Res Function(HealthProfile) _then) = _$HealthProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, BaselineMetrics baselineMetrics, List<HealthCondition> healthConditions, List<Allergy> allergies, List<RiskFactor> riskFactors, List<HealthGoal> healthGoals, DateTime createdAt, DateTime lastUpdated
});


$BaselineMetricsCopyWith<$Res> get baselineMetrics;

}
/// @nodoc
class _$HealthProfileCopyWithImpl<$Res>
    implements $HealthProfileCopyWith<$Res> {
  _$HealthProfileCopyWithImpl(this._self, this._then);

  final HealthProfile _self;
  final $Res Function(HealthProfile) _then;

/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? baselineMetrics = null,Object? healthConditions = null,Object? allergies = null,Object? riskFactors = null,Object? healthGoals = null,Object? createdAt = null,Object? lastUpdated = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,baselineMetrics: null == baselineMetrics ? _self.baselineMetrics : baselineMetrics // ignore: cast_nullable_to_non_nullable
as BaselineMetrics,healthConditions: null == healthConditions ? _self.healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<HealthCondition>,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<Allergy>,riskFactors: null == riskFactors ? _self.riskFactors : riskFactors // ignore: cast_nullable_to_non_nullable
as List<RiskFactor>,healthGoals: null == healthGoals ? _self.healthGoals : healthGoals // ignore: cast_nullable_to_non_nullable
as List<HealthGoal>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaselineMetricsCopyWith<$Res> get baselineMetrics {
  
  return $BaselineMetricsCopyWith<$Res>(_self.baselineMetrics, (value) {
    return _then(_self.copyWith(baselineMetrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthProfile].
extension HealthProfilePatterns on HealthProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthProfile value)  $default,){
final _that = this;
switch (_that) {
case _HealthProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthProfile value)?  $default,){
final _that = this;
switch (_that) {
case _HealthProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  BaselineMetrics baselineMetrics,  List<HealthCondition> healthConditions,  List<Allergy> allergies,  List<RiskFactor> riskFactors,  List<HealthGoal> healthGoals,  DateTime createdAt,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthProfile() when $default != null:
return $default(_that.id,_that.userId,_that.baselineMetrics,_that.healthConditions,_that.allergies,_that.riskFactors,_that.healthGoals,_that.createdAt,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  BaselineMetrics baselineMetrics,  List<HealthCondition> healthConditions,  List<Allergy> allergies,  List<RiskFactor> riskFactors,  List<HealthGoal> healthGoals,  DateTime createdAt,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _HealthProfile():
return $default(_that.id,_that.userId,_that.baselineMetrics,_that.healthConditions,_that.allergies,_that.riskFactors,_that.healthGoals,_that.createdAt,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  BaselineMetrics baselineMetrics,  List<HealthCondition> healthConditions,  List<Allergy> allergies,  List<RiskFactor> riskFactors,  List<HealthGoal> healthGoals,  DateTime createdAt,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _HealthProfile() when $default != null:
return $default(_that.id,_that.userId,_that.baselineMetrics,_that.healthConditions,_that.allergies,_that.riskFactors,_that.healthGoals,_that.createdAt,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthProfile implements HealthProfile {
  const _HealthProfile({required this.id, required this.userId, required this.baselineMetrics, final  List<HealthCondition> healthConditions = const [], final  List<Allergy> allergies = const [], final  List<RiskFactor> riskFactors = const [], final  List<HealthGoal> healthGoals = const [], required this.createdAt, required this.lastUpdated}): _healthConditions = healthConditions,_allergies = allergies,_riskFactors = riskFactors,_healthGoals = healthGoals;
  factory _HealthProfile.fromJson(Map<String, dynamic> json) => _$HealthProfileFromJson(json);

@override final  String id;
@override final  String userId;
@override final  BaselineMetrics baselineMetrics;
 final  List<HealthCondition> _healthConditions;
@override@JsonKey() List<HealthCondition> get healthConditions {
  if (_healthConditions is EqualUnmodifiableListView) return _healthConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_healthConditions);
}

 final  List<Allergy> _allergies;
@override@JsonKey() List<Allergy> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<RiskFactor> _riskFactors;
@override@JsonKey() List<RiskFactor> get riskFactors {
  if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_riskFactors);
}

 final  List<HealthGoal> _healthGoals;
@override@JsonKey() List<HealthGoal> get healthGoals {
  if (_healthGoals is EqualUnmodifiableListView) return _healthGoals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_healthGoals);
}

@override final  DateTime createdAt;
@override final  DateTime lastUpdated;

/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthProfileCopyWith<_HealthProfile> get copyWith => __$HealthProfileCopyWithImpl<_HealthProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.baselineMetrics, baselineMetrics) || other.baselineMetrics == baselineMetrics)&&const DeepCollectionEquality().equals(other._healthConditions, _healthConditions)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&const DeepCollectionEquality().equals(other._riskFactors, _riskFactors)&&const DeepCollectionEquality().equals(other._healthGoals, _healthGoals)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,baselineMetrics,const DeepCollectionEquality().hash(_healthConditions),const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_riskFactors),const DeepCollectionEquality().hash(_healthGoals),createdAt,lastUpdated);

@override
String toString() {
  return 'HealthProfile(id: $id, userId: $userId, baselineMetrics: $baselineMetrics, healthConditions: $healthConditions, allergies: $allergies, riskFactors: $riskFactors, healthGoals: $healthGoals, createdAt: $createdAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$HealthProfileCopyWith<$Res> implements $HealthProfileCopyWith<$Res> {
  factory _$HealthProfileCopyWith(_HealthProfile value, $Res Function(_HealthProfile) _then) = __$HealthProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, BaselineMetrics baselineMetrics, List<HealthCondition> healthConditions, List<Allergy> allergies, List<RiskFactor> riskFactors, List<HealthGoal> healthGoals, DateTime createdAt, DateTime lastUpdated
});


@override $BaselineMetricsCopyWith<$Res> get baselineMetrics;

}
/// @nodoc
class __$HealthProfileCopyWithImpl<$Res>
    implements _$HealthProfileCopyWith<$Res> {
  __$HealthProfileCopyWithImpl(this._self, this._then);

  final _HealthProfile _self;
  final $Res Function(_HealthProfile) _then;

/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? baselineMetrics = null,Object? healthConditions = null,Object? allergies = null,Object? riskFactors = null,Object? healthGoals = null,Object? createdAt = null,Object? lastUpdated = null,}) {
  return _then(_HealthProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,baselineMetrics: null == baselineMetrics ? _self.baselineMetrics : baselineMetrics // ignore: cast_nullable_to_non_nullable
as BaselineMetrics,healthConditions: null == healthConditions ? _self._healthConditions : healthConditions // ignore: cast_nullable_to_non_nullable
as List<HealthCondition>,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<Allergy>,riskFactors: null == riskFactors ? _self._riskFactors : riskFactors // ignore: cast_nullable_to_non_nullable
as List<RiskFactor>,healthGoals: null == healthGoals ? _self._healthGoals : healthGoals // ignore: cast_nullable_to_non_nullable
as List<HealthGoal>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of HealthProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaselineMetricsCopyWith<$Res> get baselineMetrics {
  
  return $BaselineMetricsCopyWith<$Res>(_self.baselineMetrics, (value) {
    return _then(_self.copyWith(baselineMetrics: value));
  });
}
}

// dart format on
