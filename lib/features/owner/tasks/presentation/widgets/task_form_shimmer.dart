import 'package:flutter/material.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';

class TaskFormShimmer extends StatelessWidget {
  const TaskFormShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.box(height: 24, width: 120),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer.box(height: 50, width: double.infinity, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.lg),
          AppShimmer.box(height: 24, width: 100),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer.box(height: 100, width: double.infinity, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(height: 24, width: 80),
                    const SizedBox(height: AppSpacing.sm),
                    AppShimmer.box(height: 50, width: double.infinity, borderRadius: AppRadius.circularMd),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(height: 24, width: 80),
                    const SizedBox(height: AppSpacing.sm),
                    AppShimmer.box(height: 50, width: double.infinity, borderRadius: AppRadius.circularMd),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppShimmer.box(height: 24, width: 100),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer.box(height: 50, width: double.infinity, borderRadius: AppRadius.circularMd),
        ],
      ),
    );
  }
}
