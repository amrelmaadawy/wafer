import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/units_status_item_entity.dart';

class PortfolioUnitCompactContent extends StatelessWidget {
  final String title;
  final String property;
  final Widget status;

  const PortfolioUnitCompactContent({
    super.key,
    required this.title,
    required this.property,
    required this.status,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.door_front_door_outlined, color: context.primaryColor),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              property,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      status,
      const SizedBox(width: AppSpacing.xs),
      const Icon(Icons.chevron_right_rounded, size: 20),
    ],
  );
}

class PortfolioUnitComfortableContent extends StatelessWidget {
  final UnitsStatusItemEntity unit;
  final String title;
  final String property;
  final Widget status;

  const PortfolioUnitComfortableContent({
    super.key,
    required this.unit,
    required this.title,
    required this.property,
    required this.status,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: .1),
              borderRadius: AppRadius.circularMd,
            ),
            child: Icon(
              Icons.door_front_door_outlined,
              color: context.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          status,
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      Divider(color: context.appBorderColor, height: 1),
      const SizedBox(height: AppSpacing.sm),
      _Info(icon: Icons.apartment_rounded, text: property),
      if (unit.floorNumber != null) ...[
        const SizedBox(height: 6),
        _Info(
          icon: Icons.layers_rounded,
          text: LocaleKeys.unit_details_floor_prefix.tr(
            args: ['${unit.floorNumber}'],
          ),
        ),
      ],
    ],
  );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: context.appSecondaryTextColor),
      const SizedBox(width: AppSpacing.xs),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ],
  );
}
