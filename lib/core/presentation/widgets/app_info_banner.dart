import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

enum AppInfoBannerType { info, warning }

/// An informational banner to explain read-only or limited sections.
/// Example: Contracts are read-only in the mobile app.
class AppInfoBanner extends StatelessWidget {
  final String messageKey;
  final IconData icon;
  final AppInfoBannerType type;

  const AppInfoBanner({
    super.key,
    required this.messageKey,
    this.icon = Icons.info_outline_rounded,
    this.type = AppInfoBannerType.info,
  });

  @override
  Widget build(BuildContext context) {
    final isWarning = type == AppInfoBannerType.warning;
    final color = isWarning ? AppColors.warning : AppColors.info;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              messageKey.tr(),
              style: TextStyle(
                color: color,
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
