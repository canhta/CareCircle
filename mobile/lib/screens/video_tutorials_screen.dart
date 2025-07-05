import 'package:flutter/material.dart';

/// Tutorial video data model
class TutorialVideo {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String category;
  final IconData icon;
  final Color color;
  final List<String> keyPoints;

  const TutorialVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.icon,
    required this.color,
    required this.keyPoints,
  });
}

/// Screen displaying video tutorials for CareCircle features
class VideoTutorialsScreen extends StatefulWidget {
  const VideoTutorialsScreen({super.key});

  @override
  State<VideoTutorialsScreen> createState() => _VideoTutorialsScreenState();
}

class _VideoTutorialsScreenState extends State<VideoTutorialsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Getting Started',
    'Health Tracking',
    'Medications',
    'Care Groups',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredVideos = _getFilteredVideos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tutorials'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildVideoList(filteredVideos),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle,
                  color: Colors.green.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Video Tutorials',
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
              'Learn how to use CareCircle with our step-by-step video guides. '
              'Each tutorial covers key features to help you get the most out of the app.',
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

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: Colors.green.shade100,
              labelStyle: TextStyle(
                color:
                    isSelected ? Colors.green.shade700 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList(List<TutorialVideo> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No tutorials found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildVideoCard(TutorialVideo video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => _showVideoDetails(video),
        borderRadius: BorderRadius.circular(8),
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
                      color: video.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      video.icon,
                      color: video.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.duration,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: video.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                video.category,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: video.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.play_circle_outline,
                    color: Colors.grey,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                video.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoDetails(TutorialVideo video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(video.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(video.description),
              const SizedBox(height: 16),
              const Text(
                'Key Points Covered:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...video.keyPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(child: Text(point)),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Video tutorials will be available in a future update. '
                        'For now, you can refer to the help articles in the Help Center.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to help center
            },
            child: const Text('View Help Articles'),
          ),
        ],
      ),
    );
  }

  List<TutorialVideo> _getFilteredVideos() {
    final allVideos = _getAllVideos();

    if (_selectedCategory == 'All') {
      return allVideos;
    }

    return allVideos
        .where((video) => video.category == _selectedCategory)
        .toList();
  }

  List<TutorialVideo> _getAllVideos() {
    return [
      const TutorialVideo(
        id: '1',
        title: 'Getting Started with CareCircle',
        description:
            'Learn the basics of setting up your CareCircle account and navigating the app.',
        duration: '3:45',
        category: 'Getting Started',
        icon: Icons.rocket_launch,
        color: Colors.blue,
        keyPoints: [
          'Creating your account',
          'Setting up your profile',
          'Understanding the main navigation',
          'Customizing your preferences',
        ],
      ),
      const TutorialVideo(
        id: '2',
        title: 'Health Data Tracking',
        description:
            'Discover how to connect health devices and track your vital signs.',
        duration: '5:20',
        category: 'Health Tracking',
        icon: Icons.health_and_safety,
        color: Colors.green,
        keyPoints: [
          'Connecting health devices',
          'Manual data entry',
          'Understanding health charts',
          'Setting health goals',
        ],
      ),
      const TutorialVideo(
        id: '3',
        title: 'Managing Medications',
        description:
            'Learn how to add medications, set reminders, and track adherence.',
        duration: '4:15',
        category: 'Medications',
        icon: Icons.medication,
        color: Colors.orange,
        keyPoints: [
          'Adding new medications',
          'Setting up reminders',
          'Tracking medication adherence',
          'Managing side effects',
        ],
      ),
      const TutorialVideo(
        id: '4',
        title: 'Creating Care Groups',
        description:
            'Set up care groups to coordinate with family members and caregivers.',
        duration: '6:30',
        category: 'Care Groups',
        icon: Icons.group,
        color: Colors.purple,
        keyPoints: [
          'Creating a new care group',
          'Inviting family members',
          'Setting privacy preferences',
          'Sharing health updates',
        ],
      ),
      const TutorialVideo(
        id: '5',
        title: 'Daily Check-ins',
        description:
            'Complete daily health check-ins and understand your health trends.',
        duration: '3:00',
        category: 'Health Tracking',
        icon: Icons.check_circle,
        color: Colors.teal,
        keyPoints: [
          'Completing daily check-ins',
          'Rating your symptoms',
          'Adding notes and observations',
          'Viewing check-in history',
        ],
      ),
      const TutorialVideo(
        id: '6',
        title: 'Privacy and Settings',
        description:
            'Configure your privacy settings and customize app preferences.',
        duration: '4:45',
        category: 'Settings',
        icon: Icons.settings,
        color: Colors.grey,
        keyPoints: [
          'Managing privacy settings',
          'Configuring notifications',
          'Data sharing preferences',
          'Account security',
        ],
      ),
    ];
  }
}
