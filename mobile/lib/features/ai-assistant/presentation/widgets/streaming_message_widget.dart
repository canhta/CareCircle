import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../providers/ai_assistant_providers.dart';

/// Healthcare-compliant streaming message widget that displays AI responses
/// with progressive character-by-character animation
class StreamingMessageWidget extends ConsumerStatefulWidget {
  final String messageId;
  final String authorId;
  final DateTime createdAt;
  final Stream<String> textStream;
  final VoidCallback? onStreamComplete;

  const StreamingMessageWidget({
    super.key,
    required this.messageId,
    required this.authorId,
    required this.createdAt,
    required this.textStream,
    this.onStreamComplete,
  });

  @override
  ConsumerState<StreamingMessageWidget> createState() => _StreamingMessageWidgetState();
}

class _StreamingMessageWidgetState extends ConsumerState<StreamingMessageWidget>
    with TickerProviderStateMixin {
  String _displayedText = '';
  bool _isStreaming = true;
  bool _hasError = false;
  StreamSubscription<String>? _streamSubscription;
  
  // Animation controllers for healthcare-appropriate effects
  late AnimationController _typingController;
  late AnimationController _fadeController;
  late Animation<double> _typingAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStreaming();
  }

  void _initializeAnimations() {
    // Subtle typing indicator animation - healthcare appropriate
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _typingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start subtle animations
    _typingController.repeat(reverse: true);
    _fadeController.forward();
  }

  void _startStreaming() {
    _streamSubscription = widget.textStream.listen(
      (chunk) {
        if (mounted) {
          setState(() {
            _displayedText += chunk;
          });
          
          // Update streaming state in provider
          ref.read(streamingStateProvider.notifier).state = StreamingState(
            isStreaming: true,
            currentContent: _displayedText,
            isComplete: false,
          );
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isStreaming = false;
          });
          
          _typingController.stop();
          
          // Update streaming state to complete
          ref.read(streamingStateProvider.notifier).state = StreamingState(
            isStreaming: false,
            currentContent: _displayedText,
            isComplete: true,
          );
          
          widget.onStreamComplete?.call();
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isStreaming = false;
            _hasError = true;
          });
          
          _typingController.stop();
          
          // Update streaming state with error
          ref.read(streamingStateProvider.notifier).state = StreamingState(
            isStreaming: false,
            currentContent: _displayedText,
            isComplete: true,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _typingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        constraints: const BoxConstraints(minHeight: CareCircleSpacingTokens.touchTargetMin), // Healthcare 44px minimum
        padding: const EdgeInsets.symmetric(
          horizontal: CareCircleSpacingTokens.md,
          vertical: CareCircleSpacingTokens.sm,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: CareCircleSpacingTokens.xs,
          horizontal: CareCircleSpacingTokens.md,
        ),
        decoration: BoxDecoration(
          color: CareCircleColorTokens.lightColorScheme.surface,
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          border: Border.all(
            color: _hasError
                ? CareCircleColorTokens.criticalAlert.withValues(alpha: 0.3)
                : CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message content with progressive display
            SelectableText(
              _displayedText.isEmpty ? ' ' : _displayedText, // Prevent empty collapse
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: _hasError
                    ? CareCircleColorTokens.criticalAlert
                    : CareCircleDesignTokens.textPrimary,
              ),
            ),
            
            // Streaming indicator
            if (_isStreaming) ...[
              const SizedBox(height: CareCircleSpacingTokens.sm),
              _buildStreamingIndicator(),
            ],

            // Error indicator
            if (_hasError) ...[
              const SizedBox(height: CareCircleSpacingTokens.sm),
              _buildErrorIndicator(),
            ],

            // Medical disclaimer for completed messages
            if (!_isStreaming && !_hasError && _displayedText.isNotEmpty) ...[
              const SizedBox(height: CareCircleSpacingTokens.md),
              _buildMedicalDisclaimer(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStreamingIndicator() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _typingAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _typingAnimation.value,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          'AI is responding...',
          style: TextStyle(
            fontSize: 12,
            color: CareCircleDesignTokens.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorIndicator() {
    return Row(
      children: [
        Icon(
          Icons.error_outline,
          size: 16,
          color: CareCircleColorTokens.criticalAlert,
        ),
        const SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          'Response interrupted. Please try again.',
          style: TextStyle(
            fontSize: 12,
            color: CareCircleColorTokens.criticalAlert,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(CareCircleSpacingTokens.sm),
      decoration: BoxDecoration(
        color: CareCircleColorTokens.warningAmber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
        border: Border.all(
          color: CareCircleColorTokens.warningAmber.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: CareCircleColorTokens.warningAmber,
          ),
          const SizedBox(width: CareCircleSpacingTokens.xs),
          Expanded(
            child: Text(
              'This AI advice is for informational purposes only. Consult your healthcare provider for medical decisions.',
              style: TextStyle(
                fontSize: 11,
                color: CareCircleDesignTokens.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
