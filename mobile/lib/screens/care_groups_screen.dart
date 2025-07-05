// Care Groups List Screen
// Shows all care groups that the user is a member of

import 'package:flutter/material.dart';
import 'dart:developer';
import '../features/care_group/care_group.dart';
import '../common/common.dart';
import 'care_group_detail_screen.dart';
import 'create_care_group_screen.dart';

class CareGroupsScreen extends StatefulWidget {
  const CareGroupsScreen({super.key});

  @override
  State<CareGroupsScreen> createState() => _CareGroupsScreenState();
}

class _CareGroupsScreenState extends State<CareGroupsScreen> {
  late final CareGroupService _careGroupService;
  List<CareGroup> _careGroups = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: AppLogger('CareGroupsScreen'),
    );
    _loadCareGroups();
  }

  Future<void> _loadCareGroups() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _careGroupService.getCareGroups();

    result.fold(
      (careGroups) => {
        setState(() {
          _careGroups = careGroups;
          _isLoading = false;
        })
      },
      (error) => {
        log('Error loading care groups: $error'),
        setState(() {
          _error = 'Failed to load care groups. Please try again.';
          _isLoading = false;
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Groups'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCareGroups,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateCareGroup(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCareGroups,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_careGroups.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadCareGroups,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _careGroups.length,
        itemBuilder: (context, index) {
          final careGroup = _careGroups[index];
          return _buildCareGroupCard(careGroup);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'No Care Groups',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first care group to start\nconnecting with family and friends.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToCreateCareGroup(),
            icon: const Icon(Icons.add),
            label: const Text('Create Care Group'),
          ),
        ],
      ),
    );
  }

  Widget _buildCareGroupCard(CareGroup careGroup) {
    final myMember = _getCurrentUserMember(careGroup);
    final roleColor = _getRoleColor(myMember?.role);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToCareGroupDetail(careGroup),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: roleColor,
                    child: Text(
                      careGroup.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
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
                          careGroup.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (careGroup.description.isNotEmpty)
                          Text(
                            careGroup.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (myMember != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getRoleDisplayName(myMember.role),
                        style: TextStyle(
                          color: roleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${careGroup.memberCount} members',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    'Created ${_formatDate(careGroup.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CareGroupMember? _getCurrentUserMember(CareGroup careGroup) {
    // Note: Since the CareGroup model doesn't contain members list,
    // we'll just return null for now. In a real implementation,
    // this would need to fetch the current user's membership from the service
    return null;
  }

  Color _getRoleColor(CareGroupRole? role) {
    switch (role) {
      case CareGroupRole.admin:
        return Colors.red;
      case CareGroupRole.member:
        return Colors.blue;
      case CareGroupRole.viewer:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

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

  Future<void> _navigateToCreateCareGroup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCareGroupScreen(),
      ),
    );

    if (result == true) {
      _loadCareGroups();
    }
  }

  void _navigateToCareGroupDetail(CareGroup careGroup) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareGroupDetailScreen(careGroup: careGroup),
      ),
    );
  }
}
