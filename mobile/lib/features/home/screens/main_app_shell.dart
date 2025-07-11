import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_tokens.dart';

import '../../../core/navigation/navigation_service.dart';
import '../../ai-assistant/presentation/screens/ai_assistant_home_screen.dart';
import '../../medication/presentation/screens/medication_list_screen.dart';
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
    const MedicationListScreen(), // Medications Screen
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
        height: 70,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                height: 1.2, // Tighter line height
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantFAB() {
    return Semantics(
      label: 'AI Health Assistant',
      hint:
          'Tap to open your AI health assistant for personalized healthcare guidance',
      button: true,
      child: Container(
        width: CareCircleDesignTokens.emergencyButtonMin,
        height: CareCircleDesignTokens.emergencyButtonMin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CareCircleDesignTokens.primaryMedicalBlue,
              CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                alpha: 0.3,
              ),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final previousIndex = _currentIndex;
              NavigationService.logTabNavigation(
                previousIndex,
                2,
                _tabNames[2],
              );
              setState(() => _currentIndex = 2);
            },
            borderRadius: BorderRadius.circular(
              CareCircleDesignTokens.emergencyButtonMin / 2,
            ),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              width: CareCircleDesignTokens.emergencyButtonMin,
              height: CareCircleDesignTokens.emergencyButtonMin,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 24,
                    color: Colors.white,
                    semanticLabel: 'AI Health Assistant Icon',
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'AI',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
