import '../../../common/common.dart';
import 'daily_check_in_models.dart';

/// Abstract repository for daily check-in operations
abstract class DailyCheckInRepository {
  /// Create a new daily check-in
  Future<Result<DailyCheckIn>> createCheckIn(CreateDailyCheckInRequest request);

  /// Update an existing daily check-in
  Future<Result<DailyCheckIn>> updateCheckIn(
    String checkInId,
    CreateDailyCheckInRequest request,
  );

  /// Get today's check-in
  Future<Result<DailyCheckIn?>> getTodayCheckIn();

  /// Get user's check-ins with optional filters
  Future<Result<List<DailyCheckIn>>> getUserCheckIns(
      DailyCheckInRequest request);

  /// Submit answers to personalized questions
  Future<Result<DailyCheckIn>> submitQuestionAnswers(
    String checkInId,
    AnswerQuestionRequest request,
  );

  /// Generate personalized questions for check-in
  Future<Result<List<PersonalizedQuestion>>> generatePersonalizedQuestions();

  /// Generate insights for a specific check-in
  Future<Result<CheckInInsight>> generateInsights(String checkInId);

  /// Get weekly insights summary
  Future<Result<WeeklyInsightsSummary>> getWeeklyInsights();

  /// Get daily insights with optional date range
  Future<Result<List<CheckInInsight>>> getDailyInsights({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Handle interactive notification response
  Future<Result<void>> handleInteractiveNotification(
    String checkInId,
    String responseType,
  );

  /// Get check-in by ID
  Future<Result<DailyCheckIn>> getCheckInById(String checkInId);

  /// Delete a check-in
  Future<Result<void>> deleteCheckIn(String checkInId);

  /// Get check-in statistics
  Future<Result<Map<String, dynamic>>> getCheckInStats({
    DateTime? startDate,
    DateTime? endDate,
  });
}
