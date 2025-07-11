// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationResponse {

 bool get success; String get message; Notification? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationResponseCopyWith<NotificationResponse> get copyWith => _$NotificationResponseCopyWithImpl<NotificationResponse>(this as NotificationResponse, _$identity);

  /// Serializes this NotificationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'NotificationResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $NotificationResponseCopyWith<$Res>  {
  factory $NotificationResponseCopyWith(NotificationResponse value, $Res Function(NotificationResponse) _then) = _$NotificationResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, Notification? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$NotificationCopyWith<$Res>? get data;

}
/// @nodoc
class _$NotificationResponseCopyWithImpl<$Res>
    implements $NotificationResponseCopyWith<$Res> {
  _$NotificationResponseCopyWithImpl(this._self, this._then);

  final NotificationResponse _self;
  final $Res Function(NotificationResponse) _then;

/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Notification?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationResponse].
extension NotificationResponsePatterns on NotificationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  Notification? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  Notification? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _NotificationResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  Notification? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _NotificationResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationResponse implements NotificationResponse {
  const _NotificationResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _NotificationResponse.fromJson(Map<String, dynamic> json) => _$NotificationResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  Notification? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationResponseCopyWith<_NotificationResponse> get copyWith => __$NotificationResponseCopyWithImpl<_NotificationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'NotificationResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$NotificationResponseCopyWith<$Res> implements $NotificationResponseCopyWith<$Res> {
  factory _$NotificationResponseCopyWith(_NotificationResponse value, $Res Function(_NotificationResponse) _then) = __$NotificationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, Notification? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $NotificationCopyWith<$Res>? get data;

}
/// @nodoc
class __$NotificationResponseCopyWithImpl<$Res>
    implements _$NotificationResponseCopyWith<$Res> {
  __$NotificationResponseCopyWithImpl(this._self, this._then);

  final _NotificationResponse _self;
  final $Res Function(_NotificationResponse) _then;

/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_NotificationResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Notification?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NotificationListResponse {

 bool get success; String get message; List<Notification> get data; Map<String, dynamic>? get errors; DateTime? get timestamp; PaginationMeta? get pagination;
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListResponseCopyWith<NotificationListResponse> get copyWith => _$NotificationListResponseCopyWithImpl<NotificationListResponse>(this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(errors),timestamp,pagination);

@override
String toString() {
  return 'NotificationListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res>  {
  factory $NotificationListResponseCopyWith(NotificationListResponse value, $Res Function(NotificationListResponse) _then) = _$NotificationListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, List<Notification> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


$PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._self, this._then);

  final NotificationListResponse _self;
  final $Res Function(NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Notification>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationListResponse].
extension NotificationListResponsePatterns on NotificationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  List<Notification> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  List<Notification> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  List<Notification> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse({required this.success, required this.message, final  List<Notification> data = const [], final  Map<String, dynamic>? errors, this.timestamp, this.pagination}): _data = data,_errors = errors;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);

@override final  bool success;
@override final  String message;
 final  List<Notification> _data;
@override@JsonKey() List<Notification> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;
@override final  PaginationMeta? pagination;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListResponseCopyWith<_NotificationListResponse> get copyWith => __$NotificationListResponseCopyWithImpl<_NotificationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_errors),timestamp,pagination);

