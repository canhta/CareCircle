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
  @GET('/drug-interactions/check-user-medications')
  Future<InteractionAnalysis> checkUserMedicationInteractions();

  /// Check interactions between specific medications
  @POST('/drug-interactions/check-specific')
  Future<InteractionAnalysis> checkSpecificMedications(
    @Body() Map<String, List<String>> request,
  );

  /// Check new medication against existing user medications
  @POST('/drug-interactions/check-new-medication')
  Future<InteractionAnalysis> checkNewMedicationAgainstExisting(
    @Body() Map<String, String> request,
  );

  /// Search RxNorm database
  @POST('/drug-interactions/rxnorm/search')
  Future<RxNormSearchResponse> searchRxNorm(
    @Body() RxNormSearchRequest request,
  );

  /// Validate RxNorm code
  @POST('/drug-interactions/rxnorm/validate')
  Future<MedicationEnrichmentResponse> validateRxNormCode(
    @Body() Map<String, String> request,
  );

  /// Enrich medication data
  @POST('/drug-interactions/enrich')
  Future<MedicationEnrichmentResponse> enrichMedicationData(
    @Body() MedicationEnrichmentRequest request,
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
