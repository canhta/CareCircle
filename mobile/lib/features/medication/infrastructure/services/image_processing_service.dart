import 'dart:io';
import 'dart:typed_data';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import 'prescription_processing_api_service.dart';

/// Service for image processing and OCR operations
/// 
/// Handles:
/// - Image preprocessing for OCR
/// - OCR result processing and validation
/// - Image format conversion and optimization
/// - Error handling for image operations
class ImageProcessingService {
  final PrescriptionProcessingApiService _apiService;
  static final _logger = BoundedContextLoggers.medication;

  ImageProcessingService(this._apiService);

  /// Process image file for prescription OCR
  Future<OCRProcessingResult> processImageFile(File imageFile) async {
    try {
      _logger.info('Processing image file for OCR', {
        'operation': 'processImageFile',
        'fileSize': await imageFile.length(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Validate image file
      await _validateImageFile(imageFile);

      // Process with OCR API
      final result = await _apiService.processImageOCR(imageFile);

      _logger.info('Image OCR processing completed', {
        'operation': 'processImageFile',
        'success': result.success,
        'medicationCount': result.extractedMedications.length,
        'confidence': result.ocrData?.confidence ?? 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result;
    } catch (e) {
      _logger.error('Failed to process image file', {
        'operation': 'processImageFile',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Process image from URL
  Future<OCRProcessingResult> processImageUrl(String imageUrl) async {
    try {
      _logger.info('Processing image from URL for OCR', {
        'operation': 'processImageUrl',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _apiService.processUrlOCR({'imageUrl': imageUrl});

      _logger.info('URL image OCR processing completed', {
        'operation': 'processImageUrl',
        'success': result.success,
        'medicationCount': result.extractedMedications.length,
        'confidence': result.ocrData?.confidence ?? 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result;
    } catch (e) {
      _logger.error('Failed to process image URL', {
        'operation': 'processImageUrl',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  /// Validate image file before processing
  Future<void> _validateImageFile(File imageFile) async {
    // Check if file exists
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    // Check file size (max 10MB)
    final fileSize = await imageFile.length();
    if (fileSize > 10 * 1024 * 1024) {
      throw Exception('Image file too large (max 10MB)');
    }

    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
      throw Exception('Unsupported image format. Use JPG, PNG, or WebP');
    }
  }

  /// Preprocess image for better OCR results
  Future<Uint8List?> preprocessImage(Uint8List imageBytes) async {
    try {
      _logger.info('Preprocessing image for OCR', {
        'operation': 'preprocessImage',
        'originalSize': imageBytes.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // TODO: Add image preprocessing logic when image packages are available
      // - Resize if too large
      // - Enhance contrast
      // - Reduce noise
      // - Convert to optimal format

      return imageBytes;
    } catch (e) {
      _logger.warning('Image preprocessing failed, using original', {
        'operation': 'preprocessImage',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      return imageBytes;
    }
  }

  /// Validate OCR results
  bool validateOCRResults(OCRProcessingResult result) {
    // Check if processing was successful
    if (!result.success) {
      _logger.warning('OCR processing failed', {
        'error': result.error,
      });
      return false;
    }

    // Check overall confidence threshold
    final confidence = result.ocrData?.confidence ?? 0.0;
    if (confidence < 0.5) {
      _logger.warning('OCR confidence below threshold', {
        'confidence': confidence,
        'threshold': 0.5,
      });
      return false;
    }

    // Check if any medications were extracted
    if (result.extractedMedications.isEmpty) {
      _logger.warning('No medications extracted from OCR');
      return false;
    }

    return true;
  }
}
