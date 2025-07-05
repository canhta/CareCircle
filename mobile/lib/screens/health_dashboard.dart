import 'package:flutter/material.dart';
import '../features/health/health.dart';
import '../widgets/charts/interactive_health_chart.dart';
import '../widgets/health_analytics_widget.dart';
import '../widgets/time_range_selector.dart';
import 'privacy_settings_screen.dart';

class HealthDashboard extends StatefulWidget {
  final List<CareCircleHealthData> healthData;

  const HealthDashboard({super.key, required this.healthData});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TimeRange _selectedTimeRange = TimeRange.week;
  CareCircleHealthDataType? _selectedDataType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (widget.healthData.isNotEmpty) {
      _selectedDataType = widget.healthData.first.type;
    }
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
        title: const Text('Health Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _onRefresh,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.show_chart), text: 'Charts'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.insights), text: 'Insights'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildChartsTab(),
                _buildAnalyticsTab(),
                _buildInsightsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    if (widget.healthData.isEmpty) {
      return _buildEmptyState();
    }

    final groupedData = _groupDataByType(widget.healthData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Range Selector
          TimeRangeSelector(
            selectedRange: _selectedTimeRange,
            onRangeChanged: (range) {
              setState(() {
                _selectedTimeRange = range;
              });
            },
          ),
          const SizedBox(height: 24),

          // Quick Stats Cards
          _buildQuickStatsGrid(groupedData),
          const SizedBox(height: 24),

          // Recent Activity
          _buildRecentActivity(),
          const SizedBox(height: 24),

          // Data Type Selection
          _buildDataTypeSelector(groupedData.keys.toList()),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    if (widget.healthData.isEmpty || _selectedDataType == null) {
      return _buildEmptyState();
    }

    final filteredData = _getFilteredDataForType(_selectedDataType!);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Interactive Chart
          InteractiveHealthChart(
            data: filteredData,
            title: _getDisplayNameForType(_selectedDataType!),
            dataType: _selectedDataType!,
            timeRange: _selectedTimeRange,
            onTimeRangeChanged: (range) {
              setState(() {
                _selectedTimeRange = range;
              });
            },
          ),

          // Chart Type Variants
          _buildChartVariants(filteredData),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    if (widget.healthData.isEmpty || _selectedDataType == null) {
      return _buildEmptyState();
    }

    final filteredData = _getFilteredDataForType(_selectedDataType!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Data Type Selector
          _buildDataTypeSelector(
            _groupDataByType(widget.healthData).keys.toList(),
          ),
          const SizedBox(height: 16),

          // Analytics Widget
          HealthAnalyticsWidget(
            healthData: filteredData,
            dataType: _selectedDataType!,
            timeRange: _selectedTimeRange,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    if (widget.healthData.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Insights',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Generate insights for each data type
          ..._generateAllInsights(),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid(
    Map<CareCircleHealthDataType, List<CareCircleHealthData>> groupedData,
  ) {
    final stats = groupedData.entries.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final entry = stats[index];
        final type = entry.key;
        final data = entry.value;
        final latestValue = data.last.value;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIconForDataType(type),
                      color: _getColorForDataType(type),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getDisplayNameForType(type),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${latestValue.toStringAsFixed(1)} ${data.last.unit}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.length} readings',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    final recentData = widget.healthData.take(5).toList();

    return Card(
      elevation: 2,
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
                    Icon(
                      _getIconForDataType(data.type),
                      size: 20,
                      color: _getColorForDataType(data.type),
                    ),
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
                      _formatTimeAgo(data.timestamp),
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

  Widget _buildDataTypeSelector(List<CareCircleHealthDataType> availableTypes) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Data Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTypes.map((type) {
                final isSelected = _selectedDataType == type;
                return FilterChip(
                  label: Text(_getDisplayNameForType(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDataType = selected ? type : null;
                    });
                  },
                  avatar: Icon(_getIconForDataType(type), size: 18),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartVariants(List<CareCircleHealthData> data) {
    return Column(
      children: [
        // Line Chart
        InteractiveHealthChart(
          data: data,
          title: '${_getDisplayNameForType(_selectedDataType!)} - Line Chart',
          dataType: _selectedDataType!,
          chartType: ChartType.line,
          timeRange: _selectedTimeRange,
        ),

        // Bar Chart
        InteractiveHealthChart(
          data: data,
          title: '${_getDisplayNameForType(_selectedDataType!)} - Bar Chart',
          dataType: _selectedDataType!,
          chartType: ChartType.bar,
          timeRange: _selectedTimeRange,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Health Data Available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Start syncing your health data to see visualizations',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _generateAllInsights() {
    final groupedData = _groupDataByType(widget.healthData);
    final insights = <Widget>[];

    for (final entry in groupedData.entries) {
      insights.add(
        HealthAnalyticsWidget(
          healthData: entry.value,
          dataType: entry.key,
          timeRange: _selectedTimeRange,
        ),
      );
      insights.add(const SizedBox(height: 16));
    }

    return insights;
  }

  // Helper methods
  Map<CareCircleHealthDataType, List<CareCircleHealthData>> _groupDataByType(
    List<CareCircleHealthData> data,
  ) {
    final Map<CareCircleHealthDataType, List<CareCircleHealthData>> grouped =
        {};

    for (final point in data) {
      grouped.putIfAbsent(point.type, () => []).add(point);
    }

    return grouped;
  }

  List<CareCircleHealthData> _getFilteredDataForType(
    CareCircleHealthDataType type,
  ) {
    return widget.healthData
        .where((data) => data.type == type)
        .where((data) => _isWithinTimeRange(data.timestamp))
        .toList();
  }

  bool _isWithinTimeRange(DateTime timestamp) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedTimeRange.days));
    return timestamp.isAfter(startDate);
  }

  void _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dashboard Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage data sharing preferences'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacySettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Data'),
              subtitle: const Text('Download your health data'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement data export
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
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
