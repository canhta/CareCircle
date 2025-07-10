import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../ai-assistant/presentation/screens/ai_assistant_home_screen.dart';
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
    const Placeholder(), // Health Data Screen (placeholder)
    const AIAssistantHomeScreen(), // AI Assistant - Central position
    const Placeholder(), // Medications Screen (placeholder)
    const Placeholder(), // Care Circle Screen (placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 2 ? null : _buildAIAssistantFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(
              icon: Icons.health_and_safety,
              label: 'Health',
              index: 1,
            ),
            const SizedBox(width: 40), // Space for FAB
            _buildNavItem(icon: Icons.medication, label: 'Meds', index: 3),
            _buildNavItem(icon: Icons.family_restroom, label: 'Care', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? CareCircleDesignTokens.primaryMedicalBlue
        : Colors.grey;

    return InkWell(
      onTap: () {
        final previousIndex = _currentIndex;
        NavigationService.logTabNavigation(
          previousIndex,
          index,
          _tabNames[index],
        );
        setState(() => _currentIndex = index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantFAB() {
    return FloatingActionButton.large(
      onPressed: () {
        final previousIndex = _currentIndex;
        NavigationService.logTabNavigation(previousIndex, 2, _tabNames[2]);
        setState(() => _currentIndex = 2);
      },
      backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      foregroundColor: Colors.white,
      elevation: 8,
      heroTag: "ai_assistant_fab",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.smart_toy, size: 28),
          const SizedBox(height: 2),
          const Text(
            'AI',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
