// Medical date picker with healthcare-specific validation and accessibility
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../design/design_tokens.dart';

/// Medical date picker with healthcare-specific validation
/// 
/// Features:
/// - Healthcare-compliant date validation
/// - Accessibility support with 44px minimum touch targets
/// - Medical context-specific date ranges
/// - Professional healthcare appearance
class MedicalDatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onDateSelected;
  final String? errorText;
  final bool isRequired;
  final String? helpText;
  final IconData? prefixIcon;
  final MedicalDateType dateType;

  const MedicalDatePicker({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.errorText,
    this.isRequired = false,
    this.helpText,
    this.prefixIcon,
    this.dateType = MedicalDateType.general,
  });

  @override
  State<MedicalDatePicker> createState() => _MedicalDatePickerState();
}

class _MedicalDatePickerState extends State<MedicalDatePicker> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: CareCircleDesignTokens.primaryMedicalBlue,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: CareCircleDesignTokens.criticalAlert,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Date picker field
        InkWell(
          onTap: _showDatePicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 56, // Healthcare minimum touch target
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.errorText != null
                    ? CareCircleDesignTokens.criticalAlert
                    : Colors.grey[300]!,
                width: widget.errorText != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: CareCircleDesignTokens.primaryMedicalBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _dateFormat.format(_selectedDate!)
                        : 'Select ${widget.label.toLowerCase()}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _selectedDate != null
                          ? Colors.black87
                          : Colors.grey[500]!,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: CareCircleDesignTokens.primaryMedicalBlue,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Help text
        if (widget.helpText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helpText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600]!,
            ),
          ),
        ],

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: CareCircleDesignTokens.criticalAlert,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showDatePicker() async {
    final firstDate = widget.firstDate ?? _getDefaultFirstDate();
    final lastDate = widget.lastDate ?? _getDefaultLastDate();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? _getDefaultInitialDate(),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select ${widget.label}',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CareCircleDesignTokens.primaryMedicalBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      widget.onDateSelected(selectedDate);
    }
  }

  DateTime _getDefaultFirstDate() {
    final now = DateTime.now();
    switch (widget.dateType) {
      case MedicalDateType.birthDate:
        return DateTime(now.year - 120, 1, 1); // 120 years ago
      case MedicalDateType.diagnosisDate:
        return DateTime(now.year - 50, 1, 1); // 50 years ago
      case MedicalDateType.treatmentDate:
        return DateTime(now.year - 10, 1, 1); // 10 years ago
      case MedicalDateType.appointmentDate:
        return now; // Today onwards
      case MedicalDateType.medicationStart:
        return DateTime(now.year - 5, 1, 1); // 5 years ago
      case MedicalDateType.general:
        return DateTime(now.year - 10, 1, 1); // 10 years ago
    }
  }

  DateTime _getDefaultLastDate() {
    final now = DateTime.now();
    switch (widget.dateType) {
      case MedicalDateType.birthDate:
        return now; // Today
      case MedicalDateType.diagnosisDate:
        return now; // Today
      case MedicalDateType.treatmentDate:
        return DateTime(now.year + 1, 12, 31); // Next year
      case MedicalDateType.appointmentDate:
        return DateTime(now.year + 2, 12, 31); // 2 years ahead
      case MedicalDateType.medicationStart:
        return DateTime(now.year + 1, 12, 31); // Next year
      case MedicalDateType.general:
        return DateTime(now.year + 1, 12, 31); // Next year
    }
  }

  DateTime _getDefaultInitialDate() {
    final now = DateTime.now();
    final firstDate = widget.firstDate ?? _getDefaultFirstDate();
    final lastDate = widget.lastDate ?? _getDefaultLastDate();

    // Ensure initial date is within bounds
    if (now.isBefore(firstDate)) {
      return firstDate;
    } else if (now.isAfter(lastDate)) {
      return lastDate;
    } else {
      return now;
    }
  }
}

/// Medical date types for context-specific validation
enum MedicalDateType {
  general,
  birthDate,
  diagnosisDate,
  treatmentDate,
  appointmentDate,
  medicationStart,
}

extension MedicalDateTypeExtension on MedicalDateType {
  String get displayName {
    switch (this) {
      case MedicalDateType.general:
        return 'Date';
      case MedicalDateType.birthDate:
        return 'Birth Date';
      case MedicalDateType.diagnosisDate:
        return 'Diagnosis Date';
      case MedicalDateType.treatmentDate:
        return 'Treatment Date';
      case MedicalDateType.appointmentDate:
        return 'Appointment Date';
      case MedicalDateType.medicationStart:
        return 'Medication Start Date';
    }
  }
}
