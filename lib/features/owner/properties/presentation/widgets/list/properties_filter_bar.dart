import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/filter_sort_header_bar.dart';
import '../../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../cubit/list/properties_list_cubit.dart';
import '../../cubit/list/properties_list_state.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import 'active_filter_bar.dart';
import 'property_filter_sheet.dart';
import 'property_sort_sheet.dart';

class PropertiesFilterBar extends StatelessWidget {
  const PropertiesFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        final cubit = context.read<PropertiesListCubit>();
        final filter = cubit.currentFilter;

        return Column(
          children: [
            FilterSortHeaderBar<String>(
              searchField: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.propertiesSearchHint,
                initialValue: filter.search,
                onChanged: cubit.searchProperties,
                onClear: () => cubit.searchProperties(''),
              ),
              activeFiltersCount: _getActiveFiltersCount(filter),
              isSortActive: filter.sortBy != null,
              onFilterTap: () {
                PropertyFilterSheet.show(context, filter);
              },
              onSortTap: () {
                PropertySortSheet.show(
                  context,
                  currentFilter: filter,
                  onApply: cubit.applyAdvancedFilter,
                );
              },
            ),
            const ActiveFilterBar(),
          ],
        );
      },
    );
  }

  int _getActiveFiltersCount(PropertiesQueryFilterEntity filter) {
    int count = 0;
    if (filter.status != null && filter.status != 'all') count++;
    if (filter.propertyType != null && filter.propertyType != 'all') count++;
    if (filter.usageType != null && filter.usageType != 'all') count++;
    if (filter.branchId != null) count++;
    if (filter.deedId != null) count++;
    return count;
  }
}
