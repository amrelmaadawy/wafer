import 'package:flutter/material.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/list/unified_bottom_sheet.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../domain/entities/maintenance_query_filter_entity.dart';
import 'filter/maintenance_filter_chips_section.dart';
import 'filter/maintenance_filter_date_field.dart';
import 'filter/maintenance_filter_input_field.dart';

class MaintenanceFilterSheet extends StatefulWidget {
  final MaintenanceQueryFilterEntity initialFilter;
  final ValueChanged<MaintenanceQueryFilterEntity> onApply;

  const MaintenanceFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required MaintenanceQueryFilterEntity currentFilter,
    required ValueChanged<MaintenanceQueryFilterEntity> onApply,
  }) {
    return UnifiedBottomSheet.show(
      context: context,
      builder: (_) => MaintenanceFilterSheet(
        initialFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<MaintenanceFilterSheet> createState() => _MaintenanceFilterSheetState();
}

class _MaintenanceFilterSheetState extends State<MaintenanceFilterSheet> {
  late String? _category;
  late String? _status;
  late String? _priority;
  late String? _costBearer;
  late final TextEditingController _propertyController;
  late final TextEditingController _technicianController;
  late String? _date;

  @override
  void initState() {
    super.initState();
    _category = widget.initialFilter.typeName;
    _status = widget.initialFilter.status;
    _priority = widget.initialFilter.priority;
    _costBearer = widget.initialFilter.costBearer;
    _propertyController = TextEditingController(
      text: widget.initialFilter.propertyName,
    );
    _technicianController = TextEditingController(
      text: widget.initialFilter.technicianName,
    );
    _date = widget.initialFilter.date;
  }

  @override
  void dispose() {
    _propertyController.dispose();
    _technicianController.dispose();
    super.dispose();
  }

  static const _categoryOptions = [
    MaintenanceFilterChipsOption(key: 'HVAC', labelKey: LocaleKeys.maintCatAc),
    MaintenanceFilterChipsOption(key: 'Plumbing', labelKey: LocaleKeys.maintCatPlumbing),
    MaintenanceFilterChipsOption(key: 'Electrical', labelKey: LocaleKeys.maintCatElectrical),
    MaintenanceFilterChipsOption(key: 'Carpentry', labelKey: LocaleKeys.maintCatCarpentry),
    MaintenanceFilterChipsOption(key: 'Painting', labelKey: LocaleKeys.maintCatPainting),
    MaintenanceFilterChipsOption(key: 'General', labelKey: LocaleKeys.maintCatGeneral),
  ];

  static const _statusOptions = [
    MaintenanceFilterChipsOption(key: 'new', labelKey: LocaleKeys.maintenanceStatusNew),
    MaintenanceFilterChipsOption(key: 'pending_supervisor', labelKey: LocaleKeys.maintenanceStatusPendingSupervisor),
    MaintenanceFilterChipsOption(key: 'approved', labelKey: LocaleKeys.maintenanceStatusApproved),
    MaintenanceFilterChipsOption(key: 'assigned', labelKey: LocaleKeys.maintenanceStatusAssigned),
    MaintenanceFilterChipsOption(key: 'in_progress', labelKey: LocaleKeys.maintenanceStatusInProgress),
    MaintenanceFilterChipsOption(key: 'executed', labelKey: LocaleKeys.maintenanceStatusExecuted),
    MaintenanceFilterChipsOption(key: 'pending_closure', labelKey: LocaleKeys.maintenanceStatusPendingClosure),
    MaintenanceFilterChipsOption(key: 'closed', labelKey: LocaleKeys.maintenanceStatusClosed),
    MaintenanceFilterChipsOption(key: 'rejected', labelKey: LocaleKeys.maintenanceStatusRejected),
    MaintenanceFilterChipsOption(key: 'cancelled', labelKey: LocaleKeys.maintenanceStatusCancelled),
    MaintenanceFilterChipsOption(key: 'forwarded', labelKey: LocaleKeys.maintenanceStatusForwarded),
  ];

  static const _priorityOptions = [
    MaintenanceFilterChipsOption(key: 'low', labelKey: LocaleKeys.maintenancePriorityLow),
    MaintenanceFilterChipsOption(key: 'medium', labelKey: LocaleKeys.maintenancePriorityMedium),
    MaintenanceFilterChipsOption(key: 'high', labelKey: LocaleKeys.maintenancePriorityHigh),
    MaintenanceFilterChipsOption(key: 'urgent', labelKey: LocaleKeys.maintenancePriorityUrgent),
  ];

  static const _costBearerOptions = [
    MaintenanceFilterChipsOption(key: 'owner', labelKey: LocaleKeys.maintenanceCostBearerOwner),
    MaintenanceFilterChipsOption(key: 'client', labelKey: LocaleKeys.maintenanceCostBearerClient),
    MaintenanceFilterChipsOption(key: 'company', labelKey: LocaleKeys.maintenanceCostBearerCompany),
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
          _costBearer = null;
          _propertyController.clear();
          _technicianController.clear();
          _date = null;
        });
        widget.onApply(const MaintenanceQueryFilterEntity());
      },
      onApply: () {
        final prop = _propertyController.text.trim();
        final tech = _technicianController.text.trim();
        widget.onApply(
          widget.initialFilter.copyWith(
            typeName: () => _category,
            status: () => _status,
            priority: () => _priority,
            costBearer: () => _costBearer,
            propertyName: () => prop.isNotEmpty ? prop : null,
            technicianName: () => tech.isNotEmpty ? tech : null,
            date: () => _date,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaintenanceFilterChipsSection(
            titleKey: LocaleKeys.maintenanceFilterCategory,
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
          MaintenanceFilterChipsSection(
            titleKey: LocaleKeys.maintenanceFilterCostBearer,
            options: _costBearerOptions,
            selectedValue: _costBearer,
            onSelected: (v) => setState(() => _costBearer = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          MaintenanceFilterInputField(
            controller: _propertyController,
            hintKey: LocaleKeys.filterProperty,
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          MaintenanceFilterInputField(
            controller: _technicianController,
            hintKey: LocaleKeys.filterTechnician,
            icon: Icons.engineering_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          MaintenanceFilterDateField(
            date: _date,
            onDateChanged: (v) => setState(() => _date = v),
          ),
        ],
      ),
    );
  }
}
