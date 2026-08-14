import 'package:flutter/material.dart';
import '../../../../../core/theme/app_breakpoints.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/portfolio_units_display_mode.dart';
import '../../domain/entities/units_status_item_entity.dart';
import 'portfolio_unit_card.dart';

class PortfolioUnitsList extends StatelessWidget {
  final List<UnitsStatusItemEntity> units;
  final PortfolioUnitsDisplayMode mode;
  final ValueChanged<UnitsStatusItemEntity> onTap;

  const PortfolioUnitsList({
    super.key,
    required this.units,
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == PortfolioUnitsDisplayMode.compact) {
      return Column(
        children: units
            .map(
              (unit) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: PortfolioUnitCard(
                  unit: unit,
                  compact: true,
                  onTap: () => onTap(unit),
                ),
              ),
            )
            .toList(),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    final count = width >= AppBreakpoints.expanded
        ? 3
        : width >= AppBreakpoints.compact
        ? 2
        : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 174,
      ),
      itemBuilder: (_, index) => PortfolioUnitCard(
        unit: units[index],
        compact: false,
        onTap: () => onTap(units[index]),
      ),
    );
  }
}
