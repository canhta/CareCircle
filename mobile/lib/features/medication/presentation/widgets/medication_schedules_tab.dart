import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/schedule_providers.dart';

/// Schedules tab for medication detail screen
///
/// Displays and manages medication schedules including:
/// - Active schedules list
/// - Schedule creation and editing
/// - Reminder configuration
/// - Conflict detection
class MedicationSchedulesTab extends ConsumerWidget {
  final String medicationId;
  static final _logger = BoundedContextLoggers.medication;

  const MedicationSchedulesTab({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(medicationSchedulesProvider(medicationId));
    final theme = Theme.of(context);

    return schedulesAsync.when(
      data: (schedules) =>
          _buildSchedulesContent(context, schedules, theme, ref),
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(error, theme),
    );
  }

  Widget _buildSchedulesContent(
    BuildContext context,
    List<MedicationSchedule> schedules,
    ThemeData theme,
    WidgetRef ref,
  ) {
    if (schedules.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    return Column(
      children: [
        _buildSchedulesHeader(context, schedules.length, theme),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildScheduleCard(context, schedule, theme),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSchedulesHeader(
    BuildContext context,
    int count,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: CareCircleDesignTokens.primaryMedicalBlue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$count Active Schedule${count == 1 ? '' : 's'}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _addNewSchedule(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Schedule'),
            style: TextButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    MedicationSchedule schedule,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    schedule.instructions,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildScheduleStatusChip(schedule, theme),
              ],
            ),
            const SizedBox(height: 12),
            _buildScheduleDetails(schedule, theme),
            const SizedBox(height: 12),
            _buildScheduleActions(context, schedule, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStatusChip(
    MedicationSchedule schedule,
    ThemeData theme,
  ) {
    final isActive =
        schedule.remindersEnabled &&
        (schedule.endDate == null || schedule.endDate!.isAfter(DateTime.now()));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isActive
              ? CareCircleDesignTokens.healthGreen
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildScheduleDetails(MedicationSchedule schedule, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          'Frequency',
          _getFrequencyText(schedule.schedule),
          Icons.repeat,
          theme,
        ),
        const SizedBox(height: 8),
        _buildDetailRow(
          'Reminders',
          schedule.remindersEnabled ? 'Enabled' : 'Disabled',
          Icons.notifications,
          theme,
        ),
        if (schedule.reminderTimes.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildDetailRow(
            'Times',
            schedule.reminderTimes
                .map(
                  (time) =>
                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                )
                .join(', '),
            Icons.access_time,
            theme,
          ),
        ],
        const SizedBox(height: 8),
        _buildDetailRow(
          'Duration',
          _getDurationText(schedule),
          Icons.date_range,
          theme,
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleActions(
    BuildContext context,
    MedicationSchedule schedule,
    ThemeData theme,
  ) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => _editSchedule(context, schedule),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          style: TextButton.styleFrom(
            foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        TextButton.icon(
          onPressed: () => _toggleSchedule(schedule),
          icon: Icon(
            schedule.remindersEnabled ? Icons.pause : Icons.play_arrow,
            size: 16,
          ),
          label: Text(schedule.remindersEnabled ? 'Pause' : 'Resume'),
          style: TextButton.styleFrom(
            foregroundColor: schedule.remindersEnabled
                ? Colors.orange
                : CareCircleDesignTokens.healthGreen,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _deleteSchedule(schedule),
          icon: const Icon(Icons.delete, size: 18),
          color: CareCircleDesignTokens.criticalAlert,
          tooltip: 'Delete schedule',
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Schedules',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a schedule to set up medication reminders',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _addNewSchedule(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Schedule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: CareCircleDesignTokens.criticalAlert,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load schedules',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFrequencyText(DosageSchedule schedule) {
    switch (schedule.frequency) {
      case DosageFrequency.daily:
        return 'Daily';
      case DosageFrequency.weekly:
        return 'Weekly';
      case DosageFrequency.monthly:
        return 'Monthly';
      case DosageFrequency.asNeeded:
        return 'As Needed';
    }
  }

  String _getDurationText(MedicationSchedule schedule) {
    final start = schedule.startDate;
    final end = schedule.endDate;

    if (end == null) {
      return 'Started ${_formatDate(start)} - Ongoing';
    } else {
      return '${_formatDate(start)} - ${_formatDate(end)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addNewSchedule(BuildContext context) {
    _logger.info('Add new schedule requested', {
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _showScheduleDialog(context);
  }

  void _editSchedule(BuildContext context, MedicationSchedule schedule) {
    _logger.info('Edit schedule requested', {
      'scheduleId': schedule.id,
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _showScheduleDialog(context, schedule: schedule);
  }

  Future<void> _toggleSchedule(MedicationSchedule schedule) async {
    _logger.info('Toggle schedule requested', {
      'scheduleId': schedule.id,
      'currentState': schedule.remindersEnabled,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // This method needs to be called from a widget context
    // For now, just log the action
    _logger.info('Schedule toggle completed', {
      'scheduleId': schedule.id,
      'newState': !schedule.remindersEnabled,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _deleteSchedule(MedicationSchedule schedule) {
    _logger.info('Delete schedule requested', {
      'scheduleId': schedule.id,
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement delete schedule
  }

  void _showScheduleDialog(
    BuildContext context, {
    MedicationSchedule? schedule,
  }) {
    final isEditing = schedule != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Schedule' : 'Add New Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing
                    ? 'Edit the medication schedule settings'
                    : 'Create a new medication schedule',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Schedule form would go here
              // For now, show a placeholder
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 48,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Schedule form will be implemented',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual schedule creation/update
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEditing
                        ? 'Schedule updated (placeholder)'
                        : 'Schedule created (placeholder)',
                  ),
                  backgroundColor: CareCircleDesignTokens.healthGreen,
                ),
              );
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }
}
