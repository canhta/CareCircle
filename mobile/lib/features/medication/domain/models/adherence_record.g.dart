// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adherence_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdherenceRecord _$AdherenceRecordFromJson(Map<String, dynamic> json) =>
    _AdherenceRecord(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      scheduleId: json['scheduleId'] as String,
      userId: json['userId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      dosage: (json['dosage'] as num).toDouble(),
      unit: json['unit'] as String,
      status: $enumDecode(_$DoseStatusEnumMap, json['status']),
      takenAt: json['takenAt'] == null
          ? null
          : DateTime.parse(json['takenAt'] as String),
      skippedReason: json['skippedReason'] as String?,
      notes: json['notes'] as String?,
      reminderId: json['reminderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AdherenceRecordToJson(_AdherenceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationId': instance.medicationId,
      'scheduleId': instance.scheduleId,
      'userId': instance.userId,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'dosage': instance.dosage,
      'unit': instance.unit,
      'status': _$DoseStatusEnumMap[instance.status]!,
      'takenAt': instance.takenAt?.toIso8601String(),
      'skippedReason': instance.skippedReason,
      'notes': instance.notes,
      'reminderId': instance.reminderId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$DoseStatusEnumMap = {
  DoseStatus.scheduled: 'SCHEDULED',
  DoseStatus.taken: 'TAKEN',
  DoseStatus.missed: 'MISSED',
  DoseStatus.skipped: 'SKIPPED',
  DoseStatus.late: 'LATE',
};

_CreateAdherenceRecordRequest _$CreateAdherenceRecordRequestFromJson(
  Map<String, dynamic> json,
) => _CreateAdherenceRecordRequest(
  medicationId: json['medicationId'] as String,
  scheduleId: json['scheduleId'] as String,
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  dosage: (json['dosage'] as num).toDouble(),
  unit: json['unit'] as String,
  status:
      $enumDecodeNullable(_$DoseStatusEnumMap, json['status']) ??
      DoseStatus.scheduled,
  takenAt: json['takenAt'] == null
      ? null
      : DateTime.parse(json['takenAt'] as String),
  skippedReason: json['skippedReason'] as String?,
  notes: json['notes'] as String?,
  reminderId: json['reminderId'] as String?,
);

Map<String, dynamic> _$CreateAdherenceRecordRequestToJson(
  _CreateAdherenceRecordRequest instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'scheduleId': instance.scheduleId,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'dosage': instance.dosage,
  'unit': instance.unit,
  'status': _$DoseStatusEnumMap[instance.status]!,
  'takenAt': instance.takenAt?.toIso8601String(),
  'skippedReason': instance.skippedReason,
  'notes': instance.notes,
  'reminderId': instance.reminderId,
};

_UpdateAdherenceRecordRequest _$UpdateAdherenceRecordRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateAdherenceRecordRequest(
  status: $enumDecodeNullable(_$DoseStatusEnumMap, json['status']),
  takenAt: json['takenAt'] == null
      ? null
      : DateTime.parse(json['takenAt'] as String),
  skippedReason: json['skippedReason'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$UpdateAdherenceRecordRequestToJson(
  _UpdateAdherenceRecordRequest instance,
) => <String, dynamic>{
  'status': _$DoseStatusEnumMap[instance.status],
  'takenAt': instance.takenAt?.toIso8601String(),
  'skippedReason': instance.skippedReason,
  'notes': instance.notes,
};

_AdherenceStatistics _$AdherenceStatisticsFromJson(Map<String, dynamic> json) =>
    _AdherenceStatistics(
      medicationId: json['medicationId'] as String,
      totalDoses: (json['totalDoses'] as num).toInt(),
      takenDoses: (json['takenDoses'] as num).toInt(),
      missedDoses: (json['missedDoses'] as num).toInt(),
      skippedDoses: (json['skippedDoses'] as num).toInt(),
      lateDoses: (json['lateDoses'] as num).toInt(),
      adherencePercentage: (json['adherencePercentage'] as num).toDouble(),
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastDoseTime: json['lastDoseTime'] == null
          ? null
          : DateTime.parse(json['lastDoseTime'] as String),
      nextDoseTime: json['nextDoseTime'] == null
          ? null
          : DateTime.parse(json['nextDoseTime'] as String),
      weeklyStats:
          (json['weeklyStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      monthlyTrends:
          (json['monthlyTrends'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$AdherenceStatisticsToJson(
  _AdherenceStatistics instance,
) => <String, dynamic>{
  'medicationId': instance.medicationId,
  'totalDoses': instance.totalDoses,
  'takenDoses': instance.takenDoses,
  'missedDoses': instance.missedDoses,
  'skippedDoses': instance.skippedDoses,
  'lateDoses': instance.lateDoses,
  'adherencePercentage': instance.adherencePercentage,
  'currentStreak': instance.currentStreak,
  'longestStreak': instance.longestStreak,
  'lastDoseTime': instance.lastDoseTime?.toIso8601String(),
  'nextDoseTime': instance.nextDoseTime?.toIso8601String(),
  'weeklyStats': instance.weeklyStats,
  'monthlyTrends': instance.monthlyTrends,
};

_AdherenceTrendPoint _$AdherenceTrendPointFromJson(Map<String, dynamic> json) =>
    _AdherenceTrendPoint(
      date: DateTime.parse(json['date'] as String),
      adherenceRate: (json['adherenceRate'] as num).toDouble(),
      totalDoses: (json['totalDoses'] as num).toInt(),
      completedDoses: (json['completedDoses'] as num).toInt(),
    );

Map<String, dynamic> _$AdherenceTrendPointToJson(
  _AdherenceTrendPoint instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'adherenceRate': instance.adherenceRate,
  'totalDoses': instance.totalDoses,
  'completedDoses': instance.completedDoses,
};

_AdherenceReport _$AdherenceReportFromJson(
  Map<String, dynamic> json,
) => _AdherenceReport(
  userId: json['userId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  overallStats: AdherenceStatistics.fromJson(
    json['overallStats'] as Map<String, dynamic>,
  ),
  medicationStats:
      (json['medicationStats'] as List<dynamic>?)
          ?.map((e) => AdherenceStatistics.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  trendData:
      (json['trendData'] as List<dynamic>?)
          ?.map((e) => AdherenceTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  recentRecords:
      (json['recentRecords'] as List<dynamic>?)
          ?.map((e) => AdherenceRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AdherenceReportToJson(_AdherenceReport instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'overallStats': instance.overallStats,
      'medicationStats': instance.medicationStats,
      'trendData': instance.trendData,
      'recentRecords': instance.recentRecords,
    };

_AdherenceRecordResponse _$AdherenceRecordResponseFromJson(
  Map<String, dynamic> json,
) => _AdherenceRecordResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : AdherenceRecord.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$AdherenceRecordResponseToJson(
  _AdherenceRecordResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'error': instance.error,
};

_AdherenceRecordListResponse _$AdherenceRecordListResponseFromJson(
  Map<String, dynamic> json,
) => _AdherenceRecordListResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => AdherenceRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$AdherenceRecordListResponseToJson(
  _AdherenceRecordListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'total': instance.total,
  'message': instance.message,
  'error': instance.error,
};

_AdherenceStatisticsResponse _$AdherenceStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => _AdherenceStatisticsResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : AdherenceStatistics.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$AdherenceStatisticsResponseToJson(
  _AdherenceStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'error': instance.error,
};

_AdherenceReportResponse _$AdherenceReportResponseFromJson(
  Map<String, dynamic> json,
) => _AdherenceReportResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : AdherenceReport.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$AdherenceReportResponseToJson(
  _AdherenceReportResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'error': instance.error,
};
