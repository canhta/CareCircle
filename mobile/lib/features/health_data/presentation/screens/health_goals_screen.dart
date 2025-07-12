import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/health_metric_type.dart';
import '../../domain/models/health_profile.dart';
import '../../application/providers/health_data_providers.dart';
import '../widgets/goal_card.dart';
import '../widgets/achievement_badge.dart';

/// Screen for managing health goals and tracking progress
///
/// Provides interface for creating, editing, and tracking health goals
/// with motivational elements and progress visualization using
/// healthcare-compliant privacy protection.
class HealthGoalsScreen extends ConsumerStatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  ConsumerState<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends ConsumerState<HealthGoalsScreen> {
  static final _logger = BoundedContextLoggers.healthData;

  @override
  void initState() {
    super.initState();
    _logger.info('Health goals screen initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Goals'),
        backgroundColor: CareCircleDesignTokens.healthGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGoalDialog(),
            tooltip: 'Create New Goal',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGoals,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress overview
              _buildProgressOverview(),

              const SizedBox(height: 24),

              // Active goals
              _buildActiveGoalsSection(),

              const SizedBox(height: 24),

              // Recent achievements
              _buildAchievementsSection(),

              const SizedBox(height: 24),

              // Goal suggestions
              _buildGoalSuggestionsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoalDialog(),
        backgroundColor: CareCircleDesignTokens.healthGreen,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.track_changes,
                  color: CareCircleDesignTokens.healthGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Progress Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.healthGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressStat(
                    'Active Goals',
                    '3',
                    CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
                Expanded(
                  child: _buildProgressStat(
                    'Completed',
                    '12',
                    CareCircleDesignTokens.healthGreen,
                  ),
                ),
                Expanded(
                  child: _buildProgressStat(
                    'This Week',
                    '85%',
                    Colors.orange[600]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActiveGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Goals',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _showAllGoals(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActiveGoalsList(),
      ],
    );
  }

  Widget _buildActiveGoalsList() {
    // Use actual health goals from provider when available
    final healthProfileAsync = ref.watch(healthProfileProvider);

    return healthProfileAsync.when(
      data: (healthProfile) {
        final activeGoals = healthProfile?.healthGoals
            .where((goal) => goal.status == 'active')
            .toList() ?? [];

        if (activeGoals.isEmpty) {
          return _buildEmptyGoalsState();
        }

        return Column(
          children: activeGoals
              .map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HealthGoalCard(
                    goal: goal,
                    onTap: () => _showHealthGoalDetails(goal),
                    onEdit: () => _editHealthGoal(goal),
                  ),
                ),
              )
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        _logger.error('Failed to load health goals', {
          'error': error.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });

        // Fallback to placeholder data
        final placeholderGoals = _getPlaceholderGoals();
        if (placeholderGoals.isEmpty) {
          return _buildEmptyGoalsState();
        }

        return Column(
          children: placeholderGoals
              .map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GoalCard(
                    goal: goal,
                    onTap: () => _showGoalDetails(goal),
                    onEdit: () => _editGoal(goal),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildEmptyGoalsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Active Goals',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your first health goal to start tracking your progress',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateGoalDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Create First Goal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.healthGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        _buildAchievementsList(),
      ],
    );
  }

  Widget _buildAchievementsList() {
    // TODO: Replace with actual achievements data
    final placeholderAchievements = _getPlaceholderAchievements();

    if (placeholderAchievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No achievements yet',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete goals to earn achievements',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: placeholderAchievements.length,
        itemBuilder: (context, index) {
          final achievement = placeholderAchievements[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < placeholderAchievements.length - 1 ? 12 : 0,
            ),
            child: AchievementBadge(
              achievement: achievement,
              onTap: () => _showAchievementDetails(achievement),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Goals',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalSuggestionsList(),
      ],
    );
  }

  Widget _buildGoalSuggestionsList() {
    final suggestions = _getGoalSuggestions();

    return Column(
      children: suggestions
          .map(
            (suggestion) => Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Icon(
                  suggestion['icon'] as IconData,
                  color: suggestion['color'] as Color,
                ),
                title: Text(suggestion['title'] as String),
                subtitle: Text(suggestion['description'] as String),
                trailing: TextButton(
                  onPressed: () => _createSuggestedGoal(suggestion),
                  child: const Text('Add'),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<PlaceholderGoal> _getPlaceholderGoals() {
    return [
      PlaceholderGoal(
        id: '1',
        title: 'Daily Steps',
        description: 'Walk 10,000 steps every day',
        metricType: HealthMetricType.steps,
        targetValue: 10000,
        currentValue: 7500,
        unit: 'steps',
        deadline: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
      ),
      PlaceholderGoal(
        id: '2',
        title: 'Weight Loss',
        description: 'Lose 5 pounds in 2 months',
        metricType: HealthMetricType.weight,
        targetValue: 165,
        currentValue: 170,
        unit: 'lbs',
        deadline: DateTime.now().add(const Duration(days: 60)),
        isActive: true,
      ),
      PlaceholderGoal(
        id: '3',
        title: 'Heart Rate Zone',
        description: 'Maintain resting heart rate below 70 bpm',
        metricType: HealthMetricType.heartRate,
        targetValue: 70,
        currentValue: 72,
        unit: 'bpm',
        deadline: DateTime.now().add(const Duration(days: 45)),
        isActive: true,
      ),
    ];
  }

  List<PlaceholderAchievement> _getPlaceholderAchievements() {
    return [
      PlaceholderAchievement(
        id: '1',
        title: 'First Goal',
        description: 'Completed your first health goal',
        icon: Icons.flag,
        color: Colors.blue[600]!,
        earnedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PlaceholderAchievement(
        id: '2',
        title: 'Step Master',
        description: 'Reached 10,000 steps for 7 days straight',
        icon: Icons.directions_walk,
        color: Colors.green[600]!,
        earnedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  List<Map<String, dynamic>> _getGoalSuggestions() {
    return [
      {
        'title': 'Weekly Exercise',
        'description': 'Exercise for 150 minutes per week',
        'icon': Icons.fitness_center,
        'color': Colors.orange[600],
        'metricType': HealthMetricType.exerciseMinutes,
        'targetValue': 150,
        'unit': 'minutes',
      },
      {
        'title': 'Better Sleep',
        'description': 'Get 8 hours of sleep nightly',
        'icon': Icons.bedtime,
        'color': Colors.indigo[600],
        'metricType': HealthMetricType.sleepDuration,
        'targetValue': 8,
        'unit': 'hours',
      },
      {
        'title': 'Hydration Goal',
        'description': 'Drink 8 glasses of water daily',
        'icon': Icons.local_drink,
        'color': Colors.cyan[600],
        'metricType': HealthMetricType.temperature, // Placeholder
        'targetValue': 8,
        'unit': 'glasses',
      },
    ];
  }

  Future<void> _refreshGoals() async {
    _logger.info('Refreshing health goals');

    try {
      // TODO: Refresh goals data from provider
      await Future.delayed(const Duration(seconds: 1)); // Simulate refresh

      _logger.info('Health goals refreshed successfully');
    } catch (e) {
      _logger.error('Failed to refresh health goals: $e', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  void _showCreateGoalDialog() {
    _logger.info('Showing create goal dialog');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Goal'),
        content: const Text('Goal creation wizard coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to goal creation wizard
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAllGoals() {
    _logger.info('Navigating to all goals view');
    // TODO: Navigate to all goals screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All goals view coming soon')));
  }

  void _showGoalDetails(PlaceholderGoal goal) {
    _logger.info('Showing goal details: ${goal.title}');
    // TODO: Navigate to goal details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${goal.title} details coming soon')),
    );
  }

  void _editGoal(PlaceholderGoal goal) {
    _logger.info('Editing goal: ${goal.title}');
    // TODO: Navigate to goal edit screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${goal.title} coming soon')));
  }

  void _showAchievementDetails(PlaceholderAchievement achievement) {
    _logger.info('Showing achievement details: ${achievement.title}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(achievement.icon, color: achievement.color),
            const SizedBox(width: 8),
            Text(achievement.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 16),
            Text(
              'Earned on ${achievement.earnedDate.day}/${achievement.earnedDate.month}/${achievement.earnedDate.year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

  void _createSuggestedGoal(Map<String, dynamic> suggestion) {
    _logger.info('Creating suggested goal: ${suggestion['title']}');
    // TODO: Create goal from suggestion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Creating ${suggestion['title']} goal...')),
    );
  }

  void _showHealthGoalDetails(HealthGoal goal) {
    _logger.info('Showing health goal details', {
      'goalId': goal.id,
      'metricType': goal.metricType,
      'timestamp': DateTime.now().toIso8601String(),
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal.metricType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target: ${goal.targetValue} ${goal.unit}'),
            const SizedBox(height: 8),
            Text('Current: ${goal.currentValue} ${goal.unit}'),
            const SizedBox(height: 8),
            Text('Progress: ${goal.progress.toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text('Status: ${goal.status}'),
            const SizedBox(height: 8),
            Text('Target Date: ${goal.targetDate.day}/${goal.targetDate.month}/${goal.targetDate.year}'),
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

  void _editHealthGoal(HealthGoal goal) {
    _logger.info('Editing health goal', {
      'goalId': goal.id,
      'metricType': goal.metricType,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // TODO: Implement health goal editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${goal.metricType} goal...'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      ),
    );
  }
}

/// Placeholder data models for goals and achievements
class PlaceholderGoal {
  final String id;
  final String title;
  final String description;
  final HealthMetricType metricType;
  final double targetValue;
  final double currentValue;
  final String unit;
  final DateTime deadline;
  final bool isActive;

  const PlaceholderGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.metricType,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.deadline,
    required this.isActive,
  });

  double get progressPercentage => (currentValue / targetValue).clamp(0.0, 1.0);
}

class PlaceholderAchievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime earnedDate;

  const PlaceholderAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.earnedDate,
  });
}

/// Health goal card widget for real HealthGoal objects
class HealthGoalCard extends StatelessWidget {
  final HealthGoal goal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const HealthGoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.metricType,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Target: ${goal.targetValue} ${goal.unit}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: goal.progress / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.progress >= 100
                    ? CareCircleDesignTokens.healthGreen
                    : CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${goal.progress.toStringAsFixed(1)}% complete',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
