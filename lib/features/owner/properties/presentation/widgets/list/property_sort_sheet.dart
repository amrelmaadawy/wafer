import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/sort_bottom_sheet.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';

class PropertySortSheet {
  static void show(
    BuildContext context, {
    required PropertiesQueryFilterEntity currentFilter,
    required ValueChanged<PropertiesQueryFilterEntity> onApply,
  }) {
    final options = [
      const AppSortOption(
        field: PropertySortField.name,
        labelLocaleKey: LocaleKeys.propertiesSortName,
        icon: Icons.title_rounded,
      ),
      const AppSortOption(
        field: PropertySortField.area,
        labelLocaleKey: LocaleKeys.propertiesSortArea,
        icon: Icons.square_foot_rounded,
      ),
      const AppSortOption(
        field: PropertySortField.occupancy,
        labelLocaleKey: LocaleKeys.propertiesSortOccupancy,
        icon: Icons.people_rounded,
      ),
      const AppSortOption(
        field: PropertySortField.units,
        labelLocaleKey: LocaleKeys.propertiesSortUnits,
        icon: Icons.meeting_room_rounded,
      ),
    ];

    SortBottomSheet.show<PropertySortField>(
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
