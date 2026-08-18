import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/sort_bottom_sheet.dart';
import '../../domain/entities/finance_query_filter_entity.dart';

class FinanceSortSheet {
  static void show(
    BuildContext context, {
    required FinanceQueryFilterEntity currentFilter,
    required ValueChanged<FinanceQueryFilterEntity> onApply,
  }) {
    final options = [
      const AppSortOption(
        field: FinanceSortField.date,
        labelLocaleKey: LocaleKeys.sortDate,
        icon: Icons.calendar_today_rounded,
      ),
      const AppSortOption(
        field: FinanceSortField.amount,
        labelLocaleKey: LocaleKeys.sortAmount,
        icon: Icons.payments_rounded,
      ),
    ];

    SortBottomSheet.show<FinanceSortField>(
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
