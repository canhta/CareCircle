import 'package:flutter/material.dart';
import '../features/care_group/care_group.dart';
import '../common/common.dart';

class CareGroupScreen extends StatefulWidget {
  const CareGroupScreen({super.key});

  @override
  State<CareGroupScreen> createState() => _CareGroupScreenState();
}

class _CareGroupScreenState extends State<CareGroupScreen> {
  late final CareGroupService _careGroupService;
  late final AppLogger _logger;

  List<CareGroup> _careGroups = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('CareGroupScreen');
    _careGroupService = CareGroupService(
      apiClient: ApiClient.instance,
      logger: _logger,
    );
    _loadCareGroups();
  }

  Future<void> _loadCareGroups() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _careGroupService.getCareGroups();

    result.fold(
      (careGroups) => setState(() {
        _careGroups = careGroups;
        _isLoading = false;
      }),
      (error) => setState(() {
        _error = error.toString();
        _isLoading = false;
      }),
    );
  }

  Future<void> _createCareGroup() async {
    final result = await Navigator.pushNamed(
      context,
      '/create-care-group',
    );

    if (result == true) {
      _loadCareGroups();
    }
  }

  Future<void> _joinCareGroup() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _JoinCareGroupDialog(),
    );

    if (result != null && result.isNotEmpty) {
      // For now, use a placeholder group ID. In a real app, this would be parsed from the invite code
      final joinResult =
          await _careGroupService.joinCareGroup('placeholder-group-id', result);

      joinResult.fold(
        (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined care group!'),
            ),
          );
          _loadCareGroups();
        },
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error joining care group: ${error.toString()}'),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Groups'),
        actions: [
          IconButton(
            onPressed: _loadCareGroups,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateJoinOptions,
        label: const Text('Join/Create Group'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
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
              'Error loading care groups',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCareGroups,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_careGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No care groups yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first care group or join an existing one',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createCareGroup,
              child: const Text('Create Care Group'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _joinCareGroup,
              child: const Text('Join Care Group'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _careGroups.length,
      itemBuilder: (context, index) {
        final careGroup = _careGroups[index];
        return _buildCareGroupCard(careGroup);
      },
    );
  }

  Widget _buildCareGroupCard(CareGroup careGroup) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            careGroup.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          careGroup.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (careGroup.description.isNotEmpty) Text(careGroup.description),
            const SizedBox(height: 4),
            Text(
              '${careGroup.memberCount} members',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/care-group-detail',
            arguments: careGroup.id,
          );
        },
      ),
    );
  }

  void _showCreateJoinOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create Care Group'),
              onTap: () {
                Navigator.pop(context);
                _createCareGroup();
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Join Care Group'),
              onTap: () {
                Navigator.pop(context);
                _joinCareGroup();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _JoinCareGroupDialog extends StatefulWidget {
  @override
  State<_JoinCareGroupDialog> createState() => _JoinCareGroupDialogState();
}

class _JoinCareGroupDialogState extends State<_JoinCareGroupDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Join Care Group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the care group invitation code:'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Invitation code',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final code = _controller.text.trim();
            if (code.isNotEmpty) {
              Navigator.pop(context, code);
            }
          },
          child: const Text('Join'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
