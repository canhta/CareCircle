// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Time _$TimeFromJson(Map<String, dynamic> json) => _Time(
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
);

Map<String, dynamic> _$TimeToJson(_Time instance) => <String, dynamic>{
  'hour': instance.hour,
  'minute': instance.minute,
};

_DosageSchedule _$DosageScheduleFromJson(Map<String, dynamic> json) =>
    _DosageSchedule(
      frequency: $enumDecode(_$DosageFrequencyEnumMap, json['frequency']),
      times: (json['times'] as num).toInt(),
      daysOfWeek:
          (json['daysOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      daysOfMonth:
          (json['daysOfMonth'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      specificTimes:
          (json['specificTimes'] as List<dynamic>?)
              ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      asNeededInstructions: json['asNeededInstructions'] as String?,
      mealRelation: $enumDecodeNullable(
        _$MealRelationEnumMap,
        json['mealRelation'],
      ),
    );

Map<String, dynamic> _$DosageScheduleToJson(_DosageSchedule instance) =>
    <String, dynamic>{
      'frequency': _$DosageFrequencyEnumMap[instance.frequency]!,
      'times': instance.times,
      'daysOfWeek': instance.daysOfWeek,
      'daysOfMonth': instance.daysOfMonth,
      'specificTimes': instance.specificTimes,
      'asNeededInstructions': instance.asNeededInstructions,
      'mealRelation': _$MealRelationEnumMap[instance.mealRelation],
    };

const _$DosageFrequencyEnumMap = {
  DosageFrequency.daily: 'daily',
  DosageFrequency.weekly: 'weekly',
  DosageFrequency.monthly: 'monthly',
  DosageFrequency.asNeeded: 'as_needed',
};

const _$MealRelationEnumMap = {
  MealRelation.beforeMeal: 'before_meal',
  MealRelation.withMeal: 'with_meal',
  MealRelation.afterMeal: 'after_meal',
  MealRelation.independent: 'independent',
};

_ReminderSettings _$ReminderSettingsFromJson(Map<String, dynamic> json) =>
    _ReminderSettings(
      advanceMinutes: (json['advanceMinutes'] as num?)?.toInt() ?? 15,
      repeatMinutes: (json['repeatMinutes'] as num?)?.toInt() ?? 15,
      maxReminders: (json['maxReminders'] as num?)?.toInt() ?? 3,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      criticalityLevel:
          $enumDecodeNullable(
            _$CriticalityLevelEnumMap,
            json['criticalityLevel'],
          ) ??
          CriticalityLevel.medium,
    );

Map<String, dynamic> _$ReminderSettingsToJson(_ReminderSettings instance) =>
    <String, dynamic>{
      'advanceMinutes': instance.advanceMinutes,
      'repeatMinutes': instance.repeatMinutes,
      'maxReminders': instance.maxReminders,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'criticalityLevel': _$CriticalityLevelEnumMap[instance.criticalityLevel]!,
    };

const _$CriticalityLevelEnumMap = {
  CriticalityLevel.low: 'low',
  CriticalityLevel.medium: 'medium',
  CriticalityLevel.high: 'high',
};

_MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) =>
    _MedicationSchedule(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      userId: json['userId'] as String,
      instructions: json['instructions'] as String,
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      schedule: DosageSchedule.fromJson(
        json['schedule'] as Map<String, dynamic>,
      ),
      reminderTimes:
          (json['reminderTimes'] as List<dynamic>?)
              ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reminderSettings: json['reminderSettings'] == null
          ? const ReminderSettings()
          : ReminderSettings.fromJson(
              json['reminderSettings'] as Map<String, dynamic>,
            ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MedicationScheduleToJson(_MedicationSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationId': instance.medicationId,
      'userId': instance.userId,
      'instructions': instance.instructions,
      'remindersEnabled': instance.remindersEnabled,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'schedule': instance.schedule,
      'reminderTimes': instance.reminderTimes,
      'reminderSettings': instance.reminderSettings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_CreateScheduleRequest _$CreateScheduleRequestFromJson(
  Map<String, dynamic> json,
) => _CreateScheduleRequest(
  medicationId: json['medicationId'] as String,
  instructions: json['instructions'] as String,
  remindersEnabled: json['remindersEnabled'] as bool? ?? true,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  schedule: DosageSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
  reminderTimes:
      (json['reminderTimes'] as List<dynamic>?)
          ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reminderSettings: json['reminderSettings'] == null
      ? const ReminderSettings()
      : ReminderSettings.fromJson(
          json['reminderSettings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CreateScheduleRequestToJson(
  _CreateScheduleRequest instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'instructions': instance.instructions,
  'remindersEnabled': instance.remindersEnabled,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'schedule': instance.schedule,
  'reminderTimes': instance.reminderTimes,
  'reminderSettings': instance.reminderSettings,
};

_UpdateScheduleRequest _$UpdateScheduleRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateScheduleRequest(
  instructions: json['instructions'] as String?,
  remindersEnabled: json['remindersEnabled'] as bool?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  schedule: json['schedule'] == null
      ? null
      : DosageSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
  reminderTimes: (json['reminderTimes'] as List<dynamic>?)
      ?.map((e) => Time.fromJson(e as Map<String, dynamic>))
      .toList(),
  reminderSettings: json['reminderSettings'] == null
      ? null
      : ReminderSettings.fromJson(
          json['reminderSettings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UpdateScheduleRequestToJson(
  _UpdateScheduleRequest instance,
) => <String, dynamic>{
  'instructions': instance.instructions,
  'remindersEnabled': instance.remindersEnabled,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'schedule': instance.schedule,
  'reminderTimes': instance.reminderTimes,
  'reminderSettings': instance.reminderSettings,
};

_ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    _ScheduleResponse(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : MedicationSchedule.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ScheduleResponseToJson(_ScheduleResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
      'error': instance.error,
    };

_ScheduleListResponse _$ScheduleListResponseFromJson(
  Map<String, dynamic> json,
) => _ScheduleListResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MedicationSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$ScheduleListResponseToJson(
  _ScheduleListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'total': instance.total,
  'message': instance.message,
  'error': instance.error,
};
