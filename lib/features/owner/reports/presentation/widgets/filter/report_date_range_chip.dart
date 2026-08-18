import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';

class ReportDateRangeChip extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final Function(String?, String?) onDateRangeSelected;

  const ReportDateRangeChip({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDate = startDate != null && endDate != null;
    final String label = hasDate
        ? '$startDate - $endDate'
        : LocaleKeys.reportsFilterDateRange.tr();

    return InputChip(
      onPressed: () => _showDatePicker(context, hasDate),
      onDeleted: hasDate ? () => onDateRangeSelected(null, null) : null,
      deleteIconColor: Colors.white,
      deleteIcon: const Icon(Icons.close_rounded, size: 16),
      backgroundColor: hasDate ? context.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: hasDate ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: hasDate ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      avatar: Icon(
        Icons.date_range_rounded,
        size: 16,
        color: hasDate ? Colors.white : AppColors.textSecondaryLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      showCheckmark: false,
    );
  }

  Future<void> _showDatePicker(BuildContext context, bool hasDate) async {
    final initialRange = hasDate
        ? DateTimeRange(
            start: DateTime.tryParse(startDate!) ?? DateTime.now(),
            end: DateTime.tryParse(endDate!) ?? DateTime.now(),
          )
        : null;

    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: context.primaryColor,
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        controlsTextStyle: const TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w700,
        ),
        dayTextStyle: const TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        selectedDayTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        cancelButtonTextStyle: const TextStyle(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.w600,
        ),
        okButtonTextStyle: TextStyle(
          color: context.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        centerAlignModePicker: true,
      ),
      dialogSize: const Size(325, 400),
      value: initialRange != null
          ? [initialRange.start, initialRange.end]
          : [],
      borderRadius: AppRadius.circularXl,
    );

    if (result != null && result.isNotEmpty) {
      final start = result.first;
      final end = result.length > 1 ? result[1] : start;
      if (start != null && end != null) {
        final startStr = DateFormat('yyyy-MM-dd').format(start);
        final endStr = DateFormat('yyyy-MM-dd').format(end);
        onDateRangeSelected(startStr, endStr);
      }
    }
  }
}
