import 'package:flutter/material.dart';

import '../../../../core/design/design_tokens.dart';

/// Preference section widget
///
/// A reusable widget for grouping related preference settings:
/// - Section header with title and icon
/// - Collapsible content area
/// - Consistent styling across preference screens
class PreferenceSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Color? iconColor;
  final VoidCallback? onTap;

  const PreferenceSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = true,
    this.iconColor,
    this.onTap,
  });

  @override
  State<PreferenceSection> createState() => _PreferenceSectionState();
}

class _PreferenceSectionState extends State<PreferenceSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: widget.onTap ?? _toggleExpanded,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (widget.iconColor ?? CareCircleDesignTokens.primaryMedicalBlue)
              .withOpacity(0.05),
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(16),
            bottom: _isExpanded ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (widget.iconColor ?? CareCircleDesignTokens.primaryMedicalBlue)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? CareCircleDesignTokens.primaryMedicalBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: CareCircleDesignTokens.textPrimary,
                ),
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.iconColor ?? CareCircleDesignTokens.primaryMedicalBlue,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: widget.children,
      ),
    );
  }
}

/// Simple preference section without expansion
class SimplePreferenceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? iconColor;

  const SimplePreferenceSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (iconColor ?? CareCircleDesignTokens.primaryMedicalBlue)
            .withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? CareCircleDesignTokens.primaryMedicalBlue)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: iconColor ?? CareCircleDesignTokens.primaryMedicalBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CareCircleDesignTokens.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

/// Preference item widget for individual settings
class PreferenceItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const PreferenceItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled 
              ? CareCircleDesignTokens.textPrimary
              : CareCircleDesignTokens.textSecondary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: enabled 
                    ? CareCircleDesignTokens.textSecondary
                    : CareCircleDesignTokens.textSecondary.withOpacity(0.6),
              ),
            )
          : null,
      leading: leading,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      enabled: enabled,
    );
  }
}

/// Switch preference item
class SwitchPreferenceItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Color? activeColor;

  const SwitchPreferenceItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.leading,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: onChanged != null 
              ? CareCircleDesignTokens.textPrimary
              : CareCircleDesignTokens.textSecondary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: onChanged != null 
                    ? CareCircleDesignTokens.textSecondary
                    : CareCircleDesignTokens.textSecondary.withOpacity(0.6),
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      secondary: leading,
      activeColor: activeColor ?? CareCircleDesignTokens.primaryMedicalBlue,
    );
  }
}

/// Slider preference item
class SliderPreferenceItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final Widget? leading;
  final String Function(double)? valueFormatter;

  const SliderPreferenceItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.onChanged,
    this.leading,
    this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: onChanged != null 
                  ? CareCircleDesignTokens.textPrimary
                  : CareCircleDesignTokens.textSecondary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    color: onChanged != null 
                        ? CareCircleDesignTokens.textSecondary
                        : CareCircleDesignTokens.textSecondary.withOpacity(0.6),
                  ),
                )
              : null,
          leading: leading,
          trailing: Text(
            valueFormatter?.call(value) ?? value.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: CareCircleDesignTokens.primaryMedicalBlue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: CareCircleDesignTokens.primaryMedicalBlue,
            inactiveColor: CareCircleDesignTokens.primaryMedicalBlue.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
