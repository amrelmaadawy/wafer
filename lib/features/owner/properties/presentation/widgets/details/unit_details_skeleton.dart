import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class UnitDetailsSkeleton extends StatelessWidget {
  const UnitDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Image Skeleton ──────────────────
          AppShimmer.box(height: 260, borderRadius: BorderRadius.zero),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Basic Info Card Skeleton ───────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.circularLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppShimmer.box(width: 120, height: 20),
                          AppShimmer.box(
                            width: 70,
                            height: 24,
                            borderRadius: AppRadius.circularFull,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppShimmer.box(width: 200, height: 14),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: AppShimmer.box(height: 40)),
                          const SizedBox(width: 12),
                          Expanded(child: AppShimmer.box(height: 40)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Prices Section Skeleton ─────────────
                AppShimmer.box(width: 130, height: 18),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: AppShimmer.box(height: 70)),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer.box(height: 70)),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Specs Grid Skeleton ─────────────────
                AppShimmer.box(width: 110, height: 18),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  children: List.generate(6, (_) => AppShimmer.box(height: 60)),
                ),
                const SizedBox(height: 24),

                // ── Dimensions Skeleton ─────────────────
                AppShimmer.box(width: 140, height: 18),
                const SizedBox(height: 12),
                AppShimmer.box(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
