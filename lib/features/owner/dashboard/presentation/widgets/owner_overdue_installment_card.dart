import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';

class OwnerOverdueInstallmentCard extends StatelessWidget {
  final LatestOverdueInstallmentEntity installment;

  const OwnerOverdueInstallmentCard({super.key, required this.installment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  installment.tenantName.isEmpty ? '-' : installment.tenantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appOnSurfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                LocaleKeys.commonCurrencySar.tr(
                  args: [installment.amount.toStringAsFixed(0)],
                ),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _InfoRow(
            icon: Icons.business_rounded,
            text: installment.propertyName,
          ),
          _InfoRow(
            icon: Icons.door_front_door_outlined,
            text: installment.unitName,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  installment.contractNumber,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
              ),
              Text(
                _formattedDate(context),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formattedDate(BuildContext context) {
    final date = DateTime.tryParse(installment.dueDate);
    if (date == null) return installment.dueDate;
    return DateFormat.yMMMd(context.locale.toString()).format(date);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: context.appSecondaryTextColor),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                color: context.appSecondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
