import 'package:json_annotation/json_annotation.dart';

part 'health_profile.g.dart';

@JsonSerializable()
class BaselineMetrics {
  final double height;
  final double weight;
  final double bmi;
  final double restingHeartRate;
  final BloodPressure bloodPressure;
  final double bloodGlucose;

  const BaselineMetrics({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.restingHeartRate,
    required this.bloodPressure,
    required this.bloodGlucose,
  });

  factory BaselineMetrics.fromJson(Map<String, dynamic> json) =>
      _$BaselineMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$BaselineMetricsToJson(this);
}

@JsonSerializable()
class BloodPressure {
  final double systolic;
  final double diastolic;

  const BloodPressure({required this.systolic, required this.diastolic});

  factory BloodPressure.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureFromJson(json);

  Map<String, dynamic> toJson() => _$BloodPressureToJson(this);
}

@JsonSerializable()
class HealthCondition {
  final String name;
  final DateTime? diagnosisDate;
  final bool isCurrent;
  final String severity; // 'mild', 'moderate', 'severe'
  final List<String>? medications;
  final String? notes;

  const HealthCondition({
    required this.name,
    this.diagnosisDate,
    required this.isCurrent,
    required this.severity,
    this.medications,
    this.notes,
  });

  factory HealthCondition.fromJson(Map<String, dynamic> json) =>
      _$HealthConditionFromJson(json);

  Map<String, dynamic> toJson() => _$HealthConditionToJson(this);
}

@JsonSerializable()
class Allergy {
  final String allergen;
  final String reactionType;
  final String severity; // 'mild', 'moderate', 'severe'

  const Allergy({
    required this.allergen,
    required this.reactionType,
    required this.severity,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) =>
      _$AllergyFromJson(json);

  Map<String, dynamic> toJson() => _$AllergyToJson(this);
}

@JsonSerializable()
class RiskFactor {
  final String type;
  final String description;
  final String riskLevel; // 'low', 'medium', 'high'

  const RiskFactor({
    required this.type,
    required this.description,
    required this.riskLevel,
  });

  factory RiskFactor.fromJson(Map<String, dynamic> json) =>
      _$RiskFactorFromJson(json);

  Map<String, dynamic> toJson() => _$RiskFactorToJson(this);
}

@JsonSerializable()
class HealthGoal {
  final String id;
  final String metricType;
  final double targetValue;
  final String unit;
  final DateTime startDate;
  final DateTime targetDate;
  final double currentValue;
  final double progress; // 0-100%
  final String status; // 'active', 'achieved', 'behind', 'abandoned'
  final String recurrence; // 'once', 'daily', 'weekly', 'monthly'

  const HealthGoal({
    required this.id,
    required this.metricType,
    required this.targetValue,
    required this.unit,
    required this.startDate,
    required this.targetDate,
    required this.currentValue,
    required this.progress,
    required this.status,
    required this.recurrence,
  });

  factory HealthGoal.fromJson(Map<String, dynamic> json) =>
      _$HealthGoalFromJson(json);

  Map<String, dynamic> toJson() => _$HealthGoalToJson(this);
}

@JsonSerializable()
class HealthProfile {
  final String id;
  final String userId;
  final BaselineMetrics baselineMetrics;
  final List<HealthCondition> healthConditions;
  final List<Allergy> allergies;
  final List<RiskFactor> riskFactors;
  final List<HealthGoal> healthGoals;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const HealthProfile({
    required this.id,
    required this.userId,
    required this.baselineMetrics,
    required this.healthConditions,
    required this.allergies,
    required this.riskFactors,
    required this.healthGoals,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory HealthProfile.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileFromJson(json);

  Map<String, dynamic> toJson() => _$HealthProfileToJson(this);

  HealthProfile copyWith({
    String? id,
    String? userId,
    BaselineMetrics? baselineMetrics,
    List<HealthCondition>? healthConditions,
    List<Allergy>? allergies,
    List<RiskFactor>? riskFactors,
    List<HealthGoal>? healthGoals,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return HealthProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      baselineMetrics: baselineMetrics ?? this.baselineMetrics,
      healthConditions: healthConditions ?? this.healthConditions,
      allergies: allergies ?? this.allergies,
      riskFactors: riskFactors ?? this.riskFactors,
      healthGoals: healthGoals ?? this.healthGoals,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  List<HealthGoal> get activeGoals =>
      healthGoals.where((goal) => goal.status == 'active').toList();

  List<HealthGoal> get achievedGoals =>
      healthGoals.where((goal) => goal.status == 'achieved').toList();

  double calculateBMI() {
    if (baselineMetrics.height > 0 && baselineMetrics.weight > 0) {
      final heightInMeters = baselineMetrics.height / 100;
      return baselineMetrics.weight / (heightInMeters * heightInMeters);
    }
    return 0;
  }
}
