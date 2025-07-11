import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

/// Enum for different vital sign types
enum VitalSignType {
  heartRate,
  bloodPressure,
  temperature,
  oxygenSaturation,
  respiratoryRate,
  bloodGlucose,
}

/// Data model for vital sign readings
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

/// Healthcare-optimized vital signs card component
///
/// Displays vital sign data with accessibility compliance and medical context awareness.
/// Supports trend indicators, normal ranges, and emergency state highlighting.
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
        Icon(_getVitalSignIcon(), color: _getVitalSignColor(), size: 24),
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

  Widget _buildTrendIndicator() {
    if (historicalData.length < 2) return const SizedBox.shrink();

    final trend = _calculateTrend();
    IconData trendIcon;
    Color trendColor;

    if (trend > 0.05) {
      trendIcon = Icons.trending_up;
      trendColor = CareCircleColorTokens.dangerRange;
    } else if (trend < -0.05) {
      trendIcon = Icons.trending_down;
      trendColor = CareCircleColorTokens.normalRange;
    } else {
      trendIcon = Icons.trending_flat;
      trendColor = CareCircleColorTokens.unknownData;
    }

    return Row(
      children: [
        Icon(trendIcon, size: 16, color: trendColor),
        SizedBox(width: CareCircleSpacingTokens.xs),
        Text(
          'Trend: ${trend > 0 ? '+' : ''}${(trend * 100).toStringAsFixed(1)}%',
          style: CareCircleTypographyTokens.medicalNote.copyWith(
            color: trendColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalRange() {
    return Text(
      'Normal: $normalRangeMin - $normalRangeMax $unit',
      style: CareCircleTypographyTokens.medicalNote.copyWith(
        color: CareCircleColorTokens.normalRange,
      ),
    );
  }

  Widget _buildLastUpdated() {
    final timeAgo = _formatTimeAgo(lastUpdated!);
    return Text(
      'Updated $timeAgo',
      style: CareCircleTypographyTokens.medicalTimestamp,
    );
  }

  Widget _buildMedicalNote() {
    return Container(
      padding: EdgeInsets.all(CareCircleSpacingTokens.sm),
      decoration: BoxDecoration(
        color: CareCircleColorTokens.lightColorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medical Note:', style: CareCircleTypographyTokens.medicalLabel),
          SizedBox(height: CareCircleSpacingTokens.xs),
          Text(medicalNote!, style: CareCircleTypographyTokens.medicalNote),
          if (recordedBy != null) ...[
            SizedBox(height: CareCircleSpacingTokens.xs),
            Text(
              'Recorded by: $recordedBy',
              style: CareCircleTypographyTokens.medicalTimestamp,
            ),
          ],
        ],
      ),
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
        return Icons.air;
      case VitalSignType.bloodGlucose:
        return Icons.water_drop;
    }
  }

  Color _getVitalSignColor() {
    return CareCircleColorTokens.getVitalSignColor(_getVitalSignType());
  }

  String _getVitalSignType() {
    switch (type) {
      case VitalSignType.heartRate:
        return 'heart_rate';
      case VitalSignType.bloodPressure:
        return 'blood_pressure';
      case VitalSignType.temperature:
        return 'temperature';
      case VitalSignType.oxygenSaturation:
        return 'oxygen_saturation';
      case VitalSignType.respiratoryRate:
        return 'respiratory_rate';
      case VitalSignType.bloodGlucose:
        return 'blood_glucose';
    }
  }

  String _getVitalSignName() {
    switch (type) {
      case VitalSignType.heartRate:
        return 'Heart Rate';
      case VitalSignType.bloodPressure:
        return 'Blood Pressure';
      case VitalSignType.temperature:
        return 'Temperature';
      case VitalSignType.oxygenSaturation:
        return 'Oxygen Saturation';
      case VitalSignType.respiratoryRate:
        return 'Respiratory Rate';
      case VitalSignType.bloodGlucose:
        return 'Blood Glucose';
    }
  }

  Color _getCardColor() {
    if (isAbnormal) {
      return CareCircleColorTokens.dangerRange.withValues(alpha: 0.1);
    }
    return CareCircleColorTokens.lightColorScheme.surface;
  }

  Color _getValueColor() {
    if (isAbnormal) {
      return CareCircleColorTokens.dangerRange;
    }
    return CareCircleColorTokens.lightColorScheme.onSurface;
  }

  int _getDecimalPlaces() {
    switch (type) {
      case VitalSignType.temperature:
        return 1;
      case VitalSignType.bloodGlucose:
        return 1;
      default:
        return 0;
    }
  }

  double _calculateTrend() {
    if (historicalData.length < 2) return 0.0;

    final recent = historicalData.last.value;
    final previous = historicalData[historicalData.length - 2].value;

    return (recent - previous) / previous;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getDefaultSemanticLabel() {
    return '${_getVitalSignName()}: $currentValue $unit';
  }

  String _getDefaultSemanticValue() {
    String value = '$currentValue $unit';
    if (isAbnormal) {
      value += ', abnormal reading';
    }
    return value;
  }

  String _getDefaultSemanticHint() {
    String hint = 'Vital sign measurement';
    if (onTap != null) {
      hint += '. Double-tap for details';
    }
    if (isAbnormal) {
      hint += '. This reading is outside normal range';
    }
    return hint;
  }
}
