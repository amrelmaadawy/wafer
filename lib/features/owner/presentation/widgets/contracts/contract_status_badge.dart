import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class ContractStatusBadge extends StatelessWidget {
  final String status;

  const ContractStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase().trim();

    Color bg;
    Color fg;
    String labelKey;

    switch (lower) {
      case 'active':
      case 'sari':
        bg = AppColors.success.withValues(alpha: 0.12);
        fg = AppColors.success;
        labelKey = LocaleKeys.contractsStatusActive;
        break;
      case 'expiring':
      case 'expiring_soon':
        bg = AppColors.warning.withValues(alpha: 0.12);
        fg = AppColors.warning;
        labelKey = LocaleKeys.contractsStatusExpiring;
        break;
      case 'draft':
        bg = AppColors.borderLight;
        fg = AppColors.textSecondaryLight;
        labelKey = LocaleKeys.contractsStatusDraft;
        break;
      case 'terminated':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        labelKey = LocaleKeys.contractsStatusTerminated;
        break;
      case 'cancelled':
        bg = AppColors.error.withValues(alpha: 0.12);
        fg = AppColors.error;
        labelKey = LocaleKeys.contractsStatusCancelled;
        break;
      case 'renewed':
        bg = AppColors.info.withValues(alpha: 0.12);
        fg = AppColors.info;
        labelKey = LocaleKeys.contractsStatusRenewed;
        break;
      default:
        bg = AppColors.borderLight;
        fg = AppColors.textPrimaryLight;
        labelKey = LocaleKeys.contractsStatusActive;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.circularSm,
      ),
      child: Text(
        labelKey.tr(),
        style: TextStyle(
          color: fg,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
