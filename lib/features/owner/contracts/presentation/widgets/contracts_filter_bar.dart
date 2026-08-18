import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_filter_chips.dart';
import '../../../../../core/presentation/widgets/list/filter_sort_header_bar.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../domain/entities/contract_status_filter.dart';
import '../cubit/list/owner_contracts_cubit.dart';
import '../cubit/list/owner_contracts_state.dart';
import 'contract_filter_sheet.dart';
import 'contract_sort_sheet.dart';

class ContractsFilterBar extends StatelessWidget {
  const ContractsFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerContractsCubit, OwnerContractsState>(
      builder: (context, state) {
        final cubit = context.read<OwnerContractsCubit>();
        final filter = cubit.currentFilter;

        final quickOptions = ContractStatusFilter.values.map((status) {
          return AppFilterOption<ContractStatusFilter>(
            value: status,
            labelKey: _mapStatusToKey(status),
            icon: _mapStatusToIcon(status),
          );
        }).toList();

        return Column(
          children: [
            FilterSortHeaderBar<ContractStatusFilter>(
              searchField: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.propertiesSearchHint,
                initialValue: filter.search,
                onChanged: cubit.searchContracts,
                onClear: () => cubit.searchContracts(''),
              ),
              activeFiltersCount: filter.activeFiltersCount,
              isSortActive: filter.sortBy != null,
              quickFilterOptions: quickOptions,
              selectedQuickFilter: filter.status,
              onQuickFilterSelected: (newStatus) {
                if (newStatus != null) {
                  cubit.changeStatusFilter(newStatus);
                }
              },
              onFilterTap: () {
                ContractFilterSheet.show(
                  context,
                  currentFilter: filter,
                  onApply: cubit.applyAdvancedFilter,
                );
              },
              onSortTap: () {
                ContractSortSheet.show(
                  context,
                  currentFilter: filter,
                  onApply: cubit.applyAdvancedFilter,
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _mapStatusToKey(ContractStatusFilter status) {
    switch (status) {
      case ContractStatusFilter.all:
        return LocaleKeys.propertiesFilterAll;
      case ContractStatusFilter.active:
        return LocaleKeys.filterStatus;
      case ContractStatusFilter.expiring:
        return LocaleKeys.sortExpiry;
      case ContractStatusFilter.draft:
        return LocaleKeys.propertiesFilterDraft;
      case ContractStatusFilter.terminated:
        return LocaleKeys.activityActionCancelled;
    }
  }

  IconData? _mapStatusToIcon(ContractStatusFilter status) {
    switch (status) {
      case ContractStatusFilter.all:
        return Icons.all_inbox_rounded;
      case ContractStatusFilter.active:
        return Icons.verified_rounded;
      case ContractStatusFilter.expiring:
        return Icons.timer_outlined;
      case ContractStatusFilter.draft:
        return Icons.edit_note_rounded;
      case ContractStatusFilter.terminated:
        return Icons.cancel_outlined;
    }
  }
}
