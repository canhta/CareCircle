// Care Group Service for Flutter App
// Handles all Care Group API interactions

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/care_group_models.dart';
import '../services/auth_service.dart';

class CareGroupService {
  final String _baseUrl = '${AppConfig.apiBaseUrl}/care-groups';
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Create a new care group
  Future<CareGroup> createCareGroup(CreateCareGroupRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroup.fromJson(data);
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
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((group) => CareGroup.fromJson(group)).toList();
      } else {
        throw Exception('Failed to fetch care groups: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching care groups: $e');
      throw Exception('Failed to fetch care groups: $e');
    }
  }

  // Get a specific care group by ID
  Future<CareGroup> getCareGroup(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroup.fromJson(data);
      } else {
        throw Exception('Failed to fetch care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching care group: $e');
      throw Exception('Failed to fetch care group: $e');
    }
  }

  // Update a care group
  Future<CareGroup> updateCareGroup(String id, UpdateCareGroupRequest request) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroup.fromJson(data);
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
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error deleting care group: $e');
      throw Exception('Failed to delete care group: $e');
    }
  }

  // Invite a member to a care group
  Future<DeepLinkInfo> inviteMember(String careGroupId, InviteCareGroupMemberRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$careGroupId/invite'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return DeepLinkInfo.fromJson(data);
      } else {
        throw Exception('Failed to invite member: ${response.statusCode}');
      }
    } catch (e) {
      log('Error inviting member: $e');
      throw Exception('Failed to invite member: $e');
    }
  }

  // Accept an invitation
  Future<CareGroup> acceptInvitation(AcceptInvitationRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/accept-invitation'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroup.fromJson(data);
      } else {
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
      final response = await http.post(
        Uri.parse('$_baseUrl/reject-invitation'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
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
  Future<List<CareGroupMember>> getMembers(String careGroupId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$careGroupId/members'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((member) => CareGroupMember.fromJson(member)).toList();
      } else {
        throw Exception('Failed to fetch members: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching members: $e');
      throw Exception('Failed to fetch members: $e');
    }
  }

  // Update member role
  Future<CareGroupMember> updateMemberRole(String careGroupId, String memberId, UpdateMemberRoleRequest request) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$careGroupId/members/$memberId'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroupMember.fromJson(data);
      } else {
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
      final response = await http.delete(
        Uri.parse('$_baseUrl/$careGroupId/members/$memberId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove member: ${response.statusCode}');
      }
    } catch (e) {
      log('Error removing member: $e');
      throw Exception('Failed to remove member: $e');
    }
  }

  // Leave care group
  Future<void> leaveCareGroup(String careGroupId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$careGroupId/leave'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to leave care group: ${response.statusCode}');
      }
    } catch (e) {
      log('Error leaving care group: $e');
      throw Exception('Failed to leave care group: $e');
    }
  }

  // Get care group dashboard data
  Future<CareGroupDashboardData> getDashboardData(String careGroupId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$careGroupId/dashboard'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CareGroupDashboardData.fromJson(data);
      } else {
        throw Exception('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching dashboard data: $e');
      throw Exception('Failed to fetch dashboard data: $e');
    }
  }

  // Generate deep link for care group
  Future<DeepLinkInfo> generateDeepLink(String careGroupId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$careGroupId/deep-link'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return DeepLinkInfo.fromJson(data);
      } else {
        throw Exception('Failed to generate deep link: ${response.statusCode}');
      }
    } catch (e) {
      log('Error generating deep link: $e');
      throw Exception('Failed to generate deep link: $e');
    }
  }

  // Validate deep link
  Future<Map<String, dynamic>> validateDeepLink(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/deep-link/validate?token=$token'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to validate deep link: ${response.statusCode}');
      }
    } catch (e) {
      log('Error validating deep link: $e');
      throw Exception('Failed to validate deep link: $e');
    }
  }
}
