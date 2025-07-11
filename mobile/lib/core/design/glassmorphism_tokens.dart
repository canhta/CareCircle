import 'package:flutter/material.dart';
import 'dart:ui';
import 'color_tokens.dart';

/// CareCircle Glassmorphism Token System
///
/// Modern glassmorphism effects for healthcare applications.
/// Provides frosted glass effects with healthcare-appropriate styling.
class CareCircleGlassmorphismTokens {
  // Glassmorphism Background Colors

  /// Light glassmorphism background - For light themes
  static const Color lightGlassBackground = Color(0x1AFFFFFF);

  /// Dark glassmorphism background - For dark accents
  static const Color darkGlassBackground = Color(0x1A000000);

  /// Medical glassmorphism background - Healthcare themed
  static const Color medicalGlassBackground = Color(0x1A1565C0);

  /// Success glassmorphism background - For positive states
  static const Color successGlassBackground = Color(0x1A2E7D32);

  /// Warning glassmorphism background - For caution states
  static const Color warningGlassBackground = Color(0x1AED6C02);

  /// Critical glassmorphism background - For emergency states
  static const Color criticalGlassBackground = Color(0x1AD32F2F);

  // Blur Intensities

  /// Light blur - Subtle glassmorphism effect
  static const double lightBlur = 8.0;

  /// Medium blur - Standard glassmorphism effect
  static const double mediumBlur = 16.0;

  /// Heavy blur - Strong glassmorphism effect
  static const double heavyBlur = 24.0;

  /// Ultra blur - Maximum glassmorphism effect
  static const double ultraBlur = 32.0;

  // Border Configurations

  /// Light glass border - Subtle border for glassmorphism
  static const Border lightGlassBorder = Border.fromBorderSide(
    BorderSide(
      color: Color(0x33FFFFFF),
      width: 1.0,
    ),
  );

  /// Medical glass border - Healthcare themed border
  static const Border medicalGlassBorder = Border.fromBorderSide(
    BorderSide(
      color: Color(0x331565C0),
      width: 1.5,
    ),
  );

  /// Gradient glass border - For enhanced visual appeal
  static const Border gradientGlassBorder = Border.fromBorderSide(
    BorderSide(
      color: Color(0x44FFFFFF),
      width: 1.0,
    ),
  );

  // Glassmorphism Decorations

  /// Light card glassmorphism - For standard cards
  static BoxDecoration lightCardGlass({
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: lightGlassBackground,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: lightGlassBorder,
      boxShadow: shadows ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Medical card glassmorphism - For healthcare cards
  static BoxDecoration medicalCardGlass({
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: medicalGlassBackground,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: medicalGlassBorder,
      boxShadow: shadows ?? [
        BoxShadow(
          color: CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  /// AI assistant glassmorphism - For AI-related components
  static BoxDecoration aiGlass({
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: const Color(0x1A7C4DFF),
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      border: const Border.fromBorderSide(
        BorderSide(
          color: Color(0x337C4DFF),
          width: 1.5,
        ),
      ),
      boxShadow: shadows ?? [
        BoxShadow(
          color: const Color(0xFF7C4DFF).withValues(alpha: 0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Emergency glassmorphism - For critical actions
  static BoxDecoration emergencyGlass({
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: criticalGlassBackground,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      border: const Border.fromBorderSide(
        BorderSide(
          color: Color(0x33D32F2F),
          width: 2.0,
        ),
      ),
      boxShadow: shadows ?? [
        BoxShadow(
          color: CareCircleColorTokens.criticalAlert.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Backdrop Filter Configurations

  /// Light backdrop filter - For subtle blur effects
  static ImageFilter lightBackdropFilter = ImageFilter.blur(
    sigmaX: lightBlur,
    sigmaY: lightBlur,
  );

  /// Medium backdrop filter - For standard blur effects
  static ImageFilter mediumBackdropFilter = ImageFilter.blur(
    sigmaX: mediumBlur,
    sigmaY: mediumBlur,
  );

  /// Heavy backdrop filter - For strong blur effects
  static ImageFilter heavyBackdropFilter = ImageFilter.blur(
    sigmaX: heavyBlur,
    sigmaY: heavyBlur,
  );

  /// Ultra backdrop filter - For maximum blur effects
  static ImageFilter ultraBackdropFilter = ImageFilter.blur(
    sigmaX: ultraBlur,
    sigmaY: ultraBlur,
  );

  // Utility Methods

  /// Create custom glassmorphism decoration
  static BoxDecoration createGlassmorphism({
    required Color backgroundColor,
    required Color borderColor,
    double borderWidth = 1.0,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.fromBorderSide(
        BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      boxShadow: shadows ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Get glassmorphism for urgency level
  static BoxDecoration getUrgencyGlass(String urgencyLevel, {
    BorderRadius? borderRadius,
  }) {
    switch (urgencyLevel.toLowerCase()) {
      case 'critical':
      case 'emergency':
        return emergencyGlass(borderRadius: borderRadius);
      case 'high':
      case 'warning':
        return createGlassmorphism(
          backgroundColor: warningGlassBackground,
          borderColor: const Color(0x33ED6C02),
          borderRadius: borderRadius,
        );
      case 'normal':
      case 'good':
        return createGlassmorphism(
          backgroundColor: successGlassBackground,
          borderColor: const Color(0x332E7D32),
          borderRadius: borderRadius,
        );
      default:
        return medicalCardGlass(borderRadius: borderRadius);
    }
  }

  /// Create backdrop filter widget
  static Widget createBackdropFilter({
    required Widget child,
    double blurIntensity = mediumBlur,
  }) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: blurIntensity,
        sigmaY: blurIntensity,
      ),
      child: child,
    );
  }

  /// Create glassmorphism container
  static Widget createGlassContainer({
    required Widget child,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    double blurIntensity = mediumBlur,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration ?? lightCardGlass(),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurIntensity,
          sigmaY: blurIntensity,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
