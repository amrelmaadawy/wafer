import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../domain/entities/create_task_params.dart';
import '../cubits/create_task/create_task_cubit.dart';
import '../cubits/create_task/create_task_state.dart';
import '../cubits/form_data/task_form_data_cubit.dart';
import '../cubits/form_data/task_form_data_state.dart';
import '../cubits/update_task/update_task_cubit.dart';
import '../cubits/update_task/update_task_state.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/update_task_params.dart';
import '../widgets/create_task/task_basic_info_section.dart';
import '../widgets/create_task/task_classification_section.dart';
import '../widgets/create_task/task_linking_dates_section.dart';
import '../widgets/create_task/task_progress_section.dart';

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
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              key: const PageStorageKey('task_form_scroll'),
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TaskBasicInfoSection(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    notesController: _notesController,
                    getError: _getError,
                  ),
                  const SizedBox(height: 16),
                  TaskClassificationSection(
                    options: state.formData.options,
                    selectedStatus: _selectedStatus,
                    selectedPriority: _selectedPriority,
                    selectedCategory: _selectedCategory,
                    onStatusChanged: (val) => setState(() => _selectedStatus = val),
                    onPriorityChanged: (val) => setState(() => _selectedPriority = val),
                    onCategoryChanged: (val) => setState(() => _selectedCategory = val),
                    getError: _getError,
                  ),
                  const SizedBox(height: 16),
                  TaskLinkingDatesSection(
                    options: state.formData.options,
                    selectedPropertyId: _selectedPropertyId,
                    selectedDeedId: _selectedDeedId,
                    selectedBranchId: _selectedBranchId,
                    startDateController: _startDateController,
                    dueDateController: _dueDateController,
                    onPropertyChanged: (val) {
                      setState(() {
                        _selectedPropertyId = val;
                        if (_selectedDeedId != null) {
                          bool matches = false;
                          try {
                            final propMatch = state.formData.options.properties.where((e) => e.id == val);
                            final deedMatch = state.formData.options.deeds.where((e) => e.id == _selectedDeedId);
                            if (propMatch.isNotEmpty && deedMatch.isNotEmpty) {
                              if (propMatch.first.deedId == _selectedDeedId || deedMatch.first.propertyId == val) {
                                matches = true;
                              }
                            }
                          } catch (_) {}
                          if (!matches) _selectedDeedId = null;
                        }
                      });
                    },
                    onDeedChanged: (val) {
                      setState(() {
                        _selectedDeedId = val;
                        if (_selectedPropertyId != null) {
                          bool matches = false;
                          try {
                            final deedMatch = state.formData.options.deeds.where((e) => e.id == val);
                            final propMatch = state.formData.options.properties.where((e) => e.id == _selectedPropertyId);
                            if (deedMatch.isNotEmpty && propMatch.isNotEmpty) {
                              if (deedMatch.first.propertyId == _selectedPropertyId || propMatch.first.deedId == val) {
                                matches = true;
                              }
                            }
                          } catch (_) {}
                          if (!matches) _selectedPropertyId = null;
                        }
                      });
                    },
                    onBranchChanged: (val) => setState(() => _selectedBranchId = val),
                    selectDate: _selectDate,
                    getError: _getError,
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    TaskProgressSection(
                      progress: _progress,
                      onChanged: (val) => setState(() => _progress = val),
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

