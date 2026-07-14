import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../domain/entities/contract_installment_entity.dart';

class InstallmentCard extends StatelessWidget {
  final ContractInstallmentEntity installment;

  const InstallmentCard({super.key, required this.installment});

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(installment.status);
    final primaryColor = context.primaryColor;
    final isOverdue = installment.status == 'overdue';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: isOverdue
            ? Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 1.5)
            : Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: isOverdue
                ? AppColors.error.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Text(
                  LocaleKeys.installmentsInstallmentNum.tr(
                    namedArgs: {'num': '${installment.installmentNumber}'},
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusConfig.color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularMd,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusConfig.icon, size: 14, color: statusConfig.color),
                    const SizedBox(width: 4),
                    Text(
                      installment.statusLabel.isNotEmpty
                          ? installment.statusLabel
                          : statusConfig.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: statusConfig.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(width: 6),
              Text(
                '${LocaleKeys.installmentsDueDate.tr()}: ',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
              ),
              Text(
                _formatDate(installment.dueDate),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isOverdue ? AppColors.error : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildValueColumn(
                label: LocaleKeys.installmentsAmount.tr(),
                value: installment.amount,
                color: AppColors.textPrimaryLight,
              ),
              _buildValueColumn(
                label: LocaleKeys.installmentsPaid.tr(),
                value: installment.paidAmount,
                color: const Color(0xFF1EBE5D),
              ),
              _buildValueColumn(
                label: LocaleKeys.installmentsRemaining.tr(),
                value: installment.remaining,
                color: installment.remaining > 0 ? AppColors.warning : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueColumn({required String label, required double value, required Color color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(2)} ${LocaleKeys.contractsCurrency.tr()}',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return '-';
    try {
      final parts = isoDate.split('-');
      if (parts.length != 3) return isoDate;
      final months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      final month = int.tryParse(parts[1]) ?? 1;
      return '${parts[2]} ${months[month - 1]} ${parts[0]}';
    } catch (_) {
      return isoDate;
    }
  }

  ({Color color, IconData icon, String label}) _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return (
          color: const Color(0xFF1EBE5D),
          icon: Icons.check_circle_rounded,
          label: LocaleKeys.installmentsStatusPaid.tr(),
        );
      case 'overdue':
        return (
          color: AppColors.error,
          icon: Icons.error_rounded,
          label: LocaleKeys.installmentsStatusOverdue.tr(),
        );
      case 'partially_paid':
        return (
          color: AppColors.info,
          icon: Icons.timelapse_rounded,
          label: LocaleKeys.installmentsStatusPartial.tr(),
        );
      case 'unpaid':
      default:
        return (
          color: AppColors.warning,
          icon: Icons.schedule_rounded,
          label: LocaleKeys.installmentsStatusUnpaid.tr(),
        );
    }
  }
}
