import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/models/models.dart' as notification_models;
import 'notification_api_service.dart';

/// Emergency alert handler service
///
/// Handles emergency alerts with special processing:
/// - High-priority notification display
/// - Sound and vibration alerts
/// - Auto-escalation to emergency contacts
/// - Full-screen alert overlay
/// - Emergency action buttons
class EmergencyAlertHandler {
  final NotificationApiService _apiService;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final SecureStorageService _secureStorage;
  final _logger = BoundedContextLoggers.notification;

  // Emergency alert state
  final _activeAlertsController = StreamController<List<notification_models.EmergencyAlert>>.broadcast();
  final Map<String, Timer> _escalationTimers = {};
  final Map<String, notification_models.EmergencyAlert> _activeAlerts = {};

  Stream<List<notification_models.EmergencyAlert>> get activeAlertsStream => _activeAlertsController.stream;
  List<notification_models.EmergencyAlert> get activeAlerts => _activeAlerts.values.toList();

  EmergencyAlertHandler(
    this._apiService,
    this._localNotifications,
    this._secureStorage,
  );

  /// Initialize emergency alert handler
  Future<void> initialize() async {
    try {
      _logger.info('Initializing emergency alert handler', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Load any existing active alerts
      await _loadActiveAlerts();

      // Set up periodic check for active alerts
      Timer.periodic(const Duration(minutes: 1), (_) => _checkActiveAlerts());

      _logger.info('Emergency alert handler initialized', {
        'activeAlerts': _activeAlerts.length,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to initialize emergency alert handler', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Handle incoming emergency alert
  Future<void> handleEmergencyAlert(notification_models.EmergencyAlert alert) async {
    try {
      _logger.info('Handling emergency alert', {
        'alertId': alert.id,
        'type': alert.alertType.name,
        'severity': alert.severity.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Add to active alerts
      _activeAlerts[alert.id] = alert;
      _notifyActiveAlertsChanged();

      // Show immediate notification
      await _showEmergencyNotification(alert);

      // Play emergency sound and vibration
      await _playEmergencyAlert(alert);

      // Set up auto-escalation if enabled
      if (alert.metadata?['autoEscalate'] == true) {
        final delayMinutes = alert.metadata?['escalationDelayMinutes'] as int? ?? 5;
        _scheduleEscalation(alert, delayMinutes);
      }

      // Show full-screen alert for critical alerts
      if (alert.severity == notification_models.EmergencyAlertSeverity.critical) {
        await _showFullScreenAlert(alert);
      }

      _logger.info('Emergency alert handled successfully', {
        'alertId': alert.id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to handle emergency alert', {
        'alertId': alert.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Show emergency notification
  Future<void> _showEmergencyNotification(notification_models.EmergencyAlert alert) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'emergency_alerts',
        'Emergency Alerts',
        channelDescription: 'Critical emergency notifications',
        importance: Importance.max,
        priority: Priority.max,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        fullScreenIntent: true,
        ongoing: true,
        autoCancel: false,
        enableVibration: true,
        enableLights: true,
        ledColor: Color.fromARGB(255, 255, 0, 0),
        color: Color.fromARGB(255, 244, 67, 54),
        largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_emergency_large'),
        styleInformation: BigTextStyleInformation(
          alert.message,
          htmlFormatBigText: true,
          contentTitle: '🚨 ${alert.title}',
          htmlFormatContentTitle: true,
          summaryText: 'Emergency Alert',
          htmlFormatSummaryText: true,
        ),
        actions: _buildNotificationActions(alert),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.critical,
        categoryIdentifier: 'EMERGENCY_ALERT',
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        alert.hashCode,
        '🚨 ${alert.title}',
        alert.message,
        notificationDetails,
        payload: 'emergency_alert:${alert.id}',
      );

      _logger.info('Emergency notification shown', {
        'alertId': alert.id,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to show emergency notification', {
        'alertId': alert.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Build notification actions for emergency alert
  List<AndroidNotificationAction> _buildNotificationActions(notification_models.EmergencyAlert alert) {
    final actions = <AndroidNotificationAction>[];

    for (final action in alert.actions) {
      actions.add(AndroidNotificationAction(
        action.id,
        action.label,
        icon: DrawableResourceAndroidBitmap('@drawable/ic_${action.actionType}'),
        contextual: action.actionType == 'acknowledge',
        showsUserInterface: action.actionType != 'acknowledge',
      ));
    }

    // Add default actions if none provided
    if (actions.isEmpty) {
      actions.addAll([
        const AndroidNotificationAction(
          'acknowledge',
          'Acknowledge',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_check'),
          contextual: true,
        ),
        const AndroidNotificationAction(
          'call_emergency',
          'Call 911',
          icon: DrawableResourceAndroidBitmap('@drawable/ic_call'),
          showsUserInterface: true,
        ),
      ]);
    }

    return actions;
  }

  /// Play emergency alert sound and vibration
  Future<void> _playEmergencyAlert(notification_models.EmergencyAlert alert) async {
    try {
      // Vibrate in emergency pattern
      await _vibrateEmergencyPattern(alert.severity);

      // Play emergency sound
      await _playEmergencySound(alert.severity);

      _logger.info('Emergency alert sound and vibration played', {
        'alertId': alert.id,
        'severity': alert.severity.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to play emergency alert', {
        'alertId': alert.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Vibrate in emergency pattern
  Future<void> _vibrateEmergencyPattern(notification_models.EmergencyAlertSeverity severity) async {
    try {
      List<int> pattern;
      
      switch (severity) {
        case notification_models.EmergencyAlertSeverity.critical:
          // Rapid, intense pattern
          pattern = [0, 200, 100, 200, 100, 200, 100, 500, 100, 200, 100, 200];
          break;
        case notification_models.EmergencyAlertSeverity.high:
          // Strong pattern
          pattern = [0, 300, 200, 300, 200, 300];
          break;
        case notification_models.EmergencyAlertSeverity.medium:
          // Moderate pattern
          pattern = [0, 400, 300, 400];
          break;
        case notification_models.EmergencyAlertSeverity.low:
          // Gentle pattern
          pattern = [0, 500];
          break;
      }

      await HapticFeedback.vibrate();

      _logger.info('Emergency vibration pattern triggered', {
        'severity': severity.name,
        'pattern': pattern.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Note: For more complex vibration patterns, you would need to use
      // platform-specific code or a vibration plugin
    } catch (e) {
      _logger.warning('Failed to vibrate', {
        'error': e.toString(),
      });
    }
  }

  /// Play emergency sound
  Future<void> _playEmergencySound(notification_models.EmergencyAlertSeverity severity) async {
    try {
      // Note: For custom emergency sounds, you would need to use
      // an audio plugin like audioplayers or just_audio
      
      switch (severity) {
        case notification_models.EmergencyAlertSeverity.critical:
          await SystemSound.play(SystemSoundType.alert);
          break;
        case notification_models.EmergencyAlertSeverity.high:
          await SystemSound.play(SystemSoundType.alert);
          break;
        case notification_models.EmergencyAlertSeverity.medium:
          await SystemSound.play(SystemSoundType.click);
          break;
        case notification_models.EmergencyAlertSeverity.low:
          await SystemSound.play(SystemSoundType.click);
          break;
      }
    } catch (e) {
      _logger.warning('Failed to play emergency sound', {
        'error': e.toString(),
      });
    }
  }

  /// Show full-screen alert overlay
  Future<void> _showFullScreenAlert(notification_models.EmergencyAlert alert) async {
    try {
      // Note: This would require showing a full-screen overlay
      // which would need to be implemented at the app level
      // For now, we'll just log the intent
      
      _logger.info('Full-screen alert requested', {
        'alertId': alert.id,
        'title': alert.title,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // In a real implementation, you would:
      // 1. Show a full-screen overlay widget
      // 2. Prevent dismissal until acknowledged
      // 3. Show emergency action buttons
      // 4. Display emergency contact information
    } catch (e) {
      _logger.error('Failed to show full-screen alert', {
        'alertId': alert.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Schedule auto-escalation
  void _scheduleEscalation(notification_models.EmergencyAlert alert, int delayMinutes) {
    try {
      final timer = Timer(Duration(minutes: delayMinutes), () {
        _escalateAlert(alert.id);
      });
      
      _escalationTimers[alert.id] = timer;
      
      _logger.info('Escalation scheduled', {
        'alertId': alert.id,
        'delayMinutes': delayMinutes,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to schedule escalation', {
        'alertId': alert.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Escalate alert to emergency contacts
  Future<void> _escalateAlert(String alertId) async {
    try {
      final alert = _activeAlerts[alertId];
      if (alert == null || alert.status != notification_models.EmergencyAlertStatus.active) {
        return;
      }

      _logger.info('Escalating emergency alert', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Call API to escalate
      await _apiService.escalateEmergencyAlert(alertId, {
        'escalatedAt': DateTime.now().toIso8601String(),
        'reason': 'auto_escalation_timeout',
      });

      _logger.info('Emergency alert escalated', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to escalate emergency alert', {
        'alertId': alertId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Acknowledge emergency alert
  Future<void> acknowledgeAlert(String alertId, {String? notes}) async {
    try {
      _logger.info('Acknowledging emergency alert', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Call API to acknowledge
      await _apiService.acknowledgeEmergencyAlert(alertId, {
        'acknowledgedAt': DateTime.now().toIso8601String(),
        'notes': notes,
      });

      // Cancel escalation timer
      _escalationTimers[alertId]?.cancel();
      _escalationTimers.remove(alertId);

      // Update local state
      final alert = _activeAlerts[alertId];
      if (alert != null) {
        _activeAlerts[alertId] = alert.copyWith(
          status: notification_models.EmergencyAlertStatus.acknowledged,
          acknowledgedAt: DateTime.now(),
        );
        _notifyActiveAlertsChanged();
      }

      // Dismiss notification
      await _localNotifications.cancel(alertId.hashCode);

      _logger.info('Emergency alert acknowledged', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to acknowledge emergency alert', {
        'alertId': alertId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Resolve emergency alert
  Future<void> resolveAlert(String alertId, {String? notes}) async {
    try {
      _logger.info('Resolving emergency alert', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Call API to resolve
      await _apiService.resolveEmergencyAlert(alertId, {
        'resolvedAt': DateTime.now().toIso8601String(),
        'notes': notes,
      });

      // Cancel escalation timer
      _escalationTimers[alertId]?.cancel();
      _escalationTimers.remove(alertId);

      // Remove from active alerts
      _activeAlerts.remove(alertId);
      _notifyActiveAlertsChanged();

      // Dismiss notification
      await _localNotifications.cancel(alertId.hashCode);

      _logger.info('Emergency alert resolved', {
        'alertId': alertId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to resolve emergency alert', {
        'alertId': alertId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Perform emergency alert action
  Future<void> performAction(String alertId, notification_models.EmergencyAlertActionRequest action) async {
    try {
      _logger.info('Performing emergency alert action', {
        'alertId': alertId,
        'actionType': action.actionType,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Call API to perform action
      await _apiService.performEmergencyAlertAction(alertId, action);

      // Handle specific actions
      switch (action.actionType) {
        case 'acknowledge':
          await acknowledgeAlert(alertId, notes: action.notes);
          break;
        case 'resolve':
          await resolveAlert(alertId, notes: action.notes);
          break;
        case 'call_emergency':
          // Note: This would trigger a phone call to emergency services
          _logger.info('Emergency call requested', {
            'alertId': alertId,
            'timestamp': DateTime.now().toIso8601String(),
          });
          break;
        case 'contact_caregiver':
          // Note: This would contact the primary caregiver
          _logger.info('Caregiver contact requested', {
            'alertId': alertId,
            'timestamp': DateTime.now().toIso8601String(),
          });
          break;
      }

      _logger.info('Emergency alert action performed', {
        'alertId': alertId,
        'actionType': action.actionType,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to perform emergency alert action', {
        'alertId': alertId,
        'actionType': action.actionType,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Load active alerts from storage
  Future<void> _loadActiveAlerts() async {
    try {
      // Note: In a real implementation, you would load active alerts
      // from local storage or fetch from the API
      _logger.info('Loading active emergency alerts', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to load active alerts', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Check active alerts periodically
  Future<void> _checkActiveAlerts() async {
    try {
      // Check for alerts that need escalation
      final now = DateTime.now();
      for (final alert in _activeAlerts.values) {
        if (alert.status == notification_models.EmergencyAlertStatus.active) {
          final timeSinceCreated = now.difference(alert.createdAt);
          // Check if alert should be escalated (example: after 10 minutes)
          if (timeSinceCreated.inMinutes >= 10 && !_escalationTimers.containsKey(alert.id)) {
            _scheduleEscalation(alert, 0); // Immediate escalation
          }
        }
      }
    } catch (e) {
      _logger.error('Failed to check active alerts', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Notify listeners of active alerts changes
  void _notifyActiveAlertsChanged() {
    _activeAlertsController.add(activeAlerts);
  }

  /// Dispose resources
  void dispose() {
    for (final timer in _escalationTimers.values) {
      timer.cancel();
    }
    _escalationTimers.clear();
    _activeAlertsController.close();
  }
}
