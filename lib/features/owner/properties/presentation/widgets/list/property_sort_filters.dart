import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import 'property_filter_controls.dart';

class PropertySortFilters extends StatelessWidget {
  final PropertiesQueryFilterEntity filter;
  final ValueChanged<PropertiesQueryFilterEntity> onChanged;

  const PropertySortFilters({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyFilterChoiceGroup<PropertySortField>(
          title: LocaleKeys.propertiesSortTitle.tr(),
          selected: filter.sortBy,
          options: [
            PropertyFilterOption(
              PropertySortField.name,
              LocaleKeys.propertiesSortName.tr(),
            ),
            PropertyFilterOption(
              PropertySortField.area,
              LocaleKeys.propertiesSortArea.tr(),
            ),
            PropertyFilterOption(
              PropertySortField.occupancy,
              LocaleKeys.propertiesSortOccupancy.tr(),
            ),
            PropertyFilterOption(
              PropertySortField.units,
              LocaleKeys.propertiesSortUnits.tr(),
            ),
          ],
          onChanged: (value) => onChanged(filter.copyWith(sortBy: () => value)),
        ),
        if (filter.sortBy != null) ...[
          const SizedBox(height: AppSpacing.lg),
          PropertyFilterChoiceGroup<bool>(
            title: LocaleKeys.propertiesSortOrderTitle.tr(),
            selected: filter.sortAscending,
            options: [
              PropertyFilterOption(
                true,
                LocaleKeys.propertiesSortAscending.tr(),
              ),
              PropertyFilterOption(
                false,
                LocaleKeys.propertiesSortDescending.tr(),
              ),
            ],
            onChanged: (value) =>
                onChanged(filter.copyWith(sortAscending: value)),
          ),
        ],
      ],
    );
  }
}
