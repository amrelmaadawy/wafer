import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../domain/entities/legal_case_item_entity.dart';
import '../utils/legal_case_status_utils.dart';

class LegalCaseCardWidget extends StatelessWidget {
  final LegalCaseItemEntity legalCase;
  final VoidCallback onTap;
  final VoidCallback? onEditTap;

  const LegalCaseCardWidget({
    super.key,
    required this.legalCase,
    required this.onTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = LegalCaseStatusUtils.getStatusColor(
      legalCase.statusColor,
      context,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularXl,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularXl,
          boxShadow: [
            BoxShadow(
              color: context.primaryShadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: context.appBorderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, statusColor),
            const SizedBox(height: AppSpacing.sm),
            _buildCourtAndType(context),
            if (legalCase.latestStage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildLatestStage(context),
            ],
            const SizedBox(height: AppSpacing.sm),
            Divider(color: context.appBorderColor, height: 1),
            const SizedBox(height: AppSpacing.sm),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            legalCase.caseNumber ?? '',
            style: AppTextStyles.h4.copyWith(color: context.appOnSurfaceColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularMd,
              ),
              child: Text(
                legalCase.status ?? '',
                style: AppTextStyles.bodySmall.copyWith(
                  color: statusColor,
                  fontWeight: AppFonts.bold,
                ),
              ),
            ),
            if (onEditTap != null) ...[
              const SizedBox(width: AppSpacing.xs),
              InkWell(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.edit, size: 16, color: context.primaryColor),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCourtAndType(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.account_balance, size: 16, color: context.primaryColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${legalCase.court ?? ''} - ${legalCase.caseType ?? ''}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.appSecondaryTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLatestStage(BuildContext context) {
    final stageColor = LegalCaseStatusUtils.getStatusColor(
      legalCase.latestStage?.stageColor,
      context,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.appSubtleSurfaceColor,
        borderRadius: AppRadius.circularMd,
      ),
      child: Row(
        children: [
          Icon(Icons.timeline, size: 16, color: stageColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              legalCase.latestStage?.stageNameDisplay ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: AppFonts.bold,
                color: context.appOnSurfaceColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (legalCase.latestStage?.stageDate != null)
            Text(
              legalCase.latestStage!.stageDate!,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.appSecondaryTextColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (legalCase.amount != null && legalCase.amount! > 0)
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 16,
                color: context.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${legalCase.amount} ${LocaleKeys.currency.tr()}',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.primaryColor,
                  fontWeight: AppFonts.bold,
                ),
              ),
            ],
          )
        else
          const SizedBox(),
        if (legalCase.hearingDate != null)
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: context.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                legalCase.hearingDate!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.appSecondaryTextColor,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
