import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emergency icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emergency, color: Colors.white, size: 30),
          ),

          const SizedBox(height: 16),

          // Emergency title
          Text(
            'Emergency Detected',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[800],
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Emergency message
          Text(
            'Your message suggests this might be a medical emergency. If you are experiencing a life-threatening situation, please contact emergency services immediately.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.red[700]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // User message context
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"$message"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              // Emergency services button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onEmergencyConfirmed,
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    'Call Emergency',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // False alarm button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onFalseAlarm,
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  label: Text(
                    'Continue Chat',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Emergency numbers info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Text(
                  'Emergency Numbers',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEmergencyNumber(context, '911', 'Emergency'),
                    _buildEmergencyNumber(context, '115', 'Vietnam Emergency'),
                    _buildEmergencyNumber(context, '113', 'Police'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumber(
    BuildContext context,
    String number,
    String label,
  ) {
    return Column(
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blue[600]),
        ),
      ],
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
