import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/units_status_filter_options_entity.dart';
import '../cubit/owner_units_status_cubit.dart';

class UnitsStatusFilterBar extends StatelessWidget {
  final UnitsStatusFilterOptionsEntity filterOptions;

  const UnitsStatusFilterBar({super.key, required this.filterOptions});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerUnitsStatusCubit>();
    final property = CustomDropdownMenu<int>(
      hint: LocaleKeys.reports_property.tr(),
      value: cubit.selectedPropertyId ?? -1,
      items: [-1, ...filterOptions.properties.map((item) => item.id)],
      height: 44,
      itemLabelBuilder: (id) {
        if (id == -1) return LocaleKeys.reports_all_properties.tr();
        final item = filterOptions.properties.firstWhere(
          (item) => item.id == id,
        );
        return item.name?.isNotEmpty == true ? item.name! : item.code;
      },
      onSelected: (value) => cubit.loadUnitsStatusReport(
        forceRefresh: true,
        propertyId: value,
        status: cubit.selectedStatus ?? 'ALL',
      ),
    );
    final status = CustomDropdownMenu<String>(
      hint: LocaleKeys.reports_status.tr(),
      value: cubit.selectedStatus ?? 'ALL',
      items: ['ALL', ...filterOptions.statuses.map((item) => item.value)],
      height: 44,
      itemLabelBuilder: (value) => value == 'ALL'
          ? LocaleKeys.reports_all_statuses.tr()
          : filterOptions.statuses
                .firstWhere((item) => item.value == value)
                .label,
      onSelected: (value) => cubit.loadUnitsStatusReport(
        forceRefresh: true,
        propertyId: cubit.selectedPropertyId ?? -1,
        status: value,
      ),
    );
    final fields = context.isCompact
        ? <Widget>[Expanded(child: property), Expanded(child: status)]
        : <Widget>[
            SizedBox(width: 260, child: property),
            SizedBox(width: 220, child: status),
          ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appSubtleSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorderColor),
      ),
      child: Row(
        children: [
          fields.first,
          const SizedBox(width: AppSpacing.sm),
          fields.last,
          if (cubit.selectedPropertyId != null ||
              cubit.selectedStatus != null) ...[
            const SizedBox(width: AppSpacing.sm),
            IconButton.outlined(
              onPressed: cubit.clearFilters,
              icon: const Icon(Icons.filter_alt_off_rounded, size: 20),
              tooltip: LocaleKeys.reports_resetFilters.tr(),
            ),
          ],
        ],
      ),
    );
  }
}
