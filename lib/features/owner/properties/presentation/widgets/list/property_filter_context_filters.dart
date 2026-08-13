import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/form_deed_entity.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../../domain/entities/property_form_options_entity.dart';
import 'property_filter_controls.dart';

class PropertyFilterContextFilters extends StatelessWidget {
  final PropertiesQueryFilterEntity filter;
  final PropertyFormOptionsEntity? options;
  final ValueChanged<PropertiesQueryFilterEntity> onChanged;

  const PropertyFilterContextFilters({
    super.key,
    required this.filter,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final deeds =
        options?.deeds
            .where(
              (deed) =>
                  filter.branchId == null || deed.branchId == filter.branchId,
            )
            .toList() ??
        const <FormDeedEntity>[];
    return Column(
      children: [
        PropertyFilterDropdown<int?>(
          label: LocaleKeys.property_create_select_branch.tr(),
          value: filter.branchId,
          options: [
            PropertyFilterOption(null, LocaleKeys.commonAll.tr()),
            ...?options?.branches.map(
              (branch) => PropertyFilterOption(branch.id, branch.name),
            ),
          ],
          onChanged: (value) => onChanged(
            filter.copyWith(branchId: () => value, deedId: () => null),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PropertyFilterDropdown<int?>(
          label: LocaleKeys.property_create_select_deed.tr(),
          value: filter.deedId,
          options: [
            PropertyFilterOption(null, LocaleKeys.commonAll.tr()),
            ...deeds.map(
              (deed) => PropertyFilterOption(deed.id, deed.name),
            ),
          ],
          onChanged: (value) => onChanged(filter.copyWith(deedId: () => value)),
        ),
      ],
    );
  }
}
