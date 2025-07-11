// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationTemplate {

 String get id; String get name; NotificationType get type; NotificationChannel get channel; String get titleTemplate; String get messageTemplate; Map<String, dynamic>? get defaultContext; bool get isActive; String? get description; List<String>? get requiredVariables; Map<String, String>? get variableDescriptions; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of NotificationTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTemplateCopyWith<NotificationTemplate> get copyWith => _$NotificationTemplateCopyWithImpl<NotificationTemplate>(this as NotificationTemplate, _$identity);

  /// Serializes this NotificationTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other.defaultContext, defaultContext)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.requiredVariables, requiredVariables)&&const DeepCollectionEquality().equals(other.variableDescriptions, variableDescriptions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,channel,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(defaultContext),isActive,description,const DeepCollectionEquality().hash(requiredVariables),const DeepCollectionEquality().hash(variableDescriptions),createdAt,updatedAt);

@override
String toString() {
  return 'NotificationTemplate(id: $id, name: $name, type: $type, channel: $channel, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, isActive: $isActive, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationTemplateCopyWith<$Res>  {
  factory $NotificationTemplateCopyWith(NotificationTemplate value, $Res Function(NotificationTemplate) _then) = _$NotificationTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, NotificationType type, NotificationChannel channel, String titleTemplate, String messageTemplate, Map<String, dynamic>? defaultContext, bool isActive, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$NotificationTemplateCopyWithImpl<$Res>
    implements $NotificationTemplateCopyWith<$Res> {
  _$NotificationTemplateCopyWithImpl(this._self, this._then);

  final NotificationTemplate _self;
  final $Res Function(NotificationTemplate) _then;

/// Create a copy of NotificationTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? channel = null,Object? titleTemplate = null,Object? messageTemplate = null,Object? defaultContext = freezed,Object? isActive = null,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,titleTemplate: null == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String,messageTemplate: null == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultContext: freezed == defaultContext ? _self.defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self.requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self.variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationTemplate].
extension NotificationTemplatePatterns on NotificationTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationTemplate value)  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  bool isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTemplate() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  bool isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplate():
return $default(_that.id,_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  bool isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplate() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTemplate implements NotificationTemplate {
  const _NotificationTemplate({required this.id, required this.name, required this.type, required this.channel, required this.titleTemplate, required this.messageTemplate, final  Map<String, dynamic>? defaultContext, this.isActive = true, this.description, final  List<String>? requiredVariables, final  Map<String, String>? variableDescriptions, required this.createdAt, this.updatedAt}): _defaultContext = defaultContext,_requiredVariables = requiredVariables,_variableDescriptions = variableDescriptions;
  factory _NotificationTemplate.fromJson(Map<String, dynamic> json) => _$NotificationTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  NotificationType type;
@override final  NotificationChannel channel;
@override final  String titleTemplate;
@override final  String messageTemplate;
 final  Map<String, dynamic>? _defaultContext;
@override Map<String, dynamic>? get defaultContext {
  final value = _defaultContext;
  if (value == null) return null;
  if (_defaultContext is EqualUnmodifiableMapView) return _defaultContext;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool isActive;
@override final  String? description;
 final  List<String>? _requiredVariables;
@override List<String>? get requiredVariables {
  final value = _requiredVariables;
  if (value == null) return null;
  if (_requiredVariables is EqualUnmodifiableListView) return _requiredVariables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, String>? _variableDescriptions;
@override Map<String, String>? get variableDescriptions {
  final value = _variableDescriptions;
  if (value == null) return null;
  if (_variableDescriptions is EqualUnmodifiableMapView) return _variableDescriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of NotificationTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationTemplateCopyWith<_NotificationTemplate> get copyWith => __$NotificationTemplateCopyWithImpl<_NotificationTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other._defaultContext, _defaultContext)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._requiredVariables, _requiredVariables)&&const DeepCollectionEquality().equals(other._variableDescriptions, _variableDescriptions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,channel,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(_defaultContext),isActive,description,const DeepCollectionEquality().hash(_requiredVariables),const DeepCollectionEquality().hash(_variableDescriptions),createdAt,updatedAt);

@override
String toString() {
  return 'NotificationTemplate(id: $id, name: $name, type: $type, channel: $channel, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, isActive: $isActive, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationTemplateCopyWith<$Res> implements $NotificationTemplateCopyWith<$Res> {
  factory _$NotificationTemplateCopyWith(_NotificationTemplate value, $Res Function(_NotificationTemplate) _then) = __$NotificationTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, NotificationType type, NotificationChannel channel, String titleTemplate, String messageTemplate, Map<String, dynamic>? defaultContext, bool isActive, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$NotificationTemplateCopyWithImpl<$Res>
    implements _$NotificationTemplateCopyWith<$Res> {
  __$NotificationTemplateCopyWithImpl(this._self, this._then);

  final _NotificationTemplate _self;
  final $Res Function(_NotificationTemplate) _then;

/// Create a copy of NotificationTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? channel = null,Object? titleTemplate = null,Object? messageTemplate = null,Object? defaultContext = freezed,Object? isActive = null,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_NotificationTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,titleTemplate: null == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String,messageTemplate: null == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultContext: freezed == defaultContext ? _self._defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self._requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self._variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TemplateVariable {

 String get name; String get type;// string, number, date, boolean
 String get description; bool get required; String? get defaultValue; List<String>? get allowedValues; String? get format;
/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateVariableCopyWith<TemplateVariable> get copyWith => _$TemplateVariableCopyWithImpl<TemplateVariable>(this as TemplateVariable, _$identity);

  /// Serializes this TemplateVariable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateVariable&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&const DeepCollectionEquality().equals(other.allowedValues, allowedValues)&&(identical(other.format, format) || other.format == format));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,description,required,defaultValue,const DeepCollectionEquality().hash(allowedValues),format);

@override
String toString() {
  return 'TemplateVariable(name: $name, type: $type, description: $description, required: $required, defaultValue: $defaultValue, allowedValues: $allowedValues, format: $format)';
}


}

/// @nodoc
abstract mixin class $TemplateVariableCopyWith<$Res>  {
  factory $TemplateVariableCopyWith(TemplateVariable value, $Res Function(TemplateVariable) _then) = _$TemplateVariableCopyWithImpl;
@useResult
$Res call({
 String name, String type, String description, bool required, String? defaultValue, List<String>? allowedValues, String? format
});




}
/// @nodoc
class _$TemplateVariableCopyWithImpl<$Res>
    implements $TemplateVariableCopyWith<$Res> {
  _$TemplateVariableCopyWithImpl(this._self, this._then);

  final TemplateVariable _self;
  final $Res Function(TemplateVariable) _then;

/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? description = null,Object? required = null,Object? defaultValue = freezed,Object? allowedValues = freezed,Object? format = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,allowedValues: freezed == allowedValues ? _self.allowedValues : allowedValues // ignore: cast_nullable_to_non_nullable
as List<String>?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateVariable].
extension TemplateVariablePatterns on TemplateVariable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateVariable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateVariable value)  $default,){
final _that = this;
switch (_that) {
case _TemplateVariable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateVariable value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  String description,  bool required,  String? defaultValue,  List<String>? allowedValues,  String? format)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
return $default(_that.name,_that.type,_that.description,_that.required,_that.defaultValue,_that.allowedValues,_that.format);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  String description,  bool required,  String? defaultValue,  List<String>? allowedValues,  String? format)  $default,) {final _that = this;
switch (_that) {
case _TemplateVariable():
return $default(_that.name,_that.type,_that.description,_that.required,_that.defaultValue,_that.allowedValues,_that.format);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  String description,  bool required,  String? defaultValue,  List<String>? allowedValues,  String? format)?  $default,) {final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
return $default(_that.name,_that.type,_that.description,_that.required,_that.defaultValue,_that.allowedValues,_that.format);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateVariable implements TemplateVariable {
  const _TemplateVariable({required this.name, required this.type, required this.description, this.required = true, this.defaultValue, final  List<String>? allowedValues, this.format}): _allowedValues = allowedValues;
  factory _TemplateVariable.fromJson(Map<String, dynamic> json) => _$TemplateVariableFromJson(json);

@override final  String name;
@override final  String type;
// string, number, date, boolean
@override final  String description;
@override@JsonKey() final  bool required;
@override final  String? defaultValue;
 final  List<String>? _allowedValues;
@override List<String>? get allowedValues {
  final value = _allowedValues;
  if (value == null) return null;
  if (_allowedValues is EqualUnmodifiableListView) return _allowedValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? format;

/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateVariableCopyWith<_TemplateVariable> get copyWith => __$TemplateVariableCopyWithImpl<_TemplateVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateVariableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateVariable&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&const DeepCollectionEquality().equals(other._allowedValues, _allowedValues)&&(identical(other.format, format) || other.format == format));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,description,required,defaultValue,const DeepCollectionEquality().hash(_allowedValues),format);

@override
String toString() {
  return 'TemplateVariable(name: $name, type: $type, description: $description, required: $required, defaultValue: $defaultValue, allowedValues: $allowedValues, format: $format)';
}


}

/// @nodoc
abstract mixin class _$TemplateVariableCopyWith<$Res> implements $TemplateVariableCopyWith<$Res> {
  factory _$TemplateVariableCopyWith(_TemplateVariable value, $Res Function(_TemplateVariable) _then) = __$TemplateVariableCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, String description, bool required, String? defaultValue, List<String>? allowedValues, String? format
});




}
/// @nodoc
class __$TemplateVariableCopyWithImpl<$Res>
    implements _$TemplateVariableCopyWith<$Res> {
  __$TemplateVariableCopyWithImpl(this._self, this._then);

  final _TemplateVariable _self;
  final $Res Function(_TemplateVariable) _then;

/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? description = null,Object? required = null,Object? defaultValue = freezed,Object? allowedValues = freezed,Object? format = freezed,}) {
  return _then(_TemplateVariable(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,allowedValues: freezed == allowedValues ? _self._allowedValues : allowedValues // ignore: cast_nullable_to_non_nullable
as List<String>?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
