import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../../profile/presentation/cubit/profile_state.dart';

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
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
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
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      LocaleKeys.ownerHeaderSubtitle.tr(),
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildCleanNotificationIcon(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCleanNotificationIcon(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF334155),
            size: 22,
          ),
          Positioned(
            top: 10,
            right: 11,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
