import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/design_tokens.dart';
import '../../domain/models/models.dart';
import '../providers/medication_providers.dart';
import '../widgets/medication_card.dart';
import '../widgets/medication_statistics_card.dart';
import 'medication_form_screen.dart';

class MedicationListScreen extends ConsumerStatefulWidget {
  const MedicationListScreen({super.key});

  @override
  ConsumerState<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends ConsumerState<MedicationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(medicationSearchTermProvider.notifier).state = _searchController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Inactive'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddMedication(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatisticsCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMedicationList(null), // All medications
                _buildMedicationList(true), // Active only
                _buildMedicationList(false), // Inactive only
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddMedication(),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: CareCircleDesignTokens.primaryMedicalBlue.withValues(alpha: 0.1),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search medications...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(medicationSearchTermProvider.notifier).state = '';
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: MedicationStatisticsCard(),
    );
  }

  Widget _buildMedicationList(bool? activeFilter) {
    // Set the active filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicationActiveFilterProvider.notifier).state = activeFilter;
    });

    final medicationsAsync = ref.watch(filteredMedicationsProvider);

    return medicationsAsync.when(
      data: (medications) {
        if (medications.isEmpty) {
          return _buildEmptyState(activeFilter);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(medicationNotifierProvider.notifier).refreshMedications();
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final medication = medications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MedicationCard(
                  medication: medication,
                  onTap: () => _navigateToMedicationDetail(medication),
                  onEdit: () => _navigateToEditMedication(medication),
                  onDelete: () => _showDeleteConfirmation(medication),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: CareCircleDesignTokens.primaryMedicalBlue,
        ),
      ),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildEmptyState(bool? activeFilter) {
    String title;
    String subtitle;
    IconData icon;

    if (activeFilter == true) {
      title = 'No Active Medications';
      subtitle = 'You don\'t have any active medications at the moment.';
      icon = Icons.medication_outlined;
    } else if (activeFilter == false) {
      title = 'No Inactive Medications';
      subtitle = 'All your medications are currently active.';
      icon = Icons.medication_outlined;
    } else {
      title = 'No Medications Found';
      subtitle = 'Start by adding your first medication.';
      icon = Icons.medication_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (activeFilter != false)
              ElevatedButton.icon(
                onPressed: () => _navigateToAddMedication(),
                icon: const Icon(Icons.add),
                label: const Text('Add Medication'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading Medications',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(medicationNotifierProvider.notifier).refreshMedications();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMedication() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MedicationFormScreen(),
      ),
    );
  }

  void _navigateToEditMedication(Medication medication) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicationFormScreen(medication: medication),
      ),
    );
  }

  void _navigateToMedicationDetail(Medication medication) {
    // TODO: Navigate to medication detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${medication.name} details...'),
        backgroundColor: CareCircleDesignTokens.primaryMedicalBlue,
      ),
    );
  }

  void _showDeleteConfirmation(Medication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text('Are you sure you want to delete ${medication.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(medicationNotifierProvider.notifier)
                    .deleteMedication(medication.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${medication.name} deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete medication: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
