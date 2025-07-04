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

  DailyCheckIn({
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
}

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

  CreateDailyCheckInRequest({
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
}

class PersonalizedQuestion {
  final String id;
  final String question;
  final QuestionType type;
  final List<String>? options;
  final int? minValue;
  final int? maxValue;
  final String? category;
  final int? priority;
  final List<String>? followUpQuestions;

  PersonalizedQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.minValue,
    this.maxValue,
    this.category,
    this.priority,
    this.followUpQuestions,
  });

  factory PersonalizedQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalizedQuestion(
      id: json['id'],
      question: json['question'],
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.text,
      ),
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
      minValue: json['minValue'],
      maxValue: json['maxValue'],
      category: json['category'],
      priority: json['priority'],
      followUpQuestions: json['followUpQuestions'] != null
          ? List<String>.from(json['followUpQuestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'options': options,
      'minValue': minValue,
      'maxValue': maxValue,
      'category': category,
      'priority': priority,
      'followUpQuestions': followUpQuestions,
    };
  }
}

enum QuestionType {
  scale,
  multipleChoice,
  text,
  boolean,
}

class GenerateQuestionsRequest {
  final String userId;
  final String? date;
  final int? questionCount;
  final List<String> categories;

  GenerateQuestionsRequest({
    required this.userId,
    this.date,
    this.questionCount,
    this.categories = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'questionCount': questionCount,
      'categories': categories,
    };
  }
}

class AnswerQuestionRequest {
  final String questionId;
  final dynamic answer;
  final String? notes;

  AnswerQuestionRequest({
    required this.questionId,
    required this.answer,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'answer': answer,
      'notes': notes,
    };
  }
}

class CheckInInsight {
  final String id;
  final String type;
  final String title;
  final String description;
  final String severity;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? supportingData;
  final double? confidence;
  final String? timeframe;
  final List<String>? relatedMetrics;

  CheckInInsight({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
    required this.timestamp,
    this.metadata,
    this.supportingData,
    this.confidence,
    this.timeframe,
    this.relatedMetrics,
  });

  factory CheckInInsight.fromJson(Map<String, dynamic> json) {
    return CheckInInsight(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      severity: json['severity'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
      supportingData: json['supportingData'],
      confidence: json['confidence']?.toDouble(),
      timeframe: json['timeframe'],
      relatedMetrics: json['relatedMetrics'] != null 
          ? List<String>.from(json['relatedMetrics'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
      if (supportingData != null) 'supportingData': supportingData,
      if (confidence != null) 'confidence': confidence,
      if (timeframe != null) 'timeframe': timeframe,
      if (relatedMetrics != null) 'relatedMetrics': relatedMetrics,
    };
  }
}

class WeeklyInsightsSummary {
  final String summary;
  final List<CheckInInsight> keyInsights;
  final List<String> trends;
  final List<String> recommendations;

  WeeklyInsightsSummary({
    required this.summary,
    required this.keyInsights,
    required this.trends,
    required this.recommendations,
  });

  factory WeeklyInsightsSummary.fromJson(Map<String, dynamic> json) {
    return WeeklyInsightsSummary(
      summary: json['summary'],
      keyInsights: (json['keyInsights'] as List?)
              ?.map((insight) => CheckInInsight.fromJson(insight))
              .toList() ??
          [],
      trends: List<String>.from(json['trends'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'keyInsights': keyInsights.map((insight) => insight.toJson()).toList(),
      'trends': trends,
      'recommendations': recommendations,
    };
  }
}

class DailyCheckInHistory {
  final String date;
  final List<CheckInInsight> insights;

  DailyCheckInHistory({
    required this.date,
    required this.insights,
  });

  factory DailyCheckInHistory.fromJson(Map<String, dynamic> json) {
    return DailyCheckInHistory(
      date: json['date'],
      insights: (json['insights'] as List?)
              ?.map((insight) => CheckInInsight.fromJson(insight))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'insights': insights.map((insight) => insight.toJson()).toList(),
    };
  }
}
