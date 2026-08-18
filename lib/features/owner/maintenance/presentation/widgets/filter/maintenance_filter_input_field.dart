import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/theme_context.dart';

class MaintenanceFilterInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintKey;
  final IconData icon;

  const MaintenanceFilterInputField({
    super.key,
    required this.controller,
    required this.hintKey,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 14,
          color: context.appOnSurfaceColor,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintKey.tr(),
          hintStyle: TextStyle(
            fontSize: 13,
            color: context.appSecondaryTextColor,
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: context.appSecondaryTextColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
