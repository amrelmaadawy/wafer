import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/features/profile/presentation/cubit/profile_cubit.dart';
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  LocaleKeys.profile_account_settings.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: AppRadius.circularXl,
                  border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryShadow.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.circularXl,
                  child: Column(
                    children: [
                      ProfileActionTile(
                        icon: Icons.person_outline_rounded,
                        label: LocaleKeys.profile_edit_profile.tr(),
                        subtitle: LocaleKeys.profile_edit_profile_subtitle.tr(),
                        iconBg: context.primaryColor.withValues(alpha: 0.1),
                        iconColor: context.primaryColor,
                        onTap: () {
                          context.push(
                            Routes.editProfile,
                            extra: {
                              'profile': profile,
                              'cubit': context.read<ProfileCubit>(),
                            },
                          );
                        },
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.borderLight,
                        indent: 74,
                        endIndent: 0,
                      ),
                      ProfileActionTile(
                        icon: Icons.palette_outlined,
                        label: LocaleKeys.profile_theme_color.tr(),
                        subtitle: LocaleKeys.profile_theme_color_subtitle.tr(),
                        iconBg: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        iconColor: const Color(0xFF6C63FF),
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
                        indent: 74,
                        endIndent: 0,
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
