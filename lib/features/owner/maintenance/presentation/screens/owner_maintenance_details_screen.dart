import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/di/service_locator.dart' as di;
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../cubit/details/owner_maintenance_details_state.dart';
import '../widgets/maintenance_cost_section.dart';
import '../widgets/maintenance_details_header_card.dart';
import '../widgets/maintenance_images_section.dart';
import '../widgets/maintenance_timeline_section.dart';

class OwnerMaintenanceDetailsScreen extends StatelessWidget {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OwnerMaintenanceDetailsCubit>()
        ..getMaintenanceDetails(item.id),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            LocaleKeys.maintenanceDetailsTitle.tr(),
            style: const TextStyle(
                color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.surfaceLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
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
                  .getMaintenanceDetails(item.id),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    MaintenanceCostSection(item: displayItem),
                    const SizedBox(height: 16),
                    MaintenanceTimelineSection(item: displayItem),
                    const SizedBox(height: 16),
                    MaintenanceImagesSection(images: displayItem.images),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
