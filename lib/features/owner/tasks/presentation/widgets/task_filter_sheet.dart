import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/unified_bottom_sheet.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/tasks_filter_params.dart';
import '../../../maintenance/presentation/widgets/filter/maintenance_filter_chips_section.dart';
import '../../../maintenance/presentation/widgets/filter/maintenance_filter_date_field.dart';

class TaskFilterSheet extends StatefulWidget {
  final TasksFilterParams initialFilter;
  final ValueChanged<TasksFilterParams> onApply;

  const TaskFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required TasksFilterParams currentFilter,
    required ValueChanged<TasksFilterParams> onApply,
  }) {
    return UnifiedBottomSheet.show(
      context: context,
      builder: (_) => TaskFilterSheet(
        initialFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<TaskFilterSheet> createState() => _TaskFilterSheetState();
}

class _TaskFilterSheetState extends State<TaskFilterSheet> {
  late String? _category;
  late String? _status;
  late String? _priority;
  late String? _dueDate;

  @override
  void initState() {
    super.initState();
    _category = widget.initialFilter.category;
    _status = widget.initialFilter.status;
    _priority = widget.initialFilter.priority;
    _dueDate = widget.initialFilter.dueDate;
  }

  static const _categoryOptions = [
    MaintenanceFilterChipsOption(key: 'legal', labelKey: LocaleKeys.taskCategoryLegal),
    MaintenanceFilterChipsOption(key: 'maintenance', labelKey: LocaleKeys.taskCategoryMaintenance),
    MaintenanceFilterChipsOption(key: 'financial', labelKey: LocaleKeys.taskCategoryFinancial),
    MaintenanceFilterChipsOption(key: 'administrative', labelKey: LocaleKeys.taskCategoryAdministrative),
    MaintenanceFilterChipsOption(key: 'documentation', labelKey: LocaleKeys.taskCategoryDocumentation),
    MaintenanceFilterChipsOption(key: 'inspection', labelKey: LocaleKeys.taskCategoryInspection),
    MaintenanceFilterChipsOption(key: 'other', labelKey: LocaleKeys.taskCategoryOther),
  ];

  static const _statusOptions = [
    MaintenanceFilterChipsOption(key: 'new', labelKey: LocaleKeys.taskFilterNew),
    MaintenanceFilterChipsOption(key: 'in_progress', labelKey: LocaleKeys.taskFilterInProgress),
    MaintenanceFilterChipsOption(key: 'review', labelKey: LocaleKeys.taskFilterReview),
    MaintenanceFilterChipsOption(key: 'completed', labelKey: LocaleKeys.taskFilterCompleted),
    MaintenanceFilterChipsOption(key: 'cancelled', labelKey: LocaleKeys.taskFilterCancelled),
  ];

  static const _priorityOptions = [
    MaintenanceFilterChipsOption(key: 'low', labelKey: LocaleKeys.taskPriorityLow),
    MaintenanceFilterChipsOption(key: 'medium', labelKey: LocaleKeys.taskPriorityMedium),
    MaintenanceFilterChipsOption(key: 'high', labelKey: LocaleKeys.taskPriorityHigh),
    MaintenanceFilterChipsOption(key: 'urgent', labelKey: LocaleKeys.taskPriorityUrgent),
  ];

  @override
  Widget build(BuildContext context) {
    return UnifiedBottomSheet(
      titleLocaleKey: LocaleKeys.filterOptionsTitle,
      onReset: () {
        setState(() {
          _category = null;
          _status = null;
          _priority = null;
          _dueDate = null;
        });
        widget.onApply(const TasksFilterParams());
      },
      onApply: () {
        widget.onApply(
          widget.initialFilter.copyWith(
            category: _category,
            status: _status,
            priority: _priority,
            dueDate: _dueDate,
            clearCategory: _category == null,
            clearStatus: _status == null,
            clearPriority: _priority == null,
            clearDueDate: _dueDate == null,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaintenanceFilterChipsSection(
            titleKey: LocaleKeys.taskFilterCategory,
            options: _categoryOptions,
            selectedValue: _category,
            onSelected: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          MaintenanceFilterChipsSection(
            titleKey: LocaleKeys.filterStatus,
            options: _statusOptions,
            selectedValue: _status,
            onSelected: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          MaintenanceFilterChipsSection(
            titleKey: LocaleKeys.filterPriority,
            options: _priorityOptions,
            selectedValue: _priority,
            onSelected: (v) => setState(() => _priority = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          MaintenanceFilterDateField(
            date: _dueDate,
            onDateChanged: (v) => setState(() => _dueDate = v),
          ),
        ],
      ),
    );
  }
}
