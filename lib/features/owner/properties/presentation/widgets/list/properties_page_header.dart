import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';

class PropertiesPageHeader extends StatelessWidget {
  const PropertiesPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.pagePadding,
        AppSpacing.md,
        context.pagePadding,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.propertiesTitle.tr(),
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            LocaleKeys.propertiesSubtitle.tr(),
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
