import 'package:flutter/material.dart';
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

  const ReportsFilterBar({
    super.key,
    required this.filterOptions,
    required this.selectedPropertyId,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onPropertySelected,
    required this.onDateRangeSelected,
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

    return ActionChip(
      onPressed: () async {
        final initialRange = hasDateFilter
            ? DateTimeRange(
                start: DateTime.parse(selectedStartDate!),
                end: DateTime.parse(selectedEndDate!),
              )
            : null;

        final result = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDateRange: initialRange,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: context.primaryColor,
                ),
              ),
              child: child!,
            );
          },
        );

        if (result != null) {
          final start = DateFormat('yyyy-MM-dd').format(result.start);
          final end = DateFormat('yyyy-MM-dd').format(result.end);
          onDateRangeSelected(start, end);
        }
      },
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
