import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../../core/design/design_tokens.dart';

class HealthcareChatTheme {
  static ChatTheme get theme => DefaultChatTheme(
    // Primary colors
    primaryColor: CareCircleDesignTokens.primaryMedicalBlue,
    secondaryColor: CareCircleDesignTokens.healthGreen.withValues(alpha: 0.1),
    backgroundColor: Colors.white,

    // Input styling
    inputBackgroundColor: Colors.grey[50]!,
    inputTextColor: Colors.black87,
    inputBorderRadius: BorderRadius.circular(24),
    inputPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    inputMargin: const EdgeInsets.all(16),

    // Message styling
    messageBorderRadius: 16,
    messageInsetsHorizontal: 16,
    messageInsetsVertical: 12,

    // Message text styling will be handled by custom widgets

    // System message styling
    systemMessageTheme: SystemMessageTheme(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    ),

    // Typing indicator
    typingIndicatorTheme: TypingIndicatorTheme(
      animatedCirclesColor: CareCircleDesignTokens.primaryMedicalBlue,
      animatedCircleSize: 6,
      bubbleBorder: BorderRadius.circular(16),
      bubbleColor: Colors.grey[100]!,
      countAvatarColor: CareCircleDesignTokens.primaryMedicalBlue,
      countTextColor: Colors.white,
      multipleUserTextStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Error message styling
    errorColor: Colors.red[600]!,

    // Delivered/seen indicators
    deliveredIcon: Icon(Icons.done, size: 16, color: Colors.grey[500]),
    seenIcon: Icon(
      Icons.done_all,
      size: 16,
      color: CareCircleDesignTokens.primaryMedicalBlue,
    ),
  );

  // Healthcare-specific message decorations
  static BoxDecoration getUserMessageDecoration() {
    return BoxDecoration(
      color: CareCircleDesignTokens.primaryMedicalBlue,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
            alpha: 0.2,
          ),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration getAssistantMessageDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[300]!, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration getSystemMessageDecoration() {
    return BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue[200]!, width: 1),
    );
  }

  static BoxDecoration getEmergencyMessageDecoration() {
    return BoxDecoration(
      color: Colors.red[50],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.red[300]!, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.red.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration getWarningMessageDecoration() {
    return BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.orange[300]!, width: 1),
    );
  }

  // Healthcare-specific text styles
  static TextStyle get medicalDisclaimerStyle => TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
    fontStyle: FontStyle.italic,
    height: 1.3,
  );

  static TextStyle get emergencyTextStyle => TextStyle(
    color: Colors.red[800],
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get warningTextStyle => TextStyle(
    color: Colors.orange[800],
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle get healthInsightStyle => TextStyle(
    color: CareCircleDesignTokens.healthGreen,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Healthcare-specific icons
  static Widget get aiAssistantAvatar => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: CareCircleDesignTokens.primaryMedicalBlue,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
            alpha: 0.3,
          ),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: const Icon(Icons.health_and_safety, color: Colors.white, size: 20),
  );

  static Widget get userAvatar => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
    child: Icon(Icons.person, color: Colors.grey[600], size: 20),
  );

  static Widget get emergencyIcon => Container(
    width: 24,
    height: 24,
    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    child: const Icon(Icons.emergency, color: Colors.white, size: 14),
  );

  static Widget get warningIcon => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.orange[600],
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.warning, color: Colors.white, size: 14),
  );

  static Widget get healthInsightIcon => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: CareCircleDesignTokens.healthGreen,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.insights, color: Colors.white, size: 14),
  );

  // Healthcare-specific animations
  static Widget buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          aiAssistantAvatar,
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: getAssistantMessageDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Assistant is analyzing',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
