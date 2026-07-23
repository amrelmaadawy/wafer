import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class PropertyDetailsSkeleton extends StatelessWidget {
  const PropertyDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildHeaderSkeleton(context),
            const SizedBox(height: 12),
            _buildMetricsBarSkeleton(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCardSkeleton(height: 160),
                  const SizedBox(height: 16),
                  _buildCardSkeleton(height: 120),
                  const SizedBox(height: 16),
                  _buildCardSkeleton(height: 140),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton(BuildContext context) {
    const darkBase = Color(0xFF1E293B);
    const darkHighlight = Color(0xFF475569);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            context.primaryColor,
            const Color(0xFF0F172A),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: AppRadius.circularFull,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppShimmer(
                              baseColor: darkBase,
                              highlightColor: darkHighlight,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppShimmer(
                              baseColor: darkBase,
                              highlightColor: darkHighlight,
                              child: Container(
                                width: 40,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: AppRadius.circularSm,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: AppRadius.circularLg,
                    ),
                    child: AppShimmer(
                      baseColor: darkBase,
                      highlightColor: darkHighlight,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer(
                          baseColor: darkBase,
                          highlightColor: darkHighlight,
                          child: Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.circularSm,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppShimmer(
                          baseColor: darkBase,
                          highlightColor: darkHighlight,
                          child: Container(
                            width: 140,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.circularSm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 52,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: AppRadius.circularXl,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: AppRadius.circularLg,
                        ),
                        child: Center(
                          child: AppShimmer(
                            baseColor: darkBase,
                            highlightColor: darkHighlight,
                            child: Container(
                              width: 80,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.circularSm,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AppShimmer(
                          baseColor: darkBase,
                          highlightColor: darkHighlight,
                          child: Container(
                            width: 60,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.circularSm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsBarSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          _buildMetricCardSkeleton(),
          const SizedBox(width: 10),
          _buildMetricCardSkeleton(),
          const SizedBox(width: 10),
          _buildMetricCardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildMetricCardSkeleton() {
    return AppShimmer(
      child: Container(
        width: 175,
        height: 125,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.box(width: 80, height: 12),
                AppShimmer.circle(size: 32),
              ],
            ),
            AppShimmer.box(width: 60, height: 22),
            AppShimmer.box(width: 110, height: 14, borderRadius: AppRadius.circularFull),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSkeleton({required double height}) {
    return AppShimmer(
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                AppShimmer.circle(size: 20),
                const SizedBox(width: 10),
                AppShimmer.box(width: 120, height: 14),
              ],
            ),
            AppShimmer.box(width: double.infinity, height: 12),
            AppShimmer.box(width: 200, height: 12),
          ],
        ),
      ),
    );
  }
}
