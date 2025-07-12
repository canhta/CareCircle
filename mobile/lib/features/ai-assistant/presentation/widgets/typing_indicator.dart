import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

/// Enhanced typing indicator with healthcare-appropriate animations and accessibility
class TypingIndicatorWidget extends StatefulWidget {
  final String? customMessage;
  final bool showAvatar;
  final bool isStreaming;

  const TypingIndicatorWidget({
    super.key,
    this.customMessage,
    this.showAvatar = true,
    this.isStreaming = false,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _dotsAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Dots animation for typing effect
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse animation for the container
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Slide in animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _dotsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    _slideController.forward();
    _dotsController.repeat();
    if (widget.isStreaming) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TypingIndicatorWidget oldWidget) {
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
    _dotsController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isStreaming ? _pulseAnimation.value : 1.0,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.showAvatar) ...[
                    _buildAIAvatar(),
                    const SizedBox(width: 8),
                  ],
                  _buildTypingBubble(),
                ],
              ),
            ),
          );
        },
      ),
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
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.psychology,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildTypingBubble() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 44,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50]!,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(18),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
        border: Border.all(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedDots(),
          const SizedBox(width: 8),
          _buildTypingText(),
        ],
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return AnimatedBuilder(
      animation: _dotsAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final animationValue = (_dotsAnimation.value - delay).clamp(0.0, 1.0);
            final scale = 0.5 + (animationValue * 0.5);
            final opacity = 0.3 + (animationValue * 0.7);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildTypingText() {
    final message = widget.customMessage ??
        (widget.isStreaming ? 'AI is responding...' : 'AI is thinking...');

    return Text(
      message,
      style: TextStyle(
        color: CareCircleDesignTokens.textSecondary,
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
