import 'package:flutter/material.dart';
import '../config/service_locator.dart';
import '../common/logging/app_logger.dart';

class AppointmentReminderSetupScreen extends StatefulWidget {
  const AppointmentReminderSetupScreen({super.key});

  @override
  State<AppointmentReminderSetupScreen> createState() =>
      _AppointmentReminderSetupScreenState();
}

class _AppointmentReminderSetupScreenState
    extends State<AppointmentReminderSetupScreen> {
  bool _enableReminders = true;
  String _selectedAdvanceTime = '1 hour';
  bool _enableSecondReminder = false;
  String _selectedSecondAdvanceTime = '1 day';
  bool _isLoading = false;

  final List<String> _advanceTimes = [
    '15 minutes',
    '30 minutes',
    '1 hour',
    '2 hours',
    '1 day',
    '2 days',
    '1 week',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Reminders'),
        backgroundColor: Colors.orange.shade50,
        foregroundColor: Colors.orange.shade700,
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
              _buildAdvanceTimeSelector(),
              const SizedBox(height: 24),
              _buildSecondReminderSection(),
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
                  Icons.calendar_today,
                  color: Colors.orange.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Appointment Reminders',
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
              'Never miss an important appointment. Set up automatic reminders '
              'that will notify you before your scheduled appointments.',
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
              color: _enableReminders ? Colors.orange : Colors.grey,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enable Appointment Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Get notified before your appointments',
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

  Widget _buildAdvanceTimeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Remind me before appointment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedAdvanceTime,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _advanceTimes.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAdvanceTime = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondReminderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Second Reminder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Get an additional earlier reminder',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _enableSecondReminder,
                  onChanged: (value) {
                    setState(() {
                      _enableSecondReminder = value;
                    });
                  },
                ),
              ],
            ),
            if (_enableSecondReminder) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSecondAdvanceTime,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: 'Second reminder time',
                ),
                items: _advanceTimes.map((time) {
                  return DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSecondAdvanceTime = value;
                    });
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Colors.orange.shade700,
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
              'You will receive a notification $_selectedAdvanceTime before each appointment.',
              style: const TextStyle(fontSize: 14),
            ),
            if (_enableSecondReminder) ...[
              const SizedBox(height: 8),
              Text(
                'You will also receive an earlier reminder $_selectedSecondAdvanceTime before each appointment.',
                style: const TextStyle(fontSize: 14),
              ),
            ],
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
          backgroundColor: Colors.orange,
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
                'Save Reminder Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final logger = ServiceLocator.get<AppLogger>();

      if (_enableReminders) {
        // Save appointment reminder preferences
        // This would typically save to user preferences or backend
        logger.info('Appointment reminder settings saved', data: {
          'enabled': _enableReminders,
          'advanceTime': _selectedAdvanceTime,
          'secondReminderEnabled': _enableSecondReminder,
          'secondAdvanceTime': _selectedSecondAdvanceTime,
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Appointment reminder settings saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Disable appointment reminders
        logger.info('Appointment reminders disabled');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment reminders disabled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      // Navigate back after a short delay
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      final logger = ServiceLocator.get<AppLogger>();
      logger.error('Failed to save appointment reminder settings', error: e);

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
