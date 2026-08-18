import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_context.dart';
import '../../utils/widgets/custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? title;
  final bool isLoading;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(color: context.appBorderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 36,
                    color: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title ?? LocaleKeys.errorsServerError.tr(),
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.appOnSurfaceColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.appSecondaryTextColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: LocaleKeys.commonRetry.tr(),
                  onPressed: onRetry,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
