import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../widgets/emergency_alert_card.dart';

/// Emergency Alert Screen
///
/// Displays active and recent emergency alerts:
/// - Active emergency alerts with action buttons
/// - Recent emergency alert history
/// - Emergency contact quick actions
/// - Emergency alert creation (for testing)
class EmergencyAlertScreen extends ConsumerStatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  ConsumerState<EmergencyAlertScreen> createState() =>
      _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends ConsumerState<EmergencyAlertScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _logger = BoundedContextLoggers.notification;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Log screen access
    _logger.info('Emergency alert screen accessed', {
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
    return Scaffold(
      backgroundColor: CareCircleDesignTokens.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildActiveAlertsTab(), _buildHistoryTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CareCircleDesignTokens.errorRed,
      foregroundColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.emergency, size: 24),
          SizedBox(width: 8),
          Text(
            'Emergency Alerts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.contacts),
          onPressed: () => context.push('/notifications/emergency-contacts'),
          tooltip: 'Emergency Contacts',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'test_alert',
              child: Row(
                children: [
                  Icon(Icons.bug_report, size: 20),
                  SizedBox(width: 12),
                  Text('Test Alert'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: CareCircleDesignTokens.errorRed,
        unselectedLabelColor: CareCircleDesignTokens.textSecondary,
        indicatorColor: CareCircleDesignTokens.errorRed,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 16),
                SizedBox(width: 8),
                Text('Active'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 16),
                SizedBox(width: 8),
                Text('History'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsTab() {
    // TODO: Replace with actual provider for active emergency alerts
    return _buildMockActiveAlerts();
  }

  Widget _buildHistoryTab() {
    // TODO: Replace with actual provider for emergency alert history
    return _buildMockHistory();
  }

  Widget _buildMockActiveAlerts() {
    // Mock data for demonstration
    final activeAlerts = <EmergencyAlert>[
      EmergencyAlert(
        id: '1',
        userId: 'user1',
        title: 'Critical Medication Alert',
        message:
            'Patient has missed critical heart medication for 4 hours. Immediate attention required.',
        alertType: EmergencyAlertType.missedCriticalMedication,
        severity: EmergencyAlertSeverity.critical,
        status: EmergencyAlertStatus.active,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        metadata: {
          'medicationName': 'Metoprolol',
          'dosage': '50mg',
          'lastTaken': DateTime.now()
              .subtract(const Duration(hours: 4))
              .toIso8601String(),
        },
        actions: [
          const EmergencyAlertAction(
            id: 'ack1',
            label: 'Acknowledge',
            actionType: 'acknowledge',
            isPrimary: true,
          ),
          const EmergencyAlertAction(
            id: 'call1',
            label: 'Call Doctor',
            actionType: 'call_doctor',
            phoneNumber: '+1234567890',
          ),
        ],
      ),
    ];

    if (activeAlerts.isEmpty) {
      return _buildEmptyActiveAlerts();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: CareCircleDesignTokens.errorRed,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activeAlerts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final alert = activeAlerts[index];
          return EmergencyAlertCard(
            alert: alert,
            onAction: (action) => _handleAlertAction(alert, action),
            onTap: () => _showAlertDetails(alert),
          );
        },
      ),
    );
  }

  Widget _buildMockHistory() {
    // Mock data for demonstration
    final historyAlerts = <EmergencyAlert>[
      EmergencyAlert(
        id: '2',
        userId: 'user1',
        title: 'Fall Detection Alert',
        message:
            'Potential fall detected. Patient did not respond to check-in.',
        alertType: EmergencyAlertType.fallDetection,
        severity: EmergencyAlertSeverity.high,
        status: EmergencyAlertStatus.resolved,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        resolvedAt: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        resolvedBy: 'Caregiver',
      ),
      EmergencyAlert(
        id: '3',
        userId: 'user1',
        title: 'Vital Signs Alert',
        message: 'Blood pressure reading outside normal range: 180/110 mmHg',
        alertType: EmergencyAlertType.vitalSignsCritical,
        severity: EmergencyAlertSeverity.medium,
        status: EmergencyAlertStatus.acknowledged,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        acknowledgedAt: DateTime.now()
            .subtract(const Duration(days: 1))
            .add(const Duration(minutes: 10)),
        acknowledgedBy: 'Patient',
      ),
    ];

    if (historyAlerts.isEmpty) {
      return _buildEmptyHistory();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: historyAlerts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final alert = historyAlerts[index];
        return EmergencyAlertCard(
          alert: alert,
          isHistoryItem: true,
          onTap: () => _showAlertDetails(alert),
        );
      },
    );
  }

  Widget _buildEmptyActiveAlerts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.check_circle,
              size: 40,
              color: CareCircleDesignTokens.successGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Alerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All emergency alerts have been resolved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _createTestAlert,
            icon: const Icon(Icons.bug_report),
            label: const Text('Create Test Alert'),
            style: OutlinedButton.styleFrom(
              foregroundColor: CareCircleDesignTokens.errorRed,
              side: BorderSide(color: CareCircleDesignTokens.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: CareCircleDesignTokens.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Alert History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency alert history will appear here.',
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showEmergencyActions,
      backgroundColor: CareCircleDesignTokens.errorRed,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.emergency),
      label: const Text('Emergency'),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      // TODO: Refresh emergency alerts from API
      _logger.info('Emergency alerts refreshed', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to refresh emergency alerts', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.errorRed,
          ),
        );
      }
    }
  }

  void _handleAlertAction(EmergencyAlert alert, EmergencyAlertAction action) {
    _logger.info('Emergency alert action triggered', {
      'alertId': alert.id,
      'actionType': action.actionType,
      'timestamp': DateTime.now().toIso8601String(),
    });

    switch (action.actionType) {
      case 'acknowledge':
        _acknowledgeAlert(alert);
        break;
      case 'resolve':
        _resolveAlert(alert);
        break;
      case 'call_emergency':
        _callEmergencyServices();
        break;
      case 'call_doctor':
        _callDoctor(action.phoneNumber);
        break;
      case 'contact_caregiver':
        _contactCaregiver();
        break;
      default:
        _showActionDialog(alert, action);
    }
  }

  void _acknowledgeAlert(EmergencyAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acknowledge Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to acknowledge this emergency alert?'),
            const SizedBox(height: 16),
            Text(
              alert.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Call emergency alert handler to acknowledge
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alert acknowledged'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.successGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Acknowledge'),
          ),
        ],
      ),
    );
  }

  void _resolveAlert(EmergencyAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mark this emergency alert as resolved?'),
            const SizedBox(height: 16),
            Text(
              alert.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Call emergency alert handler to resolve
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alert resolved'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _callEmergencyServices() {
    // TODO: Implement emergency services call
    _logger.info('Emergency services call requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling emergency services...'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _callDoctor(String? phoneNumber) {
    // TODO: Implement doctor call
    _logger.info('Doctor call requested', {
      'phoneNumber': phoneNumber,
      'timestamp': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Calling doctor${phoneNumber != null ? ' at $phoneNumber' : ''}...',
        ),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      ),
    );
  }

  void _contactCaregiver() {
    // TODO: Implement caregiver contact
    _logger.info('Caregiver contact requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contacting caregiver...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showActionDialog(EmergencyAlert alert, EmergencyAlertAction action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.label),
        content: Text('Perform action: ${action.actionType}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Perform the action
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showAlertDetails(EmergencyAlert alert) {
    context.push('/notifications/emergency-alerts/${alert.id}');
  }

  void _showEmergencyActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: CareCircleDesignTokens.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.call, color: CareCircleDesignTokens.errorRed),
              title: const Text('Call 911'),
              subtitle: const Text('Emergency services'),
              onTap: () {
                Navigator.of(context).pop();
                _callEmergencyServices();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.local_hospital,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
              title: const Text('Call Doctor'),
              subtitle: const Text('Primary care physician'),
              onTap: () {
                Navigator.of(context).pop();
                _callDoctor(null);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: CareCircleDesignTokens.successGreen,
              ),
              title: const Text('Contact Caregiver'),
              subtitle: const Text('Primary caregiver'),
              onTap: () {
                Navigator.of(context).pop();
                _contactCaregiver();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bug_report,
                color: CareCircleDesignTokens.warningOrange,
              ),
              title: const Text('Test Alert'),
              subtitle: const Text('Create test emergency alert'),
              onTap: () {
                Navigator.of(context).pop();
                _createTestAlert();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createTestAlert() {
    // TODO: Create test emergency alert
    _logger.info('Test emergency alert creation requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test emergency alert created'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'test_alert':
        _createTestAlert();
        break;
      case 'settings':
        context.push('/notifications/preferences');
        break;
    }
  }
}
