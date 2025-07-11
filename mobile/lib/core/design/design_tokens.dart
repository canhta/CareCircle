// CareCircle Design Token System - Barrel File
//
// This file exports all design token modules and provides backward compatibility
// for existing code during the migration to the new modular token system.

export 'color_tokens.dart';
export 'typography_tokens.dart';
export 'spacing_tokens.dart';
export 'animation_tokens.dart';
export 'component_tokens.dart';

import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'typography_tokens.dart';
import 'spacing_tokens.dart';

/// Legacy CareCircleDesignTokens class for backward compatibility
///
/// This class re-exports commonly used tokens to maintain compatibility
/// with existing code. New code should import specific token files directly.
///
/// @deprecated Use specific token classes instead:
/// - CareCircleColorTokens for colors
/// - CareCircleTypographyTokens for typography
/// - CareCircleSpacingTokens for spacing
/// - CareCircleAnimationTokens for animations
/// - CareCircleComponentTokens for component configurations
class CareCircleDesignTokens {
  // Re-export commonly used color tokens for backward compatibility
  static const Color primaryMedicalBlue = CareCircleColorTokens.primaryMedicalBlue;
  static const Color healthGreen = CareCircleColorTokens.healthGreen;
  static const Color criticalAlert = CareCircleColorTokens.criticalAlert;

  // Extended color palette for notifications
  static const Color successGreen = CareCircleColorTokens.normalRange;
  static const Color warningOrange = CareCircleColorTokens.warningAmber;
  static const Color errorRed = CareCircleColorTokens.criticalAlert;

  // Text colors (mapped to new color scheme)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // Background colors (mapped to new color scheme)
  static const Color backgroundPrimary = Color(0xFFFAFAFA);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);

  // Border colors (mapped to new color scheme)
  static const Color borderLight = Color(0xFFE0E0E0);

  // Re-export commonly used spacing tokens for backward compatibility
  static const double touchTargetMin = CareCircleSpacingTokens.touchTargetMin;
  static const double emergencyButtonMin = CareCircleSpacingTokens.emergencyButtonMin;

  // Re-export commonly used typography tokens for backward compatibility
  static const TextStyle vitalSignsStyle = CareCircleTypographyTokens.vitalSignsLarge;
}
