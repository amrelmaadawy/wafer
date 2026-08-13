import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/utils/launcher_utils.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../domain/entities/contract_details_entity.dart';
import 'contract_contact_button.dart';
import 'contract_section_header.dart';

class ContractDetailsRenterCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractDetailsRenterCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractSectionHeader(
            icon: Icons.person_outline_rounded,
            title: LocaleKeys.contractsSectionRenter.tr(),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.primaryColor.withValues(alpha: 0.12),
                foregroundColor: context.primaryColor,
                child: Text(_initial),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.renterName.isEmpty ? '-' : contract.renterName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.appOnSurfaceColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (contract.renterPhone.isNotEmpty)
                      Text(
                        contract.renterPhone,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.appSecondaryTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (contract.renterPhone.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ContractContactButton(
                  label: LocaleKeys.contractsActionCall.tr(),
                  icon: Icons.phone_in_talk_rounded,
                  color: context.primaryColor,
                  onTap: () => _launch(
                    context,
                    LauncherUtils.makePhoneCall(contract.renterPhone),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ContractContactButton(
                  label: LocaleKeys.contractsActionWhatsapp.tr(),
                  icon: Icons.chat_rounded,
                  color: AppColors.success,
                  onTap: () => _launch(
                    context,
                    LauncherUtils.openWhatsApp(contract.renterPhone),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String get _initial =>
      contract.renterName.isEmpty ? '-' : contract.renterName[0].toUpperCase();

  Future<void> _launch(BuildContext context, Future<bool> action) async {
    if (!await action && context.mounted) {
      AppToast.showError(context, LocaleKeys.contractsLauncherError.tr());
    }
  }
}
