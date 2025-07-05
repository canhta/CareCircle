import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../domain/daily_check_in_models.dart';
import '../domain/daily_check_in_repository.dart';

/// Daily check-in service implementation
class DailyCheckInService extends BaseRepository
    implements DailyCheckInRepository {
  DailyCheckInService({
    required super.apiClient,
    required super.logger,
  });

  @override
  Future<Result<DailyCheckIn>> createCheckIn(
      CreateDailyCheckInRequest request) async {
    try {
      logger.info('Creating daily check-in for date: ${request.date}');

      final response = await apiClient.post(
        ApiEndpoints.dailyCheckIns,
        data: request.toJson(),
      );

      final checkIn = DailyCheckIn.fromJson(response.data);
      logger.info('Successfully created daily check-in with ID: ${checkIn.id}');

      return Result.success(checkIn);
    } catch (e) {
      logger.error('Error creating daily check-in', error: e);
      return Result.failure(
        NetworkException('Failed to create check-in: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DailyCheckIn>> updateCheckIn(
    String checkInId,
    CreateDailyCheckInRequest request,
  ) async {
    try {
      logger.info('Updating daily check-in with ID: $checkInId');

      final response = await apiClient.put(
        '${ApiEndpoints.dailyCheckIns}/$checkInId',
        data: request.toJson(),
      );

      final checkIn = DailyCheckIn.fromJson(response.data);
      logger.info('Successfully updated daily check-in with ID: $checkInId');

      return Result.success(checkIn);
    } catch (e) {
      logger.error('Error updating daily check-in', error: e);
      return Result.failure(
        NetworkException('Failed to update check-in: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DailyCheckIn?>> getTodayCheckIn() async {
    try {
      logger.info('Getting today\'s check-in');

      final response =
          await apiClient.get('${ApiEndpoints.dailyCheckIns}/today');

      if (response.data != null) {
        final checkIn = DailyCheckIn.fromJson(response.data);
        logger.info('Found today\'s check-in with ID: ${checkIn.id}');
        return Result.success(checkIn);
      } else {
        logger.info('No check-in found for today');
        return const Result.success(null);
      }
    } catch (e) {
      logger.error('Error getting today\'s check-in', error: e);
      return Result.failure(
        NetworkException('Failed to get today\'s check-in: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<DailyCheckIn>>> getUserCheckIns(
      DailyCheckInRequest request) async {
    try {
      logger.info('Getting user check-ins with filters');

      final queryParams = <String, dynamic>{};
      if (request.startDate != null) {
        queryParams['startDate'] = request.startDate!.toIso8601String();
      }
      if (request.endDate != null) {
        queryParams['endDate'] = request.endDate!.toIso8601String();
      }
      if (request.limit != null) {
        queryParams['limit'] = request.limit.toString();
      }
      if (request.status != null) {
        queryParams['status'] = request.status;
      }

      final response = await apiClient.get(
        ApiEndpoints.dailyCheckIns,
        queryParameters: queryParams,
      );

      final checkIns = (response.data as List)
          .map((json) => DailyCheckIn.fromJson(json))
          .toList();

      logger.info('Successfully retrieved ${checkIns.length} check-ins');
      return Result.success(checkIns);
    } catch (e) {
      logger.error('Error getting user check-ins', error: e);
      return Result.failure(
        NetworkException('Failed to get check-ins: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DailyCheckIn>> submitQuestionAnswers(
    String checkInId,
    AnswerQuestionRequest request,
  ) async {
    try {
      logger.info('Submitting question answers for check-in: $checkInId');

      final response = await apiClient.post(
        '${ApiEndpoints.dailyCheckIns}/$checkInId/answers',
        data: request.toJson(),
      );

      final checkIn = DailyCheckIn.fromJson(response.data);
      logger.info('Successfully submitted question answers');

      return Result.success(checkIn);
    } catch (e) {
      logger.error('Error submitting question answers', error: e);
      return Result.failure(
        NetworkException('Failed to submit answers: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<PersonalizedQuestion>>>
      generatePersonalizedQuestions() async {
    try {
      logger.info('Generating personalized questions');

      final response =
          await apiClient.get('${ApiEndpoints.checkInQuestions}/generate');

      final questions = (response.data as List)
          .map((json) => PersonalizedQuestion.fromJson(json))
          .toList();

      logger.info(
          'Successfully generated ${questions.length} personalized questions');
      return Result.success(questions);
    } catch (e) {
      logger.error('Error generating personalized questions', error: e);
      return Result.failure(
        NetworkException('Failed to generate questions: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<CheckInInsight>> generateInsights(String checkInId) async {
    try {
      logger.info('Generating insights for check-in: $checkInId');

      final response = await apiClient
          .get('${ApiEndpoints.dailyCheckIns}/$checkInId/insights');

      final insight = CheckInInsight.fromJson(response.data);
      logger.info('Successfully generated insights for check-in: $checkInId');

      return Result.success(insight);
    } catch (e) {
      logger.error('Error generating insights', error: e);
      return Result.failure(
        NetworkException('Failed to generate insights: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<WeeklyInsightsSummary>> getWeeklyInsights() async {
    try {
      logger.info('Getting weekly insights summary');

      final response =
          await apiClient.get('${ApiEndpoints.dailyCheckIns}/insights/weekly');

      final summary = WeeklyInsightsSummary.fromJson(response.data);
      logger.info('Successfully retrieved weekly insights summary');

      return Result.success(summary);
    } catch (e) {
      logger.error('Error getting weekly insights', error: e);
      return Result.failure(
        NetworkException('Failed to get weekly insights: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<List<CheckInInsight>>> getDailyInsights({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      logger.info('Getting daily insights');

      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await apiClient.get(
        '${ApiEndpoints.dailyCheckIns}/insights/daily',
        queryParameters: queryParams,
      );

      final insights = (response.data as List)
          .map((json) => CheckInInsight.fromJson(json))
          .toList();

      logger.info('Successfully retrieved ${insights.length} daily insights');
      return Result.success(insights);
    } catch (e) {
      logger.error('Error getting daily insights', error: e);
      return Result.failure(
        NetworkException('Failed to get daily insights: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> handleInteractiveNotification(
    String checkInId,
    String responseType,
  ) async {
    try {
      logger.info('Handling interactive notification for check-in: $checkInId');

      await apiClient.post(
        '${ApiEndpoints.dailyCheckIns}/$checkInId/interactive-response',
        data: {'responseType': responseType},
      );

      logger.info('Successfully handled interactive notification');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error handling interactive notification', error: e);
      return Result.failure(
        NetworkException('Failed to handle notification: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<DailyCheckIn>> getCheckInById(String checkInId) async {
    try {
      logger.info('Getting check-in by ID: $checkInId');

      final response =
          await apiClient.get('${ApiEndpoints.dailyCheckIns}/$checkInId');

      final checkIn = DailyCheckIn.fromJson(response.data);
      logger.info('Successfully retrieved check-in: $checkInId');

      return Result.success(checkIn);
    } catch (e) {
      logger.error('Error getting check-in by ID', error: e);
      return Result.failure(
        NetworkException('Failed to get check-in: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<void>> deleteCheckIn(String checkInId) async {
    try {
      logger.info('Deleting check-in: $checkInId');

      await apiClient.delete('${ApiEndpoints.dailyCheckIns}/$checkInId');

      logger.info('Successfully deleted check-in: $checkInId');
      return const Result.success(null);
    } catch (e) {
      logger.error('Error deleting check-in', error: e);
      return Result.failure(
        NetworkException('Failed to delete check-in: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getCheckInStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      logger.info('Getting check-in statistics');

      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await apiClient.get(
        ApiEndpoints.checkInStats,
        queryParameters: queryParams,
      );

      logger.info('Successfully retrieved check-in statistics');
      return Result.success(response.data);
    } catch (e) {
      logger.error('Error getting check-in statistics', error: e);
      return Result.failure(
        NetworkException('Failed to get check-in statistics: $e',
            type: NetworkExceptionType.unknown),
      );
    }
  }

  /// Utility method to format date for API
  String formatDateForApi(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  /// Calculate health score for a check-in
  double calculateHealthScore(DailyCheckIn checkIn) {
    // Simple scoring algorithm based on available properties
    double score = 5.0; // Base score

    if (checkIn.moodScore != null) {
      score += (checkIn.moodScore! - 5.0) * 0.2;
    }

    if (checkIn.energyLevel != null) {
      score += (checkIn.energyLevel! - 5.0) * 0.2;
    }

    if (checkIn.sleepQuality != null) {
      score += (checkIn.sleepQuality! - 5.0) * 0.2;
    }

    if (checkIn.painLevel != null) {
      // Pain is inverse - lower pain = better score
      score += (10.0 - checkIn.painLevel!) * 0.1;
    }

    if (checkIn.stressLevel != null) {
      // Stress is inverse - lower stress = better score
      score += (10.0 - checkIn.stressLevel!) * 0.1;
    }

    // If we have symptom data, factor that in
    if (checkIn.symptoms.isNotEmpty) {
      score -= checkIn.symptoms.length * 0.1; // More symptoms = lower score
    }

    // Use existing risk score if available
    if (checkIn.riskScore != null) {
      score = (score + (10.0 - checkIn.riskScore! * 10)) / 2;
    }

    // Clamp between 1 and 10
    return score.clamp(1.0, 10.0);
  }

  /// Create or update today's check-in
  Future<Result<DailyCheckIn>> createOrUpdateTodaysCheckIn(
    CreateDailyCheckInRequest request,
  ) async {
    // First try to get today's check-in
    final todayResult = await getTodayCheckIn();

    if (todayResult.isSuccess && todayResult.data != null) {
      // Update existing check-in
      return updateCheckIn(todayResult.data!.id, request);
    } else {
      // Create new check-in
      return createCheckIn(request);
    }
  }

  /// Get recent check-ins (alias for getUserCheckIns)
  Future<Result<List<DailyCheckIn>>> getRecentCheckIns({int limit = 30}) async {
    final request = DailyCheckInRequest(
      limit: limit,
      endDate: DateTime.now(),
      startDate: DateTime.now().subtract(Duration(days: 30)),
    );
    return getUserCheckIns(request);
  }

  /// Get severity color for insight display
  Color getSeverityColor(double? severity) {
    if (severity == null) return Colors.grey;

    if (severity <= 0.3) return Colors.green;
    if (severity <= 0.6) return Colors.orange;
    return Colors.red;
  }

  /// Get severity icon for insight display
  IconData getSeverityIcon(double? severity) {
    if (severity == null) return Icons.info;

    if (severity <= 0.3) return Icons.check_circle;
    if (severity <= 0.6) return Icons.warning;
    return Icons.error;
  }
}
