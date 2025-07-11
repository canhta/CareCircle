// CareCircle Activity Ring Component
//
// Apple Health HIG-compliant Activity Rings for healthcare activity tracking.
// Follows strict Apple Human Interface Guidelines for activity visualization.

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../design/design_tokens.dart';
import '../../animations/healthcare_animations.dart';

/// Activity Ring Component following Apple Health HIG
class ActivityRingComponent extends StatefulWidget {
  const ActivityRingComponent({
    super.key,
    required this.activities,
    this.size = 200.0,
    this.strokeWidth = 12.0,
    this.showLabels = true,
    this.isInteractive = true,
    this.onRingTap,
    required this.semanticDescription,
  });

  final List<ActivityRingData> activities;
  final double size;
  final double strokeWidth;
  final bool showLabels;
  final bool isInteractive;
  final Function(ActivityRingData)? onRingTap;
  final String semanticDescription;

  @override
  State<ActivityRingComponent> createState() => _ActivityRingComponentState();
}

class _ActivityRingComponentState extends State<ActivityRingComponent>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeAnimations() {
    _animationControllers = widget.activities.map((activity) {
      return AnimationController(
        duration: HealthcareAnimationTokens.activityRingFillDuration,
        vsync: this,
      );
    }).toList();

    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: HealthcareAnimationTokens.activityRingCurve,
        ),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Activity rings',
      hint: widget.semanticDescription,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Activity rings
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: ActivityRingPainter(
                activities: widget.activities,
                animations: _animations,
                strokeWidth: widget.strokeWidth,
                isInteractive: widget.isInteractive,
              ),
            ),
            // Touch detection
            if (widget.isInteractive)
              GestureDetector(
                onTapUp: (details) => _handleTap(details),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  color: Colors.transparent,
                ),
              ),
            // Center content
            if (widget.showLabels) _buildCenterContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterContent() {
    if (widget.activities.isEmpty) return const SizedBox.shrink();

    final primaryActivity = widget.activities.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${(primaryActivity.current).toInt()}',
          style: CareCircleTypographyTokens.healthMetricValue.copyWith(
            fontSize: widget.size * 0.12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          primaryActivity.unit,
          style: CareCircleTypographyTokens.medicalLabel.copyWith(
            fontSize: widget.size * 0.06,
          ),
        ),
      ],
    );
  }

  void _handleTap(TapUpDetails details) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final distance = (details.localPosition - center).distance;

    final ringIndex = _calculateRingIndex(distance);
    if (ringIndex >= 0 && ringIndex < widget.activities.length) {
      widget.onRingTap?.call(widget.activities[ringIndex]);
    }
  }

  int _calculateRingIndex(double distance) {
    final ringSpacing = widget.strokeWidth + 4; // 4px gap between rings
    final innerRadius =
        (widget.size / 2) - (widget.activities.length * ringSpacing);

    for (int i = 0; i < widget.activities.length; i++) {
      final ringRadius = innerRadius + (i * ringSpacing);
      final ringInnerRadius = ringRadius - (widget.strokeWidth / 2);
      final ringOuterRadius = ringRadius + (widget.strokeWidth / 2);

      if (distance >= ringInnerRadius && distance <= ringOuterRadius) {
        return i;
      }
    }

    return -1;
  }
}

/// Activity Ring Data Model
class ActivityRingData {
  final String name;
  final double progress; // 0.0 to 1.0
  final double goal;
  final double current;
  final Color color;
  final String unit;

  const ActivityRingData({
    required this.name,
    required this.progress,
    required this.goal,
    required this.current,
    required this.color,
    required this.unit,
  });

  /// Creates activity ring data for steps
  factory ActivityRingData.steps({
    required double current,
    required double goal,
  }) {
    return ActivityRingData(
      name: 'Steps',
      progress: (current / goal).clamp(0.0, 1.0),
      goal: goal,
      current: current,
      color: CareCircleColorTokens.healthGreen,
      unit: 'steps',
    );
  }

  /// Creates activity ring data for exercise minutes
  factory ActivityRingData.exercise({
    required double current,
    required double goal,
  }) {
    return ActivityRingData(
      name: 'Exercise',
      progress: (current / goal).clamp(0.0, 1.0),
      goal: goal,
      current: current,
      color: CareCircleColorTokens.primaryMedicalBlue,
      unit: 'min',
    );
  }

  /// Creates activity ring data for stand hours
  factory ActivityRingData.stand({
    required double current,
    required double goal,
  }) {
    return ActivityRingData(
      name: 'Stand',
      progress: (current / goal).clamp(0.0, 1.0),
      goal: goal,
      current: current,
      color: CareCircleColorTokens.warningAmber,
      unit: 'hrs',
    );
  }
}

/// Custom painter for activity rings following Apple HIG
class ActivityRingPainter extends CustomPainter {
  final List<ActivityRingData> activities;
  final List<Animation<double>> animations;
  final double strokeWidth;
  final bool isInteractive;

  ActivityRingPainter({
    required this.activities,
    required this.animations,
    required this.strokeWidth,
    required this.isInteractive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringSpacing =
        strokeWidth + 4; // 4px gap between rings as per Apple HIG
    final outerRadius = (size.width / 2) - (strokeWidth / 2);

    for (int i = 0; i < activities.length; i++) {
      final activity = activities[i];
      final animation = animations[i];
      final radius = outerRadius - (i * ringSpacing);

      // Draw background ring
      _drawBackgroundRing(canvas, center, radius, activity.color);

      // Draw progress ring
      _drawProgressRing(
        canvas,
        center,
        radius,
        activity.color,
        activity.progress * animation.value,
      );
    }
  }

  void _drawBackgroundRing(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  void _drawProgressRing(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double progress,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2; // Start at top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(ActivityRingPainter oldDelegate) {
    return oldDelegate.activities != activities ||
        oldDelegate.animations != animations;
  }
}
