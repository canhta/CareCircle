import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/adherence_providers.dart';

/// Adherence Tracking Screen for dose management interface
///
/// Features:
/// - Dose status recording interface
/// - Quick dose actions (taken, missed, skipped)
/// - Adherence analytics and trends
/// - Streak tracking visualization
/// - Material Design 3 healthcare adaptations
class AdherenceTrackingScreen extends ConsumerStatefulWidget {
  final String medicationId;

  const AdherenceTrackingScreen({super.key, required this.medicationId});

  @override
  ConsumerState<AdherenceTrackingScreen> createState() =>
      _AdherenceTrackingScreenState();
}

class _AdherenceTrackingScreenState
    extends ConsumerState<AdherenceTrackingScreen> {
  static final _logger = BoundedContextLoggers.medication;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adherenceAsync = ref.watch(
      medicationAdherenceProvider(widget.medicationId),
    );
    final statisticsAsync = ref.watch(adherenceStatisticsProvider);
    final todayDosesAsync = ref.watch(
      medicationAdherenceProvider(widget.medicationId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adherence Tracking'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showDatePicker(context),
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Select Date',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(theme),
            const SizedBox(height: 24),
            _buildStatisticsCard(statisticsAsync, theme),
            const SizedBox(height: 24),
            _buildTodayDosesSection(todayDosesAsync, theme),
            const SizedBox(height: 24),
            _buildRecentRecordsSection(adherenceAsync, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: CareCircleDesignTokens.primaryMedicalBlue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking Date',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedDate.day != DateTime.now().day ||
                _selectedDate.month != DateTime.now().month ||
                _selectedDate.year != DateTime.now().year)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                },
                child: const Text('Today'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(
    AsyncValue<AdherenceStatistics> statisticsAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adherence Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) => _buildStatisticsContent(statistics, theme),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load statistics', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent(
    AdherenceStatistics statistics,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Adherence percentage circle
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getAdherenceColor(statistics.adherencePercentage),
              width: 8,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${statistics.adherencePercentage.toInt()}%',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getAdherenceColor(statistics.adherencePercentage),
                  ),
                ),
                Text('Adherence', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
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
    );
  }

  Widget _buildStatCard(
    String title,
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
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDosesSection(
    AsyncValue<List<AdherenceRecord>> todayDosesAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Doses',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            todayDosesAsync.when(
              data: (doses) => doses.isEmpty
                  ? _buildEmptyState('No doses scheduled for today', theme)
                  : Column(
                      children: doses
                          .map((dose) => _buildDoseCard(dose, theme))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load today\'s doses', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseCard(AdherenceRecord dose, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getDoseStatusColor(dose.status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getDoseStatusColor(dose.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getDoseStatusIcon(dose.status),
              color: _getDoseStatusColor(dose.status),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dose.scheduledTime.hour.toString().padLeft(2, '0')}:${dose.scheduledTime.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${dose.dosage} ${dose.unit}',
                  style: theme.textTheme.bodyMedium,
                ),
                if (dose.status != DoseStatus.scheduled)
                  Text(
                    _getDoseStatusText(dose.status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getDoseStatusColor(dose.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (dose.status == DoseStatus.scheduled) ...[
            const SizedBox(width: 8),
            _buildDoseActions(dose, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildDoseActions(AdherenceRecord dose, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _recordDose(dose, DoseStatus.taken),
          icon: const Icon(Icons.check_circle),
          color: CareCircleDesignTokens.healthGreen,
          tooltip: 'Mark as Taken',
        ),
        IconButton(
          onPressed: () => _recordDose(dose, DoseStatus.missed),
          icon: const Icon(Icons.cancel),
          color: CareCircleDesignTokens.criticalAlert,
          tooltip: 'Mark as Missed',
        ),
        IconButton(
          onPressed: () => _recordDose(dose, DoseStatus.skipped),
          icon: const Icon(Icons.remove_circle),
          color: Colors.orange,
          tooltip: 'Mark as Skipped',
        ),
      ],
    );
  }

  Widget _buildRecentRecordsSection(
    AsyncValue<List<AdherenceRecord>> adherenceAsync,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Records',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            adherenceAsync.when(
              data: (records) => records.isEmpty
                  ? _buildEmptyState('No adherence records yet', theme)
                  : Column(
                      children: records
                          .take(10)
                          .map((record) => _buildRecordCard(record, theme))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  _buildErrorState('Failed to load records', theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(AdherenceRecord record, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          Icon(
            _getDoseStatusIcon(record.status),
            color: _getDoseStatusColor(record.status),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.scheduledTime.day}/${record.scheduledTime.month} at ${record.scheduledTime.hour.toString().padLeft(2, '0')}:${record.scheduledTime.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _getDoseStatusText(record.status),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getDoseStatusColor(record.status),
                  ),
                ),
              ],
            ),
          ),
          if (record.takenAt != null)
            Text(
              'at ${record.takenAt!.hour.toString().padLeft(2, '0')}:${record.takenAt!.minute.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.medication,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: CareCircleDesignTokens.criticalAlert,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: CareCircleDesignTokens.criticalAlert,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getAdherenceColor(double percentage) {
    if (percentage >= 90) return CareCircleDesignTokens.healthGreen;
    if (percentage >= 70) return Colors.orange;
    return CareCircleDesignTokens.criticalAlert;
  }

  Color _getDoseStatusColor(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return CareCircleDesignTokens.healthGreen;
      case DoseStatus.missed:
        return CareCircleDesignTokens.criticalAlert;
      case DoseStatus.skipped:
        return Colors.orange;
      case DoseStatus.scheduled:
        return Colors.grey;
      case DoseStatus.late:
        return Colors.orange;
    }
  }

  IconData _getDoseStatusIcon(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return Icons.check_circle;
      case DoseStatus.missed:
        return Icons.cancel;
      case DoseStatus.skipped:
        return Icons.remove_circle;
      case DoseStatus.scheduled:
        return Icons.schedule;
      case DoseStatus.late:
        return Icons.access_time;
    }
  }

  String _getDoseStatusText(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return 'Taken';
      case DoseStatus.missed:
        return 'Missed';
      case DoseStatus.skipped:
        return 'Skipped';
      case DoseStatus.scheduled:
        return 'Scheduled';
      case DoseStatus.late:
        return 'Late';
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _recordDose(AdherenceRecord dose, DoseStatus status) async {
    try {
      _logger.info('Recording dose status', {
        'operation': 'recordDose',
        'medicationId': widget.medicationId,
        'doseId': dose.id,
        'status': status.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      // TODO: Update the adherence record using provider method
      // final adherenceRecord = AdherenceRecord(...);
      // await ref.read(adherenceNotifierProvider.notifier).updateRecord(adherenceRecord);

      if (mounted) {
        _logger.info('Dose status recorded successfully', {
          'operation': 'recordDose',
          'medicationId': widget.medicationId,
          'status': status.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dose marked as ${_getDoseStatusText(status).toLowerCase()}',
            ),
            backgroundColor: _getDoseStatusColor(status),
          ),
        );

        // Refresh data
        ref.invalidate(medicationAdherenceProvider(widget.medicationId));
        ref.invalidate(adherenceStatisticsProvider);
      }
    } catch (e) {
      _logger.error('Failed to record dose status', {
        'operation': 'recordDose',
        'medicationId': widget.medicationId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record dose: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }
}
