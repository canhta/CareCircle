// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationMetadata {

 bool get healthContextIncluded; bool get medicationContextIncluded; UserPreferences get userPreferences; String get aiModelUsed; int get tokensUsed;
/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMetadataCopyWith<ConversationMetadata> get copyWith => _$ConversationMetadataCopyWithImpl<ConversationMetadata>(this as ConversationMetadata, _$identity);

  /// Serializes this ConversationMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMetadata&&(identical(other.healthContextIncluded, healthContextIncluded) || other.healthContextIncluded == healthContextIncluded)&&(identical(other.medicationContextIncluded, medicationContextIncluded) || other.medicationContextIncluded == medicationContextIncluded)&&(identical(other.userPreferences, userPreferences) || other.userPreferences == userPreferences)&&(identical(other.aiModelUsed, aiModelUsed) || other.aiModelUsed == aiModelUsed)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,healthContextIncluded,medicationContextIncluded,userPreferences,aiModelUsed,tokensUsed);

@override
String toString() {
  return 'ConversationMetadata(healthContextIncluded: $healthContextIncluded, medicationContextIncluded: $medicationContextIncluded, userPreferences: $userPreferences, aiModelUsed: $aiModelUsed, tokensUsed: $tokensUsed)';
}


}

/// @nodoc
abstract mixin class $ConversationMetadataCopyWith<$Res>  {
  factory $ConversationMetadataCopyWith(ConversationMetadata value, $Res Function(ConversationMetadata) _then) = _$ConversationMetadataCopyWithImpl;
@useResult
$Res call({
 bool healthContextIncluded, bool medicationContextIncluded, UserPreferences userPreferences, String aiModelUsed, int tokensUsed
});


$UserPreferencesCopyWith<$Res> get userPreferences;

}
/// @nodoc
class _$ConversationMetadataCopyWithImpl<$Res>
    implements $ConversationMetadataCopyWith<$Res> {
  _$ConversationMetadataCopyWithImpl(this._self, this._then);

  final ConversationMetadata _self;
  final $Res Function(ConversationMetadata) _then;

/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? healthContextIncluded = null,Object? medicationContextIncluded = null,Object? userPreferences = null,Object? aiModelUsed = null,Object? tokensUsed = null,}) {
  return _then(_self.copyWith(
healthContextIncluded: null == healthContextIncluded ? _self.healthContextIncluded : healthContextIncluded // ignore: cast_nullable_to_non_nullable
as bool,medicationContextIncluded: null == medicationContextIncluded ? _self.medicationContextIncluded : medicationContextIncluded // ignore: cast_nullable_to_non_nullable
as bool,userPreferences: null == userPreferences ? _self.userPreferences : userPreferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,aiModelUsed: null == aiModelUsed ? _self.aiModelUsed : aiModelUsed // ignore: cast_nullable_to_non_nullable
as String,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get userPreferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.userPreferences, (value) {
    return _then(_self.copyWith(userPreferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationMetadata].
extension ConversationMetadataPatterns on ConversationMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool healthContextIncluded,  bool medicationContextIncluded,  UserPreferences userPreferences,  String aiModelUsed,  int tokensUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationMetadata() when $default != null:
return $default(_that.healthContextIncluded,_that.medicationContextIncluded,_that.userPreferences,_that.aiModelUsed,_that.tokensUsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool healthContextIncluded,  bool medicationContextIncluded,  UserPreferences userPreferences,  String aiModelUsed,  int tokensUsed)  $default,) {final _that = this;
switch (_that) {
case _ConversationMetadata():
return $default(_that.healthContextIncluded,_that.medicationContextIncluded,_that.userPreferences,_that.aiModelUsed,_that.tokensUsed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool healthContextIncluded,  bool medicationContextIncluded,  UserPreferences userPreferences,  String aiModelUsed,  int tokensUsed)?  $default,) {final _that = this;
switch (_that) {
case _ConversationMetadata() when $default != null:
return $default(_that.healthContextIncluded,_that.medicationContextIncluded,_that.userPreferences,_that.aiModelUsed,_that.tokensUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMetadata implements ConversationMetadata {
  const _ConversationMetadata({this.healthContextIncluded = false, this.medicationContextIncluded = false, this.userPreferences = const UserPreferences(), this.aiModelUsed = 'gpt-4', this.tokensUsed = 0});
  factory _ConversationMetadata.fromJson(Map<String, dynamic> json) => _$ConversationMetadataFromJson(json);

@override@JsonKey() final  bool healthContextIncluded;
@override@JsonKey() final  bool medicationContextIncluded;
@override@JsonKey() final  UserPreferences userPreferences;
@override@JsonKey() final  String aiModelUsed;
@override@JsonKey() final  int tokensUsed;

/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMetadataCopyWith<_ConversationMetadata> get copyWith => __$ConversationMetadataCopyWithImpl<_ConversationMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMetadata&&(identical(other.healthContextIncluded, healthContextIncluded) || other.healthContextIncluded == healthContextIncluded)&&(identical(other.medicationContextIncluded, medicationContextIncluded) || other.medicationContextIncluded == medicationContextIncluded)&&(identical(other.userPreferences, userPreferences) || other.userPreferences == userPreferences)&&(identical(other.aiModelUsed, aiModelUsed) || other.aiModelUsed == aiModelUsed)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,healthContextIncluded,medicationContextIncluded,userPreferences,aiModelUsed,tokensUsed);

@override
String toString() {
  return 'ConversationMetadata(healthContextIncluded: $healthContextIncluded, medicationContextIncluded: $medicationContextIncluded, userPreferences: $userPreferences, aiModelUsed: $aiModelUsed, tokensUsed: $tokensUsed)';
}


}

/// @nodoc
abstract mixin class _$ConversationMetadataCopyWith<$Res> implements $ConversationMetadataCopyWith<$Res> {
  factory _$ConversationMetadataCopyWith(_ConversationMetadata value, $Res Function(_ConversationMetadata) _then) = __$ConversationMetadataCopyWithImpl;
@override @useResult
$Res call({
 bool healthContextIncluded, bool medicationContextIncluded, UserPreferences userPreferences, String aiModelUsed, int tokensUsed
});


@override $UserPreferencesCopyWith<$Res> get userPreferences;

}
/// @nodoc
class __$ConversationMetadataCopyWithImpl<$Res>
    implements _$ConversationMetadataCopyWith<$Res> {
  __$ConversationMetadataCopyWithImpl(this._self, this._then);

  final _ConversationMetadata _self;
  final $Res Function(_ConversationMetadata) _then;

/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? healthContextIncluded = null,Object? medicationContextIncluded = null,Object? userPreferences = null,Object? aiModelUsed = null,Object? tokensUsed = null,}) {
  return _then(_ConversationMetadata(
healthContextIncluded: null == healthContextIncluded ? _self.healthContextIncluded : healthContextIncluded // ignore: cast_nullable_to_non_nullable
as bool,medicationContextIncluded: null == medicationContextIncluded ? _self.medicationContextIncluded : medicationContextIncluded // ignore: cast_nullable_to_non_nullable
as bool,userPreferences: null == userPreferences ? _self.userPreferences : userPreferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,aiModelUsed: null == aiModelUsed ? _self.aiModelUsed : aiModelUsed // ignore: cast_nullable_to_non_nullable
as String,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ConversationMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get userPreferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.userPreferences, (value) {
    return _then(_self.copyWith(userPreferences: value));
  });
}
}


/// @nodoc
mixin _$UserPreferences {

 String get language; String get responseLength;// 'concise' | 'detailed'
 String get technicalLevel;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.language, language) || other.language == language)&&(identical(other.responseLength, responseLength) || other.responseLength == responseLength)&&(identical(other.technicalLevel, technicalLevel) || other.technicalLevel == technicalLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,responseLength,technicalLevel);

@override
String toString() {
  return 'UserPreferences(language: $language, responseLength: $responseLength, technicalLevel: $technicalLevel)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 String language, String responseLength, String technicalLevel
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? responseLength = null,Object? technicalLevel = null,}) {
  return _then(_self.copyWith(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,responseLength: null == responseLength ? _self.responseLength : responseLength // ignore: cast_nullable_to_non_nullable
as String,technicalLevel: null == technicalLevel ? _self.technicalLevel : technicalLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String language,  String responseLength,  String technicalLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.language,_that.responseLength,_that.technicalLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String language,  String responseLength,  String technicalLevel)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.language,_that.responseLength,_that.technicalLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String language,  String responseLength,  String technicalLevel)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.language,_that.responseLength,_that.technicalLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferences implements UserPreferences {
  const _UserPreferences({this.language = 'en', this.responseLength = 'detailed', this.technicalLevel = 'simple'});
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

@override@JsonKey() final  String language;
@override@JsonKey() final  String responseLength;
// 'concise' | 'detailed'
@override@JsonKey() final  String technicalLevel;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.language, language) || other.language == language)&&(identical(other.responseLength, responseLength) || other.responseLength == responseLength)&&(identical(other.technicalLevel, technicalLevel) || other.technicalLevel == technicalLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language,responseLength,technicalLevel);

@override
String toString() {
  return 'UserPreferences(language: $language, responseLength: $responseLength, technicalLevel: $technicalLevel)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 String language, String responseLength, String technicalLevel
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? responseLength = null,Object? technicalLevel = null,}) {
  return _then(_UserPreferences(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,responseLength: null == responseLength ? _self.responseLength : responseLength // ignore: cast_nullable_to_non_nullable
as String,technicalLevel: null == technicalLevel ? _self.technicalLevel : technicalLevel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MessageMetadata {

 int get processingTime; double get confidence; int get tokensUsed; String get modelVersion; bool get flagged; String? get flagReason;
/// Create a copy of MessageMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageMetadataCopyWith<MessageMetadata> get copyWith => _$MessageMetadataCopyWithImpl<MessageMetadata>(this as MessageMetadata, _$identity);

  /// Serializes this MessageMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageMetadata&&(identical(other.processingTime, processingTime) || other.processingTime == processingTime)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.flagged, flagged) || other.flagged == flagged)&&(identical(other.flagReason, flagReason) || other.flagReason == flagReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processingTime,confidence,tokensUsed,modelVersion,flagged,flagReason);

@override
String toString() {
  return 'MessageMetadata(processingTime: $processingTime, confidence: $confidence, tokensUsed: $tokensUsed, modelVersion: $modelVersion, flagged: $flagged, flagReason: $flagReason)';
}


}

/// @nodoc
abstract mixin class $MessageMetadataCopyWith<$Res>  {
  factory $MessageMetadataCopyWith(MessageMetadata value, $Res Function(MessageMetadata) _then) = _$MessageMetadataCopyWithImpl;
@useResult
$Res call({
 int processingTime, double confidence, int tokensUsed, String modelVersion, bool flagged, String? flagReason
});




}
/// @nodoc
class _$MessageMetadataCopyWithImpl<$Res>
    implements $MessageMetadataCopyWith<$Res> {
  _$MessageMetadataCopyWithImpl(this._self, this._then);

  final MessageMetadata _self;
  final $Res Function(MessageMetadata) _then;

/// Create a copy of MessageMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processingTime = null,Object? confidence = null,Object? tokensUsed = null,Object? modelVersion = null,Object? flagged = null,Object? flagReason = freezed,}) {
  return _then(_self.copyWith(
processingTime: null == processingTime ? _self.processingTime : processingTime // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,flagged: null == flagged ? _self.flagged : flagged // ignore: cast_nullable_to_non_nullable
as bool,flagReason: freezed == flagReason ? _self.flagReason : flagReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageMetadata].
extension MessageMetadataPatterns on MessageMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageMetadata value)  $default,){
final _that = this;
switch (_that) {
case _MessageMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _MessageMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int processingTime,  double confidence,  int tokensUsed,  String modelVersion,  bool flagged,  String? flagReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageMetadata() when $default != null:
return $default(_that.processingTime,_that.confidence,_that.tokensUsed,_that.modelVersion,_that.flagged,_that.flagReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int processingTime,  double confidence,  int tokensUsed,  String modelVersion,  bool flagged,  String? flagReason)  $default,) {final _that = this;
switch (_that) {
case _MessageMetadata():
return $default(_that.processingTime,_that.confidence,_that.tokensUsed,_that.modelVersion,_that.flagged,_that.flagReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int processingTime,  double confidence,  int tokensUsed,  String modelVersion,  bool flagged,  String? flagReason)?  $default,) {final _that = this;
switch (_that) {
case _MessageMetadata() when $default != null:
return $default(_that.processingTime,_that.confidence,_that.tokensUsed,_that.modelVersion,_that.flagged,_that.flagReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageMetadata implements MessageMetadata {
  const _MessageMetadata({this.processingTime = 0, this.confidence = 1.0, this.tokensUsed = 0, this.modelVersion = 'gpt-4', this.flagged = false, this.flagReason});
  factory _MessageMetadata.fromJson(Map<String, dynamic> json) => _$MessageMetadataFromJson(json);

@override@JsonKey() final  int processingTime;
@override@JsonKey() final  double confidence;
@override@JsonKey() final  int tokensUsed;
@override@JsonKey() final  String modelVersion;
@override@JsonKey() final  bool flagged;
@override final  String? flagReason;

/// Create a copy of MessageMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageMetadataCopyWith<_MessageMetadata> get copyWith => __$MessageMetadataCopyWithImpl<_MessageMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageMetadata&&(identical(other.processingTime, processingTime) || other.processingTime == processingTime)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.tokensUsed, tokensUsed) || other.tokensUsed == tokensUsed)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.flagged, flagged) || other.flagged == flagged)&&(identical(other.flagReason, flagReason) || other.flagReason == flagReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processingTime,confidence,tokensUsed,modelVersion,flagged,flagReason);

@override
String toString() {
  return 'MessageMetadata(processingTime: $processingTime, confidence: $confidence, tokensUsed: $tokensUsed, modelVersion: $modelVersion, flagged: $flagged, flagReason: $flagReason)';
}


}

/// @nodoc
abstract mixin class _$MessageMetadataCopyWith<$Res> implements $MessageMetadataCopyWith<$Res> {
  factory _$MessageMetadataCopyWith(_MessageMetadata value, $Res Function(_MessageMetadata) _then) = __$MessageMetadataCopyWithImpl;
@override @useResult
$Res call({
 int processingTime, double confidence, int tokensUsed, String modelVersion, bool flagged, String? flagReason
});




}
/// @nodoc
class __$MessageMetadataCopyWithImpl<$Res>
    implements _$MessageMetadataCopyWith<$Res> {
  __$MessageMetadataCopyWithImpl(this._self, this._then);

  final _MessageMetadata _self;
  final $Res Function(_MessageMetadata) _then;

/// Create a copy of MessageMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processingTime = null,Object? confidence = null,Object? tokensUsed = null,Object? modelVersion = null,Object? flagged = null,Object? flagReason = freezed,}) {
  return _then(_MessageMetadata(
processingTime: null == processingTime ? _self.processingTime : processingTime // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,tokensUsed: null == tokensUsed ? _self.tokensUsed : tokensUsed // ignore: cast_nullable_to_non_nullable
as int,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,flagged: null == flagged ? _self.flagged : flagged // ignore: cast_nullable_to_non_nullable
as bool,flagReason: freezed == flagReason ? _self.flagReason : flagReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Reference {

 String get type;// 'medical_literature' | 'user_data' | 'health_guideline'
 String get title; String get description; String? get url; double get confidence;
/// Create a copy of Reference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenceCopyWith<Reference> get copyWith => _$ReferenceCopyWithImpl<Reference>(this as Reference, _$identity);

  /// Serializes this Reference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reference&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,description,url,confidence);

@override
String toString() {
  return 'Reference(type: $type, title: $title, description: $description, url: $url, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ReferenceCopyWith<$Res>  {
  factory $ReferenceCopyWith(Reference value, $Res Function(Reference) _then) = _$ReferenceCopyWithImpl;
@useResult
$Res call({
 String type, String title, String description, String? url, double confidence
});




}
/// @nodoc
class _$ReferenceCopyWithImpl<$Res>
    implements $ReferenceCopyWith<$Res> {
  _$ReferenceCopyWithImpl(this._self, this._then);

  final Reference _self;
  final $Res Function(Reference) _then;

/// Create a copy of Reference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? description = null,Object? url = freezed,Object? confidence = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Reference].
extension ReferencePatterns on Reference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reference value)  $default,){
final _that = this;
switch (_that) {
case _Reference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reference value)?  $default,){
final _that = this;
switch (_that) {
case _Reference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String title,  String description,  String? url,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reference() when $default != null:
return $default(_that.type,_that.title,_that.description,_that.url,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String title,  String description,  String? url,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _Reference():
return $default(_that.type,_that.title,_that.description,_that.url,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String title,  String description,  String? url,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _Reference() when $default != null:
return $default(_that.type,_that.title,_that.description,_that.url,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reference implements Reference {
  const _Reference({required this.type, required this.title, required this.description, this.url, this.confidence = 1.0});
  factory _Reference.fromJson(Map<String, dynamic> json) => _$ReferenceFromJson(json);

@override final  String type;
// 'medical_literature' | 'user_data' | 'health_guideline'
@override final  String title;
@override final  String description;
@override final  String? url;
@override@JsonKey() final  double confidence;

/// Create a copy of Reference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferenceCopyWith<_Reference> get copyWith => __$ReferenceCopyWithImpl<_Reference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reference&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,title,description,url,confidence);

@override
String toString() {
  return 'Reference(type: $type, title: $title, description: $description, url: $url, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ReferenceCopyWith<$Res> implements $ReferenceCopyWith<$Res> {
  factory _$ReferenceCopyWith(_Reference value, $Res Function(_Reference) _then) = __$ReferenceCopyWithImpl;
@override @useResult
$Res call({
 String type, String title, String description, String? url, double confidence
});




}
/// @nodoc
class __$ReferenceCopyWithImpl<$Res>
    implements _$ReferenceCopyWith<$Res> {
  __$ReferenceCopyWithImpl(this._self, this._then);

  final _Reference _self;
  final $Res Function(_Reference) _then;

/// Create a copy of Reference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? description = null,Object? url = freezed,Object? confidence = null,}) {
  return _then(_Reference(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$Attachment {

 String get type;// 'image' | 'document' | 'audio' | 'chart'
 String get url; String get contentType; int get size; Map<String, dynamic> get metadata;
/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentCopyWith<Attachment> get copyWith => _$AttachmentCopyWithImpl<Attachment>(this as Attachment, _$identity);

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attachment&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,url,contentType,size,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'Attachment(type: $type, url: $url, contentType: $contentType, size: $size, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AttachmentCopyWith<$Res>  {
  factory $AttachmentCopyWith(Attachment value, $Res Function(Attachment) _then) = _$AttachmentCopyWithImpl;
@useResult
$Res call({
 String type, String url, String contentType, int size, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$AttachmentCopyWithImpl<$Res>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._self, this._then);

  final Attachment _self;
  final $Res Function(Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? url = null,Object? contentType = null,Object? size = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Attachment].
extension AttachmentPatterns on Attachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attachment value)  $default,){
final _that = this;
switch (_that) {
case _Attachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attachment value)?  $default,){
final _that = this;
switch (_that) {
case _Attachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String url,  String contentType,  int size,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.type,_that.url,_that.contentType,_that.size,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String url,  String contentType,  int size,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _Attachment():
return $default(_that.type,_that.url,_that.contentType,_that.size,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String url,  String contentType,  int size,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _Attachment() when $default != null:
return $default(_that.type,_that.url,_that.contentType,_that.size,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attachment implements Attachment {
  const _Attachment({required this.type, required this.url, required this.contentType, required this.size, final  Map<String, dynamic> metadata = const {}}): _metadata = metadata;
  factory _Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);

@override final  String type;
// 'image' | 'document' | 'audio' | 'chart'
@override final  String url;
@override final  String contentType;
@override final  int size;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentCopyWith<_Attachment> get copyWith => __$AttachmentCopyWithImpl<_Attachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attachment&&(identical(other.type, type) || other.type == type)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,url,contentType,size,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'Attachment(type: $type, url: $url, contentType: $contentType, size: $size, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AttachmentCopyWith<$Res> implements $AttachmentCopyWith<$Res> {
  factory _$AttachmentCopyWith(_Attachment value, $Res Function(_Attachment) _then) = __$AttachmentCopyWithImpl;
@override @useResult
$Res call({
 String type, String url, String contentType, int size, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$AttachmentCopyWithImpl<$Res>
    implements _$AttachmentCopyWith<$Res> {
  __$AttachmentCopyWithImpl(this._self, this._then);

  final _Attachment _self;
  final $Res Function(_Attachment) _then;

/// Create a copy of Attachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? url = null,Object? contentType = null,Object? size = null,Object? metadata = null,}) {
  return _then(_Attachment(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$Conversation {

 String get id; String get userId; String get title; ConversationStatus get status; ConversationMetadata get metadata; DateTime get createdAt; DateTime get updatedAt; int get messageCount; int get totalTokensUsed;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.totalTokensUsed, totalTokensUsed) || other.totalTokensUsed == totalTokensUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,status,metadata,createdAt,updatedAt,messageCount,totalTokensUsed);

@override
String toString() {
  return 'Conversation(id: $id, userId: $userId, title: $title, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, messageCount: $messageCount, totalTokensUsed: $totalTokensUsed)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String title, ConversationStatus status, ConversationMetadata metadata, DateTime createdAt, DateTime updatedAt, int messageCount, int totalTokensUsed
});


$ConversationMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? status = null,Object? metadata = null,Object? createdAt = null,Object? updatedAt = null,Object? messageCount = null,Object? totalTokensUsed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationStatus,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ConversationMetadata,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,totalTokensUsed: null == totalTokensUsed ? _self.totalTokensUsed : totalTokensUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetadataCopyWith<$Res> get metadata {
  
  return $ConversationMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  ConversationStatus status,  ConversationMetadata metadata,  DateTime createdAt,  DateTime updatedAt,  int messageCount,  int totalTokensUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.status,_that.metadata,_that.createdAt,_that.updatedAt,_that.messageCount,_that.totalTokensUsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String title,  ConversationStatus status,  ConversationMetadata metadata,  DateTime createdAt,  DateTime updatedAt,  int messageCount,  int totalTokensUsed)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.userId,_that.title,_that.status,_that.metadata,_that.createdAt,_that.updatedAt,_that.messageCount,_that.totalTokensUsed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String title,  ConversationStatus status,  ConversationMetadata metadata,  DateTime createdAt,  DateTime updatedAt,  int messageCount,  int totalTokensUsed)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.status,_that.metadata,_that.createdAt,_that.updatedAt,_that.messageCount,_that.totalTokensUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conversation implements Conversation {
  const _Conversation({required this.id, required this.userId, required this.title, this.status = ConversationStatus.active, this.metadata = const ConversationMetadata(), required this.createdAt, required this.updatedAt, this.messageCount = 0, this.totalTokensUsed = 0});
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  ConversationStatus status;
@override@JsonKey() final  ConversationMetadata metadata;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  int messageCount;
@override@JsonKey() final  int totalTokensUsed;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.messageCount, messageCount) || other.messageCount == messageCount)&&(identical(other.totalTokensUsed, totalTokensUsed) || other.totalTokensUsed == totalTokensUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,status,metadata,createdAt,updatedAt,messageCount,totalTokensUsed);

@override
String toString() {
  return 'Conversation(id: $id, userId: $userId, title: $title, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, messageCount: $messageCount, totalTokensUsed: $totalTokensUsed)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String title, ConversationStatus status, ConversationMetadata metadata, DateTime createdAt, DateTime updatedAt, int messageCount, int totalTokensUsed
});


@override $ConversationMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? title = null,Object? status = null,Object? metadata = null,Object? createdAt = null,Object? updatedAt = null,Object? messageCount = null,Object? totalTokensUsed = null,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationStatus,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ConversationMetadata,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,messageCount: null == messageCount ? _self.messageCount : messageCount // ignore: cast_nullable_to_non_nullable
as int,totalTokensUsed: null == totalTokensUsed ? _self.totalTokensUsed : totalTokensUsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetadataCopyWith<$Res> get metadata {
  
  return $ConversationMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$Message {

 String get id; String get conversationId; MessageRole get role; String get content; DateTime get timestamp; MessageMetadata get metadata; List<Reference> get references; List<Attachment> get attachments; bool get isHidden;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.references, references)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,content,timestamp,metadata,const DeepCollectionEquality().hash(references),const DeepCollectionEquality().hash(attachments),isHidden);

@override
String toString() {
  return 'Message(id: $id, conversationId: $conversationId, role: $role, content: $content, timestamp: $timestamp, metadata: $metadata, references: $references, attachments: $attachments, isHidden: $isHidden)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, MessageRole role, String content, DateTime timestamp, MessageMetadata metadata, List<Reference> references, List<Attachment> attachments, bool isHidden
});


$MessageMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? content = null,Object? timestamp = null,Object? metadata = null,Object? references = null,Object? attachments = null,Object? isHidden = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MessageMetadata,references: null == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as List<Reference>,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageMetadataCopyWith<$Res> get metadata {
  
  return $MessageMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  MessageRole role,  String content,  DateTime timestamp,  MessageMetadata metadata,  List<Reference> references,  List<Attachment> attachments,  bool isHidden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.content,_that.timestamp,_that.metadata,_that.references,_that.attachments,_that.isHidden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  MessageRole role,  String content,  DateTime timestamp,  MessageMetadata metadata,  List<Reference> references,  List<Attachment> attachments,  bool isHidden)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.conversationId,_that.role,_that.content,_that.timestamp,_that.metadata,_that.references,_that.attachments,_that.isHidden);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  MessageRole role,  String content,  DateTime timestamp,  MessageMetadata metadata,  List<Reference> references,  List<Attachment> attachments,  bool isHidden)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.content,_that.timestamp,_that.metadata,_that.references,_that.attachments,_that.isHidden);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({required this.id, required this.conversationId, required this.role, required this.content, required this.timestamp, this.metadata = const MessageMetadata(), final  List<Reference> references = const [], final  List<Attachment> attachments = const [], this.isHidden = false}): _references = references,_attachments = attachments;
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  MessageRole role;
@override final  String content;
@override final  DateTime timestamp;
@override@JsonKey() final  MessageMetadata metadata;
 final  List<Reference> _references;
@override@JsonKey() List<Reference> get references {
  if (_references is EqualUnmodifiableListView) return _references;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_references);
}

 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override@JsonKey() final  bool isHidden;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._references, _references)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,content,timestamp,metadata,const DeepCollectionEquality().hash(_references),const DeepCollectionEquality().hash(_attachments),isHidden);

@override
String toString() {
  return 'Message(id: $id, conversationId: $conversationId, role: $role, content: $content, timestamp: $timestamp, metadata: $metadata, references: $references, attachments: $attachments, isHidden: $isHidden)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, MessageRole role, String content, DateTime timestamp, MessageMetadata metadata, List<Reference> references, List<Attachment> attachments, bool isHidden
});


@override $MessageMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? content = null,Object? timestamp = null,Object? metadata = null,Object? references = null,Object? attachments = null,Object? isHidden = null,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MessageMetadata,references: null == references ? _self._references : references // ignore: cast_nullable_to_non_nullable
as List<Reference>,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageMetadataCopyWith<$Res> get metadata {
  
  return $MessageMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$SendMessageRequest {

 String get content; List<Attachment> get attachments;
/// Create a copy of SendMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageRequestCopyWith<SendMessageRequest> get copyWith => _$SendMessageRequestCopyWithImpl<SendMessageRequest>(this as SendMessageRequest, _$identity);

  /// Serializes this SendMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageRequest&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.attachments, attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(attachments));

@override
String toString() {
  return 'SendMessageRequest(content: $content, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class $SendMessageRequestCopyWith<$Res>  {
  factory $SendMessageRequestCopyWith(SendMessageRequest value, $Res Function(SendMessageRequest) _then) = _$SendMessageRequestCopyWithImpl;
@useResult
$Res call({
 String content, List<Attachment> attachments
});




}
/// @nodoc
class _$SendMessageRequestCopyWithImpl<$Res>
    implements $SendMessageRequestCopyWith<$Res> {
  _$SendMessageRequestCopyWithImpl(this._self, this._then);

  final SendMessageRequest _self;
  final $Res Function(SendMessageRequest) _then;

/// Create a copy of SendMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? attachments = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}

}


/// Adds pattern-matching-related methods to [SendMessageRequest].
extension SendMessageRequestPatterns on SendMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _SendMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SendMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  List<Attachment> attachments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMessageRequest() when $default != null:
return $default(_that.content,_that.attachments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  List<Attachment> attachments)  $default,) {final _that = this;
switch (_that) {
case _SendMessageRequest():
return $default(_that.content,_that.attachments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  List<Attachment> attachments)?  $default,) {final _that = this;
switch (_that) {
case _SendMessageRequest() when $default != null:
return $default(_that.content,_that.attachments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendMessageRequest implements SendMessageRequest {
  const _SendMessageRequest({required this.content, final  List<Attachment> attachments = const []}): _attachments = attachments;
  factory _SendMessageRequest.fromJson(Map<String, dynamic> json) => _$SendMessageRequestFromJson(json);

@override final  String content;
 final  List<Attachment> _attachments;
@override@JsonKey() List<Attachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}


/// Create a copy of SendMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageRequestCopyWith<_SendMessageRequest> get copyWith => __$SendMessageRequestCopyWithImpl<_SendMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessageRequest&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._attachments, _attachments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(_attachments));

@override
String toString() {
  return 'SendMessageRequest(content: $content, attachments: $attachments)';
}


}

/// @nodoc
abstract mixin class _$SendMessageRequestCopyWith<$Res> implements $SendMessageRequestCopyWith<$Res> {
  factory _$SendMessageRequestCopyWith(_SendMessageRequest value, $Res Function(_SendMessageRequest) _then) = __$SendMessageRequestCopyWithImpl;
@override @useResult
$Res call({
 String content, List<Attachment> attachments
});




}
/// @nodoc
class __$SendMessageRequestCopyWithImpl<$Res>
    implements _$SendMessageRequestCopyWith<$Res> {
  __$SendMessageRequestCopyWithImpl(this._self, this._then);

  final _SendMessageRequest _self;
  final $Res Function(_SendMessageRequest) _then;

/// Create a copy of SendMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? attachments = null,}) {
  return _then(_SendMessageRequest(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<Attachment>,
  ));
}


}


/// @nodoc
mixin _$SendMessageResponse {

 Message get userMessage; Message get assistantMessage; Conversation get conversation;
/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageResponseCopyWith<SendMessageResponse> get copyWith => _$SendMessageResponseCopyWithImpl<SendMessageResponse>(this as SendMessageResponse, _$identity);

  /// Serializes this SendMessageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageResponse&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage)&&(identical(other.assistantMessage, assistantMessage) || other.assistantMessage == assistantMessage)&&(identical(other.conversation, conversation) || other.conversation == conversation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userMessage,assistantMessage,conversation);

@override
String toString() {
  return 'SendMessageResponse(userMessage: $userMessage, assistantMessage: $assistantMessage, conversation: $conversation)';
}


}

/// @nodoc
abstract mixin class $SendMessageResponseCopyWith<$Res>  {
  factory $SendMessageResponseCopyWith(SendMessageResponse value, $Res Function(SendMessageResponse) _then) = _$SendMessageResponseCopyWithImpl;
@useResult
$Res call({
 Message userMessage, Message assistantMessage, Conversation conversation
});


$MessageCopyWith<$Res> get userMessage;$MessageCopyWith<$Res> get assistantMessage;$ConversationCopyWith<$Res> get conversation;

}
/// @nodoc
class _$SendMessageResponseCopyWithImpl<$Res>
    implements $SendMessageResponseCopyWith<$Res> {
  _$SendMessageResponseCopyWithImpl(this._self, this._then);

  final SendMessageResponse _self;
  final $Res Function(SendMessageResponse) _then;

/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userMessage = null,Object? assistantMessage = null,Object? conversation = null,}) {
  return _then(_self.copyWith(
userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as Message,assistantMessage: null == assistantMessage ? _self.assistantMessage : assistantMessage // ignore: cast_nullable_to_non_nullable
as Message,conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as Conversation,
  ));
}
/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res> get userMessage {
  
  return $MessageCopyWith<$Res>(_self.userMessage, (value) {
    return _then(_self.copyWith(userMessage: value));
  });
}/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res> get assistantMessage {
  
  return $MessageCopyWith<$Res>(_self.assistantMessage, (value) {
    return _then(_self.copyWith(assistantMessage: value));
  });
}/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationCopyWith<$Res> get conversation {
  
  return $ConversationCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendMessageResponse].
extension SendMessageResponsePatterns on SendMessageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMessageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMessageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMessageResponse value)  $default,){
final _that = this;
switch (_that) {
case _SendMessageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMessageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SendMessageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Message userMessage,  Message assistantMessage,  Conversation conversation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMessageResponse() when $default != null:
return $default(_that.userMessage,_that.assistantMessage,_that.conversation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Message userMessage,  Message assistantMessage,  Conversation conversation)  $default,) {final _that = this;
switch (_that) {
case _SendMessageResponse():
return $default(_that.userMessage,_that.assistantMessage,_that.conversation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Message userMessage,  Message assistantMessage,  Conversation conversation)?  $default,) {final _that = this;
switch (_that) {
case _SendMessageResponse() when $default != null:
return $default(_that.userMessage,_that.assistantMessage,_that.conversation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendMessageResponse implements SendMessageResponse {
  const _SendMessageResponse({required this.userMessage, required this.assistantMessage, required this.conversation});
  factory _SendMessageResponse.fromJson(Map<String, dynamic> json) => _$SendMessageResponseFromJson(json);

@override final  Message userMessage;
@override final  Message assistantMessage;
@override final  Conversation conversation;

/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageResponseCopyWith<_SendMessageResponse> get copyWith => __$SendMessageResponseCopyWithImpl<_SendMessageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendMessageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessageResponse&&(identical(other.userMessage, userMessage) || other.userMessage == userMessage)&&(identical(other.assistantMessage, assistantMessage) || other.assistantMessage == assistantMessage)&&(identical(other.conversation, conversation) || other.conversation == conversation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userMessage,assistantMessage,conversation);

@override
String toString() {
  return 'SendMessageResponse(userMessage: $userMessage, assistantMessage: $assistantMessage, conversation: $conversation)';
}


}

/// @nodoc
abstract mixin class _$SendMessageResponseCopyWith<$Res> implements $SendMessageResponseCopyWith<$Res> {
  factory _$SendMessageResponseCopyWith(_SendMessageResponse value, $Res Function(_SendMessageResponse) _then) = __$SendMessageResponseCopyWithImpl;
@override @useResult
$Res call({
 Message userMessage, Message assistantMessage, Conversation conversation
});


@override $MessageCopyWith<$Res> get userMessage;@override $MessageCopyWith<$Res> get assistantMessage;@override $ConversationCopyWith<$Res> get conversation;

}
/// @nodoc
class __$SendMessageResponseCopyWithImpl<$Res>
    implements _$SendMessageResponseCopyWith<$Res> {
  __$SendMessageResponseCopyWithImpl(this._self, this._then);

  final _SendMessageResponse _self;
  final $Res Function(_SendMessageResponse) _then;

/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userMessage = null,Object? assistantMessage = null,Object? conversation = null,}) {
  return _then(_SendMessageResponse(
userMessage: null == userMessage ? _self.userMessage : userMessage // ignore: cast_nullable_to_non_nullable
as Message,assistantMessage: null == assistantMessage ? _self.assistantMessage : assistantMessage // ignore: cast_nullable_to_non_nullable
as Message,conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as Conversation,
  ));
}

/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res> get userMessage {
  
  return $MessageCopyWith<$Res>(_self.userMessage, (value) {
    return _then(_self.copyWith(userMessage: value));
  });
}/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res> get assistantMessage {
  
  return $MessageCopyWith<$Res>(_self.assistantMessage, (value) {
    return _then(_self.copyWith(assistantMessage: value));
  });
}/// Create a copy of SendMessageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationCopyWith<$Res> get conversation {
  
  return $ConversationCopyWith<$Res>(_self.conversation, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}
}


/// @nodoc
mixin _$CreateConversationRequest {

 String? get title; String? get initialMessage; ConversationMetadata? get metadata;
/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateConversationRequestCopyWith<CreateConversationRequest> get copyWith => _$CreateConversationRequestCopyWithImpl<CreateConversationRequest>(this as CreateConversationRequest, _$identity);

  /// Serializes this CreateConversationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateConversationRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.initialMessage, initialMessage) || other.initialMessage == initialMessage)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,initialMessage,metadata);

@override
String toString() {
  return 'CreateConversationRequest(title: $title, initialMessage: $initialMessage, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CreateConversationRequestCopyWith<$Res>  {
  factory $CreateConversationRequestCopyWith(CreateConversationRequest value, $Res Function(CreateConversationRequest) _then) = _$CreateConversationRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? initialMessage, ConversationMetadata? metadata
});


$ConversationMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$CreateConversationRequestCopyWithImpl<$Res>
    implements $CreateConversationRequestCopyWith<$Res> {
  _$CreateConversationRequestCopyWithImpl(this._self, this._then);

  final CreateConversationRequest _self;
  final $Res Function(CreateConversationRequest) _then;

/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? initialMessage = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,initialMessage: freezed == initialMessage ? _self.initialMessage : initialMessage // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ConversationMetadata?,
  ));
}
/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $ConversationMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateConversationRequest].
extension CreateConversationRequestPatterns on CreateConversationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateConversationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateConversationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateConversationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateConversationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateConversationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateConversationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? initialMessage,  ConversationMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateConversationRequest() when $default != null:
return $default(_that.title,_that.initialMessage,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? initialMessage,  ConversationMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequest():
return $default(_that.title,_that.initialMessage,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? initialMessage,  ConversationMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _CreateConversationRequest() when $default != null:
return $default(_that.title,_that.initialMessage,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateConversationRequest implements CreateConversationRequest {
  const _CreateConversationRequest({this.title, this.initialMessage, this.metadata});
  factory _CreateConversationRequest.fromJson(Map<String, dynamic> json) => _$CreateConversationRequestFromJson(json);

@override final  String? title;
@override final  String? initialMessage;
@override final  ConversationMetadata? metadata;

/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateConversationRequestCopyWith<_CreateConversationRequest> get copyWith => __$CreateConversationRequestCopyWithImpl<_CreateConversationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateConversationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateConversationRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.initialMessage, initialMessage) || other.initialMessage == initialMessage)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,initialMessage,metadata);

@override
String toString() {
  return 'CreateConversationRequest(title: $title, initialMessage: $initialMessage, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CreateConversationRequestCopyWith<$Res> implements $CreateConversationRequestCopyWith<$Res> {
  factory _$CreateConversationRequestCopyWith(_CreateConversationRequest value, $Res Function(_CreateConversationRequest) _then) = __$CreateConversationRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? initialMessage, ConversationMetadata? metadata
});


@override $ConversationMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$CreateConversationRequestCopyWithImpl<$Res>
    implements _$CreateConversationRequestCopyWith<$Res> {
  __$CreateConversationRequestCopyWithImpl(this._self, this._then);

  final _CreateConversationRequest _self;
  final $Res Function(_CreateConversationRequest) _then;

/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? initialMessage = freezed,Object? metadata = freezed,}) {
  return _then(_CreateConversationRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,initialMessage: freezed == initialMessage ? _self.initialMessage : initialMessage // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ConversationMetadata?,
  ));
}

/// Create a copy of CreateConversationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $ConversationMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
