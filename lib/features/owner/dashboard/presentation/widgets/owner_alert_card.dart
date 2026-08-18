import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';

class OwnerAlertCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final IconData icon;
  final bool highlight;
  final VoidCallback? onTap;

  const OwnerAlertCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    required this.icon,
    this.highlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const Spacer(),
              if (highlight)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: AppTextStyles.h3.copyWith(
                  color: highlight ? color : context.appOnSurfaceColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: highlight ? color : context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: context.appSecondaryTextColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
