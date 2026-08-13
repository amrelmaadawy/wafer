import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class InstallmentsSkeletonWidget extends StatelessWidget {
  const InstallmentsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildBoxSkeleton(context, 160),
          const SizedBox(height: 16),
          _buildBoxSkeleton(context, 75),
          const SizedBox(height: 16),
          _buildBoxSkeleton(context, 140),
          const SizedBox(height: 14),
          _buildBoxSkeleton(context, 140),
          const SizedBox(height: 14),
          _buildBoxSkeleton(context, 140),
        ],
      ),
    );
  }

  Widget _buildBoxSkeleton(BuildContext context, double height) {
    return AppShimmer(
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: context.appBorderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmer.box(
              width: 130,
              height: 12,
              borderRadius: AppRadius.circularSm,
            ),
            AppShimmer.box(
              width: double.infinity,
              height: 12,
              borderRadius: AppRadius.circularSm,
            ),
          ],
        ),
      ),
    );
  }
}
