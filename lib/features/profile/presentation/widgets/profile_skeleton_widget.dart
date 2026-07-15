import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/widgets/app_shimmer.dart';

class ProfileSkeletonWidget extends StatelessWidget {
  const ProfileSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildHeaderCardSkeleton(),
        const SizedBox(height: 16),
        _buildInfoCardSkeleton(),
        const SizedBox(height: 16),
        _buildActionsCardSkeleton(),
      ],
    );
  }

  Widget _buildHeaderCardSkeleton() {
    return AppShimmer(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppShimmer.circle(size: 70),
            const SizedBox(height: 14),
            AppShimmer.box(width: 140, height: 18),
            const SizedBox(height: 8),
            AppShimmer.box(width: 100, height: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardSkeleton() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppShimmer.box(width: 120, height: 16),
            const Divider(color: AppColors.borderLight),
            _buildTileSkeleton(),
            const SizedBox(height: 8),
            _buildTileSkeleton(),
            const SizedBox(height: 8),
            _buildTileSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTileSkeleton() {
    return Row(
      children: [
        AppShimmer.circle(size: 38),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer.box(width: 80, height: 12),
              const SizedBox(height: 6),
              AppShimmer.box(width: 160, height: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCardSkeleton() {
    return AppShimmer(
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                AppShimmer.circle(size: 40),
                const SizedBox(width: 14),
                Expanded(child: AppShimmer.box(height: 16)),
              ],
            ),
            const Divider(color: AppColors.borderLight),
            Row(
              children: [
                AppShimmer.circle(size: 40),
                const SizedBox(width: 14),
                Expanded(child: AppShimmer.box(height: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
