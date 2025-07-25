import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/medication_providers.dart';
import '../widgets/medication_overview_tab.dart';
import '../widgets/medication_schedules_tab.dart';
import '../widgets/medication_adherence_tab.dart';
import '../widgets/medication_interactions_tab.dart';
import '../widgets/medication_history_tab.dart';

/// Individual medication detail screen with tabbed interface
///
/// Provides comprehensive medication management including:
/// - Overview with basic details and actions
/// - Schedules for dosing and reminders
/// - Adherence tracking and analytics
/// - Drug interactions and warnings
/// - Medication history and changes
class MedicationDetailScreen extends ConsumerStatefulWidget {
  final String medicationId;
  final Medication? medication;

  const MedicationDetailScreen({
    super.key,
    required this.medicationId,
    this.medication,
  });

  @override
  ConsumerState<MedicationDetailScreen> createState() =>
      _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends ConsumerState<MedicationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _logger = BoundedContextLoggers.medication;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _logger.info('Medication detail screen initialized', {
      'medicationId': widget.medicationId,
      'hasPreloadedData': widget.medication != null,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicationAsync = widget.medication != null
        ? AsyncValue.data(widget.medication!)
        : ref.watch(medicationProvider(widget.medicationId));

    return medicationAsync.when(
      data: (medication) => medication != null
          ? _buildDetailScreen(medication)
          : _buildNotFoundScreen(),
      loading: () => _buildLoadingScreen(),
      error: (error, stackTrace) => _buildErrorScreen(error),
    );
  }

  Widget _buildDetailScreen(Medication medication) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(medication, theme),
      body: Column(
        children: [
          _buildMedicationHeader(medication, theme),
          _buildTabBar(theme),
          Expanded(child: _buildTabBarView(medication)),
        ],
      ),
      floatingActionButton: _buildActionButtons(medication, theme),
    );
  }

  PreferredSizeWidget _buildAppBar(Medication medication, ThemeData theme) {
    return AppBar(
      title: Text(
        medication.name,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: theme.colorScheme.onSurface),
          onPressed: () => _navigateToEditMedication(medication),
          tooltip: 'Edit medication',
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
          onSelected: (value) => _handleMenuAction(value, medication),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('Duplicate'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'archive',
              child: ListTile(
                leading: Icon(Icons.archive),
                title: Text('Archive'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicationHeader(Medication medication, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildMedicationIcon(medication, theme),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (medication.genericName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    medication.genericName!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      '${medication.strength} ${medication.form.name}',
                      theme,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(medication.isActive, theme),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationIcon(Medication medication, ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getMedicationIcon(medication.form),
        size: 28,
        color: CareCircleDesignTokens.primaryMedicalBlue,
      ),
    );
  }

  Widget _buildInfoChip(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive, ThemeData theme) {
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

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: CareCircleDesignTokens.primaryMedicalBlue,
        labelColor: CareCircleDesignTokens.primaryMedicalBlue,
        unselectedLabelColor: theme.colorScheme.onSurface.withValues(
          alpha: 0.7,
        ),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Schedules'),
          Tab(text: 'Adherence'),
          Tab(text: 'Interactions'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(Medication medication) {
    return TabBarView(
      controller: _tabController,
      children: [
        MedicationOverviewTab(medication: medication),
        MedicationSchedulesTab(medicationId: medication.id),
        MedicationAdherenceTab(medicationId: medication.id),
        MedicationInteractionsTab(medicationId: medication.id),
        MedicationHistoryTab(medicationId: medication.id),
      ],
    );
  }

  Widget _buildActionButtons(Medication medication, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'add_schedule',
          onPressed: () => _navigateToAddSchedule(medication),
          backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.schedule),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'record_dose',
          onPressed: () => _navigateToRecordDose(medication),
          backgroundColor: CareCircleDesignTokens.healthGreen,
          foregroundColor: Colors.white,
          child: const Icon(Icons.medication),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading...'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNotFoundScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Not Found'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Medication Not Found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The requested medication could not be found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
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
              'Failed to load medication',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMedicationIcon(MedicationForm form) {
    switch (form) {
      case MedicationForm.tablet:
        return Icons.medication;
      case MedicationForm.capsule:
        return Icons.medication_liquid;
      case MedicationForm.liquid:
        return Icons.local_drink;
      case MedicationForm.injection:
        return Icons.colorize;
      case MedicationForm.patch:
        return Icons.healing;
      case MedicationForm.inhaler:
        return Icons.air;
      case MedicationForm.cream:
        return Icons.healing;
      case MedicationForm.ointment:
        return Icons.healing;
      case MedicationForm.drops:
        return Icons.water_drop;
      case MedicationForm.suppository:
        return Icons.medication;
      case MedicationForm.other:
        return Icons.medication;
    }
  }

  void _navigateToEditMedication(Medication medication) {
    _logger.info('Navigation to edit medication requested', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement navigation to edit medication
  }

  void _navigateToAddSchedule(Medication medication) {
    _logger.info('Navigation to add schedule requested', {
      'medicationId': medication.id,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // TODO: Implement navigation to add schedule
  }

  void _navigateToRecordDose(Medication medication) {
    _logger.info('Navigation to record dose requested', {
      'medicationId': medication.id,
      'medicationName': medication.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    context.pushNamed('record-dose', pathParameters: {'id': medication.id});
  }

  void _handleMenuAction(String action, Medication medication) {
    _logger.info('Medication menu action selected', {
      'action': action,
      'medicationId': medication.id,
      'timestamp': DateTime.now().toIso8601String(),
    });

    switch (action) {
      case 'duplicate':
        _duplicateMedication(medication);
        break;
      case 'archive':
        _archiveMedication(medication);
        break;
      case 'delete':
        _showDeleteConfirmation(medication);
        break;
    }
  }

  void _showDeleteConfirmation(Medication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text('Are you sure you want to delete ${medication.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete medication
            },
            style: TextButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.criticalAlert,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _duplicateMedication(Medication medication) async {
    try {
      _logger.info('Duplicating medication', {
        'medicationId': medication.id,
        'medicationName': medication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Create a duplicate medication request
      final duplicateRequest = CreateMedicationRequest(
        name: '${medication.name} (Copy)',
        genericName: medication.genericName,
        strength: medication.strength,
        form: medication.form,
        manufacturer: medication.manufacturer,
        classification: medication.classification,
        isActive: medication.isActive,
        startDate: DateTime.now(),
        endDate: medication.endDate,
        notes: medication.notes,
      );

      // Use the medication provider to create the duplicate
      await ref
          .read(medicationNotifierProvider.notifier)
          .createMedication(duplicateRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medication.name} duplicated successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to duplicate medication', {
        'medicationId': medication.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to duplicate medication: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  Future<void> _archiveMedication(Medication medication) async {
    try {
      _logger.info('Archiving medication', {
        'medicationId': medication.id,
        'medicationName': medication.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Update medication to inactive (archived)
      final updateRequest = UpdateMedicationRequest(
        name: medication.name,
        genericName: medication.genericName,
        strength: medication.strength,
        form: medication.form,
        manufacturer: medication.manufacturer,
        classification: medication.classification,
        isActive: false, // Archive by setting to inactive
        startDate: medication.startDate,
        endDate: DateTime.now(), // Set end date to now
        notes: medication.notes != null
            ? '${medication.notes}\nArchived on ${DateTime.now().toLocal()}'
            : 'Archived on ${DateTime.now().toLocal()}',
      );

      await ref
          .read(medicationNotifierProvider.notifier)
          .updateMedication(medication.id, updateRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medication.name} archived successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );

        // Navigate back to medication list
        Navigator.of(context).pop();
      }
    } catch (e) {
      _logger.error('Failed to archive medication', {
        'medicationId': medication.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to archive medication: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }
}
