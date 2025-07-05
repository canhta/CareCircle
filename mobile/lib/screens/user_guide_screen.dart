import 'package:flutter/material.dart';

/// User guide section data model
class GuideSection {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<GuideStep> steps;

  const GuideSection({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

/// Individual guide step
class GuideStep {
  final String title;
  final String description;
  final String? tip;

  const GuideStep({
    required this.title,
    required this.description,
    this.tip,
  });
}

/// Comprehensive user guide screen
class UserGuideScreen extends StatefulWidget {
  const UserGuideScreen({super.key});

  @override
  State<UserGuideScreen> createState() => _UserGuideScreenState();
}

class _UserGuideScreenState extends State<UserGuideScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getGuideSections();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Guide'),
        backgroundColor: Colors.orange.shade50,
        foregroundColor: Colors.orange.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildProgressIndicator(sections.length),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: sections.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildSectionPage(sections[index]);
              },
            ),
          ),
          _buildNavigationButtons(sections.length),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: Colors.orange.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'CareCircle User Guide',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'A comprehensive guide to help you master CareCircle. '
              'Swipe through sections or use the navigation buttons below.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int totalSections) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(totalSections, (index) {
          final isActive = index == _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.orange : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionPage(GuideSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section),
          const SizedBox(height: 24),
          ...section.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildStepCard(step, index + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(GuideSection section) {
    return Card(
      color: section.color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    section.icon,
                    color: section.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        section.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(GuideStep step, int stepNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      stepNumber.toString(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            if (step.tip != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tip: ${step.tip}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade800,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(int totalSections) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Previous'),
              ),
            ),
          if (_currentPage > 0 && _currentPage < totalSections - 1)
            const SizedBox(width: 16),
          if (_currentPage < totalSections - 1)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Next'),
              ),
            ),
          if (_currentPage == totalSections - 1)
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Guide'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for topics...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality coming soon!'),
                ),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  List<GuideSection> _getGuideSections() {
    return [
      const GuideSection(
        id: '1',
        title: 'Getting Started',
        description: 'Set up your account and learn the basics',
        icon: Icons.rocket_launch,
        color: Colors.blue,
        steps: [
          GuideStep(
            title: 'Create Your Account',
            description: 'Sign up with your email or phone number. Verify your account through the confirmation link or SMS code.',
            tip: 'Use a strong password and enable two-factor authentication for better security.',
          ),
          GuideStep(
            title: 'Complete Your Profile',
            description: 'Add your personal information, emergency contacts, and health preferences. This helps personalize your experience.',
          ),
          GuideStep(
            title: 'Explore the Dashboard',
            description: 'Familiarize yourself with the main dashboard. Here you\'ll see your health summary, recent activities, and quick actions.',
          ),
        ],
      ),
      const GuideSection(
        id: '2',
        title: 'Health Tracking',
        description: 'Monitor your health data and vital signs',
        icon: Icons.health_and_safety,
        color: Colors.green,
        steps: [
          GuideStep(
            title: 'Connect Health Devices',
            description: 'Link your fitness trackers, smartwatches, or health monitoring devices to automatically sync data.',
            tip: 'Most popular devices like Apple Watch, Fitbit, and Samsung Health are supported.',
          ),
          GuideStep(
            title: 'Manual Data Entry',
            description: 'Enter health data manually when devices aren\'t available. Track weight, blood pressure, glucose levels, and more.',
          ),
          GuideStep(
            title: 'View Health Charts',
            description: 'Analyze your health trends with interactive charts. Switch between different time periods and data types.',
          ),
        ],
      ),
      const GuideSection(
        id: '3',
        title: 'Medications',
        description: 'Manage your medications and reminders',
        icon: Icons.medication,
        color: Colors.orange,
        steps: [
          GuideStep(
            title: 'Add Medications',
            description: 'Enter your medications with dosage, frequency, and instructions. Use the camera to scan prescription labels.',
            tip: 'Take a photo of your medication bottles for easy reference.',
          ),
          GuideStep(
            title: 'Set Reminders',
            description: 'Configure reminder times that work with your schedule. Set different times for different medications.',
          ),
          GuideStep(
            title: 'Track Adherence',
            description: 'Mark medications as taken, skipped, or delayed. View your adherence history and patterns.',
          ),
        ],
      ),
      const GuideSection(
        id: '4',
        title: 'Care Groups',
        description: 'Connect with family and caregivers',
        icon: Icons.group,
        color: Colors.purple,
        steps: [
          GuideStep(
            title: 'Create a Care Group',
            description: 'Set up a care group and invite family members or caregivers. Choose what information to share.',
          ),
          GuideStep(
            title: 'Manage Privacy',
            description: 'Control what health information is visible to each care group member. Adjust settings anytime.',
            tip: 'You can have different privacy levels for different family members.',
          ),
          GuideStep(
            title: 'Share Updates',
            description: 'Send health updates, emergency alerts, or daily check-ins to your care group members.',
          ),
        ],
      ),
    ];
  }
}
