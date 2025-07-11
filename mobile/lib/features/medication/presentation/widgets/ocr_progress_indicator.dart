import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

/// Healthcare-compliant OCR progress indicator
/// 
/// Provides clear visual feedback during prescription OCR processing
/// with professional animations and status messages.
class OCRProgressIndicator extends StatefulWidget {
  final double progress;
  final String statusMessage;
  final bool isComplete;
  final bool hasError;
  final VoidCallback? onRetry;

  const OCRProgressIndicator({
    super.key,
    required this.progress,
    required this.statusMessage,
    this.isComplete = false,
    this.hasError = false,
    this.onRetry,
  });

  @override
  State<OCRProgressIndicator> createState() => _OCRProgressIndicatorState();
}

class _OCRProgressIndicatorState extends State<OCRProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (!widget.isComplete && !widget.hasError) {
      _rotationController.repeat();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OCRProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isComplete || widget.hasError) {
      _rotationController.stop();
      _pulseController.stop();
    } else if (!oldWidget.isComplete && !oldWidget.hasError) {
      _rotationController.repeat();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 20),
          _buildStatusText(),
          if (widget.hasError && widget.onRetry != null) ...[
            const SizedBox(height: 16),
            _buildRetryButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (widget.hasError) {
      return _buildErrorIndicator();
    } else if (widget.isComplete) {
      return _buildSuccessIndicator();
    } else {
      return _buildLoadingIndicator();
    }
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
            ),
          ),
          
          // Progress circle
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: widget.progress,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Rotating scanner icon
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Icon(
                  Icons.document_scanner,
                  size: 24,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessIndicator() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.check_circle,
        size: 40,
        color: Colors.green,
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withValues(alpha: 0.1),
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.error_outline,
        size: 40,
        color: Colors.red,
      ),
    );
  }

  Widget _buildStatusText() {
    Color textColor;
    if (widget.hasError) {
      textColor = Colors.red;
    } else if (widget.isComplete) {
      textColor = Colors.green;
    } else {
      textColor = Colors.grey[700]!;
    }

    return Column(
      children: [
        Text(
          widget.statusMessage,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (!widget.isComplete && !widget.hasError) ...[
          const SizedBox(height: 8),
          Text(
            '${(widget.progress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry Scanning'),
        style: ElevatedButton.styleFrom(
          backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

/// OCR processing stages for better user feedback
enum OCRProcessingStage {
  initializing('Initializing scanner...', 0.1),
  preprocessing('Preprocessing image...', 0.3),
  textExtraction('Extracting text...', 0.6),
  medicationParsing('Parsing medication data...', 0.8),
  validation('Validating results...', 0.9),
  complete('Processing complete!', 1.0);

  const OCRProcessingStage(this.message, this.progress);
  
  final String message;
  final double progress;
}

/// Enhanced OCR progress widget with stage-based feedback
class EnhancedOCRProgressIndicator extends StatelessWidget {
  final OCRProcessingStage currentStage;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const EnhancedOCRProgressIndicator({
    super.key,
    required this.currentStage,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return OCRProgressIndicator(
      progress: currentStage.progress,
      statusMessage: hasError ? (errorMessage ?? 'Processing failed') : currentStage.message,
      isComplete: currentStage == OCRProcessingStage.complete && !hasError,
      hasError: hasError,
      onRetry: onRetry,
    );
  }
}
