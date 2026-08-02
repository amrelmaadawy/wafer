import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../cubits/add_stage/legal_case_add_stage_cubit.dart';
import '../cubits/add_stage/legal_case_add_stage_state.dart';

class AddLegalCaseStageBottomSheet extends StatefulWidget {
  final int legalCaseId;

  const AddLegalCaseStageBottomSheet({
    super.key,
    required this.legalCaseId,
  });

  @override
  State<AddLegalCaseStageBottomSheet> createState() => _AddLegalCaseStageBottomSheetState();
}

class _AddLegalCaseStageBottomSheetState extends State<AddLegalCaseStageBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _stageDateController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedStage;
  String? _selectedStageError;

  final List<String> _stages = [
    'تحت الإجراء',
    'قيد النظر',
    'تأجيل الجلسة',
    'صدر حكم ابتدائي',
    'قيد التنفيذ',
    'مكتسبة القطعية',
    'منتهية صلحاً',
    'صرف النظر / مشطوبة',
  ];

  @override
  void dispose() {
    _stageDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _stageDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() {
    setState(() {
      _selectedStageError = _selectedStage == null ? LocaleKeys.stage_name_required.tr() : null;
    });

    if (_formKey.currentState!.validate() && _selectedStageError == null) {
      context.read<LegalCaseAddStageCubit>().addStage(
            legalCaseId: widget.legalCaseId,
            stageName: _selectedStage!,
            stageDate: _stageDateController.text.trim(),
            notes: _notesController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LegalCaseAddStageCubit, LegalCaseAddStageState>(
      listener: (context, state) {
        if (state is LegalCaseAddStageSuccess) {
          AppToast.showSuccess(
            context,
            LocaleKeys.stage_added_success.tr(),
          );
          context.pop(true);
        } else if (state is LegalCaseAddStageError) {
          AppToast.showError(
            context,
            state.message,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.add_stage.tr(),
                        style: AppTextStyles.h4.copyWith(color: AppColors.textPrimaryLight),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondaryLight),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.borderLight, height: 1),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    LocaleKeys.stage_name.tr(),
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomDropdownMenu<String>(
                    items: _stages,
                    value: _selectedStage,
                    hint: '-- اختر المرحلة --',
                    itemLabelBuilder: (stage) => stage,
                    onSelected: (stage) {
                      setState(() {
                        _selectedStage = stage;
                        _selectedStageError = null;
                      });
                    },
                    errorText: _selectedStageError,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    LocaleKeys.stage_date.tr(),
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _stageDateController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.stage_date.tr(),
                          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.textSecondaryLight),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.circularMd,
                            borderSide: const BorderSide(color: AppColors.borderLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.circularMd,
                            borderSide: const BorderSide(color: AppColors.borderLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.circularMd,
                            borderSide: const BorderSide(color: AppColors.primaryDark),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.stage_date_required.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    LocaleKeys.notes.tr(),
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.notes.tr(),
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.circularMd,
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.circularMd,
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.circularMd,
                        borderSide: const BorderSide(color: AppColors.primaryDark),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<LegalCaseAddStageCubit, LegalCaseAddStageState>(
                    builder: (context, state) {
                      final isLoading = state is LegalCaseAddStageLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.circularMd,
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                LocaleKeys.save_stage.tr(),
                                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
