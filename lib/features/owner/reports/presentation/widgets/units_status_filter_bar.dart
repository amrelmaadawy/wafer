import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../domain/entities/units_status_filter_options_entity.dart';
import '../cubit/owner_units_status_cubit.dart';

class UnitsStatusFilterBar extends StatelessWidget {
  final UnitsStatusFilterOptionsEntity filterOptions;

  const UnitsStatusFilterBar({super.key, required this.filterOptions});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerUnitsStatusCubit>();

    final propertyIds = [-1, ...filterOptions.properties.map((p) => p.id)];
    final statusValues = ['ALL', ...filterOptions.statuses.map((s) => s.value)];

    return Row(
      children: [
        Expanded(
          child: CustomDropdownMenu<int>(
            hint: LocaleKeys.reports_property.tr(),
            value: cubit.selectedPropertyId,
            items: propertyIds,
            height: 44,
            itemLabelBuilder: (id) {
              if (id == -1) return LocaleKeys.reports_all_properties.tr();
              final p = filterOptions.properties.firstWhere(
                (prop) => prop.id == id,
              );
              return p.name?.isNotEmpty == true ? p.name! : p.code;
            },
            onSelected: (val) {
              cubit.loadUnitsStatusReport(
                forceRefresh: true,
                propertyId: val,
                status: cubit.selectedStatus,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomDropdownMenu<String>(
            hint: LocaleKeys.reports_status.tr(),
            value: cubit.selectedStatus,
            items: statusValues,
            height: 44,
            itemLabelBuilder: (val) {
              if (val == 'ALL') return LocaleKeys.reports_all_statuses.tr();
              return filterOptions.statuses
                  .firstWhere((s) => s.value == val)
                  .label;
            },
            onSelected: (val) {
              cubit.loadUnitsStatusReport(
                forceRefresh: true,
                propertyId: cubit.selectedPropertyId,
                status: val,
              );
            },
          ),
        ),
        if (cubit.selectedPropertyId != null ||
            cubit.selectedStatus != null) ...[
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: cubit.clearFilters,
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.red,
                size: 20,
              ),
              tooltip: 'إعادة تعيين',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ],
    );
  }
}
