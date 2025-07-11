import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/care_circle_icons.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/navigation/care_circle_tab_bar.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../ai-assistant/presentation/screens/ai_assistant_home_screen.dart';
import '../../medication/presentation/screens/medication_list_screen.dart';
import '../../health_data/presentation/screens/health_dashboard_screen.dart';
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
    // TODO: Implement health data badge logic
    // Return number of unread health alerts or null
    return null;
  }

  UrgencyLevel _getHealthDataUrgency() {
    // TODO: Implement health data urgency logic
    // Check for critical health metrics
    return UrgencyLevel.none;
  }

  String? _getMedicationBadge() {
    // TODO: Implement medication badge logic
    // Return number of missed medications or null
    return null;
  }

  UrgencyLevel _getMedicationUrgency() {
    // TODO: Implement medication urgency logic
    // Check for missed critical medications
    return UrgencyLevel.none;
  }

  // Healthcare AI Assistant helper methods
  // Note: These methods will be implemented when AI assistant features are fully integrated
}
