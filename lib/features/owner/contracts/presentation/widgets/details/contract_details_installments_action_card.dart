import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../screens/owner_contract_installments_screen.dart';

class ContractDetailsInstallmentsActionCard extends StatelessWidget {
  final String contractId;
  final String contractNumber;
  final int? installmentsCount;

  const ContractDetailsInstallmentsActionCard({
    super.key,
    required this.contractId,
    this.contractNumber = '',
    this.installmentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OwnerContractInstallmentsScreen(
            contractId: contractId,
            contractNumber: contractNumber,
          ),
        ),
      ),
      borderRadius: AppRadius.circularXxl,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet_rounded, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.installmentsTitle.tr(),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    installmentsCount != null
                        ? LocaleKeys.installmentsCountLabel.tr(
                            namedArgs: {'count': '$installmentsCount'},
                          )
                        : LocaleKeys.installmentsCardSubtitle.tr(),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: AppRadius.circularMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.installmentsViewBtn.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
