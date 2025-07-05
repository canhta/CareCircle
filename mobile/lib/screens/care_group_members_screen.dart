// Care Group Members Screen
// Shows all members of a care group with management options

import 'package:flutter/material.dart';
import 'dart:developer';
import '../features/care_group/domain/care_group_models.dart';
import '../features/care_group/data/care_group_service.dart';
import '../common/common.dart';
import 'invite_member_screen.dart';

class CareGroupMembersScreen extends StatefulWidget {
  final CareGroup careGroup;

  const CareGroupMembersScreen({
    super.key,
    required this.careGroup,
  });

  @override
  State<CareGroupMembersScreen> createState() => _CareGroupMembersScreenState();
}

class _CareGroupMembersScreenState extends State<CareGroupMembersScreen> {
  late final CareGroupService _careGroupService;
  List<CareGroupMember> _members = [];
  CareGroupMember? _currentUserMember;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: AppLogger('CareGroupMembersScreen'),
    );
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result =
        await _careGroupService.getCareGroupMembers(widget.careGroup.id);

    result.fold(
      (members) => setState(() {
        _members = members;
        _currentUserMember = _getCurrentUserMember();
        _isLoading = false;
      }),
      (error) => setState(() {
        _error = error.toString();
        _isLoading = false;
      }),
    );
  }

  CareGroupMember? _getCurrentUserMember() {
    // Note: This should be replaced with actual user ID from auth service
    // For now, we'll assume the first member is the current user
    return _members.isNotEmpty ? _members.first : null;
  }

  bool _canManageMembers() {
    return _currentUserMember?.role == CareGroupRole.admin;
  }

  bool _canInviteMembers() {
    return _currentUserMember?.role == CareGroupRole.admin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.careGroup.name} Members'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMembers,
          ),
          if (_canInviteMembers())
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _navigateToInviteMember(),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _canInviteMembers()
          ? FloatingActionButton(
              onPressed: () => _navigateToInviteMember(),
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMembers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_members.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadMembers,
      child: Column(
        children: [
          _buildMembersHeader(),
          Expanded(child: _buildMembersList()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 120,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'No Members',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Invite family and friends to join this care group.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_canInviteMembers())
            ElevatedButton.icon(
              onPressed: () => _navigateToInviteMember(),
              icon: const Icon(Icons.person_add),
              label: const Text('Invite Member'),
            ),
        ],
      ),
    );
  }

  Widget _buildMembersHeader() {
    final activeMembers = _members.length; // All members are active in the new model

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_members.length} Members',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  '$activeMembers active',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (_canInviteMembers())
            OutlinedButton.icon(
              onPressed: () => _navigateToInviteMember(),
              icon: const Icon(Icons.person_add),
              label: const Text('Invite'),
            ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    // Group members by role
    final groupedMembers = <CareGroupRole, List<CareGroupMember>>{};
    for (final member in _members) {
      groupedMembers.putIfAbsent(member.role, () => []).add(member);
    }

    // Sort roles by hierarchy
    final sortedRoles = [
      CareGroupRole.admin,
      CareGroupRole.member,
      CareGroupRole.viewer
    ].where((role) => groupedMembers.containsKey(role)).toList();

    return ListView.builder(
      itemCount: sortedRoles.length,
      itemBuilder: (context, index) {
        final role = sortedRoles[index];
        final members = groupedMembers[role]!;

        return _buildRoleSection(role, members);
      },
    );
  }

  Widget _buildRoleSection(CareGroupRole role, List<CareGroupMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: _getRoleColor(role),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_getRoleDisplayName(role)}s (${members.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _getRoleColor(role),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        ...members.map((member) => _buildMemberItem(member)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMemberItem(CareGroupMember member) {
    final isCurrentUser = member.id == _currentUserMember?.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor:
                  _getRoleColor(member.role).withValues(alpha: 0.1),
              child: Text(
                _getMemberInitials(member),
                style: TextStyle(
                  color: _getRoleColor(member.role),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green, // All members are active in the new model
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.fullName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isCurrentUser)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'You',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            const SizedBox(height: 4),
            Text(
              'Joined ${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: _canManageMembers() && !isCurrentUser
            ? PopupMenuButton<String>(
                onSelected: (value) => _handleMemberAction(value, member),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Role'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.remove_circle, color: Colors.red),
                      title:
                          Text('Remove', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              )
            : null,
        isThreeLine: true,
        onTap: () => _showMemberDetails(member),
      ),
    );
  }

  Color _getRoleColor(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        return Colors.blue;
      case CareGroupRole.member:
        return Colors.orange;
      case CareGroupRole.viewer:
        return Colors.green;
    }
  }

  void _handleMemberAction(String action, CareGroupMember member) {
    switch (action) {
      case 'edit':
        _editMemberRole(member);
        break;
      case 'remove':
        _removeMember(member);
        break;
    }
  }

  void _editMemberRole(CareGroupMember member) {
    // TODO: Implement edit member role functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Edit member role functionality coming soon!')),
    );
  }

  void _removeMember(CareGroupMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove ${member.fullName} from the group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performRemoveMember(member);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRemoveMember(CareGroupMember member) async {
    try {
      await _careGroupService.removeMember(widget.careGroup.id, member.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed successfully')),
        );
        _loadMembers();
      }
    } catch (e) {
      log('Error removing member: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove member')),
        );
      }
    }
  }

  void _showMemberDetails(CareGroupMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', member.email),
            _buildDetailRow('Role', _getRoleDisplayName(member.role)),
            _buildDetailRow('Joined', _formatDate(member.joinedAt)),
            _buildDetailRow('Status', 'Active'),
            const SizedBox(height: 16),
            _buildDetailRow('Joined', '${member.joinedAt.day}/${member.joinedAt.month}/${member.joinedAt.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }

  Future<void> _navigateToInviteMember() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteMemberScreen(careGroup: widget.careGroup),
      ),
    );

    if (result == true) {
      _loadMembers();
    }
  }

  // Helper functions for working with CareGroupMember model
  String _getRoleDisplayName(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        return 'Admin';
      case CareGroupRole.member:
        return 'Member';
      case CareGroupRole.viewer:
        return 'Viewer';
    }
  }

  String _getMemberInitials(CareGroupMember member) {
    final first = member.firstName.isNotEmpty ? member.firstName[0] : '';
    final last = member.lastName.isNotEmpty ? member.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }
}
