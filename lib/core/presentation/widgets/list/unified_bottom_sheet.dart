import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../localization/locale_keys.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/color_utils.dart';
import '../../../theme/theme_context.dart';

/// A standardized, beautifully designed modal bottom sheet frame for filters and dialogs.
class UnifiedBottomSheet extends StatelessWidget {
  final String titleLocaleKey;
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final String? applyLocaleKey;
  final String? resetLocaleKey;
  final IconData? titleIcon;

  const UnifiedBottomSheet({
    super.key,
    required this.titleLocaleKey,
    required this.child,
    required this.onApply,
    required this.onReset,
    this.applyLocaleKey,
    this.resetLocaleKey,
    this.titleIcon,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;
    final maxSheetHeight = MediaQuery.of(context).size.height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: context.appBorderColor,
                borderRadius: AppRadius.circularFull,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularMd,
                    ),
                    child: Icon(
                      titleIcon ?? Icons.tune_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titleLocaleKey.tr(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: context.appOnSurfaceColor,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: AppRadius.circularFull,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: context.appBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.appBorderColor.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: context.appSecondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.appBorderColor),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: child,
              ),
            ),
            Divider(height: 1, color: context.appBorderColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.rotate_left_rounded, size: 18),
                        label: Text(
                          (resetLocaleKey ?? LocaleKeys.filterReset).tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.appSecondaryTextColor,
                          side: BorderSide(
                            color: context.appBorderColor.withValues(alpha: 0.8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onApply();
                        },
                        icon: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
                        label: Text(
                          (applyLocaleKey ?? LocaleKeys.filterApply).tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
