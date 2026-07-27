import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ReportEmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;

  const ReportEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondaryLight.withValues(alpha: 0.5);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: effectiveColor,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
