import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../domain/entities/task_form_data_entity.dart';

class TaskLinkingDatesSection extends StatelessWidget {
  final TaskOptionsEntity options;
  final int? selectedPropertyId;
  final int? selectedDeedId;
  final int? selectedBranchId;
  final TextEditingController startDateController;
  final TextEditingController dueDateController;
  final ValueChanged<int?> onPropertyChanged;
  final ValueChanged<int?> onDeedChanged;
  final ValueChanged<int?> onBranchChanged;
  final Future<void> Function(BuildContext, TextEditingController) selectDate;
  final String? Function(String) getError;

  const TaskLinkingDatesSection({
    super.key,
    required this.options,
    required this.selectedPropertyId,
    required this.selectedDeedId,
    required this.selectedBranchId,
    required this.startDateController,
    required this.dueDateController,
    required this.onPropertyChanged,
    required this.onDeedChanged,
    required this.onBranchChanged,
    required this.selectDate,
    required this.getError,
  });

  @override
  Widget build(BuildContext context) {
    var filteredProperties = options.properties;
    if (selectedDeedId != null) {
      final matchedDeeds = options.deeds.where((e) => e.id == selectedDeedId);
      if (matchedDeeds.isNotEmpty) {
        final deed = matchedDeeds.first;
        if (deed.propertyId != null) {
          filteredProperties = filteredProperties.where((e) => e.id == deed.propertyId).toList();
        } else {
          filteredProperties = filteredProperties.where((e) => e.deedId == selectedDeedId).toList();
        }
      }
    }

    var filteredDeeds = options.deeds;
    if (selectedPropertyId != null) {
      final matchedProps = options.properties.where((e) => e.id == selectedPropertyId);
      if (matchedProps.isNotEmpty) {
        final prop = matchedProps.first;
        if (prop.deedId != null) {
          filteredDeeds = filteredDeeds.where((e) => e.id == prop.deedId).toList();
        } else {
          filteredDeeds = filteredDeeds.where((e) => e.propertyId == selectedPropertyId).toList();
        }
      }
    }

    return AppSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.tasks_linking.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<int>(
            value: selectedPropertyId,
            hint: LocaleKeys.tasks_property_input.tr(),
            errorText: getError('property_id'),
            items: filteredProperties.map((e) => e.id).toList(),
            itemLabelBuilder: (id) {
              final m = options.properties.where((e) => e.id == id);
              return m.isNotEmpty ? (m.first.name ?? id.toString()) : id.toString();
            },
            onSelected: onPropertyChanged,
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<int>(
            value: selectedDeedId,
            hint: LocaleKeys.tasks_deed_input.tr(),
            errorText: getError('deed_id'),
            items: filteredDeeds.map((e) => e.id).toList(),
            itemLabelBuilder: (id) {
              final m = options.deeds.where((e) => e.id == id);
              return m.isNotEmpty ? (m.first.name ?? id.toString()) : id.toString();
            },
            onSelected: onDeedChanged,
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<int>(
            value: selectedBranchId,
            hint: LocaleKeys.tasks_branch_input.tr(),
            errorText: getError('branch_id'),
            items: options.branches.map((e) => e.id).toList(),
            itemLabelBuilder: (id) {
              final m = options.branches.where((e) => e.id == id);
              return m.isNotEmpty ? m.first.name : id.toString();
            },
            onSelected: onBranchChanged,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => selectDate(context, startDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: startDateController,
                label: LocaleKeys.tasks_start_date_input.tr(),
                errorText: getError('start_date'),
                readOnly: true,
                prefixIcon: Icon(Icons.calendar_today_rounded, color: context.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => selectDate(context, dueDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: dueDateController,
                label: LocaleKeys.tasks_due_date_input.tr(),
                errorText: getError('due_date'),
                readOnly: true,
                prefixIcon: Icon(Icons.calendar_today_rounded, color: context.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






