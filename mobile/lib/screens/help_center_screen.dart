import 'package:flutter/material.dart';
import '../widgets/widget_optimizer.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Content
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildHelpCategories()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCategories() {
    return WidgetOptimizer.optimizeListView(
      padding: const EdgeInsets.all(16.0),
      addRepaintBoundaries: true,
      children: [
        _buildQuickActions(),
        const SizedBox(height: 24),
        _buildCategorySection(
          'Getting Started',
          Icons.rocket_launch,
          Colors.blue,
          _getGettingStartedItems(),
        ),
        const SizedBox(height: 16),
        _buildCategorySection(
          'Health Tracking',
          Icons.health_and_safety,
          Colors.green,
          _getHealthTrackingItems(),
        ),
        const SizedBox(height: 16),
        _buildCategorySection(
          'Care Groups',
          Icons.group,
          Colors.purple,
          _getCareGroupItems(),
        ),
        const SizedBox(height: 16),
        _buildCategorySection(
          'Medications',
          Icons.medication,
          Colors.orange,
          _getMedicationItems(),
        ),
        const SizedBox(height: 16),
        _buildCategorySection(
          'Privacy & Security',
          Icons.security,
          Colors.red,
          _getPrivacyItems(),
        ),
        const SizedBox(height: 16),
        _buildCategorySection(
          'Troubleshooting',
          Icons.build,
          Colors.grey,
          _getTroubleshootingItems(),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'Contact Support',
                    Icons.support_agent,
                    Colors.blue,
                    () => Navigator.pushNamed(context, '/contact-support'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    'Video Tutorials',
                    Icons.play_circle,
                    Colors.green,
                    () => _showVideoTutorials(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    'User Guide',
                    Icons.menu_book,
                    Colors.orange,
                    () => _showUserGuide(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    'Report Issue',
                    Icons.bug_report,
                    Colors.red,
                    () => _showReportIssue(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    Color color,
    List<HelpItem> items,
  ) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: items
            .map((item) => ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showHelpArticle(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSearchResults() {
    final allItems = [
      ..._getGettingStartedItems(),
      ..._getHealthTrackingItems(),
      ..._getCareGroupItems(),
      ..._getMedicationItems(),
      ..._getPrivacyItems(),
      ..._getTroubleshootingItems(),
    ];

    final filteredItems = allItems
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery) ||
            item.subtitle.toLowerCase().contains(_searchQuery) ||
            item.content.toLowerCase().contains(_searchQuery))
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "$_searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords or browse categories above',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelpArticle(item),
          ),
        );
      },
    );
  }

  void _showHelpArticle(HelpItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpArticleScreen(item: item),
      ),
    );
  }

  void _showVideoTutorials() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VideoTutorialsScreen(),
      ),
    );
  }

  void _showUserGuide() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserGuideScreen(),
      ),
    );
  }

  void _showReportIssue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportIssueScreen(),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Help content data
  List<HelpItem> _getGettingStartedItems() {
    return [
      HelpItem(
        title: 'Welcome to CareCircle',
        subtitle: 'Learn the basics of using CareCircle',
        content: '''
Welcome to CareCircle! This app helps you manage your health and stay connected with your care team.

Key Features:
• Health tracking and monitoring
• Medication management
• Care group coordination
• Daily check-ins
• Emergency contacts

Getting Started:
1. Complete your profile setup
2. Add your medications
3. Invite family members to your care group
4. Set up your health tracking preferences
5. Configure notification settings

Need help? Use the search feature above or browse the help categories.
        ''',
      ),
      HelpItem(
        title: 'Setting Up Your Profile',
        subtitle: 'Complete your personal information',
        content: '''
Your profile helps personalize your CareCircle experience.

To set up your profile:
1. Go to Settings > Profile
2. Add your photo (optional)
3. Enter your basic information
4. Set your emergency contacts
5. Configure your health preferences

Your information is kept secure and private. Only members of your care group can see the information you choose to share.
        ''',
      ),
    ];
  }

  List<HelpItem> _getHealthTrackingItems() {
    return [
      HelpItem(
        title: 'Daily Check-ins',
        subtitle: 'Track your daily health status',
        content: '''
Daily check-ins help you monitor your health trends over time.

How to complete a check-in:
1. Open the app and tap "Daily Check-in"
2. Rate your mood, energy, and pain levels
3. Add any symptoms you're experiencing
4. Include notes about your day
5. Submit your check-in

Your care team can see your check-ins to better support you.
        ''',
      ),
    ];
  }

  List<HelpItem> _getCareGroupItems() {
    return [
      HelpItem(
        title: 'Creating a Care Group',
        subtitle: 'Set up your support network',
        content: '''
Care groups help coordinate care between family members and caregivers.

To create a care group:
1. Go to Care Groups
2. Tap "Create New Group"
3. Enter group name and description
4. Invite members via email or phone
5. Set member roles and permissions

Group members can view your health updates and provide support.
        ''',
      ),
    ];
  }

  List<HelpItem> _getMedicationItems() {
    return [
      HelpItem(
        title: 'Adding Medications',
        subtitle: 'Manage your medication schedule',
        content: '''
Keep track of all your medications in one place.

To add a medication:
1. Go to Medications
2. Tap "Add Medication"
3. Enter medication details
4. Set dosage and schedule
5. Configure reminders

You can also scan prescription labels to automatically add medications.
        ''',
      ),
    ];
  }

  List<HelpItem> _getPrivacyItems() {
    return [
      HelpItem(
        title: 'Privacy Settings',
        subtitle: 'Control your data and privacy',
        content: '''
Your privacy is important to us. You control what information is shared.

Privacy controls:
• Data sharing preferences
• Care group visibility settings
• Export your data
• Delete your account
• Consent management

Go to Settings > Privacy to manage these options.
        ''',
      ),
    ];
  }

  List<HelpItem> _getTroubleshootingItems() {
    return [
      HelpItem(
        title: 'App Not Working Properly',
        subtitle: 'Common issues and solutions',
        content: '''
If you're experiencing issues with the app:

1. Check your internet connection
2. Restart the app
3. Update to the latest version
4. Restart your device
5. Clear app cache (Android)

If problems persist, contact our support team.
        ''',
      ),
    ];
  }
}

class HelpItem {
  final String title;
  final String subtitle;
  final String content;

  HelpItem({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}

class HelpArticleScreen extends StatelessWidget {
  final HelpItem item;

  const HelpArticleScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              item.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Was this helpful?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showFeedback(context, true),
                          icon: const Icon(Icons.thumb_up),
                          label: const Text('Yes'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => _showFeedback(context, false),
                          icon: const Icon(Icons.thumb_down),
                          label: const Text('No'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedback(BuildContext context, bool helpful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          helpful
              ? 'Thank you for your feedback!'
              : 'We\'ll work on improving this article.',
        ),
      ),
    );
  }
}
