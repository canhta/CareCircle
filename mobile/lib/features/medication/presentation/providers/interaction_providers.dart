import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/services/drug_interaction_api_service.dart';

// Healthcare-compliant logger for drug interaction context
final _logger = BoundedContextLoggers.medication;

/// Provider for drug interaction API service
final drugInteractionApiServiceProvider = Provider<DrugInteractionApiService>((
  ref,
) {
  final dio = ref.read(medicationDioProvider);
  return DrugInteractionApiService(dio);
});

/// Provider for user medication interactions analysis
final userMedicationInteractionsProvider = FutureProvider<InteractionAnalysis>((
  ref,
) async {
  final apiService = ref.read(drugInteractionApiServiceProvider);

  _logger.info('Checking user medication interactions', {
    'operation': 'checkUserMedicationInteractions',
    'timestamp': DateTime.now().toIso8601String(),
  });

  try {
    final analysis = await apiService.checkUserMedicationInteractions();

    _logger.logHealthDataAccess('Medication interactions analyzed', {
      'dataType': 'medicationInteractions',
      'interactionCount': analysis.interactions.length,
      'hasHighSeverity': analysis.interactions.any(
        (i) => i.severity == InteractionSeverity.major,
      ),
      'timestamp': DateTime.now().toIso8601String(),
    });

    return analysis;
  } catch (e) {
    _logger.error('Failed to check user medication interactions', {
      'operation': 'checkUserMedicationInteractions',
      'error': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
    rethrow;
  }
});

/// Provider for specific medication interactions
final medicationInteractionsProvider =
    FutureProvider.family<InteractionAnalysis, List<String>>((
      ref,
      medicationIds,
    ) async {
      final apiService = ref.read(drugInteractionApiServiceProvider);

      _logger.info('Checking specific medication interactions', {
        'operation': 'checkMedicationInteractions',
        'medicationCount': medicationIds.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      try {
        final analysis = await apiService.checkSpecificMedications({
          'medications': medicationIds,
        });

        _logger
            .logHealthDataAccess('Specific medication interactions analyzed', {
              'dataType': 'medicationInteractions',
              'medicationCount': medicationIds.length,
              'interactionCount': analysis.interactions.length,
              'timestamp': DateTime.now().toIso8601String(),
            });

        return analysis;
      } catch (e) {
        _logger.error('Failed to check specific medication interactions', {
          'operation': 'checkMedicationInteractions',
          'medicationCount': medicationIds.length,
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        rethrow;
      }
    });

/// Provider for RxNorm medication search
final rxNormSearchProvider =
    FutureProvider.family<List<RxNormMedication>, String>((
      ref,
      searchTerm,
    ) async {
      final apiService = ref.read(drugInteractionApiServiceProvider);

      if (searchTerm.trim().isEmpty) {
        return [];
      }

      _logger.info('Searching RxNorm database', {
        'operation': 'searchRxNorm',
        'searchTerm': searchTerm,
        'timestamp': DateTime.now().toIso8601String(),
      });

      try {
        final response = await apiService.searchRxNorm(
          RxNormSearchRequest(searchTerm: searchTerm, maxResults: 20),
        );

        _logger.info('RxNorm search completed', {
          'operation': 'searchRxNorm',
          'searchTerm': searchTerm,
          'resultCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return response.data;
      } catch (e) {
        _logger.error('Failed to search RxNorm database', {
          'operation': 'searchRxNorm',
          'searchTerm': searchTerm,
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        rethrow;
      }
    });

/// Provider for interaction severity levels
final interactionSeverityLevelsProvider =
    FutureProvider<List<RxNormMedication>>((ref) async {
      final apiService = ref.read(drugInteractionApiServiceProvider);

      _logger.info('Fetching interaction severity levels', {
        'operation': 'getInteractionSeverityLevels',
        'timestamp': DateTime.now().toIso8601String(),
      });

      try {
        final response = await apiService.getInteractionSeverityLevels();

        _logger.info('Interaction severity levels fetched', {
          'operation': 'getInteractionSeverityLevels',
          'levelCount': response.data.length,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return response.data;
      } catch (e) {
        _logger.error('Failed to fetch interaction severity levels', {
          'operation': 'getInteractionSeverityLevels',
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });
        rethrow;
      }
    });

/// Provider for drug interaction management operations
final interactionManagementProvider =
    StateNotifierProvider<InteractionManagementNotifier, AsyncValue<void>>((
      ref,
    ) {
      final apiService = ref.read(drugInteractionApiServiceProvider);
      return InteractionManagementNotifier(apiService, ref);
    });

/// State notifier for drug interaction management operations
class InteractionManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final DrugInteractionApiService _apiService;
  // ignore: unused_field
  final Ref _ref; // TODO: Will be used for provider invalidation when API integration is complete

  InteractionManagementNotifier(this._apiService, this._ref)
    : super(const AsyncValue.data(null));

  /// Validate medication against RxNorm database
  Future<MedicationEnrichmentResponse?> validateRxNorm(
    String medicationName,
  ) async {
    try {
      _logger.info('Validating medication against RxNorm', {
        'operation': 'validateRxNorm',
        'medicationName': medicationName,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _apiService.validateRxNormCode({
        'name': medicationName,
      });

      _logger.info('RxNorm validation completed', {
        'operation': 'validateRxNorm',
        'medicationName': medicationName,
        'isValid': result.success,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result;
    } catch (e) {
      _logger.error('Failed to validate medication against RxNorm', {
        'operation': 'validateRxNorm',
        'medicationName': medicationName,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      return null;
    }
  }

  /// Enrich medication data with RxNorm information
  Future<MedicationEnrichmentResponse?> enrichMedicationData(
    Map<String, dynamic> medicationData,
  ) async {
    try {
      _logger.info('Enriching medication data with RxNorm', {
        'operation': 'enrichMedicationData',
        'medicationName': medicationData['name'],
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _apiService.enrichMedicationData(
        MedicationEnrichmentRequest(
          medicationId: medicationData['id'] ?? '',
          medicationName: medicationData['name'],
          rxNormCode: medicationData['rxNormCode'],
        ),
      );

      _logger.info('Medication data enrichment completed', {
        'operation': 'enrichMedicationData',
        'medicationName': medicationData['name'],
        'hasRxNormCode': result.enrichedData?.rxcui != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result;
    } catch (e) {
      _logger.error('Failed to enrich medication data', {
        'operation': 'enrichMedicationData',
        'medicationName': medicationData['name'],
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      return null;
    }
  }

  /// Get RxNorm details for a specific RXCUI
  Future<MedicationEnrichmentResponse?> getRxNormDetails(String rxcui) async {
    try {
      _logger.info('Fetching RxNorm details', {
        'operation': 'getRxNormDetails',
        'rxcui': rxcui,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final result = await _apiService.getRxNormDetails(rxcui);

      _logger.info('RxNorm details fetched', {
        'operation': 'getRxNormDetails',
        'rxcui': rxcui,
        'hasDetails': result.success,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return result;
    } catch (e) {
      _logger.error('Failed to fetch RxNorm details', {
        'operation': 'getRxNormDetails',
        'rxcui': rxcui,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      return null;
    }
  }

  /// Check interactions for RxNorm codes
  Future<InteractionAnalysis?> checkRxNormInteractions(
    List<String> rxNormCodes,
  ) async {
    state = const AsyncValue.loading();

    try {
      _logger.info('Checking RxNorm code interactions', {
        'operation': 'checkRxNormInteractions',
        'codeCount': rxNormCodes.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Note: checkRxNormInteractions method not available in current API
      // Using checkSpecificMedications as alternative
      final analysis = await _apiService.checkSpecificMedications({
        'medications': rxNormCodes,
      });

      state = const AsyncValue.data(null);

      _logger.info('RxNorm interaction check completed', {
        'operation': 'checkRxNormInteractions',
        'codeCount': rxNormCodes.length,
        'interactionCount': analysis.interactions.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return analysis;
    } catch (e, stackTrace) {
      _logger.error('Failed to check RxNorm interactions', {
        'operation': 'checkRxNormInteractions',
        'codeCount': rxNormCodes.length,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }
}
