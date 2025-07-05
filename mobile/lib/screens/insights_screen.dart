import 'package:flutter/material.dart';
import '../features/daily_check_in/daily_check_in.dart';
import '../common/common.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with TickerProviderStateMixin {
  late final DailyCheckInService _service;
  late TabController _tabController;

  bool _isLoading = false;
  WeeklyInsightsSummary? _weeklySummary;
  List<DailyCheckInHistory> _recentInsights = [];

  @override
  void initState() {
    super.initState();
    _service = DailyCheckInService(
      apiClient: ApiClient.instance,
      logger: AppLogger('InsightsScreen'),
    );
    _tabController = TabController(length: 2, vsync: this);
    _loadInsightsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInsightsData() async {
    setState(() {
      _isLoading = true;
    });

    final weeklyResult = await _service.getWeeklyInsights();
    final recentResult = await _service.getRecentCheckIns(limit: 10);

    if (mounted) {
      setState(() {
        weeklyResult.fold(
          (summary) => _weeklySummary = summary,
          (error) =>
              _showErrorSnackBar('Failed to load weekly insights: $error'),
        );

        recentResult.fold(
          (checkIns) => _recentInsights = checkIns
              .map((checkIn) => DailyCheckInHistory.fromDailyCheckIn(checkIn))
              .toList(),
          (error) =>
              _showErrorSnackBar('Failed to load recent insights: $error'),
        );

        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInsightsData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly Summary'),
            Tab(text: 'Daily Insights'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildWeeklySummaryTab(),
                _buildDailyInsightsTab(),
              ],
            ),
    );
  }

  Widget _buildWeeklySummaryTab() {
    if (_weeklySummary == null) {
      return _buildEmptyState(
        icon: Icons.insights,
        title: 'No weekly summary available',
        subtitle: 'Complete more daily check-ins to generate insights.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInsightsData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.summarize,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Weekly Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _weeklySummary!.summary ?? 'No summary available',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Key Insights
            if (_weeklySummary!.keyInsights.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Key Insights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._weeklySummary!.keyInsights
                          .map((insight) => _buildInsightCard(insight)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Trends
            if (_weeklySummary!.trends.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Trends',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._weeklySummary!.trends.map((trend) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  trend,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Recommendations
            if (_weeklySummary!.recommendations.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.recommend,
                            color: Colors.purple[600],
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._weeklySummary!.recommendations.map((recommendation) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Colors.purple[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  recommendation,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDailyInsightsTab() {
    if (_recentInsights.isEmpty) {
      return _buildEmptyState(
        icon: Icons.timeline,
        title: 'No daily insights available',
        subtitle: 'Complete daily check-ins to see personalized insights.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInsightsData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recentInsights.length,
        itemBuilder: (context, index) {
          final dailyInsight = _recentInsights[index];
          return _buildDailyInsightCard(dailyInsight);
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(CheckInInsight insight) {
    final severityColor = _service.getSeverityColor(insight.severity);
    final severityIcon = _service.getSeverityIcon(insight.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    severityIcon,
                    color: severityColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (insight.severity?.toString().toUpperCase()) ?? 'UNKNOWN',
                      style: TextStyle(
                        color: severityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                insight.description,
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 8),

              // Supporting data
              if (insight.supportingData != null &&
                  insight.supportingData!.isNotEmpty) ...[
                const Text(
                  'Supporting Data:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ...insight.supportingData!.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: Text(
                      '• ${entry.key}: ${entry.value}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confidence: ${((insight.confidence ?? 0.0) * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    insight.timeframe ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyInsightCard(DailyCheckInHistory dailyInsight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(dailyInsight.date),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${dailyInsight.insights.length} insights',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Insights
            if (dailyInsight.insights.isEmpty) ...[
              Text(
                'No insights available for this day.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ] else ...[
              ...dailyInsight.insights
                  .map((insight) => _buildCompactInsightCard(insight)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInsightCard(CheckInInsight insight) {
    final severityColor = _service.getSeverityColor(insight.severity);
    final severityIcon = _service.getSeverityIcon(insight.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: severityColor,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                severityIcon,
                color: severityColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            insight.description,
            style: const TextStyle(fontSize: 13),
          ),
          if (insight.relatedMetrics != null &&
              insight.relatedMetrics!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: insight.relatedMetrics!.entries
                  .map(
                    (entry) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
