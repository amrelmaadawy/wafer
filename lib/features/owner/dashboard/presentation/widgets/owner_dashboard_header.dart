import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../notifications/presentation/cubit/unread_count_cubit.dart';
import '../../../../notifications/presentation/widgets/notification_bell_badge_widget.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../profile/presentation/cubit/profile_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

class OwnerDashboardHeader extends StatelessWidget {
  const OwnerDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final primary = context.primaryColor;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        String name = LocaleKeys.dashboardDefaultUser.tr();
        if (profileState is ProfileLoaded) {
          final fullName = profileState.profile.name.trim();
          name = fullName.isNotEmpty ? fullName.split(' ').first : fullName;
        }

        return Container(
          padding: EdgeInsets.only(
            top: topPadding + 14,
            bottom: 14,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _HeaderActionButton(
                icon: Icons.menu_rounded,
                onTap: () {
                  final rootScaffold = context.findRootAncestorStateOfType<ScaffoldState>();
                  if (rootScaffold != null) {
                    rootScaffold.openDrawer();
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
                primary: primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              // Avatar + Greeting
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.primaryDark, primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.dashboardWelcome.tr(),
                      style: TextStyle(
                        color: context.appSecondaryTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: context.appOnSurfaceColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _HeaderActionButton(
                icon: Icons.search_rounded,
                onTap: () => context.push(Routes.ownerSearch),
                primary: primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              BlocProvider.value(
                value: sl<UnreadCountCubit>()..getUnreadCount(),
                child: const NotificationBellBadgeWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color primary;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: primary, size: 20),
        ),
      ),
    );
  }
}
