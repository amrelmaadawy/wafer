import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/usecases/create_legal_case_use_case.dart';
import '../cubits/create/legal_case_create_cubit.dart';
import '../cubits/create/legal_case_create_state.dart';
import '../cubits/form_data/legal_case_form_data_cubit.dart';
import '../cubits/form_data/legal_case_form_data_state.dart';
import '../../domain/entities/legal_case_item_entity.dart';
import '../../domain/usecases/update_legal_case_use_case.dart';
import '../cubits/update/legal_case_update_cubit.dart';
import '../cubits/update/legal_case_update_state.dart';
import '../widgets/legal_case_step_indicator_widget.dart';
import '../widgets/create_wizard/legal_case_general_info_card.dart';
import '../widgets/create_wizard/legal_case_links_card.dart';
import '../widgets/create_wizard/legal_case_court_parties_card.dart';
import '../widgets/create_wizard/legal_case_financials_card.dart';
import '../widgets/create_wizard/legal_case_notes_card.dart';

class LegalCaseCreateView extends StatefulWidget {
  final LegalCaseItemEntity? legalCaseToEdit;

  const LegalCaseCreateView({super.key, this.legalCaseToEdit});

  @override
  State<LegalCaseCreateView> createState() => _LegalCaseCreateViewState();
}

class _LegalCaseCreateViewState extends State<LegalCaseCreateView> {
  late final LegalCaseFormDataCubit _formDataCubit;
  late final LegalCaseCreateCubit _createCubit;
  late final LegalCaseUpdateCubit _updateCubit;

  bool get isEditMode => widget.legalCaseToEdit != null;

  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();
  // Controllers
  final _caseNumberController = TextEditingController();
  final _courtController = TextEditingController();
  final _circuitController = TextEditingController();
  final _plaintiffController = TextEditingController();
  final _defendantController = TextEditingController();
  final _lawyerController = TextEditingController();
  final _lawyerPhoneController = TextEditingController();
  final _lawyerOfficeController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _hearingDate;

  // Selections
  int? _selectedBranchId;
  int? _selectedPropertyId;
  int? _selectedUnitId;
  int? _selectedContractId;
  int? _selectedInvoiceId;
  String? _selectedCaseType;
  String? _selectedStatus;

  // Wizard state
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  @override
  void initState() {
    super.initState();
    _formDataCubit = sl<LegalCaseFormDataCubit>()..fetchFormData();
    _createCubit = sl<LegalCaseCreateCubit>();
    _updateCubit = sl<LegalCaseUpdateCubit>();

    if (isEditMode) {
      final item = widget.legalCaseToEdit!;
      _caseNumberController.text = item.caseNumber ?? '';
      _selectedBranchId = item.branch?.id;
      _selectedPropertyId = item.property?.id;
      _selectedUnitId = item.unit?.id;
      _selectedContractId = item.contract?.id;
      _selectedInvoiceId = item.invoiceId;
      _courtController.text = item.court ?? '';
      _circuitController.text = item.circuit ?? '';
      _plaintiffController.text = item.parties?.plaintiff ?? '';
      _defendantController.text = item.parties?.defendant ?? '';
      _lawyerController.text = item.lawyer?.name ?? '';
      _lawyerPhoneController.text = item.lawyer?.phone ?? '';
      _lawyerOfficeController.text = item.lawyer?.office ?? '';
      _selectedCaseType = item.caseType;
      _amountController.text = item.amount?.toString() ?? '';
      if (item.hearingDate != null) {
        try {
          _hearingDate = DateTime.parse(item.hearingDate!);
        } catch (_) {}
      }
      _selectedStatus = item.status;
      _notesController.text = item.notes ?? '';
    }
  }

