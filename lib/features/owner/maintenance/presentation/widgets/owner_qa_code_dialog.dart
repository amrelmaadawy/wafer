import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/theme/color_utils.dart';

class OwnerQaCodeDialog extends StatelessWidget {
  final String qaCode;

  const OwnerQaCodeDialog({
    super.key,
    required this.qaCode,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified,
                color: context.primaryColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.maintenanceQaCodeTitle.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.maintenanceQaCodeDesc.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: AppRadius.circularMd,
                border: Border.all(color: context.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    qaCode,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: qaCode));
                      AppToast.showSuccess(context, LocaleKeys.maintenanceQaCodeCopied.tr());
                    },
                    icon: const Icon(Icons.copy, size: 20),
                    label: Text(LocaleKeys.maintenanceCopyQaCode.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.primaryColor,
                      side: BorderSide(color: context.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circularMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.circularMd,
                      ),
                    ),
                    child: Text(
                      LocaleKeys.common_success.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
