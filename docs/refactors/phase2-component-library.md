# Phase 2: Component Library & Patterns Implementation

**Duration**: Weeks 3-4  
**Objective**: Build comprehensive healthcare-specific component library  
**Dependencies**: [Phase 1 - Foundation & Design System](./phase1-foundation-design-system.md)  
**Next Phase**: [Phase 3 - Screen Refactoring](./phase3-screen-refactoring.md)

## Overview

Phase 2 builds upon the design system foundation established in Phase 1 to create a comprehensive library of healthcare-specific components that will be used throughout the application. This phase focuses on creating reusable, accessible, and healthcare-compliant UI components.

## Week 3: Healthcare-Specific Components

### Sub-Phase 2A: Healthcare Component Directory Structure (Day 1)

#### Create Healthcare Component Architecture
```
mobile/lib/core/widgets/
├── healthcare/
│   ├── vital_signs_card.dart
│   ├── health_metric_chart.dart
│   ├── medication_reminder_card.dart
│   ├── emergency_action_button.dart
│   ├── medical_data_table.dart
│   └── healthcare.dart (barrel file)
├── forms/
│   ├── healthcare_form_field.dart
│   ├── medical_date_picker.dart
│   ├── dosage_input_field.dart
│   ├── symptom_severity_slider.dart
│   └── forms.dart (barrel file)
└── accessibility/
    ├── screen_reader_optimized_card.dart
    ├── high_contrast_button.dart
    ├── voice_navigation_helper.dart
    └── accessibility.dart (barrel file)
```

### Sub-Phase 2B: Vital Signs Components (Days 1-2)

#### VitalSignsCard Implementation
**New File**: `mobile/lib/core/widgets/healthcare/vital_signs_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

enum VitalSignType {
  heartRate,
  bloodPressure,
  temperature,
  oxygenSaturation,
  respiratoryRate,
  bloodGlucose,
}

class VitalSignsCard extends StatelessWidget {
  const VitalSignsCard({
    super.key,
    required this.type,
    required this.currentValue,
    required this.unit,
    this.normalRangeMin,
    this.normalRangeMax,
    this.historicalData = const [],
    this.lastUpdated,
    this.onTap,
    this.showTrend = true,
    this.isAbnormal = false,
    this.medicalNote,
    this.recordedBy,
    this.semanticLabel,
    this.semanticValue,
    this.semanticHint,
    this.announceChanges = false,
  });

  final VitalSignType type;
  final double currentValue;
  final String unit;
  final double? normalRangeMin;
  final double? normalRangeMax;
  final List<VitalSignReading> historicalData;
  final DateTime? lastUpdated;
  final VoidCallback? onTap;
  
  // Healthcare-specific properties
  final bool showTrend;
  final bool isAbnormal;
  final String? medicalNote;
  final String? recordedBy;
  
  // Accessibility properties
  final String? semanticLabel;
  final String? semanticValue;
  final String? semanticHint;
  final bool announceChanges;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? _getDefaultSemanticLabel(),
      value: semanticValue ?? _getDefaultSemanticValue(),
      hint: semanticHint ?? _getDefaultSemanticHint(),
      button: onTap != null,
      liveRegion: announceChanges,
      child: Card(
        elevation: isAbnormal ? 4 : 2,
        color: _getCardColor(),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
          child: Padding(
            padding: EdgeInsets.all(CareCircleSpacingTokens.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: CareCircleSpacingTokens.sm),
                _buildValueDisplay(),
                if (showTrend && historicalData.isNotEmpty) ...[
                  SizedBox(height: CareCircleSpacingTokens.sm),
                  _buildTrendIndicator(),
                ],
                if (normalRangeMin != null && normalRangeMax != null) ...[
                  SizedBox(height: CareCircleSpacingTokens.xs),
                  _buildNormalRange(),
                ],
                if (lastUpdated != null) ...[
                  SizedBox(height: CareCircleSpacingTokens.xs),
                  _buildLastUpdated(),
                ],
                if (medicalNote != null) ...[
                  SizedBox(height: CareCircleSpacingTokens.sm),
                  _buildMedicalNote(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          _getVitalSignIcon(),
          color: _getVitalSignColor(),
          size: 24,
        ),
        SizedBox(width: CareCircleSpacingTokens.sm),
        Expanded(
          child: Text(
            _getVitalSignName(),
            style: CareCircleTypographyTokens.healthMetricTitle,
          ),
        ),
        if (isAbnormal)
          Icon(
            Icons.warning,
            color: CareCircleColorTokens.dangerRange,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildValueDisplay() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          currentValue.toStringAsFixed(_getDecimalPlaces()),
          style: CareCircleTypographyTokens.vitalSignsLarge.copyWith(
            color: _getValueColor(),
          ),
        ),
        SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          unit,
          style: CareCircleTypographyTokens.medicalLabel.copyWith(
            color: _getValueColor(),
          ),
        ),
      ],
    );
  }

  // Helper methods for vital sign specific logic
  IconData _getVitalSignIcon() {
    switch (type) {
      case VitalSignType.heartRate:
        return Icons.favorite;
      case VitalSignType.bloodPressure:
        return Icons.monitor_heart;
      case VitalSignType.temperature:
        return Icons.thermostat;
      case VitalSignType.oxygenSaturation:
        return Icons.air;
      case VitalSignType.respiratoryRate:
        return Icons.lungs;
      case VitalSignType.bloodGlucose:
        return Icons.water_drop;
    }
  }

  Color _getVitalSignColor() {
    switch (type) {
      case VitalSignType.heartRate:
        return CareCircleColorTokens.heartRateRed;
      case VitalSignType.bloodPressure:
        return CareCircleColorTokens.bloodPressureBlue;
      case VitalSignType.temperature:
        return CareCircleColorTokens.temperatureOrange;
      case VitalSignType.oxygenSaturation:
        return CareCircleColorTokens.oxygenSaturationCyan;
      default:
        return CareCircleColorTokens.primaryMedicalBlue;
    }
  }

  // Additional helper methods...
}

class VitalSignReading {
  final double value;
  final DateTime timestamp;
  final String? note;

  const VitalSignReading({
    required this.value,
    required this.timestamp,
    this.note,
  });
}
```

