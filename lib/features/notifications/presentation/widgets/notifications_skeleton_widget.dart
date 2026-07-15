import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/widgets/app_shimmer.dart';

class NotificationsSkeletonWidget extends StatelessWidget {
  const NotificationsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularXxl,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmer.box(
              width: 44,
              height: 44,
              borderRadius: AppRadius.circularLg,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer.box(
                    width: double.infinity,
                    height: 14,
                    borderRadius: AppRadius.circularSm,
                  ),
                  const SizedBox(height: 8),
                  AppShimmer.box(
                    width: 180,
                    height: 12,
                    borderRadius: AppRadius.circularSm,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmer.box(
                        width: 70,
                        height: 10,
                        borderRadius: AppRadius.circularSm,
                      ),
                      AppShimmer.box(
                        width: 50,
                        height: 10,
                        borderRadius: AppRadius.circularSm,
                      ),
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
