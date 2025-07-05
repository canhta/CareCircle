import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../features/health/health.dart';

class HealthLineChart extends StatefulWidget {
  final List<CareCircleHealthData> data;
  final String title;
  final String unit;
  final Color lineColor;
  final bool showDots;
  final double? minY;
  final double? maxY;
  final bool showGrid;
  final bool enableInteraction;

  const HealthLineChart({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    this.lineColor = Colors.blue,
    this.showDots = true,
    this.minY,
    this.maxY,
    this.showGrid = true,
    this.enableInteraction = true,
  });

  @override
  State<HealthLineChart> createState() => _HealthLineChartState();
}

class _HealthLineChartState extends State<HealthLineChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.data.isEmpty) {
      return Card(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No data available',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
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
            Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: widget.showGrid),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: _calculateBottomInterval(),
                        getTitlesWidget: (value, meta) {
                          return bottomTitleWidgets(value, meta);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: _calculateLeftInterval(),
                        getTitlesWidget: (value, meta) {
                          return leftTitleWidgets(value, meta);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: widget.data.length.toDouble() - 1,
                  minY: widget.minY ?? _calculateMinY(),
                  maxY: widget.maxY ?? _calculateMaxY(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _convertToFlSpots(),
                      isCurved: true,
                      color: widget.lineColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: widget.showDots,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: index == _touchedIndex ? 6 : 4,
                            color: widget.lineColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            widget.lineColor.withValues(alpha: 0.3),
                            widget.lineColor.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: widget.enableInteraction,
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (!event.isInterestedForInteractions ||
                          touchResponse == null ||
                          touchResponse.lineBarSpots == null) {
                        setState(() {
                          _touchedIndex = null;
                        });
                        return;
                      }

                      final touchedSpot = touchResponse.lineBarSpots!.first;
                      setState(() {
                        _touchedIndex = touchedSpot.spotIndex;
                      });
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          isDark ? Colors.grey[800]! : Colors.grey[100]!,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final dataPoint = widget.data[touchedSpot.spotIndex];
                          return LineTooltipItem(
                            '${dataPoint.value.toStringAsFixed(1)} ${widget.unit}\n'
                            '${_formatDate(dataPoint.timestamp)}',
                            TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total readings: ${widget.data.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Range: ${_formatDateRange()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _convertToFlSpots() {
    return widget.data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double _calculateMinY() {
    final values = widget.data.map((d) => d.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    return minValue - (minValue * 0.1); // Add 10% padding
  }

  double _calculateMaxY() {
    final values = widget.data.map((d) => d.value).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue + (maxValue * 0.1); // Add 10% padding
  }

  double _calculateBottomInterval() {
    return widget.data.length > 7 ? (widget.data.length / 7).ceilToDouble() : 1;
  }

  double _calculateLeftInterval() {
    final range = _calculateMaxY() - _calculateMinY();
    return range / 5; // Show 5 intervals
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

    final index = value.toInt();
    if (index >= 0 && index < widget.data.length) {
      final date = widget.data[index].timestamp;
      final text = _formatShortDate(date);

      return SideTitleWidget(
        meta: meta,
        child: Text(text, style: style),
      );
    }

    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

    return SideTitleWidget(
      meta: meta,
      child: Text(value.toStringAsFixed(0), style: style),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatShortDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}';
  }

  String _formatDateRange() {
    if (widget.data.isEmpty) return 'No data';

    final start = widget.data.first.timestamp;
    final end = widget.data.last.timestamp;

    return '${_formatShortDate(start)} - ${_formatShortDate(end)}';
  }
}
