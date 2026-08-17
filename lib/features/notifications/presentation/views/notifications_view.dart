import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/locale_keys.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/notification_item_entity.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_category_chips.dart';
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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
      backgroundColor: AppColors.surfaceSubtleLight,
      appBar: _buildAppBar(context, cubit),
      body: Column(
        children: [
          const NotificationCategoryChips(),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return const NotificationsSkeletonWidget();
                } else if (state is NotificationsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => cubit.getNotifications(),
                  );
                } else if (state is NotificationsEmpty) {
                  return NotificationsEmptyWidget(
                    onRefresh: () => cubit.getNotifications(forceRefresh: true),
                  );
                } else if (state is NotificationsLoaded) {
                  final list = state.filteredNotifications;
                  if (list.isEmpty) {
                    return NotificationsEmptyWidget(
                      onRefresh: () =>
                          cubit.getNotifications(forceRefresh: true),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => cubit.getNotifications(forceRefresh: true),
                    color: context.primaryColor,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      itemCount: list.length + (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == list.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.primaryColor,
                                ),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    NotificationsCubit cubit,
  ) {
    return CustomAppBar(
      title: LocaleKeys.notificationsTitle.tr(),
      actions: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded && state.unreadCount > 0) {
              return TextButton(
                onPressed: () => cubit.markAllAsRead(),
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

  void _handleCardTap(BuildContext context, NotificationItemEntity item) {
    if (!item.isRead) {
      context.read<NotificationsCubit>().markNotificationAsRead(item.id);
    }
    final entityId = item.entityId;

    try {
      switch (item.category) {
        case NotificationCategory.maintenance:
          if (entityId != null && entityId.isNotEmpty) {
            context.push(Routes.ownerMaintenanceDetailsPath(entityId));
          } else {
            context.push(Routes.ownerMaintenance);
          }
          break;
        case NotificationCategory.contracts:
          if (entityId != null && entityId.isNotEmpty) {
            context.push(Routes.ownerContractDetailsPath(entityId));
          } else {
            context.push(Routes.ownerContracts);
          }
          break;
        case NotificationCategory.tasks:
          if (entityId != null && entityId.isNotEmpty) {
            context.push(Routes.ownerTaskDetailsPath(entityId));
          } else {
            context.push(Routes.ownerTasks);
          }
          break;
        case NotificationCategory.legal:
          if (entityId != null && entityId.isNotEmpty) {
            context.push(Routes.ownerLegalCaseDetailsPath(entityId));
          } else {
            context.push(Routes.ownerLegalCases);
          }
          break;
        case NotificationCategory.financial:
          final idNum = int.tryParse(entityId ?? '');
          if (item.type.contains('receipt') || item.type.contains('invoice')) {
            if (idNum != null) {
              context.push(
                Routes.ownerFinanceReceiptDetails.replaceFirst(':id', '$idNum'),
              );
            } else {
              context.push(Routes.ownerFinanceReceipts);
            }
          } else {
            if (idNum != null) {
              context.push(
                Routes.ownerFinancePaymentDetails.replaceFirst(':id', '$idNum'),
              );
            } else {
              context.push(Routes.ownerFinancePayments);
            }
          }
          break;
        case NotificationCategory.system:
          break;
      }
    } catch (_) {
      // Defensive fallback
    }
  }
}
