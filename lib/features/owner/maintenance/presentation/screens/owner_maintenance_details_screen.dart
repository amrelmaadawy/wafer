import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';

import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_status_extension.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/details/owner_maintenance_details_state.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_cubit.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_state.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_state.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_state.dart';

import '../cubit/start_maintenance/owner_start_maintenance_cubit.dart';
import '../cubit/complete_task/owner_complete_task_cubit.dart';
import '../cubit/forward_maintenance/owner_forward_maintenance_cubit.dart';
import '../widgets/maintenance_cost_section.dart';
import '../widgets/maintenance_details_header_card.dart';
import '../widgets/maintenance_images_section.dart';
import '../widgets/maintenance_timeline_section.dart';
import '../widgets/maintenance_client_section.dart';
import '../widgets/maintenance_assignments_section.dart';
import '../widgets/maintenance_tasks_section.dart';
import '../widgets/maintenance_action_logs_section.dart';
import '../widgets/maintenance_details_bottom_bar.dart';
import '../widgets/maintenance_delete_confirmation_sheet.dart';
import '../widgets/maintenance_details_skeleton.dart';

class OwnerMaintenanceDetailsScreen extends StatefulWidget {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceDetailsScreen({super.key, required this.item});

  @override
  State<OwnerMaintenanceDetailsScreen> createState() =>
      _OwnerMaintenanceDetailsScreenState();
}

