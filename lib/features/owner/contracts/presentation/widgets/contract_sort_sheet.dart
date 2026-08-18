import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/sort_bottom_sheet.dart';
import '../../domain/entities/contracts_query_filter_entity.dart';

class ContractSortSheet {
  static void show(
    BuildContext context, {
    required ContractsQueryFilterEntity currentFilter,
    required ValueChanged<ContractsQueryFilterEntity> onApply,
  }) {
    final options = [
      const AppSortOption(
        field: ContractSortField.expiryDate,
        labelLocaleKey: LocaleKeys.sortExpiry,
        icon: Icons.event_busy_rounded,
      ),
      const AppSortOption(
        field: ContractSortField.startDate,
        labelLocaleKey: LocaleKeys.sortStartDate,
        icon: Icons.calendar_today_rounded,
      ),
      const AppSortOption(
        field: ContractSortField.rentAmount,
        labelLocaleKey: LocaleKeys.sortAmount,
        icon: Icons.payments_rounded,
      ),
      const AppSortOption(
        field: ContractSortField.contractNumber,
        labelLocaleKey: LocaleKeys.dashboard_contractsMovementContractNo,
        icon: Icons.tag_rounded,
      ),
    ];

    SortBottomSheet.show<ContractSortField>(
      context: context,
      options: options,
      initialField: currentFilter.sortBy,
      initialAscending: currentFilter.sortAscending,
      onReset: () {
        onApply(
          currentFilter.copyWith(
            sortBy: () => null,
            sortAscending: true,
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
