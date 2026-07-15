import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class RevenueSkeleton extends StatelessWidget {
  const RevenueSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildHeaderSkeleton(),
          const SizedBox(height: 16),
          _buildChartSkeleton(),
          const SizedBox(height: 16),
          _buildRowSkeleton(),
          const SizedBox(height: 12),
          _buildRowSkeleton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return AppShimmer(
      child: Container(
        height: 195,
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
                AppShimmer.box(width: 140, height: 16),
              ],
            ),
            AppShimmer.box(width: 120, height: 38),
            const Divider(color: AppColors.borderLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 85, height: 26),
                AppShimmer.box(width: 85, height: 26),
                AppShimmer.box(width: 85, height: 26),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSkeleton() {
    return AppShimmer(
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 150, height: 16),
                Row(children: [AppShimmer.circle(size: 10), const SizedBox(width: 4), AppShimmer.box(width: 45, height: 12)]),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(5, (i) => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppShimmer.box(width: 14, height: 80.0 + (i * 15)),
                        const SizedBox(width: 4),
                        AppShimmer.box(width: 14, height: 60.0 + (i * 10)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppShimmer.box(width: 36, height: 12),
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowSkeleton() {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
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
                AppShimmer.box(width: 110, height: 26, borderRadius: AppRadius.circularSm),
                AppShimmer.box(width: 50, height: 24, borderRadius: AppRadius.circularFull),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 80, height: 24),
                AppShimmer.box(width: 80, height: 24),
                AppShimmer.box(width: 80, height: 24),
              ],
            ),
            const SizedBox(height: 14),
            AppShimmer.box(height: 8, borderRadius: AppRadius.circularFull),
          ],
        ),
      ),
    );
  }
}
