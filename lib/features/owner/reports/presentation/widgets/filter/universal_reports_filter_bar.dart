import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import 'report_date_range_chip.dart';
import 'report_property_chip.dart';
import 'report_status_chip.dart';

class UniversalReportsFilterBar extends StatelessWidget {
  final bool showDateRange;
  final String? selectedStartDate;
  final String? selectedEndDate;
  final Function(String?, String?)? onDateRangeSelected;

  final bool showProperty;
  final int? selectedPropertyId;
  final List<ReportPropertyItem>? properties;
  final ValueChanged<int?>? onPropertySelected;

  final bool showStatus;
  final String? selectedStatus;
  final List<ReportStatusItem>? statuses;
  final ValueChanged<String?>? onStatusSelected;

  final List<Widget>? customChips;
  final bool hasActiveFilters;
  final VoidCallback onReset;

  const UniversalReportsFilterBar({
    super.key,
    this.showDateRange = false,
    this.selectedStartDate,
    this.selectedEndDate,
    this.onDateRangeSelected,
    this.showProperty = false,
    this.selectedPropertyId,
    this.properties,
    this.onPropertySelected,
    this.showStatus = false,
    this.selectedStatus,
    this.statuses,
    this.onStatusSelected,
    this.customChips,
    required this.hasActiveFilters,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (showDateRange && onDateRangeSelected != null) ...[
            ReportDateRangeChip(
              startDate: selectedStartDate,
              endDate: selectedEndDate,
              onDateRangeSelected: onDateRangeSelected!,
            ),
            const SizedBox(width: 8),
          ],
          if (showProperty &&
              properties != null &&
              onPropertySelected != null) ...[
            ReportPropertyChip(
              selectedPropertyId: selectedPropertyId,
              properties: properties!,
              onPropertySelected: onPropertySelected!,
            ),
            const SizedBox(width: 8),
          ],
          if (showStatus && statuses != null && onStatusSelected != null) ...[
            ReportStatusChip(
              selectedStatus: selectedStatus,
              statuses: statuses!,
              onStatusSelected: onStatusSelected!,
            ),
            const SizedBox(width: 8),
          ],
          if (customChips != null) ...[
            ...customChips!.expand((c) => [c, const SizedBox(width: 8)]),
          ],
          if (hasActiveFilters) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onReset,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.red,
                  size: 20,
                ),
                tooltip: LocaleKeys.reportsFilterReset.tr(),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}
