import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/daily_check_in_models.dart';

class DailyCheckInService {
  static const String _baseUrl = 'http://localhost:3000';
  late final Dio _dio;

  DailyCheckInService() {
    _dio = Dio();
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Options _getOptions() {
    return Options(
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );
  }

  Future<DailyCheckIn> createCheckIn(CreateDailyCheckInRequest request) async {
    try {
      final response = await _dio.post(
        '/daily-check-ins',
        data: request.toJson(),
        options: _getOptions(),
      );

      if (response.statusCode == 201) {
        return DailyCheckIn.fromJson(response.data);
      } else {
        final error = response.data;
        throw Exception('Failed to create check-in: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error creating check-in: $e');
      throw Exception('Failed to create check-in: $e');
    }
  }

  Future<DailyCheckIn> updateCheckIn(String checkInId, CreateDailyCheckInRequest request) async {
    try {
      final response = await _dio.put(
        '/daily-check-ins/$checkInId',
        data: request.toJson(),
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        return DailyCheckIn.fromJson(response.data);
      } else {
        final error = response.data;
        throw Exception('Failed to update check-in: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error updating check-in: $e');
      throw Exception('Failed to update check-in: $e');
    }
  }

  Future<DailyCheckIn?> getTodayCheckIn() async {
    try {
      final response = await _dio.get(
        '/daily-check-ins/today',
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data != null ? DailyCheckIn.fromJson(data) : null;
      } else {
        final error = response.data;
        throw Exception('Failed to get today\'s check-in: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error getting today\'s check-in: $e');
      return null;
    }
  }

  Future<DailyCheckIn> submitQuestionAnswers(String checkInId, AnswerQuestionRequest request) async {
    try {
      final response = await _dio.post(
        '/daily-check-ins/$checkInId/answers',
        data: request.toJson(),
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        return DailyCheckIn.fromJson(response.data);
      } else {
        final error = response.data;
        throw Exception('Failed to submit answers: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error submitting answers: $e');
      throw Exception('Failed to submit answers: $e');
    }
  }

  Future<List<PersonalizedQuestion>> getPersonalizedQuestions() async {
    try {
      final response = await _dio.get(
        '/daily-check-ins/personalized-questions',
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((question) => PersonalizedQuestion.fromJson(question)).toList();
      } else {
        final error = response.data;
        throw Exception('Failed to get personalized questions: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error getting personalized questions: $e');
      throw Exception('Failed to get personalized questions: $e');
    }
  }

  Future<List<DailyCheckIn>> getCheckInHistory({
    int page = 1,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (startDate != null) {
        queryParameters['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/daily-check-ins/history',
        queryParameters: queryParameters,
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((checkIn) => DailyCheckIn.fromJson(checkIn)).toList();
      } else {
        final error = response.data;
        throw Exception('Failed to get check-in history: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error getting check-in history: $e');
      throw Exception('Failed to get check-in history: $e');
    }
  }

  Future<WeeklyInsightsSummary> getInsights({
    DateTime? startDate,
    DateTime? endDate,
    String period = 'week',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'period': period,
      };

      if (startDate != null) {
        queryParameters['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/daily-check-ins/insights',
        queryParameters: queryParameters,
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        return WeeklyInsightsSummary.fromJson(response.data);
      } else {
        final error = response.data;
        throw Exception('Failed to get insights: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error getting insights: $e');
      throw Exception('Failed to get insights: $e');
    }
  }

  Future<List<String>> getCheckInStreak() async {
    try {
      final response = await _dio.get(
        '/daily-check-ins/streak',
        options: _getOptions(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return [
          data['currentStreak'].toString(),
          data['longestStreak'].toString(),
        ];
      } else {
        final error = response.data;
        throw Exception('Failed to get streak: ${error['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log('Error getting streak: $e');
      throw Exception('Failed to get streak: $e');
    }
  }

  // Helper method to show snackbar
  void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper method to show success message
  void showSuccessMessage(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  // Helper method to show error message
  void showErrorMessage(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }

  // Helper methods for screens

  Future<DailyCheckIn> createOrUpdateTodaysCheckIn(CreateDailyCheckInRequest request) async {
    final existingCheckIn = await getTodayCheckIn();

    if (existingCheckIn != null) {
      // Update existing check-in
      return await updateCheckIn(existingCheckIn.id, request);
    } else {
      // Create new check-in
      return await createCheckIn(request);
    }
  }

  String formatDateForApi(DateTime date) {
    return date.toIso8601String().split('T')[0]; // YYYY-MM-DD format
  }

  double calculateHealthScore(DailyCheckIn checkIn) {
    // Simple health score calculation based on available metrics
    double score = 50.0; // Base score

    if (checkIn.moodScore != null) {
      score += (checkIn.moodScore! - 5) * 5; // -20 to +20
    }

    if (checkIn.energyLevel != null) {
      score += (checkIn.energyLevel! - 5) * 3; // -12 to +12
    }

    if (checkIn.sleepQuality != null) {
      score += (checkIn.sleepQuality! - 5) * 4; // -16 to +16
    }

    if (checkIn.painLevel != null) {
      score -= (checkIn.painLevel! - 1) * 2; // 0 to -18 (less pain = better score)
    }

    if (checkIn.stressLevel != null) {
      score -= (checkIn.stressLevel! - 1) * 2; // 0 to -18 (less stress = better score)
    }

    // Factor in symptoms (more symptoms = lower score)
    score -= checkIn.symptoms.length * 2;

    // Clamp score between 0 and 100
    return score.clamp(0.0, 100.0);
  }

  Future<List<DailyCheckIn>> getRecentCheckIns({int limit = 7}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: limit));

    return await getCheckInHistory(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  Future<List<PersonalizedQuestion>> generatePersonalizedQuestions() async {
    // For now, return the same as getPersonalizedQuestions
    return await getPersonalizedQuestions();
  }

  Future<DailyCheckIn> answerQuestion(String questionId, dynamic answer) async {
    // Create an answer request and submit it
    final request = AnswerQuestionRequest(
      questionId: questionId,
      answer: answer,
    );

    // We need a check-in ID, so let's get today's check-in
    final todayCheckIn = await getTodayCheckIn();
    if (todayCheckIn != null) {
      return await submitQuestionAnswers(todayCheckIn.id, request);
    } else {
      throw Exception('No active check-in found for today');
    }
  }

  Future<WeeklyInsightsSummary> getWeeklyInsightsSummary() async {
    return await getInsights(period: 'week');
  }

  Future<List<CheckInInsight>> getRecentInsights() async {
    // For now, return empty list since we don't have this model
    return [];
  }

  Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }
}
