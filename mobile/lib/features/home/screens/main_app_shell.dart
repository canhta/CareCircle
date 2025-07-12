import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/care_circle_icons.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/navigation/care_circle_tab_bar.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../ai-assistant/presentation/screens/ai_assistant_home_screen.dart';
import '../../medication/presentation/screens/medication_list_screen.dart';
import '../../health_data/presentation/screens/health_dashboard_screen.dart';
import '../../notification/presentation/providers/notification_providers.dart';
import '../../medication/presentation/providers/medication_providers.dart';
import 'home_screen.dart';

class MainAppShell extends ConsumerStatefulWidget {
  const MainAppShell({super.key});

  @override
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  int _currentIndex = 0;

  // Tab names for logging
  final List<String> _tabNames = [
    'Home',
    'Health Data',
    'AI Assistant',
    'Medications',
    'Care Circle',
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const HealthDashboardScreen(), // Health Data Screen
    const AIAssistantHomeScreen(), // AI Assistant - Central position
    const MedicationListScreen(), // Medications Screen
    const Placeholder(), // Care Circle Screen (placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CareCircleGradientTokens.softBackground,
        ),
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: _buildHealthcareTabBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHealthcareTabBar() {
    return CareCircleTabBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      tabs: [
        CareCircleTab(
          icon: CareCircleIcons.home,
          label: 'Home',
          semanticLabel: 'Home dashboard',
          semanticHint: 'View your health overview and quick actions',
        ),
        CareCircleTab(
          icon: CareCircleIcons.healthData,
          label: 'Health Data',
          semanticLabel: 'Health data',
          semanticHint: 'View detailed health metrics and trends',
          badge: _getHealthDataBadge(),
          urgencyIndicator: _getHealthDataUrgency(),
        ),
        CareCircleTab(
          icon: CareCircleIcons.aiAssistant,
          label: 'AI Assistant',
          semanticLabel: 'AI health assistant',
          semanticHint: 'Get personalized healthcare guidance and support',
        ),
        CareCircleTab(
          icon: CareCircleIcons.medication,
          label: 'Medications',
          semanticLabel: 'Medications',
          semanticHint: 'Manage medications and view reminders',
          badge: _getMedicationBadge(),
          urgencyIndicator: _getMedicationUrgency(),
        ),
        CareCircleTab(
          icon: CareCircleIcons.careCircle,
          label: 'Care Circle',
          semanticLabel: 'Care circle',
          semanticHint: 'Connect with your care team and family',
        ),
      ],
    );
  }

  void _onTabTapped(int index) {
    final previousIndex = _currentIndex;
    NavigationService.logTabNavigation(previousIndex, index, _tabNames[index]);
    setState(() => _currentIndex = index);
  }

  // Healthcare-specific badge and urgency methods
  String? _getHealthDataBadge() {
    // Get health data related notifications
    final notificationsAsync = ref.watch(unreadNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        final healthDataNotifications = notifications
            .where(
              (notification) =>
                  notification.type.toString().contains('health') ||
                  notification.type.toString().contains('vital') ||
                  notification.type.toString().contains('metric'),
            )
            .length;

        return healthDataNotifications > 0
            ? healthDataNotifications.toString()
            : null;
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  UrgencyLevel _getHealthDataUrgency() {
    // Check for critical health data notifications
    final notificationsAsync = ref.watch(unreadNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        final healthDataNotifications = notifications.where(
          (notification) =>
              notification.type.toString().contains('health') ||
              notification.type.toString().contains('vital') ||
              notification.type.toString().contains('metric'),
        );

        // Check for high priority health notifications
        final hasHighPriority = healthDataNotifications.any(
          (notification) =>
              notification.priority.toString().contains('high') ||
              notification.priority.toString().contains('critical'),
        );

        if (hasHighPriority) return UrgencyLevel.high;

        final hasMediumPriority = healthDataNotifications.any(
          (notification) => notification.priority.toString().contains('medium'),
        );

        if (hasMediumPriority) return UrgencyLevel.medium;

        return healthDataNotifications.isNotEmpty
            ? UrgencyLevel.low
            : UrgencyLevel.none;
      },
      loading: () => UrgencyLevel.none,
      error: (error, stackTrace) => UrgencyLevel.none,
    );
  }

  String? _getMedicationBadge() {
    // Get medication related notifications and pending notifications
    final notificationsAsync = ref.watch(unreadNotificationsProvider);
    final pendingNotificationsAsync = ref.watch(
      pendingNotificationsCountProvider,
    );

    return notificationsAsync.when(
      data: (notifications) {
        final medicationNotifications = notifications
            .where(
              (notification) =>
                  notification.type.toString().contains('medication') ||
                  notification.type.toString().contains('dose') ||
                  notification.type.toString().contains('reminder'),
            )
            .length;

        // Also include pending medication notifications
        final pendingCount = pendingNotificationsAsync.when(
          data: (count) => count,
          loading: () => 0,
          error: (error, stackTrace) => 0,
        );

        final totalCount = medicationNotifications + pendingCount;
        return totalCount > 0 ? totalCount.toString() : null;
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  UrgencyLevel _getMedicationUrgency() {
    // Check for critical medication notifications
    final notificationsAsync = ref.watch(unreadNotificationsProvider);

    return notificationsAsync.when(
      data: (notifications) {
        final medicationNotifications = notifications.where(
          (notification) =>
              notification.type.toString().contains('medication') ||
              notification.type.toString().contains('dose') ||
              notification.type.toString().contains('reminder'),
        );

        // Check for critical medication alerts (missed critical medications)
        final hasCritical = medicationNotifications.any(
          (notification) =>
              notification.priority.toString().contains('critical') ||
              notification.priority.toString().contains('emergency') ||
              notification.title.toLowerCase().contains('missed') ||
              notification.title.toLowerCase().contains('overdue'),
        );

        if (hasCritical) return UrgencyLevel.critical;

        // Check for high priority medication notifications
        final hasHigh = medicationNotifications.any(
          (notification) => notification.priority.toString().contains('high'),
        );

        if (hasHigh) return UrgencyLevel.high;

        final hasMedium = medicationNotifications.any(
          (notification) => notification.priority.toString().contains('medium'),
        );

        if (hasMedium) return UrgencyLevel.medium;

        return medicationNotifications.isNotEmpty
            ? UrgencyLevel.low
            : UrgencyLevel.none;
      },
      loading: () => UrgencyLevel.none,
      error: (error, stackTrace) => UrgencyLevel.none,
    );
  }

  // Healthcare AI Assistant helper methods
  // Note: These methods will be implemented when AI assistant features are fully integrated
}
