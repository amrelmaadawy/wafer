import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/theme/theme_context.dart';

class ClientShimmerCard extends StatelessWidget {
  const ClientShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppShimmer.circle(size: 48),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppShimmer.box(height: 16, width: 120),
                            const SizedBox(width: AppSpacing.xs),
                            AppShimmer.box(height: 20, width: 60, borderRadius: BorderRadius.circular(12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        AppShimmer.box(height: 14, width: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.appBorderColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.xs,
                      children: [
                        AppShimmer.box(height: 14, width: 80),
                        AppShimmer.box(height: 14, width: 80),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppShimmer.box(height: 30, width: 30, borderRadius: BorderRadius.circular(8)),
                      const SizedBox(width: 8),
                      AppShimmer.box(height: 30, width: 30, borderRadius: BorderRadius.circular(8)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientsListShimmer extends StatelessWidget {
  final int itemCount;

  const ClientsListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const ClientShimmerCard();
      },
    );
  }
}
