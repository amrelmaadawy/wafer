import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class LegalCasesListSkeleton extends StatelessWidget {
  final int itemCount;

  const LegalCasesListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return const LegalCaseCardSkeleton();
      },
    );
  }
}

class LegalCaseCardSkeleton extends StatelessWidget {
  const LegalCaseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 120, height: 20),
                AppShimmer.box(
                  width: 80,
                  height: 24,
                  borderRadius: AppRadius.circularMd,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppShimmer.box(width: double.infinity, height: 16),
            const SizedBox(height: AppSpacing.sm),
            AppShimmer.box(width: 200, height: 16),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.borderLight, height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 80, height: 16),
                AppShimmer.box(width: 100, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
