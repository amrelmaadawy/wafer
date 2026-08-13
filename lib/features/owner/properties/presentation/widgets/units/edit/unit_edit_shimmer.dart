import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';

class UnitEditShimmer extends StatelessWidget {
  const UnitEditShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionShimmer(),
            const SizedBox(height: 24),
            _buildSectionShimmer(),
            const SizedBox(height: 24),
            _buildSectionShimmer(isSmall: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionShimmer({bool isSmall = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularMd,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildFieldShimmer()),
              const SizedBox(width: 16),
              Expanded(child: _buildFieldShimmer()),
            ],
          ),
          if (!isSmall) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildFieldShimmer()),
                const SizedBox(width: 16),
                Expanded(child: _buildFieldShimmer()),
              ],
            ),
            const SizedBox(height: 16),
            _buildFieldShimmer(height: 100),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldShimmer({double height = 48}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularSm,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularLg,
          ),
        ),
      ],
    );
  }
}


