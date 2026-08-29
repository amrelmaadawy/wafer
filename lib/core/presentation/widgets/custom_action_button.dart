import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const CustomActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 32.0,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularMd,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Icon(icon, color: color, size: iconSize),
          ),
        ),
      ),
    );
  }
}
