import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';

class InstallmentsSkeletonWidget extends StatelessWidget {
  const InstallmentsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildBoxSkeleton(160),
          const SizedBox(height: 16),
          _buildBoxSkeleton(75),
          const SizedBox(height: 16),
          _buildBoxSkeleton(140),
          const SizedBox(height: 14),
          _buildBoxSkeleton(140),
          const SizedBox(height: 14),
          _buildBoxSkeleton(140),
        ],
      ),
    );
  }

  Widget _buildBoxSkeleton(double height) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.borderLight.withValues(alpha: 0.6),
              borderRadius: AppRadius.circularSm,
            ),
          ),
          Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.borderLight.withValues(alpha: 0.4),
              borderRadius: AppRadius.circularSm,
            ),
          ),
        ],
      ),
    );
  }
}
