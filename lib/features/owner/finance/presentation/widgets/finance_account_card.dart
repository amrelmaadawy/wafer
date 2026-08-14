import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wafer/core/theme/color_utils.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/finance_account_entity.dart';
import '../../domain/entities/finance_account_type.dart';

class FinanceAccountCard extends StatelessWidget {
  final FinanceAccountEntity account;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const FinanceAccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final name = context.locale.languageCode == 'ar' ? account.nameAr : account.nameEn;
    
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularXl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: context.primaryLight.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: AppRadius.circularMd,
                  ),
                  child: Text(
                    account.code,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontFamily: AppFonts.fontFamilyEn,
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Row(
                  children: [
                    _buildStatusBadge(context),
                    if (onEdit != null) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onEdit,
                        borderRadius: AppRadius.circularXxl,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTypeTag(context),
                const SizedBox(width: 8),
                if (account.isPostable) _buildPostableTag(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final color = account.isActive ? AppColors.success : AppColors.error;
    final text = account.isActive
        ? LocaleKeys.profile_active.tr()
        : LocaleKeys.profile_inactive.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTag(BuildContext context) {
    Color color;
    String label;
    switch (account.type) {
      case FinanceAccountType.asset:
        color = AppColors.success;
        label = LocaleKeys.owner_finance_assets.tr();
        break;
      case FinanceAccountType.liability:
        color = AppColors.error;
        label = LocaleKeys.owner_finance_liabilities.tr();
        break;
      case FinanceAccountType.expense:
        color = AppColors.warning;
        label = LocaleKeys.owner_finance_expenses.tr();
        break;
      case FinanceAccountType.revenue:
        color = AppColors.info;
        label = LocaleKeys.owner_finance_revenues.tr();
        break;
      case FinanceAccountType.equity:
        color = Colors.purple;
        label = LocaleKeys.owner_finance_equity.tr();
        break;
      default:
        color = AppColors.textSecondaryLight;
        label = account.type.value;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildPostableTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        LocaleKeys.owner_finance_postable.tr(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
