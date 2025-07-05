import 'package:flutter/material.dart';
import '../config/service_locator.dart';
import '../common/logging/app_logger.dart';
import '../utils/notification_manager.dart';

class ExerciseReminderSetupScreen extends StatefulWidget {
  const ExerciseReminderSetupScreen({super.key});

  @override
  State<ExerciseReminderSetupScreen> createState() => _ExerciseReminderSetupScreenState();
}

class _ExerciseReminderSetupScreenState extends State<ExerciseReminderSetupScreen> {
  bool _enableReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedFrequency = 'Daily';
  List<String> _selectedDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  String _selectedExerciseType = 'Any Exercise';
  int _targetDuration = 30;
  bool _isLoading = false;

  final List<String> _frequencies = [
    'Daily',
    'Weekdays Only',
    'Custom Days',
  ];

  final List<String> _weekDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> _exerciseTypes = [
    'Any Exercise',
    'Walking',
    'Running',
    'Cycling',
    'Swimming',
    'Strength Training',
    'Yoga',
    'Stretching',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Reminders'),
        backgroundColor: Colors.purple.shade50,
        foregroundColor: Colors.purple.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildReminderToggle(),
            if (_enableReminders) ...[
              const SizedBox(height: 24),
              _buildTimeSelector(),
              const SizedBox(height: 24),
              _buildFrequencySelector(),
              if (_selectedFrequency == 'Custom Days') ...[
                const SizedBox(height: 16),
                _buildDaySelector(),
              ],
              const SizedBox(height: 24),
              _buildExerciseTypeSelector(),
              const SizedBox(height: 24),
              _buildDurationSelector(),
              const SizedBox(height: 24),
              _buildPreviewCard(),
            ],
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.purple.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Exercise Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Stay active and healthy with personalized exercise reminders. '
              'Set up notifications to help you maintain a consistent fitness routine.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: _enableReminders ? Colors.purple : Colors.grey,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable Exercise Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Get motivated to stay active',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _enableReminders,
              onChanged: (value) {
                setState(() {
                  _enableReminders = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reminder Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12),
                    Text(
                      _reminderTime.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedFrequency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _frequencies.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedFrequency = value;
                    if (value == 'Weekdays Only') {
                      _selectedDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
                    } else if (value == 'Daily') {
                      _selectedDays = List.from(_weekDays);
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _weekDays.map((day) {
                final isSelected = _selectedDays.contains(day);
                return FilterChip(
                  label: Text(day.substring(0, 3)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exercise Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedExerciseType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _exerciseTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedExerciseType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target Duration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _targetDuration.toDouble(),
                    min: 10,
                    max: 120,
                    divisions: 11,
                    label: '$_targetDuration minutes',
                    onChanged: (value) {
                      setState(() {
                        _targetDuration = value.round();
                      });
                    },
                  ),
                ),
                Text(
                  '$_targetDuration min',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    String frequencyText = _selectedFrequency == 'Custom Days' 
        ? _selectedDays.join(', ')
        : _selectedFrequency.toLowerCase();
    
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Colors.purple.shade700,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Reminder Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'You will receive $_selectedExerciseType reminders at ${_reminderTime.format(context)} on $frequencyText.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Target: $_targetDuration minutes of activity',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
            : const Text(
                'Save Exercise Reminders',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (selectedTime != null) {
      setState(() {
        _reminderTime = selectedTime;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final logger = ServiceLocator.get<AppLogger>();
      final notificationManager = ServiceLocator.get<NotificationManager>();

      if (_enableReminders) {
        logger.info('Exercise reminder settings saved', data: {
          'enabled': _enableReminders,
          'time': _reminderTime.format(context),
          'frequency': _selectedFrequency,
          'days': _selectedDays,
          'exerciseType': _selectedExerciseType,
          'targetDuration': _targetDuration,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exercise reminder settings saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        logger.info('Exercise reminders disabled');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exercise reminders disabled'),
              backgroundColor: Colors.purple,
            ),
          );
        }
      }

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      final logger = ServiceLocator.get<AppLogger>();
      logger.error('Failed to save exercise reminder settings', error: e);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save settings. Please try again.'),
            backgroundColor: Colors.red,
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
}
