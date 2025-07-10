import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';

/// Overview tab for medication detail screen
/// 
/// Displays comprehensive medication information including:
/// - Basic medication details
/// - Prescription information
/// - Quick actions
/// - Important notes and warnings
class MedicationOverviewTab extends ConsumerWidget {
  final Medication medication;
  static final _logger = BoundedContextLoggers.medication;

  const MedicationOverviewTab({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInformation(theme),
          const SizedBox(height: 24),
          _buildPrescriptionInformation(theme),
          const SizedBox(height: 24),
          _buildQuickActions(theme),
          const SizedBox(height: 24),
          _buildNotesSection(theme),
          if (medication.classification != null) ...[
            const SizedBox(height: 24),
            _buildClassificationSection(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildBasicInformation(ThemeData theme) {
    return _buildSection(
      title: 'Basic Information',
      theme: theme,
      child: Column(
        children: [
          _buildInfoRow('Name', medication.name, theme),
          if (medication.genericName != null)
            _buildInfoRow('Generic Name', medication.genericName!, theme),
          _buildInfoRow('Strength', medication.strength, theme),
          _buildInfoRow('Form', medication.form.displayName, theme),
          if (medication.manufacturer != null)
            _buildInfoRow('Manufacturer', medication.manufacturer!, theme),
          _buildInfoRow('Status', medication.isActive ? 'Active' : 'Inactive', theme),
          _buildInfoRow('Start Date', _formatDate(medication.startDate), theme),
          if (medication.endDate != null)
            _buildInfoRow('End Date', _formatDate(medication.endDate!), theme),
        ],
      ),
    );
  }

  Widget _buildPrescriptionInformation(ThemeData theme) {
    return _buildSection(
      title: 'Prescription Information',
      theme: theme,
      child: Column(
        children: [
          if (medication.prescriptionId != null)
            _buildInfoRow('Prescription ID', medication.prescriptionId!, theme)
          else
            _buildEmptyState('No prescription linked', theme),
          if (medication.rxNormCode != null)
            _buildInfoRow('RxNorm Code', medication.rxNormCode!, theme),
          if (medication.ndcCode != null)
            _buildInfoRow('NDC Code', medication.ndcCode!, theme),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return _buildSection(
      title: 'Quick Actions',
      theme: theme,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Record Dose',
                  Icons.medication,
                  CareCircleDesignTokens.healthGreen,
                  () => _recordDose(),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Add Schedule',
                  Icons.schedule,
                  CareCircleDesignTokens.primaryMedicalBlue,
                  () => _addSchedule(),
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Check Interactions',
                  Icons.warning_amber,
                  Colors.orange,
                  () => _checkInteractions(),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'View History',
                  Icons.history,
                  theme.colorScheme.primary,
                  () => _viewHistory(),
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return _buildSection(
      title: 'Notes',
      theme: theme,
      child: medication.notes != null && medication.notes!.isNotEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                medication.notes!,
                style: theme.textTheme.bodyMedium,
              ),
            )
          : _buildEmptyState('No notes added', theme),
    );
  }

  Widget _buildClassificationSection(ThemeData theme) {
    return _buildSection(
      title: 'Classification',
      theme: theme,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          medication.classification!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: CareCircleDesignTokens.primaryMedicalBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    ThemeData theme,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _recordDose() {
    _logger.info('Record dose action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement record dose functionality
  }

  void _addSchedule() {
    _logger.info('Add schedule action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement add schedule functionality
  }

  void _checkInteractions() {
    _logger.info('Check interactions action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement check interactions functionality
  }

  void _viewHistory() {
    _logger.info('View history action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement view history functionality
  }
}

// Extension for MedicationForm display names is already defined in the domain model
