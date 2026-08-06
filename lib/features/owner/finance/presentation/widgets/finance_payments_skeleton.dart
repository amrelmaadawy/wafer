import 'package:flutter/material.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class FinancePaymentsSkeleton extends StatelessWidget {
  const FinancePaymentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                  Row(
                    children: [
                      AppShimmer.box(width: 36, height: 36, borderRadius: BorderRadius.circular(12)),
                      const SizedBox(width: 12),
                      AppShimmer.box(width: 100, height: 20),
                    ],
                  ),
                  AppShimmer.box(width: 70, height: 24, borderRadius: BorderRadius.circular(16)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer.box(width: 50, height: 14),
                      const SizedBox(height: 4),
                      AppShimmer.box(width: 80, height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppShimmer.box(width: 60, height: 14),
                      const SizedBox(height: 4),
                      AppShimmer.box(width: 90, height: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.box(width: 120, height: 16),
                  AppShimmer.box(width: 80, height: 24, borderRadius: BorderRadius.circular(8)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
