import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/portfolio_units_display_mode.dart';

class PortfolioUnitsToolbar extends StatelessWidget {
  final int total;
  final PortfolioUnitsDisplayMode mode;
  final ValueChanged<PortfolioUnitsDisplayMode> onChanged;

  const PortfolioUnitsToolbar({
    super.key,
    required this.total,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            LocaleKeys.reports_unitsResults.tr(args: ['$total']),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xxs),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularFull,
            border: Border.all(color: context.appBorderColor),
          ),
          child: Row(
            children: [
              _Option(
                icon: Icons.grid_view_rounded,
                label: LocaleKeys.reports_unitsCards.tr(),
                selected: mode == PortfolioUnitsDisplayMode.cards,
                onTap: () => onChanged(PortfolioUnitsDisplayMode.cards),
              ),
              _Option(
                icon: Icons.view_list_rounded,
                label: LocaleKeys.reports_unitsCompact.tr(),
                selected: mode == PortfolioUnitsDisplayMode.compact,
                onTap: () => onChanged(PortfolioUnitsDisplayMode.compact),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Option({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : context.appSecondaryTextColor;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: AppRadius.circularFull,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? context.primaryColor : Colors.transparent,
            borderRadius: AppRadius.circularFull,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
