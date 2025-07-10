import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../../core/logging/bounded_context_loggers.dart';
import '../../../domain/models/health_metric_type.dart';
import 'base_health_chart.dart';

/// Bar chart for displaying health metrics with discrete values
///
/// Ideal for showing daily/weekly summaries, goal achievements,
/// and categorical health data with healthcare-appropriate styling.
class HealthBarChart extends BaseHealthChart {
  final bool showValues;
  final double barWidth;
  final bool enableTouch;

  const HealthBarChart({
    super.key,
    required super.metricType,
    required super.title,
    required super.dataPoints,
    super.dateRange,
    super.showGrid = true,
    super.showTooltips = true,
    super.minY,
    super.maxY,
    this.showValues = true,
    this.barWidth = 20,
    this.enableTouch = true,
  });

  @override
  Widget buildChart(BuildContext context) {
    final barGroups = _createBarGroups();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        minY: _getMinY(),
        gridData: getGridData(),
        titlesData: _getTitlesData(),
        borderData: getBorderData(),
        barGroups: barGroups,
        barTouchData: enableTouch
            ? _getBarTouchData()
            : BarTouchData(enabled: false),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return dataPoints.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: point.y,
            color: _getMetricColor(),
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            rodStackItems: [],
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: _getMetricColor().withValues(alpha: 0.1),
            ),
          ),
        ],
        showingTooltipIndicators: showValues ? [0] : [],
      );
    }).toList();
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) =>
              _buildBottomTitle(value.toInt(), meta),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
        ),
      ),
    );
  }

  Widget _buildBottomTitle(int index, TitleMeta meta) {
    if (index < 0 || index >= dataPoints.length) {
      return const SizedBox.shrink();
    }

    final point = dataPoints[index];
    final formatter = _getDateFormatter();

    return Text(
      formatter.format(point.timestamp),
      style: TextStyle(color: Colors.grey[600], fontSize: 10),
    );
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Text(
      _formatValue(value),
      style: TextStyle(color: Colors.grey[600], fontSize: 10),
    );
  }

  DateFormat _getDateFormatter() {
    if (dateRange == null) return DateFormat('MM/dd');

    final days = dateRange!.end.difference(dateRange!.start).inDays;

    if (days <= 1) {
      return DateFormat('HH:mm'); // Hours for same day
    } else if (days <= 7) {
      return DateFormat('E'); // Day of week for week view
    } else if (days <= 31) {
      return DateFormat('MM/dd'); // Month/day for month view
    } else {
      return DateFormat('MM/yy'); // Month/year for longer periods
    }
  }

  BarTouchData _getBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.black87,
        tooltipPadding: const EdgeInsets.all(8),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          if (groupIndex >= dataPoints.length) return null;

          final point = dataPoints[groupIndex];
          final value = point.y;

          return BarTooltipItem(
            '${_formatValue(value)} ${metricType.unit}\n${DateFormat('MMM dd, HH:mm').format(point.timestamp)}',
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
      touchCallback: (FlTouchEvent event, BarTouchResponse? touchResponse) {
        // Log touch events for analytics (with privacy protection)
        if (event is FlTapUpEvent &&
            touchResponse?.spot?.touchedBarGroup != null) {
          final groupIndex = touchResponse!.spot!.touchedBarGroup.x;
          BoundedContextLoggers.healthData.info(
            'Health bar chart touched: ${metricType.displayName} at index $groupIndex',
          );
        }
      },
    );
  }

  double _getMinY() {
    if (minY != null) return minY!;
    if (dataPoints.isEmpty) return 0;

    final values = dataPoints.map((p) => p.y).toList();
    final min = values.reduce((a, b) => a < b ? a : b);

    // For bar charts, usually start from 0 or slightly below minimum
    return min > 0 ? 0 : min - (min.abs() * 0.1);
  }

  double _getMaxY() {
    if (maxY != null) return maxY!;
    if (dataPoints.isEmpty) return 1;

    final values = dataPoints.map((p) => p.y).toList();
    final max = values.reduce((a, b) => a > b ? a : b);

    // Add some padding above the maximum for better visualization
    return max + (max * 0.2);
  }

  Color _getMetricColor() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return Colors.red[600]!;
      case HealthMetricType.bloodPressure:
        return Colors.blue[600]!;
      case HealthMetricType.bloodGlucose:
        return Colors.orange[600]!;
      case HealthMetricType.bodyTemperature:
        return Colors.amber[600]!;
      case HealthMetricType.weight:
        return Colors.green[600]!;
      case HealthMetricType.height:
        return Colors.teal[600]!;
      case HealthMetricType.steps:
        return Colors.purple[600]!;
      case HealthMetricType.bloodOxygen:
        return Colors.cyan[600]!;
      case HealthMetricType.sleep:
        return Colors.indigo[600]!;
      case HealthMetricType.exercise:
        return Colors.deepOrange[600]!;
      case HealthMetricType.respiratoryRate:
        return Colors.lightBlue[600]!;
      case HealthMetricType.activity:
        return Colors.lime[600]!;
      case HealthMetricType.mood:
        return Colors.pink[600]!;
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }
}

/// Specialized bar chart for weekly step counts with goal indicators
class WeeklyStepsBarChart extends BaseHealthChart {
  final double? dailyGoal;

  const WeeklyStepsBarChart({
    super.key,
    required super.metricType,
    required super.title,
    required super.dataPoints,
    super.dateRange,
    super.showGrid = true,
    super.showTooltips = true,
    super.minY,
    super.maxY,
    this.dailyGoal,
  });

  @override
  Widget buildChart(BuildContext context) {
    final barGroups = _createBarGroupsWithGoal();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        minY: 0,
        gridData: getGridData(),
        titlesData: _getTitlesData(),
        borderData: getBorderData(),
        barGroups: barGroups,
        extraLinesData: dailyGoal != null ? _getGoalLine() : null,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              if (groupIndex >= dataPoints.length) return null;

              final point = dataPoints[groupIndex];
              final steps = point.y.round();
              final goalText = dailyGoal != null
                  ? '\nGoal: ${dailyGoal!.round()} steps'
                  : '';

              return BarTooltipItem(
                '$steps steps$goalText\n${DateFormat('E, MMM dd').format(point.timestamp)}',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  List<BarChartGroupData> _createBarGroupsWithGoal() {
    return dataPoints.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final metGoal = dailyGoal != null && point.y >= dailyGoal!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: point.y,
            color: metGoal ? Colors.green[600]! : Colors.purple[600]!,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  ExtraLinesData _getGoalLine() {
    return ExtraLinesData(
      horizontalLines: [
        HorizontalLine(
          y: dailyGoal!,
          color: Colors.orange[600]!,
          strokeWidth: 2,
          dashArray: [5, 5],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(right: 8, top: 4),
            style: TextStyle(
              color: Colors.orange[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            labelResolver: (line) => 'Goal: ${line.y.round()}',
          ),
        ),
      ],
    );
  }

  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= dataPoints.length) {
              return const SizedBox.shrink();
            }

            final point = dataPoints[index];
            return Text(
              DateFormat('E').format(point.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return Text(
              '${(value / 1000).round()}k',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            );
          },
        ),
      ),
    );
  }

  double _getMaxY() {
    if (maxY != null) return maxY!;
    if (dataPoints.isEmpty) return dailyGoal ?? 10000;

    final values = dataPoints.map((p) => p.y).toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    final goalMax = dailyGoal ?? 0;

    return (max > goalMax ? max : goalMax) * 1.2;
  }
}
