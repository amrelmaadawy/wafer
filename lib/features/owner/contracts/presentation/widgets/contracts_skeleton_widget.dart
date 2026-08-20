import 'package:flutter/material.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';

class ContractsSkeletonWidget extends StatelessWidget {
  const ContractsSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildSkeletonCard(context),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: context.appBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmer.circle(size: 18),
              const SizedBox(width: 8),
              Expanded(child: AppShimmer.box(height: 16)),
              const SizedBox(width: 12),
              AppShimmer.box(width: 70, height: 22, borderRadius: AppRadius.circularSm),
              const SizedBox(width: 8),
              AppShimmer.box(width: 14, height: 14, borderRadius: BorderRadius.circular(4)),
            ],
          ),
          const SizedBox(height: 14),
          AppShimmer.box(width: 200, height: 14),
          const SizedBox(height: 8),
          Row(
            children: [
              AppShimmer.circle(size: 17),
              const SizedBox(width: 8),
              Expanded(child: AppShimmer.box(height: 12)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmer.box(width: 120, height: 18),
              AppShimmer.box(width: 90, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
