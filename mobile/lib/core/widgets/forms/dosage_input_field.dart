// Dosage input field with healthcare-specific validation and units
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/design_tokens.dart';

/// Dosage input field with healthcare-specific validation
///
/// Features:
/// - Numeric input with decimal support
/// - Healthcare-compliant dosage units
/// - Accessibility support with 44px minimum touch targets
/// - Professional healthcare appearance
/// - Input validation for safe dosage ranges
class DosageInputField extends StatefulWidget {
  final String label;
  final double? initialValue;
  final ValueChanged<double?> onChanged;
  final String? errorText;
  final bool isRequired;
  final String? helpText;
  final DosageUnit unit;
  final double? minValue;
  final double? maxValue;
  final int decimalPlaces;
  final bool showUnitSelector;
  final List<DosageUnit>? availableUnits;
  final ValueChanged<DosageUnit>? onUnitChanged;

  const DosageInputField({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.errorText,
    this.isRequired = false,
    this.helpText,
    this.unit = DosageUnit.mg,
    this.minValue,
    this.maxValue,
    this.decimalPlaces = 2,
    this.showUnitSelector = false,
    this.availableUnits,
    this.onUnitChanged,
  });

  @override
  State<DosageInputField> createState() => _DosageInputFieldState();
}

class _DosageInputFieldState extends State<DosageInputField> {
  late TextEditingController _controller;
  late DosageUnit _selectedUnit;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
    _selectedUnit = widget.unit;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() => _validationError = null);
      widget.onChanged(null);
      return;
    }

    final value = double.tryParse(text);
    if (value == null) {
      setState(() => _validationError = 'Please enter a valid number');
      widget.onChanged(null);
      return;
    }

    // Validate range
    if (widget.minValue != null && value < widget.minValue!) {
      setState(() => _validationError = 'Minimum value is ${widget.minValue}');
      widget.onChanged(null);
      return;
    }

    if (widget.maxValue != null && value > widget.maxValue!) {
      setState(() => _validationError = 'Maximum value is ${widget.maxValue}');
      widget.onChanged(null);
      return;
    }

    setState(() => _validationError = null);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null || _validationError != null;
    final errorText = widget.errorText ?? _validationError;

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

        // Input field with unit selector
        Row(
          children: [
            // Dosage input
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 56, // Healthcare minimum touch target
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: widget.decimalPlaces > 0,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                        r'^\d*\.?\d{0,' +
                            widget.decimalPlaces.toString() +
                            r'}',
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter ${widget.label.toLowerCase()}',
                    prefixIcon: Icon(
                      Icons.medication,
                      color: CareCircleDesignTokens.primaryMedicalBlue,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: CareCircleDesignTokens.primaryMedicalBlue,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: CareCircleDesignTokens.criticalAlert,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: CareCircleDesignTokens.criticalAlert,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),

            // Unit selector
            if (widget.showUnitSelector && widget.availableUnits != null) ...[
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? CareCircleDesignTokens.criticalAlert
                          : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DosageUnit>(
                      value: _selectedUnit,
                      isExpanded: true,
                      items: widget.availableUnits!.map((unit) {
                        return DropdownMenuItem<DosageUnit>(
                          value: unit,
                          child: Text(
                            unit.displayName,
                            style: theme.textTheme.bodyLarge,
                          ),
                        );
                      }).toList(),
                      onChanged: (unit) {
                        if (unit != null) {
                          setState(() => _selectedUnit = unit);
                          widget.onUnitChanged?.call(unit);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(width: 12),
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100]!,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Text(
                    _selectedUnit.displayName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
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
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: CareCircleDesignTokens.criticalAlert,
            ),
          ),
        ],
      ],
    );
  }
}

/// Dosage units for medication
enum DosageUnit {
  mg,
  g,
  mcg,
  ml,
  l,
  units,
  iu,
  drops,
  tablets,
  capsules,
  patches,
  sprays,
}

extension DosageUnitExtension on DosageUnit {
  String get displayName {
    switch (this) {
      case DosageUnit.mg:
        return 'mg';
      case DosageUnit.g:
        return 'g';
      case DosageUnit.mcg:
        return 'mcg';
      case DosageUnit.ml:
        return 'ml';
      case DosageUnit.l:
        return 'L';
      case DosageUnit.units:
        return 'units';
      case DosageUnit.iu:
        return 'IU';
      case DosageUnit.drops:
        return 'drops';
      case DosageUnit.tablets:
        return 'tablets';
      case DosageUnit.capsules:
        return 'capsules';
      case DosageUnit.patches:
        return 'patches';
      case DosageUnit.sprays:
        return 'sprays';
    }
  }

  String get fullName {
    switch (this) {
      case DosageUnit.mg:
        return 'Milligrams';
      case DosageUnit.g:
        return 'Grams';
      case DosageUnit.mcg:
        return 'Micrograms';
      case DosageUnit.ml:
        return 'Milliliters';
      case DosageUnit.l:
        return 'Liters';
      case DosageUnit.units:
        return 'Units';
      case DosageUnit.iu:
        return 'International Units';
      case DosageUnit.drops:
        return 'Drops';
      case DosageUnit.tablets:
        return 'Tablets';
      case DosageUnit.capsules:
        return 'Capsules';
      case DosageUnit.patches:
        return 'Patches';
      case DosageUnit.sprays:
        return 'Sprays';
    }
  }
}
