import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/models/models.dart';

part 'drug_interaction_api_service.g.dart';

/// API service for drug interaction checking and RxNorm integration
///
/// Provides endpoints for:
/// - User medication interaction analysis
/// - Specific medication interaction checking
/// - RxNorm validation and enrichment
/// - Medication standardization
@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class DrugInteractionApiService {
  factory DrugInteractionApiService(Dio dio, {String baseUrl}) =
      _DrugInteractionApiService;

  /// Check interactions for all user medications
  @GET('/drug-interactions/user-medications')
  Future<InteractionAnalysis> checkUserMedicationInteractions();

  /// Check interactions between specific medications
  @POST('/drug-interactions/check')
  Future<InteractionAnalysis> checkMedicationInteractions(
    @Body() List<String> medicationIds,
  );

  /// Check interactions for specific RxNorm codes
  @POST('/drug-interactions/check-rxnorm')
  Future<InteractionAnalysis> checkRxNormInteractions(
    @Body() List<String> rxNormCodes,
  );

  /// Validate medication against RxNorm database
  @POST('/drug-interactions/validate-rxnorm')
  Future<MedicationEnrichmentResponse> validateRxNorm(
    @Body() Map<String, String> request,
  );

  /// Enrich medication data with RxNorm information
  @POST('/drug-interactions/enrich-medication')
  Future<MedicationEnrichmentResponse> enrichMedicationData(
    @Body() Map<String, dynamic> medicationData,
  );

  /// Search RxNorm database for medication
  @GET('/drug-interactions/search-rxnorm')
  Future<RxNormSearchResponse> searchRxNorm(
    @Query('term') String searchTerm,
    @Query('limit') int? limit,
  );

  /// Get medication details from RxNorm
  @GET('/drug-interactions/rxnorm/{rxcui}')
  Future<MedicationEnrichmentResponse> getRxNormDetails(
    @Path('rxcui') String rxcui,
  );

  /// Get interaction severity levels
  @GET('/drug-interactions/severity-levels')
  Future<RxNormSearchResponse> getInteractionSeverityLevels();
}
