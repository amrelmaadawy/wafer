import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class OwnerDashboardSkeletonWidget extends StatelessWidget {
  const OwnerDashboardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildFinancialSummarySkeleton(),
        const SizedBox(height: 16),
        _buildOccupancyCardSkeleton(),
        const SizedBox(height: 16),
        _buildQuickActionsSkeleton(),
        const SizedBox(height: 16),
        _buildAlertsGridSkeleton(),
        const SizedBox(height: 16),
        _buildRecentReceiptsSkeleton(),
      ],
    );
  }

  Widget _buildFinancialSummarySkeleton() {
    return AppShimmer(
      child: Container(
        height: 175,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 140, height: 16),
                AppShimmer.box(width: 60, height: 24, borderRadius: AppRadius.circularFull),
              ],
            ),
            AppShimmer.box(width: 180, height: 32),
            Row(
              children: [
                Expanded(child: AppShimmer.box(height: 38)),
                const SizedBox(width: 12),
                Expanded(child: AppShimmer.box(height: 38)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancyCardSkeleton() {
    return AppShimmer(
      child: Container(
        height: 155,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 130, height: 16),
                AppShimmer.box(width: 50, height: 22, borderRadius: AppRadius.circularFull),
              ],
            ),
            AppShimmer.box(height: 12, borderRadius: AppRadius.circularFull),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 90, height: 14),
                AppShimmer.box(width: 90, height: 14),
                AppShimmer.box(width: 90, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSkeleton() {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmer.box(width: 120, height: 16),
            const SizedBox(height: 14),
            Row(
              children: List.generate(3, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                  child: AppShimmer.box(height: 80, borderRadius: AppRadius.circularLg),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsGridSkeleton() {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.box(width: 110, height: 16),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: AppShimmer.box(height: 95, borderRadius: AppRadius.circularXxl)),
              const SizedBox(width: 12),
              Expanded(child: AppShimmer.box(height: 95, borderRadius: AppRadius.circularXxl)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReceiptsSkeleton() {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.box(width: 130, height: 16),
          const SizedBox(height: 12),
          AppShimmer.box(height: 75, borderRadius: AppRadius.circularXxl),
          const SizedBox(height: 10),
          AppShimmer.box(height: 75, borderRadius: AppRadius.circularXxl),
        ],
      ),
    );
  }
}
