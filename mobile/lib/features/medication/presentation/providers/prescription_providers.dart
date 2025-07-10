import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/services/prescription_processing_api_service.dart';
import '../../infrastructure/services/image_processing_service.dart';

// Healthcare-compliant logger for prescription context
final _logger = BoundedContextLoggers.medication;

/// Provider for prescription processing API service
final prescriptionProcessingApiServiceProvider =
    Provider<PrescriptionProcessingApiService>((ref) {
      // TODO: Get Dio instance from existing provider
      throw UnimplementedError('Dio provider not yet implemented');
    });

/// Provider for image processing service
final imageProcessingServiceProvider = Provider<ImageProcessingService>((ref) {
  final apiService = ref.read(prescriptionProcessingApiServiceProvider);
  return ImageProcessingService(apiService);
});

/// Provider for user prescriptions list
final prescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  // TODO: Implement prescription repository when available
  _logger.info('Fetching user prescriptions - not yet implemented', {
    'operation': 'getPrescriptions',
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return empty list for now
  return <Prescription>[];
});

/// Provider for prescription by ID
final prescriptionProvider = FutureProvider.family<Prescription?, String>((
  ref,
  prescriptionId,
) async {
  // TODO: Implement prescription repository when available
  _logger.info('Fetching prescription by ID - not yet implemented', {
    'operation': 'getPrescription',
    'prescriptionId': prescriptionId,
    'timestamp': DateTime.now().toIso8601String(),
  });

  // Return null for now
  return null;
});

/// Provider for OCR processing state
final ocrProcessingProvider =
    StateNotifierProvider<
      OCRProcessingNotifier,
      AsyncValue<OCRProcessingResult?>
    >((ref) {
      final imageProcessingService = ref.read(imageProcessingServiceProvider);
      return OCRProcessingNotifier(imageProcessingService);
    });

/// State notifier for OCR processing operations
class OCRProcessingNotifier
    extends StateNotifier<AsyncValue<OCRProcessingResult?>> {
  final ImageProcessingService _imageProcessingService;

  OCRProcessingNotifier(this._imageProcessingService)
    : super(const AsyncValue.data(null));

  /// Process image file for OCR
  Future<void> processImageFile(File imageFile) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Starting OCR processing', {
        'operation': 'processImageFile',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _imageProcessingService.processImageFile(imageFile);
      state = AsyncValue.data(result);

      _logger.info('OCR processing completed successfully', {
        'operation': 'processImageFile',
        'medicationCount': result.extractedMedications.length,
        'confidence': result.ocrData?.confidence ?? 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('OCR processing failed', {
        'operation': 'processImageFile',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Process image from URL for OCR
  Future<void> processImageUrl(String imageUrl) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Starting URL OCR processing', {
        'operation': 'processImageUrl',
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _imageProcessingService.processImageUrl(imageUrl);
      state = AsyncValue.data(result);

      _logger.info('URL OCR processing completed successfully', {
        'operation': 'processImageUrl',
        'medicationCount': result.extractedMedications.length,
        'confidence': result.ocrData?.confidence ?? 0.0,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stackTrace) {
      _logger.error('URL OCR processing failed', {
        'operation': 'processImageUrl',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Clear OCR results
  void clearResults() {
    state = const AsyncValue.data(null);
    _logger.info('OCR results cleared', {
      'operation': 'clearResults',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