**Estimated Effort**: 8 hours  
**Testing**: Medical data accuracy, accessibility compliance

### Sub-Phase 2C: Health Metric Chart Component (Days 2-3)

#### HealthMetricChart Implementation
**New File**: `mobile/lib/core/widgets/healthcare/health_metric_chart.dart`

```dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../design/design_tokens.dart';

class HealthMetricChart extends StatelessWidget {
  const HealthMetricChart({
    super.key,
    required this.data,
    required this.metricType,
    this.timeRange = const Duration(days: 7),
    this.showNormalRange = true,
    this.isInteractive = true,
    this.onDataPointTap,
    required this.chartDescription,
    this.dataPointDescriptions = const [],
    this.height = 200,
  });

  final List<HealthMetricData> data;
  final HealthMetricType metricType;
  final Duration timeRange;
  final bool showNormalRange;
  final bool isInteractive;
  final Function(HealthMetricData)? onDataPointTap;
  final double height;
  
  // Accessibility properties
  final String chartDescription;
  final List<String> dataPointDescriptions;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Health metric chart for ${metricType.displayName}',
      hint: chartDescription,
      child: Container(
        height: height,
        padding: EdgeInsets.all(CareCircleSpacingTokens.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(),
            SizedBox(height: CareCircleSpacingTokens.sm),
            Expanded(
              child: _buildChart(),
            ),
            if (isInteractive) ...[
              SizedBox(height: CareCircleSpacingTokens.sm),
              _buildChartLegend(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getHorizontalInterval(),
          verticalInterval: _getVerticalInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: CareCircleColorTokens.normalRange.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: CareCircleColorTokens.normalRange.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: CareCircleColorTokens.normalRange.withOpacity(0.3),
            width: 1,
          ),
        ),
        minX: _getMinX(),
        maxX: _getMaxX(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          _buildMainDataLine(),
          if (showNormalRange) ..._buildNormalRangeLines(),
        ],
        lineTouchData: isInteractive ? _buildTouchData() : LineTouchData(enabled: false),
      ),
    );
  }

  LineChartBarData _buildMainDataLine() {
    return LineChartBarData(
      spots: data.map((point) => FlSpot(
        point.timestamp.millisecondsSinceEpoch.toDouble(),
        point.value,
      )).toList(),
      isCurved: true,
      color: _getMetricColor(),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: _getMetricColor(),
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: _getMetricColor().withOpacity(0.1),
      ),
    );
  }

  // Additional chart building methods...
}

enum HealthMetricType {
  heartRate,
  bloodPressure,
  weight,
  steps,
  sleep,
  bloodGlucose,
}

extension HealthMetricTypeExtension on HealthMetricType {
  String get displayName {
    switch (this) {
      case HealthMetricType.heartRate:
        return 'Heart Rate';
      case HealthMetricType.bloodPressure:
        return 'Blood Pressure';
      case HealthMetricType.weight:
        return 'Weight';
      case HealthMetricType.steps:
        return 'Steps';
      case HealthMetricType.sleep:
        return 'Sleep';
      case HealthMetricType.bloodGlucose:
        return 'Blood Glucose';
    }
  }
}

class HealthMetricData {
  final double value;
  final DateTime timestamp;
  final String? note;
  final bool isAbnormal;

  const HealthMetricData({
    required this.value,
    required this.timestamp,
    this.note,
    this.isAbnormal = false,
  });
}
```

