import 'package:flutter/material.dart';

class TimeRangeSelector extends StatefulWidget {
  final TimeRange selectedRange;
  final Function(TimeRange) onRangeChanged;
  final List<TimeRange> availableRanges;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    this.availableRanges = const [
      TimeRange.day,
      TimeRange.week,
      TimeRange.month,
      TimeRange.threeMonths,
      TimeRange.sixMonths,
      TimeRange.year,
    ],
  });

  @override
  State<TimeRangeSelector> createState() => _TimeRangeSelectorState();
}

enum TimeRange {
  day('Today', 1, Icons.today),
  week('7 Days', 7, Icons.date_range),
  month('30 Days', 30, Icons.calendar_month),
  threeMonths('3 Months', 90, Icons.calendar_view_month),
  sixMonths('6 Months', 180, Icons.calendar_view_week),
  year('1 Year', 365, Icons.calendar_today);

  const TimeRange(this.label, this.days, this.icon);
  final String label;
  final int days;
  final IconData icon;
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current selection header
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    widget.selectedRange.icon,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.selectedRange.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // Expanded options
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            ...widget.availableRanges.map((range) => _buildRangeOption(range)),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeOption(TimeRange range) {
    final theme = Theme.of(context);
    final isSelected = widget.selectedRange == range;

    return InkWell(
      onTap: () {
        widget.onRangeChanged(range);
        setState(() => _isExpanded = false);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              range.icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    range.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Last ${range.days} days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.8)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Extension for quick date calculations
extension TimeRangeExtension on TimeRange {
  DateTime get startDate => DateTime.now().subtract(Duration(days: days));
  DateTime get endDate => DateTime.now();

  DateTimeRange get dateRange => DateTimeRange(start: startDate, end: endDate);
}
