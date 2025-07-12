import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';

/// Enhanced message bubble with streaming awareness and healthcare-appropriate design
class EnhancedMessageBubble extends ConsumerStatefulWidget {
  final String messageId;
  final String content;
  final bool isUser;
  final bool isStreaming;
  final DateTime timestamp;
  final VoidCallback? onTap;
  final bool showTimestamp;
  final bool showMedicalDisclaimer;

  const EnhancedMessageBubble({
    super.key,
    required this.messageId,
    required this.content,
    required this.isUser,
    this.isStreaming = false,
    required this.timestamp,
    this.onTap,
    this.showTimestamp = false,
    this.showMedicalDisclaimer = false,
  });

  @override
  ConsumerState<EnhancedMessageBubble> createState() =>
      _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends ConsumerState<EnhancedMessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    // Slide in animation
    _slideController = AnimationController(
      duration: CareCircleAnimationTokens.moderate,
      vsync: this,
    );

    // Fade in animation
    _fadeController = AnimationController(
      duration: CareCircleAnimationTokens.fast,
      vsync: this,
    );

    // Pulse animation for streaming messages
    _pulseController = AnimationController(
      duration: CareCircleAnimationTokens.slow,
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(
          begin: widget.isUser ? const Offset(0.3, 0) : const Offset(-0.3, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: CareCircleAnimationTokens.gentleEase,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: CareCircleAnimationTokens.standardEase,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: CareCircleAnimationTokens.gentleEase,
      ),
    );
  }

  void _startEntryAnimation() {
    _fadeController.forward();
    _slideController.forward();

    if (widget.isStreaming) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EnhancedMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle streaming state changes
    if (oldWidget.isStreaming && !widget.isStreaming) {
      _pulseController.stop();
      _pulseController.reset();
    } else if (!oldWidget.isStreaming && widget.isStreaming) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isStreaming ? _pulseAnimation.value : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: widget.isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!widget.isUser) ...[
                      _buildAIAvatar(),
                      const SizedBox(width: 12),
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: widget.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _buildMessageBubble(),
                          if (widget.showTimestamp) ...[
                            const SizedBox(height: 4),
                            _buildTimestamp(),
                          ],
                          if (widget.showMedicalDisclaimer &&
                              !widget.isUser) ...[
                            const SizedBox(height: 8),
                            _buildMedicalDisclaimer(),
                          ],
                        ],
                      ),
                    ),
                    if (widget.isUser) ...[
                      const SizedBox(width: 8),
                      _buildUserAvatar(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          minHeight: 44,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: _buildBubbleDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageContent(),
            if (widget.isStreaming) ...[
              const SizedBox(height: 4),
              _buildStreamingIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBubbleDecoration() {
    if (widget.isUser) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CareCircleDesignTokens.primaryMedicalBlue,
            CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(4),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
    } else {
      return BoxDecoration(
        color: widget.isStreaming ? Colors.grey[50]! : Colors.grey[100]!,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(18),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        border: Border.all(
          color: widget.isStreaming
              ? CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3)
              : Colors.grey[300]!.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
  }

  Widget _buildMessageContent() {
    return SelectableText(
      widget.content.isEmpty ? ' ' : widget.content,
      style: TextStyle(
        fontSize: 16,
        height: 1.4,
        color: widget.isUser
            ? Colors.white
            : CareCircleDesignTokens.textPrimary,
        fontWeight: widget.isUser ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }

  Widget _buildStreamingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Streaming...',
          style: TextStyle(
            fontSize: 12,
            color: CareCircleDesignTokens.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildAIAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CareCircleDesignTokens.primaryMedicalBlue,
            CareCircleDesignTokens.healthGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
      child: const Icon(Icons.psychology, color: Colors.white, size: 18),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
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
      child: const Icon(Icons.person, color: Colors.white, size: 18),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isUser ? 0 : 24,
        right: widget.isUser ? 24 : 0,
      ),
      child: Text(
        _formatTimestamp(widget.timestamp),
        style: TextStyle(
          fontSize: 11,
          color: CareCircleDesignTokens.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Container(
      margin: EdgeInsets.only(left: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 14, color: Colors.orange),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'AI advice is for informational purposes only. Consult your healthcare provider.',
              style: TextStyle(
                fontSize: 10,
                color: CareCircleDesignTokens.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
