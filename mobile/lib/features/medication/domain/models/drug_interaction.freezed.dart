// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug_interaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InteractionAlert {

 String get id; InteractionType get type; InteractionSeverity get severity; String get primaryMedication; String? get secondaryMedication; String? get interactingSubstance; String get description; String get clinicalEffect; String? get mechanism; List<String> get recommendations; List<String> get alternatives; String? get sourceReference; double get confidence;
/// Create a copy of InteractionAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionAlertCopyWith<InteractionAlert> get copyWith => _$InteractionAlertCopyWithImpl<InteractionAlert>(this as InteractionAlert, _$identity);

  /// Serializes this InteractionAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.primaryMedication, primaryMedication) || other.primaryMedication == primaryMedication)&&(identical(other.secondaryMedication, secondaryMedication) || other.secondaryMedication == secondaryMedication)&&(identical(other.interactingSubstance, interactingSubstance) || other.interactingSubstance == interactingSubstance)&&(identical(other.description, description) || other.description == description)&&(identical(other.clinicalEffect, clinicalEffect) || other.clinicalEffect == clinicalEffect)&&(identical(other.mechanism, mechanism) || other.mechanism == mechanism)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&const DeepCollectionEquality().equals(other.alternatives, alternatives)&&(identical(other.sourceReference, sourceReference) || other.sourceReference == sourceReference)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,severity,primaryMedication,secondaryMedication,interactingSubstance,description,clinicalEffect,mechanism,const DeepCollectionEquality().hash(recommendations),const DeepCollectionEquality().hash(alternatives),sourceReference,confidence);

