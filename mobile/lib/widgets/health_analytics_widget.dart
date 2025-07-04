import 'package:flutter/material.dart';
import '../services/health_service.dart';
import 'time_range_selector.dart';

class HealthAnalyticsWidget extends StatefulWidget {
  final List<CareCircleHealthData> healthData;
  final CareCircleHealthDataType dataType;
  final TimeRange timeRange;

  const HealthAnalyticsWidget({
    super.key,
    required this.healthData,
    required this.dataType,
    required this.timeRange,
  });

  @override
  State<HealthAnalyticsWidget> createState() => _HealthAnalyticsWidgetState();
}

class _HealthAnalyticsWidgetState extends State<HealthAnalyticsWidget> {
  late HealthDataAnalytics _analytics;

  @override
  void initState() {
    super.initState();
    _updateAnalytics();
  }

  @override
  void didUpdateWidget(HealthAnalyticsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.healthData != oldWidget.healthData ||
        widget.dataType != oldWidget.dataType ||
        widget.timeRange != oldWidget.timeRange) {
      _updateAnalytics();
    }
  }

  void _updateAnalytics() {
    _analytics = HealthDataAnalytics.fromHealthData(
      widget.healthData,
      widget.dataType,
      widget.timeRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForDataType(widget.dataType),
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _getDisplayNameForType(widget.dataType),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildTrendAnalysis(),
            const SizedBox(height: 16),
            _buildInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _buildStatCard(
          'Current',
          _analytics.currentValue.toStringAsFixed(1),
          _analytics.unit,
          Colors.blue,
          Icons.trending_up,
        ),
        _buildStatCard(
          'Average',
          _analytics.averageValue.toStringAsFixed(1),
          _analytics.unit,
          Colors.green,
          Icons.insights,
        ),
        _buildStatCard(
          'Best',
          _analytics.maxValue.toStringAsFixed(1),
          _analytics.unit,
          Colors.orange,
          Icons.star,
        ),
        _buildStatCard(
          'Lowest',
          _analytics.minValue.toStringAsFixed(1),
          _analytics.unit,
          Colors.red,
          Icons.trending_down,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis() {
    final theme = Theme.of(context);
    final trendIcon = _analytics.trendDirection == TrendDirection.up
        ? Icons.trending_up
        : _analytics.trendDirection == TrendDirection.down
        ? Icons.trending_down
        : Icons.trending_flat;

    final trendColor = _analytics.trendDirection == TrendDirection.up
        ? Colors.green
        : _analytics.trendDirection == TrendDirection.down
        ? Colors.red
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(trendIcon, color: trendColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trend Analysis',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _analytics.trendDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_analytics.trendPercentage.toStringAsFixed(1)}%',
            style: theme.textTheme.titleSmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ..._analytics.insights.map((insight) => _buildInsightItem(insight)),
      ],
    );
  }

  Widget _buildInsightItem(HealthInsight insight) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: insight.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: insight.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(insight.icon, color: insight.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (insight.message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    insight.message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  IconData _getIconForDataType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return Icons.directions_walk;
      case CareCircleHealthDataType.heartRate:
        return Icons.favorite;
      case CareCircleHealthDataType.weight:
        return Icons.monitor_weight;
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        return Icons.bedtime;
      case CareCircleHealthDataType.bloodPressure:
        return Icons.bloodtype;
      case CareCircleHealthDataType.bloodGlucose:
        return Icons.water_drop;
      case CareCircleHealthDataType.bodyTemperature:
        return Icons.thermostat;
      case CareCircleHealthDataType.oxygenSaturation:
        return Icons.air;
      case CareCircleHealthDataType.activeEnergyBurned:
      case CareCircleHealthDataType.basalEnergyBurned:
        return Icons.local_fire_department;
      case CareCircleHealthDataType.distanceWalkingRunning:
        return Icons.map;
      case CareCircleHealthDataType.height:
        return Icons.height;
    }
  }

  String _getDisplayNameForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      case CareCircleHealthDataType.weight:
        return 'Weight';
      case CareCircleHealthDataType.height:
        return 'Height';
      case CareCircleHealthDataType.sleepInBed:
        return 'Sleep Time in Bed';
      case CareCircleHealthDataType.sleepAsleep:
        return 'Sleep Time Asleep';
      case CareCircleHealthDataType.bloodPressure:
        return 'Blood Pressure';
      case CareCircleHealthDataType.bloodGlucose:
        return 'Blood Glucose';
      case CareCircleHealthDataType.bodyTemperature:
        return 'Body Temperature';
      case CareCircleHealthDataType.oxygenSaturation:
        return 'Oxygen Saturation';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Energy Burned';
      case CareCircleHealthDataType.basalEnergyBurned:
        return 'Basal Energy Burned';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'Distance Walking/Running';
    }
  }
}

