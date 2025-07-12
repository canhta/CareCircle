import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

/// Healthcare-compliant symptom severity slider
/// 
/// Provides a standardized way to capture symptom severity ratings
/// with accessibility support and healthcare-appropriate styling.
class SymptomSeveritySlider extends StatefulWidget {
  const SymptomSeveritySlider({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = 0,
    this.min = 0,
    this.max = 10,
    this.divisions,
    this.showLabels = true,
    this.enabled = true,
    this.semanticFormatterCallback,
  });

  /// Label for the slider
  final String label;

  /// Callback when value changes
  final ValueChanged<double> onChanged;

  /// Initial value (0-10 scale by default)
  final double initialValue;

  /// Minimum value
  final double min;

  /// Maximum value  
  final double max;

  /// Number of discrete divisions
  final int? divisions;

  /// Whether to show severity labels
  final bool showLabels;

  /// Whether the slider is enabled
  final bool enabled;

  /// Custom semantic formatter for accessibility
  final String Function(double)? semanticFormatterCallback;

  @override
  State<SymptomSeveritySlider> createState() => _SymptomSeveritySliderState();
}

class _SymptomSeveritySliderState extends State<SymptomSeveritySlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: CareCircleSpacingTokens.sm),
          child: Text(
            widget.label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        
        // Slider
        Semantics(
          label: widget.label,
          value: _getSemanticValue(),
          hint: 'Slide to adjust severity level',
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getTrackColor(),
              inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.3),
              thumbColor: _getThumbColor(),
              overlayColor: _getThumbColor().withOpacity(0.2),
              valueIndicatorColor: _getThumbColor(),
              valueIndicatorTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 3),
              showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            ),
            child: Slider(
              value: _currentValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions ?? (widget.max - widget.min).round(),
              label: _currentValue.round().toString(),
              onChanged: widget.enabled ? _handleValueChanged : null,
              semanticFormatterCallback: widget.semanticFormatterCallback ?? 
                  (value) => '${value.round()} out of ${widget.max.round()}',
            ),
          ),
        ),
        
        // Severity labels
        if (widget.showLabels) ...[
          SizedBox(height: CareCircleSpacingTokens.xs),
          _buildSeverityLabels(theme),
        ],
        
        // Current value display
        SizedBox(height: CareCircleSpacingTokens.sm),
        _buildValueDisplay(theme),
      ],
    );
  }

  void _handleValueChanged(double value) {
    setState(() {
      _currentValue = value;
    });
    widget.onChanged(value);
  }

  String _getSemanticValue() {
    if (widget.semanticFormatterCallback != null) {
      return widget.semanticFormatterCallback!(_currentValue);
    }
    return '${_currentValue.round()} out of ${widget.max.round()}';
  }

  Color _getTrackColor() {
    final severity = _currentValue / widget.max;
    
    if (severity <= 0.3) {
      return CareCircleDesignTokens.healthGreen;
    } else if (severity <= 0.6) {
      return Colors.orange;
    } else {
      return CareCircleDesignTokens.criticalAlert;
    }
  }

  Color _getThumbColor() {
    return _getTrackColor();
  }

  Widget _buildSeverityLabels(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel('None', theme, CareCircleDesignTokens.healthGreen),
        _buildLabel('Mild', theme, Colors.orange),
        _buildLabel('Severe', theme, CareCircleDesignTokens.criticalAlert),
      ],
    );
  }

  Widget _buildLabel(String text, ThemeData theme, Color color) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildValueDisplay(ThemeData theme) {
    final severity = _getSeverityText();
    final severityColor = _getTrackColor();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: CareCircleSpacingTokens.md,
        vertical: CareCircleSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(CareCircleSpacingTokens.sm),
        border: Border.all(
          color: severityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSeverityIcon(),
            color: severityColor,
            size: 16,
          ),
          SizedBox(width: CareCircleSpacingTokens.xs),
          Text(
            'Level ${_currentValue.round()}: $severity',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: severityColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeverityText() {
    final severity = _currentValue / widget.max;
    
    if (severity == 0) {
      return 'No symptoms';
    } else if (severity <= 0.3) {
      return 'Mild symptoms';
    } else if (severity <= 0.6) {
      return 'Moderate symptoms';
    } else if (severity <= 0.8) {
      return 'Severe symptoms';
    } else {
      return 'Very severe symptoms';
    }
  }

  IconData _getSeverityIcon() {
    final severity = _currentValue / widget.max;
    
    if (severity == 0) {
      return Icons.sentiment_very_satisfied;
    } else if (severity <= 0.3) {
      return Icons.sentiment_satisfied;
    } else if (severity <= 0.6) {
      return Icons.sentiment_neutral;
    } else if (severity <= 0.8) {
      return Icons.sentiment_dissatisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }
}
