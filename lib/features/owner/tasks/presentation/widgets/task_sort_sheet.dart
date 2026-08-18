import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/sort_bottom_sheet.dart';
import '../../domain/entities/tasks_filter_params.dart';

class TaskSortSheet {
  static void show(
    BuildContext context, {
    required TasksFilterParams currentFilter,
    required void Function(String? sortBy, String? sortOrder) onApply,
  }) {
    final options = [
      const AppSortOption(
        field: 'due_date',
        labelLocaleKey: LocaleKeys.sortDueDate,
        icon: Icons.event_available_rounded,
      ),
      const AppSortOption(
        field: 'priority',
        labelLocaleKey: LocaleKeys.sortPriority,
        icon: Icons.flag_rounded,
      ),
      const AppSortOption(
        field: 'title',
        labelLocaleKey: LocaleKeys.sortName,
        icon: Icons.title_rounded,
      ),
    ];

    final isAscending = currentFilter.sortOrder != 'desc';

    SortBottomSheet.show<String>(
      context: context,
      options: options,
      initialField: currentFilter.sortBy,
      initialAscending: isAscending,
      onReset: () => onApply(null, null),
      onApply: (field, asc) {
        onApply(field, asc ? 'asc' : 'desc');
      },
    );
  }
}
