import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class FinanceOverviewSkeletonWidget extends StatelessWidget {
  const FinanceOverviewSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        _buildFinancialSummarySkeleton(),
        const SizedBox(height: 24),
        _buildResourcesGridSkeleton(),
        ],
      ),
    );
  }

  Widget _buildFinancialSummarySkeleton() {
    return AppShimmer(
      child: Container(
        height: 220,
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
                AppShimmer.box(
                  width: 60,
                  height: 24,
                  borderRadius: AppRadius.circularFull,
                ),
              ],
            ),
            AppShimmer.box(width: 180, height: 40),
            Row(
              children: [
                Expanded(child: AppShimmer.box(height: 50)),
                const SizedBox(width: 12),
                Expanded(child: AppShimmer.box(height: 50)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 80, height: 14),
                AppShimmer.box(width: 80, height: 14),
                AppShimmer.box(width: 80, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesGridSkeleton() {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.box(width: 150, height: 18),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return AppShimmer.box(width: double.infinity, height: double.infinity, borderRadius: AppRadius.circularXxl);
            },
          ),
        ],
      ),
    );
  }
}
