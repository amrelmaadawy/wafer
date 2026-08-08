import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class LegalCaseCreateSkeleton extends StatelessWidget {
  const LegalCaseCreateSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mock Step Indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: AppShimmer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmer.box(width: 40, height: 40, borderRadius: AppRadius.circularFull),
                const SizedBox(width: 8),
                AppShimmer.box(width: 60, height: 4),
                const SizedBox(width: 8),
                AppShimmer.box(width: 40, height: 40, borderRadius: AppRadius.circularFull),
                const SizedBox(width: 8),
                AppShimmer.box(width: 60, height: 4),
                const SizedBox(width: 8),
                AppShimmer.box(width: 40, height: 40, borderRadius: AppRadius.circularFull),
              ],
            ),
          ),
        ),
        // Mock Form Card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppShimmer(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.circularXl,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(width: 150, height: 24),
                    const SizedBox(height: AppSpacing.xl),
                    AppShimmer.box(width: double.infinity, height: 55, borderRadius: AppRadius.circularLg),
                    const SizedBox(height: AppSpacing.lg),
                    AppShimmer.box(width: double.infinity, height: 55, borderRadius: AppRadius.circularLg),
                    const SizedBox(height: AppSpacing.lg),
                    AppShimmer.box(width: double.infinity, height: 55, borderRadius: AppRadius.circularLg),
                    const SizedBox(height: AppSpacing.lg),
                    AppShimmer.box(width: double.infinity, height: 55, borderRadius: AppRadius.circularLg),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Mock Bottom Buttons
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: AppShimmer(
            child: Row(
              children: [
                Expanded(
                  child: AppShimmer.box(width: double.infinity, height: 50, borderRadius: AppRadius.circularLg),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: AppShimmer.box(width: double.infinity, height: 50, borderRadius: AppRadius.circularLg),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
