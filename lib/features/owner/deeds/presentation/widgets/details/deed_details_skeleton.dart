import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class DeedDetailsSkeleton extends StatelessWidget {
  const DeedDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Skeleton
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBox(height: 24, width: 150),
                    _buildBox(height: 24, width: 80, borderRadius: AppRadius.circularFull),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBox(height: 16, width: 100),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Info Card Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCardSkeleton(),
          ),
          const SizedBox(height: 20),

          // Location Card Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCardSkeleton(rows: 3),
          ),
          const SizedBox(height: 20),

          // Properties Card Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCardSkeleton(rows: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSkeleton({int rows = 2}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBox(height: 32, width: 32, borderRadius: AppRadius.circularLg),
              const SizedBox(width: 12),
              _buildBox(height: 20, width: 120),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(rows, (index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBox(height: 16, width: 80),
                    _buildBox(height: 16, width: 100),
                  ],
                ),
                if (index < rows - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: AppColors.borderLight),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBox({
    required double height,
    required double width,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? AppRadius.circularSm,
      ),
    );
  }
}
