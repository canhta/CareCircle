// Health profile models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_profile.freezed.dart';
part 'health_profile.g.dart';

/// Baseline health metrics
@freezed
abstract class BaselineMetrics with _$BaselineMetrics {
  const factory BaselineMetrics({
    required double height,
    required double weight,
    required double bmi,
    required double restingHeartRate,
    required BloodPressure bloodPressure,
    required double bloodGlucose,
  }) = _BaselineMetrics;

  factory BaselineMetrics.fromJson(Map<String, dynamic> json) =>
      _$BaselineMetricsFromJson(json);
}

/// Blood pressure measurement
@freezed
abstract class BloodPressure with _$BloodPressure {
  const factory BloodPressure({
    required double systolic,
    required double diastolic,
  }) = _BloodPressure;

  factory BloodPressure.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureFromJson(json);
}

/// Health condition information
@freezed
abstract class HealthCondition with _$HealthCondition {
  const factory HealthCondition({
    required String name,
    DateTime? diagnosisDate,
    required bool isCurrent,
    required String severity, // 'mild', 'moderate', 'severe'
    List<String>? medications,
    String? notes,
  }) = _HealthCondition;

  factory HealthCondition.fromJson(Map<String, dynamic> json) =>
      _$HealthConditionFromJson(json);
}

/// Allergy information
@freezed
abstract class Allergy with _$Allergy {
  const factory Allergy({
    required String allergen,
    required String reactionType,
    required String severity, // 'mild', 'moderate', 'severe'
  }) = _Allergy;

  factory Allergy.fromJson(Map<String, dynamic> json) =>
      _$AllergyFromJson(json);
}

/// Risk factor information
@freezed
abstract class RiskFactor with _$RiskFactor {
  const factory RiskFactor({
    required String type,
    required String description,
    required String riskLevel, // 'low', 'medium', 'high'
  }) = _RiskFactor;

  factory RiskFactor.fromJson(Map<String, dynamic> json) =>
      _$RiskFactorFromJson(json);
}

/// Health goal tracking
@freezed
abstract class HealthGoal with _$HealthGoal {
  const factory HealthGoal({
    required String id,
    required String metricType,
    required double targetValue,
    required String unit,
    required DateTime startDate,
    required DateTime targetDate,
    required double currentValue,
    required double progress, // 0-100%
    required String status, // 'active', 'achieved', 'behind', 'abandoned'
    required String recurrence, // 'once', 'daily', 'weekly', 'monthly'
  }) = _HealthGoal;

  factory HealthGoal.fromJson(Map<String, dynamic> json) =>
      _$HealthGoalFromJson(json);
}

/// Main health profile entity
@freezed
abstract class HealthProfile with _$HealthProfile {
  const factory HealthProfile({
    required String id,
    required String userId,
    required BaselineMetrics baselineMetrics,
    @Default([]) List<HealthCondition> healthConditions,
    @Default([]) List<Allergy> allergies,
    @Default([]) List<RiskFactor> riskFactors,
    @Default([]) List<HealthGoal> healthGoals,
    required DateTime createdAt,
    required DateTime lastUpdated,
  }) = _HealthProfile;

  factory HealthProfile.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileFromJson(json);
}

/// Extension methods for HealthProfile
extension HealthProfileExtension on HealthProfile {
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
