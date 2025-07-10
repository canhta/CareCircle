import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../../core/logging/bounded_context_loggers.dart';
import '../../../domain/models/health_metric_type.dart';
import 'base_health_chart.dart';

/// Line chart for displaying health metric trends over time
///
/// Optimized for healthcare data visualization with appropriate
/// scaling, tooltips, and accessibility features.
class HealthLineChart extends BaseHealthChart {
  final bool showDots;
  final bool showArea;
  final double strokeWidth;
  final bool enableTouch;

  const HealthLineChart({
    super.key,
    required super.metricType,
    required super.title,
    required super.dataPoints,
    super.dateRange,
    super.showGrid = true,
    super.showTooltips = true,
    super.minY,
    super.maxY,
    this.showDots = true,
    this.showArea = false,
    this.strokeWidth = 2.0,
    this.enableTouch = true,
  });

  @override
  Widget buildChart(BuildContext context) {
    final spots = dataPoints.map((point) => FlSpot(point.x, point.y)).toList();

    return LineChart(
      LineChartData(
        gridData: getGridData(),
        titlesData: _getTitlesData(),
        borderData: getBorderData(),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: _getMetricColor(),
            barWidth: strokeWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showDots,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 3, color: _getMetricColor(), strokeWidth: 1, strokeColor: Colors.white),
            ),
            belowBarData: showArea
                ? BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_getMetricColor().withValues(alpha: 0.3), _getMetricColor().withValues(alpha: 0.1)],
                    ),
                  )
                : BarAreaData(show: false),
          ),
        ],
        lineTouchData: enableTouch ? _getLineTouchData() : LineTouchData(enabled: false),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
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
          interval: _getBottomInterval(),
          getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: _getLeftInterval(),
          getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
        ),
      ),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final formatter = _getDateFormatter();

    return Text(formatter.format(date), style: TextStyle(color: Colors.grey[600], fontSize: 10));
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Text(_formatValue(value), style: TextStyle(color: Colors.grey[600], fontSize: 10));
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

  double? _getBottomInterval() {
    if (dataPoints.length <= 1) return null;

    final range = _getMaxX() - _getMinX();
    final targetTicks = 5;
    return range / targetTicks;
  }

  double? _getLeftInterval() {
    if (dataPoints.isEmpty) return null;

    final range = _getMaxY() - _getMinY();
    final targetTicks = 5;
    return range / targetTicks;
  }

  LineTouchData _getLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.black87,
        tooltipPadding: const EdgeInsets.all(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((touchedSpot) {
            final date = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
            final value = touchedSpot.y;

            return LineTooltipItem(
              '${_formatValue(value)} ${metricType.unit}\n${DateFormat('MMM dd, HH:mm').format(date)}',
              const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            );
          }).toList();
        },
      ),
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        // Log touch events for analytics (with privacy protection)
        if (event is FlTapUpEvent && touchResponse?.lineBarSpots?.isNotEmpty == true) {
          final spot = touchResponse!.lineBarSpots!.first;
          BoundedContextLoggers.healthData.info('Health chart touched: ${metricType.displayName} at ${spot.x}');
        }
      },
    );
  }

  double _getMinX() {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.first.x;
  }

  double _getMaxX() {
    if (dataPoints.isEmpty) return 1;
    return dataPoints.last.x;
  }

  double _getMinY() {
    if (minY != null) return minY!;
    if (dataPoints.isEmpty) return 0;

    final values = dataPoints.map((p) => p.y).toList();
    final min = values.reduce((a, b) => a < b ? a : b);

    // Add some padding below the minimum
    return min - (min * 0.1);
  }

  double _getMaxY() {
    if (maxY != null) return maxY!;
    if (dataPoints.isEmpty) return 1;

    final values = dataPoints.map((p) => p.y).toList();
    final max = values.reduce((a, b) => a > b ? a : b);

    // Add some padding above the maximum
    return max + (max * 0.1);
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

/// Specialized line chart for blood pressure with dual values
class BloodPressureLineChart extends BaseHealthChart {
  final List<HealthDataPoint> diastolicPoints;

  const BloodPressureLineChart({
    super.key,
    required super.metricType,
    required super.title,
    required super.dataPoints, // systolic points
    required this.diastolicPoints,
    super.dateRange,
    super.showGrid = true,
    super.showTooltips = true,
    super.minY,
    super.maxY,
  });

  @override
  Widget buildChart(BuildContext context) {
    final systolicSpots = dataPoints.map((point) => FlSpot(point.x, point.y)).toList();
    final diastolicSpots = diastolicPoints.map((point) => FlSpot(point.x, point.y)).toList();

    return LineChart(
      LineChartData(
        gridData: getGridData(),
        titlesData: _getTitlesData(),
        borderData: getBorderData(),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          // Systolic line
          LineChartBarData(
            spots: systolicSpots,
            color: Colors.red[600]!,
            barWidth: 2.0,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 3, color: Colors.red[600]!, strokeWidth: 1, strokeColor: Colors.white),
            ),
          ),
          // Diastolic line
          LineChartBarData(
            spots: diastolicSpots,
            color: Colors.blue[600]!,
            barWidth: 2.0,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 3, color: Colors.blue[600]!, strokeWidth: 1, strokeColor: Colors.white),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (touchedSpots) {
              if (touchedSpots.length >= 2) {
                final date = DateTime.fromMillisecondsSinceEpoch(touchedSpots.first.x.toInt());
                final systolic = touchedSpots.first.y;
                final diastolic = touchedSpots.last.y;

                return [
                  LineTooltipItem(
                    '${systolic.round()}/${diastolic.round()} mmHg\n${DateFormat('MMM dd, HH:mm').format(date)}',
                    const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ];
              }
              return [];
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
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
            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return Text(DateFormat('MM/dd').format(date), style: TextStyle(color: Colors.grey[600], fontSize: 10));
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            return Text(value.round().toString(), style: TextStyle(color: Colors.grey[600], fontSize: 10));
          },
        ),
      ),
    );
  }

  double _getMinX() {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.first.x;
  }

  double _getMaxX() {
    if (dataPoints.isEmpty) return 1;
    return dataPoints.last.x;
  }

  double _getMinY() {
    if (minY != null) return minY!;
    if (dataPoints.isEmpty && diastolicPoints.isEmpty) return 0;

    final allValues = [...dataPoints.map((p) => p.y), ...diastolicPoints.map((p) => p.y)];

    if (allValues.isEmpty) return 0;

    final min = allValues.reduce((a, b) => a < b ? a : b);
    return min - 10; // Add padding for blood pressure readings
  }

  double _getMaxY() {
    if (maxY != null) return maxY!;
    if (dataPoints.isEmpty && diastolicPoints.isEmpty) return 1;

    final allValues = [...dataPoints.map((p) => p.y), ...diastolicPoints.map((p) => p.y)];

    if (allValues.isEmpty) return 1;

    final max = allValues.reduce((a, b) => a > b ? a : b);
    return max + 10; // Add padding for blood pressure readings
  }
}