class HealthDataAnalytics {
  final double currentValue;
  final double averageValue;
  final double maxValue;
  final double minValue;
  final double trendPercentage;
  final TrendDirection trendDirection;
  final String trendDescription;
  final String unit;
  final List<HealthInsight> insights;

  HealthDataAnalytics({
    required this.currentValue,
    required this.averageValue,
    required this.maxValue,
    required this.minValue,
    required this.trendPercentage,
    required this.trendDirection,
    required this.trendDescription,
    required this.unit,
    required this.insights,
  });

  factory HealthDataAnalytics.fromHealthData(
    List<CareCircleHealthData> data,
    CareCircleHealthDataType dataType,
    TimeRange timeRange,
  ) {
    if (data.isEmpty) {
      return HealthDataAnalytics(
        currentValue: 0,
        averageValue: 0,
        maxValue: 0,
        minValue: 0,
        trendPercentage: 0,
        trendDirection: TrendDirection.flat,
        trendDescription: 'No data available',
        unit: '',
        insights: [],
      );
    }

    final values = data.map((d) => d.value).toList();
    final currentValue = values.last;
    final averageValue = values.reduce((a, b) => a + b) / values.length;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final unit = data.first.unit;

    // Calculate trend
    final firstHalf = values.take(values.length ~/ 2).toList();
    final secondHalf = values.skip(values.length ~/ 2).toList();

    final firstHalfAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondHalfAvg =
        secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    final trendPercentage =
        ((secondHalfAvg - firstHalfAvg) / firstHalfAvg) * 100;
    final trendDirection = trendPercentage > 5
        ? TrendDirection.up
        : trendPercentage < -5
        ? TrendDirection.down
        : TrendDirection.flat;

    final trendDescription = _getTrendDescription(
      trendDirection,
      trendPercentage,
      dataType,
    );
    final insights = _generateInsights(data, dataType, timeRange);

    return HealthDataAnalytics(
      currentValue: currentValue,
      averageValue: averageValue,
      maxValue: maxValue,
      minValue: minValue,
      trendPercentage: trendPercentage.abs(),
      trendDirection: trendDirection,
      trendDescription: trendDescription,
      unit: unit,
      insights: insights,
    );
  }

  static String _getTrendDescription(
    TrendDirection direction,
    double percentage,
    CareCircleHealthDataType dataType,
  ) {
    switch (direction) {
      case TrendDirection.up:
        return _isPositiveTrend(dataType)
            ? 'Trending upward - Good progress!'
            : 'Trending upward - Monitor closely';
      case TrendDirection.down:
        return _isPositiveTrend(dataType)
            ? 'Trending downward - Needs attention'
            : 'Trending downward - Good improvement!';
      case TrendDirection.flat:
        return 'Stable trend - Consistent performance';
    }
  }

  static bool _isPositiveTrend(CareCircleHealthDataType dataType) {
    switch (dataType) {
      case CareCircleHealthDataType.steps:
      case CareCircleHealthDataType.activeEnergyBurned:
      case CareCircleHealthDataType.distanceWalkingRunning:
      case CareCircleHealthDataType.sleepAsleep:
      case CareCircleHealthDataType.sleepInBed:
        return true;
      case CareCircleHealthDataType.weight:
      case CareCircleHealthDataType.bloodPressure:
      case CareCircleHealthDataType.bloodGlucose:
        return false;
      default:
        return true;
    }
  }

