import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/presentation/widgets/custom_dropdown_menu.dart';
import 'package:wafer/core/utils/widgets/custom_text_field.dart';
import 'package:wafer/core/utils/widgets/custom_button.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/di/service_locator.dart' as di;
import '../../domain/entities/maintenance_item_entity.dart';
import '../cubit/assign_maintenance/owner_assign_maintenance_cubit.dart';
import '../cubit/assign_maintenance/owner_assign_maintenance_state.dart';
import '../cubit/details/owner_maintenance_details_cubit.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';

class OwnerAssignMaintenanceBottomSheet extends StatefulWidget {
  final MaintenanceItemEntity item;

  const OwnerAssignMaintenanceBottomSheet({super.key, required this.item});

  static Future<bool?> show(BuildContext context, MaintenanceItemEntity item) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OwnerAssignMaintenanceBottomSheet(item: item),
    );
  }

  @override
  State<OwnerAssignMaintenanceBottomSheet> createState() =>
      _OwnerAssignMaintenanceBottomSheetState();
}

class _OwnerAssignMaintenanceBottomSheetState
    extends State<OwnerAssignMaintenanceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _taskDetailsController = TextEditingController();
  final _dueDateController = TextEditingController();

  int? _selectedTechnicianId;

  final List<TextEditingController> _taskControllers = [];

  // Dummy technicians for now
  final List<Map<String, dynamic>> _dummyTechnicians = [
    {'id': 1, 'name': 'محمد أحمد (مكيفات)'},
    {'id': 2, 'name': 'سعيد علي (كهرباء)'},
    {'id': 3, 'name': 'فني عام'},
  ];

  @override
  void initState() {
    super.initState();
    _addTaskField();
  }

  @override
  void dispose() {
    _taskDetailsController.dispose();
    _dueDateController.dispose();
    for (var controller in _taskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTaskField() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  void _removeTaskField(int index) {
    setState(() {
      final controller = _taskControllers.removeAt(index);
      controller.dispose();
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final tasks = _taskControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      context.read<OwnerAssignMaintenanceCubit>().assignMaintenanceRequest(
        id: widget.item.id ?? 0,
        technicianId: _selectedTechnicianId ?? 1,
        dueDate: _dueDateController.text,
        taskDetails: _taskDetailsController.text,
        tasks: tasks,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider(
      create: (_) => di.sl<OwnerAssignMaintenanceCubit>(),
      child: BlocConsumer<OwnerAssignMaintenanceCubit, OwnerAssignMaintenanceState>(
        listener: (context, state) {
          if (state is OwnerAssignMaintenanceSuccess) {
            AppToast.showSuccess(
              context,
              LocaleKeys.maintenanceAssignSuccess.tr(),
            );
            context.read<OwnerMaintenanceDetailsCubit>().getMaintenanceDetails(
              widget.item.id ?? 0,
            );
            Navigator.pop(context);
          } else if (state is OwnerAssignMaintenanceError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: bottomPadding + 24,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.maintenanceAssignTechnician.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.maintenanceTechnician.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomDropdownMenu<int>(
                          hint: LocaleKeys.maintenanceSelectTechnician.tr(),
                          items: _dummyTechnicians.map((t) => t['id'] as int).toList(),
                          value: _selectedTechnicianId,
                          itemLabelBuilder: (id) => _dummyTechnicians.firstWhere((t) => t['id'] == id)['name'] as String,
                          onSelected: (value) {
                            setState(() {
                              _selectedTechnicianId = value;
                            });
                          },
                          errorText: _formKey.currentState?.validate() == false && _selectedTechnicianId == null ? LocaleKeys.maintenanceRequiredField.tr() : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _selectDueDate(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _dueDateController,
                          label: LocaleKeys.maintenanceDueDate.tr(),
                          hintText: 'YYYY-MM-DD',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.maintenanceRequiredField.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _taskDetailsController,
                      label: LocaleKeys.maintenanceTaskDetails.tr(),
                      hintText: LocaleKeys.maintenanceTaskDetailsHint.tr(),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.maintenanceRequiredField.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LocaleKeys.maintenanceSubTasks.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addTaskField,
                          icon: const Icon(Icons.add),
                          label: Text(LocaleKeys.maintenanceAddSubTask.tr()),
                          style: TextButton.styleFrom(
                            foregroundColor: context.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._taskControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: controller,
                                label: '${LocaleKeys.maintenanceSubTask.tr()} ${index + 1}',
                                hintText:
                                    '${LocaleKeys.maintenanceSubTask.tr()} ${index + 1}',
                                validator: (value) {
                                  if (index == 0 &&
                                      (value == null || value.isEmpty)) {
                                    return LocaleKeys.maintenanceRequiredField
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_taskControllers.length > 1) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: AppColors.error,
                                onPressed: () => _removeTaskField(index),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: LocaleKeys.maintenanceAssignSubmit.tr(),
                      onPressed: state is OwnerAssignMaintenanceLoading
                          ? () {}
                          : () => _submit(context),
                      isLoading: state is OwnerAssignMaintenanceLoading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
