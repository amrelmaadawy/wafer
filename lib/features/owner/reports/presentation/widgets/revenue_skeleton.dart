import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class RevenueSkeleton extends StatelessWidget {
  const RevenueSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _skeletonBox(height: 180),
        const SizedBox(height: 16),
        _skeletonBox(height: 240),
        const SizedBox(height: 16),
        _skeletonBox(height: 100),
        const SizedBox(height: 12),
        _skeletonBox(height: 100),
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
