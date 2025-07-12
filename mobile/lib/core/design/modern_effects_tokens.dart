import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// CareCircle Modern Effects Token System
///
/// Modern visual effects including shadows, borders, and micro-interactions
/// for healthcare applications with professional appearance.
class CareCircleModernEffectsTokens {
  // Modern Shadow System

  /// Subtle shadow - For minimal elevation
  static const List<BoxShadow> subtleShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Soft shadow - For standard cards
  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// Medium shadow - For elevated components
  static const List<BoxShadow> mediumShadow = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Strong shadow - For floating elements
  static const List<BoxShadow> strongShadow = [
    BoxShadow(color: Color(0x29000000), blurRadius: 24, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Medical shadow - Healthcare themed shadows
  static const List<BoxShadow> medicalShadow = [
    BoxShadow(color: Color(0x141565C0), blurRadius: 12, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x0A1565C0), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// AI shadow - For AI-related components
  static const List<BoxShadow> aiShadow = [
    BoxShadow(color: Color(0x1F7C4DFF), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x147C4DFF), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Emergency shadow - For critical actions
  static const List<BoxShadow> emergencyShadow = [
    BoxShadow(color: Color(0x29D32F2F), blurRadius: 20, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x1FD32F2F), blurRadius: 6, offset: Offset(0, 3)),
  ];

  // Modern Border System

  /// Subtle border - Minimal border styling
  static const BorderSide subtleBorder = BorderSide(
    color: Color(0x1A000000),
    width: 1.0,
  );

  /// Standard border - Default border styling
  static const BorderSide standardBorder = BorderSide(
    color: Color(0x33000000),
    width: 1.0,
  );

  /// Medical border - Healthcare themed border
  static const BorderSide medicalBorder = BorderSide(
    color: Color(0x331565C0),
    width: 1.5,
  );

  /// AI border - For AI components
  static const BorderSide aiBorder = BorderSide(
    color: Color(0x337C4DFF),
    width: 1.5,
  );

  /// Focus border - For focused states
  static const BorderSide focusBorder = BorderSide(
    color: CareCircleColorTokens.primaryMedicalBlue,
    width: 2.0,
  );

  /// Error border - For error states
  static const BorderSide errorBorder = BorderSide(
    color: CareCircleColorTokens.criticalAlert,
    width: 2.0,
  );

  // Modern Border Radius System

  /// Extra small radius - For subtle rounding
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(4));

  /// Small radius - For buttons and small components
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(8));

  /// Medium radius - For cards and containers
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(12));

  /// Large radius - For prominent components
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(16));

  /// Extra large radius - For special components
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(20));

  /// Ultra large radius - For hero components
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(24));

  /// Pill radius - For pill-shaped components
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999));

  // Gradient Border Decorations

  /// Medical gradient border - For healthcare components
  static BoxDecoration medicalGradientBorder({
    BorderRadius? borderRadius,
    double borderWidth = 2.0,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? radiusMD,
      border: Border.all(
        color: CareCircleColorTokens.primaryMedicalBlue,
        width: borderWidth,
      ),
      gradient: LinearGradient(
        colors: [
          CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  /// AI gradient border - For AI components
  static BoxDecoration aiGradientBorder({
    BorderRadius? borderRadius,
    double borderWidth = 2.0,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius ?? radiusLG,
      border: Border.all(color: const Color(0xFF7C4DFF), width: borderWidth),
      gradient: const LinearGradient(
        colors: [Color(0x1A7C4DFF), Color(0x0A536DFE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  // Micro-interaction Effects

  /// Button press scale - For button interactions
  static const double buttonPressScale = 0.95;

  /// Card hover scale - For card interactions
  static const double cardHoverScale = 1.02;

  /// Icon bounce scale - For icon animations
  static const double iconBounceScale = 1.1;

  // Animation Durations

  /// Fast animation - For quick interactions
  static const Duration fastAnimation = Duration(milliseconds: 150);

  /// Standard animation - For normal interactions
  static const Duration standardAnimation = Duration(milliseconds: 250);

  /// Slow animation - For complex transitions
  static const Duration slowAnimation = Duration(milliseconds: 400);

  // Animation Curves

  /// Smooth curve - For natural feeling animations
  static const Curve smoothCurve = Curves.easeInOutCubic;

  /// Bounce curve - For playful interactions
  static const Curve bounceCurve = Curves.elasticOut;

  /// Sharp curve - For quick, decisive animations
  static const Curve sharpCurve = Curves.easeOutExpo;

  // Utility Methods

  /// Get shadow for elevation level
  static List<BoxShadow> getShadowForElevation(int elevation) {
    switch (elevation) {
      case 0:
        return [];
      case 1:
        return subtleShadow;
      case 2:
        return softShadow;
      case 3:
        return mediumShadow;
      case 4:
      case 5:
        return strongShadow;
      default:
        return strongShadow;
    }
  }

  /// Get border radius for size
  static BorderRadius getRadiusForSize(String size) {
    switch (size.toLowerCase()) {
      case 'xs':
        return radiusXS;
      case 'sm':
        return radiusSM;
      case 'md':
        return radiusMD;
      case 'lg':
        return radiusLG;
      case 'xl':
        return radiusXL;
      case 'xxl':
        return radiusXXL;
      case 'pill':
        return radiusPill;
      default:
        return radiusMD;
    }
  }

  /// Create modern card decoration
  static BoxDecoration createModernCard({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: borderRadius ?? radiusMD,
      boxShadow: shadows ?? softShadow,
      border: border,
    );
  }

  /// Create modern button decoration
  static BoxDecoration createModernButton({
    required Color backgroundColor,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? radiusSM,
      boxShadow: shadows ?? subtleShadow,
      border: border,
    );
  }
}
