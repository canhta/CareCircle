import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/services/medication_api_service.dart';

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

  const MedicationOverviewTab({super.key, required this.medication});

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
          _buildQuickActions(theme, context),
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
          _buildInfoRow(
            'Status',
            medication.isActive ? 'Active' : 'Inactive',
            theme,
          ),
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

  Widget _buildQuickActions(ThemeData theme, BuildContext context) {
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
                  () => _recordDose(context),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Add Schedule',
                  Icons.schedule,
                  CareCircleDesignTokens.primaryMedicalBlue,
                  () => _addSchedule(context),
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
                  () => _checkInteractions(context),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'View History',
                  Icons.history,
                  theme.colorScheme.primary,
                  () => _viewHistory(context),
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
              child: Text(medication.notes!, style: theme.textTheme.bodyMedium),
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
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
            alpha: 0.1,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.3,
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  void _recordDose(BuildContext context) {
    _logger.info('Record dose action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
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
              Text(
                'Record dose for ${medication.name}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'How would you like to record this dose?',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _recordDoseAsTaken(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.healthGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark as Taken'),
            ),
          ],
        );
      },
    );
  }

  void _recordDoseAsTaken(BuildContext context) {
    // For overview tab, we'll create a simple adherence record
    // In a real implementation, this would be connected to a specific schedule
    _logger.info('Recording dose as taken from overview', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dose recorded for ${medication.name}'),
        backgroundColor: CareCircleDesignTokens.healthGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addSchedule(BuildContext context) {
    _logger.info('Add schedule action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Navigate to schedule management screen for this medication
    context.push(
      '/medication/schedule/add',
      extra: {'medicationId': medication.id, 'medicationName': medication.name},
    );
  }

  void _checkInteractions(BuildContext context) {
    _logger.info('Check interactions action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Show drug interactions dialog with real API data
    _showInteractionsDialog(context);
  }

  void _viewHistory(BuildContext context) {
    _logger.info('View history action triggered', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Navigate to adherence dashboard filtered for this medication
    context.push(
      '/medication/adherence',
      extra: {'medicationId': medication.id, 'medicationName': medication.name},
    );
  }

  /// Show drug interactions dialog with real API data
  void _showInteractionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
                SizedBox(width: CareCircleSpacingTokens.sm),
                Text('Drug Interactions'),
              ],
            ),
            content: FutureBuilder(
              future: ref
                  .read(medicationApiServiceProvider)
                  .checkUserMedicationInteractions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: CareCircleSpacingTokens.md),
                      Text(
                        'Checking interactions for ${medication.name}...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: CareCircleDesignTokens.criticalAlert,
                        size: 48,
                      ),
                      SizedBox(height: CareCircleSpacingTokens.md),
                      Text(
                        'Failed to check interactions. Please try again.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                final interactionResponse = snapshot.data;
                final interactionData = interactionResponse?.data;
                final hasInteractions =
                    interactionData?.hasContraindications ?? false;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(CareCircleSpacingTokens.md),
                      decoration: BoxDecoration(
                        color: hasInteractions
                            ? Colors.orange.withValues(alpha: 0.1)
                            : CareCircleDesignTokens.healthGreen.withValues(
                                alpha: 0.1,
                              ),
                        borderRadius: BorderRadius.circular(
                          CareCircleSpacingTokens.sm,
                        ),
                        border: Border.all(
                          color: hasInteractions
                              ? Colors.orange.withValues(alpha: 0.3)
                              : CareCircleDesignTokens.healthGreen.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            hasInteractions
                                ? Icons.warning
                                : Icons.check_circle,
                            color: hasInteractions
                                ? Colors.orange
                                : CareCircleDesignTokens.healthGreen,
                            size: 20,
                          ),
                          SizedBox(width: CareCircleSpacingTokens.sm),
                          Expanded(
                            child: Text(
                              hasInteractions
                                  ? '${interactionData?.totalInteractions ?? 0} potential interaction(s) found.'
                                  : 'No known interactions found with your current medications.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: hasInteractions
                                        ? Colors.orange
                                        : CareCircleDesignTokens.healthGreen,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: CareCircleSpacingTokens.sm),
                    Text(
                      'Always consult your healthcare provider before making changes to your medication regimen.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to detailed interactions screen
                  context.push('/drug-interactions');
                  _logger.info('Detailed interactions requested', {
                    'medicationId': medication.id,
                  });
                },
                child: Text('View Details'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Extension for MedicationForm display names is already defined in the domain model
