import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/care_group_models.dart';

part 'care_group_service.g.dart';

@RestApi(baseUrl: AppConfig.apiBaseUrl)
abstract class CareGroupService {
  factory CareGroupService(Dio dio, {String baseUrl}) = _CareGroupService;

  // Care Group Management
  @GET('/care-groups')
  Future<List<CareGroup>> getUserCareGroups();

  @POST('/care-groups')
  Future<CareGroup> createCareGroup(@Body() Map<String, dynamic> request);

  @GET('/care-groups/{id}')
  Future<CareGroup> getCareGroup(@Path('id') String id);

  @PUT('/care-groups/{id}')
  Future<CareGroup> updateCareGroup(@Path('id') String id, @Body() Map<String, dynamic> updates);

  @DELETE('/care-groups/{id}')
  Future<void> deleteCareGroup(@Path('id') String id);

  // Member Management
  @POST('/care-groups/{id}/invite')
  Future<void> inviteMember(@Path('id') String groupId, @Body() Map<String, dynamic> request);

  @POST('/care-groups/{id}/join')
  Future<CareGroupMember> joinGroup(@Path('id') String groupId, @Body() Map<String, dynamic> request);

  @PUT('/care-groups/{groupId}/members/{memberId}')
  Future<CareGroupMember> updateMember(
    @Path('groupId') String groupId,
    @Path('memberId') String memberId,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE('/care-groups/{groupId}/members/{memberId}')
  Future<void> removeMember(@Path('groupId') String groupId, @Path('memberId') String memberId);

  // Task Management
  @GET('/care-groups/{id}/tasks')
  Future<List<CareTask>> getGroupTasks(@Path('id') String groupId, @Query('status') String? status);

  @POST('/care-groups/{id}/tasks')
  Future<CareTask> createTask(@Path('id') String groupId, @Body() Map<String, dynamic> request);

  @PUT('/care-groups/{groupId}/tasks/{taskId}')
  Future<CareTask> updateTask(
    @Path('groupId') String groupId,
    @Path('taskId') String taskId,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE('/care-groups/{groupId}/tasks/{taskId}')
  Future<void> deleteTask(@Path('groupId') String groupId, @Path('taskId') String taskId);

  // Activity Feed
  @GET('/care-groups/{id}/activities')
  Future<List<CareGroupActivity>> getGroupActivities(
    @Path('id') String groupId,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  // Care Recipients
  @GET('/care-groups/{id}/recipients')
  Future<List<CareRecipient>> getCareRecipients(@Path('id') String groupId);

  @POST('/care-groups/{id}/recipients')
  Future<CareRecipient> addCareRecipient(@Path('id') String groupId, @Body() Map<String, dynamic> request);

  @PUT('/care-groups/{groupId}/recipients/{recipientId}')
  Future<CareRecipient> updateCareRecipient(
    @Path('groupId') String groupId,
    @Path('recipientId') String recipientId,
    @Body() Map<String, dynamic> updates,
  );
}

/// Repository class for Care Group operations with healthcare-compliant logging
class CareGroupRepository {
  final CareGroupService _service;

  // Healthcare-compliant logger for Care Group context
  static final _logger = BoundedContextLoggers.careGroup;

  CareGroupRepository(Dio dio) : _service = CareGroupService(dio);

  /// Get all care groups for the current user
  Future<List<CareGroup>> getUserCareGroups() async {
    try {
      _logger.logCareGroupEvent('Fetching user care groups', {
        'timestamp': DateTime.now().toIso8601String(),
      });

      final groups = await _service.getUserCareGroups();

      _logger.logCareGroupEvent('Care groups fetched successfully', {
        'groupCount': groups.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return groups;
    } on DioException catch (e) {
      _logger.error('Failed to fetch care groups', {
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Create a new care group
  Future<CareGroup> createCareGroup(CreateCareGroupRequest request) async {
    _logger.logCareGroupEvent('Care group creation initiated', {
      'groupName': request.name,
      'hasDescription': request.description?.isNotEmpty == true,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final group = await _service.createCareGroup(request.toJson());

      _logger.logCareGroupEvent('Care group created successfully', {
        'groupId': group.id,
        'groupName': group.name,
        'memberCount': group.memberCount,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return group;
    } on DioException catch (e) {
      _logger.error('Care group creation failed', {
        'groupName': request.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get a specific care group by ID
  Future<CareGroup> getCareGroup(String id) async {
    try {
      _logger.logCareGroupEvent('Fetching care group details', {
        'groupId': id,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final group = await _service.getCareGroup(id);

      _logger.logCareGroupEvent('Care group details fetched successfully', {
        'groupId': group.id,
        'memberCount': group.members.length,
        'activeTaskCount': group.activeTaskCount,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return group;
    } on DioException catch (e) {
      _logger.error('Failed to fetch care group details', {
        'groupId': id,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Invite a member to the care group
  Future<void> inviteMember(String groupId, InviteMemberRequest request) async {
    _logger.logCareGroupEvent('Member invitation initiated', {
      'groupId': groupId,
      'role': request.role.name,
      'hasCustomTitle': request.customTitle?.isNotEmpty == true,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      await _service.inviteMember(groupId, request.toJson());

      _logger.logCareGroupEvent('Member invitation sent successfully', {
        'groupId': groupId,
        'role': request.role.name,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } on DioException catch (e) {
      _logger.error('Member invitation failed', {
        'groupId': groupId,
        'role': request.role.name,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Create a new task in the care group
  Future<CareTask> createTask(String groupId, CreateTaskRequest request) async {
    _logger.logCareGroupEvent('Task creation initiated', {
      'groupId': groupId,
      'taskTitle': request.title,
      'priority': request.priority.name,
      'isRecurring': request.isRecurring,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final task = await _service.createTask(groupId, request.toJson());

      _logger.logCareGroupEvent('Task created successfully', {
        'groupId': groupId,
        'taskId': task.id,
        'taskTitle': task.title,
        'priority': task.priority.name,
        'assignedTo': task.assignedTo,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return task;
    } on DioException catch (e) {
      _logger.error('Task creation failed', {
        'groupId': groupId,
        'taskTitle': request.title,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get tasks for a care group
  Future<List<CareTask>> getGroupTasks(String groupId, {String? status}) async {
    try {
      _logger.logCareGroupEvent('Fetching group tasks', {
        'groupId': groupId,
        'statusFilter': status,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final tasks = await _service.getGroupTasks(groupId, status);

      _logger.logCareGroupEvent('Group tasks fetched successfully', {
        'groupId': groupId,
        'taskCount': tasks.length,
        'statusFilter': status,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return tasks;
    } on DioException catch (e) {
      _logger.error('Failed to fetch group tasks', {
        'groupId': groupId,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Update task status
  Future<CareTask> updateTask(String groupId, String taskId, UpdateTaskRequest request) async {
    try {
      _logger.logCareGroupEvent('Task update initiated', {
        'groupId': groupId,
        'taskId': taskId,
        'hasStatusUpdate': request.status != null,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final task = await _service.updateTask(groupId, taskId, request.toJson());

      _logger.logCareGroupEvent('Task updated successfully', {
        'groupId': groupId,
        'taskId': taskId,
        'newStatus': task.status.name,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return task;
    } on DioException catch (e) {
      _logger.error('Task update failed', {
        'groupId': groupId,
        'taskId': taskId,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Get care group activities
  Future<List<CareGroupActivity>> getGroupActivities(String groupId, {int? limit, int? offset}) async {
    try {
      final activities = await _service.getGroupActivities(groupId, limit, offset);

      _logger.logCareGroupEvent('Group activities fetched successfully', {
        'groupId': groupId,
        'activityCount': activities.length,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return activities;
    } on DioException catch (e) {
      _logger.error('Failed to fetch group activities', {
        'groupId': groupId,
        'errorType': e.type.name,
        'statusCode': e.response?.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
      });
      throw _handleError(e);
    }
  }

  /// Handle Dio errors with user-friendly messages
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return Exception('Invalid request. Please check your input.');
          case 401:
            return Exception('Authentication failed. Please log in again.');
          case 403:
            return Exception('You do not have permission to perform this action.');
          case 404:
            return Exception('Care group not found.');
          case 409:
            return Exception('Conflict occurred. The resource may already exist.');
          case 500:
            return Exception('Server error. Please try again later.');
          default:
            return Exception('An error occurred. Please try again.');
        }
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      default:
        return Exception('Network error. Please check your connection.');
    }
  }
}
