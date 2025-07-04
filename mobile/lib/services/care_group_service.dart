// Care Group Service for Flutter App
// Handles all Care Group API interactions

import 'dart:developer';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/care_group_models.dart';
import '../services/auth_service.dart';

class CareGroupService {
  final AuthService _authService = AuthService();
  late final Dio _dio;

  CareGroupService() {
    _dio = Dio();
    _dio.options.baseUrl = AppConfig.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<Options> _getOptions() async {
    final token = await _authService.getAccessToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Create a new care group
  Future<CareGroup> createCareGroup(CreateCareGroupRequest request) async {
    try {
      final response = await _dio.post(
        '/care-groups',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode == 201) {
        return CareGroup.fromJson(response.data);
      } else {
        throw Exception('Failed to create care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error creating care group: $e');
      throw Exception('Failed to create care group: $e');
    }
  }

  // Get all care groups for the current user
  Future<List<CareGroup>> getCareGroups() async {
    try {
      final response = await _dio.get(
        '/care-groups',
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((group) => CareGroup.fromJson(group)).toList();
      } else {
        throw Exception('Failed to get care groups: ${response.statusCode}');
      }
    } catch (e) {
      log('Error getting care groups: $e');
      throw Exception('Failed to get care groups: $e');
    }
  }

  // Get a specific care group by ID
  Future<CareGroup> getCareGroup(String id) async {
    try {
      final response = await _dio.get(
        '/care-groups/$id',
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        return CareGroup.fromJson(response.data);
      } else {
        throw Exception('Failed to get care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error getting care group: $e');
      throw Exception('Failed to get care group: $e');
    }
  }

  // Update a care group
  Future<CareGroup> updateCareGroup(String id, UpdateCareGroupRequest request) async {
    try {
      final response = await _dio.patch(
        '/care-groups/$id',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        return CareGroup.fromJson(response.data);
      } else {
        throw Exception('Failed to update care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating care group: $e');
      throw Exception('Failed to update care group: $e');
    }
  }

  // Delete a care group
  Future<void> deleteCareGroup(String id) async {
    try {
      final response = await _dio.delete(
        '/care-groups/$id',
        options: await _getOptions(),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error deleting care group: $e');
      throw Exception('Failed to delete care group: $e');
    }
  }

  // Invite a member to a care group
  Future<void> inviteMember(String careGroupId, InviteCareGroupMemberRequest request) async {
    try {
      final response = await _dio.post(
        '/care-groups/$careGroupId/invite',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to invite member: ${response.statusCode}');
      }
    } catch (e) {
      log('Error inviting member: $e');
      throw Exception('Failed to invite member: $e');
    }
  }

  // Accept an invitation
  Future<void> acceptInvitation(AcceptInvitationRequest request) async {
    try {
      final response = await _dio.post(
        '/care-groups/accept-invitation',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to accept invitation: ${response.statusCode}');
      }
    } catch (e) {
      log('Error accepting invitation: $e');
      throw Exception('Failed to accept invitation: $e');
    }
  }

  // Reject an invitation
  Future<void> rejectInvitation(RejectInvitationRequest request) async {
    try {
      final response = await _dio.post(
        '/care-groups/reject-invitation',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reject invitation: ${response.statusCode}');
      }
    } catch (e) {
      log('Error rejecting invitation: $e');
      throw Exception('Failed to reject invitation: $e');
    }
  }

  // Get care group members
  Future<List<CareGroupMember>> getCareGroupMembers(String careGroupId) async {
    try {
      final response = await _dio.get(
        '/care-groups/$careGroupId/members',
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((member) => CareGroupMember.fromJson(member)).toList();
      } else {
        throw Exception('Failed to get care group members: ${response.statusCode}');
      }
    } catch (e) {
      log('Error getting care group members: $e');
      throw Exception('Failed to get care group members: $e');
    }
  }

  // Update member role and permissions
  Future<void> updateMemberRole(String careGroupId, String memberId, UpdateMemberRoleRequest request) async {
    try {
      final response = await _dio.patch(
        '/care-groups/$careGroupId/members/$memberId',
        data: request.toJson(),
        options: await _getOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update member role: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating member role: $e');
      throw Exception('Failed to update member role: $e');
    }
  }

  // Remove member from care group
  Future<void> removeMember(String careGroupId, String memberId) async {
    try {
      final response = await _dio.delete(
        '/care-groups/$careGroupId/members/$memberId',
        options: await _getOptions(),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to remove member: ${response.statusCode}');
      }
    } catch (e) {
      log('Error removing member: $e');
      throw Exception('Failed to remove member: $e');
    }
  }

  // Generate deep link for invitation
  Future<DeepLinkInfo> generateDeepLink(String careGroupId) async {
    try {
      final response = await _dio.post(
        '/care-groups/$careGroupId/deep-link',
        options: await _getOptions(),
      );

      if (response.statusCode == 201) {
        return DeepLinkInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to generate deep link: ${response.statusCode}');
      }
    } catch (e) {
      log('Error generating deep link: $e');
      throw Exception('Failed to generate deep link: $e');
    }
  }

  // Get care group dashboard data
  Future<CareGroupDashboardData> getDashboardData(String careGroupId) async {
    try {
      final response = await _dio.get(
        '/care-groups/$careGroupId/dashboard',
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        return CareGroupDashboardData.fromJson(response.data);
      } else {
        throw Exception('Failed to get dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error getting dashboard data: $e');
      throw Exception('Failed to get dashboard data: $e');
    }
  }

  // Join by invite code
  Future<void> joinByInviteCode(String inviteCode) async {
    try {
      final response = await _dio.post(
        '/care-groups/join',
        data: {'inviteCode': inviteCode},
        options: await _getOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to join care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error joining care group: $e');
      throw Exception('Failed to join care group: $e');
    }
  }

  // Leave care group
  Future<void> leaveCareGroup(String careGroupId) async {
    try {
      final response = await _dio.post(
        '/care-groups/$careGroupId/leave',
        options: await _getOptions(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to leave care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error leaving care group: $e');
      throw Exception('Failed to leave care group: $e');
    }
  }
}
