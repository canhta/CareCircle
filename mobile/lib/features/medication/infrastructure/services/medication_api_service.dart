import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/models/models.dart';

part 'medication_api_service.g.dart';

@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class MedicationApiService {
  factory MedicationApiService(Dio dio, {String baseUrl}) = _MedicationApiService;

  // Medication CRUD Operations
  @GET('/medications')
  Future<MedicationListResponse> getUserMedications(
    @Query('isActive') bool? isActive,
    @Query('form') String? form,
    @Query('classification') String? classification,
    @Query('startDateFrom') String? startDateFrom,
    @Query('startDateTo') String? startDateTo,
    @Query('endDateFrom') String? endDateFrom,
    @Query('endDateTo') String? endDateTo,
    @Query('prescriptionId') String? prescriptionId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('sortBy') String? sortBy,
    @Query('sortOrder') String? sortOrder,
  );

  @POST('/medications')
  Future<MedicationResponse> createMedication(@Body() CreateMedicationRequest request);

  @GET('/medications/{id}')
  Future<MedicationResponse> getMedication(@Path('id') String id);

  @PUT('/medications/{id}')
  Future<MedicationResponse> updateMedication(@Path('id') String id, @Body() UpdateMedicationRequest request);

  @DELETE('/medications/{id}')
  Future<MedicationResponse> deleteMedication(@Path('id') String id);

  // Medication Search and Statistics
  @GET('/medications/search')
  Future<MedicationListResponse> searchMedications(@Query('term') String searchTerm, @Query('limit') int? limit);

  @GET('/medications/statistics')
  Future<MedicationStatistics> getMedicationStatistics();

  @GET('/medications/active')
  Future<MedicationListResponse> getActiveMedications();

  @GET('/medications/inactive')
  Future<MedicationListResponse> getInactiveMedications();

  @GET('/medications/expiring')
  Future<MedicationListResponse> getExpiringMedications(@Query('days') int? days);

  // Medication Validation and Enrichment
  @POST('/medications/{id}/validate')
  Future<MedicationResponse> validateMedication(@Path('id') String id);

  @POST('/medications/{id}/enrich')
  Future<MedicationResponse> enrichMedication(@Path('id') String id);

  // Prescription Operations
  @GET('/prescriptions')
  Future<PrescriptionListResponse> getUserPrescriptions(
    @Query('isVerified') bool? isVerified,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @POST('/prescriptions')
  Future<PrescriptionResponse> createPrescription(@Body() CreatePrescriptionRequest request);

  @GET('/prescriptions/{id}')
  Future<PrescriptionResponse> getPrescription(@Path('id') String id);

  @PUT('/prescriptions/{id}')
  Future<PrescriptionResponse> updatePrescription(@Path('id') String id, @Body() UpdatePrescriptionRequest request);

  @DELETE('/prescriptions/{id}')
  Future<PrescriptionResponse> deletePrescription(@Path('id') String id);

  @POST('/prescriptions/{id}/verify')
  Future<PrescriptionResponse> verifyPrescription(@Path('id') String id);

  // OCR Processing Operations
  @POST('/prescription-processing/process-image')
  @MultiPart()
  Future<OCRProcessingResult> processImageOCR(@Part() File image);

  @POST('/prescription-processing/process-url')
  Future<OCRProcessingResult> processUrlOCR(@Body() Map<String, String> request);

  @POST('/prescription-processing/{id}/reprocess')
  Future<OCRProcessingResult> reprocessPrescription(@Path('id') String id);

  @POST('/prescription-processing/{id}/enhance')
  Future<PrescriptionResponse> enhancePrescription(@Path('id') String id);

  // Schedule Operations
  @GET('/medication-schedules')
  Future<ScheduleListResponse> getUserSchedules(
    @Query('medicationId') String? medicationId,
    @Query('isActive') bool? isActive,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @POST('/medication-schedules')
  Future<ScheduleResponse> createSchedule(@Body() CreateScheduleRequest request);

  @GET('/medication-schedules/{id}')
  Future<ScheduleResponse> getSchedule(@Path('id') String id);

  @PUT('/medication-schedules/{id}')
  Future<ScheduleResponse> updateSchedule(@Path('id') String id, @Body() UpdateScheduleRequest request);

  @DELETE('/medication-schedules/{id}')
  Future<ScheduleResponse> deleteSchedule(@Path('id') String id);

  @GET('/medication-schedules/upcoming')
  Future<ScheduleListResponse> getUpcomingSchedules(@Query('hours') int? hours);

  @GET('/medication-schedules/conflicts')
  Future<ScheduleListResponse> getScheduleConflicts();

  // Adherence Operations
  @GET('/adherence')
  Future<AdherenceRecordListResponse> getAdherenceRecords(
    @Query('medicationId') String? medicationId,
    @Query('scheduleId') String? scheduleId,
    @Query('status') String? status,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @POST('/adherence')
  Future<AdherenceRecordResponse> createAdherenceRecord(@Body() CreateAdherenceRecordRequest request);

  @GET('/adherence/{id}')
  Future<AdherenceRecordResponse> getAdherenceRecord(@Path('id') String id);

  @PUT('/adherence/{id}')
  Future<AdherenceRecordResponse> updateAdherenceRecord(
    @Path('id') String id,
    @Body() UpdateAdherenceRecordRequest request,
  );

  @DELETE('/adherence/{id}')
  Future<AdherenceRecordResponse> deleteAdherenceRecord(@Path('id') String id);

  @GET('/adherence/statistics')
  Future<AdherenceStatisticsResponse> getAdherenceStatistics(
    @Query('medicationId') String? medicationId,
    @Query('startDate') String? startDate,
    @Query('endDate') String? endDate,
  );

  @GET('/adherence/report')
  Future<AdherenceReportResponse> getAdherenceReport(
    @Query('startDate') String startDate,
    @Query('endDate') String endDate,
    @Query('medicationId') String? medicationId,
  );

  @POST('/adherence/mark-taken')
  Future<AdherenceRecordResponse> markDoseTaken(@Body() Map<String, dynamic> request);

  @POST('/adherence/mark-missed')
  Future<AdherenceRecordResponse> markDoseMissed(@Body() Map<String, dynamic> request);

  @POST('/adherence/mark-skipped')
  Future<AdherenceRecordResponse> markDoseSkipped(@Body() Map<String, dynamic> request);

  // Drug Interaction Operations
  @POST('/drug-interactions/check')
  Future<InteractionAnalysisResponse> checkDrugInteractions(@Body() InteractionCheckRequest request);

  @GET('/drug-interactions/user-medications')
  Future<InteractionAnalysisResponse> checkUserMedicationInteractions();

  @POST('/drug-interactions/rxnorm/search')
  Future<RxNormSearchResponse> searchRxNorm(@Body() RxNormSearchRequest request);

  @POST('/drug-interactions/rxnorm/validate')
  Future<MedicationEnrichmentResponse> validateRxNormCode(@Body() Map<String, String> request);

  @POST('/drug-interactions/enrich')
  Future<MedicationEnrichmentResponse> enrichMedicationData(@Body() MedicationEnrichmentRequest request);
}

/// Healthcare-compliant medication repository with comprehensive logging
///
/// This repository handles all medication operations with strict privacy
/// protection and HIPAA-compliant logging practices.
class MedicationRepository {
  final MedicationApiService _service;

  // Healthcare-compliant logger for medication context
  static final _logger = BoundedContextLoggers.medication;

  MedicationRepository(Dio dio) : _service = MedicationApiService(dio);

  // Medication Operations
  Future<List<Medication>> getUserMedications({MedicationQueryParams? params}) async {
    try {
      _logger.logMedicationEvent('Fetching user medications', {
        'hasFilters': params != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.getUserMedications(
        params?.isActive,
        params?.form?.name,
        params?.classification,
        params?.startDateFrom?.toIso8601String(),
        params?.startDateTo?.toIso8601String(),
        params?.endDateFrom?.toIso8601String(),
        params?.endDateTo?.toIso8601String(),
        params?.prescriptionId,
        params?.limit,
        params?.offset,
        params?.sortBy,
        params?.sortOrder,
      );

      if (response.success) {
        _logger.logMedicationEvent('User medications fetched successfully', {
          'medicationCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to fetch medications');
      }
    } on DioException catch (e) {
      _logger.error('Failed to fetch user medications', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Future<Medication> createMedication(CreateMedicationRequest request) async {
    try {
      _logger.logMedicationEvent('Creating new medication', {
        'medicationName': request.name,
        'form': request.form.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.createMedication(request);

      if (response.success && response.data != null) {
        _logger.logMedicationEvent('Medication created successfully', {
          'medicationId': response.data!.id,
          'medicationName': response.data!.name,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data!;
      } else {
        throw Exception(response.error ?? 'Failed to create medication');
      }
    } on DioException catch (e) {
      _logger.error('Failed to create medication', {
        'medicationName': request.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Future<Medication> getMedication(String id) async {
    try {
      _logger.logMedicationEvent('Fetching medication details', {
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.getMedication(id);

      if (response.success && response.data != null) {
        _logger.logMedicationEvent('Medication details fetched successfully', {
          'medicationId': response.data!.id,
          'medicationName': response.data!.name,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data!;
      } else {
        throw Exception(response.error ?? 'Failed to fetch medication');
      }
    } on DioException catch (e) {
      _logger.error('Failed to fetch medication details', {
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Future<Medication> updateMedication(String id, UpdateMedicationRequest request) async {
    try {
      _logger.logMedicationEvent('Updating medication', {
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.updateMedication(id, request);

      if (response.success && response.data != null) {
        _logger.logMedicationEvent('Medication updated successfully', {
          'medicationId': response.data!.id,
          'medicationName': response.data!.name,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data!;
      } else {
        throw Exception(response.error ?? 'Failed to update medication');
      }
    } on DioException catch (e) {
      _logger.error('Failed to update medication', {
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      _logger.logMedicationEvent('Deleting medication', {
        'medicationId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.deleteMedication(id);

      if (response.success) {
        _logger.logMedicationEvent('Medication deleted successfully', {
          'medicationId': id,
          'timestamp': DateTime.now().toIso8601String(),
        });
      } else {
        throw Exception(response.error ?? 'Failed to delete medication');
      }
    } on DioException catch (e) {
      _logger.error('Failed to delete medication', {
        'medicationId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Future<List<Medication>> searchMedications(String searchTerm, {int? limit}) async {
    try {
      _logger.logMedicationEvent('Searching medications', {
        'searchTerm': searchTerm,
        'limit': limit,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.searchMedications(searchTerm, limit);

      if (response.success) {
        _logger.logMedicationEvent('Medication search completed', {
          'searchTerm': searchTerm,
          'resultCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to search medications');
      }
    } on DioException catch (e) {
      _logger.error('Failed to search medications', {
        'searchTerm': searchTerm,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  // Prescription Operations
  Future<List<Prescription>> getUserPrescriptions() async {
    try {
      _logger.logMedicationEvent('Fetching user prescriptions', {'timestamp': DateTime.now().toIso8601String()});

      final response = await _service.getUserPrescriptions(null, null, null, null, null);

      if (response.success) {
        _logger.logMedicationEvent('User prescriptions fetched successfully', {
          'prescriptionCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to fetch prescriptions');
      }
    } on DioException catch (e) {
      _logger.error('Failed to fetch user prescriptions', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  // Adherence Operations
  Future<List<AdherenceRecord>> getAdherenceRecords({AdherenceQueryParams? params}) async {
    try {
      _logger.logMedicationEvent('Fetching adherence records', {
        'hasFilters': params != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _service.getAdherenceRecords(
        params?.medicationId,
        params?.scheduleId,
        params?.status?.name,
        params?.startDate?.toIso8601String(),
        params?.endDate?.toIso8601String(),
        params?.limit,
        params?.offset,
      );

      if (response.success) {
        _logger.logMedicationEvent('Adherence records fetched successfully', {
          'recordCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to fetch adherence records');
      }
    } on DioException catch (e) {
      _logger.error('Failed to fetch adherence records', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Authentication failed. Please log in again.');
        } else if (statusCode == 403) {
          return Exception('Access denied. You do not have permission to perform this action.');
        } else if (statusCode == 404) {
          return Exception('Resource not found.');
        } else if (statusCode == 422) {
          return Exception('Invalid data provided. Please check your input.');
        } else if (statusCode != null && statusCode >= 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception(e.response?.data?['message'] ?? 'Request failed');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error. Please check your internet connection.');
      default:
        return Exception('An unexpected error occurred');
    }
  }
}

/// Provider for medication API service
final medicationApiServiceProvider = Provider<MedicationApiService>((ref) {
  final dio = ref.read(medicationDioProvider);
  return MedicationApiService(dio);
});
