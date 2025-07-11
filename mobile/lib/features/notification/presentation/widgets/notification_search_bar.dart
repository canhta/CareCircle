import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design/design_tokens.dart';
import '../providers/notification_providers.dart';

/// Notification search bar widget
///
/// Provides search functionality for notifications:
/// - Real-time search as user types
/// - Search in title and message content
/// - Clear search button
/// - Search suggestions (future enhancement)
class NotificationSearchBar extends ConsumerStatefulWidget {
  const NotificationSearchBar({super.key});

  @override
  ConsumerState<NotificationSearchBar> createState() =>
      _NotificationSearchBarState();
}

class _NotificationSearchBarState extends ConsumerState<NotificationSearchBar> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchTerm = _searchController.text;
    ref.read(notificationSearchTermProvider.notifier).state = searchTerm;
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchActive = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchTerm = ref.watch(notificationSearchTermProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSearchField(searchTerm),
          if (_isSearchActive && searchTerm.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildSearchSuggestions(searchTerm),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(String searchTerm) {
    return Container(
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchActive
              ? CareCircleDesignTokens.primaryMedicalBlue
              : CareCircleDesignTokens.borderLight,
          width: _isSearchActive ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search notifications...',
          hintStyle: TextStyle(
            color: CareCircleDesignTokens.textSecondary,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _isSearchActive
                ? CareCircleDesignTokens.primaryMedicalBlue
                : CareCircleDesignTokens.textSecondary,
            size: 20,
          ),
          suffixIcon: searchTerm.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: CareCircleDesignTokens.textSecondary,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                  tooltip: 'Clear search',
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          color: CareCircleDesignTokens.textPrimary,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _focusNode.unfocus(),
      ),
    );
  }

  Widget _buildSearchSuggestions(String searchTerm) {
    // For now, show simple search tips
    // In the future, this could show actual search suggestions based on notification content
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
          alpha: 0.05,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
            alpha: 0.2,
          ),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 16,
                color: CareCircleDesignTokens.primaryMedicalBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Search Tips',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSearchTip('Search by medication name, e.g., "aspirin"'),
          _buildSearchTip('Search by type, e.g., "reminder" or "alert"'),
          _buildSearchTip('Search by content, e.g., "appointment" or "dose"'),
        ],
      ),
    );
  }

  Widget _buildSearchTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 4,
            color: CareCircleDesignTokens.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 11,
                color: CareCircleDesignTokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.unfocus();
    ref.read(notificationSearchTermProvider.notifier).state = '';
  }
}

/// Search results summary widget
class SearchResultsSummary extends ConsumerWidget {
  const SearchResultsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = ref.watch(notificationSearchTermProvider);
    final filteredNotifications = ref.watch(filteredNotificationsProvider);

    if (searchTerm.isEmpty) {
      return const SizedBox.shrink();
    }

    return filteredNotifications.when(
      data: (notifications) => _buildSummary(searchTerm, notifications.length),
      loading: () => _buildLoadingSummary(searchTerm),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildSummary(String searchTerm, int resultCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.backgroundSecondary,
        border: Border(
          bottom: BorderSide(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 16,
            color: CareCircleDesignTokens.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: CareCircleDesignTokens.textSecondary,
                ),
                children: [
                  TextSpan(
                    text:
                        '$resultCount result${resultCount != 1 ? 's' : ''} for ',
                  ),
                  TextSpan(
                    text: '"$searchTerm"',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (resultCount == 0)
            Text(
              'No matches found',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: CareCircleDesignTokens.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingSummary(String searchTerm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CareCircleDesignTokens.backgroundSecondary,
        border: Border(
          bottom: BorderSide(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                CareCircleDesignTokens.primaryMedicalBlue,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Searching for "$searchTerm"...',
            style: TextStyle(
              fontSize: 12,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick search filters widget
class QuickSearchFilters extends ConsumerWidget {
  const QuickSearchFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = ref.watch(notificationSearchTermProvider);

    if (searchTerm.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Search',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickSearchChip(ref, 'medication', '💊'),
                const SizedBox(width: 8),
                _buildQuickSearchChip(ref, 'reminder', '⏰'),
                const SizedBox(width: 8),
                _buildQuickSearchChip(ref, 'alert', '🚨'),
                const SizedBox(width: 8),
                _buildQuickSearchChip(ref, 'appointment', '📅'),
                const SizedBox(width: 8),
                _buildQuickSearchChip(ref, 'today', '📆'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchChip(WidgetRef ref, String term, String icon) {
    return GestureDetector(
      onTap: () {
        ref.read(notificationSearchTermProvider.notifier).state = term;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: CareCircleDesignTokens.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CareCircleDesignTokens.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              term,
              style: TextStyle(
                fontSize: 12,
                color: CareCircleDesignTokens.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
