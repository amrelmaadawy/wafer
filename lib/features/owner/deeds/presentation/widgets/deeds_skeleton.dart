import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class DeedsSkeleton extends StatelessWidget {
  const DeedsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularXl,
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(width: 44, height: 44, borderRadius: BorderRadius.circular(12)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmer.box(width: 120, height: 16),
                          const SizedBox(height: 8),
                          AppShimmer.box(width: 80, height: 12),
                        ],
                      ),
                    ),
                    AppShimmer.box(width: 60, height: 24, borderRadius: BorderRadius.circular(24)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: AppShimmer.box(width: double.infinity, height: 32)),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer.box(width: double.infinity, height: 32)),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer.box(width: double.infinity, height: 32)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
