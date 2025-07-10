import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config.dart';
import '../../../auth/infrastructure/services/firebase_auth_service.dart';
import '../../domain/models/care_group_models.dart';
import '../../infrastructure/services/care_group_service.dart';

// Repository provider
final careGroupRepositoryProvider = Provider<CareGroupRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Add auth interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final firebaseAuthService = FirebaseAuthService();
        final idToken = await firebaseAuthService.getIdToken();
        if (idToken != null) {
          options.headers['Authorization'] = 'Bearer $idToken';
        }
        handler.next(options);
      },
    ),
  );

  return CareGroupRepository(dio);
});

// Care groups list provider
final careGroupsProvider = FutureProvider<List<CareGroup>>((ref) async {
  final repository = ref.read(careGroupRepositoryProvider);
  return repository.getUserCareGroups();
});

// Single care group provider
final careGroupProvider = FutureProvider.family<CareGroup, String>((
  ref,
  id,
) async {
  final repository = ref.read(careGroupRepositoryProvider);
  return repository.getCareGroup(id);
});

// Group tasks provider
final groupTasksProvider = FutureProvider.family<List<CareTask>, String>((
  ref,
  groupId,
) async {
  final repository = ref.read(careGroupRepositoryProvider);
  return repository.getGroupTasks(groupId);
});

// Group activities provider
final groupActivitiesProvider =
    FutureProvider.family<List<CareGroupActivity>, String>((
      ref,
      groupId,
    ) async {
      final repository = ref.read(careGroupRepositoryProvider);
      return repository.getGroupActivities(groupId, limit: 50);
    });

// Current selected care group provider
final selectedCareGroupProvider = StateProvider<CareGroup?>((ref) => null);

// Task filter provider
final taskFilterProvider = StateProvider<TaskStatus?>((ref) => null);

// Care Group notifier for managing state
class CareGroupNotifier extends StateNotifier<AsyncValue<List<CareGroup>>> {
  final CareGroupRepository _repository;
  final Ref _ref;

  CareGroupNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadCareGroups();
  }

  Future<void> loadCareGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await _repository.getUserCareGroups();
      state = AsyncValue.data(groups);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<CareGroup> createCareGroup({
    required String name,
    String? description,
    CareGroupSettings? settings,
  }) async {
    try {
      final request = CreateCareGroupRequest(
        name: name,
        description: description,
        settings: settings ?? const CareGroupSettings(),
      );

      final group = await _repository.createCareGroup(request);

      // Refresh the groups list
      await loadCareGroups();

      // Set as selected group
      _ref.read(selectedCareGroupProvider.notifier).state = group;

      return group;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> inviteMember({
    required String groupId,
    required String email,
    required MemberRole role,
    String? customTitle,
    String? personalMessage,
  }) async {
    try {
      final request = InviteMemberRequest(
        email: email,
        role: role,
        customTitle: customTitle,
        personalMessage: personalMessage,
      );

      await _repository.inviteMember(groupId, request);

      // Refresh the specific group data
      _ref.invalidate(careGroupProvider(groupId));
    } catch (error) {
      rethrow;
    }
  }

  Future<CareTask> createTask({
    required String groupId,
    required String title,
    String? description,
    required TaskPriority priority,
    required String assignedTo,
    String? careRecipientId,
    required DateTime dueDate,
    bool isRecurring = false,
    String? recurrencePattern,
  }) async {
    try {
      final request = CreateTaskRequest(
        title: title,
        description: description,
        priority: priority,
        assignedTo: assignedTo,
        careRecipientId: careRecipientId,
        dueDate: dueDate,
        isRecurring: isRecurring,
        recurrencePattern: recurrencePattern,
      );

      final task = await _repository.createTask(groupId, request);

      // Refresh tasks and group data
      _ref.invalidate(groupTasksProvider(groupId));
      _ref.invalidate(careGroupProvider(groupId));
      _ref.invalidate(groupActivitiesProvider(groupId));

      return task;
    } catch (error) {
      rethrow;
    }
  }

  Future<CareTask> updateTask({
    required String groupId,
    required String taskId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? assignedTo,
    DateTime? dueDate,
    String? completionNotes,
  }) async {
    try {
      final request = UpdateTaskRequest(
        title: title,
        description: description,
        priority: priority,
        status: status,
        assignedTo: assignedTo,
        dueDate: dueDate,
        completionNotes: completionNotes,
      );

      final task = await _repository.updateTask(groupId, taskId, request);

      // Refresh tasks and group data
      _ref.invalidate(groupTasksProvider(groupId));
      _ref.invalidate(careGroupProvider(groupId));
      _ref.invalidate(groupActivitiesProvider(groupId));

      return task;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> completeTask({
    required String groupId,
    required String taskId,
    String? completionNotes,
  }) async {
    await updateTask(
      groupId: groupId,
      taskId: taskId,
      status: TaskStatus.completed,
      completionNotes: completionNotes,
    );
  }

  Future<List<CareGroupActivity>> getGroupActivities(String groupId) async {
    try {
      return await _repository.getGroupActivities(groupId, limit: 50);
    } catch (error) {
      rethrow;
    }
  }

  void setSelectedGroup(CareGroup? group) {
    _ref.read(selectedCareGroupProvider.notifier).state = group;
  }

  void setTaskFilter(TaskStatus? status) {
    _ref.read(taskFilterProvider.notifier).state = status;
  }
}

// Care Group notifier provider
final careGroupNotifierProvider =
    StateNotifierProvider<CareGroupNotifier, AsyncValue<List<CareGroup>>>((
      ref,
    ) {
      final repository = ref.read(careGroupRepositoryProvider);
      return CareGroupNotifier(repository, ref);
    });

// Filtered tasks provider based on current filter
final filteredTasksProvider =
    Provider.family<AsyncValue<List<CareTask>>, String>((ref, groupId) {
      final tasksAsync = ref.watch(groupTasksProvider(groupId));
      final filter = ref.watch(taskFilterProvider);

      return tasksAsync.when(
        data: (tasks) {
          if (filter == null) {
            return AsyncValue.data(tasks);
          }
          final filteredTasks = tasks
              .where((task) => task.status == filter)
              .toList();
          return AsyncValue.data(filteredTasks);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      );
    });

// Task statistics provider
final taskStatsProvider = Provider.family<Map<TaskStatus, int>, String>((
  ref,
  groupId,
) {
  final tasksAsync = ref.watch(groupTasksProvider(groupId));

  return tasksAsync.when(
    data: (tasks) {
      final stats = <TaskStatus, int>{};
      for (final status in TaskStatus.values) {
        stats[status] = tasks.where((task) => task.status == status).length;
      }
      return stats;
    },
    loading: () => <TaskStatus, int>{},
    error: (_, _) => <TaskStatus, int>{},
  );
});

// Member role provider for current user in a group
final currentUserRoleProvider = Provider.family<MemberRole?, String>((
  ref,
  groupId,
) {
  final groupAsync = ref.watch(careGroupProvider(groupId));
  // This would need to be implemented with actual user ID from auth context
  // For now, returning null as placeholder
  return groupAsync.when(
    data: (group) {
      // TODO: Get current user ID from auth context and find their role
      return null;
    },
    loading: () => null,
    error: (_, _) => null,
  );
});

// Can perform action provider (based on user role and permissions)
final canPerformActionProvider =
    Provider.family<bool, ({String groupId, String action})>((ref, params) {
      final userRole = ref.watch(currentUserRoleProvider(params.groupId));

      if (userRole == null) return false;

      // Define permissions based on roles
      switch (params.action) {
        case 'create_task':
          return userRole == MemberRole.admin ||
              userRole == MemberRole.caregiver;
        case 'invite_member':
          return userRole == MemberRole.admin;
        case 'manage_settings':
          return userRole == MemberRole.admin;
        case 'complete_task':
          return userRole == MemberRole.admin ||
              userRole == MemberRole.caregiver;
        default:
          return false;
      }
    });
