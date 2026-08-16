import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/color_utils.dart';
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
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              isDangerous ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
              color: isDangerous ? AppColors.error : context.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              titleKey.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              messageKey.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (impactKey != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        impactKey!.tr(),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
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
                const SizedBox(width: 12),
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