  static List<HealthInsight> _generateInsights(
    List<CareCircleHealthData> data,
    CareCircleHealthDataType dataType,
    TimeRange timeRange,
  ) {
    final insights = <HealthInsight>[];

    // Add basic insights based on data type
    switch (dataType) {
      case CareCircleHealthDataType.steps:
        insights.addAll(_getStepsInsights(data));
        break;
      case CareCircleHealthDataType.heartRate:
        insights.addAll(_getHeartRateInsights(data));
        break;
      case CareCircleHealthDataType.weight:
        insights.addAll(_getWeightInsights(data));
        break;
      case CareCircleHealthDataType.sleepAsleep:
        insights.addAll(_getSleepInsights(data));
        break;
      default:
        insights.add(
          HealthInsight(
            title: 'Data Available',
            message: 'You have ${data.length} readings for this metric',
            color: Colors.blue,
            icon: Icons.info,
          ),
        );
    }

    return insights;
  }

  static List<HealthInsight> _getStepsInsights(
    List<CareCircleHealthData> data,
  ) {
    final insights = <HealthInsight>[];
    final average =
        data.map((d) => d.value).reduce((a, b) => a + b) / data.length;

    if (average >= 10000) {
      insights.add(
        HealthInsight(
          title: 'Great Activity Level!',
          message: 'You\'re consistently meeting the 10,000 steps goal',
          color: Colors.green,
          icon: Icons.check_circle,
        ),
      );
    } else if (average >= 7500) {
      insights.add(
        HealthInsight(
          title: 'Good Progress',
          message: 'You\'re close to the 10,000 steps goal',
          color: Colors.orange,
          icon: Icons.trending_up,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Room for Improvement',
          message: 'Try to increase your daily activity',
          color: Colors.red,
          icon: Icons.flag,
        ),
      );
    }

    return insights;
  }

  static List<HealthInsight> _getHeartRateInsights(
    List<CareCircleHealthData> data,
  ) {
    final insights = <HealthInsight>[];
    final average =
        data.map((d) => d.value).reduce((a, b) => a + b) / data.length;

    if (average >= 60 && average <= 100) {
      insights.add(
        HealthInsight(
          title: 'Normal Heart Rate',
          message: 'Your heart rate is in the healthy range',
          color: Colors.green,
          icon: Icons.favorite,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Monitor Heart Rate',
          message: 'Consider discussing with your healthcare provider',
          color: Colors.orange,
          icon: Icons.warning,
        ),
      );
    }

    return insights;
  }

  static List<HealthInsight> _getWeightInsights(
    List<CareCircleHealthData> data,
  ) {
    final insights = <HealthInsight>[];
    final values = data.map((d) => d.value).toList();

    if (values.length >= 2) {
      final change = values.last - values.first;
      if (change.abs() > 2) {
        insights.add(
          HealthInsight(
            title: 'Weight Change Detected',
            message:
                'Your weight has changed by ${change.toStringAsFixed(1)} kg',
            color: change > 0 ? Colors.orange : Colors.blue,
            icon: Icons.scale,
          ),
        );
      }
    }

    return insights;
  }

  static List<HealthInsight> _getSleepInsights(
    List<CareCircleHealthData> data,
  ) {
    final insights = <HealthInsight>[];
    final average =
        data.map((d) => d.value).reduce((a, b) => a + b) / data.length;

    if (average >= 7 && average <= 9) {
      insights.add(
        HealthInsight(
          title: 'Good Sleep Duration',
          message: 'You\'re getting recommended sleep hours',
          color: Colors.green,
          icon: Icons.bedtime,
        ),
      );
    } else if (average < 7) {
      insights.add(
        HealthInsight(
          title: 'Insufficient Sleep',
          message: 'Try to get more sleep for better health',
          color: Colors.red,
          icon: Icons.warning,
        ),
      );
    } else {
      insights.add(
        HealthInsight(
          title: 'Excessive Sleep',
          message: 'Consider optimizing your sleep schedule',
          color: Colors.orange,
          icon: Icons.schedule,
        ),
      );
    }

    return insights;
  }
}

enum TrendDirection { up, down, flat }

class HealthInsight {
  final String title;
  final String message;
  final Color color;
  final IconData icon;

  HealthInsight({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
  });
}
