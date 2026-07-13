import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileContactCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileContactCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.contact_mail_rounded, color: context.primaryColor, size: 22),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.profileContactAndAccountInfo.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRow(
            context: context,
            icon: Icons.phone_android_rounded,
            label: LocaleKeys.profilePhone.tr(),
            value: profile.phone,
            canCopy: true,
          ),
          const Divider(height: 24, color: AppColors.borderLight),
          _buildRow(
            context: context,
            icon: Icons.email_rounded,
            label: LocaleKeys.profileEmail.tr(),
            value: profile.email,
            canCopy: true,
          ),
          const Divider(height: 24, color: AppColors.borderLight),
          _buildRow(
            context: context,
            icon: Icons.person_outline_rounded,
            label: LocaleKeys.profileGender.tr(),
            value: _getGenderLabel(profile.gender),
            canCopy: false,
          ),
          const Divider(height: 24, color: AppColors.borderLight),
          _buildRow(
            context: context,
            icon: Icons.calendar_today_rounded,
            label: LocaleKeys.profileJoinedDate.tr(),
            value: profile.joinedAt,
            canCopy: false,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool canCopy,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondaryLight),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : LocaleKeys.profileUnspecified.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        if (canCopy && value.isNotEmpty)
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              AppToast.showSuccess(
                context,
                LocaleKeys.profileCopySuccess.tr(args: [label]),
                title: LocaleKeys.profileCopiedTitle.tr(),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.copy_rounded, size: 16, color: context.primaryColor),
            ),
          ),
      ],
    );
  }

  String _getGenderLabel(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return LocaleKeys.profileGenderMale.tr();
      case 'female':
        return LocaleKeys.profileGenderFemale.tr();
      default:
        return gender;
    }
  }
}
