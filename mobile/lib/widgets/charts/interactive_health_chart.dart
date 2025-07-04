import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';
import '../time_range_selector.dart';

class InteractiveHealthChart extends StatefulWidget {
  final List<CareCircleHealthData> data;
  final String title;
  final CareCircleHealthDataType dataType;
  final ChartType chartType;
  final TimeRange timeRange;
  final Function(TimeRange)? onTimeRangeChanged;

  const InteractiveHealthChart({
    super.key,
    required this.data,
    required this.title,
    required this.dataType,
    this.chartType = ChartType.line,
    this.timeRange = TimeRange.week,
    this.onTimeRangeChanged,
  });

  @override
  State<InteractiveHealthChart> createState() => _InteractiveHealthChartState();
}

enum ChartType { line, bar, area }

class _InteractiveHealthChartState extends State<InteractiveHealthChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int? _touchedIndex;
  double _zoomLevel = 1.0;
  double _panOffset = 0.0;
  bool _showFullData = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          _buildTimeRangeSelector(),
          _buildChart(),
          _buildChartControls(),
          _buildDataSummary(),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            _getIconForDataType(widget.dataType),
            size: 24,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PopupMenuButton<ChartType>(
            icon: const Icon(Icons.more_vert),
            onSelected: (type) {
              setState(() {
                // Chart type change would trigger rebuild
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ChartType.line,
                child: Row(
                  children: [
                    Icon(Icons.show_chart),
                    SizedBox(width: 8),
                    Text('Line Chart'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ChartType.bar,
                child: Row(
                  children: [
                    Icon(Icons.bar_chart),
                    SizedBox(width: 8),
                    Text('Bar Chart'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: ChartType.area,
                child: Row(
                  children: [
                    Icon(Icons.area_chart),
                    SizedBox(width: 8),
                    Text('Area Chart'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TimeRangeSelector(
        selectedRange: widget.timeRange,
        onRangeChanged: (range) {
          widget.onTimeRangeChanged?.call(range);
          setState(() {
            _zoomLevel = 1.0;
            _panOffset = 0.0;
          });
        },
      ),
    );
  }

  Widget _buildChart() {
    if (widget.data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No data available',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Data will appear here once synced',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 3.0);
                // Handle panning with scale gesture
                _panOffset += details.focalPointDelta.dx;
              });
            },
            child: _buildChartByType(),
          );
        },
      ),
    );
  }

  Widget _buildChartByType() {
    switch (widget.chartType) {
      case ChartType.line:
        return _buildLineChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.area:
        return _buildAreaChart();
    }
  }

  Widget _buildLineChart() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _calculateHorizontalInterval(),
          verticalInterval: _calculateVerticalInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
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
              reservedSize: 30,
              interval: _calculateBottomInterval(),
              getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: _calculateLeftInterval(),
              getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _getFilteredSpots(),
            isCurved: true,
            color: _getColorForDataType(widget.dataType),
            barWidth: 3,
            isStrokeCapRound: true,
            preventCurveOverShooting: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: index == _touchedIndex ? 6 : 4,
                  color: _getColorForDataType(widget.dataType),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _getColorForDataType(widget.dataType).withValues(alpha: 0.3),
                  _getColorForDataType(widget.dataType).withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (response?.lineBarSpots != null) {
              setState(() {
                _touchedIndex = response!.lineBarSpots!.first.spotIndex;
              });
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                isDark ? Colors.grey[800]! : Colors.grey[100]!,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final dataPoint = widget.data[spot.spotIndex];
                return LineTooltipItem(
                  '${dataPoint.value.toStringAsFixed(1)} ${dataPoint.unit}\n${_formatDate(dataPoint.timestamp)}',
                  TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        minX: 0,
        maxX: (widget.data.length - 1).toDouble(),
        minY: _calculateMinY(),
        maxY: _calculateMaxY(),
      ),
    );
  }

  Widget _buildBarChart() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BarChart(
      BarChartData(
        barGroups: _getBarGroups(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateHorizontalInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
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
              reservedSize: 30,
              getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: _calculateLeftInterval(),
              getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                isDark ? Colors.grey[800]! : Colors.grey[100]!,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final dataPoint = widget.data[groupIndex];
              return BarTooltipItem(
                '${dataPoint.value.toStringAsFixed(1)} ${dataPoint.unit}\n${_formatDate(dataPoint.timestamp)}',
                TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAreaChart() {
    return _buildLineChart(); // Area chart is a line chart with filled area
  }

  Widget _buildChartControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.zoom_in,
            onPressed: () {
              setState(() {
                _zoomLevel = (_zoomLevel * 1.2).clamp(0.5, 3.0);
              });
            },
            tooltip: 'Zoom In',
          ),
          _buildControlButton(
            icon: Icons.zoom_out,
            onPressed: () {
              setState(() {
                _zoomLevel = (_zoomLevel / 1.2).clamp(0.5, 3.0);
              });
            },
            tooltip: 'Zoom Out',
          ),
          _buildControlButton(
            icon: Icons.center_focus_strong,
            onPressed: () {
              setState(() {
                _zoomLevel = 1.0;
                _panOffset = 0.0;
              });
            },
            tooltip: 'Reset View',
          ),
          _buildControlButton(
            icon: _showFullData ? Icons.filter_alt : Icons.filter_alt_off,
            onPressed: () {
              setState(() {
                _showFullData = !_showFullData;
              });
            },
            tooltip: _showFullData ? 'Show Filtered' : 'Show All',
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildDataSummary() {
    if (widget.data.isEmpty) return const SizedBox.shrink();

    final values = widget.data.map((d) => d.value).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final max = values.reduce((a, b) => a > b ? a : b);
    final min = values.reduce((a, b) => a < b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Average', average.toStringAsFixed(1), Colors.blue),
          _buildSummaryItem('Max', max.toStringAsFixed(1), Colors.green),
          _buildSummaryItem('Min', min.toStringAsFixed(1), Colors.orange),
          _buildSummaryItem('Count', values.length.toString(), Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getFilteredSpots() {
    final data = _showFullData ? widget.data : _getFilteredData();
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  List<BarChartGroupData> _getBarGroups() {
    final data = _showFullData ? widget.data : _getFilteredData();
    return data.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            color: _getColorForDataType(widget.dataType),
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<CareCircleHealthData> _getFilteredData() {
    // Apply zoom and pan filtering
    final dataCount = widget.data.length;
    final visibleCount = (dataCount / _zoomLevel).round();
    final startIndex = ((_panOffset / 100) * dataCount).round().clamp(
      0,
      dataCount - visibleCount,
    );
    final endIndex = (startIndex + visibleCount).clamp(0, dataCount);

    return widget.data.sublist(startIndex, endIndex);
  }

  // Helper methods for calculations
  double _calculateMinY() {
    if (widget.data.isEmpty) return 0;
    final values = widget.data.map((d) => d.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    return minValue - (minValue * 0.1);
  }

  double _calculateMaxY() {
    if (widget.data.isEmpty) return 100;
    final values = widget.data.map((d) => d.value).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue + (maxValue * 0.1);
  }

  double _calculateHorizontalInterval() {
    final range = _calculateMaxY() - _calculateMinY();
    return range / 5;
  }

  double _calculateVerticalInterval() {
    return widget.data.length > 7 ? (widget.data.length / 7).ceilToDouble() : 1;
  }

  double _calculateBottomInterval() {
    return widget.data.length > 7 ? (widget.data.length / 7).ceilToDouble() : 1;
  }

  double _calculateLeftInterval() {
    final range = _calculateMaxY() - _calculateMinY();
    return range / 5;
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    final index = value.toInt();

    if (index >= 0 && index < widget.data.length) {
      final date = widget.data[index].timestamp;
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(_formatShortDate(date), style: style),
      );
    }

    return Container();
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value.toStringAsFixed(0), style: style),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatShortDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}';
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

  Color _getColorForDataType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return Colors.green;
      case CareCircleHealthDataType.heartRate:
        return Colors.red;
      case CareCircleHealthDataType.weight:
        return Colors.blue;
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        return Colors.purple;
      case CareCircleHealthDataType.bloodPressure:
        return Colors.red;
      case CareCircleHealthDataType.bloodGlucose:
        return Colors.orange;
      case CareCircleHealthDataType.bodyTemperature:
        return Colors.orange;
      case CareCircleHealthDataType.oxygenSaturation:
        return Colors.cyan;
      case CareCircleHealthDataType.activeEnergyBurned:
      case CareCircleHealthDataType.basalEnergyBurned:
        return Colors.deepOrange;
      case CareCircleHealthDataType.distanceWalkingRunning:
        return Colors.green;
      case CareCircleHealthDataType.height:
        return Colors.blue;
    }
  }
}
