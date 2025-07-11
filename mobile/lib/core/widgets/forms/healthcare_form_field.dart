import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design/design_tokens.dart';

/// Enum for different healthcare data types
enum HealthcareDataType {
  general,
  medication,
  dosage,
  vitalSign,
  medicalId,
  emergencyContact,
  allergies,
  symptoms,
}

/// Healthcare-optimized form field component
/// 
/// Provides HIPAA-compliant input handling with medical data validation,
/// accessibility features, and healthcare-specific styling.
class HealthcareFormField extends StatelessWidget {
  const HealthcareFormField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.isRequired = false,
    this.isSensitive = false,
    this.dataType = HealthcareDataType.general,
    this.medicalUnit,
    this.semanticLabel,
    this.semanticHint,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool isSensitive; // HIPAA compliance
  final HealthcareDataType dataType;
  final String? medicalUnit;
  
  // Accessibility properties
  final String? semanticLabel;
  final String? semanticHint;
  
  // Form properties
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? _getDefaultSemanticLabel(),
      hint: semanticHint ?? _getDefaultSemanticHint(),
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
          SizedBox(height: CareCircleSpacingTokens.xs),
          _buildTextField(),
          if (helperText != null) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            _buildHelperText(),
          ],
          if (errorText != null) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            _buildErrorText(),
          ],
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        style: CareCircleTypographyTokens.medicalLabel.copyWith(
          color: _getLabelColor(),
        ),
        children: [
          TextSpan(text: label),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: CareCircleColorTokens.criticalAlert,
              ),
            ),
          if (medicalUnit != null)
            TextSpan(
              text: ' ($medicalUnit)',
              style: TextStyle(
                color: CareCircleColorTokens.normalRange,
                fontWeight: FontWeight.normal,
              ),
            ),
          if (isSensitive)
            TextSpan(
              text: ' 🔒',
              style: TextStyle(
                color: CareCircleColorTokens.primaryMedicalBlue,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: controller,
      validator: validator ?? _getDefaultValidator(),
      onChanged: onChanged,
      inputFormatters: inputFormatters ?? _getDefaultInputFormatters(),
      keyboardType: keyboardType ?? _getDefaultKeyboardType(),
      maxLines: maxLines,
      enabled: enabled,
      obscureText: isSensitive,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.primaryMedicalBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.criticalAlert,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          borderSide: BorderSide(
            color: CareCircleColorTokens.criticalAlert,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: CareCircleSpacingTokens.md,
          vertical: CareCircleSpacingTokens.md,
        ),
        prefixIcon: prefixIcon ?? _getPrefixIcon(),
        suffixIcon: suffixIcon ?? _getSuffixIcon(),
        filled: !enabled,
        fillColor: enabled ? null : CareCircleColorTokens.lightColorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildHelperText() {
    return Text(
      helperText!,
      style: CareCircleTypographyTokens.medicalNote.copyWith(
        color: CareCircleColorTokens.lightColorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildErrorText() {
    return Text(
      errorText!,
      style: CareCircleTypographyTokens.medicalNote.copyWith(
        color: CareCircleColorTokens.criticalAlert,
      ),
    );
  }

  // Helper methods for healthcare-specific logic
  String _getDefaultSemanticLabel() {
    String baseLabel = label;
    if (isRequired) baseLabel += ', required';
    if (medicalUnit != null) baseLabel += ', in $medicalUnit';
    if (isSensitive) baseLabel += ', sensitive information';
    return baseLabel;
  }

  String _getDefaultSemanticHint() {
    switch (dataType) {
      case HealthcareDataType.medication:
        return 'Enter medication name or dosage information';
      case HealthcareDataType.vitalSign:
        return 'Enter vital sign measurement';
      case HealthcareDataType.emergencyContact:
        return 'Enter emergency contact information';
      case HealthcareDataType.allergies:
        return 'Enter allergy information';
      case HealthcareDataType.symptoms:
        return 'Describe symptoms or medical concerns';
      case HealthcareDataType.medicalId:
        return 'Enter medical identification number';
      case HealthcareDataType.dosage:
        return 'Enter medication dosage amount';
      default:
        return 'Enter ${label.toLowerCase()}';
    }
  }

  Color _getLabelColor() {
    if (!enabled) {
      return CareCircleColorTokens.lightColorScheme.onSurfaceVariant;
    }
    return CareCircleColorTokens.lightColorScheme.onSurface;
  }

  Color _getBorderColor() {
    if (!enabled) {
      return CareCircleColorTokens.lightColorScheme.outline.withValues(alpha: 0.5);
    }
    return CareCircleColorTokens.lightColorScheme.outline;
  }

  Widget? _getPrefixIcon() {
    switch (dataType) {
      case HealthcareDataType.medication:
        return Icon(Icons.medication, color: CareCircleColorTokens.prescriptionBlue);
      case HealthcareDataType.vitalSign:
        return Icon(Icons.monitor_heart, color: CareCircleColorTokens.heartRateRed);
      case HealthcareDataType.emergencyContact:
        return Icon(Icons.emergency, color: CareCircleColorTokens.emergencyRed);
      case HealthcareDataType.allergies:
        return Icon(Icons.warning, color: CareCircleColorTokens.warningAmber);
      case HealthcareDataType.symptoms:
        return Icon(Icons.health_and_safety, color: CareCircleColorTokens.healthGreen);
      case HealthcareDataType.medicalId:
        return Icon(Icons.badge, color: CareCircleColorTokens.primaryMedicalBlue);
      default:
        return null;
    }
  }

  Widget? _getSuffixIcon() {
    if (isSensitive) {
      return Icon(
        Icons.security,
        color: CareCircleColorTokens.primaryMedicalBlue,
        size: 20,
      );
    }
    return null;
  }

  String? Function(String?)? _getDefaultValidator() {
    return (value) {
      if (isRequired && (value == null || value.isEmpty)) {
        return '$label is required';
      }
      
      switch (dataType) {
        case HealthcareDataType.dosage:
          if (value != null && value.isNotEmpty) {
            final dosage = double.tryParse(value);
            if (dosage == null) {
              return 'Please enter a valid dosage amount';
            }
            if (dosage <= 0) {
              return 'Dosage must be greater than 0';
            }
          }
          break;
        case HealthcareDataType.vitalSign:
          if (value != null && value.isNotEmpty) {
            final vital = double.tryParse(value);
            if (vital == null) {
              return 'Please enter a valid measurement';
            }
          }
          break;
        case HealthcareDataType.emergencyContact:
          if (value != null && value.isNotEmpty && value.length < 10) {
            return 'Please enter a complete contact number';
          }
          break;
        default:
          break;
      }
      
      return null;
    };
  }

  List<TextInputFormatter> _getDefaultInputFormatters() {
    switch (dataType) {
      case HealthcareDataType.dosage:
      case HealthcareDataType.vitalSign:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ];
      case HealthcareDataType.emergencyContact:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case HealthcareDataType.medicalId:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          LengthLimitingTextInputFormatter(20),
        ];
      default:
        return [];
    }
  }

  TextInputType _getDefaultKeyboardType() {
    switch (dataType) {
      case HealthcareDataType.dosage:
      case HealthcareDataType.vitalSign:
        return const TextInputType.numberWithOptions(decimal: true);
      case HealthcareDataType.emergencyContact:
        return TextInputType.phone;
      case HealthcareDataType.medicalId:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }
}
