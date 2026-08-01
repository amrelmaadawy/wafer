import 'package:flutter/material.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class MaintenanceDetailsSkeleton extends StatelessWidget {
  const MaintenanceDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Skeleton
          const AppShimmer(
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.circularLg,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Section Title Skeleton
          AppShimmer(
            child: SizedBox(
              width: 150,
              height: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.circularSm,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Details Card Skeleton
          const AppShimmer(
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.circularLg,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Section Title Skeleton
          AppShimmer(
            child: SizedBox(
              width: 120,
              height: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.circularSm,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // List Items Skeleton
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: const AppShimmer(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.circularMd,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