  @override
  void dispose() {
    _formDataCubit.close();
    _createCubit.close();
    _updateCubit.close();
    _caseNumberController.dispose();
    _courtController.dispose();
    _circuitController.dispose();
    _plaintiffController.dispose();
    _defendantController.dispose();
    _lawyerController.dispose();
    _lawyerPhoneController.dispose();
    _lawyerOfficeController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    bool isValid = false;
    if (_currentStep == 0) {
      isValid = _validateStep1();
    } else if (_currentStep == 1) {
      isValid = _validateStep2();
    }

    if (isValid) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  bool _validateStep1() {
    bool isValid = _step1FormKey.currentState?.validate() ?? false;
    if (_selectedBranchId == null) {
      AppToast.showError(context, LocaleKeys.select_branch_validation.tr());
      isValid = false;
    }
    if (_selectedCaseType == null) {
      AppToast.showError(context, LocaleKeys.select_case_type_validation.tr());
      isValid = false;
    }
    if (_selectedStatus == null) {
      AppToast.showError(context, LocaleKeys.select_status_validation.tr());
      isValid = false;
    }
    return isValid;
  }

  bool _validateStep2() {
    return _step2FormKey.currentState?.validate() ?? false;
  }

  void _submitForm() {
    if (!(_step3FormKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_hearingDate == null) {
      AppToast.showError(
        context,
        LocaleKeys.select_hearing_date_validation.tr(),
      );
      return;
    }

    if (isEditMode) {
      final params = UpdateLegalCaseParams(
        id: widget.legalCaseToEdit!.id!,
        caseNumber: _caseNumberController.text.trim(),
        branchId: _selectedBranchId,
        propertyId: _selectedPropertyId,
        unitId: _selectedUnitId,
        contractId: _selectedContractId,
        invoiceId: _selectedInvoiceId,
        court: _courtController.text.trim(),
        circuit: _circuitController.text.trim(),
        plaintiff: _plaintiffController.text.trim(),
        defendant: _defendantController.text.trim(),
        lawyer: _lawyerController.text.trim(),
        lawyerPhone: _lawyerPhoneController.text.trim().isNotEmpty
            ? _lawyerPhoneController.text.trim()
            : null,
        lawyerOffice: _lawyerOfficeController.text.trim().isNotEmpty
            ? _lawyerOfficeController.text.trim()
            : null,
        caseType: _selectedCaseType,
        amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
        hearingDate: DateFormat('yyyy-MM-dd').format(_hearingDate!),
        status: _selectedStatus,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );
      _updateCubit.updateLegalCase(params);
    } else {
      final params = CreateLegalCaseParams(
        caseNumber: _caseNumberController.text.trim(),
        branchId: _selectedBranchId!,
        propertyId: _selectedPropertyId,
        unitId: _selectedUnitId,
        contractId: _selectedContractId,
        invoiceId: _selectedInvoiceId,
        court: _courtController.text.trim(),
        circuit: _circuitController.text.trim(),
        plaintiff: _plaintiffController.text.trim(),
        defendant: _defendantController.text.trim(),
        lawyer: _lawyerController.text.trim(),
        lawyerPhone: _lawyerPhoneController.text.trim().isNotEmpty
            ? _lawyerPhoneController.text.trim()
            : null,
        lawyerOffice: _lawyerOfficeController.text.trim().isNotEmpty
            ? _lawyerOfficeController.text.trim()
            : null,
        caseType: _selectedCaseType!,
        amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
        hearingDate: DateFormat('yyyy-MM-dd').format(_hearingDate!),
        status: _selectedStatus!,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );
      _createCubit.createLegalCase(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _formDataCubit),
        BlocProvider.value(value: _createCubit),
        BlocProvider.value(value: _updateCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LegalCaseCreateCubit, LegalCaseCreateState>(
            listener: (context, state) {
              if (state is LegalCaseCreateSuccess) {
                AppToast.showSuccess(
                  context,
                  LocaleKeys.legal_case_created_success.tr(),
                );
                context.pop(true);
              } else if (state is LegalCaseCreateError) {
                AppToast.showError(context, state.message);
              }
            },
          ),
          BlocListener<LegalCaseUpdateCubit, LegalCaseUpdateState>(
            listener: (context, state) {
              if (state is LegalCaseUpdateSuccess) {
                AppToast.showSuccess(
                  context,
                  LocaleKeys.legal_case_updated_success.tr(),
                );
                context.pop(true);
              } else if (state is LegalCaseUpdateError) {
                AppToast.showError(context, state.message);
              }
            },
          ),
        ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final bool hasChanges =
                _caseNumberController.text.isNotEmpty ||
                _amountController.text.isNotEmpty ||
                _circuitController.text.isNotEmpty ||
                _plaintiffController.text.isNotEmpty ||
                _defendantController.text.isNotEmpty ||
                _lawyerController.text.isNotEmpty ||
                _notesController.text.isNotEmpty ||
                _selectedBranchId != null ||
                _selectedCaseType != null ||
                _selectedStatus != null;

            if (!hasChanges) {
              context.pop();
              return;
            }

            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(LocaleKeys.discard_changes.tr()),
                content: Text(LocaleKeys.discard_changes_message.tr()),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: Text(LocaleKeys.cancel.tr()),
                  ),
                  TextButton(
                    onPressed: () => context.pop(true),
                    child: Text(
                      LocaleKeys.discard.tr(),
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            );

            if (shouldPop == true && context.mounted) {
              context.pop();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                isEditMode
                    ? LocaleKeys.edit_case.tr()
                    : LocaleKeys.add_case.tr(),
                style: AppTextStyles.h4,
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>(
              builder: (context, formDataState) {
                if (formDataState is LegalCaseFormDataLoading ||
                    formDataState is LegalCaseFormDataInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (formDataState is LegalCaseFormDataError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          formDataState.message,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () => _formDataCubit.fetchFormData(),
                          child: Text(LocaleKeys.retry.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (formDataState is LegalCaseFormDataLoaded) {
                  final options = formDataState.formData.options;
                  return Column(
                    children: [
                      LegalCaseStepIndicatorWidget(
                        currentStep: _currentStep,
                        stepTitles: [
                          LocaleKeys.case_basics.tr(),
                          LocaleKeys.court_and_parties.tr(),
                          LocaleKeys.notes.tr(),
                        ],
                        stepIcons: const ['🏛️', '⚖️', '📋'],
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Step 1: General Info
                            Form(
                              key: _step1FormKey,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    LegalCaseGeneralInfoCard(
                                      options: options,
                                      caseNumberController:
                                          _caseNumberController,
                                      selectedBranchId: _selectedBranchId,
                                      selectedCaseType: _selectedCaseType,
                                      selectedStatus: _selectedStatus,
                                      onBranchSelected: (id) => setState(
                                        () => _selectedBranchId = id,
                                      ),
                                      onCaseTypeSelected: (type) => setState(
                                        () => _selectedCaseType = type,
                                      ),
                                      onStatusSelected: (status) => setState(
                                        () => _selectedStatus = status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Step 2: Court & Parties
                            Form(
                              key: _step2FormKey,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    LegalCaseCourtAndPartiesCard(
                                      courtController: _courtController,
                                      circuitController: _circuitController,
                                      plaintiffController: _plaintiffController,
                                      defendantController: _defendantController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Step 3: Links & Financials & Notes
                            Form(
                              key: _step3FormKey,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    LegalCaseLinksCard(
                                      options: options,
                                      selectedPropertyId: _selectedPropertyId,
                                      selectedUnitId: _selectedUnitId,
                                      selectedContractId: _selectedContractId,
                                      onPropertySelected: (id) => setState(() {
                                        _selectedPropertyId = id;
                                        _selectedUnitId = null;
                                        _selectedContractId = null;
                                      }),
                                      onUnitSelected: (id) => setState(() {
                                        _selectedUnitId = id;
                                        _selectedContractId = null;
                                        _selectedInvoiceId = null;
                                      }),
                                      onContractSelected: (id) => setState(() {
                                        _selectedContractId = id;
                                        _selectedInvoiceId = null;
                                      }),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    LegalCaseFinancialsCard(
                                      amountController: _amountController,
                                      hearingDate: _hearingDate,
                                      onSelectDate: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              _hearingDate ?? DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
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
                                        if (date != null) {
                                          setState(() {
                                            _hearingDate = date;
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    LegalCaseNotesCard(
                                      notesController: _notesController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: _currentStep == 0
                                    ? LocaleKeys.cancel.tr()
                                    : LocaleKeys.previous_step.tr(),
                                type: ButtonType.secondary,
                                onPressed: _previousStep,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              flex: 2,
                              child: _currentStep < _totalSteps - 1
                                  ? CustomButton(
                                      text: LocaleKeys.next_step.tr(),
                                      onPressed: _nextStep,
                                    )
                                  : BlocBuilder<
                                      LegalCaseCreateCubit,
                                      LegalCaseCreateState
                                    >(
                                      builder: (context, createState) {
                                        return BlocBuilder<
                                          LegalCaseUpdateCubit,
                                          LegalCaseUpdateState
                                        >(
                                          builder: (context, updateState) {
                                            final isEdit =
                                                widget.legalCaseToEdit != null;
                                            final isLoading = isEdit
                                                ? updateState
                                                      is LegalCaseUpdateLoading
                                                : createState
                                                      is LegalCaseCreateLoading;

                                            return CustomButton(
                                              text: isEdit
                                                  ? LocaleKeys.edit_legal_case
                                                        .tr()
                                                  : LocaleKeys.create_case.tr(),
                                              onPressed: _submitForm,
                                              isLoading: isLoading,
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
