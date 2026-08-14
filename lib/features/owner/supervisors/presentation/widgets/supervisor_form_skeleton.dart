import 'package:flutter/material.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class SupervisorFormSkeleton extends StatelessWidget {
  const SupervisorFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppShimmer.box(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ],
      ),
    );
  }
}
