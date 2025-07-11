import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/design/design_tokens.dart';

/// Enhanced camera preview widget for prescription scanning
///
/// Provides professional camera interface with healthcare-appropriate
/// guidance and feedback for optimal prescription capture.
class CameraPreviewWidget extends StatefulWidget {
  final Function(XFile) onImageCaptured;
  final VoidCallback? onClose;

  const CameraPreviewWidget({
    super.key,
    required this.onImageCaptured,
    this.onClose,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _isCapturing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            // Camera preview placeholder with guidance
            _buildCameraPreviewArea(),

            // Top controls
            _buildTopControls(),

            // Bottom controls
            _buildBottomControls(),

            // Prescription frame overlay
            _buildPrescriptionFrameOverlay(),

            // Guidance text
            _buildGuidanceText(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreviewArea() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Camera Preview',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Position prescription within the frame',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),

          // Flash toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: _toggleFlash,
              icon: const Icon(Icons.flash_auto, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: _selectFromGallery,
              icon: const Icon(
                Icons.photo_library,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // Capture button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: GestureDetector(
                  onTap: _isCapturing ? null : _captureImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isCapturing
                          ? Colors.grey
                          : CareCircleDesignTokens.primaryMedicalBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: _isCapturing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 32,
                          ),
                  ),
                ),
              );
            },
          ),

          // Switch camera button
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionFrameOverlay() {
    return Positioned.fill(
      child: CustomPaint(painter: PrescriptionFramePainter()),
    );
  }

  Widget _buildGuidanceText() {
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            Text(
              'Prescription Scanning Tips',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Ensure good lighting\n'
              '• Keep prescription flat\n'
              '• Align within the frame\n'
              '• Avoid shadows and glare',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureImage() async {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      // Haptic feedback
      HapticFeedback.mediumImpact();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        widget.onImageCaptured(image);
      }
    } catch (e) {
      // Handle camera error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageCaptured(image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gallery error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleFlash() {
    // TODO: Implement flash toggle
    HapticFeedback.lightImpact();
  }

  void _switchCamera() {
    // TODO: Implement camera switch
    HapticFeedback.lightImpact();
  }
}

/// Custom painter for prescription frame overlay
class PrescriptionFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Calculate frame dimensions (4:3 aspect ratio)
    final frameWidth = size.width * 0.8;
    final frameHeight = frameWidth * 0.75;
    final left = (size.width - frameWidth) / 2;
    final top = (size.height - frameHeight) / 2;

    // Draw main frame
    final rect = Rect.fromLTWH(left, top, frameWidth, frameHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      paint,
    );

    // Draw corner guides
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + frameWidth - cornerLength, top),
      Offset(left + frameWidth, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top),
      Offset(left + frameWidth, top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + frameHeight - cornerLength),
      Offset(left, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + frameHeight),
      Offset(left + cornerLength, top + frameHeight),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + frameWidth - cornerLength, top + frameHeight),
      Offset(left + frameWidth, top + frameHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + frameWidth, top + frameHeight - cornerLength),
      Offset(left + frameWidth, top + frameHeight),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