**Estimated Effort**: 10 hours  
**Dependencies**: fl_chart package (add to pubspec.yaml)  
**Testing**: Chart rendering, accessibility, touch interactions

## Week 4: Form Components & Data Visualization

### Sub-Phase 2D: Healthcare Form Components (Days 1-2)

#### Healthcare Form Field Implementation
**New File**: `mobile/lib/core/widgets/forms/healthcare_form_field.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design/design_tokens.dart';

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
          if (hint != null) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            _buildHint(),
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: CareCircleSpacingTokens.md,
          vertical: CareCircleSpacingTokens.md,
        ),
        prefixIcon: _getPrefixIcon(),
        suffixIcon: _getSuffixIcon(),
      ),
    );
  }

  // Helper methods for healthcare-specific logic
  String _getDefaultSemanticLabel() {
    return '$label${isRequired ? ', required' : ''}${medicalUnit != null ? ', in $medicalUnit' : ''}';
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
      default:
        return 'Enter ${label.toLowerCase()}';
    }
  }

  // Additional helper methods...
}
```

**Estimated Effort**: 6 hours  
**Testing**: Form validation, accessibility, HIPAA compliance

## Success Criteria

### Phase 2 Completion Checklist
- [ ] Healthcare component directory structure created
- [ ] VitalSignsCard component implemented with accessibility
- [ ] HealthMetricChart component with interactive features
- [ ] Healthcare form components with medical validation
- [ ] All components follow design token system
- [ ] Comprehensive testing completed
- [ ] Documentation updated

### Performance Targets
- [ ] Component rendering <100ms
- [ ] Chart animations maintain 60fps
- [ ] Form validation responsive <16ms
- [ ] Memory usage optimized for medical data

### Healthcare Compliance
- [ ] HIPAA-compliant input handling
- [ ] Medical data validation rules
- [ ] Emergency access patterns
- [ ] Audit trail capabilities

## Next Steps

Upon Phase 2 completion:
1. **Component Testing**: Validate all healthcare components
2. **Integration Testing**: Test components with existing screens
3. **Accessibility Validation**: Comprehensive accessibility testing
4. **Proceed to Phase 3**: Begin screen-level refactoring

---

**Phase Status**: Ready to Begin  
**Estimated Duration**: 2 weeks  
**Team Size**: 3-4 developers  
**Next Phase**: [Phase 3 - Screen Refactoring](./phase3-screen-refactoring.md)
