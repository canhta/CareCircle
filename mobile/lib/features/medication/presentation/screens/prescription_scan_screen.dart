import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../providers/prescription_providers.dart';

/// Prescription Scanning Screen for camera integration and OCR processing
///
/// Features:
/// - Camera integration for prescription photo capture
/// - Gallery image selection
/// - OCR processing and result verification
/// - Medication creation from OCR results
/// - Material Design 3 healthcare adaptations
class PrescriptionScanScreen extends ConsumerStatefulWidget {
  const PrescriptionScanScreen({super.key});

  @override
  ConsumerState<PrescriptionScanScreen> createState() =>
      _PrescriptionScanScreenState();
}

class _PrescriptionScanScreenState
    extends ConsumerState<PrescriptionScanScreen> {
  static final _logger = BoundedContextLoggers.medication;
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  bool _isProcessing = false;
  PrescriptionOCRResult? _ocrResult;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Prescription'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        actions: [
          if (_ocrResult != null)
            IconButton(
              onPressed: _savePrescription,
              icon: const Icon(Icons.save),
              tooltip: 'Save Prescription',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionsCard(theme),
            const SizedBox(height: 24),
            _buildImageSection(theme),
            const SizedBox(height: 24),
            if (_isProcessing) _buildProcessingSection(theme),
            if (_ocrResult != null) _buildResultsSection(theme),
            if (_errorMessage != null) _buildErrorSection(theme),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(theme),
    );
  }

  Widget _buildInstructionsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Scanning Instructions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionItem(
              'Ensure good lighting',
              Icons.wb_sunny,
              theme,
            ),
            _buildInstructionItem(
              'Keep prescription flat and straight',
              Icons.crop_rotate,
              theme,
            ),
            _buildInstructionItem(
              'Include all medication details',
              Icons.medication,
              theme,
            ),
            _buildInstructionItem(
              'Avoid shadows and glare',
              Icons.visibility,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prescription Image',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImage != null) ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _retakeImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _processImage,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.text_fields),
                      label: Text(_isProcessing ? 'Processing...' : 'Process'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            CareCircleDesignTokens.primaryMedicalBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                  color: theme.colorScheme.surfaceContainerLow,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No image selected',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo or select from gallery',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingSection(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Processing prescription...',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few moments',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(ThemeData theme) {
    if (_ocrResult == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: CareCircleDesignTokens.healthGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'OCR Results',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CareCircleDesignTokens.healthGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_ocrResult!.extractedMedications.isNotEmpty) ...[
              Text(
                'Extracted Medications (${_ocrResult!.extractedMedications.length}):',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ..._ocrResult!.medications.map(
                (med) => _buildMedicationCard(med, theme),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No medications were extracted. Please verify the image quality and try again.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_ocrResult!.confidence < 0.8) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Low confidence (${(_ocrResult!.confidence * 100).toInt()}%). Please verify the extracted information.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(String medication, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medication.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (medication.strength.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Strength: ${medication.strength}',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (medication.dosage.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Dosage: ${medication.dosage}',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (medication.instructions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Instructions: ${medication.instructions}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorSection(ThemeData theme) {
    if (_errorMessage == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: CareCircleDesignTokens.criticalAlert,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Processing Error',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CareCircleDesignTokens.criticalAlert,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_errorMessage!, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _selectFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      _logger.info('Taking prescription photo', {
        'operation': 'takePhoto',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _ocrResult = null;
          _errorMessage = null;
        });

        _logger.info('Photo taken successfully', {
          'operation': 'takePhoto',
          'imagePath': image.path,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      _logger.error('Failed to take photo', {
        'operation': 'takePhoto',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  Future<void> _selectFromGallery() async {
    try {
      _logger.info('Selecting prescription from gallery', {
        'operation': 'selectFromGallery',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _ocrResult = null;
          _errorMessage = null;
        });

        _logger.info('Image selected successfully', {
          'operation': 'selectFromGallery',
          'imagePath': image.path,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      _logger.error('Failed to select image', {
        'operation': 'selectFromGallery',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }

  void _retakeImage() {
    setState(() {
      _selectedImage = null;
      _ocrResult = null;
      _errorMessage = null;
    });
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      _logger.info('Processing prescription image', {
        'operation': 'processImage',
        'imagePath': _selectedImage!.path,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await ref
          .read(prescriptionOCRProvider.notifier)
          .processImage(_selectedImage!);

      if (mounted) {
        setState(() {
          _ocrResult = result;
          _isProcessing = false;
        });

        _logger.info('Image processed successfully', {
          'operation': 'processImage',
          'medicationsFound': result.extractedMedications.length,
          'confidence': result.confidence,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      _logger.error('Failed to process image', {
        'operation': 'processImage',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _savePrescription() async {
    if (_ocrResult == null || _selectedImage == null) return;

    try {
      _logger.info('Saving prescription', {
        'operation': 'savePrescription',
        'medicationsCount': _ocrResult!.extractedMedications.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final prescriptionRequest = CreatePrescriptionRequest(
        imageFile: File(_selectedImage!.path),
        ocrResult: _ocrResult!,
        prescribedBy: _ocrResult!.prescribedBy,
        prescribedDate: _ocrResult!.prescribedDate ?? DateTime.now(),
        notes: '',
      );

      await ref
          .read(prescriptionCreateProvider.notifier)
          .createPrescription(prescriptionRequest);

      if (mounted) {
        _logger.info('Prescription saved successfully', {
          'operation': 'savePrescription',
          'timestamp': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription saved successfully'),
            backgroundColor: CareCircleDesignTokens.healthGreen,
          ),
        );

        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      _logger.error('Failed to save prescription', {
        'operation': 'savePrescription',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save prescription: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.criticalAlert,
          ),
        );
      }
    }
  }
}
