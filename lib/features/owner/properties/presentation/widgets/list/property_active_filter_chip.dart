import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../cubit/list/properties_list_cubit.dart';
import 'property_active_filter.dart';

class PropertyActiveFilterChip extends StatelessWidget {
  final PropertyActiveFilter filter;
  final PropertiesQueryFilterEntity current;

  const PropertyActiveFilterChip({
    super.key,
    required this.filter,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.primaryFaint,
        borderRadius: AppRadius.circularFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filter.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          InkWell(
            onTap: () => context
                .read<PropertiesListCubit>()
                .applyAdvancedFilter(_remove()),
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  PropertiesQueryFilterEntity _remove() => switch (filter.key) {
    'status' => current.copyWith(status: () => null),
    'propertyType' => current.copyWith(propertyType: () => null),
    'usageType' => current.copyWith(usageType: () => null),
    'branch' => current.copyWith(branchId: () => null, deedId: () => null),
    'deed' => current.copyWith(deedId: () => null),
    'sort' => current.copyWith(sortBy: () => null, sortAscending: true),
    _ => current,
  };
}
