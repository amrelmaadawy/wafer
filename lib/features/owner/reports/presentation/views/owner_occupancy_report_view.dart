import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../cubit/owner_occupancy_cubit.dart';
import '../cubit/owner_occupancy_state.dart';
import '../widgets/occupancy_properties_list.dart';
import '../widgets/occupancy_skeleton.dart';
import '../widgets/occupancy_summary_header.dart';

class OwnerOccupancyReportView extends StatelessWidget {
  const OwnerOccupancyReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerOccupancyCubit, OwnerOccupancyState>(
      builder: (context, state) {
        if (state is OwnerOccupancyLoading || state is OwnerOccupancyInitial) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: OccupancySkeleton(),
          );
        } else if (state is OwnerOccupancyError) {
          return _buildErrorView(context, state.message);
        } else if (state is OwnerOccupancyEmpty) {
          return _buildEmptyView(context);
        } else if (state is OwnerOccupancyLoaded) {
          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () => context
                .read<OwnerOccupancyCubit>()
                .loadOccupancyReport(forceRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OccupancySummaryHeader(
                    overallRate: state.overallRate,
                    totalUnits: state.totalUnits,
                    totalRented: state.totalRented,
                    totalVacant: state.totalVacant,
                  ),
                  const SizedBox(height: 22),
                  OccupancyPropertiesList(properties: state.properties),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textPrimaryLight, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context
                  .read<OwnerOccupancyCubit>()
                  .loadOccupancyReport(forceRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circularFull),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(LocaleKeys.commonRetry.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.domain_disabled_rounded,
              size: 56, color: AppColors.textSecondaryLight),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.occupancyNoData.tr(),
            style: const TextStyle(
                color: AppColors.textSecondaryLight, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
