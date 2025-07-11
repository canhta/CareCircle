import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../design/design_tokens.dart';

/// Enum for different health metric types
enum HealthMetricType {
  heartRate,
  bloodPressure,
  weight,
  steps,
  sleep,
  bloodGlucose,
}

/// Extension for health metric type display names
extension HealthMetricTypeExtension on HealthMetricType {
  String get displayName {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'Heart Rate';
      case HealthMetricType.bloodPressure:
        return 'Blood Pressure';
      case HealthMetricType.weight:
        return 'Weight';
      case HealthMetricType.steps:
        return 'Steps';
      case HealthMetricType.sleep:
        return 'Sleep';
      case HealthMetricType.bloodGlucose:
        return 'Blood Glucose';
    }
  }

  String get unit {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'bpm';
      case HealthMetricType.bloodPressure:
        return 'mmHg';
      case HealthMetricType.weight:
        return 'kg';
      case HealthMetricType.steps:
        return 'steps';
      case HealthMetricType.sleep:
        return 'hours';
      case HealthMetricType.bloodGlucose:
        return 'mg/dL';
    }
  }
}

/// Data model for health metric readings
class HealthMetricData {
  final double value;
  final DateTime timestamp;
  final String? note;
  final bool isAbnormal;

  const HealthMetricData({
    required this.value,
    required this.timestamp,
    this.note,
    this.isAbnormal = false,
  });
}

/// Healthcare-optimized chart component for health metrics
/// 
/// Displays health data with accessibility compliance, interactive features,
/// and medical context awareness including normal ranges and trend analysis.
class HealthMetricChart extends StatelessWidget {
  const HealthMetricChart({
    super.key,
    required this.data,
    required this.metricType,
    this.timeRange = const Duration(days: 7),
    this.showNormalRange = true,
    this.isInteractive = true,
    this.onDataPointTap,
    required this.chartDescription,
    this.dataPointDescriptions = const [],
    this.height = 200,
    this.normalRangeMin,
    this.normalRangeMax,
  });

  final List<HealthMetricData> data;
  final HealthMetricType metricType;
  final Duration timeRange;
  final bool showNormalRange;
  final bool isInteractive;
  final Function(HealthMetricData)? onDataPointTap;
  final double height;
  final double? normalRangeMin;
  final double? normalRangeMax;
  
