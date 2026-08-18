import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_overdue_installment_card.dart';

class OwnerLatestOverdueSection extends StatelessWidget {
  final List<LatestOverdueInstallmentEntity> installments;

  const OwnerLatestOverdueSection({super.key, required this.installments});

  @override
  Widget build(BuildContext context) {
    if (installments.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.push(Routes.ownerDefaultersReport),
          borderRadius: AppRadius.circularSm,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularSm,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: 14,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                LocaleKeys.dashboard_latest_overdue.tr(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: context.appSecondaryTextColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: installments.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, index) =>
                OwnerOverdueInstallmentCard(installment: installments[index]),
          ),
        ),
      ],
    );
  }
}
