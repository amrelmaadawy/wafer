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

        final categoryOptions = const [
          AppFilterOption(
            value: 'all',
            labelKey: LocaleKeys.propertiesFilterAll,
            icon: Icons.all_inbox_rounded,
          ),
          AppFilterOption(
            value: 'HVAC',
            labelKey: LocaleKeys.maintCatAc,
            icon: Icons.ac_unit_rounded,
          ),
          AppFilterOption(
            value: 'Plumbing',
            labelKey: LocaleKeys.maintCatPlumbing,
            icon: Icons.plumbing_rounded,
          ),
          AppFilterOption(
            value: 'Electrical',
            labelKey: LocaleKeys.maintCatElectrical,
            icon: Icons.electric_bolt_rounded,
          ),
          AppFilterOption(
            value: 'Carpentry',
            labelKey: LocaleKeys.maintCatCarpentry,
            icon: Icons.carpenter_rounded,
          ),
          AppFilterOption(
            value: 'Painting',
            labelKey: LocaleKeys.maintCatPainting,
            icon: Icons.format_paint_rounded,
          ),
          AppFilterOption(
            value: 'General',
            labelKey: LocaleKeys.maintCatGeneral,
            icon: Icons.build_rounded,
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
              quickFilterOptions: categoryOptions,
              selectedQuickFilter: cubit.currentCategory ?? 'all',
              onQuickFilterSelected: (newCat) {
                cubit.changeCategoryFilter(newCat);
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