  // Accessibility properties
  final String chartDescription;
  final List<String> dataPointDescriptions;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState();
    }

    return Semantics(
      label: 'Health metric chart for ${metricType.displayName}',
      hint: chartDescription,
      child: Container(
        height: height,
        padding: EdgeInsets.all(CareCircleSpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(),
            SizedBox(height: CareCircleSpacingTokens.sm),
            Expanded(
              child: _buildChart(),
            ),
            if (isInteractive) ...[
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildChartLegend(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: height,
      padding: EdgeInsets.all(CareCircleSpacingTokens.md),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 48,
              color: CareCircleColorTokens.unknownData,
            ),
            SizedBox(height: CareCircleSpacingTokens.sm),
            Text(
              'No data available',
              style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                color: CareCircleColorTokens.unknownData,
              ),
            ),
            SizedBox(height: CareCircleSpacingTokens.xs),
            Text(
              'Start tracking your ${metricType.displayName.toLowerCase()} to see trends',
              style: CareCircleTypographyTokens.medicalNote.copyWith(
                color: CareCircleColorTokens.unknownData,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartHeader() {
    return Row(
      children: [
        Icon(
          _getMetricIcon(),
          color: _getMetricColor(),
          size: 24,
        ),
        SizedBox(width: CareCircleSpacingTokens.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metricType.displayName,
                style: CareCircleTypographyTokens.healthMetricTitle,
              ),
              Text(
                _getTimeRangeText(),
                style: CareCircleTypographyTokens.medicalNote,
              ),
            ],
          ),
        ),
        _buildCurrentValue(),
      ],
    );
  }

  Widget _buildCurrentValue() {
    if (data.isEmpty) return const SizedBox.shrink();
    
    final currentValue = data.last.value;
    final isAbnormal = data.last.isAbnormal;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          currentValue.toStringAsFixed(_getDecimalPlaces()),
          style: CareCircleTypographyTokens.vitalSignsMedium.copyWith(
            color: isAbnormal ? CareCircleColorTokens.dangerRange : _getMetricColor(),
          ),
        ),
        Text(
          metricType.unit,
          style: CareCircleTypographyTokens.medicalLabel.copyWith(
            color: isAbnormal ? CareCircleColorTokens.dangerRange : _getMetricColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getHorizontalInterval(),
          verticalInterval: _getVerticalInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: CareCircleColorTokens.normalRange.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: CareCircleColorTokens.normalRange.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: CareCircleColorTokens.normalRange.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          _buildMainDataLine(),
          if (showNormalRange && normalRangeMin != null && normalRangeMax != null) 
            ..._buildNormalRangeLines(),
        ],
        lineTouchData: isInteractive ? _buildTouchData() : LineTouchData(enabled: false),
      ),
    );
  }

  LineChartBarData _buildMainDataLine() {
    return LineChartBarData(
      spots: data.map((point) => FlSpot(
        point.timestamp.millisecondsSinceEpoch.toDouble(),
        point.value,
      )).toList(),
      isCurved: true,
      color: _getMetricColor(),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isAbnormal = index < data.length ? data[index].isAbnormal : false;
          return FlDotCirclePainter(
            radius: 4,
            color: isAbnormal ? CareCircleColorTokens.dangerRange : _getMetricColor(),
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: _getMetricColor().withValues(alpha: 0.1),
      ),
    );
  }

  List<LineChartBarData> _buildNormalRangeLines() {
    if (normalRangeMin == null || normalRangeMax == null) return [];
    
    final minX = _getMinX();
    final maxX = _getMaxX();
    
    return [
      // Normal range minimum line
      LineChartBarData(
        spots: [
          FlSpot(minX, normalRangeMin!),
          FlSpot(maxX, normalRangeMin!),
        ],
        isCurved: false,
        color: CareCircleColorTokens.normalRange.withValues(alpha: 0.6),
        barWidth: 1,
        dotData: FlDotData(show: false),
        dashArray: [5, 5],
      ),
      // Normal range maximum line
      LineChartBarData(
        spots: [
          FlSpot(minX, normalRangeMax!),
          FlSpot(maxX, normalRangeMax!),
        ],
        isCurved: false,
        color: CareCircleColorTokens.normalRange.withValues(alpha: 0.6),
        barWidth: 1,
        dotData: FlDotData(show: false),
        dashArray: [5, 5],
      ),
    ];
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('Current', _getMetricColor()),
        if (showNormalRange && normalRangeMin != null && normalRangeMax != null) ...[
          SizedBox(width: CareCircleSpacingTokens.md),
          _buildLegendItem('Normal Range', CareCircleColorTokens.normalRange),
        ],
        SizedBox(width: CareCircleSpacingTokens.md),
        _buildLegendItem('Abnormal', CareCircleColorTokens.dangerRange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          label,
          style: CareCircleTypographyTokens.medicalNote,
        ),
      ],
    );
  }

  // Helper methods
  IconData _getMetricIcon() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return Icons.favorite;
      case HealthMetricType.bloodPressure:
        return Icons.monitor_heart;
      case HealthMetricType.weight:
        return Icons.scale;
      case HealthMetricType.steps:
        return Icons.directions_walk;
      case HealthMetricType.sleep:
        return Icons.bedtime;
      case HealthMetricType.bloodGlucose:
        return Icons.water_drop;
    }
  }

  Color _getMetricColor() {
    return CareCircleColorTokens.getVitalSignColor(_getMetricTypeString());
  }

  String _getMetricTypeString() {
    switch (metricType) {
      case HealthMetricType.heartRate:
        return 'heart_rate';
      case HealthMetricType.bloodPressure:
        return 'blood_pressure';
      case HealthMetricType.weight:
        return 'weight';
      case HealthMetricType.steps:
        return 'steps';
      case HealthMetricType.sleep:
        return 'sleep';
      case HealthMetricType.bloodGlucose:
        return 'blood_glucose';
    }
  }

  String _getTimeRangeText() {
    if (timeRange.inDays == 1) {
      return 'Last 24 hours';
    } else if (timeRange.inDays == 7) {
      return 'Last 7 days';
    } else if (timeRange.inDays == 30) {
      return 'Last 30 days';
    } else {
      return 'Last ${timeRange.inDays} days';
    }
  }

  int _getDecimalPlaces() {
    switch (metricType) {
      case HealthMetricType.weight:
      case HealthMetricType.bloodGlucose:
        return 1;
      case HealthMetricType.sleep:
        return 1;
      default:
        return 0;
    }
  }

  double _getMinX() {
    if (data.isEmpty) return 0;
    return data.first.timestamp.millisecondsSinceEpoch.toDouble();
  }

  double _getMaxX() {
    if (data.isEmpty) return 1;
    return data.last.timestamp.millisecondsSinceEpoch.toDouble();
  }

  double _getMinY() {
    if (data.isEmpty) return 0;
    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final padding = minValue * 0.1;
    return (minValue - padding).clamp(0, double.infinity);
  }

  double _getMaxY() {
    if (data.isEmpty) return 1;
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final padding = maxValue * 0.1;
    return maxValue + padding;
  }

  double _getHorizontalInterval() {
    final range = _getMaxY() - _getMinY();
    return range / 5;
  }

  double _getVerticalInterval() {
    final range = _getMaxX() - _getMinX();
    return range / 4;
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: CareCircleTypographyTokens.medicalNote,
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return Text(
              '${date.month}/${date.day}',
              style: CareCircleTypographyTokens.medicalNote,
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final index = spot.spotIndex;
            if (index < data.length) {
              final dataPoint = data[index];
              return LineTooltipItem(
                '${dataPoint.value.toStringAsFixed(_getDecimalPlaces())} ${metricType.unit}\n${_formatDate(dataPoint.timestamp)}',
                CareCircleTypographyTokens.medicalNote.copyWith(
                  color: Colors.white,
                ),
              );
            }
            return null;
          }).toList();
        },
      ),
      touchCallback: (event, response) {
        if (event is FlTapUpEvent && response?.lineBarSpots?.isNotEmpty == true) {
          final spot = response!.lineBarSpots!.first;
          final index = spot.spotIndex;
          if (index < data.length && onDataPointTap != null) {
            onDataPointTap!(data[index]);
          }
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
