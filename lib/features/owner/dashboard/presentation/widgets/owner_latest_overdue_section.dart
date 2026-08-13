import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
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
          child: Row(
            children: [
              const Icon(
                Icons.warning_rounded,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                LocaleKeys.dashboard_latest_overdue.tr(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.appOnSurfaceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 140,
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
