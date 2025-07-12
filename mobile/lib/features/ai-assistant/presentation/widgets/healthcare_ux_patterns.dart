import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design/design_tokens.dart';

/// Healthcare-specific UX patterns for AI assistant interactions
class HealthcareUXPatterns {
  
  /// Medical disclaimer banner with healthcare-appropriate styling
  static Widget medicalDisclaimer({
    String? customText,
    VoidCallback? onDismiss,
    bool isDismissible = false,
  }) {
    return _MedicalDisclaimerBanner(
      customText: customText,
      onDismiss: onDismiss,
      isDismissible: isDismissible,
    );
  }

  /// Emergency escalation button for urgent healthcare situations
  static Widget emergencyEscalation({
    required VoidCallback onPressed,
    String? customText,
  }) {
    return _EmergencyEscalationButton(
      onPressed: onPressed,
      customText: customText,
    );
  }

  /// Healthcare-compliant input field with medical context awareness
  static Widget healthcareInput({
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onSubmit,
    bool isEmergency = false,
    int maxLines = 1,
  }) {
    return _HealthcareInputField(
      controller: controller,
      hintText: hintText,
      onSubmit: onSubmit,
      isEmergency: isEmergency,
      maxLines: maxLines,
    );
  }

  /// Accessibility-enhanced message actions
  static Widget messageActions({
    required String messageId,
    required String messageContent,
    VoidCallback? onCopy,
    VoidCallback? onShare,
    VoidCallback? onReport,
  }) {
    return _MessageActionsWidget(
      messageId: messageId,
      messageContent: messageContent,
      onCopy: onCopy,
      onShare: onShare,
      onReport: onReport,
    );
  }

  /// Healthcare privacy notice with compliance information
  static Widget privacyNotice({
    VoidCallback? onLearnMore,
    bool isCollapsed = true,
  }) {
    return _PrivacyNoticeWidget(
      onLearnMore: onLearnMore,
      isCollapsed: isCollapsed,
    );
  }
}

class _MedicalDisclaimerBanner extends StatelessWidget {
  final String? customText;
  final VoidCallback? onDismiss;
  final bool isDismissible;

  const _MedicalDisclaimerBanner({
    this.customText,
    this.onDismiss,
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_information_outlined,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Disclaimer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customText ?? 
                  'This AI assistant provides general health information only. '
                  'Always consult with qualified healthcare professionals for medical advice, '
                  'diagnosis, or treatment. In case of emergency, contact emergency services immediately.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: CareCircleDesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isDismissible && onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: CareCircleDesignTokens.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmergencyEscalationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? customText;

  const _EmergencyEscalationButton({
    required this.onPressed,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.emergency, color: Colors.white),
        label: Text(
          customText ?? 'Emergency? Get Immediate Help',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class _HealthcareInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback? onSubmit;
  final bool isEmergency;
  final int maxLines;

  const _HealthcareInputField({
    required this.controller,
    this.hintText,
    this.onSubmit,
    this.isEmergency = false,
    this.maxLines = 1,
  });

  @override
  State<_HealthcareInputField> createState() => _HealthcareInputFieldState();
}

class _HealthcareInputFieldState extends State<_HealthcareInputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isEmergency 
              ? Colors.red
              : _isFocused 
                  ? CareCircleDesignTokens.primaryMedicalBlue
                  : Colors.grey[300]!.withValues(alpha: 0.3),
          width: widget.isEmergency ? 2 : 1,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: (widget.isEmergency 
                  ? Colors.red 
                  : CareCircleDesignTokens.primaryMedicalBlue).withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              onSubmitted: (_) => widget.onSubmit?.call(),
              onTap: () => setState(() => _isFocused = true),
              onTapOutside: (_) => setState(() => _isFocused = false),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Type your health question...',
                hintStyle: TextStyle(
                  color: CareCircleDesignTokens.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: TextStyle(
                fontSize: 16,
                color: CareCircleDesignTokens.textPrimary,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            IconButton(
              onPressed: widget.onSubmit,
              icon: Icon(
                Icons.send,
                color: widget.isEmergency 
                    ? Colors.red
                    : CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
        ],
      ),
    );
  }
}

class _MessageActionsWidget extends StatelessWidget {
  final String messageId;
  final String messageContent;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onReport;

  const _MessageActionsWidget({
    required this.messageId,
    required this.messageContent,
    this.onCopy,
    this.onShare,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            icon: Icons.copy,
            label: 'Copy',
            onPressed: onCopy ?? () => _copyToClipboard(context),
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.share,
            label: 'Share',
            onPressed: onShare ?? () => _shareMessage(context),
          ),
          const SizedBox(width: 8),
          _ActionButton(
            icon: Icons.report_outlined,
            label: 'Report',
            onPressed: onReport ?? () => _reportMessage(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: messageContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportMessage(BuildContext context) {
    // Implement report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for reporting. We will review this message.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.grey[50]!,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDestructive 
                ? Colors.red.withValues(alpha: 0.3)
                : Colors.grey[300]!.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDestructive 
                  ? Colors.red
                  : CareCircleDesignTokens.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDestructive 
                    ? Colors.red
                    : CareCircleDesignTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyNoticeWidget extends StatefulWidget {
  final VoidCallback? onLearnMore;
  final bool isCollapsed;

  const _PrivacyNoticeWidget({
    this.onLearnMore,
    this.isCollapsed = true,
  });

  @override
  State<_PrivacyNoticeWidget> createState() => _PrivacyNoticeWidgetState();
}

class _PrivacyNoticeWidgetState extends State<_PrivacyNoticeWidget> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.isCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100]!,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey[300]!.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isCollapsed = !_isCollapsed),
            child: Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  size: 16,
                  color: CareCircleDesignTokens.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Privacy & Data Protection',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CareCircleDesignTokens.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isCollapsed ? Icons.expand_more : Icons.expand_less,
                  size: 16,
                  color: CareCircleDesignTokens.textSecondary,
                ),
              ],
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(height: 8),
            Text(
              'Your health conversations are encrypted and processed securely. '
              'We follow HIPAA compliance standards to protect your medical information.',
              style: TextStyle(
                fontSize: 11,
                height: 1.3,
                color: CareCircleDesignTokens.textSecondary,
              ),
            ),
            if (widget.onLearnMore != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: widget.onLearnMore,
                child: Text(
                  'Learn more about our privacy practices',
                  style: TextStyle(
                    fontSize: 11,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
