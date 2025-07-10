import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';

/// History tab for medication detail screen
///
/// Displays medication change history including:
/// - Dosage changes
/// - Schedule modifications
/// - Status updates
/// - Notes and comments
class MedicationHistoryTab extends ConsumerWidget {
  final String medicationId;
  static final _logger = BoundedContextLoggers.medication;

  const MedicationHistoryTab({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // TODO: Replace with actual history provider when available
    final mockHistory = _generateMockHistory();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryHeader(theme),
          const SizedBox(height: 16),
          if (mockHistory.isEmpty)
            _buildEmptyState(theme)
          else
            _buildHistoryTimeline(mockHistory, theme),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.history,
          color: CareCircleDesignTokens.primaryMedicalBlue,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Medication History',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _exportHistory(),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: TextButton.styleFrom(
            foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTimeline(
    List<MedicationHistoryEntry> history,
    ThemeData theme,
  ) {
    return Column(
      children: history.asMap().entries.map((entry) {
        final index = entry.key;
        final historyEntry = entry.value;
        final isLast = index == history.length - 1;

        return _buildTimelineItem(historyEntry, isLast, theme);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(
    MedicationHistoryEntry entry,
    bool isLast,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineIndicator(entry.type, isLast, theme),
        const SizedBox(width: 16),
        Expanded(child: _buildHistoryCard(entry, theme)),
      ],
    );
  }

  Widget _buildTimelineIndicator(
    HistoryEntryType type,
    bool isLast,
    ThemeData theme,
  ) {
    final color = _getHistoryTypeColor(type);
    final icon = _getHistoryTypeIcon(type);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 60,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
      ],
    );
  }

  Widget _buildHistoryCard(MedicationHistoryEntry entry, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _formatDateTime(entry.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          if (entry.changes.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildChangesList(entry.changes, theme),
          ],
          if (entry.performedBy != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'by ${entry.performedBy}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChangesList(Map<String, String> changes, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Changes:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          ...changes.entries.map(
            (change) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      '${change.key}:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      change.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
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
              Icons.history,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No History Available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Medication changes and updates will appear here',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHistoryTypeColor(HistoryEntryType type) {
    switch (type) {
      case HistoryEntryType.created:
        return CareCircleDesignTokens.healthGreen;
      case HistoryEntryType.updated:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case HistoryEntryType.dosageChanged:
        return Colors.orange;
      case HistoryEntryType.scheduleChanged:
        return Colors.purple;
      case HistoryEntryType.statusChanged:
        return Colors.amber;
      case HistoryEntryType.deleted:
        return CareCircleDesignTokens.criticalAlert;
    }
  }

  IconData _getHistoryTypeIcon(HistoryEntryType type) {
    switch (type) {
      case HistoryEntryType.created:
        return Icons.add_circle;
      case HistoryEntryType.updated:
        return Icons.edit;
      case HistoryEntryType.dosageChanged:
        return Icons.medication;
      case HistoryEntryType.scheduleChanged:
        return Icons.schedule;
      case HistoryEntryType.statusChanged:
        return Icons.toggle_on;
      case HistoryEntryType.deleted:
        return Icons.delete;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _exportHistory() {
    _logger.info('Export history requested', {
      'medicationId': medicationId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement export history functionality
  }

  // Mock data for demonstration
  List<MedicationHistoryEntry> _generateMockHistory() {
    return [
      MedicationHistoryEntry(
        id: '1',
        type: HistoryEntryType.created,
        title: 'Medication Added',
        description: 'Medication was added to your profile',
        timestamp: DateTime.now().subtract(const Duration(days: 30)),
        changes: {'Name': 'Lisinopril', 'Strength': '10mg', 'Form': 'Tablet'},
        performedBy: 'Dr. Smith',
      ),
      MedicationHistoryEntry(
        id: '2',
        type: HistoryEntryType.scheduleChanged,
        title: 'Schedule Updated',
        description: 'Dosing schedule was modified',
        timestamp: DateTime.now().subtract(const Duration(days: 15)),
        changes: {
          'Frequency': 'Once daily → Twice daily',
          'Times': '8:00 AM → 8:00 AM, 8:00 PM',
        },
        performedBy: 'Dr. Smith',
      ),
      MedicationHistoryEntry(
        id: '3',
        type: HistoryEntryType.dosageChanged,
        title: 'Dosage Increased',
        description: 'Medication strength was increased',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        changes: {'Strength': '10mg → 20mg'},
        performedBy: 'Dr. Smith',
      ),
    ];
  }
}

// Mock models for history functionality
enum HistoryEntryType {
  created,
  updated,
  dosageChanged,
  scheduleChanged,
  statusChanged,
  deleted,
}

class MedicationHistoryEntry {
  final String id;
  final HistoryEntryType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final Map<String, String> changes;
  final String? performedBy;

  MedicationHistoryEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.changes = const {},
    this.performedBy,
  });
}
