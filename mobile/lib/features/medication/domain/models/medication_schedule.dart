// Medication schedule models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_schedule.freezed.dart';
part 'medication_schedule.g.dart';

/// Dosage frequency types
enum DosageFrequency {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('as_needed')
  asNeeded,
}

/// Meal relation types
enum MealRelation {
  @JsonValue('before_meal')
  beforeMeal,
  @JsonValue('with_meal')
  withMeal,
  @JsonValue('after_meal')
  afterMeal,
  @JsonValue('independent')
  independent,
}

/// Reminder criticality levels
enum CriticalityLevel {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
}

/// Extensions for enum display names
extension DosageFrequencyExtension on DosageFrequency {
  String get displayName {
    switch (this) {
      case DosageFrequency.daily:
        return 'Daily';
      case DosageFrequency.weekly:
        return 'Weekly';
      case DosageFrequency.monthly:
        return 'Monthly';
      case DosageFrequency.asNeeded:
        return 'As Needed';
    }
  }
}

extension MealRelationExtension on MealRelation {
  String get displayName {
    switch (this) {
      case MealRelation.beforeMeal:
        return 'Before Meal';
      case MealRelation.withMeal:
        return 'With Meal';
      case MealRelation.afterMeal:
        return 'After Meal';
      case MealRelation.independent:
        return 'Independent of Meals';
    }
  }
}

extension CriticalityLevelExtension on CriticalityLevel {
  String get displayName {
    switch (this) {
      case CriticalityLevel.low:
        return 'Low Priority';
      case CriticalityLevel.medium:
        return 'Medium Priority';
      case CriticalityLevel.high:
        return 'High Priority';
    }
  }
}

/// Time representation (hour and minute)
@freezed
abstract class Time with _$Time {
  const factory Time({
    required int hour, // 0-23
    required int minute, // 0-59
  }) = _Time;

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
}

/// Extension for Time formatting
extension TimeExtension on Time {
  String get formatted {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  String get formatted12Hour {
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour < 12 ? 'AM' : 'PM';
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hour12:$minuteStr $period';
  }
}

/// Dosage schedule configuration
@freezed
abstract class DosageSchedule with _$DosageSchedule {
  const factory DosageSchedule({
    required DosageFrequency frequency,
    required int times, // Number of times per frequency period
    @Default([]) List<int> daysOfWeek, // 0-6, 0 is Sunday
    @Default([]) List<int> daysOfMonth, // 1-31
    @Default([]) List<Time> specificTimes,
    String? asNeededInstructions,
    MealRelation? mealRelation,
  }) = _DosageSchedule;

  factory DosageSchedule.fromJson(Map<String, dynamic> json) =>
      _$DosageScheduleFromJson(json);
}

/// Reminder settings configuration
@freezed
abstract class ReminderSettings with _$ReminderSettings {
  const factory ReminderSettings({
    @Default(15) int advanceMinutes, // Minutes before scheduled time to remind
    @Default(15) int repeatMinutes, // Minutes between repeat reminders
    @Default(3) int maxReminders, // Maximum number of reminders
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default(CriticalityLevel.medium) CriticalityLevel criticalityLevel,
  }) = _ReminderSettings;

  factory ReminderSettings.fromJson(Map<String, dynamic> json) =>
      _$ReminderSettingsFromJson(json);
}

/// Main medication schedule entity
@freezed
abstract class MedicationSchedule with _$MedicationSchedule {
  const factory MedicationSchedule({
    required String id,
    required String medicationId,
    required String userId,
    required String instructions,
    @Default(true) bool remindersEnabled,
    required DateTime startDate,
    DateTime? endDate,
    required DosageSchedule schedule,
    @Default([]) List<Time> reminderTimes,
    @Default(ReminderSettings()) ReminderSettings reminderSettings,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MedicationSchedule;

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) =>
      _$MedicationScheduleFromJson(json);
}

/// Schedule creation request DTO
@freezed
abstract class CreateScheduleRequest with _$CreateScheduleRequest {
  const factory CreateScheduleRequest({
    required String medicationId,
    required String instructions,
    @Default(true) bool remindersEnabled,
    required DateTime startDate,
    DateTime? endDate,
    required DosageSchedule schedule,
    @Default([]) List<Time> reminderTimes,
    @Default(ReminderSettings()) ReminderSettings reminderSettings,
  }) = _CreateScheduleRequest;

  factory CreateScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateScheduleRequestFromJson(json);
}

/// Schedule update request DTO
@freezed
abstract class UpdateScheduleRequest with _$UpdateScheduleRequest {
  const factory UpdateScheduleRequest({
    String? instructions,
    bool? remindersEnabled,
    DateTime? startDate,
    DateTime? endDate,
    DosageSchedule? schedule,
    List<Time>? reminderTimes,
    ReminderSettings? reminderSettings,
  }) = _UpdateScheduleRequest;

  factory UpdateScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateScheduleRequestFromJson(json);
}

/// API response wrapper for schedule operations
@freezed
abstract class ScheduleResponse with _$ScheduleResponse {
  const factory ScheduleResponse({
    required bool success,
    MedicationSchedule? data,
    String? message,
    String? error,
  }) = _ScheduleResponse;

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);
}

/// API response wrapper for schedule list operations
@freezed
abstract class ScheduleListResponse with _$ScheduleListResponse {
  const factory ScheduleListResponse({
    required bool success,
    @Default([]) List<MedicationSchedule> data,
    int? count,
    int? total,
    String? message,
    String? error,
  }) = _ScheduleListResponse;

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleListResponseFromJson(json);
}
