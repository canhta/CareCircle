import 'package:flutter/material.dart';
import '../features/daily_check_in/daily_check_in.dart';
import '../common/common.dart';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  late final DailyCheckInService _dailyCheckInService;
  late final AppLogger _logger;

  DailyCheckIn? _todayCheckIn;
  List<DailyCheckIn> _recentCheckIns = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('HealthCheckScreen');
    _dailyCheckInService = DailyCheckInService(
      apiClient: ApiClient.instance,
      logger: _logger,
    );
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load today's check-in
      final todayResult = await _dailyCheckInService.getTodayCheckIn();

      // Load recent check-ins
      final recentResult = await _dailyCheckInService.getRecentCheckIns();

      setState(() {
        _todayCheckIn = todayResult.fold(
          (checkIn) => checkIn,
          (error) => null,
        );

        _recentCheckIns = recentResult.fold(
          (checkIns) => checkIns,
          (error) => [],
        );

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _startDailyCheckIn() async {
    final result = await Navigator.pushNamed(
      context,
      '/daily-check-in',
    );

    if (result == true) {
      _loadHealthData();
    }
  }

  Future<void> _viewHealthDashboard() async {
    Navigator.pushNamed(context, '/health-dashboard');
  }

  Future<void> _viewInsights() async {
    Navigator.pushNamed(context, '/insights');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Check'),
        actions: [
          IconButton(
            onPressed: _loadHealthData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading health data',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHealthData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodayCheckInCard(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildRecentCheckIns(),
          const SizedBox(height: 16),
          _buildHealthOverview(),
        ],
      ),
    );
  }

  Widget _buildTodayCheckInCard() {
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
                  'Today\'s Check-In',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (_todayCheckIn != null)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_todayCheckIn != null) ...[
              _buildCheckInSummary(_todayCheckIn!),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _startDailyCheckIn,
                    child: const Text('Update Check-In'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _viewInsights,
                    child: const Text('View Insights'),
                  ),
                ],
              ),
            ] else ...[
              const Text(
                'You haven\'t completed your check-in today.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _startDailyCheckIn,
                icon: const Icon(Icons.add_task),
                label: const Text('Start Check-In'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInSummary(DailyCheckIn checkIn) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricCard(
              'Mood',
              '${checkIn.moodScore?.toInt() ?? 0}/10',
              Icons.mood,
              Colors.blue,
            ),
            _buildMetricCard(
              'Energy',
              '${checkIn.energyLevel?.toInt() ?? 0}/10',
              Icons.battery_charging_full,
              Colors.green,
            ),
            _buildMetricCard(
              'Sleep',
              '${checkIn.sleepQuality?.toInt() ?? 0}/10',
              Icons.bedtime,
              Colors.purple,
            ),
          ],
        ),
        if (checkIn.symptoms.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Symptoms: ${checkIn.symptoms.join(', ')}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildMetricCard(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  'Check-In',
                  Icons.add_task,
                  Colors.blue,
                  _startDailyCheckIn,
                ),
                _buildActionButton(
                  'Dashboard',
                  Icons.dashboard,
                  Colors.green,
                  _viewHealthDashboard,
                ),
                _buildActionButton(
                  'Insights',
                  Icons.insights,
                  Colors.orange,
                  _viewInsights,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentCheckIns() {
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
                  'Recent Check-Ins',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/check-in-history'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_recentCheckIns.isEmpty) ...[
              const Text('No recent check-ins available.'),
            ] else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentCheckIns.length.clamp(0, 3),
                itemBuilder: (context, index) {
                  final checkIn = _recentCheckIns[index];
                  return _buildCheckInListItem(checkIn);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInListItem(DailyCheckIn checkIn) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getHealthScoreColor(checkIn.moodScore?.toInt() ?? 0),
        child: Text(
          '${checkIn.moodScore?.toInt() ?? 0}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        checkIn.createdAt.toString().split(' ')[0],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Mood: ${checkIn.moodScore?.toInt() ?? 0}/10, Energy: ${checkIn.energyLevel?.toInt() ?? 0}/10',
      ),
      trailing: Icon(
        checkIn.symptoms.isNotEmpty ? Icons.warning : Icons.check_circle,
        color: checkIn.symptoms.isNotEmpty ? Colors.orange : Colors.green,
      ),
    );
  }

  Widget _buildHealthOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Overview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewStat(
                  'Check-ins',
                  '${_recentCheckIns.length}',
                  'This week',
                ),
                _buildOverviewStat(
                  'Avg Mood',
                  _calculateAverageMood(),
                  'Last 7 days',
                ),
                _buildOverviewStat(
                  'Trend',
                  _getTrendDirection(),
                  'This week',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getHealthScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    return Colors.red;
  }

  String _calculateAverageMood() {
    if (_recentCheckIns.isEmpty) return '0';

    final total = _recentCheckIns
        .map((c) => c.moodScore?.toInt() ?? 0)
        .fold(0, (a, b) => a + b);

    final average = total / _recentCheckIns.length;
    return average.toStringAsFixed(1);
  }

  String _getTrendDirection() {
    if (_recentCheckIns.length < 2) return '—';

    final recent =
        _recentCheckIns.take(3).map((c) => c.moodScore?.toInt() ?? 0).toList();
    final older = _recentCheckIns
        .skip(3)
        .take(3)
        .map((c) => c.moodScore?.toInt() ?? 0)
        .toList();

    if (recent.isEmpty || older.isEmpty) return '—';

    final recentAvg = recent.fold(0, (a, b) => a + b) / recent.length;
    final olderAvg = older.fold(0, (a, b) => a + b) / older.length;

    if (recentAvg > olderAvg) return '↗️';
    if (recentAvg < olderAvg) return '↘️';
    return '→';
  }
}
