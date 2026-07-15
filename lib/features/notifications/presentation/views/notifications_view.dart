import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../domain/entities/notification_item_entity.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_widget.dart';
import '../widgets/notifications_skeleton_widget.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationsCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context, cubit),
      body: Column(
        children: [
          _buildFilterChips(context),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return const NotificationsSkeletonWidget();
                } else if (state is NotificationsError) {
                  return _buildErrorState(context, state.message, cubit);
                } else if (state is NotificationsEmpty) {
                  return NotificationsEmptyWidget(
                    onRefresh: () => cubit.getNotifications(forceRefresh: true),
                  );
                } else if (state is NotificationsLoaded) {
                  final list = state.filteredNotifications;
                  if (list.isEmpty) {
                    return NotificationsEmptyWidget(
                      onRefresh: () => cubit.getNotifications(forceRefresh: true),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => cubit.getNotifications(forceRefresh: true),
                    color: context.primaryColor,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: list.length + (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NotificationCard(
                            notification: list[index],
                            onTap: () => _handleCardTap(context, list[index]),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, NotificationsCubit cubit) {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      centerTitle: true,
      title: Text(
        LocaleKeys.notificationsTitle.tr(),
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),

      actions: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded && state.unreadCount > 0) {
              return TextButton(
                onPressed: () => cubit.markAllAsReadLocal(),
                child: Text(
                  LocaleKeys.notificationsMarkAllRead.tr(),
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 4),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          String current = 'all';
          if (state is NotificationsLoaded) current = state.activeFilter;
          if (state is NotificationsEmpty) current = state.activeFilter;

          return Row(
            children: [
              _buildChip(
                context: context,
                label: LocaleKeys.notificationsAll.tr(),
                isSelected: current == 'all',
                onTap: () => context.read<NotificationsCubit>().changeFilter('all'),
              ),
              const SizedBox(width: 10),
              _buildChip(
                context: context,
                label: LocaleKeys.notificationsUnread.tr(),
                isSelected: current == 'unread',
                onTap: () => context.read<NotificationsCubit>().changeFilter('unread'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primary = context.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, NotificationsCubit cubit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14.5, color: Color(0xFF334155)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: LocaleKeys.commonRetry.tr(),
              width: 150,
              onPressed: () => cubit.getNotifications(forceRefresh: true),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, NotificationItemEntity item) {
    // Proactive deep linking handling or mark single as read can be added here
  }
}
