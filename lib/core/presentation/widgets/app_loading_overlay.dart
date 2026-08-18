import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';

/// A full-screen loading overlay shown during async operations.
/// Used when performing actions that block the entire screen.
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? messageKey;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.messageKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: context.appSurfaceColor,
                  borderRadius: AppRadius.circularMd,
                  border: Border.all(color: context.appBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: context.primaryColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                    if (messageKey != null) ...[
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        messageKey!.tr(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: context.appOnSurfaceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
