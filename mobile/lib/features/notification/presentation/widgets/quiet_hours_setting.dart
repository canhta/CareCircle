import 'package:flutter/material.dart';

import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';

/// Quiet hours setting widget
///
/// Allows users to configure quiet hours settings:
/// - Enable/disable quiet hours
/// - Set start and end times
/// - Select active days
/// - Configure allowed notification types during quiet hours
class QuietHoursSetting extends StatefulWidget {
  final QuietHoursSettings quietHours;
  final ValueChanged<QuietHoursSettings>? onChanged;

  const QuietHoursSetting({
    super.key,
    required this.quietHours,
    this.onChanged,
  });

  @override
  State<QuietHoursSetting> createState() => _QuietHoursSettingState();
}

class _QuietHoursSettingState extends State<QuietHoursSetting> {
  late QuietHoursSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.quietHours;
  }

  @override
  void didUpdateWidget(QuietHoursSetting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quietHours != widget.quietHours) {
      _settings = widget.quietHours;
    }
  }

  void _updateSettings(QuietHoursSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.onChanged?.call(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text(
            'Enable Quiet Hours',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            _settings.enabled
                ? 'Notifications will be silenced during quiet hours'
                : 'Receive notifications at all times',
          ),
          value: _settings.enabled,
          onChanged: widget.onChanged != null
              ? (value) => _updateSettings(_settings.copyWith(enabled: value))
              : null,
          activeColor: CareCircleDesignTokens.primaryMedicalBlue,
        ),
        if (_settings.enabled) ...[
          const Divider(height: 1),
          _buildTimeSettings(),
          const Divider(height: 1),
          _buildDaySettings(),
          const Divider(height: 1),
          _buildAllowedTypesSettings(),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'Allow Emergency Alerts',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Emergency alerts will bypass quiet hours',
            ),
            value: _settings.allowEmergencyAlerts,
            onChanged: widget.onChanged != null
                ? (value) => _updateSettings(
                    _settings.copyWith(allowEmergencyAlerts: value))
                : null,
            activeColor: CareCircleDesignTokens.errorRed,
          ),
        ],
      ],
    );
  }

  Widget _buildTimeSettings() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Quiet Hours Time',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${_settings.startTime} - ${_settings.endTime}',
            style: TextStyle(
              color: CareCircleDesignTokens.primaryMedicalBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.access_time),
          onTap: _showTimeRangePicker,
        ),
      ],
    );
  }

  Widget _buildDaySettings() {
    return ExpansionTile(
      title: const Text(
        'Active Days',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _settings.activeDaysText,
        style: TextStyle(
          color: CareCircleDesignTokens.primaryMedicalBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildQuickDaySelections(),
              const SizedBox(height: 16),
              _buildDayCheckboxes(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDaySelections() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _selectDays([1, 2, 3, 4, 5]), // Weekdays
            style: OutlinedButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              side: BorderSide(color: CareCircleDesignTokens.primaryMedicalBlue),
            ),
            child: const Text('Weekdays'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _selectDays([0, 6]), // Weekends
            style: OutlinedButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              side: BorderSide(color: CareCircleDesignTokens.primaryMedicalBlue),
            ),
            child: const Text('Weekends'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _selectDays([0, 1, 2, 3, 4, 5, 6]), // Every day
            style: OutlinedButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              side: BorderSide(color: CareCircleDesignTokens.primaryMedicalBlue),
            ),
            child: const Text('Every Day'),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCheckboxes() {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (index) {
        final isSelected = _settings.activeDays.contains(index);
        return FilterChip(
          label: Text(dayNames[index]),
          selected: isSelected,
          onSelected: (selected) {
            final newActiveDays = List<int>.from(_settings.activeDays);
            if (selected) {
              newActiveDays.add(index);
            } else {
              newActiveDays.remove(index);
            }
            newActiveDays.sort();
            _updateSettings(_settings.copyWith(activeDays: newActiveDays));
          },
          selectedColor: CareCircleDesignTokens.primaryMedicalBlue.withOpacity(0.2),
          checkmarkColor: CareCircleDesignTokens.primaryMedicalBlue,
        );
      }),
    );
  }

  Widget _buildAllowedTypesSettings() {
    return ExpansionTile(
      title: const Text(
        'Allowed Notifications',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _settings.allowedTypes.isEmpty
            ? 'No notifications allowed'
            : '${_settings.allowedTypes.length} type${_settings.allowedTypes.length != 1 ? 's' : ''} allowed',
        style: TextStyle(
          color: CareCircleDesignTokens.primaryMedicalBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select notification types that can bypass quiet hours:',
                style: TextStyle(
                  fontSize: 14,
                  color: CareCircleDesignTokens.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ...NotificationType.values
                  .where((type) => type != NotificationType.emergencyAlert)
                  .map((type) => CheckboxListTile(
                        title: Text(type.displayName),
                        subtitle: Text(_getTypeDescription(type)),
                        value: _settings.allowedTypes.contains(type),
                        onChanged: (checked) {
                          final newAllowedTypes = List<NotificationType>.from(_settings.allowedTypes);
                          if (checked == true) {
                            newAllowedTypes.add(type);
                          } else {
                            newAllowedTypes.remove(type);
                          }
                          _updateSettings(_settings.copyWith(allowedTypes: newAllowedTypes));
                        },
                        activeColor: CareCircleDesignTokens.primaryMedicalBlue,
                        dense: true,
                      )),
            ],
          ),
        ),
      ],
    );
  }

  void _selectDays(List<int> days) {
    _updateSettings(_settings.copyWith(activeDays: days));
  }

  void _showTimeRangePicker() {
    showDialog(
      context: context,
      builder: (context) => _TimeRangePickerDialog(
        startTime: _settings.startTime,
        endTime: _settings.endTime,
        onTimeRangeSelected: (startTime, endTime) {
          _updateSettings(_settings.copyWith(
            startTime: startTime,
            endTime: endTime,
          ));
        },
      ),
    );
  }

  String _getTypeDescription(NotificationType type) {
    switch (type) {
      case NotificationType.medicationReminder:
        return 'Medication doses and refill reminders';
      case NotificationType.healthAlert:
        return 'Health monitoring alerts';
      case NotificationType.appointmentReminder:
        return 'Upcoming appointments';
      case NotificationType.taskReminder:
        return 'Care tasks and activities';
      case NotificationType.careGroupUpdate:
        return 'Care team updates';
      case NotificationType.systemNotification:
        return 'App updates and information';
      case NotificationType.emergencyAlert:
        return 'Critical health emergencies';
    }
  }
}

/// Time range picker dialog
class _TimeRangePickerDialog extends StatefulWidget {
  final String startTime;
  final String endTime;
  final Function(String startTime, String endTime) onTimeRangeSelected;

  const _TimeRangePickerDialog({
    required this.startTime,
    required this.endTime,
    required this.onTimeRangeSelected,
  });

  @override
  State<_TimeRangePickerDialog> createState() => _TimeRangePickerDialogState();
}

class _TimeRangePickerDialogState extends State<_TimeRangePickerDialog> {
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime;
    _endTime = widget.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Quiet Hours'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Time'),
            subtitle: Text(_startTime),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(true),
          ),
          ListTile(
            title: const Text('End Time'),
            subtitle: Text(_endTime),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(false),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.primaryMedicalBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Notifications will be silenced from $_startTime to $_endTime',
                    style: TextStyle(
                      fontSize: 12,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onTimeRangeSelected(_startTime, _endTime);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _selectTime(bool isStartTime) async {
    final currentTime = isStartTime ? _startTime : _endTime;
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }
}
