import 'package:flutter/material.dart';
import '../../../../../../core/utils/widgets/app_shimmer.dart';

class PropertyCreateSkeleton extends StatelessWidget {
  const PropertyCreateSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Wizard Progress Bar Skeleton ──────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Expanded(
                child: Row(
                  children: [
                    AppShimmer.circle(size: 32),
                    if (index < 4)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: AppShimmer.box(height: 4),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        
        // ── Step Content Skeleton ─────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Header
              AppShimmer.box(width: 150, height: 24),
              const SizedBox(height: 8),
              AppShimmer.box(width: double.infinity, height: 16),
              const SizedBox(height: 32),
              
              // Dropdowns / Fields
              AppShimmer.box(width: double.infinity, height: 56),
              const SizedBox(height: 16),
              AppShimmer.box(width: double.infinity, height: 56),
              const SizedBox(height: 16),
              AppShimmer.box(width: double.infinity, height: 56),
              const SizedBox(height: 24),
              
              // Map Skeleton or additional info
              AppShimmer.box(
                width: double.infinity,
                height: 150,
                borderRadius: BorderRadius.circular(16),
              ),
            ],
          ),
        ),
        
        // ── Bottom Nav Skeleton ───────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: AppShimmer.box(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
