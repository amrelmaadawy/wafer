import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';

class MaintenanceSkeletonWidget extends StatefulWidget {
  const MaintenanceSkeletonWidget({super.key});

  @override
  State<MaintenanceSkeletonWidget> createState() =>
      _MaintenanceSkeletonWidgetState();
}

class _MaintenanceSkeletonWidgetState extends State<MaintenanceSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildSkeletonCard(),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 120, height: 16, color: AppColors.borderLight),
              Container(
                width: 75,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: AppRadius.circularSm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(width: 180, height: 14, color: AppColors.borderLight),
          const SizedBox(height: 8),
          Container(width: 130, height: 13, color: AppColors.borderLight),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderLight, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 110, height: 16, color: AppColors.borderLight),
              Container(width: 110, height: 14, color: AppColors.borderLight),
            ],
          ),
        ],
      ),
    );
  }
}
