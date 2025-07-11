import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';

class EmergencyDetectionWidget extends ConsumerWidget {
  final String message;
  final VoidCallback onEmergencyConfirmed;
  final VoidCallback onFalseAlarm;

  const EmergencyDetectionWidget({
    super.key,
    required this.message,
    required this.onEmergencyConfirmed,
    required this.onFalseAlarm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height *
            0.8, // Limit height to 80% of screen
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CareCircleDesignTokens.criticalAlert,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CareCircleDesignTokens.criticalAlert.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emergency header with icon and title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  // Emergency icon with better styling
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: CareCircleDesignTokens.criticalAlert,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CareCircleDesignTokens.criticalAlert
                              .withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Emergency title
                  Text(
                    'Emergency Detected',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CareCircleDesignTokens.criticalAlert,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Emergency message with better typography
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Text(
                'Your message suggests this might be a medical emergency. If you are experiencing a life-threatening situation, please contact emergency services immediately.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[800],
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // User message context with improved styling
            if (message.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Text(
                  '"$message"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Action buttons with improved styling
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  // Emergency services button
                  SizedBox(
                    width: double.infinity,
                    height: CareCircleDesignTokens.emergencyButtonMin,
                    child: ElevatedButton.icon(
                      onPressed: onEmergencyConfirmed,
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Call Emergency',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CareCircleDesignTokens.criticalAlert,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: CareCircleDesignTokens.criticalAlert
                            .withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // False alarm button
                  SizedBox(
                    width: double.infinity,
                    height: CareCircleDesignTokens.touchTargetMin,
                    child: OutlinedButton.icon(
                      onPressed: onFalseAlarm,
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                      label: Text(
                        'Continue Chat',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Emergency numbers info with improved design
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                  alpha: 0.05,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                    alpha: 0.2,
                  ),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Emergency Numbers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildEmergencyNumber(context, '911', 'Emergency'),
                      const SizedBox(width: 8),
                      _buildEmergencyNumber(
                        context,
                        '115',
                        'Vietnam Emergency',
                      ),
                      const SizedBox(width: 8),
                      _buildEmergencyNumber(context, '113', 'Police'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyNumber(
    BuildContext context,
    String number,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.3,
            ),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CareCircleDesignTokens.primaryMedicalBlue,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                  alpha: 0.8,
                ),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Emergency detection service
class EmergencyDetectionService {
  static const List<String> _emergencyKeywords = [
    'emergency',
    'help',
    'urgent',
    'chest pain',
    'heart attack',
    'stroke',
    'bleeding',
    'unconscious',
    'overdose',
    'suicide',
    'can\'t breathe',
    'choking',
    'severe pain',
    'accident',
    'injury',
    'ambulance',
    'hospital',
    'dying',
    'critical',
    'life threatening',
  ];

  static bool detectEmergency(String message) {
    final lowerMessage = message.toLowerCase();

    // Check for emergency keywords
    for (final keyword in _emergencyKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }

    // Check for urgent patterns
    if (lowerMessage.contains(
      RegExp(r'\b(call|need)\s+(911|115|ambulance|doctor)\b'),
    )) {
      return true;
    }

    // Check for pain intensity indicators
    if (lowerMessage.contains(
      RegExp(r'\b(severe|extreme|unbearable|10/10)\s+pain\b'),
    )) {
      return true;
    }

    return false;
  }

  static String getEmergencyAdvice(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('chest pain') ||
        lowerMessage.contains('heart attack')) {
      return 'For chest pain or suspected heart attack:\n'
          '• Call emergency services immediately\n'
          '• Chew aspirin if not allergic\n'
          '• Stay calm and sit upright\n'
          '• Do not drive yourself';
    }

    if (lowerMessage.contains('stroke')) {
      return 'For suspected stroke (FAST signs):\n'
          '• Face drooping\n'
          '• Arm weakness\n'
          '• Speech difficulty\n'
          '• Time to call emergency services';
    }

    if (lowerMessage.contains('bleeding')) {
      return 'For severe bleeding:\n'
          '• Apply direct pressure\n'
          '• Elevate if possible\n'
          '• Call emergency services\n'
          '• Do not remove embedded objects';
    }

    return 'If this is a medical emergency:\n'
        '• Call emergency services immediately\n'
        '• Stay on the line with dispatcher\n'
        '• Follow their instructions\n'
        '• Have someone stay with you if possible';
  }
}