@override
String toString() {
  return 'NotificationListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res> implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value, $Res Function(_NotificationListResponse) _then) = __$NotificationListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, List<Notification> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


@override $PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$NotificationListResponseCopyWithImpl<$Res>
    implements _$NotificationListResponseCopyWith<$Res> {
  __$NotificationListResponseCopyWithImpl(this._self, this._then);

  final _NotificationListResponse _self;
  final $Res Function(_NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_NotificationListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Notification>,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$NotificationSummaryResponse {

 bool get success; String get message; NotificationSummary? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSummaryResponseCopyWith<NotificationSummaryResponse> get copyWith => _$NotificationSummaryResponseCopyWithImpl<NotificationSummaryResponse>(this as NotificationSummaryResponse, _$identity);

  /// Serializes this NotificationSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSummaryResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'NotificationSummaryResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $NotificationSummaryResponseCopyWith<$Res>  {
  factory $NotificationSummaryResponseCopyWith(NotificationSummaryResponse value, $Res Function(NotificationSummaryResponse) _then) = _$NotificationSummaryResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, NotificationSummary? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$NotificationSummaryCopyWith<$Res>? get data;

}
/// @nodoc
class _$NotificationSummaryResponseCopyWithImpl<$Res>
    implements $NotificationSummaryResponseCopyWith<$Res> {
  _$NotificationSummaryResponseCopyWithImpl(this._self, this._then);

  final NotificationSummaryResponse _self;
  final $Res Function(NotificationSummaryResponse) _then;

/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationSummary?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationSummaryCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationSummaryCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationSummaryResponse].
extension NotificationSummaryResponsePatterns on NotificationSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationSummary? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSummaryResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationSummary? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _NotificationSummaryResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  NotificationSummary? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSummaryResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSummaryResponse implements NotificationSummaryResponse {
  const _NotificationSummaryResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _NotificationSummaryResponse.fromJson(Map<String, dynamic> json) => _$NotificationSummaryResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  NotificationSummary? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSummaryResponseCopyWith<_NotificationSummaryResponse> get copyWith => __$NotificationSummaryResponseCopyWithImpl<_NotificationSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSummaryResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'NotificationSummaryResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$NotificationSummaryResponseCopyWith<$Res> implements $NotificationSummaryResponseCopyWith<$Res> {
  factory _$NotificationSummaryResponseCopyWith(_NotificationSummaryResponse value, $Res Function(_NotificationSummaryResponse) _then) = __$NotificationSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, NotificationSummary? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $NotificationSummaryCopyWith<$Res>? get data;

}
/// @nodoc
class __$NotificationSummaryResponseCopyWithImpl<$Res>
    implements _$NotificationSummaryResponseCopyWith<$Res> {
  __$NotificationSummaryResponseCopyWithImpl(this._self, this._then);

  final _NotificationSummaryResponse _self;
  final $Res Function(_NotificationSummaryResponse) _then;

/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_NotificationSummaryResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationSummary?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationSummaryCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationSummaryCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NotificationPreferencesResponse {

 bool get success; String get message; NotificationPreferences? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesResponseCopyWith<NotificationPreferencesResponse> get copyWith => _$NotificationPreferencesResponseCopyWithImpl<NotificationPreferencesResponse>(this as NotificationPreferencesResponse, _$identity);

  /// Serializes this NotificationPreferencesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferencesResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'NotificationPreferencesResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesResponseCopyWith<$Res>  {
  factory $NotificationPreferencesResponseCopyWith(NotificationPreferencesResponse value, $Res Function(NotificationPreferencesResponse) _then) = _$NotificationPreferencesResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, NotificationPreferences? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$NotificationPreferencesCopyWith<$Res>? get data;

}
/// @nodoc
class _$NotificationPreferencesResponseCopyWithImpl<$Res>
    implements $NotificationPreferencesResponseCopyWith<$Res> {
  _$NotificationPreferencesResponseCopyWithImpl(this._self, this._then);

  final NotificationPreferencesResponse _self;
  final $Res Function(NotificationPreferencesResponse) _then;

/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationPreferences?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationPreferencesCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationPreferencesResponse].
extension NotificationPreferencesResponsePatterns on NotificationPreferencesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferencesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferencesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferencesResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferencesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferencesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationPreferences? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferencesResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationPreferences? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  NotificationPreferences? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferencesResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferencesResponse implements NotificationPreferencesResponse {
  const _NotificationPreferencesResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _NotificationPreferencesResponse.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  NotificationPreferences? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesResponseCopyWith<_NotificationPreferencesResponse> get copyWith => __$NotificationPreferencesResponseCopyWithImpl<_NotificationPreferencesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferencesResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'NotificationPreferencesResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesResponseCopyWith<$Res> implements $NotificationPreferencesResponseCopyWith<$Res> {
  factory _$NotificationPreferencesResponseCopyWith(_NotificationPreferencesResponse value, $Res Function(_NotificationPreferencesResponse) _then) = __$NotificationPreferencesResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, NotificationPreferences? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $NotificationPreferencesCopyWith<$Res>? get data;

}
/// @nodoc
class __$NotificationPreferencesResponseCopyWithImpl<$Res>
    implements _$NotificationPreferencesResponseCopyWith<$Res> {
  __$NotificationPreferencesResponseCopyWithImpl(this._self, this._then);

  final _NotificationPreferencesResponse _self;
  final $Res Function(_NotificationPreferencesResponse) _then;

/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_NotificationPreferencesResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationPreferences?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationPreferencesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationPreferencesCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$EmergencyAlertResponse {

 bool get success; String get message; EmergencyAlert? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertResponseCopyWith<EmergencyAlertResponse> get copyWith => _$EmergencyAlertResponseCopyWithImpl<EmergencyAlertResponse>(this as EmergencyAlertResponse, _$identity);

  /// Serializes this EmergencyAlertResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlertResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'EmergencyAlertResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertResponseCopyWith<$Res>  {
  factory $EmergencyAlertResponseCopyWith(EmergencyAlertResponse value, $Res Function(EmergencyAlertResponse) _then) = _$EmergencyAlertResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, EmergencyAlert? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$EmergencyAlertCopyWith<$Res>? get data;

}
/// @nodoc
class _$EmergencyAlertResponseCopyWithImpl<$Res>
    implements $EmergencyAlertResponseCopyWith<$Res> {
  _$EmergencyAlertResponseCopyWithImpl(this._self, this._then);

  final EmergencyAlertResponse _self;
  final $Res Function(EmergencyAlertResponse) _then;

/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EmergencyAlert?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $EmergencyAlertCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmergencyAlertResponse].
extension EmergencyAlertResponsePatterns on EmergencyAlertResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlertResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlertResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlertResponse value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlertResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  EmergencyAlert? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlertResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  EmergencyAlert? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  EmergencyAlert? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlertResponse implements EmergencyAlertResponse {
  const _EmergencyAlertResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _EmergencyAlertResponse.fromJson(Map<String, dynamic> json) => _$EmergencyAlertResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  EmergencyAlert? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertResponseCopyWith<_EmergencyAlertResponse> get copyWith => __$EmergencyAlertResponseCopyWithImpl<_EmergencyAlertResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlertResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'EmergencyAlertResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertResponseCopyWith<$Res> implements $EmergencyAlertResponseCopyWith<$Res> {
  factory _$EmergencyAlertResponseCopyWith(_EmergencyAlertResponse value, $Res Function(_EmergencyAlertResponse) _then) = __$EmergencyAlertResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, EmergencyAlert? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $EmergencyAlertCopyWith<$Res>? get data;

}
/// @nodoc
class __$EmergencyAlertResponseCopyWithImpl<$Res>
    implements _$EmergencyAlertResponseCopyWith<$Res> {
  __$EmergencyAlertResponseCopyWithImpl(this._self, this._then);

  final _EmergencyAlertResponse _self;
  final $Res Function(_EmergencyAlertResponse) _then;

/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_EmergencyAlertResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EmergencyAlert?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of EmergencyAlertResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyAlertCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $EmergencyAlertCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$EmergencyAlertListResponse {

 bool get success; String get message; List<EmergencyAlert> get data; Map<String, dynamic>? get errors; DateTime? get timestamp; PaginationMeta? get pagination;
/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertListResponseCopyWith<EmergencyAlertListResponse> get copyWith => _$EmergencyAlertListResponseCopyWithImpl<EmergencyAlertListResponse>(this as EmergencyAlertListResponse, _$identity);

  /// Serializes this EmergencyAlertListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlertListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(errors),timestamp,pagination);

@override
String toString() {
  return 'EmergencyAlertListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertListResponseCopyWith<$Res>  {
  factory $EmergencyAlertListResponseCopyWith(EmergencyAlertListResponse value, $Res Function(EmergencyAlertListResponse) _then) = _$EmergencyAlertListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, List<EmergencyAlert> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


$PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$EmergencyAlertListResponseCopyWithImpl<$Res>
    implements $EmergencyAlertListResponseCopyWith<$Res> {
  _$EmergencyAlertListResponseCopyWithImpl(this._self, this._then);

  final EmergencyAlertListResponse _self;
  final $Res Function(EmergencyAlertListResponse) _then;

/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<EmergencyAlert>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}
/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmergencyAlertListResponse].
extension EmergencyAlertListResponsePatterns on EmergencyAlertListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlertListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlertListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlertListResponse value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlertListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  List<EmergencyAlert> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlertListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  List<EmergencyAlert> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertListResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  List<EmergencyAlert> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlertListResponse implements EmergencyAlertListResponse {
  const _EmergencyAlertListResponse({required this.success, required this.message, final  List<EmergencyAlert> data = const [], final  Map<String, dynamic>? errors, this.timestamp, this.pagination}): _data = data,_errors = errors;
  factory _EmergencyAlertListResponse.fromJson(Map<String, dynamic> json) => _$EmergencyAlertListResponseFromJson(json);

@override final  bool success;
@override final  String message;
 final  List<EmergencyAlert> _data;
@override@JsonKey() List<EmergencyAlert> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;
@override final  PaginationMeta? pagination;

/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertListResponseCopyWith<_EmergencyAlertListResponse> get copyWith => __$EmergencyAlertListResponseCopyWithImpl<_EmergencyAlertListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlertListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_errors),timestamp,pagination);

@override
String toString() {
  return 'EmergencyAlertListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertListResponseCopyWith<$Res> implements $EmergencyAlertListResponseCopyWith<$Res> {
  factory _$EmergencyAlertListResponseCopyWith(_EmergencyAlertListResponse value, $Res Function(_EmergencyAlertListResponse) _then) = __$EmergencyAlertListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, List<EmergencyAlert> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


@override $PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$EmergencyAlertListResponseCopyWithImpl<$Res>
    implements _$EmergencyAlertListResponseCopyWith<$Res> {
  __$EmergencyAlertListResponseCopyWithImpl(this._self, this._then);

  final _EmergencyAlertListResponse _self;
  final $Res Function(_EmergencyAlertListResponse) _then;

/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_EmergencyAlertListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<EmergencyAlert>,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}

/// Create a copy of EmergencyAlertListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$EmergencyContactResponse {

 bool get success; String get message; EmergencyContact? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactResponseCopyWith<EmergencyContactResponse> get copyWith => _$EmergencyContactResponseCopyWithImpl<EmergencyContactResponse>(this as EmergencyContactResponse, _$identity);

  /// Serializes this EmergencyContactResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContactResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'EmergencyContactResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactResponseCopyWith<$Res>  {
  factory $EmergencyContactResponseCopyWith(EmergencyContactResponse value, $Res Function(EmergencyContactResponse) _then) = _$EmergencyContactResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, EmergencyContact? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$EmergencyContactCopyWith<$Res>? get data;

}
/// @nodoc
class _$EmergencyContactResponseCopyWithImpl<$Res>
    implements $EmergencyContactResponseCopyWith<$Res> {
  _$EmergencyContactResponseCopyWithImpl(this._self, this._then);

  final EmergencyContactResponse _self;
  final $Res Function(EmergencyContactResponse) _then;

/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EmergencyContact?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyContactCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $EmergencyContactCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmergencyContactResponse].
extension EmergencyContactResponsePatterns on EmergencyContactResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContactResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContactResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContactResponse value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContactResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  EmergencyContact? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContactResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  EmergencyContact? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  EmergencyContact? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContactResponse implements EmergencyContactResponse {
  const _EmergencyContactResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _EmergencyContactResponse.fromJson(Map<String, dynamic> json) => _$EmergencyContactResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  EmergencyContact? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactResponseCopyWith<_EmergencyContactResponse> get copyWith => __$EmergencyContactResponseCopyWithImpl<_EmergencyContactResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContactResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'EmergencyContactResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactResponseCopyWith<$Res> implements $EmergencyContactResponseCopyWith<$Res> {
  factory _$EmergencyContactResponseCopyWith(_EmergencyContactResponse value, $Res Function(_EmergencyContactResponse) _then) = __$EmergencyContactResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, EmergencyContact? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $EmergencyContactCopyWith<$Res>? get data;

}
/// @nodoc
class __$EmergencyContactResponseCopyWithImpl<$Res>
    implements _$EmergencyContactResponseCopyWith<$Res> {
  __$EmergencyContactResponseCopyWithImpl(this._self, this._then);

  final _EmergencyContactResponse _self;
  final $Res Function(_EmergencyContactResponse) _then;

/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_EmergencyContactResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EmergencyContact?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of EmergencyContactResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EmergencyContactCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $EmergencyContactCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$EmergencyContactListResponse {

 bool get success; String get message; List<EmergencyContact> get data; Map<String, dynamic>? get errors; DateTime? get timestamp; PaginationMeta? get pagination;
/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactListResponseCopyWith<EmergencyContactListResponse> get copyWith => _$EmergencyContactListResponseCopyWithImpl<EmergencyContactListResponse>(this as EmergencyContactListResponse, _$identity);

  /// Serializes this EmergencyContactListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContactListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(errors),timestamp,pagination);

@override
String toString() {
  return 'EmergencyContactListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactListResponseCopyWith<$Res>  {
  factory $EmergencyContactListResponseCopyWith(EmergencyContactListResponse value, $Res Function(EmergencyContactListResponse) _then) = _$EmergencyContactListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, List<EmergencyContact> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


$PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$EmergencyContactListResponseCopyWithImpl<$Res>
    implements $EmergencyContactListResponseCopyWith<$Res> {
  _$EmergencyContactListResponseCopyWithImpl(this._self, this._then);

  final EmergencyContactListResponse _self;
  final $Res Function(EmergencyContactListResponse) _then;

/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<EmergencyContact>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}
/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [EmergencyContactListResponse].
extension EmergencyContactListResponsePatterns on EmergencyContactListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContactListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContactListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContactListResponse value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContactListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContactListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  List<EmergencyContact> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContactListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  List<EmergencyContact> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactListResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  List<EmergencyContact> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContactListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContactListResponse implements EmergencyContactListResponse {
  const _EmergencyContactListResponse({required this.success, required this.message, final  List<EmergencyContact> data = const [], final  Map<String, dynamic>? errors, this.timestamp, this.pagination}): _data = data,_errors = errors;
  factory _EmergencyContactListResponse.fromJson(Map<String, dynamic> json) => _$EmergencyContactListResponseFromJson(json);

@override final  bool success;
@override final  String message;
 final  List<EmergencyContact> _data;
@override@JsonKey() List<EmergencyContact> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;
@override final  PaginationMeta? pagination;

/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactListResponseCopyWith<_EmergencyContactListResponse> get copyWith => __$EmergencyContactListResponseCopyWithImpl<_EmergencyContactListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContactListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_errors),timestamp,pagination);

@override
String toString() {
  return 'EmergencyContactListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactListResponseCopyWith<$Res> implements $EmergencyContactListResponseCopyWith<$Res> {
  factory _$EmergencyContactListResponseCopyWith(_EmergencyContactListResponse value, $Res Function(_EmergencyContactListResponse) _then) = __$EmergencyContactListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, List<EmergencyContact> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


@override $PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$EmergencyContactListResponseCopyWithImpl<$Res>
    implements _$EmergencyContactListResponseCopyWith<$Res> {
  __$EmergencyContactListResponseCopyWithImpl(this._self, this._then);

  final _EmergencyContactListResponse _self;
  final $Res Function(_EmergencyContactListResponse) _then;

/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_EmergencyContactListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<EmergencyContact>,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}

/// Create a copy of EmergencyContactListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$NotificationTemplateResponse {

 bool get success; String get message; NotificationTemplate? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTemplateResponseCopyWith<NotificationTemplateResponse> get copyWith => _$NotificationTemplateResponseCopyWithImpl<NotificationTemplateResponse>(this as NotificationTemplateResponse, _$identity);

  /// Serializes this NotificationTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'NotificationTemplateResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $NotificationTemplateResponseCopyWith<$Res>  {
  factory $NotificationTemplateResponseCopyWith(NotificationTemplateResponse value, $Res Function(NotificationTemplateResponse) _then) = _$NotificationTemplateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, NotificationTemplate? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$NotificationTemplateCopyWith<$Res>? get data;

}
/// @nodoc
class _$NotificationTemplateResponseCopyWithImpl<$Res>
    implements $NotificationTemplateResponseCopyWith<$Res> {
  _$NotificationTemplateResponseCopyWithImpl(this._self, this._then);

  final NotificationTemplateResponse _self;
  final $Res Function(NotificationTemplateResponse) _then;

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationTemplate?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTemplateCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationTemplateCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationTemplateResponse].
extension NotificationTemplateResponsePatterns on NotificationTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  NotificationTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  NotificationTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTemplateResponse implements NotificationTemplateResponse {
  const _NotificationTemplateResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _NotificationTemplateResponse.fromJson(Map<String, dynamic> json) => _$NotificationTemplateResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  NotificationTemplate? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationTemplateResponseCopyWith<_NotificationTemplateResponse> get copyWith => __$NotificationTemplateResponseCopyWithImpl<_NotificationTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'NotificationTemplateResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$NotificationTemplateResponseCopyWith<$Res> implements $NotificationTemplateResponseCopyWith<$Res> {
  factory _$NotificationTemplateResponseCopyWith(_NotificationTemplateResponse value, $Res Function(_NotificationTemplateResponse) _then) = __$NotificationTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, NotificationTemplate? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $NotificationTemplateCopyWith<$Res>? get data;

}
/// @nodoc
class __$NotificationTemplateResponseCopyWithImpl<$Res>
    implements _$NotificationTemplateResponseCopyWith<$Res> {
  __$NotificationTemplateResponseCopyWithImpl(this._self, this._then);

  final _NotificationTemplateResponse _self;
  final $Res Function(_NotificationTemplateResponse) _then;

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_NotificationTemplateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationTemplate?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTemplateCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $NotificationTemplateCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NotificationTemplateListResponse {

 bool get success; String get message; List<NotificationTemplate> get data; Map<String, dynamic>? get errors; DateTime? get timestamp; PaginationMeta? get pagination;
/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTemplateListResponseCopyWith<NotificationTemplateListResponse> get copyWith => _$NotificationTemplateListResponseCopyWithImpl<NotificationTemplateListResponse>(this as NotificationTemplateListResponse, _$identity);

  /// Serializes this NotificationTemplateListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTemplateListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(errors),timestamp,pagination);

@override
String toString() {
  return 'NotificationTemplateListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $NotificationTemplateListResponseCopyWith<$Res>  {
  factory $NotificationTemplateListResponseCopyWith(NotificationTemplateListResponse value, $Res Function(NotificationTemplateListResponse) _then) = _$NotificationTemplateListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, List<NotificationTemplate> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


$PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class _$NotificationTemplateListResponseCopyWithImpl<$Res>
    implements $NotificationTemplateListResponseCopyWith<$Res> {
  _$NotificationTemplateListResponseCopyWithImpl(this._self, this._then);

  final NotificationTemplateListResponse _self;
  final $Res Function(NotificationTemplateListResponse) _then;

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<NotificationTemplate>,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}
/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationTemplateListResponse].
extension NotificationTemplateListResponsePatterns on NotificationTemplateListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationTemplateListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationTemplateListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplateListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationTemplateListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  List<NotificationTemplate> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  List<NotificationTemplate> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  List<NotificationTemplate> data,  Map<String, dynamic>? errors,  DateTime? timestamp,  PaginationMeta? pagination)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTemplateListResponse implements NotificationTemplateListResponse {
  const _NotificationTemplateListResponse({required this.success, required this.message, final  List<NotificationTemplate> data = const [], final  Map<String, dynamic>? errors, this.timestamp, this.pagination}): _data = data,_errors = errors;
  factory _NotificationTemplateListResponse.fromJson(Map<String, dynamic> json) => _$NotificationTemplateListResponseFromJson(json);

@override final  bool success;
@override final  String message;
 final  List<NotificationTemplate> _data;
@override@JsonKey() List<NotificationTemplate> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;
@override final  PaginationMeta? pagination;

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationTemplateListResponseCopyWith<_NotificationTemplateListResponse> get copyWith => __$NotificationTemplateListResponseCopyWithImpl<_NotificationTemplateListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationTemplateListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTemplateListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_errors),timestamp,pagination);

@override
String toString() {
  return 'NotificationTemplateListResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$NotificationTemplateListResponseCopyWith<$Res> implements $NotificationTemplateListResponseCopyWith<$Res> {
  factory _$NotificationTemplateListResponseCopyWith(_NotificationTemplateListResponse value, $Res Function(_NotificationTemplateListResponse) _then) = __$NotificationTemplateListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, List<NotificationTemplate> data, Map<String, dynamic>? errors, DateTime? timestamp, PaginationMeta? pagination
});


@override $PaginationMetaCopyWith<$Res>? get pagination;

}
/// @nodoc
class __$NotificationTemplateListResponseCopyWithImpl<$Res>
    implements _$NotificationTemplateListResponseCopyWith<$Res> {
  __$NotificationTemplateListResponseCopyWithImpl(this._self, this._then);

  final _NotificationTemplateListResponse _self;
  final $Res Function(_NotificationTemplateListResponse) _then;

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = null,Object? errors = freezed,Object? timestamp = freezed,Object? pagination = freezed,}) {
  return _then(_NotificationTemplateListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<NotificationTemplate>,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,pagination: freezed == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationMeta?,
  ));
}

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<$Res>? get pagination {
    if (_self.pagination == null) {
    return null;
  }

  return $PaginationMetaCopyWith<$Res>(_self.pagination!, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$RenderedTemplateResponse {

 bool get success; String get message; RenderedTemplate? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedTemplateResponseCopyWith<RenderedTemplateResponse> get copyWith => _$RenderedTemplateResponseCopyWithImpl<RenderedTemplateResponse>(this as RenderedTemplateResponse, _$identity);

  /// Serializes this RenderedTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'RenderedTemplateResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $RenderedTemplateResponseCopyWith<$Res>  {
  factory $RenderedTemplateResponseCopyWith(RenderedTemplateResponse value, $Res Function(RenderedTemplateResponse) _then) = _$RenderedTemplateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, RenderedTemplate? data, Map<String, dynamic>? errors, DateTime? timestamp
});


$RenderedTemplateCopyWith<$Res>? get data;

}
/// @nodoc
class _$RenderedTemplateResponseCopyWithImpl<$Res>
    implements $RenderedTemplateResponseCopyWith<$Res> {
  _$RenderedTemplateResponseCopyWithImpl(this._self, this._then);

  final RenderedTemplateResponse _self;
  final $Res Function(RenderedTemplateResponse) _then;

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RenderedTemplate?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $RenderedTemplateCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [RenderedTemplateResponse].
extension RenderedTemplateResponsePatterns on RenderedTemplateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderedTemplateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderedTemplateResponse value)  $default,){
final _that = this;
switch (_that) {
case _RenderedTemplateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderedTemplateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String message,  RenderedTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String message,  RenderedTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String message,  RenderedTemplate? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedTemplateResponse implements RenderedTemplateResponse {
  const _RenderedTemplateResponse({required this.success, required this.message, this.data, final  Map<String, dynamic>? errors, this.timestamp}): _errors = errors;
  factory _RenderedTemplateResponse.fromJson(Map<String, dynamic> json) => _$RenderedTemplateResponseFromJson(json);

@override final  bool success;
@override final  String message;
@override final  RenderedTemplate? data;
 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderedTemplateResponseCopyWith<_RenderedTemplateResponse> get copyWith => __$RenderedTemplateResponseCopyWithImpl<_RenderedTemplateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderedTemplateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,data,const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'RenderedTemplateResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RenderedTemplateResponseCopyWith<$Res> implements $RenderedTemplateResponseCopyWith<$Res> {
  factory _$RenderedTemplateResponseCopyWith(_RenderedTemplateResponse value, $Res Function(_RenderedTemplateResponse) _then) = __$RenderedTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, RenderedTemplate? data, Map<String, dynamic>? errors, DateTime? timestamp
});


@override $RenderedTemplateCopyWith<$Res>? get data;

}
/// @nodoc
class __$RenderedTemplateResponseCopyWithImpl<$Res>
    implements _$RenderedTemplateResponseCopyWith<$Res> {
  __$RenderedTemplateResponseCopyWithImpl(this._self, this._then);

  final _RenderedTemplateResponse _self;
  final $Res Function(_RenderedTemplateResponse) _then;

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_RenderedTemplateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RenderedTemplate?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $RenderedTemplateCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PaginationMeta {

 int get currentPage; int get totalPages; int get totalItems; int get itemsPerPage; bool? get hasNextPage; bool? get hasPreviousPage;
/// Create a copy of PaginationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationMetaCopyWith<PaginationMeta> get copyWith => _$PaginationMetaCopyWithImpl<PaginationMeta>(this as PaginationMeta, _$identity);

  /// Serializes this PaginationMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationMeta&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.hasPreviousPage, hasPreviousPage) || other.hasPreviousPage == hasPreviousPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,totalPages,totalItems,itemsPerPage,hasNextPage,hasPreviousPage);

@override
String toString() {
  return 'PaginationMeta(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsPerPage: $itemsPerPage, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
}


}

/// @nodoc
abstract mixin class $PaginationMetaCopyWith<$Res>  {
  factory $PaginationMetaCopyWith(PaginationMeta value, $Res Function(PaginationMeta) _then) = _$PaginationMetaCopyWithImpl;
@useResult
$Res call({
 int currentPage, int totalPages, int totalItems, int itemsPerPage, bool? hasNextPage, bool? hasPreviousPage
});




}
/// @nodoc
class _$PaginationMetaCopyWithImpl<$Res>
    implements $PaginationMetaCopyWith<$Res> {
  _$PaginationMetaCopyWithImpl(this._self, this._then);

  final PaginationMeta _self;
  final $Res Function(PaginationMeta) _then;

/// Create a copy of PaginationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? totalPages = null,Object? totalItems = null,Object? itemsPerPage = null,Object? hasNextPage = freezed,Object? hasPreviousPage = freezed,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: freezed == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool?,hasPreviousPage: freezed == hasPreviousPage ? _self.hasPreviousPage : hasPreviousPage // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginationMeta].
extension PaginationMetaPatterns on PaginationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationMeta value)  $default,){
final _that = this;
switch (_that) {
case _PaginationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  int totalItems,  int itemsPerPage,  bool? hasNextPage,  bool? hasPreviousPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationMeta() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.totalItems,_that.itemsPerPage,_that.hasNextPage,_that.hasPreviousPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentPage,  int totalPages,  int totalItems,  int itemsPerPage,  bool? hasNextPage,  bool? hasPreviousPage)  $default,) {final _that = this;
switch (_that) {
case _PaginationMeta():
return $default(_that.currentPage,_that.totalPages,_that.totalItems,_that.itemsPerPage,_that.hasNextPage,_that.hasPreviousPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentPage,  int totalPages,  int totalItems,  int itemsPerPage,  bool? hasNextPage,  bool? hasPreviousPage)?  $default,) {final _that = this;
switch (_that) {
case _PaginationMeta() when $default != null:
return $default(_that.currentPage,_that.totalPages,_that.totalItems,_that.itemsPerPage,_that.hasNextPage,_that.hasPreviousPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginationMeta implements PaginationMeta {
  const _PaginationMeta({required this.currentPage, required this.totalPages, required this.totalItems, required this.itemsPerPage, this.hasNextPage, this.hasPreviousPage});
  factory _PaginationMeta.fromJson(Map<String, dynamic> json) => _$PaginationMetaFromJson(json);

@override final  int currentPage;
@override final  int totalPages;
@override final  int totalItems;
@override final  int itemsPerPage;
@override final  bool? hasNextPage;
@override final  bool? hasPreviousPage;

/// Create a copy of PaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationMetaCopyWith<_PaginationMeta> get copyWith => __$PaginationMetaCopyWithImpl<_PaginationMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginationMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationMeta&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.itemsPerPage, itemsPerPage) || other.itemsPerPage == itemsPerPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.hasPreviousPage, hasPreviousPage) || other.hasPreviousPage == hasPreviousPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,totalPages,totalItems,itemsPerPage,hasNextPage,hasPreviousPage);

@override
String toString() {
  return 'PaginationMeta(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsPerPage: $itemsPerPage, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
}


}

/// @nodoc
abstract mixin class _$PaginationMetaCopyWith<$Res> implements $PaginationMetaCopyWith<$Res> {
  factory _$PaginationMetaCopyWith(_PaginationMeta value, $Res Function(_PaginationMeta) _then) = __$PaginationMetaCopyWithImpl;
@override @useResult
$Res call({
 int currentPage, int totalPages, int totalItems, int itemsPerPage, bool? hasNextPage, bool? hasPreviousPage
});




}
/// @nodoc
class __$PaginationMetaCopyWithImpl<$Res>
    implements _$PaginationMetaCopyWith<$Res> {
  __$PaginationMetaCopyWithImpl(this._self, this._then);

  final _PaginationMeta _self;
  final $Res Function(_PaginationMeta) _then;

/// Create a copy of PaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? totalPages = null,Object? totalItems = null,Object? itemsPerPage = null,Object? hasNextPage = freezed,Object? hasPreviousPage = freezed,}) {
  return _then(_PaginationMeta(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,itemsPerPage: null == itemsPerPage ? _self.itemsPerPage : itemsPerPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: freezed == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool?,hasPreviousPage: freezed == hasPreviousPage ? _self.hasPreviousPage : hasPreviousPage // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$RenderedTemplate {

 String get templateId; String get renderedContent; String get subject; Map<String, dynamic>? get variables; DateTime? get renderedAt;
/// Create a copy of RenderedTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<RenderedTemplate> get copyWith => _$RenderedTemplateCopyWithImpl<RenderedTemplate>(this as RenderedTemplate, _$identity);

  /// Serializes this RenderedTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedTemplate&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.renderedContent, renderedContent) || other.renderedContent == renderedContent)&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.renderedAt, renderedAt) || other.renderedAt == renderedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,renderedContent,subject,const DeepCollectionEquality().hash(variables),renderedAt);

@override
String toString() {
  return 'RenderedTemplate(templateId: $templateId, renderedContent: $renderedContent, subject: $subject, variables: $variables, renderedAt: $renderedAt)';
}


}

/// @nodoc
abstract mixin class $RenderedTemplateCopyWith<$Res>  {
  factory $RenderedTemplateCopyWith(RenderedTemplate value, $Res Function(RenderedTemplate) _then) = _$RenderedTemplateCopyWithImpl;
@useResult
$Res call({
 String templateId, String renderedContent, String subject, Map<String, dynamic>? variables, DateTime? renderedAt
});




}
/// @nodoc
class _$RenderedTemplateCopyWithImpl<$Res>
    implements $RenderedTemplateCopyWith<$Res> {
  _$RenderedTemplateCopyWithImpl(this._self, this._then);

  final RenderedTemplate _self;
  final $Res Function(RenderedTemplate) _then;

/// Create a copy of RenderedTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? renderedContent = null,Object? subject = null,Object? variables = freezed,Object? renderedAt = freezed,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,renderedContent: null == renderedContent ? _self.renderedContent : renderedContent // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,variables: freezed == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,renderedAt: freezed == renderedAt ? _self.renderedAt : renderedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderedTemplate].
extension RenderedTemplatePatterns on RenderedTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderedTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderedTemplate value)  $default,){
final _that = this;
switch (_that) {
case _RenderedTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderedTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateId,  String renderedContent,  String subject,  Map<String, dynamic>? variables,  DateTime? renderedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
return $default(_that.templateId,_that.renderedContent,_that.subject,_that.variables,_that.renderedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateId,  String renderedContent,  String subject,  Map<String, dynamic>? variables,  DateTime? renderedAt)  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplate():
return $default(_that.templateId,_that.renderedContent,_that.subject,_that.variables,_that.renderedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateId,  String renderedContent,  String subject,  Map<String, dynamic>? variables,  DateTime? renderedAt)?  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
return $default(_that.templateId,_that.renderedContent,_that.subject,_that.variables,_that.renderedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedTemplate implements RenderedTemplate {
  const _RenderedTemplate({required this.templateId, required this.renderedContent, required this.subject, final  Map<String, dynamic>? variables, this.renderedAt}): _variables = variables;
  factory _RenderedTemplate.fromJson(Map<String, dynamic> json) => _$RenderedTemplateFromJson(json);

@override final  String templateId;
@override final  String renderedContent;
@override final  String subject;
 final  Map<String, dynamic>? _variables;
@override Map<String, dynamic>? get variables {
  final value = _variables;
  if (value == null) return null;
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? renderedAt;

/// Create a copy of RenderedTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderedTemplateCopyWith<_RenderedTemplate> get copyWith => __$RenderedTemplateCopyWithImpl<_RenderedTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderedTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedTemplate&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.renderedContent, renderedContent) || other.renderedContent == renderedContent)&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.renderedAt, renderedAt) || other.renderedAt == renderedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,renderedContent,subject,const DeepCollectionEquality().hash(_variables),renderedAt);

@override
String toString() {
  return 'RenderedTemplate(templateId: $templateId, renderedContent: $renderedContent, subject: $subject, variables: $variables, renderedAt: $renderedAt)';
}


}

/// @nodoc
abstract mixin class _$RenderedTemplateCopyWith<$Res> implements $RenderedTemplateCopyWith<$Res> {
  factory _$RenderedTemplateCopyWith(_RenderedTemplate value, $Res Function(_RenderedTemplate) _then) = __$RenderedTemplateCopyWithImpl;
@override @useResult
$Res call({
 String templateId, String renderedContent, String subject, Map<String, dynamic>? variables, DateTime? renderedAt
});




}
/// @nodoc
class __$RenderedTemplateCopyWithImpl<$Res>
    implements _$RenderedTemplateCopyWith<$Res> {
  __$RenderedTemplateCopyWithImpl(this._self, this._then);

  final _RenderedTemplate _self;
  final $Res Function(_RenderedTemplate) _then;

/// Create a copy of RenderedTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? renderedContent = null,Object? subject = null,Object? variables = freezed,Object? renderedAt = freezed,}) {
  return _then(_RenderedTemplate(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,renderedContent: null == renderedContent ? _self.renderedContent : renderedContent // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,variables: freezed == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,renderedAt: freezed == renderedAt ? _self.renderedAt : renderedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$GenericResponse {

 bool get success; String? get message; Map<String, dynamic>? get data; Map<String, dynamic>? get errors; DateTime? get timestamp;
/// Create a copy of GenericResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenericResponseCopyWith<GenericResponse> get copyWith => _$GenericResponseCopyWithImpl<GenericResponse>(this as GenericResponse, _$identity);

  /// Serializes this GenericResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenericResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(errors),timestamp);

@override
String toString() {
  return 'GenericResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GenericResponseCopyWith<$Res>  {
  factory $GenericResponseCopyWith(GenericResponse value, $Res Function(GenericResponse) _then) = _$GenericResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String? message, Map<String, dynamic>? data, Map<String, dynamic>? errors, DateTime? timestamp
});




}
/// @nodoc
class _$GenericResponseCopyWithImpl<$Res>
    implements $GenericResponseCopyWith<$Res> {
  _$GenericResponseCopyWithImpl(this._self, this._then);

  final GenericResponse _self;
  final $Res Function(GenericResponse) _then;

/// Create a copy of GenericResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = freezed,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenericResponse].
extension GenericResponsePatterns on GenericResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenericResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenericResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenericResponse value)  $default,){
final _that = this;
switch (_that) {
case _GenericResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenericResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GenericResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String? message,  Map<String, dynamic>? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenericResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String? message,  Map<String, dynamic>? data,  Map<String, dynamic>? errors,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _GenericResponse():
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String? message,  Map<String, dynamic>? data,  Map<String, dynamic>? errors,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GenericResponse() when $default != null:
return $default(_that.success,_that.message,_that.data,_that.errors,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenericResponse implements GenericResponse {
  const _GenericResponse({required this.success, this.message, final  Map<String, dynamic>? data, final  Map<String, dynamic>? errors, this.timestamp}): _data = data,_errors = errors;
  factory _GenericResponse.fromJson(Map<String, dynamic> json) => _$GenericResponseFromJson(json);

@override final  bool success;
@override final  String? message;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _errors;
@override Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? timestamp;

/// Create a copy of GenericResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenericResponseCopyWith<_GenericResponse> get copyWith => __$GenericResponseCopyWithImpl<_GenericResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenericResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenericResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_errors),timestamp);

@override
String toString() {
  return 'GenericResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GenericResponseCopyWith<$Res> implements $GenericResponseCopyWith<$Res> {
  factory _$GenericResponseCopyWith(_GenericResponse value, $Res Function(_GenericResponse) _then) = __$GenericResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, String? message, Map<String, dynamic>? data, Map<String, dynamic>? errors, DateTime? timestamp
});




}
/// @nodoc
class __$GenericResponseCopyWithImpl<$Res>
    implements _$GenericResponseCopyWith<$Res> {
  __$GenericResponseCopyWithImpl(this._self, this._then);

  final _GenericResponse _self;
  final $Res Function(_GenericResponse) _then;

/// Create a copy of GenericResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = freezed,Object? data = freezed,Object? errors = freezed,Object? timestamp = freezed,}) {
  return _then(_GenericResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
