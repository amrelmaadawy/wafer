import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../domain/entities/task_form_data_entity.dart';

class TaskClassificationSection extends StatelessWidget {
  final TaskOptionsEntity options;
  final String? selectedStatus;
  final String? selectedPriority;
  final String? selectedCategory;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final ValueChanged<String?> onCategoryChanged;
  final String? Function(String) getError;

  const TaskClassificationSection({
    super.key,
    required this.options,
    required this.selectedStatus,
    required this.selectedPriority,
    required this.selectedCategory,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onCategoryChanged,
    required this.getError,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.tasks_classification.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<String>(
            value: selectedStatus,
            hint: LocaleKeys.tasks_status_input.tr(),
            errorText: getError('status'),
            items: options.statuses.map((e) => e.value).toList(),
            itemLabelBuilder: (val) {
              final m = options.statuses.where((e) => e.value == val);
              return m.isNotEmpty ? m.first.label : val;
            },
            onSelected: onStatusChanged,
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<String>(
            value: selectedPriority,
            hint: LocaleKeys.tasks_priority_input.tr(),
            errorText: getError('priority'),
            items: options.priorities.map((e) => e.value).toList(),
            itemLabelBuilder: (val) {
              final m = options.priorities.where((e) => e.value == val);
              return m.isNotEmpty ? m.first.label : val;
            },
            onSelected: onPriorityChanged,
          ),
          const SizedBox(height: 16),
          CustomDropdownMenu<String>(
            value: selectedCategory,
            hint: LocaleKeys.tasks_category_input.tr(),
            errorText: getError('category'),
            items: options.categories.map((e) => e.value).toList(),
            itemLabelBuilder: (val) {
              final m = options.categories.where((e) => e.value == val);
              return m.isNotEmpty ? m.first.label : val;
            },
            onSelected: onCategoryChanged,
          ),
        ],
      ),
    );
  }
}


