import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class OccupancySkeleton extends StatelessWidget {
  const OccupancySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderSkeleton(),
          const SizedBox(height: 16),
          _buildPropertySkeleton(),
          const SizedBox(height: 12),
          _buildPropertySkeleton(),
          const SizedBox(height: 12),
          _buildPropertySkeleton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return AppShimmer(
      child: Container(
        height: 175,
        padding: const EdgeInsets.all(22),
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
              children: [
                AppShimmer.circle(size: 20),
                const SizedBox(width: 8),
                AppShimmer.box(width: 160, height: 16),
              ],
            ),
            AppShimmer.box(width: 100, height: 38),
            Row(
              children: [
                Expanded(child: AppShimmer.box(height: 14)),
                const SizedBox(width: 16),
                Expanded(child: AppShimmer.box(height: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertySkeleton() {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AppShimmer.circle(size: 38),
                    const SizedBox(width: 12),
                    AppShimmer.box(width: 120, height: 16),
                  ],
                ),
                AppShimmer.box(width: 55, height: 26, borderRadius: AppRadius.circularFull),
              ],
            ),
            const SizedBox(height: 16),
            AppShimmer.box(height: 8, borderRadius: AppRadius.circularFull),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 75, height: 14),
                AppShimmer.box(width: 75, height: 14),
                AppShimmer.box(width: 75, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
