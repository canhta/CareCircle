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


/// @nodoc
mixin _$RenderTemplateRequest {

 String get templateId; Map<String, dynamic> get variables; String? get locale;
/// Create a copy of RenderTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderTemplateRequestCopyWith<RenderTemplateRequest> get copyWith => _$RenderTemplateRequestCopyWithImpl<RenderTemplateRequest>(this as RenderTemplateRequest, _$identity);

  /// Serializes this RenderTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderTemplateRequest&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,const DeepCollectionEquality().hash(variables),locale);

@override
String toString() {
  return 'RenderTemplateRequest(templateId: $templateId, variables: $variables, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $RenderTemplateRequestCopyWith<$Res>  {
  factory $RenderTemplateRequestCopyWith(RenderTemplateRequest value, $Res Function(RenderTemplateRequest) _then) = _$RenderTemplateRequestCopyWithImpl;
@useResult
$Res call({
 String templateId, Map<String, dynamic> variables, String? locale
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
@pragma('vm:prefer-inline') @override $Res call({Object? templateId = null,Object? variables = null,Object? locale = freezed,}) {
  return _then(_self.copyWith(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String templateId,  Map<String, dynamic> variables,  String? locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
return $default(_that.templateId,_that.variables,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String templateId,  Map<String, dynamic> variables,  String? locale)  $default,) {final _that = this;
switch (_that) {
case _RenderTemplateRequest():
return $default(_that.templateId,_that.variables,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String templateId,  Map<String, dynamic> variables,  String? locale)?  $default,) {final _that = this;
switch (_that) {
case _RenderTemplateRequest() when $default != null:
return $default(_that.templateId,_that.variables,_that.locale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderTemplateRequest implements RenderTemplateRequest {
  const _RenderTemplateRequest({required this.templateId, required final  Map<String, dynamic> variables, this.locale}): _variables = variables;
  factory _RenderTemplateRequest.fromJson(Map<String, dynamic> json) => _$RenderTemplateRequestFromJson(json);

@override final  String templateId;
 final  Map<String, dynamic> _variables;
@override Map<String, dynamic> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

@override final  String? locale;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderTemplateRequest&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,templateId,const DeepCollectionEquality().hash(_variables),locale);

@override
String toString() {
  return 'RenderTemplateRequest(templateId: $templateId, variables: $variables, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$RenderTemplateRequestCopyWith<$Res> implements $RenderTemplateRequestCopyWith<$Res> {
  factory _$RenderTemplateRequestCopyWith(_RenderTemplateRequest value, $Res Function(_RenderTemplateRequest) _then) = __$RenderTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 String templateId, Map<String, dynamic> variables, String? locale
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
@override @pragma('vm:prefer-inline') $Res call({Object? templateId = null,Object? variables = null,Object? locale = freezed,}) {
  return _then(_RenderTemplateRequest(
templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RenderedTemplate {

 String get title; String get message; Map<String, dynamic>? get context; List<String>? get errors; List<String>? get warnings;
/// Create a copy of RenderedTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<RenderedTemplate> get copyWith => _$RenderedTemplateCopyWithImpl<RenderedTemplate>(this as RenderedTemplate, _$identity);

  /// Serializes this RenderedTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedTemplate&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.context, context)&&const DeepCollectionEquality().equals(other.errors, errors)&&const DeepCollectionEquality().equals(other.warnings, warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,const DeepCollectionEquality().hash(context),const DeepCollectionEquality().hash(errors),const DeepCollectionEquality().hash(warnings));

@override
String toString() {
  return 'RenderedTemplate(title: $title, message: $message, context: $context, errors: $errors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class $RenderedTemplateCopyWith<$Res>  {
  factory $RenderedTemplateCopyWith(RenderedTemplate value, $Res Function(RenderedTemplate) _then) = _$RenderedTemplateCopyWithImpl;
@useResult
$Res call({
 String title, String message, Map<String, dynamic>? context, List<String>? errors, List<String>? warnings
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
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? message = null,Object? context = freezed,Object? errors = freezed,Object? warnings = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,warnings: freezed == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String message,  Map<String, dynamic>? context,  List<String>? errors,  List<String>? warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
return $default(_that.title,_that.message,_that.context,_that.errors,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String message,  Map<String, dynamic>? context,  List<String>? errors,  List<String>? warnings)  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplate():
return $default(_that.title,_that.message,_that.context,_that.errors,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String message,  Map<String, dynamic>? context,  List<String>? errors,  List<String>? warnings)?  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplate() when $default != null:
return $default(_that.title,_that.message,_that.context,_that.errors,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedTemplate implements RenderedTemplate {
  const _RenderedTemplate({required this.title, required this.message, final  Map<String, dynamic>? context, final  List<String>? errors, final  List<String>? warnings}): _context = context,_errors = errors,_warnings = warnings;
  factory _RenderedTemplate.fromJson(Map<String, dynamic> json) => _$RenderedTemplateFromJson(json);

@override final  String title;
@override final  String message;
 final  Map<String, dynamic>? _context;
@override Map<String, dynamic>? get context {
  final value = _context;
  if (value == null) return null;
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String>? _errors;
@override List<String>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _warnings;
@override List<String>? get warnings {
  final value = _warnings;
  if (value == null) return null;
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedTemplate&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._context, _context)&&const DeepCollectionEquality().equals(other._errors, _errors)&&const DeepCollectionEquality().equals(other._warnings, _warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message,const DeepCollectionEquality().hash(_context),const DeepCollectionEquality().hash(_errors),const DeepCollectionEquality().hash(_warnings));

@override
String toString() {
  return 'RenderedTemplate(title: $title, message: $message, context: $context, errors: $errors, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$RenderedTemplateCopyWith<$Res> implements $RenderedTemplateCopyWith<$Res> {
  factory _$RenderedTemplateCopyWith(_RenderedTemplate value, $Res Function(_RenderedTemplate) _then) = __$RenderedTemplateCopyWithImpl;
@override @useResult
$Res call({
 String title, String message, Map<String, dynamic>? context, List<String>? errors, List<String>? warnings
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,Object? context = freezed,Object? errors = freezed,Object? warnings = freezed,}) {
  return _then(_RenderedTemplate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,context: freezed == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>?,warnings: freezed == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$CreateTemplateRequest {

 String get name; NotificationType get type; NotificationChannel get channel; String get titleTemplate; String get messageTemplate; Map<String, dynamic>? get defaultContext; String? get description; List<String>? get requiredVariables; Map<String, String>? get variableDescriptions;
/// Create a copy of CreateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTemplateRequestCopyWith<CreateTemplateRequest> get copyWith => _$CreateTemplateRequestCopyWithImpl<CreateTemplateRequest>(this as CreateTemplateRequest, _$identity);

  /// Serializes this CreateTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other.defaultContext, defaultContext)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.requiredVariables, requiredVariables)&&const DeepCollectionEquality().equals(other.variableDescriptions, variableDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,channel,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(defaultContext),description,const DeepCollectionEquality().hash(requiredVariables),const DeepCollectionEquality().hash(variableDescriptions));

@override
String toString() {
  return 'CreateTemplateRequest(name: $name, type: $type, channel: $channel, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions)';
}


}

/// @nodoc
abstract mixin class $CreateTemplateRequestCopyWith<$Res>  {
  factory $CreateTemplateRequestCopyWith(CreateTemplateRequest value, $Res Function(CreateTemplateRequest) _then) = _$CreateTemplateRequestCopyWithImpl;
@useResult
$Res call({
 String name, NotificationType type, NotificationChannel channel, String titleTemplate, String messageTemplate, Map<String, dynamic>? defaultContext, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? channel = null,Object? titleTemplate = null,Object? messageTemplate = null,Object? defaultContext = freezed,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,titleTemplate: null == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String,messageTemplate: null == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultContext: freezed == defaultContext ? _self.defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self.requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self.variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
return $default(_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)  $default,) {final _that = this;
switch (_that) {
case _CreateTemplateRequest():
return $default(_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  NotificationType type,  NotificationChannel channel,  String titleTemplate,  String messageTemplate,  Map<String, dynamic>? defaultContext,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)?  $default,) {final _that = this;
switch (_that) {
case _CreateTemplateRequest() when $default != null:
return $default(_that.name,_that.type,_that.channel,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTemplateRequest implements CreateTemplateRequest {
  const _CreateTemplateRequest({required this.name, required this.type, required this.channel, required this.titleTemplate, required this.messageTemplate, final  Map<String, dynamic>? defaultContext, this.description, final  List<String>? requiredVariables, final  Map<String, String>? variableDescriptions}): _defaultContext = defaultContext,_requiredVariables = requiredVariables,_variableDescriptions = variableDescriptions;
  factory _CreateTemplateRequest.fromJson(Map<String, dynamic> json) => _$CreateTemplateRequestFromJson(json);

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other._defaultContext, _defaultContext)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._requiredVariables, _requiredVariables)&&const DeepCollectionEquality().equals(other._variableDescriptions, _variableDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,channel,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(_defaultContext),description,const DeepCollectionEquality().hash(_requiredVariables),const DeepCollectionEquality().hash(_variableDescriptions));

@override
String toString() {
  return 'CreateTemplateRequest(name: $name, type: $type, channel: $channel, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions)';
}


}

/// @nodoc
abstract mixin class _$CreateTemplateRequestCopyWith<$Res> implements $CreateTemplateRequestCopyWith<$Res> {
  factory _$CreateTemplateRequestCopyWith(_CreateTemplateRequest value, $Res Function(_CreateTemplateRequest) _then) = __$CreateTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, NotificationType type, NotificationChannel channel, String titleTemplate, String messageTemplate, Map<String, dynamic>? defaultContext, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? channel = null,Object? titleTemplate = null,Object? messageTemplate = null,Object? defaultContext = freezed,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,}) {
  return _then(_CreateTemplateRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NotificationChannel,titleTemplate: null == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String,messageTemplate: null == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultContext: freezed == defaultContext ? _self._defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self._requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self._variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$UpdateTemplateRequest {

 String? get name; String? get titleTemplate; String? get messageTemplate; Map<String, dynamic>? get defaultContext; bool? get isActive; String? get description; List<String>? get requiredVariables; Map<String, String>? get variableDescriptions;
/// Create a copy of UpdateTemplateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTemplateRequestCopyWith<UpdateTemplateRequest> get copyWith => _$UpdateTemplateRequestCopyWithImpl<UpdateTemplateRequest>(this as UpdateTemplateRequest, _$identity);

  /// Serializes this UpdateTemplateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other.defaultContext, defaultContext)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.requiredVariables, requiredVariables)&&const DeepCollectionEquality().equals(other.variableDescriptions, variableDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(defaultContext),isActive,description,const DeepCollectionEquality().hash(requiredVariables),const DeepCollectionEquality().hash(variableDescriptions));

@override
String toString() {
  return 'UpdateTemplateRequest(name: $name, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, isActive: $isActive, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions)';
}


}

/// @nodoc
abstract mixin class $UpdateTemplateRequestCopyWith<$Res>  {
  factory $UpdateTemplateRequestCopyWith(UpdateTemplateRequest value, $Res Function(UpdateTemplateRequest) _then) = _$UpdateTemplateRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? titleTemplate, String? messageTemplate, Map<String, dynamic>? defaultContext, bool? isActive, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? titleTemplate = freezed,Object? messageTemplate = freezed,Object? defaultContext = freezed,Object? isActive = freezed,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,titleTemplate: freezed == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String?,messageTemplate: freezed == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String?,defaultContext: freezed == defaultContext ? _self.defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self.requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self.variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? titleTemplate,  String? messageTemplate,  Map<String, dynamic>? defaultContext,  bool? isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
return $default(_that.name,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? titleTemplate,  String? messageTemplate,  Map<String, dynamic>? defaultContext,  bool? isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)  $default,) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest():
return $default(_that.name,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? titleTemplate,  String? messageTemplate,  Map<String, dynamic>? defaultContext,  bool? isActive,  String? description,  List<String>? requiredVariables,  Map<String, String>? variableDescriptions)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTemplateRequest() when $default != null:
return $default(_that.name,_that.titleTemplate,_that.messageTemplate,_that.defaultContext,_that.isActive,_that.description,_that.requiredVariables,_that.variableDescriptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTemplateRequest implements UpdateTemplateRequest {
  const _UpdateTemplateRequest({this.name, this.titleTemplate, this.messageTemplate, final  Map<String, dynamic>? defaultContext, this.isActive, this.description, final  List<String>? requiredVariables, final  Map<String, String>? variableDescriptions}): _defaultContext = defaultContext,_requiredVariables = requiredVariables,_variableDescriptions = variableDescriptions;
  factory _UpdateTemplateRequest.fromJson(Map<String, dynamic> json) => _$UpdateTemplateRequestFromJson(json);

@override final  String? name;
@override final  String? titleTemplate;
@override final  String? messageTemplate;
 final  Map<String, dynamic>? _defaultContext;
@override Map<String, dynamic>? get defaultContext {
  final value = _defaultContext;
  if (value == null) return null;
  if (_defaultContext is EqualUnmodifiableMapView) return _defaultContext;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? isActive;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTemplateRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.titleTemplate, titleTemplate) || other.titleTemplate == titleTemplate)&&(identical(other.messageTemplate, messageTemplate) || other.messageTemplate == messageTemplate)&&const DeepCollectionEquality().equals(other._defaultContext, _defaultContext)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._requiredVariables, _requiredVariables)&&const DeepCollectionEquality().equals(other._variableDescriptions, _variableDescriptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,titleTemplate,messageTemplate,const DeepCollectionEquality().hash(_defaultContext),isActive,description,const DeepCollectionEquality().hash(_requiredVariables),const DeepCollectionEquality().hash(_variableDescriptions));

@override
String toString() {
  return 'UpdateTemplateRequest(name: $name, titleTemplate: $titleTemplate, messageTemplate: $messageTemplate, defaultContext: $defaultContext, isActive: $isActive, description: $description, requiredVariables: $requiredVariables, variableDescriptions: $variableDescriptions)';
}


}

/// @nodoc
abstract mixin class _$UpdateTemplateRequestCopyWith<$Res> implements $UpdateTemplateRequestCopyWith<$Res> {
  factory _$UpdateTemplateRequestCopyWith(_UpdateTemplateRequest value, $Res Function(_UpdateTemplateRequest) _then) = __$UpdateTemplateRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? titleTemplate, String? messageTemplate, Map<String, dynamic>? defaultContext, bool? isActive, String? description, List<String>? requiredVariables, Map<String, String>? variableDescriptions
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? titleTemplate = freezed,Object? messageTemplate = freezed,Object? defaultContext = freezed,Object? isActive = freezed,Object? description = freezed,Object? requiredVariables = freezed,Object? variableDescriptions = freezed,}) {
  return _then(_UpdateTemplateRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,titleTemplate: freezed == titleTemplate ? _self.titleTemplate : titleTemplate // ignore: cast_nullable_to_non_nullable
as String?,messageTemplate: freezed == messageTemplate ? _self.messageTemplate : messageTemplate // ignore: cast_nullable_to_non_nullable
as String?,defaultContext: freezed == defaultContext ? _self._defaultContext : defaultContext // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,requiredVariables: freezed == requiredVariables ? _self._requiredVariables : requiredVariables // ignore: cast_nullable_to_non_nullable
as List<String>?,variableDescriptions: freezed == variableDescriptions ? _self._variableDescriptions : variableDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$NotificationTemplateResponse {

 bool get success; NotificationTemplate get data; String? get message;
/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTemplateResponseCopyWith<NotificationTemplateResponse> get copyWith => _$NotificationTemplateResponseCopyWithImpl<NotificationTemplateResponse>(this as NotificationTemplateResponse, _$identity);

  /// Serializes this NotificationTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message);

@override
String toString() {
  return 'NotificationTemplateResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationTemplateResponseCopyWith<$Res>  {
  factory $NotificationTemplateResponseCopyWith(NotificationTemplateResponse value, $Res Function(NotificationTemplateResponse) _then) = _$NotificationTemplateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, NotificationTemplate data, String? message
});


$NotificationTemplateCopyWith<$Res> get data;

}
/// @nodoc
class _$NotificationTemplateResponseCopyWithImpl<$Res>
    implements $NotificationTemplateResponseCopyWith<$Res> {
  _$NotificationTemplateResponseCopyWithImpl(this._self, this._then);

  final NotificationTemplateResponse _self;
  final $Res Function(NotificationTemplateResponse) _then;

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationTemplate,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTemplateCopyWith<$Res> get data {
  
  return $NotificationTemplateCopyWith<$Res>(_self.data, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  NotificationTemplate data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  NotificationTemplate data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse():
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  NotificationTemplate data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTemplateResponse implements NotificationTemplateResponse {
  const _NotificationTemplateResponse({required this.success, required this.data, this.message});
  factory _NotificationTemplateResponse.fromJson(Map<String, dynamic> json) => _$NotificationTemplateResponseFromJson(json);

@override final  bool success;
@override final  NotificationTemplate data;
@override final  String? message;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message);

@override
String toString() {
  return 'NotificationTemplateResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotificationTemplateResponseCopyWith<$Res> implements $NotificationTemplateResponseCopyWith<$Res> {
  factory _$NotificationTemplateResponseCopyWith(_NotificationTemplateResponse value, $Res Function(_NotificationTemplateResponse) _then) = __$NotificationTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, NotificationTemplate data, String? message
});


@override $NotificationTemplateCopyWith<$Res> get data;

}
/// @nodoc
class __$NotificationTemplateResponseCopyWithImpl<$Res>
    implements _$NotificationTemplateResponseCopyWith<$Res> {
  __$NotificationTemplateResponseCopyWithImpl(this._self, this._then);

  final _NotificationTemplateResponse _self;
  final $Res Function(_NotificationTemplateResponse) _then;

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_NotificationTemplateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NotificationTemplate,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of NotificationTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTemplateCopyWith<$Res> get data {
  
  return $NotificationTemplateCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NotificationTemplateListResponse {

 bool get success; List<NotificationTemplate> get data; String? get message;
/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationTemplateListResponseCopyWith<NotificationTemplateListResponse> get copyWith => _$NotificationTemplateListResponseCopyWithImpl<NotificationTemplateListResponse>(this as NotificationTemplateListResponse, _$identity);

  /// Serializes this NotificationTemplateListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTemplateListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),message);

@override
String toString() {
  return 'NotificationTemplateListResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationTemplateListResponseCopyWith<$Res>  {
  factory $NotificationTemplateListResponseCopyWith(NotificationTemplateListResponse value, $Res Function(NotificationTemplateListResponse) _then) = _$NotificationTemplateListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<NotificationTemplate> data, String? message
});




}
/// @nodoc
class _$NotificationTemplateListResponseCopyWithImpl<$Res>
    implements $NotificationTemplateListResponseCopyWith<$Res> {
  _$NotificationTemplateListResponseCopyWithImpl(this._self, this._then);

  final NotificationTemplateListResponse _self;
  final $Res Function(NotificationTemplateListResponse) _then;

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<NotificationTemplate>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<NotificationTemplate> data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<NotificationTemplate> data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse():
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<NotificationTemplate> data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _NotificationTemplateListResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationTemplateListResponse implements NotificationTemplateListResponse {
  const _NotificationTemplateListResponse({required this.success, required final  List<NotificationTemplate> data, this.message}): _data = data;
  factory _NotificationTemplateListResponse.fromJson(Map<String, dynamic> json) => _$NotificationTemplateListResponseFromJson(json);

@override final  bool success;
 final  List<NotificationTemplate> _data;
@override List<NotificationTemplate> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  String? message;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationTemplateListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),message);

@override
String toString() {
  return 'NotificationTemplateListResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$NotificationTemplateListResponseCopyWith<$Res> implements $NotificationTemplateListResponseCopyWith<$Res> {
  factory _$NotificationTemplateListResponseCopyWith(_NotificationTemplateListResponse value, $Res Function(_NotificationTemplateListResponse) _then) = __$NotificationTemplateListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<NotificationTemplate> data, String? message
});




}
/// @nodoc
class __$NotificationTemplateListResponseCopyWithImpl<$Res>
    implements _$NotificationTemplateListResponseCopyWith<$Res> {
  __$NotificationTemplateListResponseCopyWithImpl(this._self, this._then);

  final _NotificationTemplateListResponse _self;
  final $Res Function(_NotificationTemplateListResponse) _then;

/// Create a copy of NotificationTemplateListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_NotificationTemplateListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<NotificationTemplate>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RenderedTemplateResponse {

 bool get success; RenderedTemplate get data; String? get message;
/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedTemplateResponseCopyWith<RenderedTemplateResponse> get copyWith => _$RenderedTemplateResponseCopyWithImpl<RenderedTemplateResponse>(this as RenderedTemplateResponse, _$identity);

  /// Serializes this RenderedTemplateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message);

@override
String toString() {
  return 'RenderedTemplateResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $RenderedTemplateResponseCopyWith<$Res>  {
  factory $RenderedTemplateResponseCopyWith(RenderedTemplateResponse value, $Res Function(RenderedTemplateResponse) _then) = _$RenderedTemplateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, RenderedTemplate data, String? message
});


$RenderedTemplateCopyWith<$Res> get data;

}
/// @nodoc
class _$RenderedTemplateResponseCopyWithImpl<$Res>
    implements $RenderedTemplateResponseCopyWith<$Res> {
  _$RenderedTemplateResponseCopyWithImpl(this._self, this._then);

  final RenderedTemplateResponse _self;
  final $Res Function(RenderedTemplateResponse) _then;

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RenderedTemplate,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<$Res> get data {
  
  return $RenderedTemplateCopyWith<$Res>(_self.data, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  RenderedTemplate data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  RenderedTemplate data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse():
return $default(_that.success,_that.data,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  RenderedTemplate data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _RenderedTemplateResponse() when $default != null:
return $default(_that.success,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedTemplateResponse implements RenderedTemplateResponse {
  const _RenderedTemplateResponse({required this.success, required this.data, this.message});
  factory _RenderedTemplateResponse.fromJson(Map<String, dynamic> json) => _$RenderedTemplateResponseFromJson(json);

@override final  bool success;
@override final  RenderedTemplate data;
@override final  String? message;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedTemplateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message);

@override
String toString() {
  return 'RenderedTemplateResponse(success: $success, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$RenderedTemplateResponseCopyWith<$Res> implements $RenderedTemplateResponseCopyWith<$Res> {
  factory _$RenderedTemplateResponseCopyWith(_RenderedTemplateResponse value, $Res Function(_RenderedTemplateResponse) _then) = __$RenderedTemplateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, RenderedTemplate data, String? message
});


@override $RenderedTemplateCopyWith<$Res> get data;

}
/// @nodoc
class __$RenderedTemplateResponseCopyWithImpl<$Res>
    implements _$RenderedTemplateResponseCopyWith<$Res> {
  __$RenderedTemplateResponseCopyWithImpl(this._self, this._then);

  final _RenderedTemplateResponse _self;
  final $Res Function(_RenderedTemplateResponse) _then;

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? message = freezed,}) {
  return _then(_RenderedTemplateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as RenderedTemplate,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RenderedTemplateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedTemplateCopyWith<$Res> get data {
  
  return $RenderedTemplateCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
