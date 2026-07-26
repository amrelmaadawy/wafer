import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/revenue_report_entity.dart';

class ReportsFilterBar extends StatelessWidget {
  final RevenueFilterOptionsEntity filterOptions;
  final int? selectedPropertyId;
  final String? selectedStartDate;
  final String? selectedEndDate;
  final Function(int?) onPropertySelected;
  final Function(String?, String?) onDateRangeSelected;
  final VoidCallback onReset;

  const ReportsFilterBar({
    super.key,
    required this.filterOptions,
    required this.selectedPropertyId,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onPropertySelected,
    required this.onDateRangeSelected,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildDateRangeChip(context),
          const SizedBox(width: 8),
          _buildPropertyChip(context),
          if (selectedPropertyId != null || (selectedStartDate != null && selectedEndDate != null)) ...[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded, color: Colors.red, size: 20),
                tooltip: 'إعادة تعيين',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRangeChip(BuildContext context) {
    final bool hasDateFilter =
        selectedStartDate != null && selectedEndDate != null;
    final String label = hasDateFilter
        ? '$selectedStartDate - $selectedEndDate'
        : 'Select Date Range'; // fallback

    return InputChip(
      onPressed: () async {
        final initialRange = hasDateFilter
            ? DateTimeRange(
                start: DateTime.parse(selectedStartDate!),
                end: DateTime.parse(selectedEndDate!),
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
      },
      onDeleted: hasDateFilter ? () => onDateRangeSelected('', '') : null,
      deleteIconColor: Colors.white,
      deleteIcon: const Icon(Icons.close_rounded, size: 16),
      backgroundColor: hasDateFilter ? context.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: hasDateFilter ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: hasDateFilter ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      avatar: Icon(
        Icons.date_range_rounded,
        size: 16,
        color: hasDateFilter ? Colors.white : AppColors.textSecondaryLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      showCheckmark: false,
    );
  }

  Widget _buildPropertyChip(BuildContext context) {
    final hasProperty = selectedPropertyId != null;
    final selectedProp = filterOptions.properties.cast<PropertyFilterItemEntity?>().firstWhere(
          (p) => p?.id == selectedPropertyId,
          orElse: () => null,
        );
    final String label = selectedProp?.displayName ?? LocaleKeys.propertiesFilterAll.tr();

    return ActionChip(
      onPressed: () {
        _showPropertySelectionSheet(context);
      },
      backgroundColor: hasProperty ? context.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(
          color: hasProperty ? context.primaryColor : AppColors.borderLight,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: hasProperty ? Colors.white : AppColors.textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      avatar: Icon(
        Icons.apartment_rounded,
        size: 16,
        color: hasProperty ? Colors.white : AppColors.textSecondaryLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  void _showPropertySelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Property', // fallback
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filterOptions.properties.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text(LocaleKeys.propertiesFilterAll.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: selectedPropertyId == null
                          ? Icon(Icons.check_circle, color: context.primaryColor)
                          : null,
                      onTap: () {
                        onPropertySelected(null);
                        Navigator.pop(context);
                      },
                    );
                  }
                  final prop = filterOptions.properties[index - 1];
                  return ListTile(
                    title: Text(prop.displayName),
                    subtitle: Text(prop.code, style: const TextStyle(fontSize: 12)),
                    trailing: selectedPropertyId == prop.id
                        ? Icon(Icons.check_circle, color: context.primaryColor)
                        : null,
                    onTap: () {
                      onPropertySelected(prop.id);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
