import 'package:flutter/material.dart';
import '../config/service_locator.dart';
import '../utils/notification_manager.dart';
import '../common/logging/app_logger.dart';

/// Screen for setting up daily check-in reminders
class CheckinReminderSetupScreen extends StatefulWidget {
  const CheckinReminderSetupScreen({super.key});

  @override
  State<CheckinReminderSetupScreen> createState() =>
      _CheckinReminderSetupScreenState();
}

class _CheckinReminderSetupScreenState
    extends State<CheckinReminderSetupScreen> {
  bool _enableReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String _selectedFrequency = 'Daily';
  bool _isLoading = false;

  final List<String> _frequencies = [
    'Daily',
    'Weekdays Only',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in Reminders'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade700,
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
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Daily Check-in Reminders',
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
              'Set up reminders to complete your daily health check-ins. '
              'Regular check-ins help track your health patterns and keep your care team informed.',
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
            const Icon(Icons.notifications_active),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Get notified when it\'s time for your daily check-in',
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
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 16),
                    Text(
                      _reminderTime.format(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right),
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
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._frequencies.map((frequency) {
              return RadioListTile<String>(
                title: Text(frequency),
                subtitle: Text(_getFrequencyDescription(frequency)),
                value: frequency,
                groupValue: _selectedFrequency,
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Reminder Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Daily Health Check-in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Time for your daily health check-in',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scheduled: ${_getScheduleDescription()}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
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
        onPressed: _isLoading ? null : _saveReminderSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Saving...'),
                ],
              )
            : const Text(
                'Save Reminder Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  String _getFrequencyDescription(String frequency) {
    switch (frequency) {
      case 'Daily':
        return 'Every day including weekends';
      case 'Weekdays Only':
        return 'Monday through Friday only';
      case 'Custom':
        return 'Choose specific days';
      default:
        return '';
    }
  }

  String _getScheduleDescription() {
    final timeStr = _reminderTime.format(context);
    switch (_selectedFrequency) {
      case 'Daily':
        return 'Every day at $timeStr';
      case 'Weekdays Only':
        return 'Weekdays at $timeStr';
      case 'Custom':
        return 'Custom schedule at $timeStr';
      default:
        return 'At $timeStr';
    }
  }

  Future<void> _saveReminderSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notificationManager = ServiceLocator.get<NotificationManager>();
      final logger = ServiceLocator.get<AppLogger>();

      if (_enableReminders) {
        // Calculate next reminder time
        final now = DateTime.now();
        final reminderDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _reminderTime.hour,
          _reminderTime.minute,
        );

        // If the time has passed today, schedule for tomorrow
        final scheduledTime = reminderDateTime.isBefore(now)
            ? reminderDateTime.add(const Duration(days: 1))
            : reminderDateTime;

        // Schedule the reminder
        await notificationManager.scheduleCheckInReminder(
          checkInType: 'daily',
          scheduledTime: scheduledTime,
        );

        logger.info('Daily check-in reminder scheduled', data: {
          'time': _reminderTime.format(context),
          'frequency': _selectedFrequency,
          'scheduledTime': scheduledTime.toIso8601String(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _enableReminders
                  ? 'Daily check-in reminders have been set up!'
                  : 'Daily check-in reminders have been disabled.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save reminder settings: $e'),
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
