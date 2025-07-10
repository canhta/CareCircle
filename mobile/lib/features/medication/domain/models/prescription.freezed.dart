// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prescription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OCRMedicationData {

 String? get name; String? get strength; String? get quantity; String? get instructions; double get confidence;
/// Create a copy of OCRMedicationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRMedicationDataCopyWith<OCRMedicationData> get copyWith => _$OCRMedicationDataCopyWithImpl<OCRMedicationData>(this as OCRMedicationData, _$identity);

  /// Serializes this OCRMedicationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRMedicationData&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,strength,quantity,instructions,confidence);

@override
String toString() {
  return 'OCRMedicationData(name: $name, strength: $strength, quantity: $quantity, instructions: $instructions, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $OCRMedicationDataCopyWith<$Res>  {
  factory $OCRMedicationDataCopyWith(OCRMedicationData value, $Res Function(OCRMedicationData) _then) = _$OCRMedicationDataCopyWithImpl;
@useResult
$Res call({
 String? name, String? strength, String? quantity, String? instructions, double confidence
});




}
/// @nodoc
class _$OCRMedicationDataCopyWithImpl<$Res>
    implements $OCRMedicationDataCopyWith<$Res> {
  _$OCRMedicationDataCopyWithImpl(this._self, this._then);

  final OCRMedicationData _self;
  final $Res Function(OCRMedicationData) _then;

/// Create a copy of OCRMedicationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? strength = freezed,Object? quantity = freezed,Object? instructions = freezed,Object? confidence = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OCRMedicationData].
extension OCRMedicationDataPatterns on OCRMedicationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRMedicationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRMedicationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRMedicationData value)  $default,){
final _that = this;
switch (_that) {
case _OCRMedicationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRMedicationData value)?  $default,){
final _that = this;
switch (_that) {
case _OCRMedicationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? strength,  String? quantity,  String? instructions,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRMedicationData() when $default != null:
return $default(_that.name,_that.strength,_that.quantity,_that.instructions,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? strength,  String? quantity,  String? instructions,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _OCRMedicationData():
return $default(_that.name,_that.strength,_that.quantity,_that.instructions,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? strength,  String? quantity,  String? instructions,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _OCRMedicationData() when $default != null:
return $default(_that.name,_that.strength,_that.quantity,_that.instructions,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRMedicationData implements OCRMedicationData {
  const _OCRMedicationData({this.name, this.strength, this.quantity, this.instructions, required this.confidence});
  factory _OCRMedicationData.fromJson(Map<String, dynamic> json) => _$OCRMedicationDataFromJson(json);

@override final  String? name;
@override final  String? strength;
@override final  String? quantity;
@override final  String? instructions;
@override final  double confidence;

/// Create a copy of OCRMedicationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRMedicationDataCopyWith<_OCRMedicationData> get copyWith => __$OCRMedicationDataCopyWithImpl<_OCRMedicationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRMedicationDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRMedicationData&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,strength,quantity,instructions,confidence);

@override
String toString() {
  return 'OCRMedicationData(name: $name, strength: $strength, quantity: $quantity, instructions: $instructions, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$OCRMedicationDataCopyWith<$Res> implements $OCRMedicationDataCopyWith<$Res> {
  factory _$OCRMedicationDataCopyWith(_OCRMedicationData value, $Res Function(_OCRMedicationData) _then) = __$OCRMedicationDataCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? strength, String? quantity, String? instructions, double confidence
});




}
/// @nodoc
class __$OCRMedicationDataCopyWithImpl<$Res>
    implements _$OCRMedicationDataCopyWith<$Res> {
  __$OCRMedicationDataCopyWithImpl(this._self, this._then);

  final _OCRMedicationData _self;
  final $Res Function(_OCRMedicationData) _then;

/// Create a copy of OCRMedicationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? strength = freezed,Object? quantity = freezed,Object? instructions = freezed,Object? confidence = null,}) {
  return _then(_OCRMedicationData(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OCRFields {

 String? get prescribedBy; String? get prescribedDate; String? get pharmacy; List<OCRMedicationData> get medications;
/// Create a copy of OCRFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRFieldsCopyWith<OCRFields> get copyWith => _$OCRFieldsCopyWithImpl<OCRFields>(this as OCRFields, _$identity);

  /// Serializes this OCRFields to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRFields&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&const DeepCollectionEquality().equals(other.medications, medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,const DeepCollectionEquality().hash(medications));

@override
String toString() {
  return 'OCRFields(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class $OCRFieldsCopyWith<$Res>  {
  factory $OCRFieldsCopyWith(OCRFields value, $Res Function(OCRFields) _then) = _$OCRFieldsCopyWithImpl;
@useResult
$Res call({
 String? prescribedBy, String? prescribedDate, String? pharmacy, List<OCRMedicationData> medications
});




}
/// @nodoc
class _$OCRFieldsCopyWithImpl<$Res>
    implements $OCRFieldsCopyWith<$Res> {
  _$OCRFieldsCopyWithImpl(this._self, this._then);

  final OCRFields _self;
  final $Res Function(OCRFields) _then;

/// Create a copy of OCRFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prescribedBy = freezed,Object? prescribedDate = freezed,Object? pharmacy = freezed,Object? medications = null,}) {
  return _then(_self.copyWith(
prescribedBy: freezed == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String?,prescribedDate: freezed == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as String?,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<OCRMedicationData>,
  ));
}

}


/// Adds pattern-matching-related methods to [OCRFields].
extension OCRFieldsPatterns on OCRFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRFields value)  $default,){
final _that = this;
switch (_that) {
case _OCRFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRFields value)?  $default,){
final _that = this;
switch (_that) {
case _OCRFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? prescribedBy,  String? prescribedDate,  String? pharmacy,  List<OCRMedicationData> medications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRFields() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.medications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? prescribedBy,  String? prescribedDate,  String? pharmacy,  List<OCRMedicationData> medications)  $default,) {final _that = this;
switch (_that) {
case _OCRFields():
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.medications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? prescribedBy,  String? prescribedDate,  String? pharmacy,  List<OCRMedicationData> medications)?  $default,) {final _that = this;
switch (_that) {
case _OCRFields() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.medications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRFields implements OCRFields {
  const _OCRFields({this.prescribedBy, this.prescribedDate, this.pharmacy, final  List<OCRMedicationData> medications = const []}): _medications = medications;
  factory _OCRFields.fromJson(Map<String, dynamic> json) => _$OCRFieldsFromJson(json);

@override final  String? prescribedBy;
@override final  String? prescribedDate;
@override final  String? pharmacy;
 final  List<OCRMedicationData> _medications;
@override@JsonKey() List<OCRMedicationData> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}


/// Create a copy of OCRFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRFieldsCopyWith<_OCRFields> get copyWith => __$OCRFieldsCopyWithImpl<_OCRFields>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRFieldsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRFields&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&const DeepCollectionEquality().equals(other._medications, _medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,const DeepCollectionEquality().hash(_medications));

@override
String toString() {
  return 'OCRFields(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class _$OCRFieldsCopyWith<$Res> implements $OCRFieldsCopyWith<$Res> {
  factory _$OCRFieldsCopyWith(_OCRFields value, $Res Function(_OCRFields) _then) = __$OCRFieldsCopyWithImpl;
@override @useResult
$Res call({
 String? prescribedBy, String? prescribedDate, String? pharmacy, List<OCRMedicationData> medications
});




}
/// @nodoc
class __$OCRFieldsCopyWithImpl<$Res>
    implements _$OCRFieldsCopyWith<$Res> {
  __$OCRFieldsCopyWithImpl(this._self, this._then);

  final _OCRFields _self;
  final $Res Function(_OCRFields) _then;

/// Create a copy of OCRFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prescribedBy = freezed,Object? prescribedDate = freezed,Object? pharmacy = freezed,Object? medications = null,}) {
  return _then(_OCRFields(
prescribedBy: freezed == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String?,prescribedDate: freezed == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as String?,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<OCRMedicationData>,
  ));
}


}


/// @nodoc
mixin _$ProcessingMetadata {

 String get ocrEngine; double get processingTime; double get imageQuality; String get extractionMethod;
/// Create a copy of ProcessingMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessingMetadataCopyWith<ProcessingMetadata> get copyWith => _$ProcessingMetadataCopyWithImpl<ProcessingMetadata>(this as ProcessingMetadata, _$identity);

  /// Serializes this ProcessingMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessingMetadata&&(identical(other.ocrEngine, ocrEngine) || other.ocrEngine == ocrEngine)&&(identical(other.processingTime, processingTime) || other.processingTime == processingTime)&&(identical(other.imageQuality, imageQuality) || other.imageQuality == imageQuality)&&(identical(other.extractionMethod, extractionMethod) || other.extractionMethod == extractionMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ocrEngine,processingTime,imageQuality,extractionMethod);

@override
String toString() {
  return 'ProcessingMetadata(ocrEngine: $ocrEngine, processingTime: $processingTime, imageQuality: $imageQuality, extractionMethod: $extractionMethod)';
}


}

/// @nodoc
abstract mixin class $ProcessingMetadataCopyWith<$Res>  {
  factory $ProcessingMetadataCopyWith(ProcessingMetadata value, $Res Function(ProcessingMetadata) _then) = _$ProcessingMetadataCopyWithImpl;
@useResult
$Res call({
 String ocrEngine, double processingTime, double imageQuality, String extractionMethod
});




}
/// @nodoc
class _$ProcessingMetadataCopyWithImpl<$Res>
    implements $ProcessingMetadataCopyWith<$Res> {
  _$ProcessingMetadataCopyWithImpl(this._self, this._then);

  final ProcessingMetadata _self;
  final $Res Function(ProcessingMetadata) _then;

/// Create a copy of ProcessingMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ocrEngine = null,Object? processingTime = null,Object? imageQuality = null,Object? extractionMethod = null,}) {
  return _then(_self.copyWith(
ocrEngine: null == ocrEngine ? _self.ocrEngine : ocrEngine // ignore: cast_nullable_to_non_nullable
as String,processingTime: null == processingTime ? _self.processingTime : processingTime // ignore: cast_nullable_to_non_nullable
as double,imageQuality: null == imageQuality ? _self.imageQuality : imageQuality // ignore: cast_nullable_to_non_nullable
as double,extractionMethod: null == extractionMethod ? _self.extractionMethod : extractionMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcessingMetadata].
extension ProcessingMetadataPatterns on ProcessingMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcessingMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcessingMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcessingMetadata value)  $default,){
final _that = this;
switch (_that) {
case _ProcessingMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcessingMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _ProcessingMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ocrEngine,  double processingTime,  double imageQuality,  String extractionMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcessingMetadata() when $default != null:
return $default(_that.ocrEngine,_that.processingTime,_that.imageQuality,_that.extractionMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ocrEngine,  double processingTime,  double imageQuality,  String extractionMethod)  $default,) {final _that = this;
switch (_that) {
case _ProcessingMetadata():
return $default(_that.ocrEngine,_that.processingTime,_that.imageQuality,_that.extractionMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ocrEngine,  double processingTime,  double imageQuality,  String extractionMethod)?  $default,) {final _that = this;
switch (_that) {
case _ProcessingMetadata() when $default != null:
return $default(_that.ocrEngine,_that.processingTime,_that.imageQuality,_that.extractionMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcessingMetadata implements ProcessingMetadata {
  const _ProcessingMetadata({required this.ocrEngine, required this.processingTime, required this.imageQuality, required this.extractionMethod});
  factory _ProcessingMetadata.fromJson(Map<String, dynamic> json) => _$ProcessingMetadataFromJson(json);

@override final  String ocrEngine;
@override final  double processingTime;
@override final  double imageQuality;
@override final  String extractionMethod;

/// Create a copy of ProcessingMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcessingMetadataCopyWith<_ProcessingMetadata> get copyWith => __$ProcessingMetadataCopyWithImpl<_ProcessingMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcessingMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcessingMetadata&&(identical(other.ocrEngine, ocrEngine) || other.ocrEngine == ocrEngine)&&(identical(other.processingTime, processingTime) || other.processingTime == processingTime)&&(identical(other.imageQuality, imageQuality) || other.imageQuality == imageQuality)&&(identical(other.extractionMethod, extractionMethod) || other.extractionMethod == extractionMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ocrEngine,processingTime,imageQuality,extractionMethod);

@override
String toString() {
  return 'ProcessingMetadata(ocrEngine: $ocrEngine, processingTime: $processingTime, imageQuality: $imageQuality, extractionMethod: $extractionMethod)';
}


}

/// @nodoc
abstract mixin class _$ProcessingMetadataCopyWith<$Res> implements $ProcessingMetadataCopyWith<$Res> {
  factory _$ProcessingMetadataCopyWith(_ProcessingMetadata value, $Res Function(_ProcessingMetadata) _then) = __$ProcessingMetadataCopyWithImpl;
@override @useResult
$Res call({
 String ocrEngine, double processingTime, double imageQuality, String extractionMethod
});




}
/// @nodoc
class __$ProcessingMetadataCopyWithImpl<$Res>
    implements _$ProcessingMetadataCopyWith<$Res> {
  __$ProcessingMetadataCopyWithImpl(this._self, this._then);

  final _ProcessingMetadata _self;
  final $Res Function(_ProcessingMetadata) _then;

/// Create a copy of ProcessingMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ocrEngine = null,Object? processingTime = null,Object? imageQuality = null,Object? extractionMethod = null,}) {
  return _then(_ProcessingMetadata(
ocrEngine: null == ocrEngine ? _self.ocrEngine : ocrEngine // ignore: cast_nullable_to_non_nullable
as String,processingTime: null == processingTime ? _self.processingTime : processingTime // ignore: cast_nullable_to_non_nullable
as double,imageQuality: null == imageQuality ? _self.imageQuality : imageQuality // ignore: cast_nullable_to_non_nullable
as double,extractionMethod: null == extractionMethod ? _self.extractionMethod : extractionMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OCRData {

 String get extractedText; double get confidence; OCRFields get fields; ProcessingMetadata get processingMetadata;
/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRDataCopyWith<OCRData> get copyWith => _$OCRDataCopyWithImpl<OCRData>(this as OCRData, _$identity);

  /// Serializes this OCRData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRData&&(identical(other.extractedText, extractedText) || other.extractedText == extractedText)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.fields, fields) || other.fields == fields)&&(identical(other.processingMetadata, processingMetadata) || other.processingMetadata == processingMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extractedText,confidence,fields,processingMetadata);

@override
String toString() {
  return 'OCRData(extractedText: $extractedText, confidence: $confidence, fields: $fields, processingMetadata: $processingMetadata)';
}


}

/// @nodoc
abstract mixin class $OCRDataCopyWith<$Res>  {
  factory $OCRDataCopyWith(OCRData value, $Res Function(OCRData) _then) = _$OCRDataCopyWithImpl;
@useResult
$Res call({
 String extractedText, double confidence, OCRFields fields, ProcessingMetadata processingMetadata
});


$OCRFieldsCopyWith<$Res> get fields;$ProcessingMetadataCopyWith<$Res> get processingMetadata;

}
/// @nodoc
class _$OCRDataCopyWithImpl<$Res>
    implements $OCRDataCopyWith<$Res> {
  _$OCRDataCopyWithImpl(this._self, this._then);

  final OCRData _self;
  final $Res Function(OCRData) _then;

/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extractedText = null,Object? confidence = null,Object? fields = null,Object? processingMetadata = null,}) {
  return _then(_self.copyWith(
extractedText: null == extractedText ? _self.extractedText : extractedText // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as OCRFields,processingMetadata: null == processingMetadata ? _self.processingMetadata : processingMetadata // ignore: cast_nullable_to_non_nullable
as ProcessingMetadata,
  ));
}
/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRFieldsCopyWith<$Res> get fields {
  
  return $OCRFieldsCopyWith<$Res>(_self.fields, (value) {
    return _then(_self.copyWith(fields: value));
  });
}/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProcessingMetadataCopyWith<$Res> get processingMetadata {
  
  return $ProcessingMetadataCopyWith<$Res>(_self.processingMetadata, (value) {
    return _then(_self.copyWith(processingMetadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [OCRData].
extension OCRDataPatterns on OCRData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRData value)  $default,){
final _that = this;
switch (_that) {
case _OCRData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRData value)?  $default,){
final _that = this;
switch (_that) {
case _OCRData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String extractedText,  double confidence,  OCRFields fields,  ProcessingMetadata processingMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRData() when $default != null:
return $default(_that.extractedText,_that.confidence,_that.fields,_that.processingMetadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String extractedText,  double confidence,  OCRFields fields,  ProcessingMetadata processingMetadata)  $default,) {final _that = this;
switch (_that) {
case _OCRData():
return $default(_that.extractedText,_that.confidence,_that.fields,_that.processingMetadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String extractedText,  double confidence,  OCRFields fields,  ProcessingMetadata processingMetadata)?  $default,) {final _that = this;
switch (_that) {
case _OCRData() when $default != null:
return $default(_that.extractedText,_that.confidence,_that.fields,_that.processingMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRData implements OCRData {
  const _OCRData({required this.extractedText, required this.confidence, required this.fields, required this.processingMetadata});
  factory _OCRData.fromJson(Map<String, dynamic> json) => _$OCRDataFromJson(json);

@override final  String extractedText;
@override final  double confidence;
@override final  OCRFields fields;
@override final  ProcessingMetadata processingMetadata;

/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRDataCopyWith<_OCRData> get copyWith => __$OCRDataCopyWithImpl<_OCRData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRData&&(identical(other.extractedText, extractedText) || other.extractedText == extractedText)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.fields, fields) || other.fields == fields)&&(identical(other.processingMetadata, processingMetadata) || other.processingMetadata == processingMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extractedText,confidence,fields,processingMetadata);

@override
String toString() {
  return 'OCRData(extractedText: $extractedText, confidence: $confidence, fields: $fields, processingMetadata: $processingMetadata)';
}


}

/// @nodoc
abstract mixin class _$OCRDataCopyWith<$Res> implements $OCRDataCopyWith<$Res> {
  factory _$OCRDataCopyWith(_OCRData value, $Res Function(_OCRData) _then) = __$OCRDataCopyWithImpl;
@override @useResult
$Res call({
 String extractedText, double confidence, OCRFields fields, ProcessingMetadata processingMetadata
});


@override $OCRFieldsCopyWith<$Res> get fields;@override $ProcessingMetadataCopyWith<$Res> get processingMetadata;

}
/// @nodoc
class __$OCRDataCopyWithImpl<$Res>
    implements _$OCRDataCopyWith<$Res> {
  __$OCRDataCopyWithImpl(this._self, this._then);

  final _OCRData _self;
  final $Res Function(_OCRData) _then;

/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? extractedText = null,Object? confidence = null,Object? fields = null,Object? processingMetadata = null,}) {
  return _then(_OCRData(
extractedText: null == extractedText ? _self.extractedText : extractedText // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as OCRFields,processingMetadata: null == processingMetadata ? _self.processingMetadata : processingMetadata // ignore: cast_nullable_to_non_nullable
as ProcessingMetadata,
  ));
}

/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRFieldsCopyWith<$Res> get fields {
  
  return $OCRFieldsCopyWith<$Res>(_self.fields, (value) {
    return _then(_self.copyWith(fields: value));
  });
}/// Create a copy of OCRData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProcessingMetadataCopyWith<$Res> get processingMetadata {
  
  return $ProcessingMetadataCopyWith<$Res>(_self.processingMetadata, (value) {
    return _then(_self.copyWith(processingMetadata: value));
  });
}
}


/// @nodoc
mixin _$PrescriptionMedication {

 String get name; String get strength; String get form; String get dosage; int get quantity; String get instructions; String? get linkedMedicationId;
/// Create a copy of PrescriptionMedication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionMedicationCopyWith<PrescriptionMedication> get copyWith => _$PrescriptionMedicationCopyWithImpl<PrescriptionMedication>(this as PrescriptionMedication, _$identity);

  /// Serializes this PrescriptionMedication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionMedication&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.linkedMedicationId, linkedMedicationId) || other.linkedMedicationId == linkedMedicationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,strength,form,dosage,quantity,instructions,linkedMedicationId);

@override
String toString() {
  return 'PrescriptionMedication(name: $name, strength: $strength, form: $form, dosage: $dosage, quantity: $quantity, instructions: $instructions, linkedMedicationId: $linkedMedicationId)';
}


}

/// @nodoc
abstract mixin class $PrescriptionMedicationCopyWith<$Res>  {
  factory $PrescriptionMedicationCopyWith(PrescriptionMedication value, $Res Function(PrescriptionMedication) _then) = _$PrescriptionMedicationCopyWithImpl;
@useResult
$Res call({
 String name, String strength, String form, String dosage, int quantity, String instructions, String? linkedMedicationId
});




}
/// @nodoc
class _$PrescriptionMedicationCopyWithImpl<$Res>
    implements $PrescriptionMedicationCopyWith<$Res> {
  _$PrescriptionMedicationCopyWithImpl(this._self, this._then);

  final PrescriptionMedication _self;
  final $Res Function(PrescriptionMedication) _then;

/// Create a copy of PrescriptionMedication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? strength = null,Object? form = null,Object? dosage = null,Object? quantity = null,Object? instructions = null,Object? linkedMedicationId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,linkedMedicationId: freezed == linkedMedicationId ? _self.linkedMedicationId : linkedMedicationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionMedication].
extension PrescriptionMedicationPatterns on PrescriptionMedication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionMedication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionMedication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionMedication value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionMedication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionMedication value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionMedication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String strength,  String form,  String dosage,  int quantity,  String instructions,  String? linkedMedicationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionMedication() when $default != null:
return $default(_that.name,_that.strength,_that.form,_that.dosage,_that.quantity,_that.instructions,_that.linkedMedicationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String strength,  String form,  String dosage,  int quantity,  String instructions,  String? linkedMedicationId)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionMedication():
return $default(_that.name,_that.strength,_that.form,_that.dosage,_that.quantity,_that.instructions,_that.linkedMedicationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String strength,  String form,  String dosage,  int quantity,  String instructions,  String? linkedMedicationId)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionMedication() when $default != null:
return $default(_that.name,_that.strength,_that.form,_that.dosage,_that.quantity,_that.instructions,_that.linkedMedicationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionMedication implements PrescriptionMedication {
  const _PrescriptionMedication({required this.name, required this.strength, required this.form, required this.dosage, required this.quantity, required this.instructions, this.linkedMedicationId});
  factory _PrescriptionMedication.fromJson(Map<String, dynamic> json) => _$PrescriptionMedicationFromJson(json);

@override final  String name;
@override final  String strength;
@override final  String form;
@override final  String dosage;
@override final  int quantity;
@override final  String instructions;
@override final  String? linkedMedicationId;

/// Create a copy of PrescriptionMedication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionMedicationCopyWith<_PrescriptionMedication> get copyWith => __$PrescriptionMedicationCopyWithImpl<_PrescriptionMedication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionMedicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionMedication&&(identical(other.name, name) || other.name == name)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.linkedMedicationId, linkedMedicationId) || other.linkedMedicationId == linkedMedicationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,strength,form,dosage,quantity,instructions,linkedMedicationId);

@override
String toString() {
  return 'PrescriptionMedication(name: $name, strength: $strength, form: $form, dosage: $dosage, quantity: $quantity, instructions: $instructions, linkedMedicationId: $linkedMedicationId)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionMedicationCopyWith<$Res> implements $PrescriptionMedicationCopyWith<$Res> {
  factory _$PrescriptionMedicationCopyWith(_PrescriptionMedication value, $Res Function(_PrescriptionMedication) _then) = __$PrescriptionMedicationCopyWithImpl;
@override @useResult
$Res call({
 String name, String strength, String form, String dosage, int quantity, String instructions, String? linkedMedicationId
});




}
/// @nodoc
class __$PrescriptionMedicationCopyWithImpl<$Res>
    implements _$PrescriptionMedicationCopyWith<$Res> {
  __$PrescriptionMedicationCopyWithImpl(this._self, this._then);

  final _PrescriptionMedication _self;
  final $Res Function(_PrescriptionMedication) _then;

/// Create a copy of PrescriptionMedication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? strength = null,Object? form = null,Object? dosage = null,Object? quantity = null,Object? instructions = null,Object? linkedMedicationId = freezed,}) {
  return _then(_PrescriptionMedication(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,linkedMedicationId: freezed == linkedMedicationId ? _self.linkedMedicationId : linkedMedicationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Prescription {

 String get id; String get userId; String get prescribedBy; DateTime get prescribedDate; String? get pharmacy; OCRData? get ocrData; String? get imageUrl; bool get isVerified; DateTime? get verifiedAt; String? get verifiedBy; List<PrescriptionMedication> get medications; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionCopyWith<Prescription> get copyWith => _$PrescriptionCopyWithImpl<Prescription>(this as Prescription, _$identity);

  /// Serializes this Prescription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other.medications, medications)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(medications),createdAt,updatedAt);

@override
String toString() {
  return 'Prescription(id: $id, userId: $userId, prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PrescriptionCopyWith<$Res>  {
  factory $PrescriptionCopyWith(Prescription value, $Res Function(Prescription) _then) = _$PrescriptionCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String prescribedBy, DateTime prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication> medications, DateTime createdAt, DateTime updatedAt
});


$OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class _$PrescriptionCopyWithImpl<$Res>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._self, this._then);

  final Prescription _self;
  final $Res Function(Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? prescribedBy = null,Object? prescribedDate = null,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,prescribedBy: null == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String,prescribedDate: null == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// Adds pattern-matching-related methods to [Prescription].
extension PrescriptionPatterns on Prescription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prescription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prescription value)  $default,){
final _that = this;
switch (_that) {
case _Prescription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prescription value)?  $default,){
final _that = this;
switch (_that) {
case _Prescription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.userId,_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Prescription():
return $default(_that.id,_that.userId,_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Prescription() when $default != null:
return $default(_that.id,_that.userId,_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prescription implements Prescription {
  const _Prescription({required this.id, required this.userId, required this.prescribedBy, required this.prescribedDate, this.pharmacy, this.ocrData, this.imageUrl, this.isVerified = false, this.verifiedAt, this.verifiedBy, final  List<PrescriptionMedication> medications = const [], required this.createdAt, required this.updatedAt}): _medications = medications;
  factory _Prescription.fromJson(Map<String, dynamic> json) => _$PrescriptionFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String prescribedBy;
@override final  DateTime prescribedDate;
@override final  String? pharmacy;
@override final  OCRData? ocrData;
@override final  String? imageUrl;
@override@JsonKey() final  bool isVerified;
@override final  DateTime? verifiedAt;
@override final  String? verifiedBy;
 final  List<PrescriptionMedication> _medications;
@override@JsonKey() List<PrescriptionMedication> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionCopyWith<_Prescription> get copyWith => __$PrescriptionCopyWithImpl<_Prescription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prescription&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other._medications, _medications)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(_medications),createdAt,updatedAt);

@override
String toString() {
  return 'Prescription(id: $id, userId: $userId, prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionCopyWith<$Res> implements $PrescriptionCopyWith<$Res> {
  factory _$PrescriptionCopyWith(_Prescription value, $Res Function(_Prescription) _then) = __$PrescriptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String prescribedBy, DateTime prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication> medications, DateTime createdAt, DateTime updatedAt
});


@override $OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class __$PrescriptionCopyWithImpl<$Res>
    implements _$PrescriptionCopyWith<$Res> {
  __$PrescriptionCopyWithImpl(this._self, this._then);

  final _Prescription _self;
  final $Res Function(_Prescription) _then;

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? prescribedBy = null,Object? prescribedDate = null,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Prescription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,prescribedBy: null == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String,prescribedDate: null == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Prescription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// @nodoc
mixin _$CreatePrescriptionRequest {

 String get prescribedBy; DateTime get prescribedDate; String? get pharmacy; OCRData? get ocrData; String? get imageUrl; bool get isVerified; DateTime? get verifiedAt; String? get verifiedBy; List<PrescriptionMedication> get medications;
/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePrescriptionRequestCopyWith<CreatePrescriptionRequest> get copyWith => _$CreatePrescriptionRequestCopyWithImpl<CreatePrescriptionRequest>(this as CreatePrescriptionRequest, _$identity);

  /// Serializes this CreatePrescriptionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePrescriptionRequest&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other.medications, medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(medications));

@override
String toString() {
  return 'CreatePrescriptionRequest(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class $CreatePrescriptionRequestCopyWith<$Res>  {
  factory $CreatePrescriptionRequestCopyWith(CreatePrescriptionRequest value, $Res Function(CreatePrescriptionRequest) _then) = _$CreatePrescriptionRequestCopyWithImpl;
@useResult
$Res call({
 String prescribedBy, DateTime prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication> medications
});


$OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class _$CreatePrescriptionRequestCopyWithImpl<$Res>
    implements $CreatePrescriptionRequestCopyWith<$Res> {
  _$CreatePrescriptionRequestCopyWithImpl(this._self, this._then);

  final CreatePrescriptionRequest _self;
  final $Res Function(CreatePrescriptionRequest) _then;

/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prescribedBy = null,Object? prescribedDate = null,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = null,}) {
  return _then(_self.copyWith(
prescribedBy: null == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String,prescribedDate: null == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,
  ));
}
/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePrescriptionRequest].
extension CreatePrescriptionRequestPatterns on CreatePrescriptionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePrescriptionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePrescriptionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePrescriptionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreatePrescriptionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePrescriptionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePrescriptionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePrescriptionRequest() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications)  $default,) {final _that = this;
switch (_that) {
case _CreatePrescriptionRequest():
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String prescribedBy,  DateTime prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication> medications)?  $default,) {final _that = this;
switch (_that) {
case _CreatePrescriptionRequest() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePrescriptionRequest implements CreatePrescriptionRequest {
  const _CreatePrescriptionRequest({required this.prescribedBy, required this.prescribedDate, this.pharmacy, this.ocrData, this.imageUrl, this.isVerified = false, this.verifiedAt, this.verifiedBy, final  List<PrescriptionMedication> medications = const []}): _medications = medications;
  factory _CreatePrescriptionRequest.fromJson(Map<String, dynamic> json) => _$CreatePrescriptionRequestFromJson(json);

@override final  String prescribedBy;
@override final  DateTime prescribedDate;
@override final  String? pharmacy;
@override final  OCRData? ocrData;
@override final  String? imageUrl;
@override@JsonKey() final  bool isVerified;
@override final  DateTime? verifiedAt;
@override final  String? verifiedBy;
 final  List<PrescriptionMedication> _medications;
@override@JsonKey() List<PrescriptionMedication> get medications {
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medications);
}


/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePrescriptionRequestCopyWith<_CreatePrescriptionRequest> get copyWith => __$CreatePrescriptionRequestCopyWithImpl<_CreatePrescriptionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePrescriptionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePrescriptionRequest&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other._medications, _medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(_medications));

@override
String toString() {
  return 'CreatePrescriptionRequest(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class _$CreatePrescriptionRequestCopyWith<$Res> implements $CreatePrescriptionRequestCopyWith<$Res> {
  factory _$CreatePrescriptionRequestCopyWith(_CreatePrescriptionRequest value, $Res Function(_CreatePrescriptionRequest) _then) = __$CreatePrescriptionRequestCopyWithImpl;
@override @useResult
$Res call({
 String prescribedBy, DateTime prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication> medications
});


@override $OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class __$CreatePrescriptionRequestCopyWithImpl<$Res>
    implements _$CreatePrescriptionRequestCopyWith<$Res> {
  __$CreatePrescriptionRequestCopyWithImpl(this._self, this._then);

  final _CreatePrescriptionRequest _self;
  final $Res Function(_CreatePrescriptionRequest) _then;

/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prescribedBy = null,Object? prescribedDate = null,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = null,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = null,}) {
  return _then(_CreatePrescriptionRequest(
prescribedBy: null == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String,prescribedDate: null == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: null == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,
  ));
}

/// Create a copy of CreatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// @nodoc
mixin _$UpdatePrescriptionRequest {

 String? get prescribedBy; DateTime? get prescribedDate; String? get pharmacy; OCRData? get ocrData; String? get imageUrl; bool? get isVerified; DateTime? get verifiedAt; String? get verifiedBy; List<PrescriptionMedication>? get medications;
/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePrescriptionRequestCopyWith<UpdatePrescriptionRequest> get copyWith => _$UpdatePrescriptionRequestCopyWithImpl<UpdatePrescriptionRequest>(this as UpdatePrescriptionRequest, _$identity);

  /// Serializes this UpdatePrescriptionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePrescriptionRequest&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other.medications, medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(medications));

@override
String toString() {
  return 'UpdatePrescriptionRequest(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class $UpdatePrescriptionRequestCopyWith<$Res>  {
  factory $UpdatePrescriptionRequestCopyWith(UpdatePrescriptionRequest value, $Res Function(UpdatePrescriptionRequest) _then) = _$UpdatePrescriptionRequestCopyWithImpl;
@useResult
$Res call({
 String? prescribedBy, DateTime? prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool? isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication>? medications
});


$OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class _$UpdatePrescriptionRequestCopyWithImpl<$Res>
    implements $UpdatePrescriptionRequestCopyWith<$Res> {
  _$UpdatePrescriptionRequestCopyWithImpl(this._self, this._then);

  final UpdatePrescriptionRequest _self;
  final $Res Function(UpdatePrescriptionRequest) _then;

/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prescribedBy = freezed,Object? prescribedDate = freezed,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = freezed,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = freezed,}) {
  return _then(_self.copyWith(
prescribedBy: freezed == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String?,prescribedDate: freezed == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: freezed == medications ? _self.medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>?,
  ));
}
/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdatePrescriptionRequest].
extension UpdatePrescriptionRequestPatterns on UpdatePrescriptionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePrescriptionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePrescriptionRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePrescriptionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? prescribedBy,  DateTime? prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool? isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication>? medications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? prescribedBy,  DateTime? prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool? isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication>? medications)  $default,) {final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest():
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? prescribedBy,  DateTime? prescribedDate,  String? pharmacy,  OCRData? ocrData,  String? imageUrl,  bool? isVerified,  DateTime? verifiedAt,  String? verifiedBy,  List<PrescriptionMedication>? medications)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePrescriptionRequest() when $default != null:
return $default(_that.prescribedBy,_that.prescribedDate,_that.pharmacy,_that.ocrData,_that.imageUrl,_that.isVerified,_that.verifiedAt,_that.verifiedBy,_that.medications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePrescriptionRequest implements UpdatePrescriptionRequest {
  const _UpdatePrescriptionRequest({this.prescribedBy, this.prescribedDate, this.pharmacy, this.ocrData, this.imageUrl, this.isVerified, this.verifiedAt, this.verifiedBy, final  List<PrescriptionMedication>? medications}): _medications = medications;
  factory _UpdatePrescriptionRequest.fromJson(Map<String, dynamic> json) => _$UpdatePrescriptionRequestFromJson(json);

@override final  String? prescribedBy;
@override final  DateTime? prescribedDate;
@override final  String? pharmacy;
@override final  OCRData? ocrData;
@override final  String? imageUrl;
@override final  bool? isVerified;
@override final  DateTime? verifiedAt;
@override final  String? verifiedBy;
 final  List<PrescriptionMedication>? _medications;
@override List<PrescriptionMedication>? get medications {
  final value = _medications;
  if (value == null) return null;
  if (_medications is EqualUnmodifiableListView) return _medications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePrescriptionRequestCopyWith<_UpdatePrescriptionRequest> get copyWith => __$UpdatePrescriptionRequestCopyWithImpl<_UpdatePrescriptionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePrescriptionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePrescriptionRequest&&(identical(other.prescribedBy, prescribedBy) || other.prescribedBy == prescribedBy)&&(identical(other.prescribedDate, prescribedDate) || other.prescribedDate == prescribedDate)&&(identical(other.pharmacy, pharmacy) || other.pharmacy == pharmacy)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.verifiedBy, verifiedBy) || other.verifiedBy == verifiedBy)&&const DeepCollectionEquality().equals(other._medications, _medications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prescribedBy,prescribedDate,pharmacy,ocrData,imageUrl,isVerified,verifiedAt,verifiedBy,const DeepCollectionEquality().hash(_medications));

@override
String toString() {
  return 'UpdatePrescriptionRequest(prescribedBy: $prescribedBy, prescribedDate: $prescribedDate, pharmacy: $pharmacy, ocrData: $ocrData, imageUrl: $imageUrl, isVerified: $isVerified, verifiedAt: $verifiedAt, verifiedBy: $verifiedBy, medications: $medications)';
}


}

/// @nodoc
abstract mixin class _$UpdatePrescriptionRequestCopyWith<$Res> implements $UpdatePrescriptionRequestCopyWith<$Res> {
  factory _$UpdatePrescriptionRequestCopyWith(_UpdatePrescriptionRequest value, $Res Function(_UpdatePrescriptionRequest) _then) = __$UpdatePrescriptionRequestCopyWithImpl;
@override @useResult
$Res call({
 String? prescribedBy, DateTime? prescribedDate, String? pharmacy, OCRData? ocrData, String? imageUrl, bool? isVerified, DateTime? verifiedAt, String? verifiedBy, List<PrescriptionMedication>? medications
});


@override $OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class __$UpdatePrescriptionRequestCopyWithImpl<$Res>
    implements _$UpdatePrescriptionRequestCopyWith<$Res> {
  __$UpdatePrescriptionRequestCopyWithImpl(this._self, this._then);

  final _UpdatePrescriptionRequest _self;
  final $Res Function(_UpdatePrescriptionRequest) _then;

/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prescribedBy = freezed,Object? prescribedDate = freezed,Object? pharmacy = freezed,Object? ocrData = freezed,Object? imageUrl = freezed,Object? isVerified = freezed,Object? verifiedAt = freezed,Object? verifiedBy = freezed,Object? medications = freezed,}) {
  return _then(_UpdatePrescriptionRequest(
prescribedBy: freezed == prescribedBy ? _self.prescribedBy : prescribedBy // ignore: cast_nullable_to_non_nullable
as String?,prescribedDate: freezed == prescribedDate ? _self.prescribedDate : prescribedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,pharmacy: freezed == pharmacy ? _self.pharmacy : pharmacy // ignore: cast_nullable_to_non_nullable
as String?,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isVerified: freezed == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,verifiedBy: freezed == verifiedBy ? _self.verifiedBy : verifiedBy // ignore: cast_nullable_to_non_nullable
as String?,medications: freezed == medications ? _self._medications : medications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>?,
  ));
}

/// Create a copy of UpdatePrescriptionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// @nodoc
mixin _$OCRProcessingRequest {

 String? get imageUrl; String? get base64Image; bool get enhanceImage; bool get extractMedications;
/// Create a copy of OCRProcessingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRProcessingRequestCopyWith<OCRProcessingRequest> get copyWith => _$OCRProcessingRequestCopyWithImpl<OCRProcessingRequest>(this as OCRProcessingRequest, _$identity);

  /// Serializes this OCRProcessingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRProcessingRequest&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.base64Image, base64Image) || other.base64Image == base64Image)&&(identical(other.enhanceImage, enhanceImage) || other.enhanceImage == enhanceImage)&&(identical(other.extractMedications, extractMedications) || other.extractMedications == extractMedications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,base64Image,enhanceImage,extractMedications);

@override
String toString() {
  return 'OCRProcessingRequest(imageUrl: $imageUrl, base64Image: $base64Image, enhanceImage: $enhanceImage, extractMedications: $extractMedications)';
}


}

/// @nodoc
abstract mixin class $OCRProcessingRequestCopyWith<$Res>  {
  factory $OCRProcessingRequestCopyWith(OCRProcessingRequest value, $Res Function(OCRProcessingRequest) _then) = _$OCRProcessingRequestCopyWithImpl;
@useResult
$Res call({
 String? imageUrl, String? base64Image, bool enhanceImage, bool extractMedications
});




}
/// @nodoc
class _$OCRProcessingRequestCopyWithImpl<$Res>
    implements $OCRProcessingRequestCopyWith<$Res> {
  _$OCRProcessingRequestCopyWithImpl(this._self, this._then);

  final OCRProcessingRequest _self;
  final $Res Function(OCRProcessingRequest) _then;

/// Create a copy of OCRProcessingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = freezed,Object? base64Image = freezed,Object? enhanceImage = null,Object? extractMedications = null,}) {
  return _then(_self.copyWith(
imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,base64Image: freezed == base64Image ? _self.base64Image : base64Image // ignore: cast_nullable_to_non_nullable
as String?,enhanceImage: null == enhanceImage ? _self.enhanceImage : enhanceImage // ignore: cast_nullable_to_non_nullable
as bool,extractMedications: null == extractMedications ? _self.extractMedications : extractMedications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OCRProcessingRequest].
extension OCRProcessingRequestPatterns on OCRProcessingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRProcessingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRProcessingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRProcessingRequest value)  $default,){
final _that = this;
switch (_that) {
case _OCRProcessingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRProcessingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OCRProcessingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? imageUrl,  String? base64Image,  bool enhanceImage,  bool extractMedications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRProcessingRequest() when $default != null:
return $default(_that.imageUrl,_that.base64Image,_that.enhanceImage,_that.extractMedications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? imageUrl,  String? base64Image,  bool enhanceImage,  bool extractMedications)  $default,) {final _that = this;
switch (_that) {
case _OCRProcessingRequest():
return $default(_that.imageUrl,_that.base64Image,_that.enhanceImage,_that.extractMedications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? imageUrl,  String? base64Image,  bool enhanceImage,  bool extractMedications)?  $default,) {final _that = this;
switch (_that) {
case _OCRProcessingRequest() when $default != null:
return $default(_that.imageUrl,_that.base64Image,_that.enhanceImage,_that.extractMedications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRProcessingRequest implements OCRProcessingRequest {
  const _OCRProcessingRequest({this.imageUrl, this.base64Image, this.enhanceImage = false, this.extractMedications = false});
  factory _OCRProcessingRequest.fromJson(Map<String, dynamic> json) => _$OCRProcessingRequestFromJson(json);

@override final  String? imageUrl;
@override final  String? base64Image;
@override@JsonKey() final  bool enhanceImage;
@override@JsonKey() final  bool extractMedications;

/// Create a copy of OCRProcessingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRProcessingRequestCopyWith<_OCRProcessingRequest> get copyWith => __$OCRProcessingRequestCopyWithImpl<_OCRProcessingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRProcessingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRProcessingRequest&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.base64Image, base64Image) || other.base64Image == base64Image)&&(identical(other.enhanceImage, enhanceImage) || other.enhanceImage == enhanceImage)&&(identical(other.extractMedications, extractMedications) || other.extractMedications == extractMedications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,base64Image,enhanceImage,extractMedications);

@override
String toString() {
  return 'OCRProcessingRequest(imageUrl: $imageUrl, base64Image: $base64Image, enhanceImage: $enhanceImage, extractMedications: $extractMedications)';
}


}

/// @nodoc
abstract mixin class _$OCRProcessingRequestCopyWith<$Res> implements $OCRProcessingRequestCopyWith<$Res> {
  factory _$OCRProcessingRequestCopyWith(_OCRProcessingRequest value, $Res Function(_OCRProcessingRequest) _then) = __$OCRProcessingRequestCopyWithImpl;
@override @useResult
$Res call({
 String? imageUrl, String? base64Image, bool enhanceImage, bool extractMedications
});




}
/// @nodoc
class __$OCRProcessingRequestCopyWithImpl<$Res>
    implements _$OCRProcessingRequestCopyWith<$Res> {
  __$OCRProcessingRequestCopyWithImpl(this._self, this._then);

  final _OCRProcessingRequest _self;
  final $Res Function(_OCRProcessingRequest) _then;

/// Create a copy of OCRProcessingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = freezed,Object? base64Image = freezed,Object? enhanceImage = null,Object? extractMedications = null,}) {
  return _then(_OCRProcessingRequest(
imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,base64Image: freezed == base64Image ? _self.base64Image : base64Image // ignore: cast_nullable_to_non_nullable
as String?,enhanceImage: null == enhanceImage ? _self.enhanceImage : enhanceImage // ignore: cast_nullable_to_non_nullable
as bool,extractMedications: null == extractMedications ? _self.extractMedications : extractMedications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OCRProcessingResult {

 bool get success; OCRData? get ocrData; List<PrescriptionMedication> get extractedMedications; String? get error; String? get message;
/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OCRProcessingResultCopyWith<OCRProcessingResult> get copyWith => _$OCRProcessingResultCopyWithImpl<OCRProcessingResult>(this as OCRProcessingResult, _$identity);

  /// Serializes this OCRProcessingResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OCRProcessingResult&&(identical(other.success, success) || other.success == success)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&const DeepCollectionEquality().equals(other.extractedMedications, extractedMedications)&&(identical(other.error, error) || other.error == error)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,ocrData,const DeepCollectionEquality().hash(extractedMedications),error,message);

@override
String toString() {
  return 'OCRProcessingResult(success: $success, ocrData: $ocrData, extractedMedications: $extractedMedications, error: $error, message: $message)';
}


}

/// @nodoc
abstract mixin class $OCRProcessingResultCopyWith<$Res>  {
  factory $OCRProcessingResultCopyWith(OCRProcessingResult value, $Res Function(OCRProcessingResult) _then) = _$OCRProcessingResultCopyWithImpl;
@useResult
$Res call({
 bool success, OCRData? ocrData, List<PrescriptionMedication> extractedMedications, String? error, String? message
});


$OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class _$OCRProcessingResultCopyWithImpl<$Res>
    implements $OCRProcessingResultCopyWith<$Res> {
  _$OCRProcessingResultCopyWithImpl(this._self, this._then);

  final OCRProcessingResult _self;
  final $Res Function(OCRProcessingResult) _then;

/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? ocrData = freezed,Object? extractedMedications = null,Object? error = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,extractedMedications: null == extractedMedications ? _self.extractedMedications : extractedMedications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// Adds pattern-matching-related methods to [OCRProcessingResult].
extension OCRProcessingResultPatterns on OCRProcessingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OCRProcessingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OCRProcessingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OCRProcessingResult value)  $default,){
final _that = this;
switch (_that) {
case _OCRProcessingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OCRProcessingResult value)?  $default,){
final _that = this;
switch (_that) {
case _OCRProcessingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  OCRData? ocrData,  List<PrescriptionMedication> extractedMedications,  String? error,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OCRProcessingResult() when $default != null:
return $default(_that.success,_that.ocrData,_that.extractedMedications,_that.error,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  OCRData? ocrData,  List<PrescriptionMedication> extractedMedications,  String? error,  String? message)  $default,) {final _that = this;
switch (_that) {
case _OCRProcessingResult():
return $default(_that.success,_that.ocrData,_that.extractedMedications,_that.error,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  OCRData? ocrData,  List<PrescriptionMedication> extractedMedications,  String? error,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _OCRProcessingResult() when $default != null:
return $default(_that.success,_that.ocrData,_that.extractedMedications,_that.error,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OCRProcessingResult implements OCRProcessingResult {
  const _OCRProcessingResult({required this.success, this.ocrData, final  List<PrescriptionMedication> extractedMedications = const [], this.error, this.message}): _extractedMedications = extractedMedications;
  factory _OCRProcessingResult.fromJson(Map<String, dynamic> json) => _$OCRProcessingResultFromJson(json);

@override final  bool success;
@override final  OCRData? ocrData;
 final  List<PrescriptionMedication> _extractedMedications;
@override@JsonKey() List<PrescriptionMedication> get extractedMedications {
  if (_extractedMedications is EqualUnmodifiableListView) return _extractedMedications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extractedMedications);
}

@override final  String? error;
@override final  String? message;

/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OCRProcessingResultCopyWith<_OCRProcessingResult> get copyWith => __$OCRProcessingResultCopyWithImpl<_OCRProcessingResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OCRProcessingResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OCRProcessingResult&&(identical(other.success, success) || other.success == success)&&(identical(other.ocrData, ocrData) || other.ocrData == ocrData)&&const DeepCollectionEquality().equals(other._extractedMedications, _extractedMedications)&&(identical(other.error, error) || other.error == error)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,ocrData,const DeepCollectionEquality().hash(_extractedMedications),error,message);

@override
String toString() {
  return 'OCRProcessingResult(success: $success, ocrData: $ocrData, extractedMedications: $extractedMedications, error: $error, message: $message)';
}


}

/// @nodoc
abstract mixin class _$OCRProcessingResultCopyWith<$Res> implements $OCRProcessingResultCopyWith<$Res> {
  factory _$OCRProcessingResultCopyWith(_OCRProcessingResult value, $Res Function(_OCRProcessingResult) _then) = __$OCRProcessingResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, OCRData? ocrData, List<PrescriptionMedication> extractedMedications, String? error, String? message
});


@override $OCRDataCopyWith<$Res>? get ocrData;

}
/// @nodoc
class __$OCRProcessingResultCopyWithImpl<$Res>
    implements _$OCRProcessingResultCopyWith<$Res> {
  __$OCRProcessingResultCopyWithImpl(this._self, this._then);

  final _OCRProcessingResult _self;
  final $Res Function(_OCRProcessingResult) _then;

/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? ocrData = freezed,Object? extractedMedications = null,Object? error = freezed,Object? message = freezed,}) {
  return _then(_OCRProcessingResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,ocrData: freezed == ocrData ? _self.ocrData : ocrData // ignore: cast_nullable_to_non_nullable
as OCRData?,extractedMedications: null == extractedMedications ? _self._extractedMedications : extractedMedications // ignore: cast_nullable_to_non_nullable
as List<PrescriptionMedication>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OCRProcessingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OCRDataCopyWith<$Res>? get ocrData {
    if (_self.ocrData == null) {
    return null;
  }

  return $OCRDataCopyWith<$Res>(_self.ocrData!, (value) {
    return _then(_self.copyWith(ocrData: value));
  });
}
}


/// @nodoc
mixin _$PrescriptionResponse {

 bool get success; Prescription? get data; String? get message; String? get error;
/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionResponseCopyWith<PrescriptionResponse> get copyWith => _$PrescriptionResponseCopyWithImpl<PrescriptionResponse>(this as PrescriptionResponse, _$identity);

  /// Serializes this PrescriptionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'PrescriptionResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $PrescriptionResponseCopyWith<$Res>  {
  factory $PrescriptionResponseCopyWith(PrescriptionResponse value, $Res Function(PrescriptionResponse) _then) = _$PrescriptionResponseCopyWithImpl;
@useResult
$Res call({
 bool success, Prescription? data, String? message, String? error
});


$PrescriptionCopyWith<$Res>? get data;

}
/// @nodoc
class _$PrescriptionResponseCopyWithImpl<$Res>
    implements $PrescriptionResponseCopyWith<$Res> {
  _$PrescriptionResponseCopyWithImpl(this._self, this._then);

  final PrescriptionResponse _self;
  final $Res Function(PrescriptionResponse) _then;

/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Prescription?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrescriptionCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PrescriptionCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PrescriptionResponse].
extension PrescriptionResponsePatterns on PrescriptionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionResponse value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  Prescription? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  Prescription? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  Prescription? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionResponse implements PrescriptionResponse {
  const _PrescriptionResponse({required this.success, this.data, this.message, this.error});
  factory _PrescriptionResponse.fromJson(Map<String, dynamic> json) => _$PrescriptionResponseFromJson(json);

@override final  bool success;
@override final  Prescription? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionResponseCopyWith<_PrescriptionResponse> get copyWith => __$PrescriptionResponseCopyWithImpl<_PrescriptionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'PrescriptionResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionResponseCopyWith<$Res> implements $PrescriptionResponseCopyWith<$Res> {
  factory _$PrescriptionResponseCopyWith(_PrescriptionResponse value, $Res Function(_PrescriptionResponse) _then) = __$PrescriptionResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, Prescription? data, String? message, String? error
});


@override $PrescriptionCopyWith<$Res>? get data;

}
/// @nodoc
class __$PrescriptionResponseCopyWithImpl<$Res>
    implements _$PrescriptionResponseCopyWith<$Res> {
  __$PrescriptionResponseCopyWithImpl(this._self, this._then);

  final _PrescriptionResponse _self;
  final $Res Function(_PrescriptionResponse) _then;

/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_PrescriptionResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Prescription?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PrescriptionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrescriptionCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PrescriptionCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PrescriptionListResponse {

 bool get success; List<Prescription> get data; int? get count; int? get total; String? get message; String? get error;
/// Create a copy of PrescriptionListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrescriptionListResponseCopyWith<PrescriptionListResponse> get copyWith => _$PrescriptionListResponseCopyWithImpl<PrescriptionListResponse>(this as PrescriptionListResponse, _$identity);

  /// Serializes this PrescriptionListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrescriptionListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,total,message,error);

@override
String toString() {
  return 'PrescriptionListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $PrescriptionListResponseCopyWith<$Res>  {
  factory $PrescriptionListResponseCopyWith(PrescriptionListResponse value, $Res Function(PrescriptionListResponse) _then) = _$PrescriptionListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<Prescription> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class _$PrescriptionListResponseCopyWithImpl<$Res>
    implements $PrescriptionListResponseCopyWith<$Res> {
  _$PrescriptionListResponseCopyWithImpl(this._self, this._then);

  final PrescriptionListResponse _self;
  final $Res Function(PrescriptionListResponse) _then;

/// Create a copy of PrescriptionListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Prescription>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrescriptionListResponse].
extension PrescriptionListResponsePatterns on PrescriptionListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrescriptionListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrescriptionListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrescriptionListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PrescriptionListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrescriptionListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PrescriptionListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<Prescription> data,  int? count,  int? total,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrescriptionListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<Prescription> data,  int? count,  int? total,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PrescriptionListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<Prescription> data,  int? count,  int? total,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PrescriptionListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrescriptionListResponse implements PrescriptionListResponse {
  const _PrescriptionListResponse({required this.success, final  List<Prescription> data = const [], this.count, this.total, this.message, this.error}): _data = data;
  factory _PrescriptionListResponse.fromJson(Map<String, dynamic> json) => _$PrescriptionListResponseFromJson(json);

@override final  bool success;
 final  List<Prescription> _data;
@override@JsonKey() List<Prescription> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  int? total;
@override final  String? message;
@override final  String? error;

/// Create a copy of PrescriptionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrescriptionListResponseCopyWith<_PrescriptionListResponse> get copyWith => __$PrescriptionListResponseCopyWithImpl<_PrescriptionListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrescriptionListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrescriptionListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,total,message,error);

@override
String toString() {
  return 'PrescriptionListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PrescriptionListResponseCopyWith<$Res> implements $PrescriptionListResponseCopyWith<$Res> {
  factory _$PrescriptionListResponseCopyWith(_PrescriptionListResponse value, $Res Function(_PrescriptionListResponse) _then) = __$PrescriptionListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<Prescription> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class __$PrescriptionListResponseCopyWithImpl<$Res>
    implements _$PrescriptionListResponseCopyWith<$Res> {
  __$PrescriptionListResponseCopyWithImpl(this._self, this._then);

  final _PrescriptionListResponse _self;
  final $Res Function(_PrescriptionListResponse) _then;

/// Create a copy of PrescriptionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_PrescriptionListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Prescription>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
