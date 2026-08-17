import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class MaintenancePendingActionBadge extends StatelessWidget {
  final String localeKey;

  const MaintenancePendingActionBadge({
    super.key,
    required this.localeKey,
  });

  @override
  Widget build(BuildContext context) {
    if (localeKey.isEmpty) return const SizedBox.shrink();

    final primary = context.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.circularMd,
        border: Border.all(
          color: primary.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pending_actions_rounded,
            size: 14,
            color: primary,
          ),
          const SizedBox(width: 5),
          Text(
            localeKey.tr(),
            style: AppTextStyles.labelMedium.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
