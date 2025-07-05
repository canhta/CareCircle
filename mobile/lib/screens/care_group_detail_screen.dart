// Care Group Detail Screen
// Shows details of a care group including dashboard, members, and management options

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import '../features/care_group/care_group.dart';
import '../common/common.dart';
import 'care_group_dashboard_screen.dart';
import 'care_group_members_screen.dart';
import 'invite_member_screen.dart';

class CareGroupDetailScreen extends StatefulWidget {
  final CareGroup careGroup;

  const CareGroupDetailScreen({
    super.key,
    required this.careGroup,
  });

  @override
  State<CareGroupDetailScreen> createState() => _CareGroupDetailScreenState();
}

class _CareGroupDetailScreenState extends State<CareGroupDetailScreen> {
  late final CareGroupService _careGroupService;
  late CareGroup _careGroup;
  CareGroupMember? _currentUserMember;
  List<CareGroupMember> _members = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: AppLogger('CareGroupDetailScreen'),
    );
    _careGroup = widget.careGroup;
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _careGroupService.getCareGroupMembers(_careGroup.id);

    if (result.isSuccess) {
      setState(() {
        _members = result.data ?? [];
        _getCurrentUserMember();
      });
    } else {
      // Log error - we can create a local logger or handle silently
      debugPrint('Failed to load members: ${result.exception}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _getCurrentUserMember() {
    // Note: This should be replaced with actual user ID from auth service
    // For now, we'll assume the first member is the current user
    if (_members.isNotEmpty) {
      _currentUserMember = _members.first;
    }
  }

  bool _canManageGroup() {
    return _currentUserMember?.role == CareRole.owner ||
        _currentUserMember?.role == CareRole.admin;
  }

  bool _canInviteMembers() {
    return _currentUserMember?.role == CareRole.owner ||
        _currentUserMember?.role == CareRole.admin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_careGroup.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_canManageGroup())
            PopupMenuButton<String>(
              onSelected: _handleMenuSelection,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Group'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share Group'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                if (_currentUserMember?.role == CareRole.owner)
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete Group',
                          style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Card
          _buildHeaderCard(),

          // Quick Actions
          _buildQuickActions(),

          // Dashboard Summary
          _buildDashboardSummary(),

          // Members Preview
          _buildMembersPreview(),

          // Actions
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    _careGroup.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _careGroup.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        _careGroup.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (_currentUserMember != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(_currentUserMember!.role)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _currentUserMember!.role.displayName,
                      style: TextStyle(
                        color: _getRoleColor(_currentUserMember!.role),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.people_outline,
                  label: '${_careGroup.members.length} members',
                ),
                const SizedBox(width: 16),
                _buildInfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: 'Created ${_formatDate(_careGroup.createdAt)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              subtitle: 'View insights',
              onTap: () => _navigateToDashboard(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickActionCard(
              icon: Icons.people_outline,
              title: 'Members',
              subtitle: '${_careGroup.members.length} members',
              onTap: () => _navigateToMembers(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Placeholder for recent activities
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.health_and_safety),
              ),
              title: Text('Daily check-in completed'),
              subtitle: Text('2 hours ago'),
              contentPadding: EdgeInsets.zero,
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.medication),
              ),
              title: Text('Medication reminder'),
              subtitle: Text('4 hours ago'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _navigateToDashboard(),
              child: const Text('View Full Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersPreview() {
    final visibleMembers = _careGroup.members.take(3).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_canInviteMembers())
                  TextButton.icon(
                    onPressed: () => _navigateToInviteMember(),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Invite'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...visibleMembers.map((member) => _buildMemberListItem(member)),
            if (_careGroup.members.length > 3)
              TextButton(
                onPressed: () => _navigateToMembers(),
                child: Text('View All ${_careGroup.members.length} Members'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberListItem(CareGroupMember member) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          member.user?.name?.substring(0, 1).toUpperCase() ?? 'U',
        ),
      ),
      title: Text(member.user?.name ?? 'Unknown User'),
      subtitle: Text(member.role.displayName),
      trailing: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: member.isActive ? Colors.green : Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_canInviteMembers())
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToInviteMember(),
                icon: const Icon(Icons.person_add),
                label: const Text('Invite Member'),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _shareGroup(),
              icon: const Icon(Icons.share),
              label: const Text('Share Group'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _leaveGroup(),
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Leave Group'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(CareRole role) {
    switch (role) {
      case CareRole.owner:
        return Colors.purple;
      case CareRole.admin:
        return Colors.blue;
      case CareRole.caregiver:
        return Colors.green;
      case CareRole.member:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        _editGroup();
        break;
      case 'share':
        _shareGroup();
        break;
      case 'delete':
        _deleteGroup();
        break;
    }
  }

  void _editGroup() {
    // TODO: Implement edit group functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit group functionality coming soon!')),
    );
  }

  void _shareGroup() async {
    try {
      final deepLink = await _careGroupService.generateDeepLink(_careGroup.id);
      final shareText =
          'Join my care group "${_careGroup.name}" on CareCircle: ${deepLink.url}';

      await Clipboard.setData(ClipboardData(text: shareText));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Care group link copied to clipboard!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      log('Error sharing group: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate share link')),
        );
      }
    }
  }

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Care Group'),
        content: Text(
          'Are you sure you want to delete "${_careGroup.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDeleteGroup();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteGroup() async {
    setState(() => _isLoading = true);
    try {
      await _careGroupService.deleteCareGroup(_careGroup.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Care group deleted successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      log('Error deleting group: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete care group')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _leaveGroup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Care Group'),
        content: Text(
          'Are you sure you want to leave "${_careGroup.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performLeaveGroup();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Future<void> _performLeaveGroup() async {
    setState(() => _isLoading = true);
    try {
      await _careGroupService.leaveCareGroup(_careGroup.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Left care group successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      log('Error leaving group: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to leave care group')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareGroupDashboardScreen(careGroup: _careGroup),
      ),
    );
  }

  void _navigateToMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareGroupMembersScreen(careGroup: _careGroup),
      ),
    );
  }

  void _navigateToInviteMember() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteMemberScreen(careGroup: _careGroup),
      ),
    );
  }
}
