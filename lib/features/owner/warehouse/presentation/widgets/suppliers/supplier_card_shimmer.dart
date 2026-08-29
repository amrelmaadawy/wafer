import 'package:flutter/material.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';

class SupplierCardShimmer extends StatelessWidget {
  const SupplierCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.appBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppShimmer.box(width: 32, height: 32, borderRadius: BorderRadius.circular(AppRadius.md)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(width: 120, height: 16),
                    const SizedBox(height: 8),
                    AppShimmer.box(width: 80, height: 12),
                  ],
                ),
              ),
              AppShimmer.box(width: 60, height: 24, borderRadius: BorderRadius.circular(AppRadius.sm)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    AppShimmer.box(width: 16, height: 16, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    const SizedBox(width: 6),
                    AppShimmer.box(width: 60, height: 14),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    AppShimmer.box(width: 16, height: 16, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    const SizedBox(width: 6),
                    AppShimmer.box(width: 80, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
