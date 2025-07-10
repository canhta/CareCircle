// Adherence record models with JSON serialization using freezed and json_serializable
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adherence_record.freezed.dart';
part 'adherence_record.g.dart';

/// Dose status types (matches backend Prisma enum)
enum DoseStatus {
  @JsonValue('SCHEDULED')
  scheduled,
  @JsonValue('TAKEN')
  taken,
  @JsonValue('MISSED')
  missed,
  @JsonValue('SKIPPED')
  skipped,
  @JsonValue('LATE')
  late,
}

/// Extension for DoseStatus display names and colors
extension DoseStatusExtension on DoseStatus {
  String get displayName {
    switch (this) {
      case DoseStatus.scheduled:
        return 'Scheduled';
      case DoseStatus.taken:
        return 'Taken';
      case DoseStatus.missed:
        return 'Missed';
      case DoseStatus.skipped:
        return 'Skipped';
      case DoseStatus.late:
        return 'Late';
    }
  }

  String get icon {
    switch (this) {
      case DoseStatus.scheduled:
        return '⏰';
      case DoseStatus.taken:
        return '✅';
      case DoseStatus.missed:
        return '❌';
      case DoseStatus.skipped:
        return '⏭️';
      case DoseStatus.late:
        return '⏰';
    }
  }

  /// Color representation for UI (hex color codes)
  String get colorHex {
    switch (this) {
      case DoseStatus.scheduled:
        return '#2196F3'; // Blue
      case DoseStatus.taken:
        return '#4CAF50'; // Green
      case DoseStatus.missed:
        return '#F44336'; // Red
      case DoseStatus.skipped:
        return '#FF9800'; // Orange
      case DoseStatus.late:
        return '#FF5722'; // Deep Orange
    }
  }

  bool get isCompleted => this == DoseStatus.taken;
  bool get isNegative =>
      this == DoseStatus.missed || this == DoseStatus.skipped;
}

/// Main adherence record entity
@freezed
abstract class AdherenceRecord with _$AdherenceRecord {
  const factory AdherenceRecord({
    required String id,
    required String medicationId,
    required String scheduleId,
    required String userId,
    required DateTime scheduledTime,
    required double dosage,
    required String unit,
    required DoseStatus status,
    DateTime? takenAt,
    String? skippedReason,
    String? notes,
    String? reminderId,
    required DateTime createdAt,
  }) = _AdherenceRecord;

  factory AdherenceRecord.fromJson(Map<String, dynamic> json) =>
      _$AdherenceRecordFromJson(json);
}

/// Adherence record creation request DTO
@freezed
abstract class CreateAdherenceRecordRequest
    with _$CreateAdherenceRecordRequest {
  const factory CreateAdherenceRecordRequest({
    required String medicationId,
    required String scheduleId,
    required DateTime scheduledTime,
    required double dosage,
    required String unit,
    @Default(DoseStatus.scheduled) DoseStatus status,
    DateTime? takenAt,
    String? skippedReason,
    String? notes,
    String? reminderId,
  }) = _CreateAdherenceRecordRequest;

  factory CreateAdherenceRecordRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAdherenceRecordRequestFromJson(json);
}

/// Adherence record update request DTO
@freezed
abstract class UpdateAdherenceRecordRequest
    with _$UpdateAdherenceRecordRequest {
  const factory UpdateAdherenceRecordRequest({
    DoseStatus? status,
    DateTime? takenAt,
    String? skippedReason,
    String? notes,
  }) = _UpdateAdherenceRecordRequest;

  factory UpdateAdherenceRecordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdherenceRecordRequestFromJson(json);
}

/// Adherence statistics DTO
@freezed
abstract class AdherenceStatistics with _$AdherenceStatistics {
  const factory AdherenceStatistics({
    required String medicationId,
    required int totalDoses,
    required int takenDoses,
    required int missedDoses,
    required int skippedDoses,
    required int lateDoses,
    required double adherencePercentage,
    required int currentStreak,
    required int longestStreak,
    required DateTime? lastDoseTime,
    required DateTime? nextDoseTime,
    @Default({}) Map<String, int> weeklyStats,
    @Default({}) Map<String, double> monthlyTrends,
  }) = _AdherenceStatistics;

  factory AdherenceStatistics.fromJson(Map<String, dynamic> json) =>
      _$AdherenceStatisticsFromJson(json);
}

/// Adherence trend data point
@freezed
abstract class AdherenceTrendPoint with _$AdherenceTrendPoint {
  const factory AdherenceTrendPoint({
    required DateTime date,
    required double adherenceRate,
    required int totalDoses,
    required int completedDoses,
  }) = _AdherenceTrendPoint;

  factory AdherenceTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$AdherenceTrendPointFromJson(json);
}

/// Adherence report DTO
@freezed
abstract class AdherenceReport with _$AdherenceReport {
  const factory AdherenceReport({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required AdherenceStatistics overallStats,
    @Default([]) List<AdherenceStatistics> medicationStats,
    @Default([]) List<AdherenceTrendPoint> trendData,
    @Default([]) List<AdherenceRecord> recentRecords,
  }) = _AdherenceReport;

  factory AdherenceReport.fromJson(Map<String, dynamic> json) =>
      _$AdherenceReportFromJson(json);
}

/// Adherence query parameters DTO
@freezed
abstract class AdherenceQueryParams with _$AdherenceQueryParams {
  const factory AdherenceQueryParams({
    String? medicationId,
    String? scheduleId,
    DoseStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    @Default(50) int limit,
    @Default(0) int offset,
    @Default('scheduledTime') String sortBy,
    @Default('desc') String sortOrder,
  }) = _AdherenceQueryParams;

  factory AdherenceQueryParams.fromJson(Map<String, dynamic> json) =>
      _$AdherenceQueryParamsFromJson(json);
}

/// API response wrapper for adherence record operations
@freezed
abstract class AdherenceRecordResponse with _$AdherenceRecordResponse {
  const factory AdherenceRecordResponse({
    required bool success,
    AdherenceRecord? data,
    String? message,
    String? error,
  }) = _AdherenceRecordResponse;

  factory AdherenceRecordResponse.fromJson(Map<String, dynamic> json) =>
      _$AdherenceRecordResponseFromJson(json);
}

/// API response wrapper for adherence record list operations
@freezed
abstract class AdherenceRecordListResponse with _$AdherenceRecordListResponse {
  const factory AdherenceRecordListResponse({
    required bool success,
    @Default([]) List<AdherenceRecord> data,
    int? count,
    int? total,
    String? message,
    String? error,
  }) = _AdherenceRecordListResponse;

  factory AdherenceRecordListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdherenceRecordListResponseFromJson(json);
}

/// API response wrapper for adherence statistics
@freezed
abstract class AdherenceStatisticsResponse with _$AdherenceStatisticsResponse {
  const factory AdherenceStatisticsResponse({
    required bool success,
    AdherenceStatistics? data,
    String? message,
    String? error,
  }) = _AdherenceStatisticsResponse;

  factory AdherenceStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdherenceStatisticsResponseFromJson(json);
}

/// API response wrapper for adherence report
@freezed
abstract class AdherenceReportResponse with _$AdherenceReportResponse {
  const factory AdherenceReportResponse({
    required bool success,
    AdherenceReport? data,
    String? message,
    String? error,
  }) = _AdherenceReportResponse;

  factory AdherenceReportResponse.fromJson(Map<String, dynamic> json) =>
      _$AdherenceReportResponseFromJson(json);
}
