import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design/design_tokens.dart';
import '../../../../core/logging/bounded_context_loggers.dart';
import '../../domain/models/models.dart' as notification_models;
import '../providers/notification_providers.dart';
import '../widgets/notification_list_item.dart';
import '../widgets/notification_filter_bar.dart';
import '../widgets/notification_search_bar.dart';

/// Notification Center Screen
///
/// Displays all user notifications with:
/// - Filtering by type, priority, and status
/// - Search functionality
/// - Mark as read/unread actions
/// - Pull-to-refresh
/// - Infinite scrolling
class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _logger = BoundedContextLoggers.notification;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Log screen access
    _logger.info('Notification center accessed', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareCircleDesignTokens.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          const NotificationSearchBar(),
          const NotificationFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllNotificationsTab(),
                _buildUnreadNotificationsTab(),
                _buildImportantNotificationsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      foregroundColor: Colors.white,
      title: const Text(
        'Notifications',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Notification summary badge
        Consumer(
          builder: (context, ref, child) {
            final summaryAsync = ref.watch(notificationSummaryProvider);
            return summaryAsync.when(
              data: (summary) => _buildNotificationBadge(summary.unread),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
        // Settings button
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/notifications/preferences'),
          tooltip: 'Notification Settings',
        ),
        // More options menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'mark_all_read',
              child: Row(
                children: [
                  Icon(Icons.mark_email_read, size: 20),
                  SizedBox(width: 12),
                  Text('Mark All Read'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, size: 20),
                  SizedBox(width: 12),
                  Text('Clear All'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 12),
                  Text('Refresh'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationBadge(int unreadCount) {
    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.errorRed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: CareCircleDesignTokens.primaryMedicalBlue,
        unselectedLabelColor: CareCircleDesignTokens.textSecondary,
        indicatorColor: CareCircleDesignTokens.primaryMedicalBlue,
        indicatorWeight: 3,
        tabs: [
          Tab(
            child: Consumer(
              builder: (context, ref, child) {
                final notificationsAsync = ref.watch(notificationsProvider);
                return notificationsAsync.when(
                  data: (notifications) => _buildTabWithCount('All', notifications.length),
                  loading: () => const Text('All'),
                  error: (_, __) => const Text('All'),
                );
              },
            ),
          ),
          Tab(
            child: Consumer(
              builder: (context, ref, child) {
                final unreadAsync = ref.watch(unreadNotificationsProvider);
                return unreadAsync.when(
                  data: (unread) => _buildTabWithCount('Unread', unread.length),
                  loading: () => const Text('Unread'),
                  error: (_, __) => const Text('Unread'),
                );
              },
            ),
          ),
          const Tab(text: 'Important'),
        ],
      ),
    );
  }

  Widget _buildTabWithCount(String label, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAllNotificationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final notificationsAsync = ref.watch(filteredNotificationsProvider);
        
        return notificationsAsync.when(
          data: (notifications) => _buildNotificationList(notifications),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildUnreadNotificationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        // Set unread filter when this tab is active
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(showOnlyUnreadProvider.notifier).state = true;
        });

        final notificationsAsync = ref.watch(filteredNotificationsProvider);
        
        return notificationsAsync.when(
          data: (notifications) => _buildNotificationList(notifications),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildImportantNotificationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        // Set priority filter for important notifications
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(notificationPriorityFilterProvider.notifier).state = 
              NotificationPriority.high;
        });

        final notificationsAsync = ref.watch(filteredNotificationsProvider);
        
        return notificationsAsync.when(
          data: (notifications) => _buildNotificationList(notifications),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildNotificationList(List<notification_models.Notification> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: CareCircleDesignTokens.primaryMedicalBlue,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationListItem(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
            onMarkAsRead: () => _handleMarkAsRead(notification),
            onDelete: () => _handleDeleteNotification(notification),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading notifications...',
            style: TextStyle(
              fontSize: 16,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: CareCircleDesignTokens.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
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
            Icons.notifications_none,
            size: 64,
            color: CareCircleDesignTokens.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => context.push('/notifications/preferences'),
      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      foregroundColor: Colors.white,
      child: const Icon(Icons.tune),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      await ref.read(notificationNotifierProvider.notifier).refresh();
      
      _logger.info('Notifications refreshed', {
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.error('Failed to refresh notifications', {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.errorRed,
          ),
        );
      }
    }
  }

  void _handleNotificationTap(notification_models.Notification notification) {
    _logger.info('Notification tapped', {
      'notificationId': notification.id,
      'type': notification.type.name,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Mark as read if unread
    if (notification.status != notification_models.NotificationStatus.read) {
      _handleMarkAsRead(notification);
    }

    // Navigate to detail screen
    context.push('/notifications/${notification.id}');
  }

  Future<void> _handleMarkAsRead(notification_models.Notification notification) async {
    try {
      await ref.read(notificationNotifierProvider.notifier)
          .markAsRead(notification.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marked as read'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _logger.error('Failed to mark notification as read', {
        'notificationId': notification.id,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: ${e.toString()}'),
            backgroundColor: CareCircleDesignTokens.errorRed,
          ),
        );
      }
    }
  }

  void _handleDeleteNotification(notification_models.Notification notification) {
    // TODO: Implement delete notification
    _logger.info('Delete notification requested', {
      'notificationId': notification.id,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        _handleMarkAllRead();
        break;
      case 'clear_all':
        _handleClearAll();
        break;
      case 'refresh':
        _handleRefresh();
        break;
    }
  }

  void _handleMarkAllRead() {
    // TODO: Implement mark all as read
    _logger.info('Mark all read requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _handleClearAll() {
    // TODO: Implement clear all notifications
    _logger.info('Clear all requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
