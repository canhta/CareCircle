import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/notification_providers.dart';
import '../widgets/preference_section.dart';
import '../widgets/quiet_hours_setting.dart';

/// Notification Preferences Screen
///
/// Allows users to configure their notification preferences:
/// - Global notification toggle
/// - Per-type notification settings
/// - Per-channel preferences
/// - Quiet hours configuration
/// - Do not disturb settings
class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  final _logger = BoundedContextLoggers.notification;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Log screen access
    _logger.info('Notification preferences accessed', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareCircleDesignTokens.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      foregroundColor: Colors.white,
      title: const Text(
        'Notification Settings',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      actions: [
        TextButton(
          onPressed: _resetToDefaults,
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final preferencesAsync = ref.watch(notificationPreferencesNotifierProvider);

    return preferencesAsync.when(
      data: (preferences) => _buildPreferencesContent(preferences),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading preferences...',
            style: TextStyle(
              fontSize: 16,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: CareCircleDesignTokens.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                ref.refresh(notificationPreferencesNotifierProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesContent(NotificationPreferences preferences) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGlobalSettings(preferences),
          const SizedBox(height: 24),
          _buildNotificationTypes(preferences),
          const SizedBox(height: 24),
          _buildChannelSettings(preferences),
          const SizedBox(height: 24),
          _buildQuietHoursSection(preferences),
          const SizedBox(height: 24),
          _buildEmergencySettings(preferences),
          const SizedBox(height: 24),
          _buildAdvancedSettings(preferences),
        ],
      ),
    );
  }

  Widget _buildGlobalSettings(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'General',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text(
            'Enable Notifications',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Receive all notifications from CareCircle'),
          value: preferences.globalEnabled,
          onChanged: _isLoading ? null : (value) => _updateGlobalEnabled(value),
          activeColor: CareCircleDesignTokens.primaryMedicalBlue,
        ),
        const Divider(height: 1),
        SwitchListTile(
          title: const Text(
            'Do Not Disturb',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            preferences.doNotDisturbEnabled
                ? 'Active until manually disabled'
                : 'Temporarily disable all notifications',
          ),
          value: preferences.doNotDisturbEnabled,
          onChanged: preferences.globalEnabled && !_isLoading
              ? (value) => _updateDoNotDisturb(value)
              : null,
          activeColor: CareCircleDesignTokens.warningOrange,
        ),
      ],
    );
  }

  Widget _buildNotificationTypes(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'Notification Types',
      icon: Icons.category,
      children: [
        ...ContextType.values.map((contextType) {
          final preference = _getPreferenceForContext(preferences, contextType);
          return Column(
            children: [
              SwitchListTile(
                title: Text(
                  _getContextDisplayName(contextType),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_getContextDescription(contextType)),
                value: preference?.enabled ?? true,
                onChanged: preferences.globalEnabled && !_isLoading
                    ? (value) => _updateContextPreference(contextType, value)
                    : null,
                activeColor: _getContextColor(contextType),
                secondary: Icon(
                  _getContextIcon(contextType),
                  color: _getContextColor(contextType),
                ),
              ),
              if (contextType != ContextType.values.last)
                const Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildChannelSettings(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'Delivery Channels',
      icon: Icons.send,
      children: [
        ...NotificationChannel.values
            .map((channel) {
              if (channel == NotificationChannel.sms) {
                // Skip SMS as it's not implemented in this phase
                return const SizedBox.shrink();
              }

              final isEnabled = _isChannelEnabled(preferences, channel);
              return Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      _getChannelDisplayName(channel),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(_getChannelDescription(channel)),
                    value: isEnabled,
                    onChanged: preferences.globalEnabled && !_isLoading
                        ? (value) => _updateChannelPreference(channel, value)
                        : null,
                    activeColor: CareCircleDesignTokens.primaryMedicalBlue,
                    secondary: Icon(
                      _getChannelIcon(channel),
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                  if (channel != NotificationChannel.inApp)
                    const Divider(height: 1),
                ],
              );
            })
            .where((widget) => widget is! SizedBox),
      ],
    );
  }

  Widget _buildQuietHoursSection(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'Quiet Hours',
      icon: Icons.bedtime,
      children: [
        QuietHoursSetting(
          quietHours: preferences.quietHours,
          onChanged: _isLoading ? null : _updateQuietHours,
        ),
      ],
    );
  }

  Widget _buildEmergencySettings(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'Emergency Alerts',
      icon: Icons.emergency,
      children: [
        SwitchListTile(
          title: const Text(
            'Emergency Notifications',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Always receive critical health alerts'),
          value: preferences.emergencySettings.enabled,
          onChanged: _isLoading
              ? null
              : (value) => _updateEmergencyEnabled(value),
          activeColor: CareCircleDesignTokens.errorRed,
        ),
        const Divider(height: 1),
        SwitchListTile(
          title: const Text(
            'Override Quiet Hours',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Emergency alerts bypass quiet hours'),
          value: preferences.emergencySettings.overrideQuietHours,
          onChanged: preferences.emergencySettings.enabled && !_isLoading
              ? (value) => _updateEmergencyOverride(value)
              : null,
          activeColor: CareCircleDesignTokens.errorRed,
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text(
            'Emergency Contacts',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${preferences.emergencySettings.emergencyContacts.length} contacts configured',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push('/notifications/emergency-contacts'),
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings(NotificationPreferences preferences) {
    return PreferenceSection(
      title: 'Advanced',
      icon: Icons.settings,
      children: [
        ListTile(
          title: const Text(
            'Notification History',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('View and manage notification history'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => context.push('/notifications/history'),
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text(
            'Test Notification',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Send a test notification'),
          trailing: const Icon(Icons.send, size: 16),
          onTap: _sendTestNotification,
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text(
            'Reset to Defaults',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.errorRed,
            ),
          ),
          subtitle: const Text('Reset all notification preferences'),
          trailing: const Icon(
            Icons.restore,
            size: 16,
            color: CareCircleDesignTokens.errorRed,
          ),
          onTap: _resetToDefaults,
        ),
      ],
    );
  }

  // Helper methods for getting preference data
  NotificationPreference? _getPreferenceForContext(
    NotificationPreferences preferences,
    ContextType contextType,
  ) {
    return preferences.preferences
            .where((p) => p.contextType == contextType)
            .isNotEmpty
        ? preferences.preferences.firstWhere(
            (p) => p.contextType == contextType,
          )
        : null;
  }

  bool _isChannelEnabled(
    NotificationPreferences preferences,
    NotificationChannel channel,
  ) {
    // Check if any context has this channel enabled
    return preferences.preferences
        .where((p) => p.channel == channel && p.enabled)
        .isNotEmpty;
  }

  // Update methods
  Future<void> _updateGlobalEnabled(bool enabled) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .toggleGlobalNotifications(enabled);
    } catch (e) {
      _showErrorSnackBar('Failed to update global settings: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDoNotDisturb(bool enabled) async {
    setState(() => _isLoading = true);
    try {
      final request = UpdateNotificationPreferencesRequest(
        globalEnabled: enabled,
      );
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .updatePreferences(request);
    } catch (e) {
      _showErrorSnackBar('Failed to update do not disturb: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateContextPreference(
    ContextType contextType,
    bool enabled,
  ) async {
    try {
      final notifier = ref.read(
        notificationPreferencesNotifierProvider.notifier,
      );
      await notifier.updateContextPreference(contextType, enabled);

      _logger.info('Context preference updated successfully', {
        'contextType': contextType.name,
        'enabled': enabled,
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              enabled
                  ? '${contextType.displayName} notifications enabled'
                  : '${contextType.displayName} notifications disabled',
            ),
            backgroundColor: enabled
                ? CareCircleDesignTokens.healthGreen
                : CareCircleDesignTokens.criticalAlert,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.error('Context preference update failed', {
        'contextType': contextType.name,
        'enabled': enabled,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update ${contextType.displayName} preferences',
            ),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _updateChannelPreference(
    NotificationChannel channel,
    bool enabled,
  ) async {
    _logger.info('Channel preference update requested', {
      'channel': channel.name,
      'enabled': enabled,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      setState(() => _isLoading = true);

      // Update channel preference through the provider
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .updateChannelPreference(channel, enabled);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_getChannelDisplayName(channel)} notifications ${enabled ? 'enabled' : 'disabled'}',
            ),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to update channel preference', {
        'channel': channel.name,
        'enabled': enabled,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update ${_getChannelDisplayName(channel)} preferences',
            ),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateQuietHours(QuietHoursSettings quietHours) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .updateQuietHours(quietHours);
    } catch (e) {
      _showErrorSnackBar('Failed to update quiet hours: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmergencyEnabled(bool enabled) async {
    setState(() => _isLoading = true);
    try {
      final currentPrefs = ref
          .read(notificationPreferencesNotifierProvider)
          .value;
      if (currentPrefs != null) {
        final updatedSettings = currentPrefs.emergencySettings.copyWith(
          enabled: enabled,
        );
        await ref
            .read(notificationPreferencesNotifierProvider.notifier)
            .updateEmergencySettings(updatedSettings);
      }
    } catch (e) {
      _showErrorSnackBar(
        'Failed to update emergency settings: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmergencyOverride(bool override) async {
    setState(() => _isLoading = true);
    try {
      final currentPrefs = ref
          .read(notificationPreferencesNotifierProvider)
          .value;
      if (currentPrefs != null) {
        final updatedSettings = currentPrefs.emergencySettings.copyWith(
          overrideQuietHours: override,
        );
        await ref
            .read(notificationPreferencesNotifierProvider.notifier)
            .updateEmergencySettings(updatedSettings);
      }
    } catch (e) {
      _showErrorSnackBar(
        'Failed to update emergency override: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sendTestNotification() async {
    try {
      _logger.info('Test notification requested', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Send test notification through the FCM service
      final fcmService = ref.read(fcmServiceProvider);
      await fcmService.showLocalNotification(
        title: 'CareCircle Test',
        body:
            'This is a test notification to verify your settings are working correctly.',
        payload: 'test_notification',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Test notification sent successfully!'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      _logger.error('Test notification failed', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to send test notification'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'This will reset all notification preferences to their default values. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performReset();
            },
            style: TextButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.errorRed,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _performReset() async {
    _logger.info('Reset to defaults requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      setState(() => _isLoading = true);

      // Reset preferences to defaults through the provider
      await ref
          .read(notificationPreferencesNotifierProvider.notifier)
          .resetToDefaults();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences reset to defaults successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to reset preferences to defaults', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset preferences: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CareCircleDesignTokens.errorRed,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Helper methods for display names and descriptions
  String _getContextDisplayName(ContextType contextType) {
    switch (contextType) {
      case ContextType.medication:
        return 'Medication Reminders';
      case ContextType.healthData:
        return 'Health Alerts';
      case ContextType.careGroup:
        return 'Care Group Updates';
      case ContextType.appointment:
        return 'Appointment Reminders';
      case ContextType.system:
        return 'System Notifications';
      case ContextType.emergency:
        return 'Emergency Alerts';
    }
  }

  String _getContextDescription(ContextType contextType) {
    switch (contextType) {
      case ContextType.medication:
        return 'Medication doses, refill reminders, and adherence alerts';
      case ContextType.healthData:
        return 'Vital signs alerts and health metric notifications';
      case ContextType.careGroup:
        return 'Care team updates, task assignments, and group activities';
      case ContextType.appointment:
        return 'Upcoming appointments and scheduling changes';
      case ContextType.system:
        return 'App updates, maintenance, and general information';
      case ContextType.emergency:
        return 'Critical health alerts and emergency notifications';
    }
  }

  IconData _getContextIcon(ContextType contextType) {
    switch (contextType) {
      case ContextType.medication:
        return Icons.medication;
      case ContextType.healthData:
        return Icons.health_and_safety;
      case ContextType.careGroup:
        return Icons.group;
      case ContextType.appointment:
        return Icons.calendar_today;
      case ContextType.system:
        return Icons.settings;
      case ContextType.emergency:
        return Icons.emergency;
    }
  }

  Color _getContextColor(ContextType contextType) {
    switch (contextType) {
      case ContextType.medication:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case ContextType.healthData:
        return CareCircleDesignTokens.successGreen;
      case ContextType.careGroup:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case ContextType.appointment:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case ContextType.system:
        return CareCircleDesignTokens.textSecondary;
      case ContextType.emergency:
        return CareCircleDesignTokens.errorRed;
    }
  }

  String _getChannelDisplayName(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.push:
        return 'Push Notifications';
      case NotificationChannel.email:
        return 'Email Notifications';
      case NotificationChannel.sms:
        return 'SMS Notifications';
      case NotificationChannel.inApp:
        return 'In-App Notifications';
    }
  }

  String _getChannelDescription(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.push:
        return 'Receive notifications on your device';
      case NotificationChannel.email:
        return 'Receive notifications via email';
      case NotificationChannel.sms:
        return 'Receive notifications via text message';
      case NotificationChannel.inApp:
        return 'Show notifications within the app';
    }
  }

  IconData _getChannelIcon(NotificationChannel channel) {
    switch (channel) {
      case NotificationChannel.push:
        return Icons.notifications;
      case NotificationChannel.email:
        return Icons.email;
      case NotificationChannel.sms:
        return Icons.sms;
      case NotificationChannel.inApp:
        return Icons.app_registration;
    }
  }
}
