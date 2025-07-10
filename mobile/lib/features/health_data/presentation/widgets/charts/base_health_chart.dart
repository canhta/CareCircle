import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../core/logging/bounded_context_loggers.dart';
import '../../../domain/models/health_metric_type.dart';

/// Base class for health data charts with common healthcare styling
///
/// Provides consistent theming, accessibility, and logging for all
/// health data visualizations with HIPAA-compliant data handling.
abstract class BaseHealthChart extends StatelessWidget {
  final HealthMetricType metricType;
  final String title;
  final List<HealthDataPoint> dataPoints;
  final DateTimeRange? dateRange;
  final bool showGrid;
  final bool showTooltips;
  final double? minY;
  final double? maxY;

  const BaseHealthChart({
    super.key,
    required this.metricType,
    required this.title,
    required this.dataPoints,
    this.dateRange,
    this.showGrid = true,
    this.showTooltips = true,
    this.minY,
    this.maxY,
  });

  static final _logger = BoundedContextLoggers.healthData;

  @override
  Widget build(BuildContext context) {
    _logger.info('Rendering health chart: ${metricType.displayName}');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: dataPoints.isEmpty
                  ? _buildEmptyState(context)
                  : buildChart(context),
            ),
            const SizedBox(height: 8),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Build the chart-specific visualization
  Widget buildChart(BuildContext context);

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(_getMetricIcon(), color: _getMetricColor(), size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _getMetricColor(),
            ),
          ),
        ),
        if (dateRange != null) _buildDateRangeChip(),
      ],
    );
  }

  Widget _buildDateRangeChip() {
    final range = dateRange!;
    final days = range.end.difference(range.start).inDays;
    final rangeText = days <= 1
        ? 'Today'
        : days <= 7
        ? '7 days'
        : days <= 30
        ? '30 days'
        : '${days}d';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getMetricColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        rangeText,
        style: TextStyle(
          fontSize: 12,
          color: _getMetricColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No data available',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Start tracking to see trends',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final latest = dataPoints.last;
    final previous = dataPoints.length > 1
        ? dataPoints[dataPoints.length - 2]
        : null;

    return Row(
      children: [
        Text(
          'Latest: ${_formatValue(latest.value)} ${metricType.unit}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        if (previous != null) ...[
          const SizedBox(width: 16),
          _buildTrendIndicator(latest.value, previous.value),
        ],
        const Spacer(),
        Text(
          '${dataPoints.length} readings',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(double current, double previous) {
    final difference = current - previous;
    final isPositive = difference > 0;
    final isNeutral =
        difference.abs() < 0.01; // Consider very small changes as neutral

    if (isNeutral) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_flat, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 2),
          Text(
            'No change',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: 16,
          color: isPositive ? Colors.red[600] : Colors.green[600],
        ),
        const SizedBox(width: 2),
        Text(
          '${isPositive ? '+' : ''}${_formatValue(difference)}',
          style: TextStyle(
            fontSize: 12,
            color: isPositive ? Colors.red[600] : Colors.green[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Get healthcare-appropriate colors for the metric type
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

  IconData _getMetricIcon() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return Icons.favorite;
      case HealthMetricType.bloodPressure:
        return Icons.monitor_heart;
      case HealthMetricType.bloodGlucose:
        return Icons.bloodtype;
      case HealthMetricType.bodyTemperature:
        return Icons.thermostat;
      case HealthMetricType.weight:
        return Icons.scale;
      case HealthMetricType.height:
        return Icons.height;
      case HealthMetricType.steps:
        return Icons.directions_walk;
      case HealthMetricType.bloodOxygen:
        return Icons.air;
      case HealthMetricType.sleep:
        return Icons.bedtime;
      case HealthMetricType.exercise:
        return Icons.fitness_center;
      case HealthMetricType.respiratoryRate:
        return Icons.air;
      case HealthMetricType.activity:
        return Icons.directions_run;
      case HealthMetricType.mood:
        return Icons.mood;
    }
  }

  /// Format value for display with appropriate precision
  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  /// Get common grid data for consistent styling
  FlGridData getGridData() {
    if (!showGrid) return const FlGridData(show: false);

    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: null,
      verticalInterval: null,
      getDrawingHorizontalLine: (value) =>
          FlLine(color: Colors.grey[300]!, strokeWidth: 0.5),
      getDrawingVerticalLine: (value) =>
          FlLine(color: Colors.grey[300]!, strokeWidth: 0.5),
    );
  }

  /// Get common border data for consistent styling
  FlBorderData getBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(color: Colors.grey[300]!, width: 1),
    );
  }
}

/// Data point for health charts
class HealthDataPoint {
  final DateTime timestamp;
  final double value;
  final Map<String, dynamic>? metadata;

  const HealthDataPoint({
    required this.timestamp,
    required this.value,
    this.metadata,
  });

  /// Get x-axis value (milliseconds since epoch)
  double get x => timestamp.millisecondsSinceEpoch.toDouble();

  /// Get y-axis value
  double get y => value;
}
