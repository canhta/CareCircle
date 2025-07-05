/// Care group role enumeration
enum CareGroupRole {
  admin,
  member,
  viewer,
}

/// Care group model
class CareGroup {
  final String id;
  final String name;
  final String description;
  final String? avatar;
  final CareGroupRole userRole;
  final int memberCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CareGroup({
    required this.id,
    required this.name,
    required this.description,
    this.avatar,
    required this.userRole,
    required this.memberCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory CareGroup.fromJson(Map<String, dynamic> json) {
    return CareGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      avatar: json['avatar'],
      userRole: CareGroupRole.values.firstWhere(
        (role) => role.toString().split('.').last == json['userRole'],
        orElse: () => CareGroupRole.member,
      ),
      memberCount: json['memberCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'userRole': userRole.toString().split('.').last,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Care group member model
class CareGroupMember {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;
  final CareGroupRole role;
  final DateTime joinedAt;

  const CareGroupMember({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
    required this.role,
    required this.joinedAt,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Create from JSON
  factory CareGroupMember.fromJson(Map<String, dynamic> json) {
    return CareGroupMember(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      role: CareGroupRole.values.firstWhere(
        (role) => role.toString().split('.').last == json['role'],
        orElse: () => CareGroupRole.member,
      ),
      joinedAt: DateTime.tryParse(json['joinedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'role': role.toString().split('.').last,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}

/// Care group invitation model
class CareGroupInvitation {
  final String id;
  final String careGroupId;
  final String inviterName;
  final String email;
  final String inviteCode;
  final DateTime expiresAt;
  final bool isAccepted;
  final DateTime createdAt;

  const CareGroupInvitation({
    required this.id,
    required this.careGroupId,
    required this.inviterName,
    required this.email,
    required this.inviteCode,
    required this.expiresAt,
    required this.isAccepted,
    required this.createdAt,
  });

  /// Create from JSON
  factory CareGroupInvitation.fromJson(Map<String, dynamic> json) {
    return CareGroupInvitation(
      id: json['id'] ?? '',
      careGroupId: json['careGroupId'] ?? '',
      inviterName: json['inviterName'] ?? '',
      email: json['email'] ?? '',
      inviteCode: json['inviteCode'] ?? '',
      expiresAt: DateTime.tryParse(json['expiresAt'] ?? '') ?? DateTime.now(),
      isAccepted: json['isAccepted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'careGroupId': careGroupId,
      'inviterName': inviterName,
      'email': email,
      'inviteCode': inviteCode,
      'expiresAt': expiresAt.toIso8601String(),
      'isAccepted': isAccepted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Care group settings model
class CareGroupSettings {
  final bool allowMemberInvites;
  final bool requireApprovalForJoin;
  final bool enableNotifications;
  final bool enableDataSharing;

  const CareGroupSettings({
    required this.allowMemberInvites,
    required this.requireApprovalForJoin,
    required this.enableNotifications,
    required this.enableDataSharing,
  });

  /// Create from JSON
  factory CareGroupSettings.fromJson(Map<String, dynamic> json) {
    return CareGroupSettings(
      allowMemberInvites: json['allowMemberInvites'] ?? false,
      requireApprovalForJoin: json['requireApprovalForJoin'] ?? false,
      enableNotifications: json['enableNotifications'] ?? true,
      enableDataSharing: json['enableDataSharing'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'allowMemberInvites': allowMemberInvites,
      'requireApprovalForJoin': requireApprovalForJoin,
      'enableNotifications': enableNotifications,
      'enableDataSharing': enableDataSharing,
    };
  }
}

// Request models

/// Create care group request
class CreateCareGroupRequest {
  final String name;
  final String description;

  const CreateCareGroupRequest({
    required this.name,
    required this.description,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

/// Update care group request
class UpdateCareGroupRequest {
  final String? name;
  final String? description;

  const UpdateCareGroupRequest({
    this.name,
    this.description,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    return json;
  }
}

/// Send invitation request
class SendInvitationRequest {
  final String email;

  const SendInvitationRequest({required this.email});

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

/// Care group settings request
class CareGroupSettingsRequest {
  final bool? allowMemberInvites;
  final bool? requireApprovalForJoin;
  final bool? enableNotifications;
  final bool? enableDataSharing;

  const CareGroupSettingsRequest({
    this.allowMemberInvites,
    this.requireApprovalForJoin,
    this.enableNotifications,
    this.enableDataSharing,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (allowMemberInvites != null) {
      json['allowMemberInvites'] = allowMemberInvites;
    }
    if (requireApprovalForJoin != null) {
      json['requireApprovalForJoin'] = requireApprovalForJoin;
    }
    if (enableNotifications != null) {
      json['enableNotifications'] = enableNotifications;
    }
    if (enableDataSharing != null) {
      json['enableDataSharing'] = enableDataSharing;
    }
    return json;
  }
}

/// Share link data model
class ShareLinkData {
  final String deepLink;
  final String universalLink;
  final String? qrCodeData;

  const ShareLinkData({
    required this.deepLink,
    required this.universalLink,
    this.qrCodeData,
  });

  /// Create from JSON
  factory ShareLinkData.fromJson(Map<String, dynamic> json) {
    return ShareLinkData(
      deepLink: json['deepLink'] ?? '',
      universalLink: json['universalLink'] ?? '',
      qrCodeData: json['qrCode'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'deepLink': deepLink,
      'universalLink': universalLink,
      'qrCode': qrCodeData,
    };
  }
}
