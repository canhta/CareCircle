import 'package:flutter/material.dart';
import '../features/daily_check_in/daily_check_in.dart';
import '../common/common.dart';

class CheckInHistoryScreen extends StatefulWidget {
  const CheckInHistoryScreen({super.key});

  @override
  State<CheckInHistoryScreen> createState() => _CheckInHistoryScreenState();
}

class _CheckInHistoryScreenState extends State<CheckInHistoryScreen> {
  late final DailyCheckInService _service;

  bool _isLoading = false;
  List<DailyCheckIn> _checkIns = [];
  int _selectedFilter = 0; // 0: All, 1: Last 7 days, 2: Last 30 days

  @override
  void initState() {
    super.initState();
    _service = DailyCheckInService(
      apiClient: ApiClient.instance,
      logger: AppLogger('CheckInHistoryScreen'),
    );
    _loadCheckInHistory();
  }

  Future<void> _loadCheckInHistory() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _service.getRecentCheckIns(limit: 30);

    if (result.isSuccess) {
      if (mounted) {
        setState(() {
          _checkIns = result.data ?? [];
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar(
            'Failed to load check-in history: ${result.exception}');
      }
    }
  }

  List<DailyCheckIn> get _filteredCheckIns {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 1: // Last 7 days
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return _checkIns
            .where((checkIn) => checkIn.date.isAfter(sevenDaysAgo))
            .toList();
      case 2: // Last 30 days
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        return _checkIns
            .where((checkIn) => checkIn.date.isAfter(thirtyDaysAgo))
            .toList();
      default: // All
        return _checkIns;
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

  void _showCheckInDetails(DailyCheckIn checkIn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildCheckInDetailModal(checkIn),
    );
  }

  String _formatDate(DateTime date) {
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

  Color _getHealthScoreColor(double score) {
    if (score >= 7) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCheckInHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                _buildFilterTab('All', 0),
                _buildFilterTab('Last 7 days', 1),
                _buildFilterTab('Last 30 days', 2),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCheckIns.isEmpty
                    ? _buildEmptyState()
                    : _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _selectedFilter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No check-ins found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by completing your daily check-in.',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return RefreshIndicator(
      onRefresh: _loadCheckInHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredCheckIns.length,
        itemBuilder: (context, index) {
          final checkIn = _filteredCheckIns[index];
          return _buildCheckInCard(checkIn);
        },
      ),
    );
  }

  Widget _buildCheckInCard(DailyCheckIn checkIn) {
    final healthScore = _service.calculateHealthScore(checkIn);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showCheckInDetails(checkIn),
        borderRadius: BorderRadius.circular(12),
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
                    _formatDate(checkIn.date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getHealthScoreColor(healthScore)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${healthScore.toStringAsFixed(1)}/10',
                      style: TextStyle(
                        color: _getHealthScoreColor(healthScore),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Metrics row
              Row(
                children: [
                  if (checkIn.moodScore != null) ...[
                    _buildMetricChip('Mood', checkIn.moodScore!, Icons.mood),
                    const SizedBox(width: 8),
                  ],
                  if (checkIn.energyLevel != null) ...[
                    _buildMetricChip('Energy', checkIn.energyLevel!,
                        Icons.battery_charging_full),
                    const SizedBox(width: 8),
                  ],
                  if (checkIn.sleepQuality != null) ...[
                    _buildMetricChip(
                        'Sleep', checkIn.sleepQuality!, Icons.bedtime),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Symptoms and pain/stress
              Row(
                children: [
                  if (checkIn.painLevel != null && checkIn.painLevel! > 0) ...[
                    _buildMetricChip('Pain', checkIn.painLevel!, Icons.healing,
                        isInverted: true),
                    const SizedBox(width: 8),
                  ],
                  if (checkIn.stressLevel != null) ...[
                    _buildMetricChip(
                        'Stress', checkIn.stressLevel!, Icons.psychology,
                        isInverted: true),
                    const SizedBox(width: 8),
                  ],
                  if (checkIn.symptoms.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${checkIn.symptoms.length} symptoms',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Notes preview
              if (checkIn.notes != null && checkIn.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  checkIn.notes!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Completion status
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    checkIn.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 16,
                    color: checkIn.completed ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    checkIn.completed ? 'Completed' : 'Incomplete',
                    style: TextStyle(
                      fontSize: 12,
                      color: checkIn.completed ? Colors.green : Colors.grey,
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

  Widget _buildMetricChip(String label, int value, IconData icon,
      {bool isInverted = false}) {
    Color color;
    if (isInverted) {
      // For pain and stress, lower is better
      color = value <= 3
          ? Colors.green
          : value <= 6
              ? Colors.orange
              : Colors.red;
    } else {
      // For mood, energy, sleep, higher is better
      color = value >= 7
          ? Colors.green
          : value >= 5
              ? Colors.orange
              : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInDetailModal(DailyCheckIn checkIn) {
    final healthScore = _service.calculateHealthScore(checkIn);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(checkIn.date),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Health Score: ${healthScore.toStringAsFixed(1)}/10',
                            style: TextStyle(
                              fontSize: 16,
                              color: _getHealthScoreColor(healthScore),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Metrics
                      const Text(
                        'Health Metrics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (checkIn.moodScore != null)
                        _buildDetailMetric('Mood', checkIn.moodScore!, '😊'),
                      if (checkIn.energyLevel != null)
                        _buildDetailMetric(
                            'Energy Level', checkIn.energyLevel!, '⚡'),
                      if (checkIn.sleepQuality != null)
                        _buildDetailMetric(
                            'Sleep Quality', checkIn.sleepQuality!, '😴'),
                      if (checkIn.painLevel != null)
                        _buildDetailMetric(
                            'Pain Level', checkIn.painLevel!, '🩹'),
                      if (checkIn.stressLevel != null)
                        _buildDetailMetric(
                            'Stress Level', checkIn.stressLevel!, '😰'),

                      // Symptoms
                      if (checkIn.symptoms.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Symptoms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: checkIn.symptoms.map((symptom) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                symptom,
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      // Notes
                      if (checkIn.notes != null &&
                          checkIn.notes!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(checkIn.notes!),
                        ),
                      ],

                      // AI Insights
                      if (checkIn.aiInsights != null &&
                          checkIn.aiInsights!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'AI Insights',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(checkIn.aiInsights!),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Timestamps
                      _buildTimestamp('Completed', checkIn.completedAt),
                      _buildTimestamp('Created', checkIn.createdAt),
                      _buildTimestamp('Updated', checkIn.updatedAt),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailMetric(String label, int value, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Text(
            '$value/10',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(String label, DateTime? timestamp) {
    if (timestamp == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
