import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/adherence_providers.dart';
import '../providers/medication_providers.dart';

/// Simple screen for recording medication doses
class SimpleRecordDoseScreen extends ConsumerStatefulWidget {
  final String medicationId;
  final String? scheduleId;

  const SimpleRecordDoseScreen({
    super.key,
    required this.medicationId,
    this.scheduleId,
  });

  @override
  ConsumerState<SimpleRecordDoseScreen> createState() =>
      _SimpleRecordDoseScreenState();
}

class _SimpleRecordDoseScreenState
    extends ConsumerState<SimpleRecordDoseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _amountController = TextEditingController(text: '1');
  final _logger = BoundedContextLoggers.medication;

  DateTime _selectedTime = DateTime.now();
  String _selectedUnit = 'tablet';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _logger.logMedicationEvent('Record dose screen accessed', {
      'medicationId': widget.medicationId,
      'hasScheduleId': widget.scheduleId != null,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicationAsync = ref.watch(medicationProvider(widget.medicationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Dose'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
      ),
      body: medicationAsync.when(
        data: (medication) => medication != null
            ? _buildForm(medication)
            : const Center(child: Text('Medication not found')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load medication details'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(medicationProvider(widget.medicationId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Medication medication) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (medication.genericName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Generic: ${medication.genericName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${medication.strength} • ${medication.form.name.toUpperCase()}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Amount input
            Text(
              'Dose Amount',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _getUnitsForForm(medication.form)
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedUnit = value);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Time taken
            Text(
              'Time Taken',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(_selectedTime),
                ),
                subtitle: const Text('Tap to change'),
                onTap: _selectDateTime,
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            Text(
              'Notes (Optional)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any notes about taking this dose...',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _recordDose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          CareCircleDesignTokens.primaryMedicalBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Record Dose'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<String> _getUnitsForForm(MedicationForm form) {
    switch (form) {
      case MedicationForm.tablet:
      case MedicationForm.capsule:
        return ['tablet', 'capsule', 'piece'];
      case MedicationForm.liquid:
        return ['ml', 'tsp', 'tbsp', 'oz'];
      case MedicationForm.injection:
        return ['ml', 'unit', 'mg'];
      case MedicationForm.patch:
        return ['patch', 'piece'];
      case MedicationForm.inhaler:
        return ['puff', 'dose', 'inhalation'];
      case MedicationForm.cream:
        return ['g', 'ml', 'application'];
      case MedicationForm.ointment:
        return ['g', 'ml', 'application'];
      case MedicationForm.drops:
        return ['drop', 'ml'];
      case MedicationForm.suppository:
        return ['suppository', 'piece'];
      case MedicationForm.other:
        return ['dose', 'unit', 'piece', 'ml', 'mg'];
    }
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();

    // Show date picker if not today
    DateTime selectedDate = DateTime(
      _selectedTime.year,
      _selectedTime.month,
      _selectedTime.day,
    );

    if (!_isToday(_selectedTime)) {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: now.subtract(const Duration(days: 7)),
        lastDate: now,
      );

      if (pickedDate != null) {
        selectedDate = pickedDate;
      } else {
        return;
      }
    }

    // Show time picker
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (pickedTime != null) {
      final newDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Ensure not in future
      final finalTime = newDateTime.isAfter(now) ? now : newDateTime;
      setState(() => _selectedTime = finalTime);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> _recordDose() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final amount = double.parse(_amountController.text);

      final request = CreateAdherenceRecordRequest(
        medicationId: widget.medicationId,
        scheduleId:
            widget.scheduleId ??
            'manual-${DateTime.now().millisecondsSinceEpoch}',
        scheduledTime: _selectedTime,
        dosage: amount,
        unit: _selectedUnit,
        status: DoseStatus.taken,
        takenAt: _selectedTime,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await ref.read(adherenceManagementProvider.notifier).recordDose(request);

      _logger.logMedicationEvent('Dose recorded successfully', {
        'medicationId': widget.medicationId,
        'dosage': amount,
        'unit': _selectedUnit,
        'timestamp': _selectedTime.toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dose recorded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          context.pop();
        }
      }
    } catch (error) {
      _logger.error('Failed to record dose', {
        'error': error.toString(),
        'medicationId': widget.medicationId,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record dose: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
