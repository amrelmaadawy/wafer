import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/properties_query_filter_entity.dart';
import '../../cubit/filter_options/property_filter_options_cubit.dart';
import '../../cubit/filter_options/property_filter_options_state.dart';
import '../../cubit/list/properties_list_cubit.dart';
import '../../cubit/list/properties_list_state.dart';
import 'property_active_filter.dart';
import 'property_active_filter_chip.dart';

class ActiveFilterBar extends StatelessWidget {
  const ActiveFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesListCubit, PropertiesListState>(
      builder: (context, state) {
        final current = context.read<PropertiesListCubit>().currentFilter;
        final optionsState = context.watch<PropertyFilterOptionsCubit>().state;
        final options = optionsState is PropertyFilterOptionsLoaded
            ? optionsState.options
            : null;
        final filters = PropertyActiveFilterResolver.resolve(current, options);
        if (filters.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${LocaleKeys.propertiesFilterTitle.tr()} (${filters.length})',
                      style: AppTextStyles.labelMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<PropertiesListCubit>().applyAdvancedFilter(
                          const PropertiesQueryFilterEntity(),
                        ),
                    child: Text(
                      LocaleKeys.propertiesResetFilter.tr(),
                      style: TextStyle(color: context.primaryColor),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: filters
                    .map(
                      (filter) => PropertyActiveFilterChip(
                        filter: filter,
                        current: current,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
