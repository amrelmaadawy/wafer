import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileIdentityCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileIdentityCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isExpiring = _checkIsExpiring(profile.identityExpiry);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_rounded, color: context.primaryColor, size: 22),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.profileIdentitySection.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildItemRow(
            context: context,
            label: LocaleKeys.profileIdentityNumber.tr(),
            value: profile.identityNumber,
            canCopy: true,
          ),
          const Divider(height: 24, color: AppColors.borderLight),
          _buildItemRow(
            context: context,
            label: LocaleKeys.profileIdentityExpiry.tr(),
            value: profile.identityExpiry,
            canCopy: false,
          ),
          if (isExpiring) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularLg,
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      LocaleKeys.profileIdentityWarningBanner.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool canCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        Row(
          children: [
            Text(
              value.isNotEmpty ? value : LocaleKeys.profileUnspecified.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (canCopy && value.isNotEmpty) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  AppToast.showSuccess(
                    context,
                    LocaleKeys.profileCopySuccess.tr(args: [label]),
                    title: LocaleKeys.profileCopiedTitle.tr(),
                  );
                },
                child: Icon(Icons.copy_rounded, size: 18, color: context.primaryColor),
              ),
            ],
          ],
        ),
      ],
    );
  }

  bool _checkIsExpiring(String expiryDate) {
    if (expiryDate.isEmpty) return false;
    try {
      final date = DateTime.parse(expiryDate);
      final diff = date.difference(DateTime.now()).inDays;
      return diff <= 30;
    } catch (_) {
      return false;
    }
  }
}
