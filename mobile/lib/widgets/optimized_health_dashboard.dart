import 'package:flutter/material.dart';
import '../features/health/health.dart';
import '../services/lazy_health_data_service.dart';
import '../common/common.dart';
import 'lazy_health_data_list.dart';
import 'performance_optimized_widget.dart';
import 'time_range_selector.dart';
import 'charts/health_line_chart.dart';
import 'charts/interactive_health_chart.dart';

/// Optimized health dashboard with lazy loading and performance optimizations
class OptimizedHealthDashboard extends StatefulWidget {
  final List<CareCircleHealthData> initialData;
  final Function()? onTimeRangeChanged;

  const OptimizedHealthDashboard({
    super.key,
    required this.initialData,
    this.onTimeRangeChanged,
  });

  @override
  State<OptimizedHealthDashboard> createState() =>
      _OptimizedHealthDashboardState();
}

class _OptimizedHealthDashboardState extends State<OptimizedHealthDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late LazyHealthDataService _lazyDataService;
  TimeRange _selectedTimeRange = TimeRange.week;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _lazyDataService = LazyHealthDataService(
      HealthService(
        apiClient: ApiClient.instance,
        logger: AppLogger('OptimizedHealthDashboard'),
        secureStorage: SecureStorageService(),
      ),
    );
    _initializeService();
  }

  Future<void> _initializeService() async {
    // Preload data for better performance
    await _lazyDataService.preloadData(
      startDate: _getStartDateForRange(_selectedTimeRange),
      endDate: DateTime.now(),
    );

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  DateTime _getStartDateForRange(TimeRange range) {
    final now = DateTime.now();
    switch (range) {
      case TimeRange.day:
        return now.subtract(const Duration(days: 1));
      case TimeRange.week:
        return now.subtract(const Duration(days: 7));
      case TimeRange.month:
        return now.subtract(const Duration(days: 30));
      case TimeRange.threeMonths:
        return now.subtract(const Duration(days: 90));
      case TimeRange.sixMonths:
        return now.subtract(const Duration(days: 180));
      case TimeRange.year:
        return now.subtract(const Duration(days: 365));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Trends', icon: Icon(Icons.trending_up)),
            Tab(text: 'Activity', icon: Icon(Icons.directions_run)),
            Tab(text: 'Sleep', icon: Icon(Icons.bedtime)),
          ],
        ),
      ),
      body: TabBarView(
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
    return PerformanceOptimizedWidget(
      debugLabel: 'OverviewTab',
      child: CustomScrollView(
        slivers: [
          // Summary Cards
          SliverToBoxAdapter(
            child: _buildSummarySection(),
          ),

          // Recent Activity Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LazyHealthChart(
                title: 'Recent Activity',
                startDate: _getStartDateForRange(TimeRange.week),
                endDate: DateTime.now(),
                onLoadData: (start, end) => _lazyDataService.loadChartData(
                  startDate: start,
                  endDate: end,
                  types: [CareCircleHealthDataType.steps],
                ),
                chartBuilder: (data) => HealthLineChart(
                  data: data,
                  title: 'Steps (Last 7 Days)',
                  unit: 'steps',
                  lineColor: Colors.green,
                  showDots: true,
                ),
              ),
            ),
          ),

          // Recent Health Data List
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LazyHealthDataList(
                onLoadData: (page, pageSize) => _lazyDataService.loadHealthData(
                  page: page,
                  pageSize: pageSize,
                  startDate: _getStartDateForRange(TimeRange.month),
                  endDate: DateTime.now(),
                ),
                itemBuilder: (context, data, index) =>
                    _buildHealthDataItem(data),
                pageSize: 15,
                padding: const EdgeInsets.only(bottom: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return PerformanceOptimizedWidget(
      debugLabel: 'TrendsTab',
      child: CustomScrollView(
        slivers: [
          // Time Range Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TimeRangeSelector(
                selectedRange: _selectedTimeRange,
                onRangeChanged: (range) {
                  setState(() => _selectedTimeRange = range);
                  widget.onTimeRangeChanged?.call();
                  _lazyDataService.clearCachePattern('chart_data');
                },
              ),
            ),
          ),

          // Steps Trend Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LazyHealthChart(
                title: 'Steps Trend',
                startDate: _getStartDateForRange(_selectedTimeRange),
                endDate: DateTime.now(),
                onLoadData: (start, end) => _lazyDataService.loadChartData(
                  startDate: start,
                  endDate: end,
                  types: [CareCircleHealthDataType.steps],
                ),
                chartBuilder: (data) => InteractiveHealthChart(
                  data: data,
                  title: 'Steps Trend',
                  dataType: CareCircleHealthDataType.steps,
                  chartType: ChartType.line,
                  timeRange: _selectedTimeRange,
                ),
              ),
            ),
          ),

          // Heart Rate Trend Chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LazyHealthChart(
                title: 'Heart Rate Trend',
                startDate: _getStartDateForRange(_selectedTimeRange),
                endDate: DateTime.now(),
                onLoadData: (start, end) => _lazyDataService.loadChartData(
                  startDate: start,
                  endDate: end,
                  types: [CareCircleHealthDataType.heartRate],
                ),
                chartBuilder: (data) => HealthLineChart(
                  data: data,
                  title: 'Heart Rate Trend',
                  unit: 'bpm',
                  lineColor: Colors.red,
                  showDots: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return PerformanceOptimizedWidget(
      debugLabel: 'ActivityTab',
      child: LazyHealthDataList(
        onLoadData: (page, pageSize) => _lazyDataService.loadHealthData(
          page: page,
          pageSize: pageSize,
          types: [
            CareCircleHealthDataType.steps,
            CareCircleHealthDataType.activeEnergyBurned,
            CareCircleHealthDataType.distanceWalkingRunning,
          ],
          startDate: _getStartDateForRange(_selectedTimeRange),
          endDate: DateTime.now(),
        ),
        itemBuilder: (context, data, index) => _buildActivityItem(data),
        pageSize: 20,
        padding: const EdgeInsets.all(16),
        emptyWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_run, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No activity data available'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepTab() {
    return PerformanceOptimizedWidget(
      debugLabel: 'SleepTab',
      child: LazyHealthDataList(
        onLoadData: (page, pageSize) => _lazyDataService.loadHealthData(
          page: page,
          pageSize: pageSize,
          types: [
            CareCircleHealthDataType.sleepInBed,
            CareCircleHealthDataType.sleepAsleep,
          ],
          startDate: _getStartDateForRange(_selectedTimeRange),
          endDate: DateTime.now(),
        ),
        itemBuilder: (context, data, index) => _buildSleepItem(data),
        pageSize: 20,
        padding: const EdgeInsets.all(16),
        emptyWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bedtime, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No sleep data available'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return FutureBuilder<Map<CareCircleHealthDataType, double>>(
      future: _lazyDataService.loadSummaryData(
        startDate: _getStartDateForRange(_selectedTimeRange),
        endDate: DateTime.now(),
        types: [
          CareCircleHealthDataType.steps,
          CareCircleHealthDataType.heartRate,
          CareCircleHealthDataType.activeEnergyBurned,
        ],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading summary: ${snapshot.error}'),
              ),
            ),
          );
        }

        final summaryData = snapshot.data ?? {};
        return _buildSummaryCards(summaryData);
      },
    );
  }

  Widget _buildSummaryCards(Map<CareCircleHealthDataType, double> summaryData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Steps',
              summaryData[CareCircleHealthDataType.steps]?.toInt().toString() ??
                  '0',
              Icons.directions_walk,
              Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'Heart Rate',
              '${summaryData[CareCircleHealthDataType.heartRate]?.toInt() ?? 0} bpm',
              Icons.favorite,
              Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              'Calories',
              summaryData[CareCircleHealthDataType.activeEnergyBurned]
                      ?.toInt()
                      .toString() ??
                  '0',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDataItem(CareCircleHealthData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(_getIconForDataType(data.type)),
        title: Text('${data.value} ${_getUnitForDataType(data.type)}'),
        subtitle: Text(_formatDateTime(data.timestamp)),
        trailing: Text(data.type.name),
      ),
    );
  }

  Widget _buildActivityItem(CareCircleHealthData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          child: Icon(Icons.directions_run, color: Colors.green),
        ),
        title: Text('${data.value.toInt()} ${_getUnitForDataType(data.type)}'),
        subtitle: Text(_formatDateTime(data.timestamp)),
        trailing: Chip(
          label: Text(data.type.name),
          backgroundColor: Colors.green.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildSleepItem(CareCircleHealthData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.withValues(alpha: 0.1),
          child: Icon(Icons.bedtime, color: Colors.indigo),
        ),
        title: Text('${(data.value / 60).toStringAsFixed(1)} hours'),
        subtitle: Text(_formatDateTime(data.timestamp)),
        trailing: Chip(
          label: Text(data.type.name),
          backgroundColor: Colors.indigo.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  IconData _getIconForDataType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return Icons.directions_walk;
      case CareCircleHealthDataType.heartRate:
        return Icons.favorite;
      case CareCircleHealthDataType.activeEnergyBurned:
        return Icons.local_fire_department;
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        return Icons.bedtime;
      default:
        return Icons.health_and_safety;
    }
  }

  String _getUnitForDataType(CareCircleHealthDataType type) {
    switch (type) {
      case CareCircleHealthDataType.steps:
        return 'steps';
      case CareCircleHealthDataType.heartRate:
        return 'bpm';
      case CareCircleHealthDataType.activeEnergyBurned:
        return 'cal';
      case CareCircleHealthDataType.sleepInBed:
      case CareCircleHealthDataType.sleepAsleep:
        return 'min';
      default:
        return '';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
