import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../features/health/health.dart';

class HealthBarChart extends StatefulWidget {
  final List<CareCircleHealthData> data;
  final String title;
  final String unit;
  final Color barColor;
  final bool showValues;
  final bool showGrid;
  final bool enableInteraction;
  final BarChartGroupType groupType;

  const HealthBarChart({
    super.key,
    required this.data,
    required this.title,
    required this.unit,
    this.barColor = Colors.blue,
    this.showValues = true,
    this.showGrid = true,
    this.enableInteraction = true,
    this.groupType = BarChartGroupType.daily,
  });

  @override
  State<HealthBarChart> createState() => _HealthBarChartState();
}

enum BarChartGroupType { daily, weekly, monthly }

class _HealthBarChartState extends State<HealthBarChart> {
  int? _touchedIndex;
  late List<BarChartGroupData> _barGroups;
  late List<DateTime> _groupDates;
  late List<double> _groupValues;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  @override
  void didUpdateWidget(HealthBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.groupType != oldWidget.groupType) {
      _processData();
    }
  }

  void _processData() {
    final Map<DateTime, List<CareCircleHealthData>> groupedData = {};

    for (final dataPoint in widget.data) {
      final groupDate = _getGroupDate(dataPoint.timestamp);
      groupedData.putIfAbsent(groupDate, () => []).add(dataPoint);
    }

    _groupDates = groupedData.keys.toList()..sort();
    _groupValues = _groupDates.map((date) {
      final points = groupedData[date]!;
      switch (widget.groupType) {
        case BarChartGroupType.daily:
          return points.map((p) => p.value).reduce((a, b) => a + b);
        case BarChartGroupType.weekly:
          return points.map((p) => p.value).reduce((a, b) => a + b);
        case BarChartGroupType.monthly:
          return points.map((p) => p.value).reduce((a, b) => a + b) /
              points.length;
      }
    }).toList();

    _barGroups = _groupValues.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final isTouched = index == _touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: isTouched
                ? widget.barColor.withValues(alpha: 0.8)
                : widget.barColor,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxValue(),
              color: widget.barColor.withValues(alpha: 0.1),
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    }).toList();
  }

  DateTime _getGroupDate(DateTime timestamp) {
    switch (widget.groupType) {
      case BarChartGroupType.daily:
        return DateTime(timestamp.year, timestamp.month, timestamp.day);
      case BarChartGroupType.weekly:
        final weekday = timestamp.weekday;
        return timestamp.subtract(Duration(days: weekday - 1));
      case BarChartGroupType.monthly:
        return DateTime(timestamp.year, timestamp.month);
    }
  }

  double _getMaxValue() {
    if (_groupValues.isEmpty) return 0;
    return _groupValues.reduce((a, b) => a > b ? a : b) * 1.2;
  }

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
              Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getGroupTypeLabel(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(),
                  barTouchData: BarTouchData(
                    enabled: widget.enableInteraction,
                    touchCallback:
                        (FlTouchEvent event, BarTouchResponse? response) {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.spot == null) {
                        setState(() {
                          _touchedIndex = null;
                        });
                        return;
                      }

                      setState(() {
                        _touchedIndex = response.spot!.touchedBarGroupIndex;
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) =>
                          isDark ? Colors.grey[800]! : Colors.grey[100]!,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final date = _groupDates[groupIndex];
                        final value = _groupValues[groupIndex];
                        return BarTooltipItem(
                          '${_formatDateForTooltip(date)}\n'
                          '${value.toStringAsFixed(1)} ${widget.unit}',
                          TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
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
                        getTitlesWidget: (value, meta) {
                          return bottomTitleWidgets(value, meta);
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: _getMaxValue() / 5,
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
                  barGroups: _barGroups,
                  gridData: FlGridData(show: widget.showGrid),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ${_getGroupTypeLabel().toLowerCase()}: ${_barGroups.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Average: ${_calculateAverage().toStringAsFixed(1)} ${widget.unit}',
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

    final index = value.toInt();
    if (index >= 0 && index < _groupDates.length) {
      final date = _groupDates[index];
      final text = _formatDateForAxis(date);

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

  String _getGroupTypeLabel() {
    switch (widget.groupType) {
      case BarChartGroupType.daily:
        return 'Daily';
      case BarChartGroupType.weekly:
        return 'Weekly';
      case BarChartGroupType.monthly:
        return 'Monthly';
    }
  }

  String _formatDateForAxis(DateTime date) {
    switch (widget.groupType) {
      case BarChartGroupType.daily:
        return '${date.day}/${date.month}';
      case BarChartGroupType.weekly:
        return 'W${_getWeekOfYear(date)}';
      case BarChartGroupType.monthly:
        return '${date.month}/${date.year}';
    }
  }

  String _formatDateForTooltip(DateTime date) {
    switch (widget.groupType) {
      case BarChartGroupType.daily:
        return '${date.day}/${date.month}/${date.year}';
      case BarChartGroupType.weekly:
        return 'Week ${_getWeekOfYear(date)} of ${date.year}';
      case BarChartGroupType.monthly:
        return '${_getMonthName(date.month)} ${date.year}';
    }
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(firstDayOfYear).inDays;
    return (daysDifference / 7).ceil();
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  double _calculateAverage() {
    if (_groupValues.isEmpty) return 0;
    return _groupValues.reduce((a, b) => a + b) / _groupValues.length;
  }
}
