// Care Group Models for Flutter App
// Matches backend NestJS API structure

import 'auth_models.dart';

enum CareRole {
  OWNER,
  ADMIN,
  CAREGIVER,
  MEMBER,
}

class CareGroup {
  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CareGroupMember> members;

  CareGroup({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
  });

  factory CareGroup.fromJson(Map<String, dynamic> json) {
    return CareGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      inviteCode: json['inviteCode'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      members: (json['members'] as List<dynamic>?)
              ?.map((member) => CareGroupMember.fromJson(member))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'inviteCode': inviteCode,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class CareGroupMember {
  final String id;
  final String careGroupId;
  final String userId;
  final User? user;
  final CareRole role;
  final DateTime joinedAt;
  final bool isActive;
  final bool canViewHealth;
  final bool canReceiveAlerts;
  final bool canManageSettings;

  CareGroupMember({
    required this.id,
    required this.careGroupId,
    required this.userId,
    this.user,
    required this.role,
    required this.joinedAt,
    required this.isActive,
    required this.canViewHealth,
    required this.canReceiveAlerts,
    required this.canManageSettings,
  });

  factory CareGroupMember.fromJson(Map<String, dynamic> json) {
    return CareGroupMember(
      id: json['id'] as String,
      careGroupId: json['careGroupId'] as String,
      userId: json['userId'] as String,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      role: CareRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => CareRole.MEMBER,
      ),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      isActive: json['isActive'] as bool,
      canViewHealth: json['canViewHealth'] as bool,
      canReceiveAlerts: json['canReceiveAlerts'] as bool,
      canManageSettings: json['canManageSettings'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'careGroupId': careGroupId,
      'userId': userId,
      'user': user?.toJson(),
      'role': role.name,
      'joinedAt': joinedAt.toIso8601String(),
      'isActive': isActive,
      'canViewHealth': canViewHealth,
      'canReceiveAlerts': canReceiveAlerts,
      'canManageSettings': canManageSettings,
    };
  }
}

class CreateCareGroupRequest {
  final String name;
  final String? description;

  CreateCareGroupRequest({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
    };
  }
}

class InviteCareGroupMemberRequest {
  final String email;
  final CareRole role;
  final bool canViewHealth;
  final bool canReceiveAlerts;
  final bool canManageSettings;
  final String? message;

  InviteCareGroupMemberRequest({
    required this.email,
    this.role = CareRole.MEMBER,
    this.canViewHealth = false,
    this.canReceiveAlerts = true,
    this.canManageSettings = false,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role.name,
      'canViewHealth': canViewHealth,
      'canReceiveAlerts': canReceiveAlerts,
      'canManageSettings': canManageSettings,
      if (message != null) 'message': message,
    };
  }
}

class UpdateCareGroupRequest {
  final String? name;
  final String? description;

  UpdateCareGroupRequest({
    this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
  }
}

class UpdateMemberRoleRequest {
  final CareRole role;
  final bool canViewHealth;
  final bool canReceiveAlerts;
  final bool canManageSettings;

  UpdateMemberRoleRequest({
    required this.role,
    required this.canViewHealth,
    required this.canReceiveAlerts,
    required this.canManageSettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'canViewHealth': canViewHealth,
      'canReceiveAlerts': canReceiveAlerts,
      'canManageSettings': canManageSettings,
    };
  }
}

class CareGroupDashboardData {
  final String careGroupId;
  final String careGroupName;
  final int totalMembers;
  final int activeMembers;
  final List<RecentActivity> recentActivities;
  final List<CareGroupMember> members;

  CareGroupDashboardData({
    required this.careGroupId,
    required this.careGroupName,
    required this.totalMembers,
    required this.activeMembers,
    required this.recentActivities,
    required this.members,
  });

  factory CareGroupDashboardData.fromJson(Map<String, dynamic> json) {
    return CareGroupDashboardData(
      careGroupId: json['careGroupId'] as String,
      careGroupName: json['careGroupName'] as String,
      totalMembers: json['totalMembers'] as int,
      activeMembers: json['activeMembers'] as int,
      recentActivities: (json['recentActivities'] as List<dynamic>?)
              ?.map((activity) => RecentActivity.fromJson(activity))
              .toList() ??
          [],
      members: (json['members'] as List<dynamic>?)
              ?.map((member) => CareGroupMember.fromJson(member))
              .toList() ??
          [],
    );
  }
}

class RecentActivity {
  final String id;
  final String type;
  final String userId;
  final String userName;
  final String description;
  final DateTime timestamp;

  RecentActivity({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    required this.description,
    required this.timestamp,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] as String,
      type: json['type'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class AcceptInvitationRequest {
  final String token;

  AcceptInvitationRequest({required this.token});

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}

class RejectInvitationRequest {
  final String token;

  RejectInvitationRequest({required this.token});

  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}

class DeepLinkInfo {
  final String url;
  final String token;
  final DateTime expiresAt;

  DeepLinkInfo({
    required this.url,
    required this.token,
    required this.expiresAt,
  });

  factory DeepLinkInfo.fromJson(Map<String, dynamic> json) {
    return DeepLinkInfo(
      url: json['url'] as String,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}

extension CareRoleExtension on CareRole {
  String get displayName {
    switch (this) {
      case CareRole.OWNER:
        return 'Owner';
      case CareRole.ADMIN:
        return 'Admin';
      case CareRole.CAREGIVER:
        return 'Caregiver';
      case CareRole.MEMBER:
        return 'Member';
    }
  }

  String get description {
    switch (this) {
      case CareRole.OWNER:
        return 'Full access to all features and settings';
      case CareRole.ADMIN:
        return 'Can manage members and group settings';
      case CareRole.CAREGIVER:
        return 'Can view health data and receive alerts';
      case CareRole.MEMBER:
        return 'Basic access to group features';
    }
  }
}
