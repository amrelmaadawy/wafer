import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/launcher_utils.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../domain/entities/contract_details_entity.dart';

class ContractDetailsRenterCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsRenterCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline_rounded, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.contractsSectionRenter.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: Text(
                  contract.renterName.isNotEmpty ? contract.renterName[0].toUpperCase() : 'M',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.renterName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    if (contract.renterPhone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${LocaleKeys.contractsRenterPhone.tr()} ${contract.renterPhone}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (contract.renterPhone.isNotEmpty) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildContactActionButton(
                    context: context,
                    title: LocaleKeys.contractsActionCall.tr(),
                    icon: Icons.phone_in_talk_rounded,
                    color: primaryColor,
                    onTap: () async {
                      final success = await LauncherUtils.makePhoneCall(contract.renterPhone);
                      if (!success && context.mounted) {
                        AppToast.showError(
                          context,
                          LocaleKeys.contractsLauncherError.tr(),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContactActionButton(
                    context: context,
                    title: LocaleKeys.contractsActionWhatsapp.tr(),
                    icon: Icons.chat_rounded,
                    color: const Color(0xFF1EBE5D),
                    onTap: () async {
                      final success = await LauncherUtils.openWhatsApp(contract.renterPhone);
                      if (!success && context.mounted) {
                        AppToast.showError(
                          context,
                          LocaleKeys.contractsLauncherError.tr(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.07),
      borderRadius: AppRadius.circularLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularLg,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadius.circularLg,
            border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
