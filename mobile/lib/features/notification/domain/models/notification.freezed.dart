// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notification {

 String get id; String get userId; String get title; String get message; NotificationType get type; NotificationPriority get priority; NotificationChannel get channel; NotificationStatus get status; DateTime get createdAt; DateTime? get scheduledFor; DateTime? get deliveredAt; DateTime? get readAt; DateTime? get expiresAt; Map<String, dynamic>? get context; DateTime? get updatedAt;
/// Create a copy of Notification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationCopyWith<Notification> get copyWith => _$NotificationCopyWithImpl<Notification>(this as Notification, _$identity);

  /// Serializes this Notification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Notification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.context, context)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,type,priority,channel,status,createdAt,scheduledFor,deliveredAt,readAt,expiresAt,const DeepCollectionEquality().hash(context),updatedAt);

@override
String toString() {
  return 'Notification(id: $id, userId: $userId, title: $title, message: $message, type: $type, priority: $priority, channel: $channel, status: $status, createdAt: $createdAt, scheduledFor: $scheduledFor, deliveredAt: $deliveredAt, readAt: $readAt, expiresAt: $expiresAt, context: $context, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationCopyWith<$Res>  {
  factory $NotificationCopyWith(Notification value, $Res Function(Notification) _then) = _$NotificationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, String message, NotificationType type, NotificationPriority priority, NotificationChannel channel, NotificationStatus status, DateTime createdAt, DateTime? scheduledFor, DateTime? deliveredAt, DateTime? readAt, DateTime? expiresAt, Map<String, dynamic>? context, DateTime? updatedAt
});




}
/// @nodoc
class _$NotificationCopyWithImpl<$Res>
    implements $NotificationCopyWith<$Res> {
  _$NotificationCopyWithImpl(this._self, this._then);

  final Notification _self;
  final $Res Function(Notification) _then;

/// Create a copy of Notification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? type = null,Object? priority = null,Object? channel = null,Object? status = null,Object? createdAt = null,Object? scheduledFor = freezed,Object? deliveredAt = freezed,Object? readAt = freezed,Object? expiresAt = freezed,Object? context = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Notification].
extension NotificationPatterns on Notification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Notification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Notification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Notification value)  $default,){
final _that = this;
switch (_that) {
case _Notification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Notification value)?  $default,){
final _that = this;
switch (_that) {
case _Notification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  NotificationStatus status,  DateTime createdAt,  DateTime? scheduledFor,  DateTime? deliveredAt,  DateTime? readAt,  DateTime? expiresAt,  Map<String, dynamic>? context,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Notification() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.status,_that.createdAt,_that.scheduledFor,_that.deliveredAt,_that.readAt,_that.expiresAt,_that.context,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  NotificationStatus status,  DateTime createdAt,  DateTime? scheduledFor,  DateTime? deliveredAt,  DateTime? readAt,  DateTime? expiresAt,  Map<String, dynamic>? context,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Notification():
return $default(_that.id,_that.userId,_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.status,_that.createdAt,_that.scheduledFor,_that.deliveredAt,_that.readAt,_that.expiresAt,_that.context,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  String message,  NotificationType type,  NotificationPriority priority,  NotificationChannel channel,  NotificationStatus status,  DateTime createdAt,  DateTime? scheduledFor,  DateTime? deliveredAt,  DateTime? readAt,  DateTime? expiresAt,  Map<String, dynamic>? context,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Notification() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.message,_that.type,_that.priority,_that.channel,_that.status,_that.createdAt,_that.scheduledFor,_that.deliveredAt,_that.readAt,_that.expiresAt,_that.context,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Notification implements Notification {
  const _Notification({required this.id, required this.userId, required this.title, required this.message, required this.type, this.priority = NotificationPriority.normal, this.channel = NotificationChannel.inApp, this.status = NotificationStatus.pending, required this.createdAt, this.scheduledFor, this.deliveredAt, this.readAt, this.expiresAt, final  Map<String, dynamic>? context, this.updatedAt}): _context = context;
  factory _Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override final  String message;
@override final  NotificationType type;
@override@JsonKey() final  NotificationPriority priority;
@override@JsonKey() final  NotificationChannel channel;
@override@JsonKey() final  NotificationStatus status;
@override final  DateTime createdAt;
@override final  DateTime? scheduledFor;
@override final  DateTime? deliveredAt;
@override final  DateTime? readAt;
@override final  DateTime? expiresAt;
 final  Map<String, dynamic>? _context;
@override Map<String, dynamic>? get context {
  final value = _context;
  if (value == null) return null;
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? updatedAt;

/// Create a copy of Notification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationCopyWith<_Notification> get copyWith => __$NotificationCopyWithImpl<_Notification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Notification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other._context, _context)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,message,type,priority,channel,status,createdAt,scheduledFor,deliveredAt,readAt,expiresAt,const DeepCollectionEquality().hash(_context),updatedAt);

@override
String toString() {
  return 'Notification(id: $id, userId: $userId, title: $title, message: $message, type: $type, priority: $priority, channel: $channel, status: $status, createdAt: $createdAt, scheduledFor: $scheduledFor, deliveredAt: $deliveredAt, readAt: $readAt, expiresAt: $expiresAt, context: $context, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationCopyWith<$Res> implements $NotificationCopyWith<$Res> {
  factory _$NotificationCopyWith(_Notification value, $Res Function(_Notification) _then) = __$NotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, String message, NotificationType type, NotificationPriority priority, NotificationChannel channel, NotificationStatus status, DateTime createdAt, DateTime? scheduledFor, DateTime? deliveredAt, DateTime? readAt, DateTime? expiresAt, Map<String, dynamic>? context, DateTime? updatedAt
});




}
/// @nodoc
class __$NotificationCopyWithImpl<$Res>
    implements _$NotificationCopyWith<$Res> {
  __$NotificationCopyWithImpl(this._self, this._then);

  final _Notification _self;
  final $Res Function(_Notification) _then;

/// Create a copy of Notification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? message = null,Object? type = null,Object? priority = null,Object? channel = null,Object? status = null,Object? createdAt = null,Object? scheduledFor = freezed,Object? deliveredAt = freezed,Object? readAt = freezed,Object? expiresAt = freezed,Object? context = freezed,Object? updatedAt = freezed,}) {
  return _then(_Notification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as NotificationPriority,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NotificationStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,context: freezed == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NotificationInteraction {

 String get id; String get notificationId; InteractionType get interactionType; Map<String, dynamic>? get interactionData; DateTime get createdAt;
/// Create a copy of NotificationInteraction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationInteractionCopyWith<NotificationInteraction> get copyWith => _$NotificationInteractionCopyWithImpl<NotificationInteraction>(this as NotificationInteraction, _$identity);

  /// Serializes this NotificationInteraction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationInteraction&&(identical(other.id, id) || other.id == id)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.interactionType, interactionType) || other.interactionType == interactionType)&&const DeepCollectionEquality().equals(other.interactionData, interactionData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,notificationId,interactionType,const DeepCollectionEquality().hash(interactionData),createdAt);

@override
String toString() {
  return 'NotificationInteraction(id: $id, notificationId: $notificationId, interactionType: $interactionType, interactionData: $interactionData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationInteractionCopyWith<$Res>  {
  factory $NotificationInteractionCopyWith(NotificationInteraction value, $Res Function(NotificationInteraction) _then) = _$NotificationInteractionCopyWithImpl;
@useResult
$Res call({
 String id, String notificationId, InteractionType interactionType, Map<String, dynamic>? interactionData, DateTime createdAt
});




}
/// @nodoc
class _$NotificationInteractionCopyWithImpl<$Res>
    implements $NotificationInteractionCopyWith<$Res> {
  _$NotificationInteractionCopyWithImpl(this._self, this._then);

  final NotificationInteraction _self;
  final $Res Function(NotificationInteraction) _then;

/// Create a copy of NotificationInteraction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? notificationId = null,Object? interactionType = null,Object? interactionData = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,interactionType: null == interactionType ? _self.interactionType : interactionType // ignore: cast_nullable_to_non_nullable
as InteractionType,interactionData: freezed == interactionData ? _self.interactionData : interactionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationInteraction].
extension NotificationInteractionPatterns on NotificationInteraction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationInteraction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationInteraction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationInteraction value)  $default,){
final _that = this;
switch (_that) {
case _NotificationInteraction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationInteraction value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationInteraction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String notificationId,  InteractionType interactionType,  Map<String, dynamic>? interactionData,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationInteraction() when $default != null:
return $default(_that.id,_that.notificationId,_that.interactionType,_that.interactionData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String notificationId,  InteractionType interactionType,  Map<String, dynamic>? interactionData,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationInteraction():
return $default(_that.id,_that.notificationId,_that.interactionType,_that.interactionData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String notificationId,  InteractionType interactionType,  Map<String, dynamic>? interactionData,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationInteraction() when $default != null:
return $default(_that.id,_that.notificationId,_that.interactionType,_that.interactionData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationInteraction implements NotificationInteraction {
  const _NotificationInteraction({required this.id, required this.notificationId, required this.interactionType, final  Map<String, dynamic>? interactionData, required this.createdAt}): _interactionData = interactionData;
  factory _NotificationInteraction.fromJson(Map<String, dynamic> json) => _$NotificationInteractionFromJson(json);

@override final  String id;
@override final  String notificationId;
@override final  InteractionType interactionType;
 final  Map<String, dynamic>? _interactionData;
@override Map<String, dynamic>? get interactionData {
  final value = _interactionData;
  if (value == null) return null;
  if (_interactionData is EqualUnmodifiableMapView) return _interactionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;

/// Create a copy of NotificationInteraction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationInteractionCopyWith<_NotificationInteraction> get copyWith => __$NotificationInteractionCopyWithImpl<_NotificationInteraction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationInteractionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationInteraction&&(identical(other.id, id) || other.id == id)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.interactionType, interactionType) || other.interactionType == interactionType)&&const DeepCollectionEquality().equals(other._interactionData, _interactionData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,notificationId,interactionType,const DeepCollectionEquality().hash(_interactionData),createdAt);

@override
String toString() {
  return 'NotificationInteraction(id: $id, notificationId: $notificationId, interactionType: $interactionType, interactionData: $interactionData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationInteractionCopyWith<$Res> implements $NotificationInteractionCopyWith<$Res> {
  factory _$NotificationInteractionCopyWith(_NotificationInteraction value, $Res Function(_NotificationInteraction) _then) = __$NotificationInteractionCopyWithImpl;
@override @useResult
$Res call({
 String id, String notificationId, InteractionType interactionType, Map<String, dynamic>? interactionData, DateTime createdAt
});




}
/// @nodoc
class __$NotificationInteractionCopyWithImpl<$Res>
    implements _$NotificationInteractionCopyWith<$Res> {
  __$NotificationInteractionCopyWithImpl(this._self, this._then);

  final _NotificationInteraction _self;
  final $Res Function(_NotificationInteraction) _then;

/// Create a copy of NotificationInteraction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? notificationId = null,Object? interactionType = null,Object? interactionData = freezed,Object? createdAt = null,}) {
  return _then(_NotificationInteraction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as String,interactionType: null == interactionType ? _self.interactionType : interactionType // ignore: cast_nullable_to_non_nullable
as InteractionType,interactionData: freezed == interactionData ? _self._interactionData : interactionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$NotificationSummary {

 int get total; int get unread; Map<String, int> get byType; Map<String, int> get byPriority;
/// Create a copy of NotificationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSummaryCopyWith<NotificationSummary> get copyWith => _$NotificationSummaryCopyWithImpl<NotificationSummary>(this as NotificationSummary, _$identity);

  /// Serializes this NotificationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSummary&&(identical(other.total, total) || other.total == total)&&(identical(other.unread, unread) || other.unread == unread)&&const DeepCollectionEquality().equals(other.byType, byType)&&const DeepCollectionEquality().equals(other.byPriority, byPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,unread,const DeepCollectionEquality().hash(byType),const DeepCollectionEquality().hash(byPriority));

@override
String toString() {
  return 'NotificationSummary(total: $total, unread: $unread, byType: $byType, byPriority: $byPriority)';
}


}

/// @nodoc
abstract mixin class $NotificationSummaryCopyWith<$Res>  {
  factory $NotificationSummaryCopyWith(NotificationSummary value, $Res Function(NotificationSummary) _then) = _$NotificationSummaryCopyWithImpl;
@useResult
$Res call({
 int total, int unread, Map<String, int> byType, Map<String, int> byPriority
});




}
/// @nodoc
class _$NotificationSummaryCopyWithImpl<$Res>
    implements $NotificationSummaryCopyWith<$Res> {
  _$NotificationSummaryCopyWithImpl(this._self, this._then);

  final NotificationSummary _self;
  final $Res Function(NotificationSummary) _then;

/// Create a copy of NotificationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? unread = null,Object? byType = null,Object? byPriority = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as Map<String, int>,byPriority: null == byPriority ? _self.byPriority : byPriority // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSummary].
extension NotificationSummaryPatterns on NotificationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSummary value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int unread,  Map<String, int> byType,  Map<String, int> byPriority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSummary() when $default != null:
return $default(_that.total,_that.unread,_that.byType,_that.byPriority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int unread,  Map<String, int> byType,  Map<String, int> byPriority)  $default,) {final _that = this;
switch (_that) {
case _NotificationSummary():
return $default(_that.total,_that.unread,_that.byType,_that.byPriority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int unread,  Map<String, int> byType,  Map<String, int> byPriority)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSummary() when $default != null:
return $default(_that.total,_that.unread,_that.byType,_that.byPriority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSummary implements NotificationSummary {
  const _NotificationSummary({required this.total, required this.unread, required final  Map<String, int> byType, required final  Map<String, int> byPriority}): _byType = byType,_byPriority = byPriority;
  factory _NotificationSummary.fromJson(Map<String, dynamic> json) => _$NotificationSummaryFromJson(json);

@override final  int total;
@override final  int unread;
 final  Map<String, int> _byType;
@override Map<String, int> get byType {
  if (_byType is EqualUnmodifiableMapView) return _byType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byType);
}

 final  Map<String, int> _byPriority;
@override Map<String, int> get byPriority {
  if (_byPriority is EqualUnmodifiableMapView) return _byPriority;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byPriority);
}


/// Create a copy of NotificationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSummaryCopyWith<_NotificationSummary> get copyWith => __$NotificationSummaryCopyWithImpl<_NotificationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSummary&&(identical(other.total, total) || other.total == total)&&(identical(other.unread, unread) || other.unread == unread)&&const DeepCollectionEquality().equals(other._byType, _byType)&&const DeepCollectionEquality().equals(other._byPriority, _byPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,unread,const DeepCollectionEquality().hash(_byType),const DeepCollectionEquality().hash(_byPriority));

@override
String toString() {
  return 'NotificationSummary(total: $total, unread: $unread, byType: $byType, byPriority: $byPriority)';
}


}

/// @nodoc
abstract mixin class _$NotificationSummaryCopyWith<$Res> implements $NotificationSummaryCopyWith<$Res> {
  factory _$NotificationSummaryCopyWith(_NotificationSummary value, $Res Function(_NotificationSummary) _then) = __$NotificationSummaryCopyWithImpl;
@override @useResult
$Res call({
 int total, int unread, Map<String, int> byType, Map<String, int> byPriority
});




}
/// @nodoc
class __$NotificationSummaryCopyWithImpl<$Res>
    implements _$NotificationSummaryCopyWith<$Res> {
  __$NotificationSummaryCopyWithImpl(this._self, this._then);

  final _NotificationSummary _self;
  final $Res Function(_NotificationSummary) _then;

/// Create a copy of NotificationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? unread = null,Object? byType = null,Object? byPriority = null,}) {
  return _then(_NotificationSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,byType: null == byType ? _self._byType : byType // ignore: cast_nullable_to_non_nullable
as Map<String, int>,byPriority: null == byPriority ? _self._byPriority : byPriority // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
