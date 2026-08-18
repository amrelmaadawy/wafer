import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';

class MaintenanceFilterDateField extends StatelessWidget {
  final String? date;
  final ValueChanged<String?> onDateChanged;

  const MaintenanceFilterDateField({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) {
          onDateChanged(DateFormat('yyyy-MM-dd').format(picked));
        }
      },
      borderRadius: AppRadius.circularLg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_rounded, size: 20, color: primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                date ?? LocaleKeys.filterDate.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: date != null
                      ? context.appOnSurfaceColor
                      : context.appSecondaryTextColor,
                  fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () => onDateChanged(null),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}
