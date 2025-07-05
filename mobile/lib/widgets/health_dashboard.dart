import 'package:flutter/material.dart';
import '../features/health/health.dart';
import 'charts/health_line_chart.dart';
import 'charts/health_bar_chart.dart';
import 'charts/health_pie_chart.dart';
import 'charts/interactive_health_chart.dart';
import 'health_insights.dart';
import 'time_range_selector.dart' show TimeRange, TimeRangeSelector;
import 'health_analytics_widget.dart';
import 'widget_optimizer.dart';
import 'enhanced_error_boundary.dart';

class HealthDashboard extends StatefulWidget {
  final List<CareCircleHealthData> healthData;
  final String title;
  final TimeRange timeRange;
  final VoidCallback? onTimeRangeChanged;
  final VoidCallback? onRefresh;

  const HealthDashboard({
    super.key,
    required this.healthData,
    this.title = 'Health Dashboard',
    this.timeRange = TimeRange.week,
    this.onTimeRangeChanged,
    this.onRefresh,
  });

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TimeRange _selectedTimeRange = TimeRange.week;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedTimeRange = widget.timeRange;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading
                ? null
                : () {
                    setState(() => _isLoading = true);
                    widget.onRefresh?.call();
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) setState(() => _isLoading = false);
                    });
                  },
          ),
          PopupMenuButton<TimeRange>(
            icon: const Icon(Icons.date_range),
            onSelected: (TimeRange range) {
              setState(() => _selectedTimeRange = range);
              widget.onTimeRangeChanged?.call();
            },
            itemBuilder: (context) => TimeRange.values
                .map(
                  (range) => PopupMenuItem(
                    value: range,
                    child: Row(
                      children: [
                        Icon(
                          _selectedTimeRange == range
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(range.label),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.show_chart), text: 'Trends'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Activity'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Sleep'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTrendsTab(),
                _buildActivityTab(),
                _buildSleepTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    final filteredData = _getFilteredData();
    final summaryData = _calculateSummaryData(filteredData);

    return EnhancedErrorBoundary(
      contextName: 'Health Overview',
      child: WidgetOptimizer.optimizeListView(
        padding: const EdgeInsets.all(16),
        addRepaintBoundaries: true,
        children: [
          _buildSummaryCards(summaryData),
          const SizedBox(height: 16),
          HealthInsights(
            healthData: filteredData,
            timeRangeLabel: _selectedTimeRange.label,
          ),
          const SizedBox(height: 16),
          ChartErrorBoundary(
            chartType: 'Quick Stats',
            child: _buildQuickStatsChart(filteredData),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(filteredData),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    final filteredData = _getFilteredData();

    return EnhancedErrorBoundary(
      contextName: 'Health Trends',
      child: WidgetOptimizer.optimizeListView(
        padding: const EdgeInsets.all(16),
        addRepaintBoundaries: true,
        children: [
          // Time Range Selector
          TimeRangeSelector(
            selectedRange: _selectedTimeRange,
            onRangeChanged: (range) {
              setState(() => _selectedTimeRange = range);
              widget.onTimeRangeChanged?.call();
            },
          ),
          const SizedBox(height: 16),

          // Interactive Steps Chart
          ChartErrorBoundary(
            chartType: 'Steps Trend',
            child: InteractiveHealthChart(
              data: filteredData
                  .where((d) => d.type == CareCircleHealthDataType.steps)
                  .toList(),
              title: 'Steps Trend',
              dataType: CareCircleHealthDataType.steps,
              chartType: ChartType.line,
              timeRange: _selectedTimeRange,
            ),
          ),
          const SizedBox(height: 16),

          // Heart Rate Analytics
          if (filteredData.any(
            (d) => d.type == CareCircleHealthDataType.heartRate,
          )) ...[
            HealthAnalyticsWidget(
              healthData: filteredData
                  .where((d) => d.type == CareCircleHealthDataType.heartRate)
                  .toList(),
              dataType: CareCircleHealthDataType.heartRate,
              timeRange: _selectedTimeRange,
            ),
            const SizedBox(height: 16),
          ],

          // Weight Trend Line Chart
          if (filteredData.any(
            (d) => d.type == CareCircleHealthDataType.weight,
          )) ...[
            RepaintBoundary(
              child: InteractiveHealthChart(
                data: filteredData
                    .where((d) => d.type == CareCircleHealthDataType.weight)
                    .toList(),
                title: 'Weight Trend',
                dataType: CareCircleHealthDataType.weight,
                chartType: ChartType.line,
                timeRange: _selectedTimeRange,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Legacy charts for other data types
          ChartErrorBoundary(
            chartType: 'Blood Pressure',
            child: _buildLineChart(
              filteredData
                  .where(
                      (d) => d.type == CareCircleHealthDataType.bloodPressure)
                  .toList(),
              'Blood Pressure',
              'mmHg',
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final filteredData = _getFilteredData();
    final activityData = filteredData
        .where(
          (d) => [
            CareCircleHealthDataType.steps,
            CareCircleHealthDataType.activeEnergyBurned,
            CareCircleHealthDataType.distanceWalkingRunning,
          ].contains(d.type),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RepaintBoundary(
          child: HealthBarChart(
            data: activityData
                .where((d) => d.type == CareCircleHealthDataType.steps)
                .toList(),
            title: 'Daily Steps',
            unit: 'steps',
            barColor: Colors.green,
            groupType: BarChartGroupType.daily,
          ),
        ),
        const SizedBox(height: 16),
        HealthBarChart(
          data: activityData
              .where(
                (d) => d.type == CareCircleHealthDataType.activeEnergyBurned,
              )
              .toList(),
          title: 'Active Calories',
          unit: 'cal',
          barColor: Colors.orange,
          groupType: BarChartGroupType.daily,
        ),
        const SizedBox(height: 16),
        HealthPieChart(
          data: HealthPieChartHelper.createActivityDistributionData(
            activityData,
          ),
          title: 'Activity Distribution',
          showPercentages: true,
          showLegend: true,
        ),
      ],
    );
  }

  Widget _buildSleepTab() {
    final filteredData = _getFilteredData();
    final sleepData = filteredData
        .where(
          (d) => [
            CareCircleHealthDataType.sleepInBed,
            CareCircleHealthDataType.sleepAsleep,
          ].contains(d.type),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HealthPieChart(
          data: HealthPieChartHelper.createSleepPhaseData(sleepData),
          title: 'Sleep Phase Breakdown',
          showPercentages: true,
          showLegend: true,
        ),
        const SizedBox(height: 16),
        HealthLineChart(
          data: sleepData
              .where((d) => d.type == CareCircleHealthDataType.sleepInBed)
              .toList(),
          title: 'Sleep Duration Trend',
          unit: 'min',
          lineColor: Colors.indigo,
          showDots: true,
        ),
        const SizedBox(height: 16),
        _buildSleepInsights(sleepData),
      ],
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summaryData) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Steps Today',
            '${summaryData['steps']?.toStringAsFixed(0) ?? '0'}',
            Icons.directions_walk,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            'Heart Rate',
            '${summaryData['heartRate']?.toStringAsFixed(0) ?? '0'} bpm',
            Icons.favorite,
            Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            'Sleep',
            '${summaryData['sleep']?.toStringAsFixed(1) ?? '0'}h',
            Icons.bedtime,
            Colors.indigo,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsChart(List<CareCircleHealthData> data) {
    final stepsData =
        data.where((d) => d.type == CareCircleHealthDataType.steps).toList();

    if (stepsData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No activity data available'),
        ),
      );
    }

    return HealthLineChart(
      data: stepsData.take(7).toList(), // Last 7 data points
      title: 'Recent Activity',
      unit: 'steps',
      lineColor: Colors.green,
      showDots: true,
      showGrid: false,
    );
  }

  Widget _buildRecentActivity(List<CareCircleHealthData> data) {
    final recentData = data.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recentData.map(
              (data) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    _getIconForDataType(data.type),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDisplayNameForType(data.type),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${data.value.toStringAsFixed(1)} ${data.unit}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatTimestamp(data.timestamp),
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(
    List<CareCircleHealthData> data,
    String title,
    String unit,
    Color color,
  ) {
    return HealthLineChart(
      data: data,
      title: title,
      unit: unit,
      lineColor: color,
      showDots: true,
      enableInteraction: true,
    );
  }

  Widget _buildSleepInsights(List<CareCircleHealthData> sleepData) {
    if (sleepData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No sleep data available'),
        ),
      );
    }

    final avgSleep = sleepData
            .where((d) => d.type == CareCircleHealthDataType.sleepInBed)
            .map((d) => d.value)
            .fold(0.0, (a, b) => a + b) /
        sleepData.length;

    final sleepQuality = avgSleep >= 480
        ? 'Good'
        : avgSleep >= 360
            ? 'Fair'
            : 'Poor';
    final sleepColor = avgSleep >= 480
        ? Colors.green
        : avgSleep >= 360
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: sleepColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Sleep Quality: $sleepQuality'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Average sleep duration: ${(avgSleep / 60).toStringAsFixed(1)} hours',
            ),
            const SizedBox(height: 8),
            Text(
              _getSleepRecommendation(avgSleep),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  List<CareCircleHealthData> _getFilteredData() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedTimeRange.days));

    return widget.healthData
        .where((data) => data.timestamp.isAfter(startDate))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Map<String, dynamic> _calculateSummaryData(List<CareCircleHealthData> data) {
    final today = DateTime.now();
    final todayData = data
        .where(
          (d) =>
              d.timestamp.year == today.year &&
              d.timestamp.month == today.month &&
              d.timestamp.day == today.day,
        )
        .toList();

    double steps = 0;
    double heartRate = 0;
    double sleep = 0;

    for (final dataPoint in todayData) {
      switch (dataPoint.type) {
        case CareCircleHealthDataType.steps:
          steps += dataPoint.value;
          break;
        case CareCircleHealthDataType.heartRate:
          heartRate = dataPoint.value; // Use latest reading
          break;
        case CareCircleHealthDataType.sleepInBed:
          sleep = dataPoint.value / 60; // Convert to hours
          break;
        default:
          break;
      }
    }

    return {'steps': steps, 'heartRate': heartRate, 'sleep': sleep};
  }

  Widget _getIconForDataType(CareCircleHealthDataType type) {
    IconData iconData;
    Color color;

    switch (type) {
      case CareCircleHealthDataType.steps:
        iconData = Icons.directions_walk;
        color = Colors.green;
        break;
      case CareCircleHealthDataType.heartRate:
        iconData = Icons.favorite;
        color = Colors.red;
        break;
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        iconData = Icons.bedtime;
        color = Colors.indigo;
        break;
      case CareCircleHealthDataType.weight:
        iconData = Icons.monitor_weight;
        color = Colors.blue;
        break;
      case CareCircleHealthDataType.activeEnergyBurned:
        iconData = Icons.local_fire_department;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.health_and_safety;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 20);
  }

  String _getDisplayNameForType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'Steps';
      case CareCircleHealthDataType.heartRate:
        return 'Heart Rate';
      case CareCircleHealthDataType.sleepInBed:
        return 'Sleep Duration';
      case CareCircleHealthDataType.sleepAsleep:
        return 'Deep Sleep';
      case CareCircleHealthDataType.weight:
        return 'Weight';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'Active Calories';
      case CareCircleHealthDataType.distanceWalkingRunning:
        return 'Distance';
      default:
        return type.name;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getSleepRecommendation(double avgSleepMinutes) {
    if (avgSleepMinutes >= 480) {
      return 'Great job! You\'re getting enough sleep.';
    } else if (avgSleepMinutes >= 360) {
      return 'Try to get a bit more sleep for optimal health.';
    } else {
      return 'Consider improving your sleep schedule for better health.';
    }
  }
}
