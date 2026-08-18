import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/sort_bottom_sheet.dart';
import '../../domain/entities/maintenance_query_filter_entity.dart';

class MaintenanceSortSheet {
  static void show(
    BuildContext context, {
    required MaintenanceQueryFilterEntity currentFilter,
    required ValueChanged<MaintenanceQueryFilterEntity> onApply,
  }) {
    final options = [
      const AppSortOption(
        field: MaintenanceSortField.date,
        labelLocaleKey: LocaleKeys.sortDate,
        icon: Icons.calendar_today_rounded,
      ),
      const AppSortOption(
        field: MaintenanceSortField.priority,
        labelLocaleKey: LocaleKeys.sortPriority,
        icon: Icons.flag_rounded,
      ),
      const AppSortOption(
        field: MaintenanceSortField.requestNumber,
        labelLocaleKey: LocaleKeys.dashboard_maintenanceRequestsRequestNo,
        icon: Icons.tag_rounded,
      ),
    ];

    SortBottomSheet.show<MaintenanceSortField>(
      context: context,
      options: options,
      initialField: currentFilter.sortBy,
      initialAscending: currentFilter.sortAscending,
      onReset: () {
        onApply(
          currentFilter.copyWith(
            sortBy: () => null,
            sortAscending: false,
          ),
        );
      },
      onApply: (field, isAscending) {
        onApply(
          currentFilter.copyWith(
            sortBy: () => field,
            sortAscending: isAscending,
          ),
        );
      },
    );
  }
}
