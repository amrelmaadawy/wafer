import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../cubit/owner_activity_logs_cubit.dart';

class ActivityLogsFilterBar extends StatelessWidget {
  const ActivityLogsFilterBar({
    super.key,
    required this.types,
    required this.actions,
  });

  final List<String> types;
  final List<String> actions;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerActivityLogsCubit>();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appSubtleSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorderColor),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fields = [
            _FilterMenu(
              icon: Icons.category_outlined,
              value: cubit.selectedType,
              allLabel: LocaleKeys.activityLogsAllTypes.tr(),
              options: types,
              onChanged: (value) =>
                  cubit.setFilters(type: value, action: cubit.selectedAction),
            ),
            _FilterMenu(
              icon: Icons.bolt_outlined,
              value: cubit.selectedAction,
              allLabel: LocaleKeys.activityLogsAllActions.tr(),
              options: actions,
              onChanged: (value) =>
                  cubit.setFilters(type: cubit.selectedType, action: value),
            ),
          ];
          if (constraints.maxWidth < 560) {
            return Column(
              children: [
                ...fields.expand(
                  (field) => [field, const SizedBox(height: AppSpacing.xs)],
                ),
                if (cubit.hasActiveFilters) _resetButton(context, cubit),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: fields.first),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: fields.last),
              if (cubit.hasActiveFilters) ...[
                const SizedBox(width: AppSpacing.sm),
                _resetButton(context, cubit),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _resetButton(BuildContext context, OwnerActivityLogsCubit cubit) =>
      IconButton.outlined(
        onPressed: cubit.clearFilters,
        tooltip: LocaleKeys.reports_resetFilters.tr(),
        icon: const Icon(Icons.filter_alt_off_rounded),
      );
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.icon,
    required this.value,
    required this.allLabel,
    required this.options,
    required this.onChanged,
  });

  final IconData icon;
  final String? value;
  final String allLabel;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  static const _allValue = '__all__';

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    initialValue: value,
    onSelected: (selected) =>
        onChanged(selected == _allValue ? null : selected),
    itemBuilder: (_) => [
      PopupMenuItem<String>(value: _allValue, child: Text(allLabel)),
      ...options.map(
        (option) => PopupMenuItem<String>(value: option, child: Text(option)),
      ),
    ],
    child: Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appBorderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.appSecondaryTextColor),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              value ?? allLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded),
        ],
      ),
    ),
  );
}
