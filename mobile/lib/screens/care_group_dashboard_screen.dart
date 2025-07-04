// Care Group Dashboard Screen
// Shows dashboard with insights and activities for a care group

import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/care_group_models.dart';
import '../services/care_group_service.dart';

class CareGroupDashboardScreen extends StatefulWidget {
  final CareGroup careGroup;

  const CareGroupDashboardScreen({
    super.key,
    required this.careGroup,
  });

  @override
  State<CareGroupDashboardScreen> createState() => _CareGroupDashboardScreenState();
}

class _CareGroupDashboardScreenState extends State<CareGroupDashboardScreen> {
  final CareGroupService _careGroupService = CareGroupService();
  CareGroupDashboardData? _dashboardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final dashboardData = await _careGroupService.getDashboardData(widget.careGroup.id);
      
      setState(() {
        _dashboardData = dashboardData;
        _isLoading = false;
      });
    } catch (e) {
      log('Error loading dashboard data: $e');
      setState(() {
        _error = 'Failed to load dashboard data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.careGroup.name} Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _buildBody(),
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
              onPressed: _loadDashboardData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildRecentActivities(),
            const SizedBox(height: 24),
            _buildMembersOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.people,
                title: 'Total Members',
                value: _dashboardData?.totalMembers.toString() ?? '0',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.online_prediction,
                title: 'Active Members',
                value: _dashboardData?.activeMembers.toString() ?? '0',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.health_and_safety,
                title: 'Check-ins Today',
                value: '5', // Placeholder
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.trending_up,
                title: 'Health Score',
                value: '8.5', // Placeholder
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    final activities = _dashboardData?.recentActivities ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        if (activities.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.timeline,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recent activities',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Activities will appear here when members interact with the group.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(activity);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildActivityItem(RecentActivity activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getActivityColor(activity.type).withOpacity(0.1),
        child: Icon(
          _getActivityIcon(activity.type),
          color: _getActivityColor(activity.type),
        ),
      ),
      title: Text(activity.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activity.userName),
          Text(
            _formatTimestamp(activity.timestamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildMembersOverview() {
    final members = _dashboardData?.members ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () {
                // Navigate to full members screen
                Navigator.pop(context);
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ...members.take(5).map((member) => _buildMemberItem(member)),
              if (members.length > 5)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'and ${members.length - 5} more members',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberItem(CareGroupMember member) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getRoleColor(member.role).withOpacity(0.1),
        child: Text(
          member.user?.name?.substring(0, 1).toUpperCase() ?? 'U',
          style: TextStyle(
            color: _getRoleColor(member.role),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(member.user?.name ?? 'Unknown User'),
      subtitle: Text(member.role.displayName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: member.isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            member.isActive ? 'Active' : 'Inactive',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(CareRole role) {
    switch (role) {
      case CareRole.OWNER:
        return Colors.purple;
      case CareRole.ADMIN:
        return Colors.blue;
      case CareRole.CAREGIVER:
        return Colors.green;
      case CareRole.MEMBER:
        return Colors.orange;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checkin':
        return Icons.health_and_safety;
      case 'medication':
        return Icons.medication;
      case 'join':
        return Icons.person_add;
      case 'alert':
        return Icons.warning;
      default:
        return Icons.timeline;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'checkin':
        return Colors.green;
      case 'medication':
        return Colors.blue;
      case 'join':
        return Colors.purple;
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
