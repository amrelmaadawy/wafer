import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
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

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        String name = LocaleKeys.dashboardDefaultUser.tr();
        if (profileState is ProfileLoaded) {
          final fullName = profileState.profile.name.trim();
          name = fullName.isNotEmpty ? fullName.split(' ').first : fullName;
        }

        return Container(
          padding: EdgeInsets.only(
            top: topPadding + 16,
            bottom: 16,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            border: Border(
              bottom: BorderSide(color: context.appBorderColor, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${LocaleKeys.dashboardWelcome.tr()} $name',
                      style: TextStyle(
                        color: context.appOnSurfaceColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      LocaleKeys.ownerHeaderSubtitle.tr(),
                      style: TextStyle(
                        color: context.appSecondaryTextColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.appSurfaceColor,
                  border: Border.all(color: context.appBorderColor),
                ),
                child: IconButton(
                  icon: Icon(Icons.search,
                      color: context.appSecondaryTextColor, size: 20),
                  onPressed: () => context.push(Routes.ownerSearch),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  splashRadius: 24,
                ),
              ),
              const SizedBox(width: 8),
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
