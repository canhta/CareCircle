import 'package:flutter/material.dart';

/// Daily check-in model
class DailyCheckIn {
  final String id;
  final String userId;
  final DateTime date;
  final int? moodScore;
  final int? energyLevel;
  final int? sleepQuality;
  final int? painLevel;
  final int? stressLevel;
  final List<String> symptoms;
  final String? notes;
  final String? aiInsights;
  final double? riskScore;
  final bool completed;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyCheckIn({
    required this.id,
    required this.userId,
    required this.date,
    this.moodScore,
    this.energyLevel,
    this.sleepQuality,
    this.painLevel,
    this.stressLevel,
    this.symptoms = const [],
    this.notes,
    this.aiInsights,
    this.riskScore,
    required this.completed,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory DailyCheckIn.fromJson(Map<String, dynamic> json) {
    return DailyCheckIn(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      moodScore: json['moodScore'],
      energyLevel: json['energyLevel'],
      sleepQuality: json['sleepQuality'],
      painLevel: json['painLevel'],
      stressLevel: json['stressLevel'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
      aiInsights: json['aiInsights'],
      riskScore: json['riskScore']?.toDouble(),
      completed: json['completed'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'moodScore': moodScore,
      'energyLevel': energyLevel,
      'sleepQuality': sleepQuality,
      'painLevel': painLevel,
      'stressLevel': stressLevel,
      'symptoms': symptoms,
      'notes': notes,
      'aiInsights': aiInsights,
      'riskScore': riskScore,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Copy with new values
  DailyCheckIn copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? moodScore,
    int? energyLevel,
    int? sleepQuality,
    int? painLevel,
    int? stressLevel,
    List<String>? symptoms,
    String? notes,
    String? aiInsights,
    double? riskScore,
    bool? completed,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyCheckIn(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      moodScore: moodScore ?? this.moodScore,
      energyLevel: energyLevel ?? this.energyLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      painLevel: painLevel ?? this.painLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      aiInsights: aiInsights ?? this.aiInsights,
      riskScore: riskScore ?? this.riskScore,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calculate health score based on check-in data
  double calculateHealthScore() {
    double score = 0.0;
    int count = 0;

    if (moodScore != null) {
      score += moodScore!;
      count++;
    }
    if (energyLevel != null) {
      score += energyLevel!;
      count++;
    }
    if (sleepQuality != null) {
      score += sleepQuality!;
      count++;
    }
    if (painLevel != null) {
      score += (10 - painLevel!); // Invert pain score
      count++;
    }
    if (stressLevel != null) {
      score += (10 - stressLevel!); // Invert stress score
      count++;
    }

    return count > 0 ? score / count : 0.0;
  }

  /// Get health score color
  Color getHealthScoreColor() {
    final score = calculateHealthScore();
    if (score >= 7.5) return Colors.green;
    if (score >= 5.0) return Colors.orange;
    return Colors.red;
  }

  /// Get health score description
  String getHealthScoreDescription() {
    final score = calculateHealthScore();
    if (score >= 7.5) return 'Excellent';
    if (score >= 5.0) return 'Good';
    if (score >= 2.5) return 'Fair';
    return 'Poor';
  }

  @override
  String toString() {
    return 'DailyCheckIn(id: $id, date: $date, completed: $completed, score: ${calculateHealthScore()})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyCheckIn && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Create daily check-in request
class CreateDailyCheckInRequest {
  final String date;
  final int? moodScore;
  final int? energyLevel;
  final int? sleepQuality;
  final int? painLevel;
  final int? stressLevel;
  final List<String> symptoms;
  final String? notes;
  final bool? completed;

  const CreateDailyCheckInRequest({
    required this.date,
    this.moodScore,
    this.energyLevel,
    this.sleepQuality,
    this.painLevel,
    this.stressLevel,
    this.symptoms = const [],
    this.notes,
    this.completed,
  });

  /// Create from JSON
  factory CreateDailyCheckInRequest.fromJson(Map<String, dynamic> json) {
    return CreateDailyCheckInRequest(
      date: json['date'],
      moodScore: json['moodScore'],
      energyLevel: json['energyLevel'],
      sleepQuality: json['sleepQuality'],
      painLevel: json['painLevel'],
      stressLevel: json['stressLevel'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
      completed: json['completed'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'moodScore': moodScore,
      'energyLevel': energyLevel,
      'sleepQuality': sleepQuality,
      'painLevel': painLevel,
      'stressLevel': stressLevel,
      'symptoms': symptoms,
      'notes': notes,
      'completed': completed,
    };
  }

  /// Copy with new values
  CreateDailyCheckInRequest copyWith({
    String? date,
    int? moodScore,
    int? energyLevel,
    int? sleepQuality,
    int? painLevel,
    int? stressLevel,
    List<String>? symptoms,
    String? notes,
    bool? completed,
  }) {
    return CreateDailyCheckInRequest(
      date: date ?? this.date,
      moodScore: moodScore ?? this.moodScore,
      energyLevel: energyLevel ?? this.energyLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      painLevel: painLevel ?? this.painLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'CreateDailyCheckInRequest(date: $date, completed: $completed)';
  }
}

/// Personalized question model
class PersonalizedQuestion {
  final String id;
  final String question;
  final String type;
  final List<String>? options;
  final bool required;
  final String? category;
  final Map<String, dynamic>? metadata;

  const PersonalizedQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    required this.required,
    this.category,
    this.metadata,
  });

  /// Create from JSON
  factory PersonalizedQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalizedQuestion(
      id: json['id'],
      question: json['question'],
      type: json['type'],
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      required: json['required'] ?? false,
      category: json['category'],
      metadata: json['metadata'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'options': options,
      'required': required,
      'category': category,
      'metadata': metadata,
    };
  }

  /// Copy with new values
  PersonalizedQuestion copyWith({
    String? id,
    String? question,
    String? type,
    List<String>? options,
    bool? required,
    String? category,
    Map<String, dynamic>? metadata,
  }) {
    return PersonalizedQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      options: options ?? this.options,
      required: required ?? this.required,
      category: category ?? this.category,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'PersonalizedQuestion(id: $id, question: $question, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PersonalizedQuestion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Answer question request
class AnswerQuestionRequest {
  final String questionId;
  final dynamic answer;
  final String? notes;

  const AnswerQuestionRequest({
    required this.questionId,
    required this.answer,
    this.notes,
  });

  /// Create from JSON
  factory AnswerQuestionRequest.fromJson(Map<String, dynamic> json) {
    return AnswerQuestionRequest(
      questionId: json['questionId'],
      answer: json['answer'],
      notes: json['notes'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
      'notes': notes,
    };
  }

  /// Copy with new values
  AnswerQuestionRequest copyWith({
    String? questionId,
    dynamic answer,
    String? notes,
  }) {
    return AnswerQuestionRequest(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'AnswerQuestionRequest(questionId: $questionId, answer: $answer)';
  }
}

/// Check-in insight model
class CheckInInsight {
  final String id;
  final String checkInId;
  final String category;
  final String title;
  final String description;
  final String? recommendation;
  final double? severity;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const CheckInInsight({
    required this.id,
    required this.checkInId,
    required this.category,
    required this.title,
    required this.description,
    this.recommendation,
    this.severity,
    this.metadata,
    required this.createdAt,
  });

  /// Create from JSON
  factory CheckInInsight.fromJson(Map<String, dynamic> json) {
    return CheckInInsight(
      id: json['id'],
      checkInId: json['checkInId'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      recommendation: json['recommendation'],
      severity: json['severity']?.toDouble(),
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkInId': checkInId,
      'category': category,
      'title': title,
      'description': description,
      'recommendation': recommendation,
      'severity': severity,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Copy with new values
  CheckInInsight copyWith({
    String? id,
    String? checkInId,
    String? category,
    String? title,
    String? description,
    String? recommendation,
    double? severity,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return CheckInInsight(
      id: id ?? this.id,
      checkInId: checkInId ?? this.checkInId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      recommendation: recommendation ?? this.recommendation,
      severity: severity ?? this.severity,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CheckInInsight(id: $id, category: $category, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckInInsight && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Weekly insights summary model
class WeeklyInsightsSummary {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double averageHealthScore;
  final List<String> trends;
  final List<String> achievements;
  final List<String> recommendations;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const WeeklyInsightsSummary({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.averageHealthScore,
    required this.trends,
    required this.achievements,
    required this.recommendations,
    this.metadata,
    required this.createdAt,
  });

  /// Create from JSON
  factory WeeklyInsightsSummary.fromJson(Map<String, dynamic> json) {
    return WeeklyInsightsSummary(
      id: json['id'],
      userId: json['userId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      averageHealthScore: json['averageHealthScore']?.toDouble() ?? 0.0,
      trends: List<String>.from(json['trends'] ?? []),
      achievements: List<String>.from(json['achievements'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'averageHealthScore': averageHealthScore,
      'trends': trends,
      'achievements': achievements,
      'recommendations': recommendations,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Copy with new values
  WeeklyInsightsSummary copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    double? averageHealthScore,
    List<String>? trends,
    List<String>? achievements,
    List<String>? recommendations,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return WeeklyInsightsSummary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      averageHealthScore: averageHealthScore ?? this.averageHealthScore,
      trends: trends ?? this.trends,
      achievements: achievements ?? this.achievements,
      recommendations: recommendations ?? this.recommendations,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'WeeklyInsightsSummary(id: $id, score: $averageHealthScore, trends: ${trends.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeeklyInsightsSummary && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Daily check-in request parameters
class DailyCheckInRequest {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final String? status;

  const DailyCheckInRequest({
    this.startDate,
    this.endDate,
    this.limit,
    this.status,
  });

  /// Create from JSON
  factory DailyCheckInRequest.fromJson(Map<String, dynamic> json) {
    return DailyCheckInRequest(
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      limit: json['limit'],
      status: json['status'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'limit': limit,
      'status': status,
    };
  }

  /// Copy with new values
  DailyCheckInRequest copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? status,
  }) {
    return DailyCheckInRequest(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      limit: limit ?? this.limit,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'DailyCheckInRequest(startDate: $startDate, endDate: $endDate, limit: $limit)';
  }
}