class _OwnerMaintenanceDetailsScreenState
    extends State<OwnerMaintenanceDetailsScreen> {
  bool _isModified = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<OwnerMaintenanceDetailsCubit>()
                ..getMaintenanceDetails(widget.item.safeId),
        ),
        BlocProvider(create: (_) => di.sl<OwnerDeleteMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerApproveMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerRejectMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerStartMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerCompleteTaskCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerForwardMaintenanceCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<
            OwnerDeleteMaintenanceCubit,
            OwnerDeleteMaintenanceState
          >(
            listener: (context, state) {
              if (state.status == DeleteMaintenanceStatus.success) {
                Navigator.of(context, rootNavigator: true).pop(); // pop modal
                AppToast.showSuccess(
                  context,
                  LocaleKeys.maintenanceDeleteSuccess.tr(),
                );
                context.pop(true); // pop details screen
              } else if (state.status == DeleteMaintenanceStatus.failure) {
                Navigator.of(context, rootNavigator: true).pop(); // pop modal
                AppToast.showError(
                  context,
                  state.errorMessage ?? LocaleKeys.errorsServerError.tr(),
                );
              }
            },
            child: BlocListener<OwnerApproveMaintenanceCubit, OwnerApproveMaintenanceState>(
              listener: (context, state) {
                if (state is OwnerApproveMaintenanceSuccess) {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // pop bottom sheet
                  AppToast.showSuccess(context, state.message);
                  context.pop(true); // pop details screen and refresh list
                } else if (state is OwnerApproveMaintenanceError) {
                  AppToast.showError(context, state.message);
                }
              },
              child:
                  BlocListener<
                    OwnerRejectMaintenanceCubit,
                    OwnerRejectMaintenanceState
                  >(
                    listener: (context, state) {
                      if (state is OwnerRejectMaintenanceSuccess) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(); // pop bottom sheet
                        AppToast.showSuccess(context, state.message);
                        context.pop(
                          true,
                        ); // pop details screen and refresh list
                      } else if (state is OwnerRejectMaintenanceError) {
                        AppToast.showError(context, state.message);
                      }
                    },
                    child:
                        BlocBuilder<
                          OwnerMaintenanceDetailsCubit,
                          OwnerMaintenanceDetailsState
                        >(
                          builder: (context, state) {
                            MaintenanceItemEntity displayItem = widget.item;
                            if (state is OwnerMaintenanceDetailsLoaded) {
                              displayItem = state.item;
                            }

                            return Scaffold(
                              backgroundColor: AppColors.backgroundLight,
                              appBar: CustomAppBar(
                                title: LocaleKeys.maintenanceDetailsTitle.tr(),
                                onBackPressed: () => context.pop(_isModified),
                                actions: [
                                  if (displayItem.canDelete)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.error,
                                      ),
                                      onPressed: () =>
                                          MaintenanceDeleteConfirmationSheet.show(
                                            context,
                                            displayItem,
                                          ),
                                    ),
                                  if (displayItem.canEdit)
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: context.primaryColor,
                                      ),
                                      onPressed: () async {
                                        final result = await context.push(
                                          Routes.ownerMaintenanceEdit,
                                          extra: displayItem,
                                        );
                                        if (result == true && context.mounted) {
                                          _isModified = true;
                                          context
                                              .read<
                                                OwnerMaintenanceDetailsCubit
                                              >()
                                              .getMaintenanceDetails(
                                                displayItem.safeId,
                                              );
                                        }
                                      },
                                    ),
                                ],
                              ),
                              body: PopScope(
                                canPop: false,
                                onPopInvokedWithResult: (didPop, result) {
                                  if (didPop) return;
                                  context.pop(_isModified);
                                },
                                child: Builder(
                                  builder: (context) {
                                    if (state is OwnerMaintenanceDetailsError) {
                                      return CustomErrorWidget(
                                        message: state.message,
                                        onRetry: () => context
                                            .read<
                                              OwnerMaintenanceDetailsCubit
                                            >()
                                            .getMaintenanceDetails(
                                              widget.item.safeId,
                                            ),
                                      );
                                    }

                                    if (state
                                            is OwnerMaintenanceDetailsLoading &&
                                        displayItem == widget.item) {
                                      return const MaintenanceDetailsSkeleton();
                                    }

                                    return RefreshIndicator(
                                      color: context.primaryColor,
                                      onRefresh: () => context
                                          .read<OwnerMaintenanceDetailsCubit>()
                                          .getMaintenanceDetails(
                                            widget.item.safeId,
                                          ),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics(),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (state
                                                is OwnerMaintenanceDetailsLoading)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                child: LinearProgressIndicator(
                                                  minHeight: 2,
                                                ),
                                              ),
                                            MaintenanceDetailsHeaderCard(
                                              item: displayItem,
                                            ),
                                            const SizedBox(height: 16),
                                            MaintenanceClientSection(
                                              item: displayItem,
                                            ),
                                            if (displayItem.financials !=
                                                    null &&
                                                (displayItem
                                                            .financials!
                                                            .estimatedCost !=
                                                        null ||
                                                    displayItem
                                                            .financials!
                                                            .actualCost !=
                                                        null)) ...[
                                              MaintenanceCostSection(
                                                item: displayItem,
                                              ),
                                              const SizedBox(height: 24),
                                            ],
                                            MaintenanceAssignmentsSection(
                                              item: displayItem,
                                            ),
                                            if (displayItem.assignments !=
                                                    null &&
                                                displayItem
                                                    .assignments!
                                                    .isNotEmpty)
                                              const SizedBox(height: 16),
                                            MaintenanceTasksSection(
                                              item: displayItem,
                                            ),
                                            if (displayItem.tasks != null &&
                                                displayItem.tasks!.isNotEmpty)
                                              const SizedBox(height: 16),
                                            MaintenanceTimelineSection(
                                              item: displayItem,
                                            ),
                                            const SizedBox(height: 16),
                                            MaintenanceActionLogsSection(
                                              item: displayItem,
                                            ),
                                            if (displayItem.actionLogs !=
                                                    null &&
                                                displayItem
                                                    .actionLogs!
                                                    .isNotEmpty)
                                              const SizedBox(height: 16),
                                            MaintenanceImagesSection(
                                              images: displayItem.images ?? [],
                                            ),
                                            if (displayItem.actionLogs !=
                                                    null &&
                                                displayItem
                                                    .actionLogs!
                                                    .isNotEmpty)
                                              const SizedBox(
                                                height: 100,
                                              ), // spacing for bottom bar
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomNavigationBar: MaintenanceDetailsBottomBar(
                                displayItem: displayItem,
                                onModified: (modified) {
                                  if (modified) {
                                    _isModified = true;
                                  }
                                },
                              ),
                            );
                          },
                        ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
