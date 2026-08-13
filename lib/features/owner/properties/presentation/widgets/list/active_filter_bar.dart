import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../cubit/list/properties_list_cubit.dart';
import '../../cubit/list/properties_list_state.dart';

class ActiveFilterBar extends StatelessWidget {
  const ActiveFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        final filter = context.read<PropertiesListCubit>().currentFilter;
        final activeFilters = _getActiveFilters(filter, context);

        if (activeFilters.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${LocaleKeys.propertiesFilterTitle.tr()} (${activeFilters.length})',
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryLight),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<PropertiesListCubit>().applyAdvancedFilter(const PropertiesQueryFilterEntity());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      LocaleKeys.propertiesResetFilter.tr(),
                      style: AppTextStyles.labelMedium.copyWith(color: context.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activeFilters.map((f) => _buildChip(context, f, filter)).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_ActiveFilterInfo> _getActiveFilters(PropertiesQueryFilterEntity filter, BuildContext context) {
    final list = <_ActiveFilterInfo>[];

    if (filter.status != null && filter.status != 'all') {
      final statusMap = {
        'published': LocaleKeys.propertiesStatusPublished.tr(),
        'draft': LocaleKeys.propertiesStatusDraft.tr(),
      };
      list.add(_ActiveFilterInfo('status', statusMap[filter.status] ?? filter.status!));
    }
    
    if (filter.propertyType != null && filter.propertyType != 'all') {
      final typeMap = {
        'building': LocaleKeys.propertiesTypeBuilding.tr(),
        'villa': LocaleKeys.propertiesTypeVilla.tr(),
        'land': LocaleKeys.propertiesTypeLand.tr(),
      };
      list.add(_ActiveFilterInfo('propertyType', typeMap[filter.propertyType] ?? filter.propertyType!));
    }
    
    if (filter.usageType != null && filter.usageType != 'all') {
      final usageMap = {
        'residential': LocaleKeys.propertiesUsageResidential.tr(),
        'commercial': LocaleKeys.propertiesUsageCommercial.tr(),
      };
      list.add(_ActiveFilterInfo('usageType', usageMap[filter.usageType] ?? filter.usageType!));
    }
    
    if (filter.sortBy != null) {
      final sortMap = {
        'name': LocaleKeys.propertiesSortName.tr(),
        'area': LocaleKeys.propertiesSortArea.tr(),
        'occupancy': LocaleKeys.propertiesSortOccupancy.tr(),
        'units': LocaleKeys.propertiesSortUnits.tr(),
      };
      final orderStr = filter.sortAscending ? LocaleKeys.propertiesSortAscending.tr() : LocaleKeys.propertiesSortDescending.tr();
      list.add(_ActiveFilterInfo('sort', '${sortMap[filter.sortBy]} ($orderStr)'));
    }

    return list;
  }

  Widget _buildChip(BuildContext context, _ActiveFilterInfo info, PropertiesQueryFilterEntity currentFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXxl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            info.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              PropertiesQueryFilterEntity newFilter = currentFilter;
              if (info.key == 'status') newFilter = newFilter.copyWith(status: () => null);
              if (info.key == 'propertyType') newFilter = newFilter.copyWith(propertyType: () => null);
              if (info.key == 'usageType') newFilter = newFilter.copyWith(usageType: () => null);
              if (info.key == 'sort') {
                newFilter = newFilter.copyWith(
                  sortBy: () => null,
                  sortAscending: true,
                );
              }
              context.read<PropertiesListCubit>().applyAdvancedFilter(newFilter);
            },
            child: Icon(Icons.close_rounded, size: 14, color: context.primaryColor),
          ),
        ],
      ),
    );
  }
}

class _ActiveFilterInfo {
  final String key;
  final String label;
  const _ActiveFilterInfo(this.key, this.label);
}
