import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class ContractDetailsSkeletonWidget extends StatelessWidget {
  const ContractDetailsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildCardSkeleton(110),
          const SizedBox(height: 16),
          _buildCardSkeleton(140),
          const SizedBox(height: 16),
          _buildCardSkeleton(150),
          const SizedBox(height: 16),
          _buildCardSkeleton(220),
        ],
      ),
    );
  }

  Widget _buildCardSkeleton(double height) {
    return AppShimmer(
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppShimmer.box(
              width: 140,
              height: 16,
              borderRadius: AppRadius.circularSm,
            ),
            AppShimmer.box(
              width: double.infinity,
              height: 14,
              borderRadius: AppRadius.circularSm,
            ),
            AppShimmer.box(
              width: 200,
              height: 14,
              borderRadius: AppRadius.circularSm,
            ),
          ],
        ),
      ),
    );
  }
}
