import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class OccupancySkeleton extends StatelessWidget {
  const OccupancySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _skeletonBox(height: 170),
        const SizedBox(height: 16),
        _skeletonBox(height: 150),
        const SizedBox(height: 12),
        _skeletonBox(height: 150),
        const SizedBox(height: 12),
        _skeletonBox(height: 150),
      ],
    );
  }

  Widget _skeletonBox({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
    );
  }
}
