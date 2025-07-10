import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/care_group_models.dart';
import '../providers/care_group_providers.dart';
import '../widgets/care_group_card.dart';
import '../widgets/create_care_group_dialog.dart';

class CareGroupsScreen extends ConsumerWidget {
  const CareGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careGroupsAsync = ref.watch(careGroupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Groups'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(careGroupNotifierProvider.notifier).loadCareGroups();
            },
          ),
        ],
      ),
      body: careGroupsAsync.when(
        data: (groups) => _buildGroupsList(context, ref, groups),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(context, ref, error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context, ref),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Group'),
      ),
    );
  }

  Widget _buildGroupsList(
    BuildContext context,
    WidgetRef ref,
    List<CareGroup> groups,
  ) {
    if (groups.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(careGroupNotifierProvider.notifier).loadCareGroups();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CareGroupCard(
              group: group,
              onTap: () => _navigateToGroupDetails(context, ref, group),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_add, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No Care Groups Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first care group to start coordinating care with family members and caregivers.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showCreateGroupDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Group'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: CareCircleDesignTokens.criticalAlert,
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Load Care Groups',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(careGroupNotifierProvider.notifier).loadCareGroups();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CreateCareGroupDialog(
        onGroupCreated: (group) {
          // Navigate to the newly created group
          _navigateToGroupDetails(context, ref, group);
        },
      ),
    );
  }

  void _navigateToGroupDetails(
    BuildContext context,
    WidgetRef ref,
    CareGroup group,
  ) {
    // Set the selected group
    ref.read(selectedCareGroupProvider.notifier).state = group;

    // Navigate to group details screen
    Navigator.of(context).pushNamed('/care-group/details', arguments: group.id);
  }
}

/// Statistics widget showing care group overview
class CareGroupStatsWidget extends ConsumerWidget {
  const CareGroupStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careGroupsAsync = ref.watch(careGroupNotifierProvider);

    return careGroupsAsync.when(
      data: (groups) {
        final totalGroups = groups.length;
        final totalMembers = groups.fold<int>(
          0,
          (sum, group) => sum + group.memberCount,
        );
        final totalActiveTasks = groups.fold<int>(
          0,
          (sum, group) => sum + group.activeTaskCount,
        );

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Care Coordination Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Groups',
                    totalGroups.toString(),
                    Icons.group,
                  ),
                  _buildStatItem(
                    context,
                    'Members',
                    totalMembers.toString(),
                    Icons.people,
                  ),
                  _buildStatItem(
                    context,
                    'Active Tasks',
                    totalActiveTasks.toString(),
                    Icons.task_alt,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: CareCircleDesignTokens.primaryMedicalBlue),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
