import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class ReportSkeleton extends StatelessWidget {
  const ReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderSkeleton(),
          const SizedBox(height: 24),
          _buildListSkeleton(),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return AppShimmer(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AppShimmer.circle(size: 24),
                const SizedBox(width: 12),
                AppShimmer.box(width: 120, height: 16),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderItemSkeleton(),
                _buildHeaderItemSkeleton(),
                _buildHeaderItemSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItemSkeleton() {
    return Column(
      children: [
        AppShimmer.box(width: 60, height: 12),
        const SizedBox(height: 8),
        AppShimmer.box(width: 40, height: 20),
      ],
    );
  }

  Widget _buildListSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer.box(width: 140, height: 20),
        const SizedBox(height: 16),
        ...List.generate(4, (index) => _buildCardSkeleton()),
      ],
    );
  }

  Widget _buildCardSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppShimmer(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularLg,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.box(width: 100, height: 16),
                  AppShimmer.box(
                    width: 60,
                    height: 24,
                    borderRadius: AppRadius.circularXl,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  AppShimmer.circle(size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer.box(width: 120, height: 14),
                      const SizedBox(height: 6),
                      AppShimmer.box(width: 80, height: 12),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
