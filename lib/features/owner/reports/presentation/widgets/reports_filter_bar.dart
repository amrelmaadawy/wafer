import 'package:flutter/material.dart';
import '../../domain/entities/revenue_report_entity.dart';
import 'filter/report_property_chip.dart';
import 'filter/universal_reports_filter_bar.dart';

class ReportsFilterBar extends StatelessWidget {
  final RevenueFilterOptionsEntity filterOptions;
  final int? selectedPropertyId;
  final String? selectedStartDate;
  final String? selectedEndDate;
  final Function(int?) onPropertySelected;
  final Function(String?, String?) onDateRangeSelected;
  final VoidCallback onReset;

  const ReportsFilterBar({
    super.key,
    required this.filterOptions,
    required this.selectedPropertyId,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onPropertySelected,
    required this.onDateRangeSelected,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final propertyItems = filterOptions.properties
        .map(
          (p) => ReportPropertyItem(
            id: p.id,
            displayName: p.displayName,
            code: p.code,
          ),
        )
        .toList();

    final bool hasActiveFilters =
        selectedPropertyId != null ||
        (selectedStartDate != null && selectedEndDate != null);

    return UniversalReportsFilterBar(
      showDateRange: true,
      selectedStartDate: selectedStartDate,
      selectedEndDate: selectedEndDate,
      onDateRangeSelected: onDateRangeSelected,
      showProperty: true,
      selectedPropertyId: selectedPropertyId,
      properties: propertyItems,
      onPropertySelected: onPropertySelected,
      hasActiveFilters: hasActiveFilters,
      onReset: onReset,
    );
  }
}
