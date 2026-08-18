import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/option_value_label_entity.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../../domain/entities/property_form_options_entity.dart';
import 'property_filter_controls.dart';
import 'property_filter_context_filters.dart';

class PropertyFilterSheetBody extends StatelessWidget {
  final PropertiesQueryFilterEntity filter;
  final PropertyFormOptionsEntity? options;
  final ValueChanged<PropertiesQueryFilterEntity> onChanged;

  const PropertyFilterSheetBody({
    super.key,
    required this.filter,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final propertyTypes = options?.propertyTypes.isNotEmpty == true
        ? options!.propertyTypes
        : [
            OptionValueLabelEntity(
              value: 'building',
              label: LocaleKeys.propertiesTypeBuilding.tr(),
            ),
            OptionValueLabelEntity(
              value: 'villa',
              label: LocaleKeys.propertiesTypeVilla.tr(),
            ),
            OptionValueLabelEntity(
              value: 'land',
              label: LocaleKeys.propertiesTypeLand.tr(),
            ),
          ];
    final usageTypes = options?.usageTypes.isNotEmpty == true
        ? options!.usageTypes
        : [
            OptionValueLabelEntity(
              value: 'residential',
              label: LocaleKeys.propertiesUsageResidential.tr(),
            ),
            OptionValueLabelEntity(
              value: 'commercial',
              label: LocaleKeys.propertiesUsageCommercial.tr(),
            ),
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyFilterChoiceGroup<String>(
            title: LocaleKeys.propertiesTypeTitle.tr(),
            selected: filter.propertyType ?? nullValue,
            options: [
              PropertyFilterOption(nullValue, LocaleKeys.commonAll.tr()),
              ...propertyTypes.map(
                (e) => PropertyFilterOption(e.value, e.label),
              ),
            ],
            onChanged: (value) => onChanged(
              filter.copyWith(
                propertyType: () => value == nullValue ? null : value,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PropertyFilterChoiceGroup<String>(
            title: LocaleKeys.propertiesUsageTitle.tr(),
            selected: filter.usageType ?? nullValue,
            options: [
              PropertyFilterOption(nullValue, LocaleKeys.commonAll.tr()),
              ...usageTypes.map((e) => PropertyFilterOption(e.value, e.label)),
            ],
            onChanged: (value) => onChanged(
              filter.copyWith(
                usageType: () => value == nullValue ? null : value,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PropertyFilterContextFilters(
            filter: filter,
            options: options,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  static const nullValue = '__all__';
}
