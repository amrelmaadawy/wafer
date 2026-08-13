import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';
import 'property_metric_card.dart';

class PropertyDetailsMetricsBar extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyDetailsMetricsBar({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final cards = _cards(context);
    if (context.isCompact) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(
          context.pagePadding,
          AppSpacing.sm,
          context.pagePadding,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            for (final card in cards) ...[
              card,
              const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      );
    }
    return AppResponsiveContent(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: cards,
        ),
      ),
    );
  }

  List<Widget> _cards(BuildContext context) => [
    PropertyMetricCard(
      label: LocaleKeys.propertyDetailsTotalUnits.tr(),
      value: '${property.unitsCount}',
      subtext:
          '${property.rentedUnits} ${LocaleKeys.propertyDetailsRentedUnits.tr()} · ${property.availableUnits} ${LocaleKeys.propertyDetailsAvailableUnitsLabel.tr()}',
      icon: Icons.meeting_room_rounded,
      color: context.primaryColor,
      backgroundColor: context.primarySubtle,
    ),
    PropertyMetricCard(
      label: LocaleKeys.propertyDetailsOccupancyRate.tr(),
      value: '${property.occupancyRate.toStringAsFixed(0)}%',
      subtext: LocaleKeys.propertyDetailsOccupancyRateSub.tr(),
      icon: Icons.pie_chart_rounded,
      color: AppColors.success,
      backgroundColor: AppColors.success.withValues(alpha: 0.1),
    ),
    if (property.area != null)
      PropertyMetricCard(
        label: LocaleKeys.propertyDetailsTotalArea.tr(),
        value: '${property.area} ${LocaleKeys.propertyDetailsAreaUnit.tr()}',
        subtext: property.length != null && property.width != null
            ? '${property.length}m × ${property.width}m'
            : LocaleKeys.propertyDetailsTotalArea.tr(),
        icon: Icons.square_foot_rounded,
        color: AppColors.accent,
        backgroundColor: AppColors.accent.withValues(alpha: 0.1),
      ),
    if (property.valuationAmount != null)
      PropertyMetricCard(
        label: LocaleKeys.propertyDetailsValuationAmount.tr(),
        value:
            '${property.valuationAmount} ${LocaleKeys.propertyDetailsValuationCurrency.tr()}',
        subtext:
            property.valuationEntity ??
            LocaleKeys.propertyDetailsValuationApproved.tr(),
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.warning,
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      ),
  ];
}
