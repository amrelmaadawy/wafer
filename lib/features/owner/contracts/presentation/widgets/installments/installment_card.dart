import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../domain/entities/contract_installment_entity.dart';
import 'installment_status_style.dart';

class InstallmentCard extends StatelessWidget {
  final ContractInstallmentEntity installment;

  const InstallmentCard({super.key, required this.installment});

  @override
  Widget build(BuildContext context) {
    final status = installmentStatusStyle(installment.status);
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.installmentsInstallmentNum.tr(
                    namedArgs: {'num': '${installment.installmentNumber}'},
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(status.icon, color: status.color, size: 17),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                installment.statusLabel.isEmpty
                    ? status.label
                    : installment.statusLabel,
                style: AppTextStyles.labelMedium.copyWith(color: status.color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: context.appSecondaryTextColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formattedDate(context),
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.appSecondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.appBorderColor, height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _Amount(
                label: LocaleKeys.installmentsAmount.tr(),
                value: installment.amount,
                color: context.appOnSurfaceColor,
              ),
              _Amount(
                label: LocaleKeys.installmentsPaid.tr(),
                value: installment.paidAmount,
                color: AppColors.success,
              ),
              _Amount(
                label: LocaleKeys.installmentsRemaining.tr(),
                value: installment.remaining,
                color: installment.remaining > 0
                    ? AppColors.warning
                    : context.appSecondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formattedDate(BuildContext context) {
    final date = DateTime.tryParse(installment.dueDate);
    if (date == null) {
      return installment.dueDate.isEmpty ? '-' : installment.dueDate;
    }
    return DateFormat.yMMMd(context.locale.toString()).format(date);
  }
}

class _Amount extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _Amount({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: context.appSecondaryTextColor,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
