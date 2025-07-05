import 'package:flutter/material.dart';
import '../features/health/health.dart';

class HealthInsights extends StatelessWidget {
  final List<CareCircleHealthData> healthData;
  final String timeRangeLabel;

  const HealthInsights({
    super.key,
    required this.healthData,
    required this.timeRangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();

    if (insights.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.lightbulb_outline, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No insights available',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                'More data needed to generate insights',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Health Insights ($timeRangeLabel)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.map((insight) => _buildInsightItem(insight)),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(HealthInsight insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: insight.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.message,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                if (insight.recommendation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    insight.recommendation!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<HealthInsight> _generateInsights() {
    final insights = <HealthInsight>[];

    // Group data by type
    final groupedData =
        <CareCircleHealthDataType, List<CareCircleHealthData>>{};
    for (final point in healthData) {
      groupedData.putIfAbsent(point.type, () => []).add(point);
    }

    // Generate insights for each data type
    groupedData.forEach((type, data) {
      insights.addAll(_generateInsightsForType(type, data));
    });

    // Generate overall insights
    insights.addAll(_generateOverallInsights(groupedData));

    return insights;
  }

  List<HealthInsight> _generateInsightsForType(
    CareCircleHealthDataType type,
    List<CareCircleHealthData> data,
  ) {
    final insights = <HealthInsight>[];

    if (data.isEmpty) return insights;

    // Sort data by timestamp
    data.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final values = data.map((d) => d.value).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    switch (type) {
      case CareCircleHealthDataType.steps:
        insights.addAll(_generateStepsInsights(data, average, min, max));
        break;
      case CareCircleHealthDataType.heartRate:
        insights.addAll(_generateHeartRateInsights(data, average, min, max));
        break;
      case CareCircleHealthDataType.weight:
        insights.addAll(_generateWeightInsights(data, average, min, max));
        break;
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        insights.addAll(_generateSleepInsights(data, average, min, max, type));
        break;
      case CareCircleHealthDataType.bloodPressure:
        insights.addAll(
          _generateBloodPressureInsights(data, average, min, max),
        );
        break;
      case CareCircleHealthDataType.activeEnergyBurned:
        insights.addAll(_generateEnergyInsights(data, average, min, max));
        break;
      default:
        // Generic insights
        insights.add(
          HealthInsight(
            title: '${_getTypeDisplayName(type)} Average',
            message:
                'Average: ${average.toStringAsFixed(1)} ${data.first.unit}',
            color: Colors.blue,
          ),
        );
        break;
    }

    return insights;
  }

  List<HealthInsight> _generateStepsInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
  ) {
    final insights = <HealthInsight>[];

    final dailyGoal = 10000;
    final avgSteps = average.round();

    if (avgSteps >= dailyGoal) {
      insights.add(
        HealthInsight(
          title: 'Great Activity Level! 🎉',
          message:
              'You\'re averaging ${avgSteps.toStringAsFixed(0)} steps per day',
          recommendation:
              'Keep up the excellent work! Consider increasing your goal.',
          color: Colors.green,
        ),
      );
    } else if (avgSteps >= dailyGoal * 0.8) {
      insights.add(
        HealthInsight(
          title: 'Good Progress 👍',
          message:
              'You\'re ${(dailyGoal - avgSteps).round()} steps away from your daily goal',
          recommendation:
              'Try taking a 10-minute walk after meals to reach your goal.',
          color: Colors.orange,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Room for Improvement',
          message: 'Average steps: ${avgSteps.toStringAsFixed(0)} per day',
          recommendation:
              'Consider setting reminders to move more throughout the day.',
          color: Colors.red,
        ),
      );
    }

    return insights;
  }

  List<HealthInsight> _generateHeartRateInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
  ) {
    final insights = <HealthInsight>[];

    final avgBPM = average.round();

    if (avgBPM >= 60 && avgBPM <= 100) {
      insights.add(
        HealthInsight(
          title: 'Heart Rate in Normal Range',
          message: 'Average resting heart rate: $avgBPM BPM',
          recommendation: 'Your heart rate is within the normal range.',
          color: Colors.green,
        ),
      );
    } else if (avgBPM < 60) {
      insights.add(
        HealthInsight(
          title: 'Low Heart Rate',
          message: 'Average heart rate: $avgBPM BPM',
          recommendation: 'Consider consulting with a healthcare provider.',
          color: Colors.orange,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Elevated Heart Rate',
          message: 'Average heart rate: $avgBPM BPM',
          recommendation:
              'Monitor stress levels and consider medical consultation.',
          color: Colors.red,
        ),
      );
    }

    return insights;
  }

