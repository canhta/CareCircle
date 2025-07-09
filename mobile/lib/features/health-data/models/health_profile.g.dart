// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaselineMetrics _$BaselineMetricsFromJson(Map<String, dynamic> json) =>
    BaselineMetrics(
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      restingHeartRate: (json['restingHeartRate'] as num).toDouble(),
      bloodPressure: BloodPressure.fromJson(
        json['bloodPressure'] as Map<String, dynamic>,
      ),
      bloodGlucose: (json['bloodGlucose'] as num).toDouble(),
    );

Map<String, dynamic> _$BaselineMetricsToJson(BaselineMetrics instance) =>
    <String, dynamic>{
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'restingHeartRate': instance.restingHeartRate,
      'bloodPressure': instance.bloodPressure,
      'bloodGlucose': instance.bloodGlucose,
    };

BloodPressure _$BloodPressureFromJson(Map<String, dynamic> json) =>
    BloodPressure(
      systolic: (json['systolic'] as num).toDouble(),
      diastolic: (json['diastolic'] as num).toDouble(),
    );

Map<String, dynamic> _$BloodPressureToJson(BloodPressure instance) =>
    <String, dynamic>{
      'systolic': instance.systolic,
      'diastolic': instance.diastolic,
    };

HealthCondition _$HealthConditionFromJson(Map<String, dynamic> json) =>
    HealthCondition(
      name: json['name'] as String,
      diagnosisDate: json['diagnosisDate'] == null
          ? null
          : DateTime.parse(json['diagnosisDate'] as String),
      isCurrent: json['isCurrent'] as bool,
      severity: json['severity'] as String,
      medications: (json['medications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$HealthConditionToJson(HealthCondition instance) =>
    <String, dynamic>{
      'name': instance.name,
      'diagnosisDate': instance.diagnosisDate?.toIso8601String(),
      'isCurrent': instance.isCurrent,
      'severity': instance.severity,
      'medications': instance.medications,
      'notes': instance.notes,
    };

Allergy _$AllergyFromJson(Map<String, dynamic> json) => Allergy(
  allergen: json['allergen'] as String,
  reactionType: json['reactionType'] as String,
  severity: json['severity'] as String,
);

Map<String, dynamic> _$AllergyToJson(Allergy instance) => <String, dynamic>{
  'allergen': instance.allergen,
  'reactionType': instance.reactionType,
  'severity': instance.severity,
};

RiskFactor _$RiskFactorFromJson(Map<String, dynamic> json) => RiskFactor(
  type: json['type'] as String,
  description: json['description'] as String,
  riskLevel: json['riskLevel'] as String,
);

Map<String, dynamic> _$RiskFactorToJson(RiskFactor instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'riskLevel': instance.riskLevel,
    };

HealthGoal _$HealthGoalFromJson(Map<String, dynamic> json) => HealthGoal(
  id: json['id'] as String,
  metricType: json['metricType'] as String,
  targetValue: (json['targetValue'] as num).toDouble(),
  unit: json['unit'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  targetDate: DateTime.parse(json['targetDate'] as String),
  currentValue: (json['currentValue'] as num).toDouble(),
  progress: (json['progress'] as num).toDouble(),
  status: json['status'] as String,
  recurrence: json['recurrence'] as String,
);

Map<String, dynamic> _$HealthGoalToJson(HealthGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'metricType': instance.metricType,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'startDate': instance.startDate.toIso8601String(),
      'targetDate': instance.targetDate.toIso8601String(),
      'currentValue': instance.currentValue,
      'progress': instance.progress,
      'status': instance.status,
      'recurrence': instance.recurrence,
    };

HealthProfile _$HealthProfileFromJson(Map<String, dynamic> json) =>
    HealthProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      baselineMetrics: BaselineMetrics.fromJson(
        json['baselineMetrics'] as Map<String, dynamic>,
      ),
      healthConditions: (json['healthConditions'] as List<dynamic>)
          .map((e) => HealthCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      allergies: (json['allergies'] as List<dynamic>)
          .map((e) => Allergy.fromJson(e as Map<String, dynamic>))
          .toList(),
      riskFactors: (json['riskFactors'] as List<dynamic>)
          .map((e) => RiskFactor.fromJson(e as Map<String, dynamic>))
          .toList(),
      healthGoals: (json['healthGoals'] as List<dynamic>)
          .map((e) => HealthGoal.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$HealthProfileToJson(HealthProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'baselineMetrics': instance.baselineMetrics,
      'healthConditions': instance.healthConditions,
      'allergies': instance.allergies,
      'riskFactors': instance.riskFactors,
      'healthGoals': instance.healthGoals,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
