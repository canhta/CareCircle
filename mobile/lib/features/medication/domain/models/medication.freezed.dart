// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medication {

 String get id; String get userId; String get name; String? get genericName; String get strength; MedicationForm get form; String? get manufacturer; String? get rxNormCode; String? get ndcCode; String? get classification; MedicationCategory get category; bool get isActive; DateTime get startDate; DateTime? get endDate; String? get prescriptionId; String? get notes; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);

  /// Serializes this Medication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,category,isActive,startDate,endDate,prescriptionId,notes,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, userId: $userId, name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, category: $category, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String? genericName, String strength, MedicationForm form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, MedicationCategory category, bool isActive, DateTime startDate, DateTime? endDate, String? prescriptionId, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? genericName = freezed,Object? strength = null,Object? form = null,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? category = null,Object? isActive = null,Object? startDate = null,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicationCategory,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  MedicationCategory category,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.category,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  MedicationCategory category,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.userId,_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.category,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  MedicationCategory category,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.category,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Medication implements Medication {
  const _Medication({required this.id, required this.userId, required this.name, this.genericName, required this.strength, required this.form, this.manufacturer, this.rxNormCode, this.ndcCode, this.classification, this.category = MedicationCategory.other, this.isActive = true, required this.startDate, this.endDate, this.prescriptionId, this.notes, required this.createdAt, required this.updatedAt});
  factory _Medication.fromJson(Map<String, dynamic> json) => _$MedicationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  String? genericName;
