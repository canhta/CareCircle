// CareCircle Medical Timeline Widget
// 
// Interactive timeline for medical history visualization with healthcare-compliant
// data presentation and accessibility-optimized navigation.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design/design_tokens.dart';
import '../../design/care_circle_icons.dart';

/// Medical Timeline Widget for comprehensive medical history
class MedicalTimelineWidget extends StatelessWidget {
  const MedicalTimelineWidget({
    super.key,
    required this.events,
    this.showDateLabels = true,
    this.isInteractive = true,
    this.onEventTap,
    required this.timelineDescription,
  });

  final List<MedicalTimelineEvent> events;
  final bool showDateLabels;
  final bool isInteractive;
  final Function(MedicalTimelineEvent)? onEventTap;
  final String timelineDescription;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }

    return Semantics(
      label: 'Medical timeline',
      hint: timelineDescription,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildTimelineItem(events[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CareCircleIcons.medicalHistory,
            size: 64,
            color: CareCircleColorTokens.normalRange.withValues(alpha: 0.5),
          ),
          SizedBox(height: CareCircleSpacingTokens.md),
          Text(
            'No Medical History',
            style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
              color: CareCircleColorTokens.normalRange,
            ),
          ),
          SizedBox(height: CareCircleSpacingTokens.sm),
          Text(
            'Your medical timeline will appear here as you add health events.',
            style: CareCircleTypographyTokens.medicalLabel,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(MedicalTimelineEvent event, int index) {
    final isLast = index == events.length - 1;
    
    return Semantics(
      label: '${event.type.displayName} on ${_formatDate(event.date)}',
      hint: event.description,
      button: isInteractive,
      child: InkWell(
        onTap: isInteractive ? () => onEventTap?.call(event) : null,
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: CareCircleSpacingTokens.sm,
            horizontal: CareCircleSpacingTokens.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimelineIndicator(event, isLast),
              SizedBox(width: CareCircleSpacingTokens.md),
              Expanded(
                child: _buildEventContent(event),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator(MedicalTimelineEvent event, bool isLast) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getEventColor(event.type),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _getEventColor(event.type).withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getEventIcon(event.type),
            size: 16,
            color: Colors.white,
          ),
        ),
        if (!isLast)
          Container(
            width: 3,
            height: 60,
            margin: EdgeInsets.only(top: CareCircleSpacingTokens.xs),
            decoration: BoxDecoration(
              color: CareCircleColorTokens.normalRange.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
      ],
    );
  }

  Widget _buildEventContent(MedicalTimelineEvent event) {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.md),
      decoration: BoxDecoration(
        color: _getEventColor(event.type).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        border: Border.all(
          color: _getEventColor(event.type).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                    color: _getEventColor(event.type),
                  ),
                ),
              ),
              if (showDateLabels)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: CareCircleSpacingTokens.sm,
                    vertical: CareCircleSpacingTokens.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getEventColor(event.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
                  ),
                  child: Text(
                    _formatDate(event.date),
                    style: CareCircleTypographyTokens.medicalLabel.copyWith(
                      color: _getEventColor(event.type),
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: CareCircleSpacingTokens.sm),
          Text(
            event.description,
            style: CareCircleTypographyTokens.textTheme.bodyMedium,
          ),
          if (event.additionalInfo != null) ...[
            SizedBox(height: CareCircleSpacingTokens.sm),
            Container(
              padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
              ),
              child: Text(
                event.additionalInfo!,
                style: CareCircleTypographyTokens.medicalLabel.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getEventColor(MedicalEventType type) {
    switch (type) {
      case MedicalEventType.appointment:
        return CareCircleColorTokens.primaryMedicalBlue;
      case MedicalEventType.medication:
        return CareCircleColorTokens.prescriptionBlue;
      case MedicalEventType.test:
        return CareCircleColorTokens.healthGreen;
      case MedicalEventType.surgery:
        return CareCircleColorTokens.warningAmber;
      case MedicalEventType.symptom:
        return CareCircleColorTokens.cautionOrange;
      case MedicalEventType.emergency:
        return CareCircleColorTokens.emergencyRed;
    }
  }

  IconData _getEventIcon(MedicalEventType type) {
    switch (type) {
      case MedicalEventType.appointment:
        return CareCircleIcons.appointment;
      case MedicalEventType.medication:
        return CareCircleIcons.medication;
      case MedicalEventType.test:
        return CareCircleIcons.labResults;
      case MedicalEventType.surgery:
        return CareCircleIcons.surgery;
      case MedicalEventType.symptom:
        return CareCircleIcons.symptoms;
      case MedicalEventType.emergency:
        return CareCircleIcons.emergency;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else if (difference < 30) {
      return '${(difference / 7).round()}w ago';
    } else if (difference < 365) {
      return '${(difference / 30).round()}mo ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}

/// Medical Event Types for timeline categorization
enum MedicalEventType {
  appointment,
  medication,
  test,
  surgery,
  symptom,
  emergency,
}

extension MedicalEventTypeExtension on MedicalEventType {
  String get displayName {
    switch (this) {
      case MedicalEventType.appointment:
        return 'Appointment';
      case MedicalEventType.medication:
        return 'Medication';
      case MedicalEventType.test:
        return 'Test/Lab';
      case MedicalEventType.surgery:
        return 'Surgery';
      case MedicalEventType.symptom:
        return 'Symptom';
      case MedicalEventType.emergency:
        return 'Emergency';
    }
  }
}

/// Medical Timeline Event Model
class MedicalTimelineEvent {
  final String title;
  final String description;
  final DateTime date;
  final MedicalEventType type;
  final String? additionalInfo;

  const MedicalTimelineEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.additionalInfo,
  });

  /// Creates an appointment event
  factory MedicalTimelineEvent.appointment({
    required String doctorName,
    required String specialty,
    required DateTime date,
    String? notes,
  }) {
    return MedicalTimelineEvent(
      title: 'Appointment with $doctorName',
      description: specialty,
      date: date,
      type: MedicalEventType.appointment,
      additionalInfo: notes,
    );
  }

  /// Creates a medication event
  factory MedicalTimelineEvent.medication({
    required String medicationName,
    required String action, // 'Started', 'Stopped', 'Changed'
    required DateTime date,
    String? dosage,
  }) {
    return MedicalTimelineEvent(
      title: '$action $medicationName',
      description: 'Medication change',
      date: date,
      type: MedicalEventType.medication,
      additionalInfo: dosage,
    );
  }

  /// Creates a test/lab event
  factory MedicalTimelineEvent.test({
    required String testName,
    required String result,
    required DateTime date,
    String? notes,
  }) {
    return MedicalTimelineEvent(
      title: testName,
      description: 'Result: $result',
      date: date,
      type: MedicalEventType.test,
      additionalInfo: notes,
    );
  }
}
