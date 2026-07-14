import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';

class InstallmentsEmptyWidget extends StatelessWidget {
  const InstallmentsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_rounded, size: 56, color: primaryColor),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.installmentsEmptyTitle.tr(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.installmentsEmptySubtitle.tr(),
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
