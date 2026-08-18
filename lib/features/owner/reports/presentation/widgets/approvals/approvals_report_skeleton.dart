import 'package:flutter/material.dart';

class ApprovalsReportSkeleton extends StatelessWidget {
  const ApprovalsReportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonBox(100)),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonBox(100)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSkeletonBox(100)),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonBox(100)),
          ],
        ),
        const SizedBox(height: 24),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSkeletonBox(80),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonBox(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
