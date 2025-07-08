import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/design_tokens.dart';
import '../../../core/widgets/care_circle_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to CareCircle',
      description:
          'Your comprehensive health management platform designed for family care coordination and wellness tracking.',
      icon: Icons.favorite,
      color: CareCircleDesignTokens.primaryMedicalBlue,
    ),
    OnboardingPage(
      title: 'AI Health Assistant',
      description:
          'Get personalized health insights and recommendations from our AI-powered assistant available 24/7.',
      icon: Icons.psychology,
      color: CareCircleDesignTokens.primaryMedicalBlue,
    ),
    OnboardingPage(
      title: 'Medication Management',
      description:
          'Track medications, set reminders, and scan prescriptions with our intelligent medication management system.',
      icon: Icons.medication,
      color: CareCircleDesignTokens.healthGreen,
    ),
    OnboardingPage(
      title: 'Family Care Groups',
      description:
          'Connect with family members, share health updates, and coordinate care activities together.',
      icon: Icons.family_restroom,
      color: CareCircleDesignTokens.healthGreen,
    ),
    OnboardingPage(
      title: 'Health Data Tracking',
      description:
          'Monitor vital signs, sync with health devices, and track your wellness journey over time.',
      icon: Icons.monitor_heart,
      color: CareCircleDesignTokens.primaryMedicalBlue,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _handleSkip,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Back button
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handlePrevious,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: CareCircleDesignTokens.primaryMedicalBlue,
                          ),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: CareCircleDesignTokens.primaryMedicalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  if (_currentPage > 0) const SizedBox(width: 16),

                  // Next/Get Started button
                  Expanded(
                    flex: _currentPage > 0 ? 1 : 2,
                    child: CareCircleButton(
                      onPressed: _handleNext,
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(page.icon, size: 60, color: page.color),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: page.color,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? CareCircleDesignTokens.primaryMedicalBlue
            : CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _handlePrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleComplete();
    }
  }

  void _handleSkip() {
    _handleComplete();
  }

  void _handleComplete() {
    // Mark onboarding as completed and navigate to home
    context.go('/home');
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
