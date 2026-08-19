import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../models/drawer_navigation_item.dart';


class OwnerDrawerFooter extends StatelessWidget {
  final int currentBranchIndex;
  final ValueChanged<int> onSelectBranch;
  final bool isCollapsed;

  const OwnerDrawerFooter({
    super.key,
    required this.currentBranchIndex,
    required this.onSelectBranch,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          border: Border(
            top: BorderSide(
              color: context.appBorderColor.withValues(alpha: 0.6),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: LocaleKeys.drawerNavSettings.tr(),
              icon: Icon(
                Icons.settings_outlined,
                color: context.appSecondaryTextColor,
              ),
              onPressed: () {
                if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                  Navigator.of(context).pop();
                }
                onSelectBranch(OwnerDrawerConfig.branchSettings);
              },
            ),
            IconButton(
              tooltip: LocaleKeys.drawerNavLogout.tr(),
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
              ),
              onPressed: () => _confirmLogout(context),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFooterButton(
            context: context,
            icon: Icons.logout_rounded,
            label: LocaleKeys.drawerNavLogout.tr(),
            color: AppColors.error,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final effectiveColor = color ?? context.appSecondaryTextColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      child: Material(
        color: color != null ? color.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 20, color: effectiveColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: effectiveColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circularXl),
        backgroundColor: context.appSurfaceColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularMd,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                LocaleKeys.drawerLogoutConfirmTitle.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          LocaleKeys.drawerLogoutConfirmMessage.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.appSecondaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              LocaleKeys.drawerLogoutCancelBtn.tr(),
              style: TextStyle(color: context.appSecondaryTextColor),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                Navigator.of(context).pop();
              }
              context.read<AuthCubit>().logout();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(LocaleKeys.drawerLogoutConfirmBtn.tr()),
          ),
        ],
      ),
    );
  }
}
