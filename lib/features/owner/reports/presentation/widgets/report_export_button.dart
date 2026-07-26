import 'package:flutter/material.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class ReportExportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportExportButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.circularMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularMd,
              border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.print_rounded, color: context.primaryColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  'تصدير',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
