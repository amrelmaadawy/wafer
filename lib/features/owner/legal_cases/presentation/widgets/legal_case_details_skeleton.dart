import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class LegalCaseDetailsSkeleton extends StatelessWidget {
  const LegalCaseDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildShimmerBlock(height: 120),
          const SizedBox(height: AppSpacing.md),
          _buildShimmerBlock(height: 150),
          const SizedBox(height: AppSpacing.md),
          _buildShimmerBlock(height: 180),
          const SizedBox(height: AppSpacing.md),
          _buildShimmerBlock(height: 300),
        ],
      ),
    );
  }

  Widget _buildShimmerBlock({required double height}) {
    return AppShimmer.box(
      width: double.infinity,
      height: height,
      borderRadius: AppRadius.circularLg,
    );
  }
}
