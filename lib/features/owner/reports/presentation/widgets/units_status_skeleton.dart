import 'package:flutter/material.dart';
import '../../../../../core/theme/app_radius.dart';

class UnitsStatusSkeleton extends StatelessWidget {
  const UnitsStatusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        // Filter bar skeleton
        Row(
          children: [
            Container(
              width: 140,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: AppRadius.circularLg,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 140,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: AppRadius.circularLg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Summary header skeleton
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: AppRadius.circularXxl,
          ),
        ),
        const SizedBox(height: 20),
        // List items
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: AppRadius.circularLg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
