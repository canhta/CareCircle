import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/adherence_providers.dart';

/// Adherence tab for medication detail screen
///
/// Displays adherence tracking and analytics including:
/// - Adherence statistics and trends
/// - Recent dose records
/// - Streak tracking
/// - Quick dose recording
class MedicationAdherenceTab extends ConsumerWidget {
  final String medicationId;
  static final _logger = BoundedContextLoggers.medication;

  const MedicationAdherenceTab({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adherenceAsync = ref.watch(medicationAdherenceProvider(medicationId));
    final statisticsAsync = ref.watch(adherenceStatisticsProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatisticsSection(statisticsAsync, theme),
          const SizedBox(height: 24),
          _buildTrendsSection(theme),
          const SizedBox(height: 24),
          _buildRecentRecordsSection(adherenceAsync, theme, context),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return statisticsAsync.when(
      data: (statistics) => _buildStatisticsContent(statistics, theme),
      loading: () => _buildStatisticsLoading(theme),
      error: (error, stackTrace) => _buildStatisticsError(theme),
    );
  }

  Widget _buildStatisticsContent(
    AdherenceStatistics statistics,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adherence Overview',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              _buildAdherencePercentage(statistics.adherencePercentage, theme),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Current Streak',
                      '${statistics.currentStreak} days',
                      Icons.local_fire_department,
                      CareCircleDesignTokens.healthGreen,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Best Streak',
                      '${statistics.longestStreak} days',
                      Icons.emoji_events,
                      Colors.amber,
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Taken',
                      '${statistics.takenDoses}',
                      Icons.check_circle,
                      CareCircleDesignTokens.healthGreen,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Missed',
                      '${statistics.missedDoses}',
                      Icons.cancel,
                      CareCircleDesignTokens.criticalAlert,
                      theme,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdherencePercentage(double percentage, ThemeData theme) {
    final color = _getAdherenceColor(percentage);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 8,
                backgroundColor: theme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  'Adherence',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _getAdherenceLabel(percentage),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adherence Trends',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 48,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Trends Chart',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  'Coming Soon',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentRecordsSection(
    AsyncValue<List<AdherenceRecord>> adherenceAsync,
    ThemeData theme,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Records',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _recordDose(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Record Dose'),
              style: TextButton.styleFrom(
                foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        adherenceAsync.when(
          data: (records) => _buildRecordsContent(records, theme),
          loading: () => _buildRecordsLoading(theme),
          error: (error, stackTrace) => _buildRecordsError(theme),
        ),
      ],
    );
  }

  Widget _buildRecordsContent(List<AdherenceRecord> records, ThemeData theme) {
    if (records.isEmpty) {
      return _buildEmptyRecords(theme);
    }

    return Column(
      children: records
          .take(5)
          .map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildRecordCard(record, theme),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecordCard(AdherenceRecord record, ThemeData theme) {
    final statusColor = _getDoseStatusColor(record.status);
    final statusIcon = _getDoseStatusIcon(record.status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.dosage} ${record.unit}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDateTime(record.scheduledTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _getDoseStatusText(record.status),
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyRecords(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.medication,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No Records Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              'Start recording doses to track adherence',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsLoading(ThemeData theme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStatisticsError(ThemeData theme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Failed to load statistics',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsLoading(ThemeData theme) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildRecordsError(ThemeData theme) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Failed to load records',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Color _getAdherenceColor(double percentage) {
    if (percentage >= 90) return CareCircleDesignTokens.healthGreen;
    if (percentage >= 70) return Colors.orange;
    return CareCircleDesignTokens.criticalAlert;
  }

  String _getAdherenceLabel(double percentage) {
    if (percentage >= 90) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 50) return 'Fair';
    return 'Needs Improvement';
  }

  Color _getDoseStatusColor(DoseStatus status) {
    switch (status) {
      case DoseStatus.scheduled:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case DoseStatus.taken:
        return CareCircleDesignTokens.healthGreen;
      case DoseStatus.missed:
        return CareCircleDesignTokens.criticalAlert;
      case DoseStatus.skipped:
        return Colors.orange;
      case DoseStatus.late:
        return Colors.amber;
    }
  }

  IconData _getDoseStatusIcon(DoseStatus status) {
    switch (status) {
      case DoseStatus.scheduled:
        return Icons.schedule;
      case DoseStatus.taken:
        return Icons.check_circle;
      case DoseStatus.missed:
        return Icons.cancel;
      case DoseStatus.skipped:
        return Icons.skip_next;
      case DoseStatus.late:
        return Icons.access_time;
    }
  }

  String _getDoseStatusText(DoseStatus status) {
    switch (status) {
      case DoseStatus.scheduled:
        return 'Scheduled';
      case DoseStatus.taken:
        return 'Taken';
      case DoseStatus.missed:
        return 'Missed';
      case DoseStatus.skipped:
        return 'Skipped';
      case DoseStatus.late:
        return 'Late';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _recordDose(BuildContext context) {
    _logger.info('Record dose requested from adherence tab', {
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Show record dose dialog with options
    _showRecordDoseDialog(context);
  }

  void _showRecordDoseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Record Dose',
            style: TextStyle(
              color: CareCircleDesignTokens.primaryMedicalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Record adherence for this medication',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Select the dose status:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _recordDoseWithStatus(context, DoseStatus.taken);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CareCircleDesignTokens.healthGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Taken'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _recordDoseWithStatus(context, DoseStatus.missed);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CareCircleDesignTokens.criticalAlert,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Missed'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _recordDoseWithStatus(BuildContext context, DoseStatus status) {
    _logger.info('Recording dose with status from adherence tab', {
      'medicationId': medicationId,
      'status': status.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Dose marked as ${_getDoseStatusText(status).toLowerCase()}',
        ),
        backgroundColor: _getDoseStatusColor(status),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
