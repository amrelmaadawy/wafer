import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/documents/widgets/documents_list_widget.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_status_extension.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/details/owner_maintenance_details_state.dart';
import 'maintenance_action_logs_section.dart';
import 'maintenance_assignments_section.dart';
import 'maintenance_client_section.dart';
import 'maintenance_cost_section.dart';
import 'maintenance_delete_confirmation_sheet.dart';
import 'maintenance_details_bottom_bar.dart';
import 'maintenance_details_header_card.dart';
import 'maintenance_details_skeleton.dart';
import 'maintenance_images_section.dart';
import 'maintenance_tasks_section.dart';
import 'maintenance_timeline_section.dart';
import 'maintenance_workflow_stepper.dart';

class MaintenanceDetailsViewContent extends StatelessWidget {
  final MaintenanceItemEntity initialItem;
  final bool isModified;
  final ValueChanged<bool> onModifiedChanged;

  const MaintenanceDetailsViewContent({
    super.key,
    required this.initialItem,
    required this.isModified,
    required this.onModifiedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerMaintenanceDetailsCubit, OwnerMaintenanceDetailsState>(
      builder: (context, state) {
        MaintenanceItemEntity displayItem = initialItem;
        if (state is OwnerMaintenanceDetailsLoaded) {
          displayItem = state.item;
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: CustomAppBar(
            title: LocaleKeys.maintenanceDetailsTitle.tr(),
            onBackPressed: () => context.pop(isModified),
            actions: [
              if (displayItem.canDelete)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: () => MaintenanceDeleteConfirmationSheet.show(
                    context,
                    displayItem,
                  ),
                ),
              if (displayItem.canEdit)
                IconButton(
                  icon: Icon(Icons.edit, color: context.primaryColor),
                  onPressed: () async {
                    final result = await context.push(
                      Routes.ownerMaintenanceEdit,
                      extra: displayItem,
                    );
                    if (result == true && context.mounted) {
                      onModifiedChanged(true);
                      context
                          .read<OwnerMaintenanceDetailsCubit>()
                          .getMaintenanceDetails(displayItem.safeId);
                    }
                  },
                ),
            ],
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              context.pop(isModified);
            },
            child: _buildBodyContent(context, state, displayItem),
          ),
          bottomNavigationBar: MaintenanceDetailsBottomBar(
            displayItem: displayItem,
            onModified: (modified) {
              if (modified) {
                onModifiedChanged(true);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    OwnerMaintenanceDetailsState state,
    MaintenanceItemEntity displayItem,
  ) {
    if (state is OwnerMaintenanceDetailsError) {
      return CustomErrorWidget(
        message: state.message,
        onRetry: () => context
            .read<OwnerMaintenanceDetailsCubit>()
            .getMaintenanceDetails(initialItem.safeId),
      );
    }

    if (state is OwnerMaintenanceDetailsLoading && displayItem == initialItem) {
      return const MaintenanceDetailsSkeleton();
    }

    return RefreshIndicator(
      color: context.primaryColor,
      onRefresh: () => context
          .read<OwnerMaintenanceDetailsCubit>()
          .getMaintenanceDetails(initialItem.safeId),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is OwnerMaintenanceDetailsLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            MaintenanceWorkflowStepper(item: displayItem),
            const SizedBox(height: 16),
            MaintenanceDetailsHeaderCard(item: displayItem),
            const SizedBox(height: 16),
            MaintenanceClientSection(item: displayItem),
            if (displayItem.financials != null &&
                (displayItem.financials!.estimatedCost != null ||
                    displayItem.financials!.actualCost != null)) ...[
              const SizedBox(height: 16),
              MaintenanceCostSection(item: displayItem),
            ],
            if (displayItem.assignments != null &&
                displayItem.assignments!.isNotEmpty) ...[
              const SizedBox(height: 16),
              MaintenanceAssignmentsSection(item: displayItem),
            ],
            if (displayItem.tasks != null &&
                displayItem.tasks!.isNotEmpty) ...[
              const SizedBox(height: 16),
              MaintenanceTasksSection(item: displayItem),
            ],
            const SizedBox(height: 16),
            MaintenanceTimelineSection(item: displayItem),
            if (displayItem.actionLogs != null &&
                displayItem.actionLogs!.isNotEmpty) ...[
              const SizedBox(height: 16),
              MaintenanceActionLogsSection(item: displayItem),
            ],
            const SizedBox(height: 16),
            MaintenanceImagesSection(images: displayItem.images ?? []),
            const SizedBox(height: 16),
            const DocumentsListWidget(documents: [], padding: EdgeInsets.zero),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
