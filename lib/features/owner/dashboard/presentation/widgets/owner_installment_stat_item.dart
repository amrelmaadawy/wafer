import 'package:flutter/material.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class OwnerInstallmentStatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const OwnerInstallmentStatItem({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: color.withValues(alpha: 0.16)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
            ),
            Text('$count', style: AppTextStyles.h4.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
