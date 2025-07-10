import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/models.dart';

part 'prescription_processing_api_service.g.dart';

/// API service for prescription processing and OCR operations
/// 
/// Provides endpoints for:
/// - Image upload and OCR processing
/// - URL-based prescription processing
/// - Prescription reprocessing and enhancement
/// - RxNorm integration and validation
@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class PrescriptionProcessingApiService {
  factory PrescriptionProcessingApiService(Dio dio, {String baseUrl}) = _PrescriptionProcessingApiService;

  /// Process prescription image using OCR
  @POST('/prescription-processing/process-image')
  @MultiPart()
  Future<OCRProcessingResult> processImageOCR(@Part() File image);

  /// Process prescription from URL
  @POST('/prescription-processing/process-url')
  Future<OCRProcessingResult> processUrlOCR(@Body() Map<String, String> request);

  /// Reprocess existing prescription with updated OCR
  @POST('/prescription-processing/{id}/reprocess')
  Future<OCRProcessingResult> reprocessPrescription(@Path('id') String id);

  /// Enhance prescription with RxNorm data
  @POST('/prescription-processing/{id}/enhance')
  Future<PrescriptionResponse> enhancePrescription(@Path('id') String id);

  /// Validate prescription data
  @POST('/prescription-processing/validate')
  Future<PrescriptionResponse> validatePrescriptionData(@Body() Map<String, dynamic> data);

  /// Get OCR processing status
  @GET('/prescription-processing/{id}/status')
  Future<PrescriptionResponse> getProcessingStatus(@Path('id') String id);
}
