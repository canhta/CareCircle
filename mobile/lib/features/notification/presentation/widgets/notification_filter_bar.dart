import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';
import '../providers/notification_providers.dart';

/// Notification filter bar widget
///
/// Provides filtering options for notifications:
/// - Type filter (medication, health, emergency, etc.)
/// - Priority filter (low, normal, high, urgent)
/// - Status filter (read, unread, all)
/// - Clear filters button
class NotificationFilterBar extends ConsumerWidget {
  const NotificationFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeFilter = ref.watch(notificationTypeFilterProvider);
    final priorityFilter = ref.watch(notificationPriorityFilterProvider);
    final statusFilter = ref.watch(notificationStatusFilterProvider);
    final showOnlyUnread = ref.watch(showOnlyUnreadProvider);

    final hasActiveFilters =
        typeFilter != null ||
        priorityFilter != null ||
        statusFilter != null ||
        showOnlyUnread;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CareCircleDesignTokens.textPrimary,
                ),
              ),
              const Spacer(),
              if (hasActiveFilters)
                TextButton(
                  onPressed: () => _clearAllFilters(ref),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeFilter(ref, typeFilter),
                const SizedBox(width: 8),
                _buildPriorityFilter(ref, priorityFilter),
                const SizedBox(width: 8),
                _buildStatusFilter(ref, statusFilter, showOnlyUnread),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter(WidgetRef ref, NotificationType? currentFilter) {
    return PopupMenuButton<NotificationType?>(
      onSelected: (type) {
        ref.read(notificationTypeFilterProvider.notifier).state = type;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All Types')),
        ...NotificationType.values.map(
          (type) => PopupMenuItem(
            value: type,
            child: Row(
              children: [
                Text(type.icon),
                const SizedBox(width: 8),
                Text(type.displayName),
              ],
            ),
          ),
        ),
      ],
      child: _buildFilterChip(
        label: currentFilter?.displayName ?? 'Type',
        icon: currentFilter?.icon,
        isActive: currentFilter != null,
      ),
    );
  }

  Widget _buildPriorityFilter(
    WidgetRef ref,
    NotificationPriority? currentFilter,
  ) {
    return PopupMenuButton<NotificationPriority?>(
      onSelected: (priority) {
        ref.read(notificationPriorityFilterProvider.notifier).state = priority;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All Priorities')),
        ...NotificationPriority.values.map(
          (priority) => PopupMenuItem(
            value: priority,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(priority),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 8),
                Text(priority.displayName),
              ],
            ),
          ),
        ),
      ],
      child: _buildFilterChip(
        label: currentFilter?.displayName ?? 'Priority',
        isActive: currentFilter != null,
        color: currentFilter != null ? _getPriorityColor(currentFilter) : null,
      ),
    );
  }

  Widget _buildStatusFilter(
    WidgetRef ref,
    NotificationStatus? currentFilter,
    bool showOnlyUnread,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'all':
            ref.read(notificationStatusFilterProvider.notifier).state = null;
            ref.read(showOnlyUnreadProvider.notifier).state = false;
            break;
          case 'unread':
            ref.read(notificationStatusFilterProvider.notifier).state = null;
            ref.read(showOnlyUnreadProvider.notifier).state = true;
            break;
          case 'read':
            ref.read(notificationStatusFilterProvider.notifier).state =
                NotificationStatus.read;
            ref.read(showOnlyUnreadProvider.notifier).state = false;
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'all',
          child: Row(
            children: [
              Icon(Icons.all_inclusive, size: 16),
              SizedBox(width: 8),
              Text('All Status'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'unread',
          child: Row(
            children: [
              Icon(Icons.mark_email_unread, size: 16),
              SizedBox(width: 8),
              Text('Unread'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'read',
          child: Row(
            children: [
              Icon(Icons.mark_email_read, size: 16),
              SizedBox(width: 8),
              Text('Read'),
            ],
          ),
        ),
      ],
      child: _buildFilterChip(
        label: showOnlyUnread
            ? 'Unread'
            : currentFilter == NotificationStatus.read
            ? 'Read'
            : 'Status',
        icon: showOnlyUnread
            ? '📧'
            : currentFilter == NotificationStatus.read
            ? '✅'
            : null,
        isActive: showOnlyUnread || currentFilter != null,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    String? icon,
    bool isActive = false,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? (color ?? CareCircleDesignTokens.primaryMedicalBlue).withValues(
                alpha: 0.1,
              )
            : CareCircleDesignTokens.backgroundSecondary,
        border: Border.all(
          color: isActive
              ? (color ?? CareCircleDesignTokens.primaryMedicalBlue)
              : CareCircleDesignTokens.borderLight,
          width: isActive ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive
                  ? (color ?? CareCircleDesignTokens.primaryMedicalBlue)
                  : CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isActive
                ? (color ?? CareCircleDesignTokens.primaryMedicalBlue)
                : CareCircleDesignTokens.textSecondary,
          ),
        ],
      ),
    );
  }

  void _clearAllFilters(WidgetRef ref) {
    ref.read(notificationTypeFilterProvider.notifier).state = null;
    ref.read(notificationPriorityFilterProvider.notifier).state = null;
    ref.read(notificationStatusFilterProvider.notifier).state = null;
    ref.read(showOnlyUnreadProvider.notifier).state = false;
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return CareCircleDesignTokens.successGreen;
      case NotificationPriority.normal:
        return CareCircleDesignTokens.primaryMedicalBlue;
      case NotificationPriority.high:
        return CareCircleDesignTokens.warningOrange;
      case NotificationPriority.urgent:
        return CareCircleDesignTokens.errorRed;
    }
  }
}

/// Active filters indicator widget
class ActiveFiltersIndicator extends ConsumerWidget {
  const ActiveFiltersIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeFilter = ref.watch(notificationTypeFilterProvider);
    final priorityFilter = ref.watch(notificationPriorityFilterProvider);
    final statusFilter = ref.watch(notificationStatusFilterProvider);
    final showOnlyUnread = ref.watch(showOnlyUnreadProvider);

    final activeFilters = <String>[];

    if (typeFilter != null) {
      activeFilters.add(typeFilter.displayName);
    }
    if (priorityFilter != null) {
      activeFilters.add(priorityFilter.displayName);
    }
    if (statusFilter != null) {
      activeFilters.add(statusFilter.name);
    }
    if (showOnlyUnread) {
      activeFilters.add('Unread');
    }

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: CareCircleDesignTokens.primaryMedicalBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Filtered by: ${activeFilters.join(', ')}',
              style: TextStyle(
                fontSize: 12,
                color: CareCircleDesignTokens.primaryMedicalBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _clearAllFilters(ref),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 24),
            ),
            child: Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters(WidgetRef ref) {
    ref.read(notificationTypeFilterProvider.notifier).state = null;
    ref.read(notificationPriorityFilterProvider.notifier).state = null;
    ref.read(notificationStatusFilterProvider.notifier).state = null;
    ref.read(showOnlyUnreadProvider.notifier).state = false;
  }
}
