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
      width: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: context.appBorderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3.5, color: AppColors.error),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            installment.tenantName.isEmpty
                                ? '-'
                                : installment.tenantName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.appOnSurfaceColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: AppRadius.circularFull,
                          ),
                          child: Text(
                            LocaleKeys.commonCurrencySar.tr(
                              args: [installment.amount.toStringAsFixed(0)],
                            ),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w800,
                            ),
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
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formattedDate(context),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          installment.contractNumber,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: context.appSecondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          Icon(icon, size: 13, color: context.appSecondaryTextColor),
          const SizedBox(width: 4),
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
