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
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/details/owner_maintenance_details_state.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_cubit.dart';
import '../cubit/delete_maintenance/owner_delete_maintenance_state.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_cubit.dart';
import '../cubit/approve_maintenance/owner_approve_maintenance_state.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_cubit.dart';
import '../cubit/reject_maintenance/owner_reject_maintenance_state.dart';
import '../widgets/owner_approve_maintenance_bottom_sheet.dart';
import '../widgets/owner_reject_maintenance_bottom_sheet.dart';
import '../widgets/owner_assign_maintenance_bottom_sheet.dart';
import '../widgets/maintenance_cost_section.dart';
import '../widgets/maintenance_details_header_card.dart';
import '../widgets/maintenance_images_section.dart';
import '../widgets/maintenance_timeline_section.dart';
import '../widgets/maintenance_client_section.dart';
import '../widgets/maintenance_assignments_section.dart';
import '../widgets/maintenance_tasks_section.dart';
import '../widgets/maintenance_action_logs_section.dart';

class OwnerMaintenanceDetailsScreen extends StatelessWidget {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.sl<OwnerMaintenanceDetailsCubit>()
                ..getMaintenanceDetails(item.id ?? 0),
        ),
        BlocProvider(create: (_) => di.sl<OwnerDeleteMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerApproveMaintenanceCubit>()),
        BlocProvider(create: (_) => di.sl<OwnerRejectMaintenanceCubit>()),
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
                    child: Scaffold(
                      backgroundColor: AppColors.backgroundLight,
                      appBar: CustomAppBar(
                        title: LocaleKeys.maintenanceDetailsTitle.tr(),
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                            ),
                            onPressed: () => _showDeleteConfirmationBottomSheet(
                              context,
                              item,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: context.primaryColor),
                            onPressed: () async {
                              final result = await context.push(
                                Routes.ownerMaintenanceEdit,
                                extra: item,
                              );
                              if (result == true && context.mounted) {
                                context
                                    .read<OwnerMaintenanceDetailsCubit>()
                                    .getMaintenanceDetails(item.id ?? 0);
                              }
                            },
                          ),
                        ],
                      ),
                      body:
                          BlocBuilder<
                            OwnerMaintenanceDetailsCubit,
                            OwnerMaintenanceDetailsState
                          >(
                            builder: (context, state) {
                              if (state is OwnerMaintenanceDetailsError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 56,
                                          color: AppColors.error,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          state.message,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppColors.textSecondaryLight,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () => context
                                              .read<
                                                OwnerMaintenanceDetailsCubit
                                              >()
                                              .getMaintenanceDetails(
                                                item.id ?? 0,
                                              ),
                                          icon: const Icon(Icons.refresh),
                                          label: Text(
                                            LocaleKeys.common_retry.tr(),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                context.primaryColor,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              MaintenanceItemEntity displayItem = item;
                              if (state is OwnerMaintenanceDetailsLoaded) {
                                displayItem = state.item;
                              }
                              return RefreshIndicator(
                                color: context.primaryColor,
                                onRefresh: () => context
                                    .read<OwnerMaintenanceDetailsCubit>()
                                    .getMaintenanceDetails(item.id ?? 0),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state
                                          is OwnerMaintenanceDetailsLoading)
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 12),
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
                                      if (displayItem.financials != null &&
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
                                      if (displayItem.assignments != null &&
                                          displayItem.assignments!.isNotEmpty)
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
                                      if (displayItem.actionLogs != null &&
                                          displayItem.actionLogs!.isNotEmpty)
                                        const SizedBox(height: 16),
                                      MaintenanceImagesSection(
                                        images: displayItem.images ?? [],
                                      ),
                                      if (displayItem.actionLogs != null &&
                                          displayItem.actionLogs!.isNotEmpty)
                                        const SizedBox(
                                          height: 100,
                                        ), // spacing for bottom bar
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      bottomNavigationBar:
                          BlocBuilder<
                            OwnerMaintenanceDetailsCubit,
                            OwnerMaintenanceDetailsState
                          >(
                            builder: (context, state) {
                              MaintenanceItemEntity displayItem = item;
                              if (state is OwnerMaintenanceDetailsLoaded) {
                                displayItem = state.item;
                              }
                              if (displayItem.status == 'new' ||
                                  displayItem.status == 'pending_supervisor') {
                                return Container(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: SafeArea(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                _showApproveBottomSheet(
                                                  context,
                                                  displayItem.id ?? 0,
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  context.primaryColor,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        AppRadius.circularLg,
                                                  ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              LocaleKeys
                                                  .maintenanceApproveRequest
                                                  .tr(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                _showRejectBottomSheet(
                                                  context,
                                                  displayItem.id ?? 0,
                                                ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: AppColors.error,
                                              side: const BorderSide(
                                                color: AppColors.error,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        AppRadius.circularLg,
                                                  ),
                                            ),
                                            child: Text(
                                              LocaleKeys
                                                  .maintenanceRejectRequest
                                                  .tr(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (displayItem.status == 'approved') {
                                return Container(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: SafeArea(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          OwnerAssignMaintenanceBottomSheet.show(
                                            context,
                                            displayItem,
                                          ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: AppRadius.circularLg,
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        LocaleKeys.maintenanceAssignTechnician
                                            .tr(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }

  void _showApproveBottomSheet(BuildContext parentContext, int maintenanceId) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: parentContext.read<OwnerApproveMaintenanceCubit>(),
        child: OwnerApproveMaintenanceBottomSheet(maintenanceId: maintenanceId),
      ),
    );
  }

  void _showRejectBottomSheet(BuildContext parentContext, int maintenanceId) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: parentContext.read<OwnerRejectMaintenanceCubit>(),
        child: OwnerRejectMaintenanceBottomSheet(maintenanceId: maintenanceId),
      ),
    );
  }

  void _showDeleteConfirmationBottomSheet(
    BuildContext context,
    MaintenanceItemEntity item,
  ) {
    final deleteCubit = context.read<OwnerDeleteMaintenanceCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXxl),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: deleteCubit,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.maintenanceDeleteConfirmTitle.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.maintenanceDeleteConfirmDesc.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.circularXl,
                          ),
                          side: const BorderSide(color: AppColors.borderLight),
                        ),
                        onPressed: () => Navigator.of(bottomSheetContext).pop(),
                        child: Text(
                          LocaleKeys.maintenanceDeleteCancelBtn.tr(),
                          style: const TextStyle(
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          BlocBuilder<
                            OwnerDeleteMaintenanceCubit,
                            OwnerDeleteMaintenanceState
                          >(
                            bloc: context.read<OwnerDeleteMaintenanceCubit>(),
                            builder: (context, state) {
                              final isLoading =
                                  state.status ==
                                  DeleteMaintenanceStatus.loading;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: AppRadius.circularXl,
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<OwnerDeleteMaintenanceCubit>()
                                            .deleteMaintenanceRequest(
                                              item.id ?? 0,
                                            );
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        LocaleKeys.maintenanceDeleteConfirmBtn
                                            .tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
