import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';

/// Emergency alert card widget
///
/// Displays an emergency alert with:
/// - Alert type icon and severity indicator
/// - Title and message
/// - Timestamp and status
/// - Action buttons for active alerts
/// - Status information for resolved alerts
class EmergencyAlertCard extends StatelessWidget {
  final EmergencyAlert alert;
  final Function(EmergencyAlertAction)? onAction;
  final VoidCallback? onTap;
  final bool isHistoryItem;

  const EmergencyAlertCard({
    super.key,
    required this.alert,
    this.onAction,
    this.onTap,
    this.isHistoryItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: alert.isActive ? 8 : 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getSeverityColor(alert.severity),
          width: alert.isActive ? 3 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: alert.isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getSeverityColor(alert.severity).withOpacity(0.05),
                      Colors.white,
                    ],
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
              const SizedBox(height: 16),
              _buildFooter(),
              if (alert.isActive && alert.actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildTypeIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      alert.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: CareCircleDesignTokens.textPrimary,
                      ),
                    ),
                  ),
                  _buildSeverityBadge(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                alert.alertType.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getSeverityColor(alert.severity),
                ),
              ),
            ],
          ),
        ),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildTypeIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _getSeverityColor(alert.severity), width: 2),
      ),
      child: Center(
        child: Text(alert.alertType.icon, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildSeverityBadge() {
    if (alert.severity == EmergencyAlertSeverity.low) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getSeverityColor(alert.severity),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        alert.severity.displayName.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    IconData icon;
    Color color;

    switch (alert.status) {
      case EmergencyAlertStatus.active:
        icon = Icons.warning;
        color = CareCircleDesignTokens.errorRed;
        break;
      case EmergencyAlertStatus.acknowledged:
        icon = Icons.check_circle;
        color = CareCircleDesignTokens.warningOrange;
        break;
      case EmergencyAlertStatus.resolved:
        icon = Icons.check_circle;
        color = CareCircleDesignTokens.successGreen;
        break;
      case EmergencyAlertStatus.escalated:
        icon = Icons.trending_up;
        color = CareCircleDesignTokens.errorRed;
        break;
      case EmergencyAlertStatus.cancelled:
        icon = Icons.cancel;
        color = CareCircleDesignTokens.textSecondary;
        break;
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          alert.status.name.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          alert.message,
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
            color: CareCircleDesignTokens.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (alert.metadata != null && alert.metadata!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildMetadataChips(),
        ],
      ],
    );
  }

  Widget _buildMetadataChips() {
    final metadata = alert.metadata!;
    final chips = <Widget>[];

    // Show relevant metadata as chips
    if (metadata['medicationName'] != null) {
      chips.add(
        _buildMetadataChip(
          '💊 ${metadata['medicationName']}',
          CareCircleDesignTokens.primaryMedicalBlue,
        ),
      );
    }

    if (metadata['location'] != null) {
      chips.add(
        _buildMetadataChip(
          '📍 ${metadata['location']}',
          CareCircleDesignTokens.warningOrange,
        ),
      );
    }

    if (metadata['vitalType'] != null && metadata['value'] != null) {
      chips.add(
        _buildMetadataChip(
          '💓 ${metadata['vitalType']}: ${metadata['value']}',
          CareCircleDesignTokens.errorRed,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 4, children: chips);
  }

  Widget _buildMetadataChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 16,
          color: CareCircleDesignTokens.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimestamp(alert.createdAt),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: CareCircleDesignTokens.textSecondary,
          ),
        ),
        if (alert.timeSinceCreated.inMinutes > 0) ...[
          const SizedBox(width: 8),
          Text(
            '• ${_formatDuration(alert.timeSinceCreated)} ago',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
        const Spacer(),
        if (alert.acknowledgedAt != null) ...[
          Icon(
            Icons.person,
            size: 14,
            color: CareCircleDesignTokens.successGreen,
          ),
          const SizedBox(width: 4),
          Text(
            'Ack: ${alert.acknowledgedBy ?? 'Unknown'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CareCircleDesignTokens.successGreen,
            ),
          ),
        ],
        if (alert.resolvedAt != null) ...[
          Icon(
            Icons.check,
            size: 14,
            color: CareCircleDesignTokens.successGreen,
          ),
          const SizedBox(width: 4),
          Text(
            'Resolved: ${alert.resolvedBy ?? 'Unknown'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CareCircleDesignTokens.successGreen,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    if (onAction == null) return const SizedBox.shrink();

    final primaryActions = alert.actions.where((a) => a.isPrimary).toList();
    final secondaryActions = alert.actions.where((a) => !a.isPrimary).toList();

    return Column(
      children: [
        // Primary actions (full width)
        ...primaryActions.map(
          (action) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: () => onAction!(action),
              icon: Icon(_getActionIcon(action.actionType)),
              label: Text(action.label),
              style: ElevatedButton.styleFrom(
                backgroundColor: action.isDestructive
                    ? CareCircleDesignTokens.errorRed
                    : _getSeverityColor(alert.severity),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),

        // Secondary actions (in a row)
        if (secondaryActions.isNotEmpty)
          Row(
            children: secondaryActions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < secondaryActions.length - 1 ? 8 : 0,
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () => onAction!(action),
                    icon: Icon(_getActionIcon(action.actionType), size: 16),
                    label: Text(action.label),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: action.isDestructive
                          ? CareCircleDesignTokens.errorRed
                          : _getSeverityColor(alert.severity),
                      side: BorderSide(
                        color: action.isDestructive
                            ? CareCircleDesignTokens.errorRed
                            : _getSeverityColor(alert.severity),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Color _getSeverityColor(EmergencyAlertSeverity severity) {
    switch (severity) {
      case EmergencyAlertSeverity.low:
        return CareCircleDesignTokens.successGreen;
      case EmergencyAlertSeverity.medium:
        return CareCircleDesignTokens.warningOrange;
      case EmergencyAlertSeverity.high:
        return CareCircleDesignTokens.errorRed;
      case EmergencyAlertSeverity.critical:
        return const Color(0xFF9C27B0); // Purple for critical
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'acknowledge':
        return Icons.check;
      case 'resolve':
        return Icons.check_circle;
      case 'call_emergency':
        return Icons.call;
      case 'call_doctor':
        return Icons.local_hospital;
      case 'contact_caregiver':
        return Icons.people;
      case 'escalate':
        return Icons.trending_up;
      default:
        return Icons.touch_app;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE h:mm a').format(timestamp);
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    }
  }
}