@override final  String strength;
@override final  MedicationForm form;
@override final  String? manufacturer;
@override final  String? rxNormCode;
@override final  String? ndcCode;
@override final  String? classification;
@override@JsonKey() final  MedicationCategory category;
@override@JsonKey() final  bool isActive;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  String? prescriptionId;
@override final  String? notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.category, category) || other.category == category)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,category,isActive,startDate,endDate,prescriptionId,notes,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, userId: $userId, name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, category: $category, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String? genericName, String strength, MedicationForm form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, MedicationCategory category, bool isActive, DateTime startDate, DateTime? endDate, String? prescriptionId, String? notes, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? genericName = freezed,Object? strength = null,Object? form = null,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? category = null,Object? isActive = null,Object? startDate = null,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MedicationCategory,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CreateMedicationRequest {

 String get name; String? get genericName; String get strength; MedicationForm get form; String? get manufacturer; String? get rxNormCode; String? get ndcCode; String? get classification; bool get isActive; DateTime get startDate; DateTime? get endDate; String? get prescriptionId; String? get notes;
/// Create a copy of CreateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateMedicationRequestCopyWith<CreateMedicationRequest> get copyWith => _$CreateMedicationRequestCopyWithImpl<CreateMedicationRequest>(this as CreateMedicationRequest, _$identity);

  /// Serializes this CreateMedicationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateMedicationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,isActive,startDate,endDate,prescriptionId,notes);

@override
String toString() {
  return 'CreateMedicationRequest(name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $CreateMedicationRequestCopyWith<$Res>  {
  factory $CreateMedicationRequestCopyWith(CreateMedicationRequest value, $Res Function(CreateMedicationRequest) _then) = _$CreateMedicationRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? genericName, String strength, MedicationForm form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, bool isActive, DateTime startDate, DateTime? endDate, String? prescriptionId, String? notes
});




}
/// @nodoc
class _$CreateMedicationRequestCopyWithImpl<$Res>
    implements $CreateMedicationRequestCopyWith<$Res> {
  _$CreateMedicationRequestCopyWithImpl(this._self, this._then);

  final CreateMedicationRequest _self;
  final $Res Function(CreateMedicationRequest) _then;

/// Create a copy of CreateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? genericName = freezed,Object? strength = null,Object? form = null,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? isActive = null,Object? startDate = null,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateMedicationRequest].
extension CreateMedicationRequestPatterns on CreateMedicationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateMedicationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateMedicationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateMedicationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateMedicationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateMedicationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateMedicationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateMedicationRequest() when $default != null:
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _CreateMedicationRequest():
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? genericName,  String strength,  MedicationForm form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool isActive,  DateTime startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _CreateMedicationRequest() when $default != null:
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateMedicationRequest implements CreateMedicationRequest {
  const _CreateMedicationRequest({required this.name, this.genericName, required this.strength, required this.form, this.manufacturer, this.rxNormCode, this.ndcCode, this.classification, this.isActive = true, required this.startDate, this.endDate, this.prescriptionId, this.notes});
  factory _CreateMedicationRequest.fromJson(Map<String, dynamic> json) => _$CreateMedicationRequestFromJson(json);

@override final  String name;
@override final  String? genericName;
@override final  String strength;
@override final  MedicationForm form;
@override final  String? manufacturer;
@override final  String? rxNormCode;
@override final  String? ndcCode;
@override final  String? classification;
@override@JsonKey() final  bool isActive;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  String? prescriptionId;
@override final  String? notes;

/// Create a copy of CreateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateMedicationRequestCopyWith<_CreateMedicationRequest> get copyWith => __$CreateMedicationRequestCopyWithImpl<_CreateMedicationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateMedicationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateMedicationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,isActive,startDate,endDate,prescriptionId,notes);

@override
String toString() {
  return 'CreateMedicationRequest(name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CreateMedicationRequestCopyWith<$Res> implements $CreateMedicationRequestCopyWith<$Res> {
  factory _$CreateMedicationRequestCopyWith(_CreateMedicationRequest value, $Res Function(_CreateMedicationRequest) _then) = __$CreateMedicationRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? genericName, String strength, MedicationForm form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, bool isActive, DateTime startDate, DateTime? endDate, String? prescriptionId, String? notes
});




}
/// @nodoc
class __$CreateMedicationRequestCopyWithImpl<$Res>
    implements _$CreateMedicationRequestCopyWith<$Res> {
  __$CreateMedicationRequestCopyWithImpl(this._self, this._then);

  final _CreateMedicationRequest _self;
  final $Res Function(_CreateMedicationRequest) _then;

/// Create a copy of CreateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? genericName = freezed,Object? strength = null,Object? form = null,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? isActive = null,Object? startDate = null,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,}) {
  return _then(_CreateMedicationRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdateMedicationRequest {

 String? get name; String? get genericName; String? get strength; MedicationForm? get form; String? get manufacturer; String? get rxNormCode; String? get ndcCode; String? get classification; bool? get isActive; DateTime? get startDate; DateTime? get endDate; String? get prescriptionId; String? get notes;
/// Create a copy of UpdateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMedicationRequestCopyWith<UpdateMedicationRequest> get copyWith => _$UpdateMedicationRequestCopyWithImpl<UpdateMedicationRequest>(this as UpdateMedicationRequest, _$identity);

  /// Serializes this UpdateMedicationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMedicationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,isActive,startDate,endDate,prescriptionId,notes);

@override
String toString() {
  return 'UpdateMedicationRequest(name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $UpdateMedicationRequestCopyWith<$Res>  {
  factory $UpdateMedicationRequestCopyWith(UpdateMedicationRequest value, $Res Function(UpdateMedicationRequest) _then) = _$UpdateMedicationRequestCopyWithImpl;
@useResult
$Res call({
 String? name, String? genericName, String? strength, MedicationForm? form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, bool? isActive, DateTime? startDate, DateTime? endDate, String? prescriptionId, String? notes
});




}
/// @nodoc
class _$UpdateMedicationRequestCopyWithImpl<$Res>
    implements $UpdateMedicationRequestCopyWith<$Res> {
  _$UpdateMedicationRequestCopyWithImpl(this._self, this._then);

  final UpdateMedicationRequest _self;
  final $Res Function(UpdateMedicationRequest) _then;

/// Create a copy of UpdateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? genericName = freezed,Object? strength = freezed,Object? form = freezed,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? isActive = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateMedicationRequest].
extension UpdateMedicationRequestPatterns on UpdateMedicationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateMedicationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateMedicationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateMedicationRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateMedicationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateMedicationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateMedicationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? genericName,  String? strength,  MedicationForm? form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateMedicationRequest() when $default != null:
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? genericName,  String? strength,  MedicationForm? form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _UpdateMedicationRequest():
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? genericName,  String? strength,  MedicationForm? form,  String? manufacturer,  String? rxNormCode,  String? ndcCode,  String? classification,  bool? isActive,  DateTime? startDate,  DateTime? endDate,  String? prescriptionId,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _UpdateMedicationRequest() when $default != null:
return $default(_that.name,_that.genericName,_that.strength,_that.form,_that.manufacturer,_that.rxNormCode,_that.ndcCode,_that.classification,_that.isActive,_that.startDate,_that.endDate,_that.prescriptionId,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateMedicationRequest implements UpdateMedicationRequest {
  const _UpdateMedicationRequest({this.name, this.genericName, this.strength, this.form, this.manufacturer, this.rxNormCode, this.ndcCode, this.classification, this.isActive, this.startDate, this.endDate, this.prescriptionId, this.notes});
  factory _UpdateMedicationRequest.fromJson(Map<String, dynamic> json) => _$UpdateMedicationRequestFromJson(json);

@override final  String? name;
@override final  String? genericName;
@override final  String? strength;
@override final  MedicationForm? form;
@override final  String? manufacturer;
@override final  String? rxNormCode;
@override final  String? ndcCode;
@override final  String? classification;
@override final  bool? isActive;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
@override final  String? prescriptionId;
@override final  String? notes;

/// Create a copy of UpdateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateMedicationRequestCopyWith<_UpdateMedicationRequest> get copyWith => __$UpdateMedicationRequestCopyWithImpl<_UpdateMedicationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateMedicationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateMedicationRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.form, form) || other.form == form)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.ndcCode, ndcCode) || other.ndcCode == ndcCode)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.prescriptionId, prescriptionId) || other.prescriptionId == prescriptionId)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,genericName,strength,form,manufacturer,rxNormCode,ndcCode,classification,isActive,startDate,endDate,prescriptionId,notes);

@override
String toString() {
  return 'UpdateMedicationRequest(name: $name, genericName: $genericName, strength: $strength, form: $form, manufacturer: $manufacturer, rxNormCode: $rxNormCode, ndcCode: $ndcCode, classification: $classification, isActive: $isActive, startDate: $startDate, endDate: $endDate, prescriptionId: $prescriptionId, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$UpdateMedicationRequestCopyWith<$Res> implements $UpdateMedicationRequestCopyWith<$Res> {
  factory _$UpdateMedicationRequestCopyWith(_UpdateMedicationRequest value, $Res Function(_UpdateMedicationRequest) _then) = __$UpdateMedicationRequestCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? genericName, String? strength, MedicationForm? form, String? manufacturer, String? rxNormCode, String? ndcCode, String? classification, bool? isActive, DateTime? startDate, DateTime? endDate, String? prescriptionId, String? notes
});




}
/// @nodoc
class __$UpdateMedicationRequestCopyWithImpl<$Res>
    implements _$UpdateMedicationRequestCopyWith<$Res> {
  __$UpdateMedicationRequestCopyWithImpl(this._self, this._then);

  final _UpdateMedicationRequest _self;
  final $Res Function(_UpdateMedicationRequest) _then;

/// Create a copy of UpdateMedicationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? genericName = freezed,Object? strength = freezed,Object? form = freezed,Object? manufacturer = freezed,Object? rxNormCode = freezed,Object? ndcCode = freezed,Object? classification = freezed,Object? isActive = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? prescriptionId = freezed,Object? notes = freezed,}) {
  return _then(_UpdateMedicationRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,form: freezed == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MedicationForm?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,ndcCode: freezed == ndcCode ? _self.ndcCode : ndcCode // ignore: cast_nullable_to_non_nullable
as String?,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,prescriptionId: freezed == prescriptionId ? _self.prescriptionId : prescriptionId // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedicationStatistics {

 int get totalMedications; int get activeMedications; int get inactiveMedications; int get expiringSoon; Map<MedicationForm, int> get medicationsByForm; Map<String, int> get medicationsByClassification; double get averageAdherence; int get totalDoses; int get missedDoses;
/// Create a copy of MedicationStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationStatisticsCopyWith<MedicationStatistics> get copyWith => _$MedicationStatisticsCopyWithImpl<MedicationStatistics>(this as MedicationStatistics, _$identity);

  /// Serializes this MedicationStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationStatistics&&(identical(other.totalMedications, totalMedications) || other.totalMedications == totalMedications)&&(identical(other.activeMedications, activeMedications) || other.activeMedications == activeMedications)&&(identical(other.inactiveMedications, inactiveMedications) || other.inactiveMedications == inactiveMedications)&&(identical(other.expiringSoon, expiringSoon) || other.expiringSoon == expiringSoon)&&const DeepCollectionEquality().equals(other.medicationsByForm, medicationsByForm)&&const DeepCollectionEquality().equals(other.medicationsByClassification, medicationsByClassification)&&(identical(other.averageAdherence, averageAdherence) || other.averageAdherence == averageAdherence)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.missedDoses, missedDoses) || other.missedDoses == missedDoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMedications,activeMedications,inactiveMedications,expiringSoon,const DeepCollectionEquality().hash(medicationsByForm),const DeepCollectionEquality().hash(medicationsByClassification),averageAdherence,totalDoses,missedDoses);

@override
String toString() {
  return 'MedicationStatistics(totalMedications: $totalMedications, activeMedications: $activeMedications, inactiveMedications: $inactiveMedications, expiringSoon: $expiringSoon, medicationsByForm: $medicationsByForm, medicationsByClassification: $medicationsByClassification, averageAdherence: $averageAdherence, totalDoses: $totalDoses, missedDoses: $missedDoses)';
}


}

/// @nodoc
abstract mixin class $MedicationStatisticsCopyWith<$Res>  {
  factory $MedicationStatisticsCopyWith(MedicationStatistics value, $Res Function(MedicationStatistics) _then) = _$MedicationStatisticsCopyWithImpl;
@useResult
$Res call({
 int totalMedications, int activeMedications, int inactiveMedications, int expiringSoon, Map<MedicationForm, int> medicationsByForm, Map<String, int> medicationsByClassification, double averageAdherence, int totalDoses, int missedDoses
});




}
/// @nodoc
class _$MedicationStatisticsCopyWithImpl<$Res>
    implements $MedicationStatisticsCopyWith<$Res> {
  _$MedicationStatisticsCopyWithImpl(this._self, this._then);

  final MedicationStatistics _self;
  final $Res Function(MedicationStatistics) _then;

/// Create a copy of MedicationStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalMedications = null,Object? activeMedications = null,Object? inactiveMedications = null,Object? expiringSoon = null,Object? medicationsByForm = null,Object? medicationsByClassification = null,Object? averageAdherence = null,Object? totalDoses = null,Object? missedDoses = null,}) {
  return _then(_self.copyWith(
totalMedications: null == totalMedications ? _self.totalMedications : totalMedications // ignore: cast_nullable_to_non_nullable
as int,activeMedications: null == activeMedications ? _self.activeMedications : activeMedications // ignore: cast_nullable_to_non_nullable
as int,inactiveMedications: null == inactiveMedications ? _self.inactiveMedications : inactiveMedications // ignore: cast_nullable_to_non_nullable
as int,expiringSoon: null == expiringSoon ? _self.expiringSoon : expiringSoon // ignore: cast_nullable_to_non_nullable
as int,medicationsByForm: null == medicationsByForm ? _self.medicationsByForm : medicationsByForm // ignore: cast_nullable_to_non_nullable
as Map<MedicationForm, int>,medicationsByClassification: null == medicationsByClassification ? _self.medicationsByClassification : medicationsByClassification // ignore: cast_nullable_to_non_nullable
as Map<String, int>,averageAdherence: null == averageAdherence ? _self.averageAdherence : averageAdherence // ignore: cast_nullable_to_non_nullable
as double,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,missedDoses: null == missedDoses ? _self.missedDoses : missedDoses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationStatistics].
extension MedicationStatisticsPatterns on MedicationStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationStatistics value)  $default,){
final _that = this;
switch (_that) {
case _MedicationStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalMedications,  int activeMedications,  int inactiveMedications,  int expiringSoon,  Map<MedicationForm, int> medicationsByForm,  Map<String, int> medicationsByClassification,  double averageAdherence,  int totalDoses,  int missedDoses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationStatistics() when $default != null:
return $default(_that.totalMedications,_that.activeMedications,_that.inactiveMedications,_that.expiringSoon,_that.medicationsByForm,_that.medicationsByClassification,_that.averageAdherence,_that.totalDoses,_that.missedDoses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalMedications,  int activeMedications,  int inactiveMedications,  int expiringSoon,  Map<MedicationForm, int> medicationsByForm,  Map<String, int> medicationsByClassification,  double averageAdherence,  int totalDoses,  int missedDoses)  $default,) {final _that = this;
switch (_that) {
case _MedicationStatistics():
return $default(_that.totalMedications,_that.activeMedications,_that.inactiveMedications,_that.expiringSoon,_that.medicationsByForm,_that.medicationsByClassification,_that.averageAdherence,_that.totalDoses,_that.missedDoses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalMedications,  int activeMedications,  int inactiveMedications,  int expiringSoon,  Map<MedicationForm, int> medicationsByForm,  Map<String, int> medicationsByClassification,  double averageAdherence,  int totalDoses,  int missedDoses)?  $default,) {final _that = this;
switch (_that) {
case _MedicationStatistics() when $default != null:
return $default(_that.totalMedications,_that.activeMedications,_that.inactiveMedications,_that.expiringSoon,_that.medicationsByForm,_that.medicationsByClassification,_that.averageAdherence,_that.totalDoses,_that.missedDoses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationStatistics implements MedicationStatistics {
  const _MedicationStatistics({required this.totalMedications, required this.activeMedications, required this.inactiveMedications, required this.expiringSoon, required final  Map<MedicationForm, int> medicationsByForm, required final  Map<String, int> medicationsByClassification, required this.averageAdherence, required this.totalDoses, required this.missedDoses}): _medicationsByForm = medicationsByForm,_medicationsByClassification = medicationsByClassification;
  factory _MedicationStatistics.fromJson(Map<String, dynamic> json) => _$MedicationStatisticsFromJson(json);

@override final  int totalMedications;
@override final  int activeMedications;
@override final  int inactiveMedications;
@override final  int expiringSoon;
 final  Map<MedicationForm, int> _medicationsByForm;
@override Map<MedicationForm, int> get medicationsByForm {
  if (_medicationsByForm is EqualUnmodifiableMapView) return _medicationsByForm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_medicationsByForm);
}

 final  Map<String, int> _medicationsByClassification;
@override Map<String, int> get medicationsByClassification {
  if (_medicationsByClassification is EqualUnmodifiableMapView) return _medicationsByClassification;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_medicationsByClassification);
}

@override final  double averageAdherence;
@override final  int totalDoses;
@override final  int missedDoses;

/// Create a copy of MedicationStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationStatisticsCopyWith<_MedicationStatistics> get copyWith => __$MedicationStatisticsCopyWithImpl<_MedicationStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationStatistics&&(identical(other.totalMedications, totalMedications) || other.totalMedications == totalMedications)&&(identical(other.activeMedications, activeMedications) || other.activeMedications == activeMedications)&&(identical(other.inactiveMedications, inactiveMedications) || other.inactiveMedications == inactiveMedications)&&(identical(other.expiringSoon, expiringSoon) || other.expiringSoon == expiringSoon)&&const DeepCollectionEquality().equals(other._medicationsByForm, _medicationsByForm)&&const DeepCollectionEquality().equals(other._medicationsByClassification, _medicationsByClassification)&&(identical(other.averageAdherence, averageAdherence) || other.averageAdherence == averageAdherence)&&(identical(other.totalDoses, totalDoses) || other.totalDoses == totalDoses)&&(identical(other.missedDoses, missedDoses) || other.missedDoses == missedDoses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalMedications,activeMedications,inactiveMedications,expiringSoon,const DeepCollectionEquality().hash(_medicationsByForm),const DeepCollectionEquality().hash(_medicationsByClassification),averageAdherence,totalDoses,missedDoses);

@override
String toString() {
  return 'MedicationStatistics(totalMedications: $totalMedications, activeMedications: $activeMedications, inactiveMedications: $inactiveMedications, expiringSoon: $expiringSoon, medicationsByForm: $medicationsByForm, medicationsByClassification: $medicationsByClassification, averageAdherence: $averageAdherence, totalDoses: $totalDoses, missedDoses: $missedDoses)';
}


}

/// @nodoc
abstract mixin class _$MedicationStatisticsCopyWith<$Res> implements $MedicationStatisticsCopyWith<$Res> {
  factory _$MedicationStatisticsCopyWith(_MedicationStatistics value, $Res Function(_MedicationStatistics) _then) = __$MedicationStatisticsCopyWithImpl;
@override @useResult
$Res call({
 int totalMedications, int activeMedications, int inactiveMedications, int expiringSoon, Map<MedicationForm, int> medicationsByForm, Map<String, int> medicationsByClassification, double averageAdherence, int totalDoses, int missedDoses
});




}
/// @nodoc
class __$MedicationStatisticsCopyWithImpl<$Res>
    implements _$MedicationStatisticsCopyWith<$Res> {
  __$MedicationStatisticsCopyWithImpl(this._self, this._then);

  final _MedicationStatistics _self;
  final $Res Function(_MedicationStatistics) _then;

/// Create a copy of MedicationStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalMedications = null,Object? activeMedications = null,Object? inactiveMedications = null,Object? expiringSoon = null,Object? medicationsByForm = null,Object? medicationsByClassification = null,Object? averageAdherence = null,Object? totalDoses = null,Object? missedDoses = null,}) {
  return _then(_MedicationStatistics(
totalMedications: null == totalMedications ? _self.totalMedications : totalMedications // ignore: cast_nullable_to_non_nullable
as int,activeMedications: null == activeMedications ? _self.activeMedications : activeMedications // ignore: cast_nullable_to_non_nullable
as int,inactiveMedications: null == inactiveMedications ? _self.inactiveMedications : inactiveMedications // ignore: cast_nullable_to_non_nullable
as int,expiringSoon: null == expiringSoon ? _self.expiringSoon : expiringSoon // ignore: cast_nullable_to_non_nullable
as int,medicationsByForm: null == medicationsByForm ? _self._medicationsByForm : medicationsByForm // ignore: cast_nullable_to_non_nullable
as Map<MedicationForm, int>,medicationsByClassification: null == medicationsByClassification ? _self._medicationsByClassification : medicationsByClassification // ignore: cast_nullable_to_non_nullable
as Map<String, int>,averageAdherence: null == averageAdherence ? _self.averageAdherence : averageAdherence // ignore: cast_nullable_to_non_nullable
as double,totalDoses: null == totalDoses ? _self.totalDoses : totalDoses // ignore: cast_nullable_to_non_nullable
as int,missedDoses: null == missedDoses ? _self.missedDoses : missedDoses // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MedicationResponse {

 bool get success; Medication? get data; String? get message; String? get error;
/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationResponseCopyWith<MedicationResponse> get copyWith => _$MedicationResponseCopyWithImpl<MedicationResponse>(this as MedicationResponse, _$identity);

  /// Serializes this MedicationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'MedicationResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $MedicationResponseCopyWith<$Res>  {
  factory $MedicationResponseCopyWith(MedicationResponse value, $Res Function(MedicationResponse) _then) = _$MedicationResponseCopyWithImpl;
@useResult
$Res call({
 bool success, Medication? data, String? message, String? error
});


$MedicationCopyWith<$Res>? get data;

}
/// @nodoc
class _$MedicationResponseCopyWithImpl<$Res>
    implements $MedicationResponseCopyWith<$Res> {
  _$MedicationResponseCopyWithImpl(this._self, this._then);

  final MedicationResponse _self;
  final $Res Function(MedicationResponse) _then;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Medication?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationResponse].
extension MedicationResponsePatterns on MedicationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationResponse value)  $default,){
final _that = this;
switch (_that) {
case _MedicationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  Medication? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  Medication? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MedicationResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  Medication? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MedicationResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationResponse implements MedicationResponse {
  const _MedicationResponse({required this.success, this.data, this.message, this.error});
  factory _MedicationResponse.fromJson(Map<String, dynamic> json) => _$MedicationResponseFromJson(json);

@override final  bool success;
@override final  Medication? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationResponseCopyWith<_MedicationResponse> get copyWith => __$MedicationResponseCopyWithImpl<_MedicationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'MedicationResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MedicationResponseCopyWith<$Res> implements $MedicationResponseCopyWith<$Res> {
  factory _$MedicationResponseCopyWith(_MedicationResponse value, $Res Function(_MedicationResponse) _then) = __$MedicationResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, Medication? data, String? message, String? error
});


@override $MedicationCopyWith<$Res>? get data;

}
/// @nodoc
class __$MedicationResponseCopyWithImpl<$Res>
    implements _$MedicationResponseCopyWith<$Res> {
  __$MedicationResponseCopyWithImpl(this._self, this._then);

  final _MedicationResponse _self;
  final $Res Function(_MedicationResponse) _then;

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_MedicationResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Medication?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MedicationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicationCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $MedicationCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MedicationListResponse {

 bool get success; List<Medication> get data; int? get count; int? get total; String? get message; String? get error;
/// Create a copy of MedicationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationListResponseCopyWith<MedicationListResponse> get copyWith => _$MedicationListResponseCopyWithImpl<MedicationListResponse>(this as MedicationListResponse, _$identity);

  /// Serializes this MedicationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,total,message,error);

@override
String toString() {
  return 'MedicationListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $MedicationListResponseCopyWith<$Res>  {
  factory $MedicationListResponseCopyWith(MedicationListResponse value, $Res Function(MedicationListResponse) _then) = _$MedicationListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<Medication> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class _$MedicationListResponseCopyWithImpl<$Res>
    implements $MedicationListResponseCopyWith<$Res> {
  _$MedicationListResponseCopyWithImpl(this._self, this._then);

  final MedicationListResponse _self;
  final $Res Function(MedicationListResponse) _then;

/// Create a copy of MedicationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Medication>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationListResponse].
extension MedicationListResponsePatterns on MedicationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MedicationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<Medication> data,  int? count,  int? total,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<Medication> data,  int? count,  int? total,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MedicationListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<Medication> data,  int? count,  int? total,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MedicationListResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.total,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationListResponse implements MedicationListResponse {
  const _MedicationListResponse({required this.success, final  List<Medication> data = const [], this.count, this.total, this.message, this.error}): _data = data;
  factory _MedicationListResponse.fromJson(Map<String, dynamic> json) => _$MedicationListResponseFromJson(json);

@override final  bool success;
 final  List<Medication> _data;
@override@JsonKey() List<Medication> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  int? total;
@override final  String? message;
@override final  String? error;

/// Create a copy of MedicationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationListResponseCopyWith<_MedicationListResponse> get copyWith => __$MedicationListResponseCopyWithImpl<_MedicationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationListResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.total, total) || other.total == total)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,total,message,error);

@override
String toString() {
  return 'MedicationListResponse(success: $success, data: $data, count: $count, total: $total, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MedicationListResponseCopyWith<$Res> implements $MedicationListResponseCopyWith<$Res> {
  factory _$MedicationListResponseCopyWith(_MedicationListResponse value, $Res Function(_MedicationListResponse) _then) = __$MedicationListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<Medication> data, int? count, int? total, String? message, String? error
});




}
/// @nodoc
class __$MedicationListResponseCopyWithImpl<$Res>
    implements _$MedicationListResponseCopyWith<$Res> {
  __$MedicationListResponseCopyWithImpl(this._self, this._then);

  final _MedicationListResponse _self;
  final $Res Function(_MedicationListResponse) _then;

/// Create a copy of MedicationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? total = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_MedicationListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Medication>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
