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

/// Alias for OCR provider to match screen expectations
final prescriptionOCRProvider = ocrProcessingProvider;

/// Provider for prescription creation
final prescriptionCreateProvider =
    StateNotifierProvider<PrescriptionCreateNotifier, AsyncValue<Prescription?>>(
  (ref) {
    final apiService = ref.read(prescriptionProcessingApiServiceProvider);
    return PrescriptionCreateNotifier(apiService);
  },
);

/// State notifier for prescription creation
class PrescriptionCreateNotifier
    extends StateNotifier<AsyncValue<Prescription?>> {
  final PrescriptionProcessingApiService _apiService;

  PrescriptionCreateNotifier(this._apiService)
      : super(const AsyncValue.data(null));

  /// Create a new prescription from OCR result
  Future<Prescription> createFromOCR({
    required String prescribedBy,
    required DateTime prescribedDate,
    String? pharmacy,
    OCRProcessingResult? ocrResult,
    String? imageUrl,
    String? notes,
  }) async {
    _logger.info('Creating prescription from OCR', {
      'operation': 'createFromOCR',
      'prescribedBy': prescribedBy,
      'timestamp': DateTime.now().toIso8601String(),
    });

    state = const AsyncValue.loading();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final prescription = Prescription(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user',
        prescribedBy: prescribedBy,
        prescribedDate: prescribedDate,
        pharmacy: pharmacy,
        medications: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        verificationStatus: VerificationStatus.pending,
        dateIssued: prescribedDate,
        extractedMedications: ocrResult?.extractedMedications.cast<String>() ?? [],
      );

      state = AsyncValue.data(prescription);

      _logger.info('Prescription created successfully', {
        'operation': 'createFromOCR',
        'prescriptionId': prescription.id,
      });

      return prescription;
    } catch (error, stackTrace) {
      _logger.error('Failed to create prescription', error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
