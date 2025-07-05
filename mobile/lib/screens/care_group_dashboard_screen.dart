// Care Group Dashboard Screen
// Shows dashboard with insights and activities for a care group

import 'package:flutter/material.dart';
import 'dart:developer';
import '../features/care_group/care_group.dart';
import '../common/common.dart';

class CareGroupDashboardScreen extends StatefulWidget {
  final CareGroup careGroup;

  const CareGroupDashboardScreen({
    super.key,
    required this.careGroup,
  });

  @override
  State<CareGroupDashboardScreen> createState() =>
      _CareGroupDashboardScreenState();
}

class _CareGroupDashboardScreenState extends State<CareGroupDashboardScreen> {
  late final CareGroupService _careGroupService;
  List<CareGroupMember> _members = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: AppLogger('CareGroupDashboardScreen'),
    );
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result =
        await _careGroupService.getCareGroupMembers(widget.careGroup.id);

    result.fold(
      (members) => {
        setState(() {
          _members = members;
          _isLoading = false;
        })
      },
      (error) => {
        log('Error loading dashboard data: $error'),
        setState(() {
          _error = 'Failed to load dashboard data';
          _isLoading = false;
        })
      },
    );
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
                value: _members.length.toString(),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.online_prediction,
                title: 'Active Members',
                value: _members.length.toString(),
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
                    color: color.withValues(alpha: 0.1),
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
    // For now, show a placeholder since we don't have activities in the service
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
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
                    'Activity tracking will be available soon',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersOverview() {
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
              ..._members.take(5).map((member) => _buildMemberItem(member)),
              if (_members.length > 5)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'and ${_members.length - 5} more members',
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
        backgroundColor: _getRoleColor(member.role).withValues(alpha: 0.1),
        child: Text(
          member.firstName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: _getRoleColor(member.role),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(member.fullName),
      subtitle: Text(_getRoleDisplayName(member.role)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green, // All members shown as active for now
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Active',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(CareGroupRole role) {
    switch (role) {
      case CareGroupRole.admin:
        return Colors.red;
      case CareGroupRole.member:
        return Colors.blue;
      case CareGroupRole.viewer:
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
}
