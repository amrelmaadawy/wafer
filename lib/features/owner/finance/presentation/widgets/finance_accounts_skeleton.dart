import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class FinanceAccountsSkeleton extends StatelessWidget {
  const FinanceAccountsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 8,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.box(width: 80, height: 16, borderRadius: BorderRadius.circular(4)),
                  AppShimmer.box(width: 60, height: 24, borderRadius: BorderRadius.circular(12)),
                ],
              ),
              const SizedBox(height: 12),
              AppShimmer.box(width: 150, height: 20, borderRadius: BorderRadius.circular(4)),
              const SizedBox(height: 16),
              Row(
                children: [
                  AppShimmer.box(width: 60, height: 20, borderRadius: BorderRadius.circular(10)),
                  const SizedBox(width: 8),
                  AppShimmer.box(width: 80, height: 20, borderRadius: BorderRadius.circular(10)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
