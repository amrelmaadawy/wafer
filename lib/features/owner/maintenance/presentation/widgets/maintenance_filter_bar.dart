import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_filter_chips.dart';
import '../../../../../core/presentation/widgets/list/filter_sort_header_bar.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../cubit/owner_maintenance_cubit.dart';
import '../cubit/owner_maintenance_state.dart';
import 'maintenance_filter_sheet.dart';
import 'maintenance_sort_sheet.dart';

class MaintenanceFilterBar extends StatelessWidget {
  const MaintenanceFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerMaintenanceCubit, OwnerMaintenanceState>(
      builder: (context, state) {
        final cubit = context.read<OwnerMaintenanceCubit>();
        final filter = cubit.currentFilter;

        final statusOptions = const [
          AppFilterOption(
            value: 'all',
            labelKey: LocaleKeys.propertiesFilterAll,
            icon: Icons.all_inbox_rounded,
          ),
          AppFilterOption(
            value: 'new',
            labelKey: LocaleKeys.maintenanceStatusNew,
            icon: Icons.fiber_new_rounded,
          ),
          AppFilterOption(
            value: 'in_progress',
            labelKey: LocaleKeys.maintenanceStatusInProgress,
            icon: Icons.handyman_rounded,
          ),
          AppFilterOption(
            value: 'executed',
            labelKey: LocaleKeys.maintenanceStatusExecuted,
            icon: Icons.done_all_rounded,
          ),
          AppFilterOption(
            value: 'rejected',
            labelKey: LocaleKeys.maintenanceStatusRejected,
            icon: Icons.cancel_rounded,
          ),
          AppFilterOption(
            value: 'closed',
            labelKey: LocaleKeys.maintenanceStatusClosed,
            icon: Icons.lock_rounded,
          ),
        ];

        return Column(
          children: [
            FilterSortHeaderBar<String>(
              searchField: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.propertiesSearchHint,
                initialValue: filter.search,
                onChanged: cubit.searchMaintenance,
                onClear: () => cubit.searchMaintenance(''),
              ),
              activeFiltersCount: filter.activeFiltersCount,
              isSortActive: filter.sortBy != null,
              quickFilterOptions: statusOptions,
              selectedQuickFilter: cubit.currentStatus,
              onQuickFilterSelected: (newStatus) {
                cubit.changeStatusFilter(newStatus ?? 'all');
              },
              onFilterTap: () {
                MaintenanceFilterSheet.show(
                  context,
                  currentFilter: filter,
                  onApply: cubit.applyAdvancedFilter,
                );
              },
              onSortTap: () {
                MaintenanceSortSheet.show(
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
}
