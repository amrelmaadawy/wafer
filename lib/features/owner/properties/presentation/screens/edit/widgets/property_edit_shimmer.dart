import 'package:flutter/material.dart';
import '../../../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../../../core/theme/app_radius.dart';

class PropertyEditShimmer extends StatelessWidget {
  const PropertyEditShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Shimmer
        _buildLabelShimmer(),
        const SizedBox(height: 8),
        _buildFieldShimmer(),
        const SizedBox(height: 24),

        // Deed Selector Shimmer
        _buildLabelShimmer(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFieldShimmer(height: 60)),
            const SizedBox(width: 12),
            Expanded(child: _buildFieldShimmer(height: 60)),
          ],
        ),
        const SizedBox(height: 24),

        // Basic Info Header Shimmer
        Row(
          children: [
            AppShimmer.circle(size: 32),
            const SizedBox(width: 12),
            AppShimmer.box(width: 120, height: 20),
          ],
        ),
        const SizedBox(height: 16),

        // Form fields
        _buildFieldShimmer(),
        const SizedBox(height: 16),
        _buildFieldShimmer(),
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
    );
  }

  Widget _buildLabelShimmer() {
    return AppShimmer.box(
      width: 100,
      height: 16,
      borderRadius: AppRadius.circularSm,
    );
  }

  Widget _buildFieldShimmer({double height = 56}) {
    return AppShimmer.box(height: height, borderRadius: AppRadius.circularMd);
  }
}
