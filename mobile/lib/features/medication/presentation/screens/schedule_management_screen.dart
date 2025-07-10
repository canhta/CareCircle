import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/schedule_providers.dart';

/// Schedule Management Screen for medication scheduling interface
/// 
/// Features:
/// - Schedule creation and editing forms
/// - Reminder configuration interface
/// - Dose tracking and conflict detection
/// - Calendar/timeline view for schedules
/// - Material Design 3 healthcare adaptations
class ScheduleManagementScreen extends ConsumerStatefulWidget {
  final String medicationId;
  final MedicationSchedule? schedule; // null for new schedule

  const ScheduleManagementScreen({
    super.key,
    required this.medicationId,
    this.schedule,
  });

  @override
  ConsumerState<ScheduleManagementScreen> createState() => _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends ConsumerState<ScheduleManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _instructionsController = TextEditingController();
  static final _logger = BoundedContextLoggers.medication;

  // Form state
  bool _remindersEnabled = true;
  DateTime? _startDate;
  DateTime? _endDate;
  String _frequency = 'daily';
  int _timesPerDay = 1;
  List<int> _selectedDaysOfWeek = [];
  List<TimeOfDay> _reminderTimes = [];
  String _mealRelation = 'independent';
  
  // Reminder settings
  int _advanceMinutes = 15;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _criticalityLevel = 'medium';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.schedule != null) {
      final schedule = widget.schedule!;
      _instructionsController.text = schedule.instructions;
      _remindersEnabled = schedule.remindersEnabled;
      _startDate = schedule.startDate;
      _endDate = schedule.endDate;
      _frequency = schedule.schedule.frequency;
      _timesPerDay = schedule.schedule.times;
      _selectedDaysOfWeek = schedule.schedule.daysOfWeek ?? [];
      _mealRelation = schedule.schedule.mealRelation ?? 'independent';
      
      // Convert reminder times
      _reminderTimes = schedule.reminderTimes.map((time) => 
        TimeOfDay(hour: time.hour, minute: time.minute)
      ).toList();
      
      // Reminder settings
      _advanceMinutes = schedule.reminderSettings.advanceMinutes;
      _soundEnabled = schedule.reminderSettings.soundEnabled;
      _vibrationEnabled = schedule.reminderSettings.vibrationEnabled;
      _criticalityLevel = schedule.reminderSettings.criticalityLevel;
    } else {
      _startDate = DateTime.now();
      _reminderTimes = [const TimeOfDay(hour: 8, minute: 0)]; // Default morning time
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.schedule != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Schedule' : 'New Schedule'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _deleteSchedule,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Schedule',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(theme),
              const SizedBox(height: 24),
              _buildScheduleSection(theme),
              const SizedBox(height: 24),
              _buildReminderSection(theme),
              const SizedBox(height: 24),
              _buildAdvancedSettingsSection(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(isEditing ? 'Update Schedule' : 'Create Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions *',
                hintText: 'e.g., Take with food, twice daily',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Instructions are required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date *',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _startDate != null
                            ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                            : 'Select start date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date (Optional)',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _endDate != null
                            ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                            : 'No end date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule Configuration',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency *',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'as_needed', child: Text('As Needed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _frequency = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_frequency != 'as_needed') ...[
              TextFormField(
                initialValue: _timesPerDay.toString(),
                decoration: InputDecoration(
                  labelText: 'Times per ${_frequency.replaceAll('_', ' ')} *',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  final times = int.tryParse(value);
                  if (times == null || times < 1) {
                    return 'Must be a positive number';
                  }
                  return null;
                },
                onChanged: (value) {
                  final times = int.tryParse(value);
                  if (times != null && times > 0) {
                    setState(() {
                      _timesPerDay = times;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            DropdownButtonFormField<String>(
              value: _mealRelation,
              decoration: const InputDecoration(
                labelText: 'Meal Relation',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'independent', child: Text('Independent of meals')),
                DropdownMenuItem(value: 'before_meal', child: Text('Before meals')),
                DropdownMenuItem(value: 'with_meal', child: Text('With meals')),
                DropdownMenuItem(value: 'after_meal', child: Text('After meals')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _mealRelation = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderSection(ThemeData theme) {
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
                Text(
                  'Reminders',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _remindersEnabled,
                  onChanged: (value) {
                    setState(() {
                      _remindersEnabled = value;
                    });
                  },
                  activeColor: CareCircleDesignTokens.healthGreen,
                ),
              ],
            ),
            if (_remindersEnabled) ...[
              const SizedBox(height: 16),
              Text(
                'Reminder Times',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ..._reminderTimes.asMap().entries.map((entry) {
                final index = entry.key;
                final time = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, index),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            child: Text(time.format(context)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _reminderTimes.length > 1
                            ? () => _removeReminderTime(index)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _addReminderTime,
                icon: const Icon(Icons.add),
                label: const Text('Add Reminder Time'),
                style: TextButton.styleFrom(
                  foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettingsSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            if (_remindersEnabled) ...[
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _advanceMinutes.toString(),
                decoration: const InputDecoration(
                  labelText: 'Advance Notice (minutes)',
                  hintText: 'Minutes before dose time',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final minutes = int.tryParse(value);
                  if (minutes != null && minutes >= 0) {
                    setState(() {
                      _advanceMinutes = minutes;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _criticalityLevel,
                decoration: const InputDecoration(
                  labelText: 'Priority Level',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low Priority')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium Priority')),
                  DropdownMenuItem(value: 'high', child: Text('High Priority')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _criticalityLevel = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Sound'),
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Vibration'),
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Clear end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTimes[index],
    );

    if (picked != null) {
      setState(() {
        _reminderTimes[index] = picked;
      });
    }
  }

  void _addReminderTime() {
    setState(() {
      _reminderTimes.add(const TimeOfDay(hour: 8, minute: 0));
    });
  }

  void _removeReminderTime(int index) {
    if (_reminderTimes.length > 1) {
      setState(() {
        _reminderTimes.removeAt(index);
      });
    }
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isEditing = widget.schedule != null;

      _logger.info('Saving medication schedule', {
        'operation': isEditing ? 'updateSchedule' : 'createSchedule',
        'medicationId': widget.medicationId,
        'frequency': _frequency,
        'remindersEnabled': _remindersEnabled,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Create schedule request
      final scheduleRequest = CreateScheduleRequest(
        medicationId: widget.medicationId,
        instructions: _instructionsController.text.trim(),
        remindersEnabled: _remindersEnabled,
        startDate: _startDate!,
        endDate: _endDate,
        schedule: DosageSchedule(
          frequency: _frequency,
          times: _timesPerDay,
          daysOfWeek: _frequency == 'weekly' ? _selectedDaysOfWeek : null,
          specificTimes: _reminderTimes.map((time) =>
            Time(hour: time.hour, minute: time.minute)
          ).toList(),
          mealRelation: _mealRelation,
        ),
        reminderTimes: _reminderTimes.map((time) =>
          Time(hour: time.hour, minute: time.minute)
        ).toList(),
        reminderSettings: ReminderSettings(
          advanceMinutes: _advanceMinutes,
          repeatMinutes: 15,
          maxReminders: 3,
          soundEnabled: _soundEnabled,
          vibrationEnabled: _vibrationEnabled,
          criticalityLevel: _criticalityLevel,
        ),
      );

      if (isEditing) {
        await ref.read(scheduleUpdateProvider.notifier).updateSchedule(
          widget.schedule!.id,
          scheduleRequest,
        );
      } else {
        await ref.read(scheduleCreateProvider.notifier).createSchedule(scheduleRequest);
      }

      if (mounted) {
        _logger.info('Schedule saved successfully', {
          'operation': isEditing ? 'updateSchedule' : 'createSchedule',
          'medicationId': widget.medicationId,
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Schedule updated successfully' : 'Schedule created successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );

        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      _logger.error('Failed to save schedule', {
        'operation': widget.schedule != null ? 'updateSchedule' : 'createSchedule',
        'medicationId': widget.medicationId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save schedule: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteSchedule() async {
    if (widget.schedule == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text('Are you sure you want to delete this schedule? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.criticalAlert,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        _logger.info('Deleting medication schedule', {
          'operation': 'deleteSchedule',
          'scheduleId': widget.schedule!.id,
          'medicationId': widget.medicationId,
          'timestamp': DateTime.now().toIso8601String(),
        });

        await ref.read(scheduleDeleteProvider.notifier).deleteSchedule(widget.schedule!.id);

        if (mounted) {
          _logger.info('Schedule deleted successfully', {
            'operation': 'deleteSchedule',
            'scheduleId': widget.schedule!.id,
            'timestamp': DateTime.now().toIso8601String(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Schedule deleted successfully'),
              backgroundColor: CareCircleDesignTokens.healthGreen,
            ),
          );

          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        _logger.error('Failed to delete schedule', {
          'operation': 'deleteSchedule',
          'scheduleId': widget.schedule!.id,
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete schedule: ${e.toString()}'),
              backgroundColor: CareCircleDesignTokens.criticalAlert,
            ),
          );
        }
      }
    }
  }
}
