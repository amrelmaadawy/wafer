import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class WarehouseItemsShimmer extends StatelessWidget {
  final int itemCount;

  const WarehouseItemsShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.box(width: 120, height: 20),
                  AppShimmer.box(width: 60, height: 24, borderRadius: BorderRadius.circular(12)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  AppShimmer.box(width: 80, height: 16),
                  const SizedBox(width: AppSpacing.sm),
                  AppShimmer.box(width: 60, height: 16),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.box(width: 100, height: 16),
                  AppShimmer.box(width: 80, height: 16),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
