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
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/details/owner_maintenance_details_state.dart';
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
    return BlocProvider(
      create: (_) => di.sl<OwnerMaintenanceDetailsCubit>()
        ..getMaintenanceDetails(item.id ?? 0),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: CustomAppBar(
              title: LocaleKeys.maintenanceDetailsTitle.tr(),
              actions: [
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
        body: BlocBuilder<OwnerMaintenanceDetailsCubit,
            OwnerMaintenanceDetailsState>(
          builder: (context, state) {
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
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is OwnerMaintenanceDetailsLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    MaintenanceDetailsHeaderCard(item: displayItem),
                    const SizedBox(height: 16),
                    MaintenanceClientSection(item: displayItem),
                    if (displayItem.client != null) const SizedBox(height: 16),
                    MaintenanceCostSection(item: displayItem),
                    const SizedBox(height: 16),
                    MaintenanceAssignmentsSection(item: displayItem),
                    if (displayItem.assignments != null && displayItem.assignments!.isNotEmpty) const SizedBox(height: 16),
                    MaintenanceTasksSection(item: displayItem),
                    if (displayItem.tasks != null && displayItem.tasks!.isNotEmpty) const SizedBox(height: 16),
                    MaintenanceTimelineSection(item: displayItem),
                    const SizedBox(height: 16),
                    MaintenanceActionLogsSection(item: displayItem),
                    if (displayItem.actionLogs != null && displayItem.actionLogs!.isNotEmpty) const SizedBox(height: 16),
                    MaintenanceImagesSection(images: displayItem.images ?? []),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      );
        },
      ),
    );
  }
}
