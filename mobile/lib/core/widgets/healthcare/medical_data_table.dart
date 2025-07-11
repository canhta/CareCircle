// CareCircle Medical Data Table
//
// Healthcare-optimized data table with sorting, filtering, and accessibility
// compliance for medical records and health metrics display.

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

/// Medical Data Table with healthcare-specific features
class MedicalDataTable extends StatefulWidget {
  const MedicalDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.showCheckboxColumn = false,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.dataRowMinHeight = 56.0,
    this.dataRowMaxHeight = 56.0,
    this.headingRowHeight = 56.0,
    this.dividerThickness = 1.0,
    this.showBottomBorder = false,
    this.decoration,
    required this.semanticLabel,
  });

  final List<MedicalDataColumn> columns;
  final List<MedicalDataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool)? onSort;
  final bool showCheckboxColumn;
  final double horizontalMargin;
  final double columnSpacing;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double headingRowHeight;
  final double dividerThickness;
  final bool showBottomBorder;
  final Decoration? decoration;
  final String semanticLabel;

  @override
  State<MedicalDataTable> createState() => _MedicalDataTableState();
}

class _MedicalDataTableState extends State<MedicalDataTable> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      hint: 'Medical data table with ${widget.rows.length} rows',
      child: Container(
        decoration: widget.decoration ?? _getDefaultDecoration(),
        child: DataTable(
          columns: widget.columns.map((col) => _buildDataColumn(col)).toList(),
          rows: widget.rows.map((row) => _buildDataRow(row)).toList(),
          sortColumnIndex: widget.sortColumnIndex,
          sortAscending: widget.sortAscending,
          onSelectAll: widget.showCheckboxColumn ? _handleSelectAll : null,
          showCheckboxColumn: widget.showCheckboxColumn,
          horizontalMargin: widget.horizontalMargin,
          columnSpacing: widget.columnSpacing,
          dataRowMinHeight: widget.dataRowMinHeight,
          dataRowMaxHeight: widget.dataRowMaxHeight,
          headingRowHeight: widget.headingRowHeight,
          dividerThickness: widget.dividerThickness,
          showBottomBorder: widget.showBottomBorder,
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(MedicalDataColumn column) {
    return DataColumn(
      label: Semantics(
        label: '${column.label} column header',
        hint: column.tooltip ?? 'Sort by ${column.label}',
        // sortKey: column.sortOrder != null ? OrdinalSortKey(column.sortOrder!) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                column.label,
                style: CareCircleTypographyTokens.healthMetricTitle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (column.unit != null) ...[
              SizedBox(width: CareCircleSpacingTokens.xs),
              Text(
                '(${column.unit})',
                style: CareCircleTypographyTokens.medicalLabel.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
            if (column.isRequired) ...[
              SizedBox(width: CareCircleSpacingTokens.xs),
              Text(
                '*',
                style: TextStyle(
                  color: CareCircleColorTokens.emergencyRed,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
      onSort: column.onSort ?? widget.onSort,
      numeric: column.isNumeric,
      tooltip: column.tooltip,
    );
  }

  DataRow _buildDataRow(MedicalDataRow row) {
    return DataRow(
      cells: row.cells.map((cell) => _buildDataCell(cell)).toList(),
      selected: row.selected,
      onSelectChanged: row.onSelectChanged,
      color: _getRowColor(row),
    );
  }

  DataCell _buildDataCell(MedicalDataCell cell) {
    return DataCell(
      Semantics(
        label: cell.semanticLabel ?? cell.value.toString(),
        hint: cell.semanticHint,
        child: _buildCellContent(cell),
      ),
      showEditIcon: cell.showEditIcon,
      onTap: cell.onTap,
      onLongPress: cell.onLongPress,
      onDoubleTap: cell.onDoubleTap,
      placeholder: cell.placeholder,
    );
  }

  Widget _buildCellContent(MedicalDataCell cell) {
    if (cell.widget != null) {
      return cell.widget!;
    }

    final textStyle = _getCellTextStyle(cell);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cell.icon != null) ...[
          Icon(cell.icon, size: 16, color: _getCellIconColor(cell)),
          SizedBox(width: CareCircleSpacingTokens.xs),
        ],
        Flexible(
          child: Text(
            cell.value.toString(),
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (cell.badge != null) ...[
          SizedBox(width: CareCircleSpacingTokens.xs),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: CareCircleSpacingTokens.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: _getBadgeColor(cell.badge!),
              borderRadius: BorderRadius.circular(CareCircleSpacingTokens.xs),
            ),
            child: Text(
              cell.badge!,
              style: CareCircleTypographyTokens.medicalLabel.copyWith(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  TextStyle _getCellTextStyle(MedicalDataCell cell) {
    var baseStyle = CareCircleTypographyTokens.textTheme.bodyMedium!;

    if (cell.isNumeric) {
      baseStyle = baseStyle.copyWith(
        fontFeatures: [const FontFeature.tabularFigures()],
      );
    }

    switch (cell.severity) {
      case MedicalSeverity.critical:
        return baseStyle.copyWith(
          color: CareCircleColorTokens.emergencyRed,
          fontWeight: FontWeight.bold,
        );
      case MedicalSeverity.warning:
        return baseStyle.copyWith(
          color: CareCircleColorTokens.warningAmber,
          fontWeight: FontWeight.w600,
        );
      case MedicalSeverity.normal:
        return baseStyle.copyWith(color: CareCircleColorTokens.healthGreen);
      case MedicalSeverity.info:
        return baseStyle.copyWith(
          color: CareCircleColorTokens.primaryMedicalBlue,
        );
      default:
        return baseStyle;
    }
  }

  Color _getCellIconColor(MedicalDataCell cell) {
    switch (cell.severity) {
      case MedicalSeverity.critical:
        return CareCircleColorTokens.emergencyRed;
      case MedicalSeverity.warning:
        return CareCircleColorTokens.warningAmber;
      case MedicalSeverity.normal:
        return CareCircleColorTokens.healthGreen;
      case MedicalSeverity.info:
        return CareCircleColorTokens.primaryMedicalBlue;
      default:
        return Colors.grey;
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'high':
      case 'critical':
      case 'urgent':
        return CareCircleColorTokens.emergencyRed;
      case 'medium':
      case 'warning':
        return CareCircleColorTokens.warningAmber;
      case 'low':
      case 'normal':
      case 'good':
        return CareCircleColorTokens.healthGreen;
      default:
        return CareCircleColorTokens.primaryMedicalBlue;
    }
  }

  WidgetStateProperty<Color?> _getRowColor(MedicalDataRow row) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return CareCircleColorTokens.primaryMedicalBlue.withValues(alpha: 0.1);
      }

      if (row.severity != null) {
        switch (row.severity!) {
          case MedicalSeverity.critical:
            return CareCircleColorTokens.emergencyRed.withValues(alpha: 0.05);
          case MedicalSeverity.warning:
            return CareCircleColorTokens.warningAmber.withValues(alpha: 0.05);
          case MedicalSeverity.normal:
            return CareCircleColorTokens.healthGreen.withValues(alpha: 0.05);
          default:
            return null;
        }
      }

      return null;
    });
  }

  Decoration _getDefaultDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(CareCircleSpacingTokens.md),
      border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _handleSelectAll(bool? selected) {
    // Handle select all functionality
    for (final row in widget.rows) {
      row.onSelectChanged?.call(selected ?? false);
    }
  }
}

/// Medical Data Column definition
class MedicalDataColumn {
  final String label;
  final String? unit;
  final String? tooltip;
  final bool isNumeric;
  final bool isRequired;
  final Function(int, bool)? onSort;
  final int? sortOrder;

  const MedicalDataColumn({
    required this.label,
    this.unit,
    this.tooltip,
    this.isNumeric = false,
    this.isRequired = false,
    this.onSort,
    this.sortOrder,
  });
}

/// Medical Data Row definition
class MedicalDataRow {
  final List<MedicalDataCell> cells;
  final bool selected;
  final Function(bool?)? onSelectChanged;
  final MedicalSeverity? severity;

  const MedicalDataRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
    this.severity,
  });
}

/// Medical Data Cell definition
class MedicalDataCell {
  final dynamic value;
  final Widget? widget;
  final IconData? icon;
  final String? badge;
  final bool isNumeric;
  final bool placeholder;
  final bool showEditIcon;
  final MedicalSeverity? severity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final String? semanticLabel;
  final String? semanticHint;

  const MedicalDataCell({
    required this.value,
    this.widget,
    this.icon,
    this.badge,
    this.isNumeric = false,
    this.placeholder = false,
    this.showEditIcon = false,
    this.severity,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Creates a vital sign cell with appropriate formatting
  factory MedicalDataCell.vitalSign({
    required double value,
    required String unit,
    required String normalRange,
    MedicalSeverity? severity,
  }) {
    return MedicalDataCell(
      value: '$value $unit',
      isNumeric: true,
      severity: severity,
      semanticLabel: '$value $unit',
      semanticHint: 'Normal range: $normalRange',
    );
  }

  /// Creates a medication cell with dosage information
  factory MedicalDataCell.medication({
    required String name,
    required String dosage,
    required bool taken,
  }) {
    return MedicalDataCell(
      value: '$name - $dosage',
      icon: Icons.medication,
      badge: taken ? 'Taken' : 'Pending',
      severity: taken ? MedicalSeverity.normal : MedicalSeverity.warning,
      semanticLabel: '$name $dosage',
      semanticHint: taken ? 'Medication taken' : 'Medication pending',
    );
  }
}

/// Medical severity levels for data visualization
enum MedicalSeverity { critical, warning, normal, info }
