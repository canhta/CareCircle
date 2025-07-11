import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/repositories/prescription_repository.dart';
import '../../infrastructure/services/prescription_processing_api_service.dart';
import '../../infrastructure/services/medication_api_service.dart';
import '../../infrastructure/services/image_processing_service.dart';

// Healthcare-compliant logger for prescription context
final _logger = BoundedContextLoggers.medication;

/// Provider for prescription processing API service
final prescriptionProcessingApiServiceProvider = Provider<PrescriptionProcessingApiService>((ref) {
  final dio = ref.read(medicationDioProvider);
  return PrescriptionProcessingApiService(dio);
});

/// Provider for image processing service
final imageProcessingServiceProvider = Provider<ImageProcessingService>((ref) {
  final apiService = ref.read(prescriptionProcessingApiServiceProvider);
  return ImageProcessingService(apiService);
});

/// Provider for user prescriptions list
final prescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  final repository = ref.read(prescriptionRepositoryProvider);
  return repository.getPrescriptions();
});

/// Provider for prescription by ID
final prescriptionProvider = FutureProvider.family<Prescription?, String>((ref, prescriptionId) async {
  final repository = ref.read(prescriptionRepositoryProvider);
  return repository.getPrescriptionById(prescriptionId);
});

/// Provider for OCR processing state
final ocrProcessingProvider = StateNotifierProvider<OCRProcessingNotifier, AsyncValue<OCRProcessingResult?>>((ref) {
  final imageProcessingService = ref.read(imageProcessingServiceProvider);
  return OCRProcessingNotifier(imageProcessingService);
});

/// State notifier for OCR processing operations
class OCRProcessingNotifier extends StateNotifier<AsyncValue<OCRProcessingResult?>> {
  final ImageProcessingService _imageProcessingService;

  OCRProcessingNotifier(this._imageProcessingService) : super(const AsyncValue.data(null));

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
    _logger.info('OCR results cleared', {'operation': 'clearResults', 'timestamp': DateTime.now().toIso8601String()});
  }
}

/// Alias for OCR provider to match screen expectations
final prescriptionOCRProvider = ocrProcessingProvider;

/// Provider for prescription creation
final prescriptionCreateProvider = StateNotifierProvider<PrescriptionCreateNotifier, AsyncValue<Prescription?>>((ref) {
  final apiService = ref.read(medicationApiServiceProvider);
  return PrescriptionCreateNotifier(apiService);
});

/// State notifier for prescription creation
class PrescriptionCreateNotifier extends StateNotifier<AsyncValue<Prescription?>> {
  final MedicationApiService _apiService;

  PrescriptionCreateNotifier(this._apiService) : super(const AsyncValue.data(null));

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
      // Create OCR data from result if available
      OCRData? ocrData;
      if (ocrResult != null) {
        ocrData = OCRData(
          extractedText: ocrResult.ocrData?.extractedText ?? '',
          confidence: ocrResult.ocrData?.confidence ?? 0.0,
          fields: ocrResult.ocrData?.fields ?? const OCRFields(),
          processingMetadata:
              ocrResult.ocrData?.processingMetadata ??
              const ProcessingMetadata(
                ocrEngine: 'unknown',
                processingTime: 0.0,
                imageQuality: 0.0,
                extractionMethod: 'unknown',
              ),
        );
      }

      // Create prescription request
      final request = CreatePrescriptionRequest(
        prescribedBy: prescribedBy,
        prescribedDate: prescribedDate,
        pharmacy: pharmacy,
        imageUrl: imageUrl,
        ocrData: ocrData,
      );

      // Call API service to create prescription
      final response = await _apiService.createPrescription(request);

      // Extract prescription from response
      if (response.success && response.data != null) {
        final prescription = response.data!;
        state = AsyncValue.data(prescription);

        _logger.info('Prescription created successfully', {
          'operation': 'createFromOCR',
          'prescriptionId': prescription.id,
        });

        return prescription;
      } else {
        throw Exception(response.error ?? 'Failed to create prescription');
      }
    } catch (error, stackTrace) {
      _logger.error('Failed to create prescription', error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
