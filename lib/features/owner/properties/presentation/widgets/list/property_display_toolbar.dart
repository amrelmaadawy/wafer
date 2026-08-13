import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_durations.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_display_mode.dart';

class PropertyDisplayToolbar extends StatelessWidget {
  final int total;
  final PropertyDisplayMode mode;
  final ValueChanged<PropertyDisplayMode> onChanged;

  const PropertyDisplayToolbar({
    super.key,
    required this.total,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.pagePadding,
        AppSpacing.xs,
        context.pagePadding,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${LocaleKeys.propertiesTotalCount.tr()}: $total',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Semantics(
            container: true,
            label: LocaleKeys.propertiesDisplayOptions.tr(),
            child: Container(
              key: const Key('property-display-mode'),
              padding: const EdgeInsets.all(AppSpacing.xxs),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.circularFull,
                border: Border.all(color: AppColors.borderLight),
                boxShadow: AppShadows.cardLight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DisplayOption(
                    label: LocaleKeys.propertiesViewComfortable.tr(),
                    icon: Icons.grid_view_rounded,
                    selected: mode == PropertyDisplayMode.comfortable,
                    onTap: () => onChanged(PropertyDisplayMode.comfortable),
                  ),
                  _DisplayOption(
                    label: LocaleKeys.propertiesViewCompact.tr(),
                    icon: Icons.view_list_rounded,
                    selected: mode == PropertyDisplayMode.compact,
                    onTap: () => onChanged(PropertyDisplayMode.compact),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _DisplayOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : AppColors.textSecondaryLight;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: AppRadius.circularFull,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected ? context.primaryColor : Colors.transparent,
            borderRadius: AppRadius.circularFull,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: context.primaryShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: foreground),
              const SizedBox(width: AppSpacing.xs),
              AnimatedDefaultTextStyle(
                duration: AppDurations.fast,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
