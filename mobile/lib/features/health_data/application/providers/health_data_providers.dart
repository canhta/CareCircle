import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/health_profile.dart';
import '../../infrastructure/services/health_data_api_service.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../../../core/network/dio_provider.dart';

// Healthcare-compliant logger for health data context
final _logger = BoundedContextLoggers.healthData;

/// Provider for health data API service
final healthDataApiServiceProvider = Provider<HealthDataApiService>((ref) {
  final dio = ref.read(dioProvider);
  return HealthDataApiService(dio);
});

/// Provider for user's health profile
final healthProfileProvider = FutureProvider<HealthProfile?>((ref) async {
  try {
    final apiService = ref.read(healthDataApiServiceProvider);
    // TODO: Get actual user ID from auth service
    const userId = 'current-user'; // Placeholder
    
    _logger.info('Fetching health profile for user', {
      'operation': 'getHealthProfile',
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    final healthProfile = await apiService.getHealthProfile(userId);
    
    _logger.info('Health profile fetched successfully', {
      'hasGoals': healthProfile.healthGoals.isNotEmpty,
      'goalsCount': healthProfile.healthGoals.length,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    return healthProfile;
  } catch (e) {
    _logger.error('Failed to fetch health profile', {
      'error': e.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    // Return null to allow fallback to placeholder data
    return null;
  }
});

/// Provider for active health goals
final activeHealthGoalsProvider = Provider<List<HealthGoal>>((ref) {
  final healthProfileAsync = ref.watch(healthProfileProvider);
  
  return healthProfileAsync.when(
    data: (healthProfile) {
      return healthProfile?.healthGoals
          .where((goal) => goal.status == 'active')
          .toList() ?? [];
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// Provider for completed health goals (achievements)
final completedHealthGoalsProvider = Provider<List<HealthGoal>>((ref) {
  final healthProfileAsync = ref.watch(healthProfileProvider);
  
  return healthProfileAsync.when(
    data: (healthProfile) {
      return healthProfile?.healthGoals
          .where((goal) => goal.status == 'achieved')
          .toList() ?? [];
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// Provider for health goal statistics
final healthGoalStatsProvider = Provider<Map<String, int>>((ref) {
  final healthProfileAsync = ref.watch(healthProfileProvider);
  
  return healthProfileAsync.when(
    data: (healthProfile) {
      final goals = healthProfile?.healthGoals ?? [];
      
      return {
        'total': goals.length,
        'active': goals.where((g) => g.status == 'active').length,
        'achieved': goals.where((g) => g.status == 'achieved').length,
        'behind': goals.where((g) => g.status == 'behind').length,
      };
    },
    loading: () => {'total': 0, 'active': 0, 'achieved': 0, 'behind': 0},
    error: (error, stackTrace) => {'total': 0, 'active': 0, 'achieved': 0, 'behind': 0},
  );
});
