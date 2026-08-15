import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../domain/entities/create_task_params.dart';
import '../cubit/create_task/create_task_cubit.dart';
import '../cubit/create_task/create_task_state.dart';
import '../cubits/form_data/task_form_data_cubit.dart';
import '../cubits/form_data/task_form_data_state.dart';

import '../cubits/update_task/update_task_cubit.dart';
import '../cubits/update_task/update_task_state.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/update_task_params.dart';

class OwnerCreateTaskScreen extends StatefulWidget {
  final TaskEntity? taskToEdit;

  const OwnerCreateTaskScreen({super.key, this.taskToEdit});

  @override
  State<OwnerCreateTaskScreen> createState() => _OwnerCreateTaskScreenState();
}

class _OwnerCreateTaskScreenState extends State<OwnerCreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _startDateController = TextEditingController();
  final _dueDateController = TextEditingController();

  String? _selectedStatus;
  String? _selectedPriority;
  String? _selectedCategory;
  int? _selectedPropertyId;
  int? _selectedDeedId;
  int? _selectedBranchId;
  double _progress = 0;
  Map<String, dynamic>? _validationErrors;

  String? _getError(String field) {
    if (_validationErrors == null) return null;
    final err = _validationErrors![field];
    if (err is List && err.isNotEmpty) return err.first.toString();
    if (err != null) return err.toString();
    return null;
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskFormDataCubit>().fetchFormData();
    if (widget.taskToEdit != null) {
      _initEditData();
    }
  }

  void _initEditData() {
    final task = widget.taskToEdit!;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _notesController.text = task.notes ?? '';
    _startDateController.text = task.dates?.startDate ?? '';
    _dueDateController.text = task.dates?.dueDate ?? '';
    
    _selectedStatus = task.status?.value;
    _selectedPriority = task.priority?.value;
    _selectedCategory = task.category?.value;
    
    _selectedPropertyId = task.property?.id;
    _selectedDeedId = task.deed?.id;
    _selectedBranchId = task.branch?.id;
    _progress = task.progress.toDouble();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() {
    setState(() => _validationErrors = null);
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.taskToEdit != null) {
        final params = UpdateTaskParams(
          id: widget.taskToEdit!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          status: _selectedStatus,
          priority: _selectedPriority,
          category: _selectedCategory,
          propertyId: _selectedPropertyId,
          deedId: _selectedDeedId,
          branchId: _selectedBranchId,
          startDate: _startDateController.text.isEmpty ? null : _startDateController.text,
          dueDate: _dueDateController.text.isEmpty ? null : _dueDateController.text,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          progress: _progress.toInt(),
          assignees: const [],
        );
        context.read<UpdateTaskCubit>().updateTask(params);
      } else {
        final params = CreateTaskParams(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          status: _selectedStatus,
          priority: _selectedPriority,
          category: _selectedCategory,
          propertyId: _selectedPropertyId,
          deedId: _selectedDeedId,
          branchId: _selectedBranchId,
          startDate: _startDateController.text.isEmpty ? null : _startDateController.text,
          dueDate: _dueDateController.text.isEmpty ? null : _dueDateController.text,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          progress: _progress.toInt(),
          assignees: const [],
          imageDescriptions: const [],
        );
        context.read<CreateTaskCubit>().submitTask(params);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? LocaleKeys.tasks_update_title.tr() : LocaleKeys.tasks_create_title.tr(),
      ),
      body: isEditing ? _buildEditBody(context) : _buildCreateBody(context),
    );
  }

  Widget _buildCreateBody(BuildContext context) {
    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          AppToast.showSuccess(context, LocaleKeys.tasks_create_success.tr());
          context.pop(true);
        } else if (state is CreateTaskError) {
          setState(() => _validationErrors = state.validationErrors);
          AppToast.showError(context, state.message);
        }
      },
      child: _buildFormContent(context),
    );
  }

  Widget _buildEditBody(BuildContext context) {
    return BlocListener<UpdateTaskCubit, UpdateTaskState>(
      listener: (context, state) {
        if (state is UpdateTaskSuccess) {
          AppToast.showSuccess(context, LocaleKeys.tasks_update_success.tr());
          context.pop(true);
        } else if (state is UpdateTaskFailure) {
          setState(() => _validationErrors = state.validationErrors);
          AppToast.showError(context, state.message);
        }
      },
      child: _buildFormContent(context),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    return BlocBuilder<TaskFormDataCubit, TaskFormDataState>(
      builder: (context, state) {
        if (state is TaskFormDataLoading) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppShimmer.box(height: 200, borderRadius: AppRadius.circularLg),
              const SizedBox(height: 16),
              AppShimmer.box(height: 200, borderRadius: AppRadius.circularLg),
            ],
          );
        } else if (state is TaskFormDataError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<TaskFormDataCubit>().fetchFormData(),
              );
            } else if (state is TaskFormDataLoaded) {
              final options = state.formData.options;

              var filteredProperties = options.properties;
              if (_selectedDeedId != null) {
                final matchedDeeds = options.deeds.where((e) => e.id == _selectedDeedId);
                if (matchedDeeds.isNotEmpty) {
                  final deed = matchedDeeds.first;
                  if (deed.propertyId != null) {
                    filteredProperties = filteredProperties.where((e) => e.id == deed.propertyId).toList();
                  } else {
                    filteredProperties = filteredProperties.where((e) => e.deedId == _selectedDeedId).toList();
                  }
                }
              }

              var filteredDeeds = options.deeds;
              if (_selectedPropertyId != null) {
                final matchedProps = options.properties.where((e) => e.id == _selectedPropertyId);
                if (matchedProps.isNotEmpty) {
                  final prop = matchedProps.first;
                  if (prop.deedId != null) {
                    filteredDeeds = filteredDeeds.where((e) => e.id == prop.deedId).toList();
                  } else {
                    filteredDeeds = filteredDeeds.where((e) => e.propertyId == _selectedPropertyId).toList();
                  }
                }
              }

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  key: const PageStorageKey('task_form_scroll'),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    // Basic Info
                    AppSurfaceCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.tasks_basic_info.tr(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _titleController,
                            label: LocaleKeys.tasks_title_input.tr(),
                            errorText: _getError('title'),
                            validator: (val) => val == null || val.trim().isEmpty ? LocaleKeys.tasks_validation_required.tr() : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _descriptionController,
                            label: LocaleKeys.tasks_description_input.tr(),
                            errorText: _getError('description'),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _notesController,
                            label: LocaleKeys.tasks_notes_input.tr(),
                            errorText: _getError('notes'),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Classification
                    AppSurfaceCard(
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
                            value: _selectedStatus,
                            hint: LocaleKeys.tasks_status_input.tr(),
                            errorText: _getError('status'),
                            items: options.statuses.map((e) => e.value).toList(),
                            itemLabelBuilder: (val) => options.statuses.firstWhere((e) => e.value == val).label,
                            onSelected: (val) => setState(() => _selectedStatus = val),
                          ),
                          const SizedBox(height: 16),
                          CustomDropdownMenu<String>(
                            value: _selectedPriority,
                            hint: LocaleKeys.tasks_priority_input.tr(),
                            errorText: _getError('priority'),
                            items: options.priorities.map((e) => e.value).toList(),
                            itemLabelBuilder: (val) => options.priorities.firstWhere((e) => e.value == val).label,
                            onSelected: (val) => setState(() => _selectedPriority = val),
                          ),
                          const SizedBox(height: 16),
                          CustomDropdownMenu<String>(
                            value: _selectedCategory,
                            hint: LocaleKeys.tasks_category_input.tr(),
                            errorText: _getError('category'),
                            items: options.categories.map((e) => e.value).toList(),
                            itemLabelBuilder: (val) => options.categories.firstWhere((e) => e.value == val).label,
                            onSelected: (val) => setState(() => _selectedCategory = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Linking & Dates
                    AppSurfaceCard(
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
                            value: _selectedPropertyId,
                            hint: LocaleKeys.tasks_property_input.tr(),
                            errorText: _getError('property_id'),
                            items: filteredProperties.map((e) => e.id).toList(),
                            itemLabelBuilder: (id) => options.properties.firstWhere((e) => e.id == id).name ?? id.toString(),
                            onSelected: (val) {
                              setState(() {
                                _selectedPropertyId = val;
                                if (_selectedDeedId != null) {
                                  bool matches = false;
                                  try {
                                    final prop = options.properties.firstWhere((e) => e.id == val);
                                    final deed = options.deeds.firstWhere((e) => e.id == _selectedDeedId);
                                    if (prop.deedId == _selectedDeedId || deed.propertyId == val) matches = true;
                                  } catch (_) {}
                                  if (!matches) _selectedDeedId = null;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomDropdownMenu<int>(
                            value: _selectedDeedId,
                            hint: LocaleKeys.tasks_deed_input.tr(),
                            errorText: _getError('deed_id'),
                            items: filteredDeeds.map((e) => e.id).toList(),
                            itemLabelBuilder: (id) => options.deeds.firstWhere((e) => e.id == id).name ?? id.toString(),
                            onSelected: (val) {
                              setState(() {
                                _selectedDeedId = val;
                                if (_selectedPropertyId != null) {
                                  bool matches = false;
                                  try {
                                    final deed = options.deeds.firstWhere((e) => e.id == val);
                                    final prop = options.properties.firstWhere((e) => e.id == _selectedPropertyId);
                                    if (deed.propertyId == _selectedPropertyId || prop.deedId == val) matches = true;
                                  } catch (_) {}
                                  if (!matches) _selectedPropertyId = null;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomDropdownMenu<int>(
                            value: _selectedBranchId,
                            hint: LocaleKeys.tasks_branch_input.tr(),
                            errorText: _getError('branch_id'),
                            items: options.branches.map((e) => e.id).toList(),
                            itemLabelBuilder: (id) => options.branches.firstWhere((e) => e.id == id).name,
                            onSelected: (val) => setState(() => _selectedBranchId = val),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context, _startDateController),
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: _startDateController,
                                label: LocaleKeys.tasks_start_date_input.tr(),
                                errorText: _getError('start_date'),
                                readOnly: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context, _dueDateController),
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: _dueDateController,
                                label: LocaleKeys.tasks_due_date_input.tr(),
                                errorText: _getError('due_date'),
                                readOnly: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isEditing) ...[
                      const SizedBox(height: 16),
                      AppSurfaceCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.progress.tr(),
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: context.appOnSurfaceColor),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: context.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: AppRadius.circularLg,
                                  ),
                                  child: Text(
                                    '${_progress.toInt()}%',
                                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w800, color: context.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 8,
                                activeTrackColor: context.primaryColor,
                                inactiveTrackColor: context.primaryColor.withValues(alpha: 0.1),
                                tickMarkShape: SliderTickMarkShape.noTickMark,
                                overlayColor: context.primaryColor.withValues(alpha: 0.2),
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14, elevation: 4),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                                trackShape: const RoundedRectSliderTrackShape(),
                              ),
                              child: Slider(
                                value: _progress,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                onChanged: (val) => setState(() => _progress = val),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    
                    if (isEditing)
                      BlocBuilder<UpdateTaskCubit, UpdateTaskState>(
                        builder: (context, updateState) {
                          return CustomButton(
                            onPressed: _submit,
                            isLoading: updateState is UpdateTaskLoading,
                            text: LocaleKeys.tasks_update_title.tr(),
                          );
                        },
                      )
                    else
                      BlocBuilder<CreateTaskCubit, CreateTaskState>(
                        builder: (context, createState) {
                          return CustomButton(
                            onPressed: _submit,
                            isLoading: createState is CreateTaskLoading,
                            text: LocaleKeys.tasks_submit.tr(),
                          );
                        },
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
               ),
              );
            }
            return const SizedBox.shrink();
          },
    );
  }
}