  List<HealthInsight> _generateWeightInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
  ) {
    final insights = <HealthInsight>[];

    if (data.length >= 2) {
      final weightChange = data.last.value - data.first.value;
      final daysSpan =
          data.last.timestamp.difference(data.first.timestamp).inDays;

      if (weightChange.abs() > 0.5 && daysSpan > 0) {
        final trend = weightChange > 0 ? 'gained' : 'lost';
        insights.add(
          HealthInsight(
            title: 'Weight Trend',
            message:
                'You\'ve $trend ${weightChange.abs().toStringAsFixed(1)} ${data.first.unit}',
            recommendation:
                'Track your progress consistently for better insights.',
            color: Colors.blue,
          ),
        );
      } else {
        insights.add(
          HealthInsight(
            title: 'Weight Stable',
            message: 'Your weight has remained relatively stable',
            color: Colors.green,
          ),
        );
      }
    }

    return insights;
  }

  List<HealthInsight> _generateSleepInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
    CareCircleHealthDataType type,
  ) {
    final insights = <HealthInsight>[];

    // Convert minutes to hours for display
    final avgHours = average / 60;

    if (type == CareCircleHealthDataType.sleepAsleep) {
      if (avgHours >= 7 && avgHours <= 9) {
        insights.add(
          HealthInsight(
            title: 'Good Sleep Duration',
            message: 'Average sleep: ${avgHours.toStringAsFixed(1)} hours',
            recommendation: 'You\'re getting adequate sleep for recovery.',
            color: Colors.green,
          ),
        );
      } else if (avgHours < 7) {
        insights.add(
          HealthInsight(
            title: 'Insufficient Sleep',
            message: 'Average sleep: ${avgHours.toStringAsFixed(1)} hours',
            recommendation: 'Try to get 7-9 hours of sleep for optimal health.',
            color: Colors.red,
          ),
        );
      } else {
        insights.add(
          HealthInsight(
            title: 'Long Sleep Duration',
            message: 'Average sleep: ${avgHours.toStringAsFixed(1)} hours',
            recommendation:
                'Consider sleep quality if you\'re sleeping more than 9 hours.',
            color: Colors.orange,
          ),
        );
      }
    }

    return insights;
  }

  List<HealthInsight> _generateBloodPressureInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
  ) {
    final insights = <HealthInsight>[];

    // Note: This is simplified - blood pressure needs systolic/diastolic
    insights.add(
      HealthInsight(
        title: 'Blood Pressure Monitoring',
        message: 'Regular monitoring is important for cardiovascular health',
        recommendation:
            'Consult with your healthcare provider about your readings.',
        color: Colors.blue,
      ),
    );

    return insights;
  }

  List<HealthInsight> _generateEnergyInsights(
    List<CareCircleHealthData> data,
    double average,
    double min,
    double max,
  ) {
    final insights = <HealthInsight>[];

    final avgCalories = average.round();

    if (avgCalories >= 300) {
      insights.add(
        HealthInsight(
          title: 'Active Lifestyle',
          message:
              'You\'re burning an average of $avgCalories calories per day',
          recommendation: 'Great job staying active!',
          color: Colors.green,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Moderate Activity',
          message: 'Average calories burned: $avgCalories per day',
          recommendation:
              'Consider adding more physical activity to your routine.',
          color: Colors.orange,
        ),
      );
    }

    return insights;
  }

  List<HealthInsight> _generateOverallInsights(
    Map<CareCircleHealthDataType, List<CareCircleHealthData>> groupedData,
  ) {
    final insights = <HealthInsight>[];

    // Data consistency insight
    final daysWithData = healthData.map((d) => d.timestamp.day).toSet().length;

    if (daysWithData >= 5) {
      insights.add(
        HealthInsight(
          title: 'Consistent Tracking',
          message: 'You have health data for $daysWithData days',
          recommendation: 'Great job maintaining consistent health tracking!',
          color: Colors.green,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Improve Data Consistency',
          message: 'Health data available for $daysWithData days',
          recommendation:
              'Try to sync your health data more regularly for better insights.',
          color: Colors.orange,
        ),
      );
    }

    return insights;
  }

  String _getTypeDisplayName(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      case CareCircleHealthDataType.weight:
        return 'Weight';
      case CareCircleHealthDataType.sleepInBed:
        return 'Sleep (In Bed)';
      case CareCircleHealthDataType.sleepAsleep:
        return 'Sleep (Asleep)';
      case CareCircleHealthDataType.bloodPressure:
        return 'Blood Pressure';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Energy';
      default:
        return type.toString().split('.').last;
    }
  }
}

class HealthInsight {
  final String title;
  final String message;
  final String? recommendation;
  final Color color;

  HealthInsight({
    required this.title,
    required this.message,
    this.recommendation,
    required this.color,
  });
}
