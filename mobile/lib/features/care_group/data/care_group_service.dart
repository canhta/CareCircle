import '../../../common/common.dart';
import '../domain/care_group_models.dart';

/// Enhanced care group service using common modules
class CareGroupService extends BaseRepository {
  CareGroupService({
    required super.apiClient,
    required super.logger,
  });

  /// Create a new care group
  Future<Result<CareGroup>> createCareGroup(
      CreateCareGroupRequest request) async {
    return await post<CareGroup>(
      ApiEndpoints.createCareGroup,
      data: request.toJson(),
      fromJson: (json) => CareGroup.fromJson(json),
    );
  }

  /// Get all care groups for the current user
  Future<Result<List<CareGroup>>> getCareGroups() async {
    return await get<List<CareGroup>>(
      ApiEndpoints.careGroups,
      fromJson: (json) {
        final List<dynamic> data = json as List<dynamic>;
        return data.map((group) => CareGroup.fromJson(group)).toList();
      },
    );
  }

  /// Get paginated care groups
  Future<Result<PaginatedResult<CareGroup>>> getCareGroupsPaginated({
    int page = 1,
    int limit = 20,
  }) async {
    return await getPaginated<CareGroup>(
      ApiEndpoints.careGroups,
      page: page,
      limit: limit,
      fromJson: (json) => CareGroup.fromJson(json),
    );
  }

  /// Get a specific care group by ID
  Future<Result<CareGroup>> getCareGroup(String id) async {
    return await get<CareGroup>(
      '${ApiEndpoints.careGroups}/$id',
      fromJson: (json) => CareGroup.fromJson(json),
    );
  }

  /// Update a care group
  Future<Result<CareGroup>> updateCareGroup(
    String id,
    UpdateCareGroupRequest request,
  ) async {
    return await patch<CareGroup>(
      '${ApiEndpoints.careGroups}/$id',
      data: request.toJson(),
      fromJson: (json) => CareGroup.fromJson(json),
    );
  }

  /// Delete a care group
  Future<Result<void>> deleteCareGroup(String id) async {
    return await delete('${ApiEndpoints.careGroups}/$id');
  }

  /// Get care group members
  Future<Result<List<CareGroupMember>>> getCareGroupMembers(
      String groupId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupMembers,
      {'id': groupId},
    );

    return await get<List<CareGroupMember>>(
      endpoint,
      fromJson: (json) {
        final List<dynamic> data = json as List<dynamic>;
        return data.map((member) => CareGroupMember.fromJson(member)).toList();
      },
    );
  }

  /// Join a care group
  Future<Result<void>> joinCareGroup(String groupId, String inviteCode) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.joinCareGroup,
      {'id': groupId},
    );

    return await post(
      endpoint,
      data: {'inviteCode': inviteCode},
    );
  }

  /// Leave a care group
  Future<Result<void>> leaveCareGroup(String groupId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.leaveCareGroup,
      {'id': groupId},
    );

    return await post(endpoint);
  }

  /// Send care group invitation
  Future<Result<CareGroupInvitation>> sendInvitation(
    String groupId,
    SendInvitationRequest request,
  ) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupInvitations,
      {'id': groupId},
    );

    return await post<CareGroupInvitation>(
      endpoint,
      data: request.toJson(),
      fromJson: (json) => CareGroupInvitation.fromJson(json),
    );
  }

  /// Get care group invitations
  Future<Result<List<CareGroupInvitation>>> getInvitations(
      String groupId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupInvitations,
      {'id': groupId},
    );

    return await get<List<CareGroupInvitation>>(
      endpoint,
      fromJson: (json) {
        final List<dynamic> data = json as List<dynamic>;
        return data
            .map((invitation) => CareGroupInvitation.fromJson(invitation))
            .toList();
      },
    );
  }

  /// Update care group settings
  Future<Result<CareGroupSettings>> updateSettings(
    String groupId,
    CareGroupSettingsRequest request,
  ) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupSettings,
      {'id': groupId},
    );

    return await patch<CareGroupSettings>(
      endpoint,
      data: request.toJson(),
      fromJson: (json) => CareGroupSettings.fromJson(json),
    );
  }

  /// Remove member from care group
  Future<Result<void>> removeMember(String groupId, String memberId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupMembers,
      {'id': groupId},
    );

    return await delete('$endpoint/$memberId');
  }

  /// Update member role
  Future<Result<CareGroupMember>> updateMemberRole(
    String groupId,
    String memberId,
    CareGroupRole role,
  ) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupMembers,
      {'id': groupId},
    );

    return await patch<CareGroupMember>(
      '$endpoint/$memberId',
      data: {'role': role.toString().split('.').last},
      fromJson: (json) => CareGroupMember.fromJson(json),
    );
  }

  /// Search care groups
  Future<Result<List<CareGroup>>> searchCareGroups(String query) async {
    return await get<List<CareGroup>>(
      ApiEndpoints.careGroups,
      queryParameters: {'search': query},
      fromJson: (json) {
        final List<dynamic> data = json as List<dynamic>;
        return data.map((group) => CareGroup.fromJson(group)).toList();
      },
    );
  }

  /// Generate a share link for a care group
  Future<Result<ShareLinkData>> generateShareLink(String careGroupId) async {
    final endpoint = ApiEndpoints.replacePathParams(
      ApiEndpoints.careGroupShareLink,
      {'id': careGroupId},
    );

    return await get<ShareLinkData>(
      endpoint,
      fromJson: (json) => ShareLinkData.fromJson(json),
    );
  }
}
