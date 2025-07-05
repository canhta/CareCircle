import 'package:flutter/material.dart';
import '../config/service_locator.dart';
import '../common/logging/app_logger.dart';

class ReminderManagementScreen extends StatefulWidget {
  const ReminderManagementScreen({super.key});

  @override
  State<ReminderManagementScreen> createState() => _ReminderManagementScreenState();
}

class _ReminderManagementScreenState extends State<ReminderManagementScreen> {
  String _selectedCategory = 'All';
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Medications',
    'Check-ins',
    'Appointments',
    'Exercise',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reminders'),
        backgroundColor: Colors.blue.shade50,
        foregroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryFilter(),
          Expanded(
            child: _buildRemindersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.manage_history,
                  color: Colors.blue.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Reminder Management',
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
              'View, edit, and manage all your reminders in one place. '
              'Toggle reminders on/off or modify their settings.',
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
          final isSelected = category == _selectedCategory;
          
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildRemindersList() {
    final filteredReminders = _getFilteredReminders();
    
    if (filteredReminders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredReminders.length,
      itemBuilder: (context, index) {
        final reminder = filteredReminders[index];
        return _buildReminderCard(reminder);
      },
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (reminder['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            reminder['icon'] as IconData,
            color: reminder['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          reminder['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder['subtitle'] as String),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  reminder['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.repeat,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  reminder['frequency'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: reminder['enabled'] as bool,
              onChanged: (value) => _toggleReminder(reminder, value),
            ),
            PopupMenuButton<String>(
              onSelected: (action) => _handleReminderAction(reminder, action),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 8),
                      Text('Duplicate'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showReminderDetails(reminder),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No reminders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory == 'All' 
                ? 'You haven\'t set up any reminders yet'
                : 'No ${_selectedCategory.toLowerCase()} reminders found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddReminderDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Reminder'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredReminders() {
    // Sample reminder data - in a real app, this would come from a service
    final allReminders = [
      {
        'id': '1',
        'title': 'Morning Medication',
        'subtitle': 'Take 2 tablets with breakfast',
        'time': '8:00 AM',
        'frequency': 'Daily',
        'category': 'Medications',
        'icon': Icons.medication,
        'color': Colors.blue,
        'enabled': true,
      },
      {
        'id': '2',
        'title': 'Daily Check-in',
        'subtitle': 'Record your health status',
        'time': '7:00 PM',
        'frequency': 'Daily',
        'category': 'Check-ins',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'enabled': true,
      },
      {
        'id': '3',
        'title': 'Doctor Appointment',
        'subtitle': 'Cardiology consultation',
        'time': '2:00 PM',
        'frequency': 'One-time',
        'category': 'Appointments',
        'icon': Icons.calendar_today,
        'color': Colors.orange,
        'enabled': true,
      },
      {
        'id': '4',
        'title': 'Evening Walk',
        'subtitle': '30 minutes of light exercise',
        'time': '6:00 PM',
        'frequency': 'Weekdays',
        'category': 'Exercise',
        'icon': Icons.directions_walk,
        'color': Colors.purple,
        'enabled': false,
      },
    ];

    if (_selectedCategory == 'All') {
      return allReminders;
    }

    return allReminders
        .where((reminder) => reminder['category'] == _selectedCategory)
        .toList();
  }

  void _toggleReminder(Map<String, dynamic> reminder, bool enabled) {
    setState(() {
      reminder['enabled'] = enabled;
    });

    final logger = ServiceLocator.get<AppLogger>();
    logger.info('Reminder toggled', data: {
      'reminderId': reminder['id'],
      'title': reminder['title'],
      'enabled': enabled,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled 
              ? '${reminder['title']} reminder enabled'
              : '${reminder['title']} reminder disabled',
        ),
        backgroundColor: enabled ? Colors.green : Colors.orange,
      ),
    );
  }

  void _handleReminderAction(Map<String, dynamic> reminder, String action) {
    switch (action) {
      case 'edit':
        _editReminder(reminder);
        break;
      case 'duplicate':
        _duplicateReminder(reminder);
        break;
      case 'delete':
        _deleteReminder(reminder);
        break;
    }
  }

  void _editReminder(Map<String, dynamic> reminder) {
    // Navigate to appropriate edit screen based on category
    final category = reminder['category'] as String;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit $category reminder - Feature coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _duplicateReminder(Map<String, dynamic> reminder) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${reminder['title']} duplicated'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteReminder(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: Text('Are you sure you want to delete "${reminder['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${reminder['title']} deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReminderDetails(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder['subtitle'] as String),
            const SizedBox(height: 8),
            Text('Time: ${reminder['time']}'),
            const SizedBox(height: 4),
            Text('Frequency: ${reminder['frequency']}'),
            const SizedBox(height: 4),
            Text('Category: ${reminder['category']}'),
            const SizedBox(height: 4),
            Text('Status: ${reminder['enabled'] ? 'Active' : 'Inactive'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editReminder(reminder);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Reminder'),
        content: const Text(
          'Choose the type of reminder you want to create:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/medications');
            },
            child: const Text('Medication'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to check-in reminder setup
            },
            child: const Text('Check-in'),
          ),
        ],
      ),
    );
  }
}
