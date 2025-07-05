import 'dart:io';
import 'package:dio/dio.dart';
import '../../../common/common.dart';
import '../domain/prescription_models.dart';
import '../domain/prescription_repository.dart';

/// Implementation of PrescriptionRepository
class PrescriptionService extends BaseRepository
    implements PrescriptionRepository {
  PrescriptionService({
    required super.apiClient,
    required super.logger,
  });

  @override
  Future<Result<PrescriptionOCRResponse>> scanPrescription(
    File imageFile, {
    PrescriptionScanOptions? options,
  }) async {
    try {
      final scanOptions = options ?? const PrescriptionScanOptions();

      logger.info('Starting prescription scan', data: {
        'fileName': _getFileName(imageFile),
        'fileSize': await _getFileSize(imageFile),
      });

      // Validate file before processing
      if (!scanOptions.isValidFile(imageFile)) {
        logger.warning('Invalid file format for prescription scan');
        return Result.failure(
          const NetworkException(
            'Invalid image file format. Please use JPG, PNG, or WEBP.',
            type: NetworkExceptionType.badRequest,
          ),
        );
      }

      final isValidSize = await scanOptions.isFileSizeValid(imageFile);
      if (!isValidSize) {
        logger.warning('File size too large for prescription scan');
        return Result.failure(
          const NetworkException(
            'File size too large. Maximum size is 10MB.',
            type: NetworkExceptionType.badRequest,
          ),
        );
      }

      // Create form data with the image file
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: _getFileName(imageFile),
        ),
      });

      logger.info('Uploading prescription image for OCR processing');

      final response = await apiClient.post(
        ApiEndpoints.prescriptionScan,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final result = PrescriptionOCRResponse.fromJson(response.data);

      logger.info('Prescription scan completed successfully', data: {
        'confidence': result.confidence,
        'drugName': result.extractedData.drugName,
      });

      return Result.success(result);
    } catch (e) {
      logger.error('Failed to scan prescription', error: e);
      return Result.failure(
        NetworkException(
          'Failed to scan prescription image',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<PrescriptionPaginatedResponse>> getPrescriptions({
    int page = 1,
    int limit = 20,
    PrescriptionFilterOptions? filters,
  }) async {
    try {
      logger.info('Fetching prescriptions', data: {
        'page': page,
        'limit': limit,
        'filters': filters?.toJson(),
      });

      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      // Add filter parameters if provided
      if (filters != null) {
        final filterParams = filters.toJson();
        filterParams.forEach((key, value) {
          if (value != null) {
            queryParameters[key] = value;
          }
        });
      }

      final response = await apiClient.get(
        ApiEndpoints.prescriptions,
        queryParameters: queryParameters,
      );

      final result =
          PrescriptionPaginatedResponse.fromJson(response.data['data']);

      logger.info('Successfully fetched prescriptions', data: {
        'count': result.prescriptions.length,
        'total': result.total,
      });

      return Result.success(result);
    } catch (e) {
      logger.error('Failed to fetch prescriptions', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch prescriptions',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<PrescriptionModel>> getPrescription(
      String prescriptionId) async {
    try {
      logger.info('Fetching prescription',
          data: {'prescriptionId': prescriptionId});

      final response = await apiClient.get(
        ApiEndpoints.prescription.replaceAll('{id}', prescriptionId),
      );

      final result = PrescriptionModel.fromJson(response.data['data']);

      logger.info('Successfully fetched prescription');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to fetch prescription', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch prescription',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<PrescriptionModel>> createPrescription(
    Map<String, dynamic> prescriptionData,
  ) async {
    try {
      logger.info('Creating prescription', data: prescriptionData);

      final response = await apiClient.post(
        ApiEndpoints.prescriptions,
        data: prescriptionData,
      );

      final result = PrescriptionModel.fromJson(response.data['data']);

      logger.info('Successfully created prescription', data: {'id': result.id});
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to create prescription', error: e);
      return Result.failure(
        NetworkException(
          'Failed to create prescription',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<PrescriptionModel>> updatePrescription(
    String prescriptionId,
    Map<String, dynamic> prescriptionData,
  ) async {
    try {
      logger.info('Updating prescription', data: {
        'prescriptionId': prescriptionId,
        'data': prescriptionData,
      });

      final response = await apiClient.put(
        ApiEndpoints.prescription.replaceAll('{id}', prescriptionId),
        data: prescriptionData,
      );

      final result = PrescriptionModel.fromJson(response.data['data']);

      logger.info('Successfully updated prescription');
      return Result.success(result);
    } catch (e) {
      logger.error('Failed to update prescription', error: e);
      return Result.failure(
        NetworkException(
          'Failed to update prescription',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deletePrescription(String prescriptionId) async {
    try {
      logger.info('Deleting prescription',
          data: {'prescriptionId': prescriptionId});

      await apiClient.delete(
        ApiEndpoints.prescription.replaceAll('{id}', prescriptionId),
      );

      logger.info('Successfully deleted prescription');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to delete prescription', error: e);
      return Result.failure(
        NetworkException(
          'Failed to delete prescription',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<PrescriptionModel>>> getPatientPrescriptions(
    String patientId,
  ) async {
    try {
      logger.info('Fetching patient prescriptions',
          data: {'patientId': patientId});

      final response = await apiClient.get(
        ApiEndpoints.patientPrescriptions.replaceAll('{patientId}', patientId),
      );

      final prescriptions = (response.data['data'] as List<dynamic>)
          .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      logger.info('Successfully fetched patient prescriptions', data: {
        'count': prescriptions.length,
      });

      return Result.success(prescriptions);
    } catch (e) {
      logger.error('Failed to fetch patient prescriptions', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch patient prescriptions',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<PrescriptionModel>>> getActivePrescriptions() async {
    try {
      logger.info('Fetching active prescriptions');

      final response = await apiClient.get(ApiEndpoints.activePrescriptions);

      final prescriptions = (response.data['data'] as List<dynamic>)
          .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      logger.info('Successfully fetched active prescriptions', data: {
        'count': prescriptions.length,
      });

      return Result.success(prescriptions);
    } catch (e) {
      logger.error('Failed to fetch active prescriptions', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch active prescriptions',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<List<PrescriptionModel>>> getExpiringSoon({
    int days = 7,
  }) async {
    try {
      logger.info('Fetching expiring prescriptions', data: {'days': days});

      final response = await apiClient.get(
        ApiEndpoints.expiringSoonPrescriptions,
        queryParameters: {'days': days},
      );

      final prescriptions = (response.data['data'] as List<dynamic>)
          .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();

      logger.info('Successfully fetched expiring prescriptions', data: {
        'count': prescriptions.length,
      });

      return Result.success(prescriptions);
    } catch (e) {
      logger.error('Failed to fetch expiring prescriptions', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch expiring prescriptions',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAsCompleted(String prescriptionId) async {
    try {
      logger.info('Marking prescription as completed', data: {
        'prescriptionId': prescriptionId,
      });

      await apiClient.post(
        ApiEndpoints.markPrescriptionCompleted
            .replaceAll('{id}', prescriptionId),
      );

      logger.info('Successfully marked prescription as completed');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to mark prescription as completed', error: e);
      return Result.failure(
        NetworkException(
          'Failed to mark prescription as completed',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<void>> markAsCancelled(String prescriptionId) async {
    try {
      logger.info('Marking prescription as cancelled', data: {
        'prescriptionId': prescriptionId,
      });

      await apiClient.post(
        ApiEndpoints.markPrescriptionCancelled
            .replaceAll('{id}', prescriptionId),
      );

      logger.info('Successfully marked prescription as cancelled');
      return Result.success(null);
    } catch (e) {
      logger.error('Failed to mark prescription as cancelled', error: e);
      return Result.failure(
        NetworkException(
          'Failed to mark prescription as cancelled',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<String>> uploadPrescriptionImage(File imageFile) async {
    try {
      logger.info('Uploading prescription image', data: {
        'fileName': _getFileName(imageFile),
        'fileSize': await _getFileSize(imageFile),
      });

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: _getFileName(imageFile),
        ),
      });

      final response = await apiClient.post(
        ApiEndpoints.uploadPrescriptionImage,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final imageUrl = response.data['data']['imageUrl'] as String;

      logger.info('Successfully uploaded prescription image', data: {
        'imageUrl': imageUrl,
      });

      return Result.success(imageUrl);
    } catch (e) {
      logger.error('Failed to upload prescription image', error: e);
      return Result.failure(
        NetworkException(
          'Failed to upload prescription image',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getPrescriptionStats() async {
    try {
      logger.info('Fetching prescription statistics');

      final response = await apiClient.get(ApiEndpoints.prescriptionStats);

      final stats = response.data['data'] as Map<String, dynamic>;

      logger.info('Successfully fetched prescription statistics');
      return Result.success(stats);
    } catch (e) {
      logger.error('Failed to fetch prescription statistics', error: e);
      return Result.failure(
        NetworkException(
          'Failed to fetch prescription statistics',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Helper method to get filename from file path
  String _getFileName(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  /// Helper method to get file size
  Future<String> _getFileSize(File file) async {
    final bytes = await file.length();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
