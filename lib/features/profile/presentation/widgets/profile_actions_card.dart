import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../screens/edit_profile_screen.dart';

class ProfileActionsCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileActionsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune_rounded, color: context.primaryColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  LocaleKeys.profileAccountSettings.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.borderLight),
          _buildTile(
            context: context,
            icon: Icons.edit_rounded,
            label: LocaleKeys.profileEditProfile.tr(),
            subtitle: LocaleKeys.profileEditProfileSubtitle.tr(),
            iconBg: context.primaryColor.withValues(alpha: 0.1),
            iconColor: context.primaryColor,
            onTap: () {
              final cubit = context.read<ProfileCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    cubit: cubit,
                    profile: profile,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, color: AppColors.borderLight, indent: 20, endIndent: 20),
          _buildTile(
            context: context,
            icon: Icons.lock_outline_rounded,
            label: LocaleKeys.profileChangePassword.tr(),
            subtitle: LocaleKeys.profileChangePasswordSubtitle.tr(),
            iconBg: AppColors.warning.withValues(alpha: 0.1),
            iconColor: AppColors.warning,
            onTap: () => AppToast.showInfo(context, LocaleKeys.profileChangePasswordToast.tr()),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          _buildTile(
            context: context,
            icon: Icons.logout_rounded,
            label: LocaleKeys.profileLogout.tr(),
            subtitle: LocaleKeys.profileLogoutSubtitle.tr(),
            iconBg: AppColors.error.withValues(alpha: 0.1),
            iconColor: AppColors.error,
            labelColor: AppColors.error,
            onTap: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: labelColor ?? AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryLight.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppToast.showInfo(context, LocaleKeys.profileLogoutDialogMsg.tr());
  }
}
