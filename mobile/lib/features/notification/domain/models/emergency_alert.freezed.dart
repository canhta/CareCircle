// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmergencyAlert {

 String get id; String get userId; String get title; String get message; EmergencyAlertType get alertType; EmergencyAlertSeverity get severity; EmergencyAlertStatus get status; DateTime get createdAt; DateTime? get acknowledgedAt; DateTime? get resolvedAt; String? get acknowledgedBy; String? get resolvedBy; Map<String, dynamic>? get metadata; String? get location; List<String>? get attachments; List<EmergencyAlertAction> get actions; List<EmergencyEscalation> get escalations; DateTime? get updatedAt;
/// Create a copy of EmergencyAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertCopyWith<EmergencyAlert> get copyWith => _$EmergencyAlertCopyWithImpl<EmergencyAlert>(this as EmergencyAlert, _$identity);

  /// Serializes this EmergencyAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.acknowledgedBy, acknowledgedBy) || other.acknowledgedBy == acknowledgedBy)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.escalations, escalations)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,alertType,severity,status,createdAt,acknowledgedAt,resolvedAt,acknowledgedBy,resolvedBy,const DeepCollectionEquality().hash(metadata),location,const DeepCollectionEquality().hash(attachments),const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(escalations),updatedAt);

@override
String toString() {
  return 'EmergencyAlert(id: $id, userId: $userId, title: $title, message: $message, alertType: $alertType, severity: $severity, status: $status, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt, resolvedAt: $resolvedAt, acknowledgedBy: $acknowledgedBy, resolvedBy: $resolvedBy, metadata: $metadata, location: $location, attachments: $attachments, actions: $actions, escalations: $escalations, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertCopyWith<$Res>  {
  factory $EmergencyAlertCopyWith(EmergencyAlert value, $Res Function(EmergencyAlert) _then) = _$EmergencyAlertCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String message, EmergencyAlertType alertType, EmergencyAlertSeverity severity, EmergencyAlertStatus status, DateTime createdAt, DateTime? acknowledgedAt, DateTime? resolvedAt, String? acknowledgedBy, String? resolvedBy, Map<String, dynamic>? metadata, String? location, List<String>? attachments, List<EmergencyAlertAction> actions, List<EmergencyEscalation> escalations, DateTime? updatedAt
});




}
/// @nodoc
class _$EmergencyAlertCopyWithImpl<$Res>
    implements $EmergencyAlertCopyWith<$Res> {
  _$EmergencyAlertCopyWithImpl(this._self, this._then);

  final EmergencyAlert _self;
  final $Res Function(EmergencyAlert) _then;

/// Create a copy of EmergencyAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? alertType = null,Object? severity = null,Object? status = null,Object? createdAt = null,Object? acknowledgedAt = freezed,Object? resolvedAt = freezed,Object? acknowledgedBy = freezed,Object? resolvedBy = freezed,Object? metadata = freezed,Object? location = freezed,Object? attachments = freezed,Object? actions = null,Object? escalations = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as EmergencyAlertType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSeverity,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmergencyAlertStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acknowledgedBy: freezed == acknowledgedBy ? _self.acknowledgedBy : acknowledgedBy // ignore: cast_nullable_to_non_nullable
as String?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,attachments: freezed == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<EmergencyAlertAction>,escalations: null == escalations ? _self.escalations : escalations // ignore: cast_nullable_to_non_nullable
as List<EmergencyEscalation>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyAlert].
extension EmergencyAlertPatterns on EmergencyAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlert value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlert value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message,  EmergencyAlertType alertType,  EmergencyAlertSeverity severity,  EmergencyAlertStatus status,  DateTime createdAt,  DateTime? acknowledgedAt,  DateTime? resolvedAt,  String? acknowledgedBy,  String? resolvedBy,  Map<String, dynamic>? metadata,  String? location,  List<String>? attachments,  List<EmergencyAlertAction> actions,  List<EmergencyEscalation> escalations,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlert() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.alertType,_that.severity,_that.status,_that.createdAt,_that.acknowledgedAt,_that.resolvedAt,_that.acknowledgedBy,_that.resolvedBy,_that.metadata,_that.location,_that.attachments,_that.actions,_that.escalations,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message,  EmergencyAlertType alertType,  EmergencyAlertSeverity severity,  EmergencyAlertStatus status,  DateTime createdAt,  DateTime? acknowledgedAt,  DateTime? resolvedAt,  String? acknowledgedBy,  String? resolvedBy,  Map<String, dynamic>? metadata,  String? location,  List<String>? attachments,  List<EmergencyAlertAction> actions,  List<EmergencyEscalation> escalations,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlert():
return $default(_that.id,_that.userId,_that.title,_that.message,_that.alertType,_that.severity,_that.status,_that.createdAt,_that.acknowledgedAt,_that.resolvedAt,_that.acknowledgedBy,_that.resolvedBy,_that.metadata,_that.location,_that.attachments,_that.actions,_that.escalations,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String message,  EmergencyAlertType alertType,  EmergencyAlertSeverity severity,  EmergencyAlertStatus status,  DateTime createdAt,  DateTime? acknowledgedAt,  DateTime? resolvedAt,  String? acknowledgedBy,  String? resolvedBy,  Map<String, dynamic>? metadata,  String? location,  List<String>? attachments,  List<EmergencyAlertAction> actions,  List<EmergencyEscalation> escalations,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlert() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.alertType,_that.severity,_that.status,_that.createdAt,_that.acknowledgedAt,_that.resolvedAt,_that.acknowledgedBy,_that.resolvedBy,_that.metadata,_that.location,_that.attachments,_that.actions,_that.escalations,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlert implements EmergencyAlert {
  const _EmergencyAlert({required this.id, required this.userId, required this.title, required this.message, required this.alertType, required this.severity, this.status = EmergencyAlertStatus.active, required this.createdAt, this.acknowledgedAt, this.resolvedAt, this.acknowledgedBy, this.resolvedBy, final  Map<String, dynamic>? metadata, this.location, final  List<String>? attachments, final  List<EmergencyAlertAction> actions = const [], final  List<EmergencyEscalation> escalations = const [], this.updatedAt}): _metadata = metadata,_attachments = attachments,_actions = actions,_escalations = escalations;
  factory _EmergencyAlert.fromJson(Map<String, dynamic> json) => _$EmergencyAlertFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String message;
@override final  EmergencyAlertType alertType;
@override final  EmergencyAlertSeverity severity;
@override@JsonKey() final  EmergencyAlertStatus status;
@override final  DateTime createdAt;
@override final  DateTime? acknowledgedAt;
@override final  DateTime? resolvedAt;
@override final  String? acknowledgedBy;
@override final  String? resolvedBy;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? location;
 final  List<String>? _attachments;
@override List<String>? get attachments {
  final value = _attachments;
  if (value == null) return null;
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<EmergencyAlertAction> _actions;
@override@JsonKey() List<EmergencyAlertAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

 final  List<EmergencyEscalation> _escalations;
@override@JsonKey() List<EmergencyEscalation> get escalations {
  if (_escalations is EqualUnmodifiableListView) return _escalations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_escalations);
}

@override final  DateTime? updatedAt;

/// Create a copy of EmergencyAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertCopyWith<_EmergencyAlert> get copyWith => __$EmergencyAlertCopyWithImpl<_EmergencyAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.acknowledgedBy, acknowledgedBy) || other.acknowledgedBy == acknowledgedBy)&&(identical(other.resolvedBy, resolvedBy) || other.resolvedBy == resolvedBy)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&const DeepCollectionEquality().equals(other._actions, _actions)&&const DeepCollectionEquality().equals(other._escalations, _escalations)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,alertType,severity,status,createdAt,acknowledgedAt,resolvedAt,acknowledgedBy,resolvedBy,const DeepCollectionEquality().hash(_metadata),location,const DeepCollectionEquality().hash(_attachments),const DeepCollectionEquality().hash(_actions),const DeepCollectionEquality().hash(_escalations),updatedAt);

@override
String toString() {
  return 'EmergencyAlert(id: $id, userId: $userId, title: $title, message: $message, alertType: $alertType, severity: $severity, status: $status, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt, resolvedAt: $resolvedAt, acknowledgedBy: $acknowledgedBy, resolvedBy: $resolvedBy, metadata: $metadata, location: $location, attachments: $attachments, actions: $actions, escalations: $escalations, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertCopyWith<$Res> implements $EmergencyAlertCopyWith<$Res> {
  factory _$EmergencyAlertCopyWith(_EmergencyAlert value, $Res Function(_EmergencyAlert) _then) = __$EmergencyAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String message, EmergencyAlertType alertType, EmergencyAlertSeverity severity, EmergencyAlertStatus status, DateTime createdAt, DateTime? acknowledgedAt, DateTime? resolvedAt, String? acknowledgedBy, String? resolvedBy, Map<String, dynamic>? metadata, String? location, List<String>? attachments, List<EmergencyAlertAction> actions, List<EmergencyEscalation> escalations, DateTime? updatedAt
});




}
/// @nodoc
class __$EmergencyAlertCopyWithImpl<$Res>
    implements _$EmergencyAlertCopyWith<$Res> {
  __$EmergencyAlertCopyWithImpl(this._self, this._then);

  final _EmergencyAlert _self;
  final $Res Function(_EmergencyAlert) _then;

/// Create a copy of EmergencyAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? alertType = null,Object? severity = null,Object? status = null,Object? createdAt = null,Object? acknowledgedAt = freezed,Object? resolvedAt = freezed,Object? acknowledgedBy = freezed,Object? resolvedBy = freezed,Object? metadata = freezed,Object? location = freezed,Object? attachments = freezed,Object? actions = null,Object? escalations = null,Object? updatedAt = freezed,}) {
  return _then(_EmergencyAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as EmergencyAlertType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EmergencyAlertSeverity,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EmergencyAlertStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acknowledgedBy: freezed == acknowledgedBy ? _self.acknowledgedBy : acknowledgedBy // ignore: cast_nullable_to_non_nullable
as String?,resolvedBy: freezed == resolvedBy ? _self.resolvedBy : resolvedBy // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,attachments: freezed == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<String>?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<EmergencyAlertAction>,escalations: null == escalations ? _self._escalations : escalations // ignore: cast_nullable_to_non_nullable
as List<EmergencyEscalation>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$EmergencyAlertAction {

 String get id; String get label; String get actionType;// 'acknowledge', 'resolve', 'escalate', 'call_emergency', 'contact_caregiver'
 String? get phoneNumber; String? get url; Map<String, dynamic>? get parameters; bool get isPrimary; bool get isDestructive;
/// Create a copy of EmergencyAlertAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyAlertActionCopyWith<EmergencyAlertAction> get copyWith => _$EmergencyAlertActionCopyWithImpl<EmergencyAlertAction>(this as EmergencyAlertAction, _$identity);

  /// Serializes this EmergencyAlertAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyAlertAction&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isDestructive, isDestructive) || other.isDestructive == isDestructive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,actionType,phoneNumber,url,const DeepCollectionEquality().hash(parameters),isPrimary,isDestructive);

@override
String toString() {
  return 'EmergencyAlertAction(id: $id, label: $label, actionType: $actionType, phoneNumber: $phoneNumber, url: $url, parameters: $parameters, isPrimary: $isPrimary, isDestructive: $isDestructive)';
}


}

/// @nodoc
abstract mixin class $EmergencyAlertActionCopyWith<$Res>  {
  factory $EmergencyAlertActionCopyWith(EmergencyAlertAction value, $Res Function(EmergencyAlertAction) _then) = _$EmergencyAlertActionCopyWithImpl;
@useResult
$Res call({
 String id, String label, String actionType, String? phoneNumber, String? url, Map<String, dynamic>? parameters, bool isPrimary, bool isDestructive
});




}
/// @nodoc
class _$EmergencyAlertActionCopyWithImpl<$Res>
    implements $EmergencyAlertActionCopyWith<$Res> {
  _$EmergencyAlertActionCopyWithImpl(this._self, this._then);

  final EmergencyAlertAction _self;
  final $Res Function(EmergencyAlertAction) _then;

/// Create a copy of EmergencyAlertAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? actionType = null,Object? phoneNumber = freezed,Object? url = freezed,Object? parameters = freezed,Object? isPrimary = null,Object? isDestructive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,parameters: freezed == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isDestructive: null == isDestructive ? _self.isDestructive : isDestructive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyAlertAction].
extension EmergencyAlertActionPatterns on EmergencyAlertAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyAlertAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyAlertAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyAlertAction value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyAlertAction value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyAlertAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String actionType,  String? phoneNumber,  String? url,  Map<String, dynamic>? parameters,  bool isPrimary,  bool isDestructive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyAlertAction() when $default != null:
return $default(_that.id,_that.label,_that.actionType,_that.phoneNumber,_that.url,_that.parameters,_that.isPrimary,_that.isDestructive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String actionType,  String? phoneNumber,  String? url,  Map<String, dynamic>? parameters,  bool isPrimary,  bool isDestructive)  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertAction():
return $default(_that.id,_that.label,_that.actionType,_that.phoneNumber,_that.url,_that.parameters,_that.isPrimary,_that.isDestructive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String actionType,  String? phoneNumber,  String? url,  Map<String, dynamic>? parameters,  bool isPrimary,  bool isDestructive)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyAlertAction() when $default != null:
return $default(_that.id,_that.label,_that.actionType,_that.phoneNumber,_that.url,_that.parameters,_that.isPrimary,_that.isDestructive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyAlertAction implements EmergencyAlertAction {
  const _EmergencyAlertAction({required this.id, required this.label, required this.actionType, this.phoneNumber, this.url, final  Map<String, dynamic>? parameters, this.isPrimary = false, this.isDestructive = false}): _parameters = parameters;
  factory _EmergencyAlertAction.fromJson(Map<String, dynamic> json) => _$EmergencyAlertActionFromJson(json);

@override final  String id;
@override final  String label;
@override final  String actionType;
// 'acknowledge', 'resolve', 'escalate', 'call_emergency', 'contact_caregiver'
@override final  String? phoneNumber;
@override final  String? url;
 final  Map<String, dynamic>? _parameters;
@override Map<String, dynamic>? get parameters {
  final value = _parameters;
  if (value == null) return null;
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool isPrimary;
@override@JsonKey() final  bool isDestructive;

/// Create a copy of EmergencyAlertAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyAlertActionCopyWith<_EmergencyAlertAction> get copyWith => __$EmergencyAlertActionCopyWithImpl<_EmergencyAlertAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyAlertActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyAlertAction&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.isDestructive, isDestructive) || other.isDestructive == isDestructive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,actionType,phoneNumber,url,const DeepCollectionEquality().hash(_parameters),isPrimary,isDestructive);

@override
String toString() {
  return 'EmergencyAlertAction(id: $id, label: $label, actionType: $actionType, phoneNumber: $phoneNumber, url: $url, parameters: $parameters, isPrimary: $isPrimary, isDestructive: $isDestructive)';
}


}

/// @nodoc
abstract mixin class _$EmergencyAlertActionCopyWith<$Res> implements $EmergencyAlertActionCopyWith<$Res> {
  factory _$EmergencyAlertActionCopyWith(_EmergencyAlertAction value, $Res Function(_EmergencyAlertAction) _then) = __$EmergencyAlertActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String actionType, String? phoneNumber, String? url, Map<String, dynamic>? parameters, bool isPrimary, bool isDestructive
});




}
/// @nodoc
class __$EmergencyAlertActionCopyWithImpl<$Res>
    implements _$EmergencyAlertActionCopyWith<$Res> {
  __$EmergencyAlertActionCopyWithImpl(this._self, this._then);

  final _EmergencyAlertAction _self;
  final $Res Function(_EmergencyAlertAction) _then;

/// Create a copy of EmergencyAlertAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? actionType = null,Object? phoneNumber = freezed,Object? url = freezed,Object? parameters = freezed,Object? isPrimary = null,Object? isDestructive = null,}) {
  return _then(_EmergencyAlertAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,parameters: freezed == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,isDestructive: null == isDestructive ? _self.isDestructive : isDestructive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EmergencyEscalation {

 String get id; String get alertId; String get contactId; String get contactName; String get contactPhone; String? get contactEmail; DateTime get scheduledAt; DateTime? get sentAt; DateTime? get acknowledgedAt; String get status;// 'pending', 'sent', 'acknowledged', 'failed'
 String? get failureReason; int get attemptNumber; int get priority;
/// Create a copy of EmergencyEscalation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyEscalationCopyWith<EmergencyEscalation> get copyWith => _$EmergencyEscalationCopyWithImpl<EmergencyEscalation>(this as EmergencyEscalation, _$identity);

  /// Serializes this EmergencyEscalation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyEscalation&&(identical(other.id, id) || other.id == id)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.attemptNumber, attemptNumber) || other.attemptNumber == attemptNumber)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alertId,contactId,contactName,contactPhone,contactEmail,scheduledAt,sentAt,acknowledgedAt,status,failureReason,attemptNumber,priority);

@override
String toString() {
  return 'EmergencyEscalation(id: $id, alertId: $alertId, contactId: $contactId, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, scheduledAt: $scheduledAt, sentAt: $sentAt, acknowledgedAt: $acknowledgedAt, status: $status, failureReason: $failureReason, attemptNumber: $attemptNumber, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $EmergencyEscalationCopyWith<$Res>  {
  factory $EmergencyEscalationCopyWith(EmergencyEscalation value, $Res Function(EmergencyEscalation) _then) = _$EmergencyEscalationCopyWithImpl;
@useResult
$Res call({
 String id, String alertId, String contactId, String contactName, String contactPhone, String? contactEmail, DateTime scheduledAt, DateTime? sentAt, DateTime? acknowledgedAt, String status, String? failureReason, int attemptNumber, int priority
});




}
/// @nodoc
class _$EmergencyEscalationCopyWithImpl<$Res>
    implements $EmergencyEscalationCopyWith<$Res> {
  _$EmergencyEscalationCopyWithImpl(this._self, this._then);

  final EmergencyEscalation _self;
  final $Res Function(EmergencyEscalation) _then;

/// Create a copy of EmergencyEscalation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? alertId = null,Object? contactId = null,Object? contactName = null,Object? contactPhone = null,Object? contactEmail = freezed,Object? scheduledAt = null,Object? sentAt = freezed,Object? acknowledgedAt = freezed,Object? status = null,Object? failureReason = freezed,Object? attemptNumber = null,Object? priority = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,attemptNumber: null == attemptNumber ? _self.attemptNumber : attemptNumber // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyEscalation].
extension EmergencyEscalationPatterns on EmergencyEscalation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyEscalation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyEscalation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyEscalation value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyEscalation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyEscalation value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyEscalation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String alertId,  String contactId,  String contactName,  String contactPhone,  String? contactEmail,  DateTime scheduledAt,  DateTime? sentAt,  DateTime? acknowledgedAt,  String status,  String? failureReason,  int attemptNumber,  int priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyEscalation() when $default != null:
return $default(_that.id,_that.alertId,_that.contactId,_that.contactName,_that.contactPhone,_that.contactEmail,_that.scheduledAt,_that.sentAt,_that.acknowledgedAt,_that.status,_that.failureReason,_that.attemptNumber,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String alertId,  String contactId,  String contactName,  String contactPhone,  String? contactEmail,  DateTime scheduledAt,  DateTime? sentAt,  DateTime? acknowledgedAt,  String status,  String? failureReason,  int attemptNumber,  int priority)  $default,) {final _that = this;
switch (_that) {
case _EmergencyEscalation():
return $default(_that.id,_that.alertId,_that.contactId,_that.contactName,_that.contactPhone,_that.contactEmail,_that.scheduledAt,_that.sentAt,_that.acknowledgedAt,_that.status,_that.failureReason,_that.attemptNumber,_that.priority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String alertId,  String contactId,  String contactName,  String contactPhone,  String? contactEmail,  DateTime scheduledAt,  DateTime? sentAt,  DateTime? acknowledgedAt,  String status,  String? failureReason,  int attemptNumber,  int priority)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyEscalation() when $default != null:
return $default(_that.id,_that.alertId,_that.contactId,_that.contactName,_that.contactPhone,_that.contactEmail,_that.scheduledAt,_that.sentAt,_that.acknowledgedAt,_that.status,_that.failureReason,_that.attemptNumber,_that.priority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyEscalation implements EmergencyEscalation {
  const _EmergencyEscalation({required this.id, required this.alertId, required this.contactId, required this.contactName, required this.contactPhone, this.contactEmail, required this.scheduledAt, this.sentAt, this.acknowledgedAt, this.status = 'pending', this.failureReason, this.attemptNumber = 1, this.priority = 1});
  factory _EmergencyEscalation.fromJson(Map<String, dynamic> json) => _$EmergencyEscalationFromJson(json);

@override final  String id;
@override final  String alertId;
@override final  String contactId;
@override final  String contactName;
@override final  String contactPhone;
@override final  String? contactEmail;
@override final  DateTime scheduledAt;
@override final  DateTime? sentAt;
@override final  DateTime? acknowledgedAt;
@override@JsonKey() final  String status;
// 'pending', 'sent', 'acknowledged', 'failed'
@override final  String? failureReason;
@override@JsonKey() final  int attemptNumber;
@override@JsonKey() final  int priority;

/// Create a copy of EmergencyEscalation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyEscalationCopyWith<_EmergencyEscalation> get copyWith => __$EmergencyEscalationCopyWithImpl<_EmergencyEscalation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyEscalationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyEscalation&&(identical(other.id, id) || other.id == id)&&(identical(other.alertId, alertId) || other.alertId == alertId)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.contactName, contactName) || other.contactName == contactName)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.attemptNumber, attemptNumber) || other.attemptNumber == attemptNumber)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alertId,contactId,contactName,contactPhone,contactEmail,scheduledAt,sentAt,acknowledgedAt,status,failureReason,attemptNumber,priority);

@override
String toString() {
  return 'EmergencyEscalation(id: $id, alertId: $alertId, contactId: $contactId, contactName: $contactName, contactPhone: $contactPhone, contactEmail: $contactEmail, scheduledAt: $scheduledAt, sentAt: $sentAt, acknowledgedAt: $acknowledgedAt, status: $status, failureReason: $failureReason, attemptNumber: $attemptNumber, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$EmergencyEscalationCopyWith<$Res> implements $EmergencyEscalationCopyWith<$Res> {
  factory _$EmergencyEscalationCopyWith(_EmergencyEscalation value, $Res Function(_EmergencyEscalation) _then) = __$EmergencyEscalationCopyWithImpl;
@override @useResult
$Res call({
 String id, String alertId, String contactId, String contactName, String contactPhone, String? contactEmail, DateTime scheduledAt, DateTime? sentAt, DateTime? acknowledgedAt, String status, String? failureReason, int attemptNumber, int priority
});




}
/// @nodoc
class __$EmergencyEscalationCopyWithImpl<$Res>
    implements _$EmergencyEscalationCopyWith<$Res> {
  __$EmergencyEscalationCopyWithImpl(this._self, this._then);

  final _EmergencyEscalation _self;
  final $Res Function(_EmergencyEscalation) _then;

/// Create a copy of EmergencyEscalation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? alertId = null,Object? contactId = null,Object? contactName = null,Object? contactPhone = null,Object? contactEmail = freezed,Object? scheduledAt = null,Object? sentAt = freezed,Object? acknowledgedAt = freezed,Object? status = null,Object? failureReason = freezed,Object? attemptNumber = null,Object? priority = null,}) {
  return _then(_EmergencyEscalation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertId: null == alertId ? _self.alertId : alertId // ignore: cast_nullable_to_non_nullable
as String,contactId: null == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String,contactName: null == contactName ? _self.contactName : contactName // ignore: cast_nullable_to_non_nullable
as String,contactPhone: null == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,attemptNumber: null == attemptNumber ? _self.attemptNumber : attemptNumber // ignore: cast_nullable_to_non_nullable
as int,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
