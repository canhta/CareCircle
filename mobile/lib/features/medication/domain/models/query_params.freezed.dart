// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrescriptionQueryParams {

 bool? get isVerified; DateTime? get startDate; DateTime? get endDate; int? get limit; int? get offset;
/// Create a copy of PrescriptionQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionQueryParamsCopyWith<PrescriptionQueryParams> get copyWith => _$PrescriptionQueryParamsCopyWithImpl<PrescriptionQueryParams>(this as PrescriptionQueryParams, _$identity);

  /// Serializes this PrescriptionQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionQueryParams&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isVerified,startDate,endDate,limit,offset);

@override
String toString() {
  return 'PrescriptionQueryParams(isVerified: $isVerified, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $PrescriptionQueryParamsCopyWith<$Res>  {
  factory $PrescriptionQueryParamsCopyWith(PrescriptionQueryParams value, $Res Function(PrescriptionQueryParams) _then) = _$PrescriptionQueryParamsCopyWithImpl;
@useResult
$Res call({
 bool? isVerified, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class _$PrescriptionQueryParamsCopyWithImpl<$Res>
    implements $PrescriptionQueryParamsCopyWith<$Res> {
  _$PrescriptionQueryParamsCopyWithImpl(this._self, this._then);

  final PrescriptionQueryParams _self;
  final $Res Function(PrescriptionQueryParams) _then;

/// Create a copy of PrescriptionQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isVerified = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionQueryParams].
extension PrescriptionQueryParamsPatterns on PrescriptionQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isVerified,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionQueryParams() when $default != null:
return $default(_that.isVerified,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isVerified,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionQueryParams():
return $default(_that.isVerified,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isVerified,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionQueryParams() when $default != null:
return $default(_that.isVerified,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionQueryParams implements PrescriptionQueryParams {
  const _PrescriptionQueryParams({this.isVerified, this.startDate, this.endDate, this.limit, this.offset});
  factory _PrescriptionQueryParams.fromJson(Map<String, dynamic> json) => _$PrescriptionQueryParamsFromJson(json);

@override final  bool? isVerified;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of PrescriptionQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionQueryParamsCopyWith<_PrescriptionQueryParams> get copyWith => __$PrescriptionQueryParamsCopyWithImpl<_PrescriptionQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionQueryParams&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isVerified,startDate,endDate,limit,offset);

@override
String toString() {
  return 'PrescriptionQueryParams(isVerified: $isVerified, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionQueryParamsCopyWith<$Res> implements $PrescriptionQueryParamsCopyWith<$Res> {
  factory _$PrescriptionQueryParamsCopyWith(_PrescriptionQueryParams value, $Res Function(_PrescriptionQueryParams) _then) = __$PrescriptionQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 bool? isVerified, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class __$PrescriptionQueryParamsCopyWithImpl<$Res>
    implements _$PrescriptionQueryParamsCopyWith<$Res> {
  __$PrescriptionQueryParamsCopyWithImpl(this._self, this._then);

  final _PrescriptionQueryParams _self;
  final $Res Function(_PrescriptionQueryParams) _then;

/// Create a copy of PrescriptionQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isVerified = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_PrescriptionQueryParams(
isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ScheduleQueryParams {

 String? get medicationId; bool? get isActive; DateTime? get startDate; DateTime? get endDate; int? get limit; int? get offset;
/// Create a copy of ScheduleQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleQueryParamsCopyWith<ScheduleQueryParams> get copyWith => _$ScheduleQueryParamsCopyWithImpl<ScheduleQueryParams>(this as ScheduleQueryParams, _$identity);

  /// Serializes this ScheduleQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,isActive,startDate,endDate,limit,offset);

@override
String toString() {
  return 'ScheduleQueryParams(medicationId: $medicationId, isActive: $isActive, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $ScheduleQueryParamsCopyWith<$Res>  {
  factory $ScheduleQueryParamsCopyWith(ScheduleQueryParams value, $Res Function(ScheduleQueryParams) _then) = _$ScheduleQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? medicationId, bool? isActive, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class _$ScheduleQueryParamsCopyWithImpl<$Res>
    implements $ScheduleQueryParamsCopyWith<$Res> {
  _$ScheduleQueryParamsCopyWithImpl(this._self, this._then);

  final ScheduleQueryParams _self;
  final $Res Function(ScheduleQueryParams) _then;

/// Create a copy of ScheduleQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = freezed,Object? isActive = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleQueryParams].
extension ScheduleQueryParamsPatterns on ScheduleQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? medicationId,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleQueryParams() when $default != null:
return $default(_that.medicationId,_that.isActive,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? medicationId,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _ScheduleQueryParams():
return $default(_that.medicationId,_that.isActive,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? medicationId,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleQueryParams() when $default != null:
return $default(_that.medicationId,_that.isActive,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleQueryParams implements ScheduleQueryParams {
  const _ScheduleQueryParams({this.medicationId, this.isActive, this.startDate, this.endDate, this.limit, this.offset});
  factory _ScheduleQueryParams.fromJson(Map<String, dynamic> json) => _$ScheduleQueryParamsFromJson(json);

@override final  String? medicationId;
@override final  bool? isActive;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of ScheduleQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleQueryParamsCopyWith<_ScheduleQueryParams> get copyWith => __$ScheduleQueryParamsCopyWithImpl<_ScheduleQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,isActive,startDate,endDate,limit,offset);

@override
String toString() {
  return 'ScheduleQueryParams(medicationId: $medicationId, isActive: $isActive, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$ScheduleQueryParamsCopyWith<$Res> implements $ScheduleQueryParamsCopyWith<$Res> {
  factory _$ScheduleQueryParamsCopyWith(_ScheduleQueryParams value, $Res Function(_ScheduleQueryParams) _then) = __$ScheduleQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? medicationId, bool? isActive, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class __$ScheduleQueryParamsCopyWithImpl<$Res>
    implements _$ScheduleQueryParamsCopyWith<$Res> {
  __$ScheduleQueryParamsCopyWithImpl(this._self, this._then);

  final _ScheduleQueryParams _self;
  final $Res Function(_ScheduleQueryParams) _then;

/// Create a copy of ScheduleQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = freezed,Object? isActive = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_ScheduleQueryParams(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AdherenceQueryParams {

 String? get medicationId; String? get scheduleId; DoseStatus? get status; DateTime? get startDate; DateTime? get endDate; int? get limit; int? get offset;
/// Create a copy of AdherenceQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceQueryParamsCopyWith<AdherenceQueryParams> get copyWith => _$AdherenceQueryParamsCopyWithImpl<AdherenceQueryParams>(this as AdherenceQueryParams, _$identity);

  /// Serializes this AdherenceQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,status,startDate,endDate,limit,offset);

@override
String toString() {
  return 'AdherenceQueryParams(medicationId: $medicationId, scheduleId: $scheduleId, status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $AdherenceQueryParamsCopyWith<$Res>  {
  factory $AdherenceQueryParamsCopyWith(AdherenceQueryParams value, $Res Function(AdherenceQueryParams) _then) = _$AdherenceQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? medicationId, String? scheduleId, DoseStatus? status, DateTime? startDate, DateTime? endDate, int? limit, int? offset
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
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = freezed,Object? scheduleId = freezed,Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _AdherenceQueryParams():
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? medicationId,  String? scheduleId,  DoseStatus? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceQueryParams() when $default != null:
return $default(_that.medicationId,_that.scheduleId,_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceQueryParams implements AdherenceQueryParams {
  const _AdherenceQueryParams({this.medicationId, this.scheduleId, this.status, this.startDate, this.endDate, this.limit, this.offset});
  factory _AdherenceQueryParams.fromJson(Map<String, dynamic> json) => _$AdherenceQueryParamsFromJson(json);

@override final  String? medicationId;
@override final  String? scheduleId;
@override final  DoseStatus? status;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  int? limit;
@override final  int? offset;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,scheduleId,status,startDate,endDate,limit,offset);

@override
String toString() {
  return 'AdherenceQueryParams(medicationId: $medicationId, scheduleId: $scheduleId, status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$AdherenceQueryParamsCopyWith<$Res> implements $AdherenceQueryParamsCopyWith<$Res> {
  factory _$AdherenceQueryParamsCopyWith(_AdherenceQueryParams value, $Res Function(_AdherenceQueryParams) _then) = __$AdherenceQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? medicationId, String? scheduleId, DoseStatus? status, DateTime? startDate, DateTime? endDate, int? limit, int? offset
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
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = freezed,Object? scheduleId = freezed,Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_AdherenceQueryParams(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DoseStatus?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MedicationQueryParams {

 String? get searchTerm; bool? get isActive; MedicationForm? get form; String? get classification; DateTime? get startDateFrom; DateTime? get startDateTo; DateTime? get endDateFrom; DateTime? get endDateTo; String? get prescriptionId; int get limit; int get offset; String get sortBy; String get sortOrder;
/// Create a copy of MedicationQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationQueryParamsCopyWith<MedicationQueryParams> get copyWith => _$MedicationQueryParamsCopyWithImpl<MedicationQueryParams>(this as MedicationQueryParams, _$identity);

  /// Serializes this MedicationQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationQueryParams&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.form, form) || other.form == form)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.startDateFrom, startDateFrom) || other.startDateFrom == startDateFrom)&&(identical(other.startDateTo, startDateTo) || other.startDateTo == startDateTo)&&(identical(other.endDateFrom, endDateFrom) || other.endDateFrom == endDateFrom)&&(identical(other.endDateTo, endDateTo) || other.endDateTo == endDateTo)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchTerm,isActive,form,classification,startDateFrom,startDateTo,endDateFrom,endDateTo,prescriptionId,limit,offset,sortBy,sortOrder);

@override
String toString() {
  return 'MedicationQueryParams(searchTerm: $searchTerm, isActive: $isActive, form: $form, classification: $classification, startDateFrom: $startDateFrom, startDateTo: $startDateTo, endDateFrom: $endDateFrom, endDateTo: $endDateTo, prescriptionId: $prescriptionId, limit: $limit, offset: $offset, sortBy: $sortBy, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MedicationQueryParamsCopyWith<$Res>  {
  factory $MedicationQueryParamsCopyWith(MedicationQueryParams value, $Res Function(MedicationQueryParams) _then) = _$MedicationQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? searchTerm, bool? isActive, MedicationForm? form, String? classification, DateTime? startDateFrom, DateTime? startDateTo, DateTime? endDateFrom, DateTime? endDateTo, String? prescriptionId, int limit, int offset, String sortBy, String sortOrder
});




}
/// @nodoc
class _$MedicationQueryParamsCopyWithImpl<$Res>
    implements $MedicationQueryParamsCopyWith<$Res> {
  _$MedicationQueryParamsCopyWithImpl(this._self, this._then);

  final MedicationQueryParams _self;
  final $Res Function(MedicationQueryParams) _then;

/// Create a copy of MedicationQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchTerm = freezed,Object? isActive = freezed,Object? form = freezed,Object? classification = freezed,Object? startDateFrom = freezed,Object? startDateTo = freezed,Object? endDateFrom = freezed,Object? endDateTo = freezed,Object? prescriptionId = freezed,Object? limit = null,Object? offset = null,Object? sortBy = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
searchTerm: freezed == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,startDateFrom: freezed == startDateFrom ? _self.startDateFrom : startDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,startDateTo: freezed == startDateTo ? _self.startDateTo : startDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateFrom: freezed == endDateFrom ? _self.endDateFrom : endDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateTo: freezed == endDateTo ? _self.endDateTo : endDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationQueryParams].
extension MedicationQueryParamsPatterns on MedicationQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _MedicationQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? searchTerm,  bool? isActive,  MedicationForm? form,  String? classification,  DateTime? startDateFrom,  DateTime? startDateTo,  DateTime? endDateFrom,  DateTime? endDateTo,  String? prescriptionId,  int limit,  int offset,  String sortBy,  String sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationQueryParams() when $default != null:
return $default(_that.searchTerm,_that.isActive,_that.form,_that.classification,_that.startDateFrom,_that.startDateTo,_that.endDateFrom,_that.endDateTo,_that.prescriptionId,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? searchTerm,  bool? isActive,  MedicationForm? form,  String? classification,  DateTime? startDateFrom,  DateTime? startDateTo,  DateTime? endDateFrom,  DateTime? endDateTo,  String? prescriptionId,  int limit,  int offset,  String sortBy,  String sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MedicationQueryParams():
return $default(_that.searchTerm,_that.isActive,_that.form,_that.classification,_that.startDateFrom,_that.startDateTo,_that.endDateFrom,_that.endDateTo,_that.prescriptionId,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? searchTerm,  bool? isActive,  MedicationForm? form,  String? classification,  DateTime? startDateFrom,  DateTime? startDateTo,  DateTime? endDateFrom,  DateTime? endDateTo,  String? prescriptionId,  int limit,  int offset,  String sortBy,  String sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MedicationQueryParams() when $default != null:
return $default(_that.searchTerm,_that.isActive,_that.form,_that.classification,_that.startDateFrom,_that.startDateTo,_that.endDateFrom,_that.endDateTo,_that.prescriptionId,_that.limit,_that.offset,_that.sortBy,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationQueryParams implements MedicationQueryParams {
  const _MedicationQueryParams({this.searchTerm, this.isActive, this.form, this.classification, this.startDateFrom, this.startDateTo, this.endDateFrom, this.endDateTo, this.prescriptionId, this.limit = 50, this.offset = 0, this.sortBy = 'name', this.sortOrder = 'asc'});
  factory _MedicationQueryParams.fromJson(Map<String, dynamic> json) => _$MedicationQueryParamsFromJson(json);

@override final  String? searchTerm;
@override final  bool? isActive;
@override final  MedicationForm? form;
@override final  String? classification;
@override final  DateTime? startDateFrom;
@override final  DateTime? startDateTo;
@override final  DateTime? endDateFrom;
@override final  DateTime? endDateTo;
@override final  String? prescriptionId;
@override@JsonKey() final  int limit;
@override@JsonKey() final  int offset;
@override@JsonKey() final  String sortBy;
@override@JsonKey() final  String sortOrder;

/// Create a copy of MedicationQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationQueryParamsCopyWith<_MedicationQueryParams> get copyWith => __$MedicationQueryParamsCopyWithImpl<_MedicationQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationQueryParams&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.form, form) || other.form == form)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.startDateFrom, startDateFrom) || other.startDateFrom == startDateFrom)&&(identical(other.startDateTo, startDateTo) || other.startDateTo == startDateTo)&&(identical(other.endDateFrom, endDateFrom) || other.endDateFrom == endDateFrom)&&(identical(other.endDateTo, endDateTo) || other.endDateTo == endDateTo)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchTerm,isActive,form,classification,startDateFrom,startDateTo,endDateFrom,endDateTo,prescriptionId,limit,offset,sortBy,sortOrder);

@override
String toString() {
  return 'MedicationQueryParams(searchTerm: $searchTerm, isActive: $isActive, form: $form, classification: $classification, startDateFrom: $startDateFrom, startDateTo: $startDateTo, endDateFrom: $endDateFrom, endDateTo: $endDateTo, prescriptionId: $prescriptionId, limit: $limit, offset: $offset, sortBy: $sortBy, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MedicationQueryParamsCopyWith<$Res> implements $MedicationQueryParamsCopyWith<$Res> {
  factory _$MedicationQueryParamsCopyWith(_MedicationQueryParams value, $Res Function(_MedicationQueryParams) _then) = __$MedicationQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? searchTerm, bool? isActive, MedicationForm? form, String? classification, DateTime? startDateFrom, DateTime? startDateTo, DateTime? endDateFrom, DateTime? endDateTo, String? prescriptionId, int limit, int offset, String sortBy, String sortOrder
});




}
/// @nodoc
class __$MedicationQueryParamsCopyWithImpl<$Res>
    implements _$MedicationQueryParamsCopyWith<$Res> {
  __$MedicationQueryParamsCopyWithImpl(this._self, this._then);

  final _MedicationQueryParams _self;
  final $Res Function(_MedicationQueryParams) _then;

/// Create a copy of MedicationQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchTerm = freezed,Object? isActive = freezed,Object? form = freezed,Object? classification = freezed,Object? startDateFrom = freezed,Object? startDateTo = freezed,Object? endDateFrom = freezed,Object? endDateTo = freezed,Object? prescriptionId = freezed,Object? limit = null,Object? offset = null,Object? sortBy = null,Object? sortOrder = null,}) {
  return _then(_MedicationQueryParams(
searchTerm: freezed == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,startDateFrom: freezed == startDateFrom ? _self.startDateFrom : startDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,startDateTo: freezed == startDateTo ? _self.startDateTo : startDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateFrom: freezed == endDateFrom ? _self.endDateFrom : endDateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,endDateTo: freezed == endDateTo ? _self.endDateTo : endDateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InteractionQueryParams {

 String? get medicationId; String? get severity; bool? get isActive; int? get limit; int? get offset;
/// Create a copy of InteractionQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionQueryParamsCopyWith<InteractionQueryParams> get copyWith => _$InteractionQueryParamsCopyWithImpl<InteractionQueryParams>(this as InteractionQueryParams, _$identity);

  /// Serializes this InteractionQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,severity,isActive,limit,offset);

@override
String toString() {
  return 'InteractionQueryParams(medicationId: $medicationId, severity: $severity, isActive: $isActive, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $InteractionQueryParamsCopyWith<$Res>  {
  factory $InteractionQueryParamsCopyWith(InteractionQueryParams value, $Res Function(InteractionQueryParams) _then) = _$InteractionQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? medicationId, String? severity, bool? isActive, int? limit, int? offset
});




}
/// @nodoc
class _$InteractionQueryParamsCopyWithImpl<$Res>
    implements $InteractionQueryParamsCopyWith<$Res> {
  _$InteractionQueryParamsCopyWithImpl(this._self, this._then);

  final InteractionQueryParams _self;
  final $Res Function(InteractionQueryParams) _then;

/// Create a copy of InteractionQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = freezed,Object? severity = freezed,Object? isActive = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionQueryParams].
extension InteractionQueryParamsPatterns on InteractionQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _InteractionQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? medicationId,  String? severity,  bool? isActive,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionQueryParams() when $default != null:
return $default(_that.medicationId,_that.severity,_that.isActive,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? medicationId,  String? severity,  bool? isActive,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _InteractionQueryParams():
return $default(_that.medicationId,_that.severity,_that.isActive,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? medicationId,  String? severity,  bool? isActive,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _InteractionQueryParams() when $default != null:
return $default(_that.medicationId,_that.severity,_that.isActive,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionQueryParams implements InteractionQueryParams {
  const _InteractionQueryParams({this.medicationId, this.severity, this.isActive, this.limit, this.offset});
  factory _InteractionQueryParams.fromJson(Map<String, dynamic> json) => _$InteractionQueryParamsFromJson(json);

@override final  String? medicationId;
@override final  String? severity;
@override final  bool? isActive;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of InteractionQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionQueryParamsCopyWith<_InteractionQueryParams> get copyWith => __$InteractionQueryParamsCopyWithImpl<_InteractionQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,severity,isActive,limit,offset);

@override
String toString() {
  return 'InteractionQueryParams(medicationId: $medicationId, severity: $severity, isActive: $isActive, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$InteractionQueryParamsCopyWith<$Res> implements $InteractionQueryParamsCopyWith<$Res> {
  factory _$InteractionQueryParamsCopyWith(_InteractionQueryParams value, $Res Function(_InteractionQueryParams) _then) = __$InteractionQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? medicationId, String? severity, bool? isActive, int? limit, int? offset
});




}
/// @nodoc
class __$InteractionQueryParamsCopyWithImpl<$Res>
    implements _$InteractionQueryParamsCopyWith<$Res> {
  __$InteractionQueryParamsCopyWithImpl(this._self, this._then);

  final _InteractionQueryParams _self;
  final $Res Function(_InteractionQueryParams) _then;

/// Create a copy of InteractionQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = freezed,Object? severity = freezed,Object? isActive = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_InteractionQueryParams(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$InventoryQueryParams {

 String? get medicationId; bool? get isLowStock; bool? get isExpired; DateTime? get expirationBefore; DateTime? get expirationAfter; int? get limit; int? get offset;
/// Create a copy of InventoryQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryQueryParamsCopyWith<InventoryQueryParams> get copyWith => _$InventoryQueryParamsCopyWithImpl<InventoryQueryParams>(this as InventoryQueryParams, _$identity);

  /// Serializes this InventoryQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.expirationBefore, expirationBefore) || other.expirationBefore == expirationBefore)&&(identical(other.expirationAfter, expirationAfter) || other.expirationAfter == expirationAfter)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,isLowStock,isExpired,expirationBefore,expirationAfter,limit,offset);

@override
String toString() {
  return 'InventoryQueryParams(medicationId: $medicationId, isLowStock: $isLowStock, isExpired: $isExpired, expirationBefore: $expirationBefore, expirationAfter: $expirationAfter, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $InventoryQueryParamsCopyWith<$Res>  {
  factory $InventoryQueryParamsCopyWith(InventoryQueryParams value, $Res Function(InventoryQueryParams) _then) = _$InventoryQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? medicationId, bool? isLowStock, bool? isExpired, DateTime? expirationBefore, DateTime? expirationAfter, int? limit, int? offset
});




}
/// @nodoc
class _$InventoryQueryParamsCopyWithImpl<$Res>
    implements $InventoryQueryParamsCopyWith<$Res> {
  _$InventoryQueryParamsCopyWithImpl(this._self, this._then);

  final InventoryQueryParams _self;
  final $Res Function(InventoryQueryParams) _then;

/// Create a copy of InventoryQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = freezed,Object? isLowStock = freezed,Object? isExpired = freezed,Object? expirationBefore = freezed,Object? expirationAfter = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,isLowStock: freezed == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool?,isExpired: freezed == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool?,expirationBefore: freezed == expirationBefore ? _self.expirationBefore : expirationBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,expirationAfter: freezed == expirationAfter ? _self.expirationAfter : expirationAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryQueryParams].
extension InventoryQueryParamsPatterns on InventoryQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _InventoryQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? medicationId,  bool? isLowStock,  bool? isExpired,  DateTime? expirationBefore,  DateTime? expirationAfter,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryQueryParams() when $default != null:
return $default(_that.medicationId,_that.isLowStock,_that.isExpired,_that.expirationBefore,_that.expirationAfter,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? medicationId,  bool? isLowStock,  bool? isExpired,  DateTime? expirationBefore,  DateTime? expirationAfter,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _InventoryQueryParams():
return $default(_that.medicationId,_that.isLowStock,_that.isExpired,_that.expirationBefore,_that.expirationAfter,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? medicationId,  bool? isLowStock,  bool? isExpired,  DateTime? expirationBefore,  DateTime? expirationAfter,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _InventoryQueryParams() when $default != null:
return $default(_that.medicationId,_that.isLowStock,_that.isExpired,_that.expirationBefore,_that.expirationAfter,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryQueryParams implements InventoryQueryParams {
  const _InventoryQueryParams({this.medicationId, this.isLowStock, this.isExpired, this.expirationBefore, this.expirationAfter, this.limit, this.offset});
  factory _InventoryQueryParams.fromJson(Map<String, dynamic> json) => _$InventoryQueryParamsFromJson(json);

@override final  String? medicationId;
@override final  bool? isLowStock;
@override final  bool? isExpired;
@override final  DateTime? expirationBefore;
@override final  DateTime? expirationAfter;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of InventoryQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryQueryParamsCopyWith<_InventoryQueryParams> get copyWith => __$InventoryQueryParamsCopyWithImpl<_InventoryQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryQueryParams&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.isLowStock, isLowStock) || other.isLowStock == isLowStock)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.expirationBefore, expirationBefore) || other.expirationBefore == expirationBefore)&&(identical(other.expirationAfter, expirationAfter) || other.expirationAfter == expirationAfter)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,isLowStock,isExpired,expirationBefore,expirationAfter,limit,offset);

@override
String toString() {
  return 'InventoryQueryParams(medicationId: $medicationId, isLowStock: $isLowStock, isExpired: $isExpired, expirationBefore: $expirationBefore, expirationAfter: $expirationAfter, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$InventoryQueryParamsCopyWith<$Res> implements $InventoryQueryParamsCopyWith<$Res> {
  factory _$InventoryQueryParamsCopyWith(_InventoryQueryParams value, $Res Function(_InventoryQueryParams) _then) = __$InventoryQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? medicationId, bool? isLowStock, bool? isExpired, DateTime? expirationBefore, DateTime? expirationAfter, int? limit, int? offset
});




}
/// @nodoc
class __$InventoryQueryParamsCopyWithImpl<$Res>
    implements _$InventoryQueryParamsCopyWith<$Res> {
  __$InventoryQueryParamsCopyWithImpl(this._self, this._then);

  final _InventoryQueryParams _self;
  final $Res Function(_InventoryQueryParams) _then;

/// Create a copy of InventoryQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = freezed,Object? isLowStock = freezed,Object? isExpired = freezed,Object? expirationBefore = freezed,Object? expirationAfter = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_InventoryQueryParams(
medicationId: freezed == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String?,isLowStock: freezed == isLowStock ? _self.isLowStock : isLowStock // ignore: cast_nullable_to_non_nullable
as bool?,isExpired: freezed == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool?,expirationBefore: freezed == expirationBefore ? _self.expirationBefore : expirationBefore // ignore: cast_nullable_to_non_nullable
as DateTime?,expirationAfter: freezed == expirationAfter ? _self.expirationAfter : expirationAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ProcessingQueryParams {

 String? get status; DateTime? get startDate; DateTime? get endDate; int? get limit; int? get offset;
/// Create a copy of ProcessingQueryParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessingQueryParamsCopyWith<ProcessingQueryParams> get copyWith => _$ProcessingQueryParamsCopyWithImpl<ProcessingQueryParams>(this as ProcessingQueryParams, _$identity);

  /// Serializes this ProcessingQueryParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessingQueryParams&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,startDate,endDate,limit,offset);

@override
String toString() {
  return 'ProcessingQueryParams(status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $ProcessingQueryParamsCopyWith<$Res>  {
  factory $ProcessingQueryParamsCopyWith(ProcessingQueryParams value, $Res Function(ProcessingQueryParams) _then) = _$ProcessingQueryParamsCopyWithImpl;
@useResult
$Res call({
 String? status, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class _$ProcessingQueryParamsCopyWithImpl<$Res>
    implements $ProcessingQueryParamsCopyWith<$Res> {
  _$ProcessingQueryParamsCopyWithImpl(this._self, this._then);

  final ProcessingQueryParams _self;
  final $Res Function(ProcessingQueryParams) _then;

/// Create a copy of ProcessingQueryParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcessingQueryParams].
extension ProcessingQueryParamsPatterns on ProcessingQueryParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcessingQueryParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcessingQueryParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcessingQueryParams value)  $default,){
final _that = this;
switch (_that) {
case _ProcessingQueryParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcessingQueryParams value)?  $default,){
final _that = this;
switch (_that) {
case _ProcessingQueryParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcessingQueryParams() when $default != null:
return $default(_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)  $default,) {final _that = this;
switch (_that) {
case _ProcessingQueryParams():
return $default(_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? status,  DateTime? startDate,  DateTime? endDate,  int? limit,  int? offset)?  $default,) {final _that = this;
switch (_that) {
case _ProcessingQueryParams() when $default != null:
return $default(_that.status,_that.startDate,_that.endDate,_that.limit,_that.offset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcessingQueryParams implements ProcessingQueryParams {
  const _ProcessingQueryParams({this.status, this.startDate, this.endDate, this.limit, this.offset});
  factory _ProcessingQueryParams.fromJson(Map<String, dynamic> json) => _$ProcessingQueryParamsFromJson(json);

@override final  String? status;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  int? limit;
@override final  int? offset;

/// Create a copy of ProcessingQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcessingQueryParamsCopyWith<_ProcessingQueryParams> get copyWith => __$ProcessingQueryParamsCopyWithImpl<_ProcessingQueryParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcessingQueryParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcessingQueryParams&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,startDate,endDate,limit,offset);

@override
String toString() {
  return 'ProcessingQueryParams(status: $status, startDate: $startDate, endDate: $endDate, limit: $limit, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$ProcessingQueryParamsCopyWith<$Res> implements $ProcessingQueryParamsCopyWith<$Res> {
  factory _$ProcessingQueryParamsCopyWith(_ProcessingQueryParams value, $Res Function(_ProcessingQueryParams) _then) = __$ProcessingQueryParamsCopyWithImpl;
@override @useResult
$Res call({
 String? status, DateTime? startDate, DateTime? endDate, int? limit, int? offset
});




}
/// @nodoc
class __$ProcessingQueryParamsCopyWithImpl<$Res>
    implements _$ProcessingQueryParamsCopyWith<$Res> {
  __$ProcessingQueryParamsCopyWithImpl(this._self, this._then);

  final _ProcessingQueryParams _self;
  final $Res Function(_ProcessingQueryParams) _then;

/// Create a copy of ProcessingQueryParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? limit = freezed,Object? offset = freezed,}) {
  return _then(_ProcessingQueryParams(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
