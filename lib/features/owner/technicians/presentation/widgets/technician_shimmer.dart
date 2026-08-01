import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class TechnicianShimmer extends StatelessWidget {
  const TechnicianShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularLg,
              border: Border.all(color: AppColors.borderLight),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar shimmer
                const AppShimmer(
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name shimmer
                      AppShimmer(
                        child: Container(
                          height: 20,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.circularSm,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Role shimmer
                      AppShimmer(
                        child: Container(
                          height: 16,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.circularSm,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Stats row shimmer
                      Row(
                        children: [
                          AppShimmer(
                            child: Container(
                              height: 16,
                              width: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.circularSm,
                              ),
                            ),
                          ),
                          const Spacer(),
                          AppShimmer(
                            child: Container(
                              height: 16,
                              width: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppRadius.circularSm,
                              ),
                            ),
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
      },
    );
  }
}