@override
String toString() {
  return 'InteractionAlert(id: $id, type: $type, severity: $severity, primaryMedication: $primaryMedication, secondaryMedication: $secondaryMedication, interactingSubstance: $interactingSubstance, description: $description, clinicalEffect: $clinicalEffect, mechanism: $mechanism, recommendations: $recommendations, alternatives: $alternatives, sourceReference: $sourceReference, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $InteractionAlertCopyWith<$Res>  {
  factory $InteractionAlertCopyWith(InteractionAlert value, $Res Function(InteractionAlert) _then) = _$InteractionAlertCopyWithImpl;
@useResult
$Res call({
 String id, InteractionType type, InteractionSeverity severity, String primaryMedication, String? secondaryMedication, String? interactingSubstance, String description, String clinicalEffect, String? mechanism, List<String> recommendations, List<String> alternatives, String? sourceReference, double confidence
});




}
/// @nodoc
class _$InteractionAlertCopyWithImpl<$Res>
    implements $InteractionAlertCopyWith<$Res> {
  _$InteractionAlertCopyWithImpl(this._self, this._then);

  final InteractionAlert _self;
  final $Res Function(InteractionAlert) _then;

/// Create a copy of InteractionAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? severity = null,Object? primaryMedication = null,Object? secondaryMedication = freezed,Object? interactingSubstance = freezed,Object? description = null,Object? clinicalEffect = null,Object? mechanism = freezed,Object? recommendations = null,Object? alternatives = null,Object? sourceReference = freezed,Object? confidence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InteractionType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as InteractionSeverity,primaryMedication: null == primaryMedication ? _self.primaryMedication : primaryMedication // ignore: cast_nullable_to_non_nullable
as String,secondaryMedication: freezed == secondaryMedication ? _self.secondaryMedication : secondaryMedication // ignore: cast_nullable_to_non_nullable
as String?,interactingSubstance: freezed == interactingSubstance ? _self.interactingSubstance : interactingSubstance // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,clinicalEffect: null == clinicalEffect ? _self.clinicalEffect : clinicalEffect // ignore: cast_nullable_to_non_nullable
as String,mechanism: freezed == mechanism ? _self.mechanism : mechanism // ignore: cast_nullable_to_non_nullable
as String?,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,sourceReference: freezed == sourceReference ? _self.sourceReference : sourceReference // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionAlert].
extension InteractionAlertPatterns on InteractionAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionAlert value)  $default,){
final _that = this;
switch (_that) {
case _InteractionAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionAlert value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  InteractionType type,  InteractionSeverity severity,  String primaryMedication,  String? secondaryMedication,  String? interactingSubstance,  String description,  String clinicalEffect,  String? mechanism,  List<String> recommendations,  List<String> alternatives,  String? sourceReference,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionAlert() when $default != null:
return $default(_that.id,_that.type,_that.severity,_that.primaryMedication,_that.secondaryMedication,_that.interactingSubstance,_that.description,_that.clinicalEffect,_that.mechanism,_that.recommendations,_that.alternatives,_that.sourceReference,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  InteractionType type,  InteractionSeverity severity,  String primaryMedication,  String? secondaryMedication,  String? interactingSubstance,  String description,  String clinicalEffect,  String? mechanism,  List<String> recommendations,  List<String> alternatives,  String? sourceReference,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _InteractionAlert():
return $default(_that.id,_that.type,_that.severity,_that.primaryMedication,_that.secondaryMedication,_that.interactingSubstance,_that.description,_that.clinicalEffect,_that.mechanism,_that.recommendations,_that.alternatives,_that.sourceReference,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  InteractionType type,  InteractionSeverity severity,  String primaryMedication,  String? secondaryMedication,  String? interactingSubstance,  String description,  String clinicalEffect,  String? mechanism,  List<String> recommendations,  List<String> alternatives,  String? sourceReference,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _InteractionAlert() when $default != null:
return $default(_that.id,_that.type,_that.severity,_that.primaryMedication,_that.secondaryMedication,_that.interactingSubstance,_that.description,_that.clinicalEffect,_that.mechanism,_that.recommendations,_that.alternatives,_that.sourceReference,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionAlert implements InteractionAlert {
  const _InteractionAlert({required this.id, required this.type, required this.severity, required this.primaryMedication, this.secondaryMedication, this.interactingSubstance, required this.description, required this.clinicalEffect, this.mechanism, final  List<String> recommendations = const [], final  List<String> alternatives = const [], this.sourceReference, required this.confidence}): _recommendations = recommendations,_alternatives = alternatives;
  factory _InteractionAlert.fromJson(Map<String, dynamic> json) => _$InteractionAlertFromJson(json);

@override final  String id;
@override final  InteractionType type;
@override final  InteractionSeverity severity;
@override final  String primaryMedication;
@override final  String? secondaryMedication;
@override final  String? interactingSubstance;
@override final  String description;
@override final  String clinicalEffect;
@override final  String? mechanism;
 final  List<String> _recommendations;
@override@JsonKey() List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

 final  List<String> _alternatives;
@override@JsonKey() List<String> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}

@override final  String? sourceReference;
@override final  double confidence;

/// Create a copy of InteractionAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionAlertCopyWith<_InteractionAlert> get copyWith => __$InteractionAlertCopyWithImpl<_InteractionAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.primaryMedication, primaryMedication) || other.primaryMedication == primaryMedication)&&(identical(other.secondaryMedication, secondaryMedication) || other.secondaryMedication == secondaryMedication)&&(identical(other.interactingSubstance, interactingSubstance) || other.interactingSubstance == interactingSubstance)&&(identical(other.description, description) || other.description == description)&&(identical(other.clinicalEffect, clinicalEffect) || other.clinicalEffect == clinicalEffect)&&(identical(other.mechanism, mechanism) || other.mechanism == mechanism)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives)&&(identical(other.sourceReference, sourceReference) || other.sourceReference == sourceReference)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,severity,primaryMedication,secondaryMedication,interactingSubstance,description,clinicalEffect,mechanism,const DeepCollectionEquality().hash(_recommendations),const DeepCollectionEquality().hash(_alternatives),sourceReference,confidence);

@override
String toString() {
  return 'InteractionAlert(id: $id, type: $type, severity: $severity, primaryMedication: $primaryMedication, secondaryMedication: $secondaryMedication, interactingSubstance: $interactingSubstance, description: $description, clinicalEffect: $clinicalEffect, mechanism: $mechanism, recommendations: $recommendations, alternatives: $alternatives, sourceReference: $sourceReference, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$InteractionAlertCopyWith<$Res> implements $InteractionAlertCopyWith<$Res> {
  factory _$InteractionAlertCopyWith(_InteractionAlert value, $Res Function(_InteractionAlert) _then) = __$InteractionAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, InteractionType type, InteractionSeverity severity, String primaryMedication, String? secondaryMedication, String? interactingSubstance, String description, String clinicalEffect, String? mechanism, List<String> recommendations, List<String> alternatives, String? sourceReference, double confidence
});




}
/// @nodoc
class __$InteractionAlertCopyWithImpl<$Res>
    implements _$InteractionAlertCopyWith<$Res> {
  __$InteractionAlertCopyWithImpl(this._self, this._then);

  final _InteractionAlert _self;
  final $Res Function(_InteractionAlert) _then;

/// Create a copy of InteractionAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? severity = null,Object? primaryMedication = null,Object? secondaryMedication = freezed,Object? interactingSubstance = freezed,Object? description = null,Object? clinicalEffect = null,Object? mechanism = freezed,Object? recommendations = null,Object? alternatives = null,Object? sourceReference = freezed,Object? confidence = null,}) {
  return _then(_InteractionAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InteractionType,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as InteractionSeverity,primaryMedication: null == primaryMedication ? _self.primaryMedication : primaryMedication // ignore: cast_nullable_to_non_nullable
as String,secondaryMedication: freezed == secondaryMedication ? _self.secondaryMedication : secondaryMedication // ignore: cast_nullable_to_non_nullable
as String?,interactingSubstance: freezed == interactingSubstance ? _self.interactingSubstance : interactingSubstance // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,clinicalEffect: null == clinicalEffect ? _self.clinicalEffect : clinicalEffect // ignore: cast_nullable_to_non_nullable
as String,mechanism: freezed == mechanism ? _self.mechanism : mechanism // ignore: cast_nullable_to_non_nullable
as String?,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,sourceReference: freezed == sourceReference ? _self.sourceReference : sourceReference // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$InteractionAnalysis {

 String get userId; DateTime get analysisDate; List<String> get medicationIds; List<InteractionAlert> get interactions; InteractionSeverity get highestSeverity; int get totalInteractions; bool get hasContraindications; List<String> get generalRecommendations; String? get pharmacistNotes;
/// Create a copy of InteractionAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionAnalysisCopyWith<InteractionAnalysis> get copyWith => _$InteractionAnalysisCopyWithImpl<InteractionAnalysis>(this as InteractionAnalysis, _$identity);

  /// Serializes this InteractionAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionAnalysis&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.analysisDate, analysisDate) || other.analysisDate == analysisDate)&&const DeepCollectionEquality().equals(other.medicationIds, medicationIds)&&const DeepCollectionEquality().equals(other.interactions, interactions)&&(identical(other.highestSeverity, highestSeverity) || other.highestSeverity == highestSeverity)&&(identical(other.totalInteractions, totalInteractions) || other.totalInteractions == totalInteractions)&&(identical(other.hasContraindications, hasContraindications) || other.hasContraindications == hasContraindications)&&const DeepCollectionEquality().equals(other.generalRecommendations, generalRecommendations)&&(identical(other.pharmacistNotes, pharmacistNotes) || other.pharmacistNotes == pharmacistNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,analysisDate,const DeepCollectionEquality().hash(medicationIds),const DeepCollectionEquality().hash(interactions),highestSeverity,totalInteractions,hasContraindications,const DeepCollectionEquality().hash(generalRecommendations),pharmacistNotes);

@override
String toString() {
  return 'InteractionAnalysis(userId: $userId, analysisDate: $analysisDate, medicationIds: $medicationIds, interactions: $interactions, highestSeverity: $highestSeverity, totalInteractions: $totalInteractions, hasContraindications: $hasContraindications, generalRecommendations: $generalRecommendations, pharmacistNotes: $pharmacistNotes)';
}


}

/// @nodoc
abstract mixin class $InteractionAnalysisCopyWith<$Res>  {
  factory $InteractionAnalysisCopyWith(InteractionAnalysis value, $Res Function(InteractionAnalysis) _then) = _$InteractionAnalysisCopyWithImpl;
@useResult
$Res call({
 String userId, DateTime analysisDate, List<String> medicationIds, List<InteractionAlert> interactions, InteractionSeverity highestSeverity, int totalInteractions, bool hasContraindications, List<String> generalRecommendations, String? pharmacistNotes
});




}
/// @nodoc
class _$InteractionAnalysisCopyWithImpl<$Res>
    implements $InteractionAnalysisCopyWith<$Res> {
  _$InteractionAnalysisCopyWithImpl(this._self, this._then);

  final InteractionAnalysis _self;
  final $Res Function(InteractionAnalysis) _then;

/// Create a copy of InteractionAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? analysisDate = null,Object? medicationIds = null,Object? interactions = null,Object? highestSeverity = null,Object? totalInteractions = null,Object? hasContraindications = null,Object? generalRecommendations = null,Object? pharmacistNotes = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,analysisDate: null == analysisDate ? _self.analysisDate : analysisDate // ignore: cast_nullable_to_non_nullable
as DateTime,medicationIds: null == medicationIds ? _self.medicationIds : medicationIds // ignore: cast_nullable_to_non_nullable
as List<String>,interactions: null == interactions ? _self.interactions : interactions // ignore: cast_nullable_to_non_nullable
as List<InteractionAlert>,highestSeverity: null == highestSeverity ? _self.highestSeverity : highestSeverity // ignore: cast_nullable_to_non_nullable
as InteractionSeverity,totalInteractions: null == totalInteractions ? _self.totalInteractions : totalInteractions // ignore: cast_nullable_to_non_nullable
as int,hasContraindications: null == hasContraindications ? _self.hasContraindications : hasContraindications // ignore: cast_nullable_to_non_nullable
as bool,generalRecommendations: null == generalRecommendations ? _self.generalRecommendations : generalRecommendations // ignore: cast_nullable_to_non_nullable
as List<String>,pharmacistNotes: freezed == pharmacistNotes ? _self.pharmacistNotes : pharmacistNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionAnalysis].
extension InteractionAnalysisPatterns on InteractionAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _InteractionAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  DateTime analysisDate,  List<String> medicationIds,  List<InteractionAlert> interactions,  InteractionSeverity highestSeverity,  int totalInteractions,  bool hasContraindications,  List<String> generalRecommendations,  String? pharmacistNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionAnalysis() when $default != null:
return $default(_that.userId,_that.analysisDate,_that.medicationIds,_that.interactions,_that.highestSeverity,_that.totalInteractions,_that.hasContraindications,_that.generalRecommendations,_that.pharmacistNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  DateTime analysisDate,  List<String> medicationIds,  List<InteractionAlert> interactions,  InteractionSeverity highestSeverity,  int totalInteractions,  bool hasContraindications,  List<String> generalRecommendations,  String? pharmacistNotes)  $default,) {final _that = this;
switch (_that) {
case _InteractionAnalysis():
return $default(_that.userId,_that.analysisDate,_that.medicationIds,_that.interactions,_that.highestSeverity,_that.totalInteractions,_that.hasContraindications,_that.generalRecommendations,_that.pharmacistNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  DateTime analysisDate,  List<String> medicationIds,  List<InteractionAlert> interactions,  InteractionSeverity highestSeverity,  int totalInteractions,  bool hasContraindications,  List<String> generalRecommendations,  String? pharmacistNotes)?  $default,) {final _that = this;
switch (_that) {
case _InteractionAnalysis() when $default != null:
return $default(_that.userId,_that.analysisDate,_that.medicationIds,_that.interactions,_that.highestSeverity,_that.totalInteractions,_that.hasContraindications,_that.generalRecommendations,_that.pharmacistNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionAnalysis implements InteractionAnalysis {
  const _InteractionAnalysis({required this.userId, required this.analysisDate, final  List<String> medicationIds = const [], final  List<InteractionAlert> interactions = const [], required this.highestSeverity, required this.totalInteractions, required this.hasContraindications, final  List<String> generalRecommendations = const [], this.pharmacistNotes}): _medicationIds = medicationIds,_interactions = interactions,_generalRecommendations = generalRecommendations;
  factory _InteractionAnalysis.fromJson(Map<String, dynamic> json) => _$InteractionAnalysisFromJson(json);

@override final  String userId;
@override final  DateTime analysisDate;
 final  List<String> _medicationIds;
@override@JsonKey() List<String> get medicationIds {
  if (_medicationIds is EqualUnmodifiableListView) return _medicationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicationIds);
}

 final  List<InteractionAlert> _interactions;
@override@JsonKey() List<InteractionAlert> get interactions {
  if (_interactions is EqualUnmodifiableListView) return _interactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interactions);
}

@override final  InteractionSeverity highestSeverity;
@override final  int totalInteractions;
@override final  bool hasContraindications;
 final  List<String> _generalRecommendations;
@override@JsonKey() List<String> get generalRecommendations {
  if (_generalRecommendations is EqualUnmodifiableListView) return _generalRecommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_generalRecommendations);
}

@override final  String? pharmacistNotes;

/// Create a copy of InteractionAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionAnalysisCopyWith<_InteractionAnalysis> get copyWith => __$InteractionAnalysisCopyWithImpl<_InteractionAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionAnalysis&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.analysisDate, analysisDate) || other.analysisDate == analysisDate)&&const DeepCollectionEquality().equals(other._medicationIds, _medicationIds)&&const DeepCollectionEquality().equals(other._interactions, _interactions)&&(identical(other.highestSeverity, highestSeverity) || other.highestSeverity == highestSeverity)&&(identical(other.totalInteractions, totalInteractions) || other.totalInteractions == totalInteractions)&&(identical(other.hasContraindications, hasContraindications) || other.hasContraindications == hasContraindications)&&const DeepCollectionEquality().equals(other._generalRecommendations, _generalRecommendations)&&(identical(other.pharmacistNotes, pharmacistNotes) || other.pharmacistNotes == pharmacistNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,analysisDate,const DeepCollectionEquality().hash(_medicationIds),const DeepCollectionEquality().hash(_interactions),highestSeverity,totalInteractions,hasContraindications,const DeepCollectionEquality().hash(_generalRecommendations),pharmacistNotes);

@override
String toString() {
  return 'InteractionAnalysis(userId: $userId, analysisDate: $analysisDate, medicationIds: $medicationIds, interactions: $interactions, highestSeverity: $highestSeverity, totalInteractions: $totalInteractions, hasContraindications: $hasContraindications, generalRecommendations: $generalRecommendations, pharmacistNotes: $pharmacistNotes)';
}


}

/// @nodoc
abstract mixin class _$InteractionAnalysisCopyWith<$Res> implements $InteractionAnalysisCopyWith<$Res> {
  factory _$InteractionAnalysisCopyWith(_InteractionAnalysis value, $Res Function(_InteractionAnalysis) _then) = __$InteractionAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String userId, DateTime analysisDate, List<String> medicationIds, List<InteractionAlert> interactions, InteractionSeverity highestSeverity, int totalInteractions, bool hasContraindications, List<String> generalRecommendations, String? pharmacistNotes
});




}
/// @nodoc
class __$InteractionAnalysisCopyWithImpl<$Res>
    implements _$InteractionAnalysisCopyWith<$Res> {
  __$InteractionAnalysisCopyWithImpl(this._self, this._then);

  final _InteractionAnalysis _self;
  final $Res Function(_InteractionAnalysis) _then;

/// Create a copy of InteractionAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? analysisDate = null,Object? medicationIds = null,Object? interactions = null,Object? highestSeverity = null,Object? totalInteractions = null,Object? hasContraindications = null,Object? generalRecommendations = null,Object? pharmacistNotes = freezed,}) {
  return _then(_InteractionAnalysis(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,analysisDate: null == analysisDate ? _self.analysisDate : analysisDate // ignore: cast_nullable_to_non_nullable
as DateTime,medicationIds: null == medicationIds ? _self._medicationIds : medicationIds // ignore: cast_nullable_to_non_nullable
as List<String>,interactions: null == interactions ? _self._interactions : interactions // ignore: cast_nullable_to_non_nullable
as List<InteractionAlert>,highestSeverity: null == highestSeverity ? _self.highestSeverity : highestSeverity // ignore: cast_nullable_to_non_nullable
as InteractionSeverity,totalInteractions: null == totalInteractions ? _self.totalInteractions : totalInteractions // ignore: cast_nullable_to_non_nullable
as int,hasContraindications: null == hasContraindications ? _self.hasContraindications : hasContraindications // ignore: cast_nullable_to_non_nullable
as bool,generalRecommendations: null == generalRecommendations ? _self._generalRecommendations : generalRecommendations // ignore: cast_nullable_to_non_nullable
as List<String>,pharmacistNotes: freezed == pharmacistNotes ? _self.pharmacistNotes : pharmacistNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RxNormMedication {

 String get rxcui; String get name; String? get genericName; String? get brandName; String? get strength; String? get doseForm; String? get route; List<String> get ingredients; String? get classification; bool? get isGeneric; List<String> get synonyms;
/// Create a copy of RxNormMedication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RxNormMedicationCopyWith<RxNormMedication> get copyWith => _$RxNormMedicationCopyWithImpl<RxNormMedication>(this as RxNormMedication, _$identity);

  /// Serializes this RxNormMedication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RxNormMedication&&(identical(other.rxcui, rxcui) || other.rxcui == rxcui)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.doseForm, doseForm) || other.doseForm == doseForm)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isGeneric, isGeneric) || other.isGeneric == isGeneric)&&const DeepCollectionEquality().equals(other.synonyms, synonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rxcui,name,genericName,brandName,strength,doseForm,route,const DeepCollectionEquality().hash(ingredients),classification,isGeneric,const DeepCollectionEquality().hash(synonyms));

@override
String toString() {
  return 'RxNormMedication(rxcui: $rxcui, name: $name, genericName: $genericName, brandName: $brandName, strength: $strength, doseForm: $doseForm, route: $route, ingredients: $ingredients, classification: $classification, isGeneric: $isGeneric, synonyms: $synonyms)';
}


}

/// @nodoc
abstract mixin class $RxNormMedicationCopyWith<$Res>  {
  factory $RxNormMedicationCopyWith(RxNormMedication value, $Res Function(RxNormMedication) _then) = _$RxNormMedicationCopyWithImpl;
@useResult
$Res call({
 String rxcui, String name, String? genericName, String? brandName, String? strength, String? doseForm, String? route, List<String> ingredients, String? classification, bool? isGeneric, List<String> synonyms
});




}
/// @nodoc
class _$RxNormMedicationCopyWithImpl<$Res>
    implements $RxNormMedicationCopyWith<$Res> {
  _$RxNormMedicationCopyWithImpl(this._self, this._then);

  final RxNormMedication _self;
  final $Res Function(RxNormMedication) _then;

/// Create a copy of RxNormMedication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rxcui = null,Object? name = null,Object? genericName = freezed,Object? brandName = freezed,Object? strength = freezed,Object? doseForm = freezed,Object? route = freezed,Object? ingredients = null,Object? classification = freezed,Object? isGeneric = freezed,Object? synonyms = null,}) {
  return _then(_self.copyWith(
rxcui: null == rxcui ? _self.rxcui : rxcui // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,doseForm: freezed == doseForm ? _self.doseForm : doseForm // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isGeneric: freezed == isGeneric ? _self.isGeneric : isGeneric // ignore: cast_nullable_to_non_nullable
as bool?,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RxNormMedication].
extension RxNormMedicationPatterns on RxNormMedication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RxNormMedication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RxNormMedication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RxNormMedication value)  $default,){
final _that = this;
switch (_that) {
case _RxNormMedication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RxNormMedication value)?  $default,){
final _that = this;
switch (_that) {
case _RxNormMedication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rxcui,  String name,  String? genericName,  String? brandName,  String? strength,  String? doseForm,  String? route,  List<String> ingredients,  String? classification,  bool? isGeneric,  List<String> synonyms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RxNormMedication() when $default != null:
return $default(_that.rxcui,_that.name,_that.genericName,_that.brandName,_that.strength,_that.doseForm,_that.route,_that.ingredients,_that.classification,_that.isGeneric,_that.synonyms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rxcui,  String name,  String? genericName,  String? brandName,  String? strength,  String? doseForm,  String? route,  List<String> ingredients,  String? classification,  bool? isGeneric,  List<String> synonyms)  $default,) {final _that = this;
switch (_that) {
case _RxNormMedication():
return $default(_that.rxcui,_that.name,_that.genericName,_that.brandName,_that.strength,_that.doseForm,_that.route,_that.ingredients,_that.classification,_that.isGeneric,_that.synonyms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rxcui,  String name,  String? genericName,  String? brandName,  String? strength,  String? doseForm,  String? route,  List<String> ingredients,  String? classification,  bool? isGeneric,  List<String> synonyms)?  $default,) {final _that = this;
switch (_that) {
case _RxNormMedication() when $default != null:
return $default(_that.rxcui,_that.name,_that.genericName,_that.brandName,_that.strength,_that.doseForm,_that.route,_that.ingredients,_that.classification,_that.isGeneric,_that.synonyms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RxNormMedication implements RxNormMedication {
  const _RxNormMedication({required this.rxcui, required this.name, this.genericName, this.brandName, this.strength, this.doseForm, this.route, final  List<String> ingredients = const [], this.classification, this.isGeneric, final  List<String> synonyms = const []}): _ingredients = ingredients,_synonyms = synonyms;
  factory _RxNormMedication.fromJson(Map<String, dynamic> json) => _$RxNormMedicationFromJson(json);

@override final  String rxcui;
@override final  String name;
@override final  String? genericName;
@override final  String? brandName;
@override final  String? strength;
@override final  String? doseForm;
@override final  String? route;
 final  List<String> _ingredients;
@override@JsonKey() List<String> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override final  String? classification;
@override final  bool? isGeneric;
 final  List<String> _synonyms;
@override@JsonKey() List<String> get synonyms {
  if (_synonyms is EqualUnmodifiableListView) return _synonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_synonyms);
}


/// Create a copy of RxNormMedication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RxNormMedicationCopyWith<_RxNormMedication> get copyWith => __$RxNormMedicationCopyWithImpl<_RxNormMedication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RxNormMedicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RxNormMedication&&(identical(other.rxcui, rxcui) || other.rxcui == rxcui)&&(identical(other.name, name) || other.name == name)&&(identical(other.genericName, genericName) || other.genericName == genericName)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.strength, strength) || other.strength == strength)&&(identical(other.doseForm, doseForm) || other.doseForm == doseForm)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.isGeneric, isGeneric) || other.isGeneric == isGeneric)&&const DeepCollectionEquality().equals(other._synonyms, _synonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rxcui,name,genericName,brandName,strength,doseForm,route,const DeepCollectionEquality().hash(_ingredients),classification,isGeneric,const DeepCollectionEquality().hash(_synonyms));

@override
String toString() {
  return 'RxNormMedication(rxcui: $rxcui, name: $name, genericName: $genericName, brandName: $brandName, strength: $strength, doseForm: $doseForm, route: $route, ingredients: $ingredients, classification: $classification, isGeneric: $isGeneric, synonyms: $synonyms)';
}


}

/// @nodoc
abstract mixin class _$RxNormMedicationCopyWith<$Res> implements $RxNormMedicationCopyWith<$Res> {
  factory _$RxNormMedicationCopyWith(_RxNormMedication value, $Res Function(_RxNormMedication) _then) = __$RxNormMedicationCopyWithImpl;
@override @useResult
$Res call({
 String rxcui, String name, String? genericName, String? brandName, String? strength, String? doseForm, String? route, List<String> ingredients, String? classification, bool? isGeneric, List<String> synonyms
});




}
/// @nodoc
class __$RxNormMedicationCopyWithImpl<$Res>
    implements _$RxNormMedicationCopyWith<$Res> {
  __$RxNormMedicationCopyWithImpl(this._self, this._then);

  final _RxNormMedication _self;
  final $Res Function(_RxNormMedication) _then;

/// Create a copy of RxNormMedication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rxcui = null,Object? name = null,Object? genericName = freezed,Object? brandName = freezed,Object? strength = freezed,Object? doseForm = freezed,Object? route = freezed,Object? ingredients = null,Object? classification = freezed,Object? isGeneric = freezed,Object? synonyms = null,}) {
  return _then(_RxNormMedication(
rxcui: null == rxcui ? _self.rxcui : rxcui // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genericName: freezed == genericName ? _self.genericName : genericName // ignore: cast_nullable_to_non_nullable
as String?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as String?,doseForm: freezed == doseForm ? _self.doseForm : doseForm // ignore: cast_nullable_to_non_nullable
as String?,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,classification: freezed == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String?,isGeneric: freezed == isGeneric ? _self.isGeneric : isGeneric // ignore: cast_nullable_to_non_nullable
as bool?,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$InteractionCheckRequest {

 List<String> get medicationIds; List<String> get rxNormCodes; List<String> get medicationNames; bool get includeMinor; bool get includeModerate; bool get includeMajor; bool get includeContraindicated; bool get includeFood; bool get includeConditions;
/// Create a copy of InteractionCheckRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionCheckRequestCopyWith<InteractionCheckRequest> get copyWith => _$InteractionCheckRequestCopyWithImpl<InteractionCheckRequest>(this as InteractionCheckRequest, _$identity);

  /// Serializes this InteractionCheckRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionCheckRequest&&const DeepCollectionEquality().equals(other.medicationIds, medicationIds)&&const DeepCollectionEquality().equals(other.rxNormCodes, rxNormCodes)&&const DeepCollectionEquality().equals(other.medicationNames, medicationNames)&&(identical(other.includeMinor, includeMinor) || other.includeMinor == includeMinor)&&(identical(other.includeModerate, includeModerate) || other.includeModerate == includeModerate)&&(identical(other.includeMajor, includeMajor) || other.includeMajor == includeMajor)&&(identical(other.includeContraindicated, includeContraindicated) || other.includeContraindicated == includeContraindicated)&&(identical(other.includeFood, includeFood) || other.includeFood == includeFood)&&(identical(other.includeConditions, includeConditions) || other.includeConditions == includeConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(medicationIds),const DeepCollectionEquality().hash(rxNormCodes),const DeepCollectionEquality().hash(medicationNames),includeMinor,includeModerate,includeMajor,includeContraindicated,includeFood,includeConditions);

@override
String toString() {
  return 'InteractionCheckRequest(medicationIds: $medicationIds, rxNormCodes: $rxNormCodes, medicationNames: $medicationNames, includeMinor: $includeMinor, includeModerate: $includeModerate, includeMajor: $includeMajor, includeContraindicated: $includeContraindicated, includeFood: $includeFood, includeConditions: $includeConditions)';
}


}

/// @nodoc
abstract mixin class $InteractionCheckRequestCopyWith<$Res>  {
  factory $InteractionCheckRequestCopyWith(InteractionCheckRequest value, $Res Function(InteractionCheckRequest) _then) = _$InteractionCheckRequestCopyWithImpl;
@useResult
$Res call({
 List<String> medicationIds, List<String> rxNormCodes, List<String> medicationNames, bool includeMinor, bool includeModerate, bool includeMajor, bool includeContraindicated, bool includeFood, bool includeConditions
});




}
/// @nodoc
class _$InteractionCheckRequestCopyWithImpl<$Res>
    implements $InteractionCheckRequestCopyWith<$Res> {
  _$InteractionCheckRequestCopyWithImpl(this._self, this._then);

  final InteractionCheckRequest _self;
  final $Res Function(InteractionCheckRequest) _then;

/// Create a copy of InteractionCheckRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationIds = null,Object? rxNormCodes = null,Object? medicationNames = null,Object? includeMinor = null,Object? includeModerate = null,Object? includeMajor = null,Object? includeContraindicated = null,Object? includeFood = null,Object? includeConditions = null,}) {
  return _then(_self.copyWith(
medicationIds: null == medicationIds ? _self.medicationIds : medicationIds // ignore: cast_nullable_to_non_nullable
as List<String>,rxNormCodes: null == rxNormCodes ? _self.rxNormCodes : rxNormCodes // ignore: cast_nullable_to_non_nullable
as List<String>,medicationNames: null == medicationNames ? _self.medicationNames : medicationNames // ignore: cast_nullable_to_non_nullable
as List<String>,includeMinor: null == includeMinor ? _self.includeMinor : includeMinor // ignore: cast_nullable_to_non_nullable
as bool,includeModerate: null == includeModerate ? _self.includeModerate : includeModerate // ignore: cast_nullable_to_non_nullable
as bool,includeMajor: null == includeMajor ? _self.includeMajor : includeMajor // ignore: cast_nullable_to_non_nullable
as bool,includeContraindicated: null == includeContraindicated ? _self.includeContraindicated : includeContraindicated // ignore: cast_nullable_to_non_nullable
as bool,includeFood: null == includeFood ? _self.includeFood : includeFood // ignore: cast_nullable_to_non_nullable
as bool,includeConditions: null == includeConditions ? _self.includeConditions : includeConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InteractionCheckRequest].
extension InteractionCheckRequestPatterns on InteractionCheckRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionCheckRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionCheckRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionCheckRequest value)  $default,){
final _that = this;
switch (_that) {
case _InteractionCheckRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionCheckRequest value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionCheckRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> medicationIds,  List<String> rxNormCodes,  List<String> medicationNames,  bool includeMinor,  bool includeModerate,  bool includeMajor,  bool includeContraindicated,  bool includeFood,  bool includeConditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionCheckRequest() when $default != null:
return $default(_that.medicationIds,_that.rxNormCodes,_that.medicationNames,_that.includeMinor,_that.includeModerate,_that.includeMajor,_that.includeContraindicated,_that.includeFood,_that.includeConditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> medicationIds,  List<String> rxNormCodes,  List<String> medicationNames,  bool includeMinor,  bool includeModerate,  bool includeMajor,  bool includeContraindicated,  bool includeFood,  bool includeConditions)  $default,) {final _that = this;
switch (_that) {
case _InteractionCheckRequest():
return $default(_that.medicationIds,_that.rxNormCodes,_that.medicationNames,_that.includeMinor,_that.includeModerate,_that.includeMajor,_that.includeContraindicated,_that.includeFood,_that.includeConditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> medicationIds,  List<String> rxNormCodes,  List<String> medicationNames,  bool includeMinor,  bool includeModerate,  bool includeMajor,  bool includeContraindicated,  bool includeFood,  bool includeConditions)?  $default,) {final _that = this;
switch (_that) {
case _InteractionCheckRequest() when $default != null:
return $default(_that.medicationIds,_that.rxNormCodes,_that.medicationNames,_that.includeMinor,_that.includeModerate,_that.includeMajor,_that.includeContraindicated,_that.includeFood,_that.includeConditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionCheckRequest implements InteractionCheckRequest {
  const _InteractionCheckRequest({final  List<String> medicationIds = const [], final  List<String> rxNormCodes = const [], final  List<String> medicationNames = const [], this.includeMinor = true, this.includeModerate = true, this.includeMajor = true, this.includeContraindicated = true, this.includeFood = false, this.includeConditions = false}): _medicationIds = medicationIds,_rxNormCodes = rxNormCodes,_medicationNames = medicationNames;
  factory _InteractionCheckRequest.fromJson(Map<String, dynamic> json) => _$InteractionCheckRequestFromJson(json);

 final  List<String> _medicationIds;
@override@JsonKey() List<String> get medicationIds {
  if (_medicationIds is EqualUnmodifiableListView) return _medicationIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicationIds);
}

 final  List<String> _rxNormCodes;
@override@JsonKey() List<String> get rxNormCodes {
  if (_rxNormCodes is EqualUnmodifiableListView) return _rxNormCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rxNormCodes);
}

 final  List<String> _medicationNames;
@override@JsonKey() List<String> get medicationNames {
  if (_medicationNames is EqualUnmodifiableListView) return _medicationNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicationNames);
}

@override@JsonKey() final  bool includeMinor;
@override@JsonKey() final  bool includeModerate;
@override@JsonKey() final  bool includeMajor;
@override@JsonKey() final  bool includeContraindicated;
@override@JsonKey() final  bool includeFood;
@override@JsonKey() final  bool includeConditions;

/// Create a copy of InteractionCheckRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionCheckRequestCopyWith<_InteractionCheckRequest> get copyWith => __$InteractionCheckRequestCopyWithImpl<_InteractionCheckRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionCheckRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionCheckRequest&&const DeepCollectionEquality().equals(other._medicationIds, _medicationIds)&&const DeepCollectionEquality().equals(other._rxNormCodes, _rxNormCodes)&&const DeepCollectionEquality().equals(other._medicationNames, _medicationNames)&&(identical(other.includeMinor, includeMinor) || other.includeMinor == includeMinor)&&(identical(other.includeModerate, includeModerate) || other.includeModerate == includeModerate)&&(identical(other.includeMajor, includeMajor) || other.includeMajor == includeMajor)&&(identical(other.includeContraindicated, includeContraindicated) || other.includeContraindicated == includeContraindicated)&&(identical(other.includeFood, includeFood) || other.includeFood == includeFood)&&(identical(other.includeConditions, includeConditions) || other.includeConditions == includeConditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_medicationIds),const DeepCollectionEquality().hash(_rxNormCodes),const DeepCollectionEquality().hash(_medicationNames),includeMinor,includeModerate,includeMajor,includeContraindicated,includeFood,includeConditions);

@override
String toString() {
  return 'InteractionCheckRequest(medicationIds: $medicationIds, rxNormCodes: $rxNormCodes, medicationNames: $medicationNames, includeMinor: $includeMinor, includeModerate: $includeModerate, includeMajor: $includeMajor, includeContraindicated: $includeContraindicated, includeFood: $includeFood, includeConditions: $includeConditions)';
}


}

/// @nodoc
abstract mixin class _$InteractionCheckRequestCopyWith<$Res> implements $InteractionCheckRequestCopyWith<$Res> {
  factory _$InteractionCheckRequestCopyWith(_InteractionCheckRequest value, $Res Function(_InteractionCheckRequest) _then) = __$InteractionCheckRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> medicationIds, List<String> rxNormCodes, List<String> medicationNames, bool includeMinor, bool includeModerate, bool includeMajor, bool includeContraindicated, bool includeFood, bool includeConditions
});




}
/// @nodoc
class __$InteractionCheckRequestCopyWithImpl<$Res>
    implements _$InteractionCheckRequestCopyWith<$Res> {
  __$InteractionCheckRequestCopyWithImpl(this._self, this._then);

  final _InteractionCheckRequest _self;
  final $Res Function(_InteractionCheckRequest) _then;

/// Create a copy of InteractionCheckRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationIds = null,Object? rxNormCodes = null,Object? medicationNames = null,Object? includeMinor = null,Object? includeModerate = null,Object? includeMajor = null,Object? includeContraindicated = null,Object? includeFood = null,Object? includeConditions = null,}) {
  return _then(_InteractionCheckRequest(
medicationIds: null == medicationIds ? _self._medicationIds : medicationIds // ignore: cast_nullable_to_non_nullable
as List<String>,rxNormCodes: null == rxNormCodes ? _self._rxNormCodes : rxNormCodes // ignore: cast_nullable_to_non_nullable
as List<String>,medicationNames: null == medicationNames ? _self._medicationNames : medicationNames // ignore: cast_nullable_to_non_nullable
as List<String>,includeMinor: null == includeMinor ? _self.includeMinor : includeMinor // ignore: cast_nullable_to_non_nullable
as bool,includeModerate: null == includeModerate ? _self.includeModerate : includeModerate // ignore: cast_nullable_to_non_nullable
as bool,includeMajor: null == includeMajor ? _self.includeMajor : includeMajor // ignore: cast_nullable_to_non_nullable
as bool,includeContraindicated: null == includeContraindicated ? _self.includeContraindicated : includeContraindicated // ignore: cast_nullable_to_non_nullable
as bool,includeFood: null == includeFood ? _self.includeFood : includeFood // ignore: cast_nullable_to_non_nullable
as bool,includeConditions: null == includeConditions ? _self.includeConditions : includeConditions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RxNormSearchRequest {

 String get searchTerm; int get maxResults; bool get exactMatch; bool get includeSynonyms; List<String> get sources;
/// Create a copy of RxNormSearchRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RxNormSearchRequestCopyWith<RxNormSearchRequest> get copyWith => _$RxNormSearchRequestCopyWithImpl<RxNormSearchRequest>(this as RxNormSearchRequest, _$identity);

  /// Serializes this RxNormSearchRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RxNormSearchRequest&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.maxResults, maxResults) || other.maxResults == maxResults)&&(identical(other.exactMatch, exactMatch) || other.exactMatch == exactMatch)&&(identical(other.includeSynonyms, includeSynonyms) || other.includeSynonyms == includeSynonyms)&&const DeepCollectionEquality().equals(other.sources, sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchTerm,maxResults,exactMatch,includeSynonyms,const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'RxNormSearchRequest(searchTerm: $searchTerm, maxResults: $maxResults, exactMatch: $exactMatch, includeSynonyms: $includeSynonyms, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $RxNormSearchRequestCopyWith<$Res>  {
  factory $RxNormSearchRequestCopyWith(RxNormSearchRequest value, $Res Function(RxNormSearchRequest) _then) = _$RxNormSearchRequestCopyWithImpl;
@useResult
$Res call({
 String searchTerm, int maxResults, bool exactMatch, bool includeSynonyms, List<String> sources
});




}
/// @nodoc
class _$RxNormSearchRequestCopyWithImpl<$Res>
    implements $RxNormSearchRequestCopyWith<$Res> {
  _$RxNormSearchRequestCopyWithImpl(this._self, this._then);

  final RxNormSearchRequest _self;
  final $Res Function(RxNormSearchRequest) _then;

/// Create a copy of RxNormSearchRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchTerm = null,Object? maxResults = null,Object? exactMatch = null,Object? includeSynonyms = null,Object? sources = null,}) {
  return _then(_self.copyWith(
searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,maxResults: null == maxResults ? _self.maxResults : maxResults // ignore: cast_nullable_to_non_nullable
as int,exactMatch: null == exactMatch ? _self.exactMatch : exactMatch // ignore: cast_nullable_to_non_nullable
as bool,includeSynonyms: null == includeSynonyms ? _self.includeSynonyms : includeSynonyms // ignore: cast_nullable_to_non_nullable
as bool,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RxNormSearchRequest].
extension RxNormSearchRequestPatterns on RxNormSearchRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RxNormSearchRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RxNormSearchRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RxNormSearchRequest value)  $default,){
final _that = this;
switch (_that) {
case _RxNormSearchRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RxNormSearchRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RxNormSearchRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchTerm,  int maxResults,  bool exactMatch,  bool includeSynonyms,  List<String> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RxNormSearchRequest() when $default != null:
return $default(_that.searchTerm,_that.maxResults,_that.exactMatch,_that.includeSynonyms,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchTerm,  int maxResults,  bool exactMatch,  bool includeSynonyms,  List<String> sources)  $default,) {final _that = this;
switch (_that) {
case _RxNormSearchRequest():
return $default(_that.searchTerm,_that.maxResults,_that.exactMatch,_that.includeSynonyms,_that.sources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchTerm,  int maxResults,  bool exactMatch,  bool includeSynonyms,  List<String> sources)?  $default,) {final _that = this;
switch (_that) {
case _RxNormSearchRequest() when $default != null:
return $default(_that.searchTerm,_that.maxResults,_that.exactMatch,_that.includeSynonyms,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RxNormSearchRequest implements RxNormSearchRequest {
  const _RxNormSearchRequest({required this.searchTerm, this.maxResults = 10, this.exactMatch = false, this.includeSynonyms = true, final  List<String> sources = const []}): _sources = sources;
  factory _RxNormSearchRequest.fromJson(Map<String, dynamic> json) => _$RxNormSearchRequestFromJson(json);

@override final  String searchTerm;
@override@JsonKey() final  int maxResults;
@override@JsonKey() final  bool exactMatch;
@override@JsonKey() final  bool includeSynonyms;
 final  List<String> _sources;
@override@JsonKey() List<String> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of RxNormSearchRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RxNormSearchRequestCopyWith<_RxNormSearchRequest> get copyWith => __$RxNormSearchRequestCopyWithImpl<_RxNormSearchRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RxNormSearchRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RxNormSearchRequest&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.maxResults, maxResults) || other.maxResults == maxResults)&&(identical(other.exactMatch, exactMatch) || other.exactMatch == exactMatch)&&(identical(other.includeSynonyms, includeSynonyms) || other.includeSynonyms == includeSynonyms)&&const DeepCollectionEquality().equals(other._sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,searchTerm,maxResults,exactMatch,includeSynonyms,const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'RxNormSearchRequest(searchTerm: $searchTerm, maxResults: $maxResults, exactMatch: $exactMatch, includeSynonyms: $includeSynonyms, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$RxNormSearchRequestCopyWith<$Res> implements $RxNormSearchRequestCopyWith<$Res> {
  factory _$RxNormSearchRequestCopyWith(_RxNormSearchRequest value, $Res Function(_RxNormSearchRequest) _then) = __$RxNormSearchRequestCopyWithImpl;
@override @useResult
$Res call({
 String searchTerm, int maxResults, bool exactMatch, bool includeSynonyms, List<String> sources
});




}
/// @nodoc
class __$RxNormSearchRequestCopyWithImpl<$Res>
    implements _$RxNormSearchRequestCopyWith<$Res> {
  __$RxNormSearchRequestCopyWithImpl(this._self, this._then);

  final _RxNormSearchRequest _self;
  final $Res Function(_RxNormSearchRequest) _then;

/// Create a copy of RxNormSearchRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchTerm = null,Object? maxResults = null,Object? exactMatch = null,Object? includeSynonyms = null,Object? sources = null,}) {
  return _then(_RxNormSearchRequest(
searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,maxResults: null == maxResults ? _self.maxResults : maxResults // ignore: cast_nullable_to_non_nullable
as int,exactMatch: null == exactMatch ? _self.exactMatch : exactMatch // ignore: cast_nullable_to_non_nullable
as bool,includeSynonyms: null == includeSynonyms ? _self.includeSynonyms : includeSynonyms // ignore: cast_nullable_to_non_nullable
as bool,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$MedicationEnrichmentRequest {

 String get medicationId; String? get medicationName; String? get rxNormCode; bool get updateClassification; bool get updateIngredients; bool get updateInteractions;
/// Create a copy of MedicationEnrichmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationEnrichmentRequestCopyWith<MedicationEnrichmentRequest> get copyWith => _$MedicationEnrichmentRequestCopyWithImpl<MedicationEnrichmentRequest>(this as MedicationEnrichmentRequest, _$identity);

  /// Serializes this MedicationEnrichmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationEnrichmentRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.medicationName, medicationName) || other.medicationName == medicationName)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.updateClassification, updateClassification) || other.updateClassification == updateClassification)&&(identical(other.updateIngredients, updateIngredients) || other.updateIngredients == updateIngredients)&&(identical(other.updateInteractions, updateInteractions) || other.updateInteractions == updateInteractions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,medicationName,rxNormCode,updateClassification,updateIngredients,updateInteractions);

@override
String toString() {
  return 'MedicationEnrichmentRequest(medicationId: $medicationId, medicationName: $medicationName, rxNormCode: $rxNormCode, updateClassification: $updateClassification, updateIngredients: $updateIngredients, updateInteractions: $updateInteractions)';
}


}

/// @nodoc
abstract mixin class $MedicationEnrichmentRequestCopyWith<$Res>  {
  factory $MedicationEnrichmentRequestCopyWith(MedicationEnrichmentRequest value, $Res Function(MedicationEnrichmentRequest) _then) = _$MedicationEnrichmentRequestCopyWithImpl;
@useResult
$Res call({
 String medicationId, String? medicationName, String? rxNormCode, bool updateClassification, bool updateIngredients, bool updateInteractions
});




}
/// @nodoc
class _$MedicationEnrichmentRequestCopyWithImpl<$Res>
    implements $MedicationEnrichmentRequestCopyWith<$Res> {
  _$MedicationEnrichmentRequestCopyWithImpl(this._self, this._then);

  final MedicationEnrichmentRequest _self;
  final $Res Function(MedicationEnrichmentRequest) _then;

/// Create a copy of MedicationEnrichmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicationId = null,Object? medicationName = freezed,Object? rxNormCode = freezed,Object? updateClassification = null,Object? updateIngredients = null,Object? updateInteractions = null,}) {
  return _then(_self.copyWith(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,medicationName: freezed == medicationName ? _self.medicationName : medicationName // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,updateClassification: null == updateClassification ? _self.updateClassification : updateClassification // ignore: cast_nullable_to_non_nullable
as bool,updateIngredients: null == updateIngredients ? _self.updateIngredients : updateIngredients // ignore: cast_nullable_to_non_nullable
as bool,updateInteractions: null == updateInteractions ? _self.updateInteractions : updateInteractions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicationEnrichmentRequest].
extension MedicationEnrichmentRequestPatterns on MedicationEnrichmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationEnrichmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationEnrichmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationEnrichmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String medicationId,  String? medicationName,  String? rxNormCode,  bool updateClassification,  bool updateIngredients,  bool updateInteractions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest() when $default != null:
return $default(_that.medicationId,_that.medicationName,_that.rxNormCode,_that.updateClassification,_that.updateIngredients,_that.updateInteractions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String medicationId,  String? medicationName,  String? rxNormCode,  bool updateClassification,  bool updateIngredients,  bool updateInteractions)  $default,) {final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest():
return $default(_that.medicationId,_that.medicationName,_that.rxNormCode,_that.updateClassification,_that.updateIngredients,_that.updateInteractions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String medicationId,  String? medicationName,  String? rxNormCode,  bool updateClassification,  bool updateIngredients,  bool updateInteractions)?  $default,) {final _that = this;
switch (_that) {
case _MedicationEnrichmentRequest() when $default != null:
return $default(_that.medicationId,_that.medicationName,_that.rxNormCode,_that.updateClassification,_that.updateIngredients,_that.updateInteractions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationEnrichmentRequest implements MedicationEnrichmentRequest {
  const _MedicationEnrichmentRequest({required this.medicationId, this.medicationName, this.rxNormCode, this.updateClassification = true, this.updateIngredients = true, this.updateInteractions = true});
  factory _MedicationEnrichmentRequest.fromJson(Map<String, dynamic> json) => _$MedicationEnrichmentRequestFromJson(json);

@override final  String medicationId;
@override final  String? medicationName;
@override final  String? rxNormCode;
@override@JsonKey() final  bool updateClassification;
@override@JsonKey() final  bool updateIngredients;
@override@JsonKey() final  bool updateInteractions;

/// Create a copy of MedicationEnrichmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationEnrichmentRequestCopyWith<_MedicationEnrichmentRequest> get copyWith => __$MedicationEnrichmentRequestCopyWithImpl<_MedicationEnrichmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationEnrichmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationEnrichmentRequest&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.medicationName, medicationName) || other.medicationName == medicationName)&&(identical(other.rxNormCode, rxNormCode) || other.rxNormCode == rxNormCode)&&(identical(other.updateClassification, updateClassification) || other.updateClassification == updateClassification)&&(identical(other.updateIngredients, updateIngredients) || other.updateIngredients == updateIngredients)&&(identical(other.updateInteractions, updateInteractions) || other.updateInteractions == updateInteractions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,medicationId,medicationName,rxNormCode,updateClassification,updateIngredients,updateInteractions);

@override
String toString() {
  return 'MedicationEnrichmentRequest(medicationId: $medicationId, medicationName: $medicationName, rxNormCode: $rxNormCode, updateClassification: $updateClassification, updateIngredients: $updateIngredients, updateInteractions: $updateInteractions)';
}


}

/// @nodoc
abstract mixin class _$MedicationEnrichmentRequestCopyWith<$Res> implements $MedicationEnrichmentRequestCopyWith<$Res> {
  factory _$MedicationEnrichmentRequestCopyWith(_MedicationEnrichmentRequest value, $Res Function(_MedicationEnrichmentRequest) _then) = __$MedicationEnrichmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String medicationId, String? medicationName, String? rxNormCode, bool updateClassification, bool updateIngredients, bool updateInteractions
});




}
/// @nodoc
class __$MedicationEnrichmentRequestCopyWithImpl<$Res>
    implements _$MedicationEnrichmentRequestCopyWith<$Res> {
  __$MedicationEnrichmentRequestCopyWithImpl(this._self, this._then);

  final _MedicationEnrichmentRequest _self;
  final $Res Function(_MedicationEnrichmentRequest) _then;

/// Create a copy of MedicationEnrichmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicationId = null,Object? medicationName = freezed,Object? rxNormCode = freezed,Object? updateClassification = null,Object? updateIngredients = null,Object? updateInteractions = null,}) {
  return _then(_MedicationEnrichmentRequest(
medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,medicationName: freezed == medicationName ? _self.medicationName : medicationName // ignore: cast_nullable_to_non_nullable
as String?,rxNormCode: freezed == rxNormCode ? _self.rxNormCode : rxNormCode // ignore: cast_nullable_to_non_nullable
as String?,updateClassification: null == updateClassification ? _self.updateClassification : updateClassification // ignore: cast_nullable_to_non_nullable
as bool,updateIngredients: null == updateIngredients ? _self.updateIngredients : updateIngredients // ignore: cast_nullable_to_non_nullable
as bool,updateInteractions: null == updateInteractions ? _self.updateInteractions : updateInteractions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$InteractionAnalysisResponse {

 bool get success; InteractionAnalysis? get data; String? get message; String? get error;
/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionAnalysisResponseCopyWith<InteractionAnalysisResponse> get copyWith => _$InteractionAnalysisResponseCopyWithImpl<InteractionAnalysisResponse>(this as InteractionAnalysisResponse, _$identity);

  /// Serializes this InteractionAnalysisResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionAnalysisResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'InteractionAnalysisResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $InteractionAnalysisResponseCopyWith<$Res>  {
  factory $InteractionAnalysisResponseCopyWith(InteractionAnalysisResponse value, $Res Function(InteractionAnalysisResponse) _then) = _$InteractionAnalysisResponseCopyWithImpl;
@useResult
$Res call({
 bool success, InteractionAnalysis? data, String? message, String? error
});


$InteractionAnalysisCopyWith<$Res>? get data;

}
/// @nodoc
class _$InteractionAnalysisResponseCopyWithImpl<$Res>
    implements $InteractionAnalysisResponseCopyWith<$Res> {
  _$InteractionAnalysisResponseCopyWithImpl(this._self, this._then);

  final InteractionAnalysisResponse _self;
  final $Res Function(InteractionAnalysisResponse) _then;

/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InteractionAnalysis?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InteractionAnalysisCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $InteractionAnalysisCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [InteractionAnalysisResponse].
extension InteractionAnalysisResponsePatterns on InteractionAnalysisResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InteractionAnalysisResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InteractionAnalysisResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InteractionAnalysisResponse value)  $default,){
final _that = this;
switch (_that) {
case _InteractionAnalysisResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InteractionAnalysisResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InteractionAnalysisResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  InteractionAnalysis? data,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InteractionAnalysisResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  InteractionAnalysis? data,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _InteractionAnalysisResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  InteractionAnalysis? data,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _InteractionAnalysisResponse() when $default != null:
return $default(_that.success,_that.data,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InteractionAnalysisResponse implements InteractionAnalysisResponse {
  const _InteractionAnalysisResponse({required this.success, this.data, this.message, this.error});
  factory _InteractionAnalysisResponse.fromJson(Map<String, dynamic> json) => _$InteractionAnalysisResponseFromJson(json);

@override final  bool success;
@override final  InteractionAnalysis? data;
@override final  String? message;
@override final  String? error;

/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InteractionAnalysisResponseCopyWith<_InteractionAnalysisResponse> get copyWith => __$InteractionAnalysisResponseCopyWithImpl<_InteractionAnalysisResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InteractionAnalysisResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InteractionAnalysisResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data,message,error);

@override
String toString() {
  return 'InteractionAnalysisResponse(success: $success, data: $data, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$InteractionAnalysisResponseCopyWith<$Res> implements $InteractionAnalysisResponseCopyWith<$Res> {
  factory _$InteractionAnalysisResponseCopyWith(_InteractionAnalysisResponse value, $Res Function(_InteractionAnalysisResponse) _then) = __$InteractionAnalysisResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, InteractionAnalysis? data, String? message, String? error
});


@override $InteractionAnalysisCopyWith<$Res>? get data;

}
/// @nodoc
class __$InteractionAnalysisResponseCopyWithImpl<$Res>
    implements _$InteractionAnalysisResponseCopyWith<$Res> {
  __$InteractionAnalysisResponseCopyWithImpl(this._self, this._then);

  final _InteractionAnalysisResponse _self;
  final $Res Function(_InteractionAnalysisResponse) _then;

/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_InteractionAnalysisResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InteractionAnalysis?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InteractionAnalysisResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InteractionAnalysisCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $InteractionAnalysisCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$RxNormSearchResponse {

 bool get success; List<RxNormMedication> get data; int? get count; String? get message; String? get error;
/// Create a copy of RxNormSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RxNormSearchResponseCopyWith<RxNormSearchResponse> get copyWith => _$RxNormSearchResponseCopyWithImpl<RxNormSearchResponse>(this as RxNormSearchResponse, _$identity);

  /// Serializes this RxNormSearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RxNormSearchResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.count, count) || other.count == count)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(data),count,message,error);

@override
String toString() {
  return 'RxNormSearchResponse(success: $success, data: $data, count: $count, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $RxNormSearchResponseCopyWith<$Res>  {
  factory $RxNormSearchResponseCopyWith(RxNormSearchResponse value, $Res Function(RxNormSearchResponse) _then) = _$RxNormSearchResponseCopyWithImpl;
@useResult
$Res call({
 bool success, List<RxNormMedication> data, int? count, String? message, String? error
});




}
/// @nodoc
class _$RxNormSearchResponseCopyWithImpl<$Res>
    implements $RxNormSearchResponseCopyWith<$Res> {
  _$RxNormSearchResponseCopyWithImpl(this._self, this._then);

  final RxNormSearchResponse _self;
  final $Res Function(RxNormSearchResponse) _then;

/// Create a copy of RxNormSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<RxNormMedication>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RxNormSearchResponse].
extension RxNormSearchResponsePatterns on RxNormSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RxNormSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RxNormSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RxNormSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _RxNormSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RxNormSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RxNormSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  List<RxNormMedication> data,  int? count,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RxNormSearchResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  List<RxNormMedication> data,  int? count,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _RxNormSearchResponse():
return $default(_that.success,_that.data,_that.count,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  List<RxNormMedication> data,  int? count,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _RxNormSearchResponse() when $default != null:
return $default(_that.success,_that.data,_that.count,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RxNormSearchResponse implements RxNormSearchResponse {
  const _RxNormSearchResponse({required this.success, final  List<RxNormMedication> data = const [], this.count, this.message, this.error}): _data = data;
  factory _RxNormSearchResponse.fromJson(Map<String, dynamic> json) => _$RxNormSearchResponseFromJson(json);

@override final  bool success;
 final  List<RxNormMedication> _data;
@override@JsonKey() List<RxNormMedication> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  int? count;
@override final  String? message;
@override final  String? error;

/// Create a copy of RxNormSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RxNormSearchResponseCopyWith<_RxNormSearchResponse> get copyWith => __$RxNormSearchResponseCopyWithImpl<_RxNormSearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RxNormSearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RxNormSearchResponse&&(identical(other.success, success) || other.success == success)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.count, count) || other.count == count)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,const DeepCollectionEquality().hash(_data),count,message,error);

@override
String toString() {
  return 'RxNormSearchResponse(success: $success, data: $data, count: $count, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$RxNormSearchResponseCopyWith<$Res> implements $RxNormSearchResponseCopyWith<$Res> {
  factory _$RxNormSearchResponseCopyWith(_RxNormSearchResponse value, $Res Function(_RxNormSearchResponse) _then) = __$RxNormSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, List<RxNormMedication> data, int? count, String? message, String? error
});




}
/// @nodoc
class __$RxNormSearchResponseCopyWithImpl<$Res>
    implements _$RxNormSearchResponseCopyWith<$Res> {
  __$RxNormSearchResponseCopyWithImpl(this._self, this._then);

  final _RxNormSearchResponse _self;
  final $Res Function(_RxNormSearchResponse) _then;

/// Create a copy of RxNormSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,Object? count = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_RxNormSearchResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<RxNormMedication>,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MedicationEnrichmentResponse {

 bool get success; RxNormMedication? get enrichedData; List<InteractionAlert> get interactions; String? get message; String? get error;
/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationEnrichmentResponseCopyWith<MedicationEnrichmentResponse> get copyWith => _$MedicationEnrichmentResponseCopyWithImpl<MedicationEnrichmentResponse>(this as MedicationEnrichmentResponse, _$identity);

  /// Serializes this MedicationEnrichmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicationEnrichmentResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.enrichedData, enrichedData) || other.enrichedData == enrichedData)&&const DeepCollectionEquality().equals(other.interactions, interactions)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,enrichedData,const DeepCollectionEquality().hash(interactions),message,error);

@override
String toString() {
  return 'MedicationEnrichmentResponse(success: $success, enrichedData: $enrichedData, interactions: $interactions, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $MedicationEnrichmentResponseCopyWith<$Res>  {
  factory $MedicationEnrichmentResponseCopyWith(MedicationEnrichmentResponse value, $Res Function(MedicationEnrichmentResponse) _then) = _$MedicationEnrichmentResponseCopyWithImpl;
@useResult
$Res call({
 bool success, RxNormMedication? enrichedData, List<InteractionAlert> interactions, String? message, String? error
});


$RxNormMedicationCopyWith<$Res>? get enrichedData;

}
/// @nodoc
class _$MedicationEnrichmentResponseCopyWithImpl<$Res>
    implements $MedicationEnrichmentResponseCopyWith<$Res> {
  _$MedicationEnrichmentResponseCopyWithImpl(this._self, this._then);

  final MedicationEnrichmentResponse _self;
  final $Res Function(MedicationEnrichmentResponse) _then;

/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? enrichedData = freezed,Object? interactions = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,enrichedData: freezed == enrichedData ? _self.enrichedData : enrichedData // ignore: cast_nullable_to_non_nullable
as RxNormMedication?,interactions: null == interactions ? _self.interactions : interactions // ignore: cast_nullable_to_non_nullable
as List<InteractionAlert>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RxNormMedicationCopyWith<$Res>? get enrichedData {
    if (_self.enrichedData == null) {
    return null;
  }

  return $RxNormMedicationCopyWith<$Res>(_self.enrichedData!, (value) {
    return _then(_self.copyWith(enrichedData: value));
  });
}
}


/// Adds pattern-matching-related methods to [MedicationEnrichmentResponse].
extension MedicationEnrichmentResponsePatterns on MedicationEnrichmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicationEnrichmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicationEnrichmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicationEnrichmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  RxNormMedication? enrichedData,  List<InteractionAlert> interactions,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse() when $default != null:
return $default(_that.success,_that.enrichedData,_that.interactions,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  RxNormMedication? enrichedData,  List<InteractionAlert> interactions,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse():
return $default(_that.success,_that.enrichedData,_that.interactions,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  RxNormMedication? enrichedData,  List<InteractionAlert> interactions,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MedicationEnrichmentResponse() when $default != null:
return $default(_that.success,_that.enrichedData,_that.interactions,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicationEnrichmentResponse implements MedicationEnrichmentResponse {
  const _MedicationEnrichmentResponse({required this.success, this.enrichedData, final  List<InteractionAlert> interactions = const [], this.message, this.error}): _interactions = interactions;
  factory _MedicationEnrichmentResponse.fromJson(Map<String, dynamic> json) => _$MedicationEnrichmentResponseFromJson(json);

@override final  bool success;
@override final  RxNormMedication? enrichedData;
 final  List<InteractionAlert> _interactions;
@override@JsonKey() List<InteractionAlert> get interactions {
  if (_interactions is EqualUnmodifiableListView) return _interactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interactions);
}

@override final  String? message;
@override final  String? error;

/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationEnrichmentResponseCopyWith<_MedicationEnrichmentResponse> get copyWith => __$MedicationEnrichmentResponseCopyWithImpl<_MedicationEnrichmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationEnrichmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicationEnrichmentResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.enrichedData, enrichedData) || other.enrichedData == enrichedData)&&const DeepCollectionEquality().equals(other._interactions, _interactions)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,enrichedData,const DeepCollectionEquality().hash(_interactions),message,error);

@override
String toString() {
  return 'MedicationEnrichmentResponse(success: $success, enrichedData: $enrichedData, interactions: $interactions, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MedicationEnrichmentResponseCopyWith<$Res> implements $MedicationEnrichmentResponseCopyWith<$Res> {
  factory _$MedicationEnrichmentResponseCopyWith(_MedicationEnrichmentResponse value, $Res Function(_MedicationEnrichmentResponse) _then) = __$MedicationEnrichmentResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, RxNormMedication? enrichedData, List<InteractionAlert> interactions, String? message, String? error
});


@override $RxNormMedicationCopyWith<$Res>? get enrichedData;

}
/// @nodoc
class __$MedicationEnrichmentResponseCopyWithImpl<$Res>
    implements _$MedicationEnrichmentResponseCopyWith<$Res> {
  __$MedicationEnrichmentResponseCopyWithImpl(this._self, this._then);

  final _MedicationEnrichmentResponse _self;
  final $Res Function(_MedicationEnrichmentResponse) _then;

/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? enrichedData = freezed,Object? interactions = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(_MedicationEnrichmentResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,enrichedData: freezed == enrichedData ? _self.enrichedData : enrichedData // ignore: cast_nullable_to_non_nullable
as RxNormMedication?,interactions: null == interactions ? _self._interactions : interactions // ignore: cast_nullable_to_non_nullable
as List<InteractionAlert>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MedicationEnrichmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RxNormMedicationCopyWith<$Res>? get enrichedData {
    if (_self.enrichedData == null) {
    return null;
  }

  return $RxNormMedicationCopyWith<$Res>(_self.enrichedData!, (value) {
    return _then(_self.copyWith(enrichedData: value));
  });
}
}

// dart format on
