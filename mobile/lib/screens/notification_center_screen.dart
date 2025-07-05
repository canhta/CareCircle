import 'package:flutter/material.dart';
import '../features/notification/notification.dart';
import '../common/common.dart';
import '../widgets/notification_card.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen>
    with SingleTickerProviderStateMixin {
  late final NotificationService _notificationService;
  late final TabController _tabController;

  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> _unreadNotifications = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationService = NotificationService(
      apiClient: ApiClient.instance,
      logger: AppLogger('NotificationCenterScreen'),
    );
    _loadNotifications();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreNotifications();
      }
    });
  }

  Future<void> _loadNotifications({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _allNotifications.clear();
        _unreadNotifications.clear();
      });
    }

    setState(() {
      _isLoading = refresh || _currentPage == 1;
      _error = null;
    });

    try {
      // Load all notifications
      final allResponse = await _notificationService.getNotifications(
        page: _currentPage,
        limit: 20,
        unreadOnly: false,
      );

      // Load unread notifications
      final unreadResponse = await _notificationService.getNotifications(
        page: 1,
        limit: 50,
        unreadOnly: true,
      );

      setState(() {
        if (refresh || _currentPage == 1) {
          _allNotifications = allResponse.notifications;
        } else {
          _allNotifications.addAll(allResponse.notifications);
        }
        _unreadNotifications = unreadResponse.notifications;
        _hasMore = allResponse.hasNext;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final response = await _notificationService.getNotifications(
        page: _currentPage,
        limit: 20,
        unreadOnly: false,
      );

      setState(() {
        _allNotifications.addAll(response.notifications);
        _hasMore = response.hasNext;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _currentPage--; // Revert page increment
        _isLoadingMore = false;
      });
      _showError('Failed to load more notifications');
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    try {
      await _notificationService.markAsRead(notification.id);

      setState(() {
        // Update the notification in both lists
        final allIndex =
            _allNotifications.indexWhere((n) => n.id == notification.id);
        if (allIndex != -1) {
          _allNotifications[allIndex] = notification.copyWith(
            readAt: DateTime.now(),
          );
        }

        // Remove from unread list
        _unreadNotifications.removeWhere((n) => n.id == notification.id);
      });
    } catch (e) {
      _showError('Failed to mark notification as read');
    }
  }

  Future<void> _handleNotificationAction(
    NotificationModel notification,
    String action,
  ) async {
    try {
      await _notificationService.handleNotificationAction(notification, action);
      await _markAsRead(notification);

      // Navigate based on notification type and action
      _navigateFromNotification(notification, action);
    } catch (e) {
      _showError('Failed to handle notification action');
    }
  }

  void _navigateFromNotification(
      NotificationModel notification, String action) {
    switch (notification.type) {
      case NotificationType.medicationReminder:
        if (action == 'view') {
          Navigator.pushNamed(context, '/prescriptions');
        }
        break;
      case NotificationType.checkInReminder:
        if (action == 'start_checkin') {
          Navigator.pushNamed(context, '/daily-checkin');
        }
        break;
      case NotificationType.careGroupUpdate:
        final careGroupId = notification.metadata?['careGroupId'];
        if (careGroupId != null) {
          Navigator.pushNamed(context, '/care-groups', arguments: careGroupId);
        }
        break;
      case NotificationType.healthInsight:
        Navigator.pushNamed(context, '/health-dashboard');
        break;
      default:
        break;
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNotificationPreferences() {
    Navigator.pushNamed(context, '/notification-preferences');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showNotificationPreferences,
            tooltip: 'Notification Preferences',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'All',
              icon: _allNotifications.isNotEmpty
                  ? Badge(
                      label: Text('${_allNotifications.length}'),
                      child: const Icon(Icons.notifications),
                    )
                  : const Icon(Icons.notifications),
            ),
            Tab(
              text: 'Unread',
              icon: _unreadNotifications.isNotEmpty
                  ? Badge(
                      label: Text('${_unreadNotifications.length}'),
                      child: const Icon(Icons.notifications_active),
                    )
                  : const Icon(Icons.notifications_none),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(_allNotifications, false),
          _buildNotificationList(_unreadNotifications, true),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
      List<NotificationModel> notifications, bool unreadOnly) {
    if (_isLoading && notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null && notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadNotifications(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              unreadOnly ? Icons.notifications_none : Icons.notifications_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              unreadOnly ? 'No unread notifications' : 'No notifications yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              unreadOnly
                  ? 'All caught up! Check back later for new updates.'
                  : 'Notifications will appear here when you receive them.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadNotifications(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: notifications.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= notifications.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final notification = notifications[index];
          return NotificationCard(
            notification: notification,
            onTap: () => _markAsRead(notification),
            onAction: (action) =>
                _handleNotificationAction(notification, action),
            onDismiss: () => _markAsRead(notification),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
