import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

/// Healthcare-compliant loading states for AI assistant interactions
class HealthcareLoadingStates {
  /// Subtle loading indicator for healthcare applications
  static Widget subtleLoader({
    String? message,
    double size = 24,
    Color? color,
  }) {
    return _HealthcareLoader(
      message: message,
      size: size,
      color: color ?? CareCircleDesignTokens.primaryMedicalBlue,
      type: _LoaderType.subtle,
    );
  }

  /// Streaming response loader with healthcare theming
  static Widget streamingLoader({String? message, bool showPulse = true}) {
    return _HealthcareLoader(
      message: message ?? 'AI is responding...',
      showPulse: showPulse,
      type: _LoaderType.streaming,
    );
  }

  /// Connection status loader for network operations
  static Widget connectionLoader({
    String? message,
    bool isReconnecting = false,
  }) {
    return _HealthcareLoader(
      message:
          message ?? (isReconnecting ? 'Reconnecting...' : 'Connecting...'),
      type: _LoaderType.connection,
    );
  }

  /// Processing loader for data operations
  static Widget processingLoader({
    String? message,
    double progress = 0.0,
    bool showProgress = false,
  }) {
    return _HealthcareLoader(
      message: message ?? 'Processing...',
      progress: progress,
      showProgress: showProgress,
      type: _LoaderType.processing,
    );
  }

  /// Emergency-style loader for urgent operations
  static Widget emergencyLoader({String? message}) {
    return _HealthcareLoader(
      message: message ?? 'Processing urgent request...',
      type: _LoaderType.emergency,
    );
  }
}

enum _LoaderType { subtle, streaming, connection, processing, emergency }

class _HealthcareLoader extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;
  final bool showPulse;
  final double progress;
  final bool showProgress;
  final _LoaderType type;

  const _HealthcareLoader({
    this.message,
    this.size = 24,
    this.color,
    this.showPulse = false,
    this.progress = 0.0,
    this.showProgress = false,
    required this.type,
  });

  @override
  State<_HealthcareLoader> createState() => _HealthcareLoaderState();
}

class _HealthcareLoaderState extends State<_HealthcareLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() {
    _fadeController.forward();

    switch (widget.type) {
      case _LoaderType.subtle:
      case _LoaderType.connection:
      case _LoaderType.processing:
        _rotationController.repeat();
        break;
      case _LoaderType.streaming:
        _pulseController.repeat(reverse: true);
        break;
      case _LoaderType.emergency:
        _rotationController.repeat();
        _pulseController.repeat(reverse: true);
        break;
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoader(),
            if (widget.message != null) ...[
              const SizedBox(height: 8),
              _buildMessage(),
            ],
            if (widget.showProgress) ...[
              const SizedBox(height: 8),
              _buildProgressBar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() {
    Widget loader;

    switch (widget.type) {
      case _LoaderType.subtle:
        loader = _buildSubtleLoader();
        break;
      case _LoaderType.streaming:
        loader = _buildStreamingLoader();
        break;
      case _LoaderType.connection:
        loader = _buildConnectionLoader();
        break;
      case _LoaderType.processing:
        loader = _buildProcessingLoader();
        break;
      case _LoaderType.emergency:
        loader = _buildEmergencyLoader();
        break;
    }

    return SizedBox(width: widget.size, height: widget.size, child: loader);
  }

  Widget _buildSubtleLoader() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? CareCircleDesignTokens.primaryMedicalBlue,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreamingLoader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showPulse ? _pulseAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  CareCircleDesignTokens.primaryMedicalBlue,
                  CareCircleDesignTokens.healthGreen,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildConnectionLoader() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Icon(
            Icons.sync,
            color: CareCircleDesignTokens.primaryMedicalBlue,
            size: widget.size,
          ),
        );
      },
    );
  }

  Widget _buildProcessingLoader() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            value: widget.showProgress ? widget.progress : null,
            valueColor: AlwaysStoppedAnimation<Color>(
              CareCircleDesignTokens.primaryMedicalBlue,
            ),
            backgroundColor: Colors.grey[300]!.withValues(alpha: 0.2),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyLoader() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.priority_high,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage() {
    Color textColor;
    FontWeight fontWeight;

    switch (widget.type) {
      case _LoaderType.emergency:
        textColor = Colors.red;
        fontWeight = FontWeight.w600;
        break;
      case _LoaderType.streaming:
        textColor = CareCircleDesignTokens.primaryMedicalBlue;
        fontWeight = FontWeight.w500;
        break;
      default:
        textColor = CareCircleDesignTokens.textSecondary;
        fontWeight = FontWeight.w400;
        break;
    }

    return Text(
      widget.message!,
      style: TextStyle(
        fontSize: 14,
        color: textColor,
        fontWeight: fontWeight,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 120,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey[300]!.withValues(alpha: 0.2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
      ),
    );
  }
}
