// CareCircle Medication Reminder Card
//
// Healthcare-optimized medication reminder with adherence tracking,
// animated states, and accessibility-compliant medication management.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../animations/medication_animations.dart';

/// Medication Reminder Card with animated states and adherence tracking
class MedicationReminderCard extends StatefulWidget {
  const MedicationReminderCard({
    super.key,
    required this.medication,
    required this.onTakeDose,
    required this.onSkipDose,
    this.onViewDetails,
    this.showAdherenceStreak = true,
    this.isInteractive = true,
    required this.semanticLabel,
    required this.semanticHint,
  });

  final MedicationReminder medication;
  final VoidCallback onTakeDose;
  final VoidCallback onSkipDose;
  final VoidCallback? onViewDetails;
  final bool showAdherenceStreak;
  final bool isInteractive;
  final String semanticLabel;
  final String semanticHint;

  @override
  State<MedicationReminderCard> createState() => _MedicationReminderCardState();
}

class _MedicationReminderCardState extends State<MedicationReminderCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _successController;
  late AnimationController _streakController;

  bool _showSuccessAnimation = false;
  bool _showStreakCelebration = false;

  @override
  void initState() {
    super.initState();
    _pulseController = MedicationReminderAnimations.createPulseAnimation(this);
    _successController = MedicationReminderAnimations.createSuccessAnimation(
      this,
    );
    _streakController = MedicationReminderAnimations.createStreakAnimation(
      this,
    );

    // Start pulse animation for overdue medications
    if (widget.medication.state == MedicationReminderState.overdue) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(MedicationReminderCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animations based on state changes
    if (widget.medication.state != oldWidget.medication.state) {
      _updateAnimationsForState();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _successController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  void _updateAnimationsForState() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        _pulseController.repeat(reverse: true);
        break;
      case MedicationReminderState.taken:
        _pulseController.stop();
        _showSuccessAnimation = true;
        _successController.forward();
        break;
      default:
        _pulseController.stop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      hint: widget.semanticHint,
      button: widget.isInteractive,
      child: Stack(
        children: [
          MedicationReminderAnimations.buildAnimatedReminderCard(
            controller: _pulseController,
            state: widget.medication.state,
            onTap: widget.onViewDetails,
            child: _buildCardContent(),
          ),
          if (_showSuccessAnimation)
            Positioned.fill(
              child: MedicationReminderAnimations.buildDoseTakenConfirmation(
                controller: _successController,
                medicationName: widget.medication.name,
                dosage: widget.medication.dosage,
              ),
            ),
          if (_showStreakCelebration)
            Positioned.fill(
              child: MedicationReminderAnimations.buildStreakCelebration(
                controller: _streakController,
                streakDays: widget.medication.adherenceStreak,
                message:
                    'Great job! ${widget.medication.adherenceStreak} days in a row!',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.md),
      decoration: BoxDecoration(
        color: _getCardBackgroundColor(),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
        border: Border.all(color: _getCardBorderColor(), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: CareCircleSpacingTokens.sm),
          _buildMedicationInfo(),
          SizedBox(height: CareCircleSpacingTokens.md),
          if (widget.medication.state != MedicationReminderState.taken)
            _buildActionButtons(),
          if (widget.showAdherenceStreak &&
              widget.medication.adherenceStreak > 0)
            _buildAdherenceStreak(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getIconBackgroundColor(),
            borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          ),
          child: Icon(_getMedicationIcon(), color: _getIconColor(), size: 24),
        ),
        SizedBox(width: CareCircleSpacingTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medication.name,
                style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                  color: _getTextColor(),
                ),
              ),
              Text(
                _getTimeDisplayText(),
                style: CareCircleTypographyTokens.medicalLabel.copyWith(
                  color: _getSecondaryTextColor(),
                ),
              ),
            ],
          ),
        ),
        _buildStateIndicator(),
      ],
    );
  }

  Widget _buildMedicationInfo() {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dosage', style: CareCircleTypographyTokens.medicalLabel),
                Text(
                  widget.medication.dosage,
                  style: CareCircleTypographyTokens.healthMetricTitle,
                ),
              ],
            ),
          ),
          if (widget.medication.instructions.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions',
                    style: CareCircleTypographyTokens.medicalLabel,
                  ),
                  Text(
                    widget.medication.instructions,
                    style: CareCircleTypographyTokens.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleTakeDose,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Take Dose'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleColorTokens.healthGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
              ),
            ),
          ),
        ),
        SizedBox(width: CareCircleSpacingTokens.sm),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onSkipDose,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Skip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: CareCircleColorTokens.cautionOrange,
              side: BorderSide(color: CareCircleColorTokens.cautionOrange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdherenceStreak() {
    return Container(
      margin: EdgeInsets.only(top: CareCircleSpacingTokens.sm),
      padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.1),
            Colors.yellow.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 20,
          ),
          SizedBox(width: CareCircleSpacingTokens.sm),
          Text(
            '${widget.medication.adherenceStreak} day streak!',
            style: CareCircleTypographyTokens.medicalLabel.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getStateIndicatorColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  void _handleTakeDose() {
    widget.onTakeDose();

    // Show success animation
    setState(() {
      _showSuccessAnimation = true;
    });
    _successController.forward();

    // Check for streak milestone
    if (widget.medication.adherenceStreak > 0 &&
        widget.medication.adherenceStreak % 7 == 0) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _showStreakCelebration = true;
          });
          _streakController.forward();
        }
      });
    }
  }

  Color _getCardBackgroundColor() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        return CareCircleColorTokens.emergencyRed.withValues(alpha: 0.05);
      case MedicationReminderState.due:
        return CareCircleColorTokens.warningAmber.withValues(alpha: 0.05);
      case MedicationReminderState.taken:
        return CareCircleColorTokens.healthGreen.withValues(alpha: 0.05);
      default:
        return Colors.white;
    }
  }

  Color _getCardBorderColor() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        return CareCircleColorTokens.emergencyRed;
      case MedicationReminderState.due:
        return CareCircleColorTokens.warningAmber;
      case MedicationReminderState.taken:
        return CareCircleColorTokens.healthGreen;
      default:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Color _getIconBackgroundColor() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        return CareCircleColorTokens.emergencyRed.withValues(alpha: 0.1);
      case MedicationReminderState.due:
        return CareCircleColorTokens.warningAmber.withValues(alpha: 0.1);
      case MedicationReminderState.taken:
        return CareCircleColorTokens.healthGreen.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        return CareCircleColorTokens.emergencyRed;
      case MedicationReminderState.due:
        return CareCircleColorTokens.warningAmber;
      case MedicationReminderState.taken:
        return CareCircleColorTokens.healthGreen;
      default:
        return CareCircleColorTokens.primaryMedicalBlue;
    }
  }

  Color _getTextColor() {
    return widget.medication.state == MedicationReminderState.taken
        ? Colors.grey
        : Colors.black;
  }

  Color _getSecondaryTextColor() {
    return Colors.grey;
  }

  Color _getStateIndicatorColor() {
    switch (widget.medication.state) {
      case MedicationReminderState.overdue:
        return CareCircleColorTokens.emergencyRed;
      case MedicationReminderState.due:
        return CareCircleColorTokens.warningAmber;
      case MedicationReminderState.taken:
        return CareCircleColorTokens.healthGreen;
      default:
        return Colors.grey;
    }
  }

  IconData _getMedicationIcon() {
    return Icons.medication;
  }

  String _getTimeDisplayText() {
    final now = DateTime.now();
    final scheduledTime = widget.medication.scheduledTime;

    if (widget.medication.state == MedicationReminderState.taken) {
      return 'Taken';
    }

    if (scheduledTime.isBefore(now)) {
      final difference = now.difference(scheduledTime);
      if (difference.inHours > 0) {
        return '${difference.inHours}h overdue';
      } else {
        return '${difference.inMinutes}m overdue';
      }
    } else {
      final difference = scheduledTime.difference(now);
      if (difference.inHours > 0) {
        return 'Due in ${difference.inHours}h';
      } else {
        return 'Due in ${difference.inMinutes}m';
      }
    }
  }
}

/// Medication Reminder Data Model
class MedicationReminder {
  final String id;
  final String name;
  final String dosage;
  final String instructions;
  final DateTime scheduledTime;
  final MedicationReminderState state;
  final int adherenceStreak;

  const MedicationReminder({
    required this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.scheduledTime,
    required this.state,
    this.adherenceStreak = 0,
  });

  /// Creates a medication reminder for testing
  factory MedicationReminder.example({
    String name = 'Lisinopril',
    String dosage = '10mg',
    MedicationReminderState state = MedicationReminderState.due,
  }) {
    return MedicationReminder(
      id: 'med_001',
      name: name,
      dosage: dosage,
      instructions: 'Take with food',
      scheduledTime: DateTime.now().add(const Duration(minutes: 30)),
      state: state,
      adherenceStreak: 5,
    );
  }
}
