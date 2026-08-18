import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../../domain/entities/property_form_options_entity.dart';
import '../../../domain/entities/option_value_label_entity.dart';

class PropertyActiveFilter {
  final String key;
  final String label;

  const PropertyActiveFilter(this.key, this.label);
}

class PropertyActiveFilterResolver {
  const PropertyActiveFilterResolver._();

  static List<PropertyActiveFilter> resolve(
    PropertiesQueryFilterEntity filter,
    PropertyFormOptionsEntity? options,
  ) {
    final result = <PropertyActiveFilter>[];
    if (filter.propertyType != null) {
      result.add(
        PropertyActiveFilter(
          'propertyType',
          _optionLabel(options?.propertyTypes, filter.propertyType!),
        ),
      );
    }
    if (filter.usageType != null) {
      result.add(
        PropertyActiveFilter(
          'usageType',
          _optionLabel(options?.usageTypes, filter.usageType!),
        ),
      );
    }
    if (filter.branchId != null) {
      final match = options?.branches.where((e) => e.id == filter.branchId);
      result.add(
        PropertyActiveFilter(
          'branch',
          match != null && match.isNotEmpty
              ? match.first.name
              : LocaleKeys.property_create_select_branch.tr(),
        ),
      );
    }
    if (filter.deedId != null) {
      final match = options?.deeds.where((e) => e.id == filter.deedId);
      result.add(
        PropertyActiveFilter(
          'deed',
          match != null && match.isNotEmpty
              ? match.first.name
              : LocaleKeys.property_create_select_deed.tr(),
        ),
      );
    }
    if (filter.sortBy != null) {
      final order = filter.sortAscending
          ? LocaleKeys.propertiesSortAscending.tr()
          : LocaleKeys.propertiesSortDescending.tr();
      result.add(
        PropertyActiveFilter('sort', '${_sort(filter.sortBy!)} ($order)'),
      );
    }
    return result;
  }

  static String _optionLabel(
    List<OptionValueLabelEntity>? options,
    String value,
  ) {
    final match = options?.where((option) => option.value == value);
    return match != null && match.isNotEmpty ? match.first.label : value;
  }

  static String _sort(PropertySortField field) => switch (field) {
    PropertySortField.name => LocaleKeys.propertiesSortName.tr(),
    PropertySortField.area => LocaleKeys.propertiesSortArea.tr(),
    PropertySortField.occupancy => LocaleKeys.propertiesSortOccupancy.tr(),
    PropertySortField.units => LocaleKeys.propertiesSortUnits.tr(),
  };
}
