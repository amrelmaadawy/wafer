import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../cubit/unread_count_cubit.dart';
import '../cubit/unread_count_state.dart';

class NotificationBellBadgeWidget extends StatelessWidget {
  final bool isTransparent;
  const NotificationBellBadgeWidget({super.key, this.isTransparent = false});

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return Material(
      color: isTransparent ? Colors.transparent : primaryColor.withValues(alpha: 0.08),
      borderRadius: AppRadius.circularLg,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: AppRadius.circularLg,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_rounded,
                color: primaryColor,
                size: 22,
              ),
              BlocBuilder<UnreadCountCubit, UnreadCountState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is UnreadCountLoaded) {
                    count = state.count;
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: count > 0
                        ? Positioned(
                            key: ValueKey<int>(count),
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: AppRadius.circularLg,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  count > 99 ? '99+' : '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey<int>(0)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final cubit = context.read<UnreadCountCubit>();
    await context.push(Routes.notifications);
    if (context.mounted) {
      cubit.getUnreadCount();
    }
  }
}

