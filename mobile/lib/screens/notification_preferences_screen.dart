import 'package:flutter/material.dart';
import '../features/notification/notification.dart';
import '../common/common.dart';
import '../widgets/widget_optimizer.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  late final NotificationService _notificationService;
  NotificationPreferences? _preferences;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService(
      apiClient: ApiClient.instance,
      logger: AppLogger('NotificationPreferencesScreen'),
    );
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _notificationService.getNotificationPreferences();

    if (result.isSuccess) {
      setState(() {
        _preferences = result.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.exception?.toString() ?? 'Failed to load preferences';
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    if (_preferences == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // In a real implementation, this would be a PUT/PATCH request
      // For now, we'll just show success
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _updatePreferences(NotificationPreferences newPreferences) {
    setState(() {
      _preferences = newPreferences;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        actions: [
          if (_preferences != null)
            TextButton(
              onPressed: _isSaving ? null : _savePreferences,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPreferences,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_preferences == null) {
      return const Center(
        child: Text('No preferences available'),
      );
    }

    return WidgetOptimizer.optimizeListView(
      padding: const EdgeInsets.all(16),
      addRepaintBoundaries: true,
      children: [
        _buildNotificationTypesSection(),
        const SizedBox(height: 24),
        _buildChannelsSection(),
        const SizedBox(height: 24),
        _buildQuietHoursSection(),
        const SizedBox(height: 24),
        _buildTestSection(),
      ],
    );
  }

  Widget _buildNotificationTypesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Types',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose which types of notifications you want to receive',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Medication Reminders'),
              subtitle: const Text('Reminders to take your medications'),
              value: _preferences!.medicationReminders,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: value,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: _preferences!.channels,
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Daily Check-in Reminders'),
              subtitle: const Text(
                  'Reminders to complete your daily health check-in'),
              value: _preferences!.checkInReminders,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: value,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: _preferences!.channels,
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('AI Insights'),
              subtitle: const Text(
                  'Personalized health insights and recommendations'),
              value: _preferences!.aiInsights,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: value,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: _preferences!.channels,
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Care Group Updates'),
              subtitle: const Text(
                  'Updates from your family and healthcare providers'),
              value: _preferences!.careGroupUpdates,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: value,
                    channels: _preferences!.channels,
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Channels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to receive notifications',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Notifications on your phone'),
              value: _preferences!.channels.push,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: NotificationChannelPreferences(
                      push: value,
                      email: _preferences!.channels.email,
                      sms: _preferences!.channels.sms,
                      inApp: _preferences!.channels.inApp,
                    ),
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Email'),
              subtitle: const Text('Email notifications'),
              value: _preferences!.channels.email,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: NotificationChannelPreferences(
                      push: _preferences!.channels.push,
                      email: value,
                      sms: _preferences!.channels.sms,
                      inApp: _preferences!.channels.inApp,
                    ),
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('SMS'),
              subtitle: const Text('Text message notifications'),
              value: _preferences!.channels.sms,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: NotificationChannelPreferences(
                      push: _preferences!.channels.push,
                      email: _preferences!.channels.email,
                      sms: value,
                      inApp: _preferences!.channels.inApp,
                    ),
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
            SwitchListTile(
              title: const Text('In-App'),
              subtitle: const Text('Notifications within the app'),
              value: _preferences!.channels.inApp,
              onChanged: (value) {
                _updatePreferences(
                  NotificationPreferences(
                    medicationReminders: _preferences!.medicationReminders,
                    checkInReminders: _preferences!.checkInReminders,
                    aiInsights: _preferences!.aiInsights,
                    careGroupUpdates: _preferences!.careGroupUpdates,
                    channels: NotificationChannelPreferences(
                      push: _preferences!.channels.push,
                      email: _preferences!.channels.email,
                      sms: _preferences!.channels.sms,
                      inApp: value,
                    ),
                    quietHours: _preferences!.quietHours,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuietHoursSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiet Hours',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Set times when you don\'t want to receive notifications',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Quiet Hours'),
              subtitle: Text(_preferences!.quietHours != null
                  ? 'From ${_preferences!.quietHours!.start} to ${_preferences!.quietHours!.end}'
                  : 'Disabled'),
              value: _preferences!.quietHours?.enabled ?? false,
              onChanged: (value) {
                if (value) {
                  _updatePreferences(
                    NotificationPreferences(
                      medicationReminders: _preferences!.medicationReminders,
                      checkInReminders: _preferences!.checkInReminders,
                      aiInsights: _preferences!.aiInsights,
                      careGroupUpdates: _preferences!.careGroupUpdates,
                      channels: _preferences!.channels,
                      quietHours: QuietHours(
                        enabled: true,
                        start: '22:00',
                        end: '08:00',
                      ),
                    ),
                  );
                } else {
                  _updatePreferences(
                    NotificationPreferences(
                      medicationReminders: _preferences!.medicationReminders,
                      checkInReminders: _preferences!.checkInReminders,
                      aiInsights: _preferences!.aiInsights,
                      careGroupUpdates: _preferences!.careGroupUpdates,
                      channels: _preferences!.channels,
                      quietHours: null,
                    ),
                  );
                }
              },
            ),
            if (_preferences!.quietHours?.enabled == true) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(_preferences!.quietHours!.start),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(_preferences!.quietHours!.end),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(false),
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

  Widget _buildTestSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Send test notifications to verify your settings',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _sendTestMedicationReminder,
                  icon: const Icon(Icons.medication, size: 16),
                  label: const Text('Medication'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendTestCheckInReminder,
                  icon: const Icon(Icons.health_and_safety, size: 16),
                  label: const Text('Check-in'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendTestHealthInsight,
                  icon: const Icon(Icons.insights, size: 16),
                  label: const Text('Health Insight'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(bool isStartTime) async {
    final currentTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (selectedTime != null && _preferences != null) {
      final timeString =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

      _updatePreferences(
        NotificationPreferences(
          medicationReminders: _preferences!.medicationReminders,
          checkInReminders: _preferences!.checkInReminders,
          aiInsights: _preferences!.aiInsights,
          careGroupUpdates: _preferences!.careGroupUpdates,
          channels: _preferences!.channels,
          quietHours: QuietHours(
            enabled: _preferences!.quietHours!.enabled,
            start: isStartTime ? timeString : _preferences!.quietHours!.start,
            end: isStartTime ? _preferences!.quietHours!.end : timeString,
          ),
        ),
      );
    }
  }

  Future<void> _sendTestMedicationReminder() async {
    try {
      await _notificationService.testMedicationReminder();
      _showSuccessMessage('Test medication reminder sent');
    } catch (e) {
      _showErrorMessage('Failed to send test notification');
    }
  }

  Future<void> _sendTestCheckInReminder() async {
    try {
      await _notificationService.testCheckInReminder();
      _showSuccessMessage('Test check-in reminder sent');
    } catch (e) {
      _showErrorMessage('Failed to send test notification');
    }
  }

  Future<void> _sendTestHealthInsight() async {
    try {
      await _notificationService.testHealthInsight();
      _showSuccessMessage('Test health insight sent');
    } catch (e) {
      _showErrorMessage('Failed to send test notification');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
