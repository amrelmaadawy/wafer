import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';
import '../../utils/widgets/custom_button.dart';

/// A standardized confirmation dialog for destructive actions.
/// MUST be used for all: Delete, Cancel, Reject, Reverse, Remove operations.
class AppConfirmDialog extends StatelessWidget {
  final String titleKey;
  final String messageKey;
  final String? impactKey;
  final String confirmKey;
  final String cancelKey;
  final VoidCallback onConfirm;
  final bool isDangerous;

  const AppConfirmDialog({
    super.key,
    required this.titleKey,
    required this.messageKey,
    this.impactKey,
    this.confirmKey = LocaleKeys.commonConfirm,
    this.cancelKey = LocaleKeys.commonCancel,
    required this.onConfirm,
    this.isDangerous = true,
  });

  /// Convenience static method to show the dialog
  static Future<bool?> show({
    required BuildContext context,
    required String titleKey,
    required String messageKey,
    String? impactKey,
    String confirmKey = LocaleKeys.commonConfirm,
    String cancelKey = LocaleKeys.commonCancel,
    bool isDangerous = true,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        titleKey: titleKey,
        messageKey: messageKey,
        impactKey: impactKey,
        confirmKey: confirmKey,
        cancelKey: cancelKey,
        onConfirm: () => Navigator.of(context).pop(true),
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
      backgroundColor: context.appSurfaceColor,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              isDangerous ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
              color: isDangerous ? AppColors.error : context.primaryColor,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              titleKey.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appOnSurfaceColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              messageKey.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.appSecondaryTextColor,
                height: 1.5,
              ),
            ),
            if (impactKey != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.error, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        impactKey!.tr(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    text: cancelKey.tr(),
                    type: ButtonType.secondary,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: CustomButton(
                    onPressed: onConfirm,
                    text: confirmKey.tr(),
                    backgroundColor: isDangerous ? AppColors.error : context.primaryColor,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
