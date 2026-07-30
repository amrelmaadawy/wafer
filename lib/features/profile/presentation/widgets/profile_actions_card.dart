import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../domain/entities/profile_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'profile_action_tile.dart';
import 'theme_color_selector_bottom_sheet.dart';

class ProfileActionsCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileActionsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AppToast.showError(context, state.message);
          } else if (state is Unauthenticated) {
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: AppRadius.circularXxl,
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
                          borderRadius: AppRadius.circularMd,
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: context.primaryColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.profile_account_settings.tr(),
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
                ProfileActionTile(
                  icon: Icons.edit_rounded,
                  label: LocaleKeys.profile_edit_profile.tr(),
                  subtitle: LocaleKeys.profile_edit_profile_subtitle.tr(),
                  iconBg: context.primaryColor.withValues(alpha: 0.1),
                  iconColor: context.primaryColor,
                  onTap: () {
                    context.push(
                      Routes.editProfile,
                      extra: {'profile': profile},
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: AppColors.borderLight,
                  indent: 20,
                  endIndent: 20,
                ),
                ProfileActionTile(
                  icon: Icons.bar_chart_rounded,
                  label: LocaleKeys.reports_title.tr(),
                  subtitle: LocaleKeys.reports_operational
                      .tr(), // Or some general subtitle
                  iconBg: AppColors.info.withValues(alpha: 0.1),
                  iconColor: AppColors.info,
                  onTap: () {
                    context.push(Routes.ownerReportsCenter);
                  },
                ),
                const Divider(
                  height: 1,
                  color: AppColors.borderLight,
                  indent: 20,
                  endIndent: 20,
                ),
                ProfileActionTile(
                  icon: Icons.palette_rounded,
                  label: LocaleKeys.profile_theme_color.tr(),
                  subtitle: LocaleKeys.profile_theme_color_subtitle.tr(),
                  iconBg: context.primaryColor.withValues(alpha: 0.1),
                  iconColor: context.primaryColor,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          const ThemeColorSelectorBottomSheet(),
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  color: AppColors.borderLight,
                  indent: 20,
                  endIndent: 20,
                ),
                ProfileActionTile(
                  icon: Icons.lock_outline_rounded,
                  label: LocaleKeys.profile_change_password.tr(),
                  subtitle: LocaleKeys.profile_change_password_subtitle.tr(),
                  iconBg: AppColors.warning.withValues(alpha: 0.1),
                  iconColor: AppColors.warning,
                  onTap: () {
                    context.push(Routes.changePassword);
                  },
                ),

                const Divider(height: 1, color: AppColors.borderLight),
                ProfileActionTile(
                  icon: Icons.logout_rounded,
                  label: LocaleKeys.profile_logout.tr(),
                  subtitle: LocaleKeys.profile_logout_subtitle.tr(),
                  iconBg: AppColors.error.withValues(alpha: 0.1),
                  iconColor: AppColors.error,
                  labelColor: AppColors.error,
                  onTap: () =>
                      _showLogoutDialog(context, context.read<AuthCubit>()),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthCubit authCubit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                Navigator.pop(dialogContext);
                AppToast.showError(context, state.message);
              } else if (state is Unauthenticated) {
                Navigator.pop(dialogContext);
                context.go(Routes.login);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Dialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.circularXl,
                ),
                backgroundColor: AppColors.backgroundLight,
                insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Warning Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.error,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        LocaleKeys.profile_logout.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Body
                      Text(
                        LocaleKeys.profile_logout_dialog_msg.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(dialogContext),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: AppColors.borderLight,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.circularLg,
                                ),
                                foregroundColor: AppColors.textPrimaryLight,
                              ),
                              child: Text(
                                LocaleKeys.propertyDetailsCancel.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => authCubit.logout(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppRadius.circularLg,
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      LocaleKeys.profile_logout.tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
