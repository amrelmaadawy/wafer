import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../core/utils/widgets/app_toast.dart';
import '../../domain/usecases/create_legal_case_use_case.dart';
import '../cubits/create/legal_case_create_cubit.dart';
import '../cubits/create/legal_case_create_state.dart';
import '../cubits/form_data/legal_case_form_data_cubit.dart';
import '../cubits/form_data/legal_case_form_data_state.dart';
import '../../domain/entities/legal_case_form_data_entity.dart';
import '../widgets/legal_case_details_skeleton.dart';
import '../widgets/legal_case_step_indicator_widget.dart';

class LegalCaseCreateView extends StatefulWidget {
  const LegalCaseCreateView({super.key});

  @override
  State<LegalCaseCreateView> createState() => _LegalCaseCreateViewState();
}

class _LegalCaseCreateViewState extends State<LegalCaseCreateView> {
  late final LegalCaseFormDataCubit _formDataCubit;
  late final LegalCaseCreateCubit _createCubit;

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
  }

  @override
  void dispose() {
    _formDataCubit.close();
    _createCubit.close();
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
      AppToast.showError(context, LocaleKeys.select_hearing_date_validation.tr());
      return;
    }

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
      lawyerPhone: _lawyerPhoneController.text.trim().isNotEmpty ? _lawyerPhoneController.text.trim() : null,
      lawyerOffice: _lawyerOfficeController.text.trim().isNotEmpty ? _lawyerOfficeController.text.trim() : null,
      caseType: _selectedCaseType!,
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      hearingDate: DateFormat('yyyy-MM-dd').format(_hearingDate!),
      status: _selectedStatus!,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    _createCubit.createLegalCase(params);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _formDataCubit),
        BlocProvider.value(value: _createCubit),
      ],
      child: BlocListener<LegalCaseCreateCubit, LegalCaseCreateState>(
        listener: (context, state) {
          if (state is LegalCaseCreateSuccess) {
            AppToast.showSuccess(context, LocaleKeys.legal_case_created_success.tr());
            context.pop(true);
          } else if (state is LegalCaseCreateError) {
            AppToast.showError(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.create_legal_case.tr(), style: AppTextStyles.h4),
            centerTitle: true,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          backgroundColor: AppColors.backgroundLight,
          body: BlocBuilder<LegalCaseFormDataCubit, LegalCaseFormDataState>(
            builder: (context, formDataState) {
              if (formDataState is LegalCaseFormDataLoading || formDataState is LegalCaseFormDataInitial) {
                return const LegalCaseDetailsSkeleton();
              }

              if (formDataState is LegalCaseFormDataError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        formDataState.message,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
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
                      stepTitles: const [
                        'أساسيات القضية',
                        'المحكمة والأطراف',
                        'التفاصيل والختام',
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildGeneralInfoCard(options),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildCourtAndPartiesCard(),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildLinksCard(options),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildFinancialsAndDatesCard(),
                                  const SizedBox(height: AppSpacing.md),
                                  _buildNotesCard(),
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
                              text: _currentStep == 0 ? LocaleKeys.cancel.tr() : LocaleKeys.previous_step.tr(),
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
                                : BlocBuilder<LegalCaseCreateCubit, LegalCaseCreateState>(
                                    builder: (context, createState) {
                                      return CustomButton(
                                        text: LocaleKeys.create_case.tr(),
                                        onPressed: _submitForm,
                                        isLoading: createState is LegalCaseCreateLoading,
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
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabeledDropdown<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabelBuilder,
    required void Function(T) onSelected,
  }) {
    final bool isEmpty = items.isEmpty;
    final String displayHint = isEmpty ? 'لا توجد بيانات متاحة' : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Opacity(
          opacity: isEmpty ? 0.6 : 1.0,
          child: CustomDropdownMenu<T>(
            hint: displayHint,
            value: items.contains(value) ? value : null,
            items: items,
            itemLabelBuilder: itemLabelBuilder,
            onSelected: isEmpty ? null : onSelected,
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralInfoCard(LegalCaseOptionsEntity? options) {
    final branches = options?.branches ?? [];
    final caseTypes = options?.caseTypes ?? [];
    final statuses = options?.statuses ?? [];

    return _buildCard(
      title: LocaleKeys.general_info.tr(),
      children: [
        CustomTextField(
          controller: _caseNumberController,
          label: LocaleKeys.case_number.tr(),
          hintText: LocaleKeys.enter_case_number.tr(),
          validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.branch.tr(),
          hint: LocaleKeys.select_branch.tr(),
          value: branches.where((b) => b.id == _selectedBranchId).firstOrNull,
          items: branches.where((b) => b.id != null && b.name != null && b.name!.trim().isNotEmpty).toList(),
          itemLabelBuilder: (b) => b.name ?? '',
          onSelected: (b) => setState(() => _selectedBranchId = b.id),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.case_type.tr(),
          hint: LocaleKeys.select_case_type.tr(),
          value: caseTypes.where((t) => t.value == _selectedCaseType).firstOrNull,
          items: caseTypes.where((t) => t.value != null && t.label != null && t.label!.trim().isNotEmpty).toList(),
          itemLabelBuilder: (t) => t.label ?? '',
          onSelected: (t) => setState(() => _selectedCaseType = t.value),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.status.tr(),
          hint: LocaleKeys.select_status.tr(),
          value: statuses.where((s) => s.value == _selectedStatus).firstOrNull,
          items: statuses.where((s) => s.value != null && s.label != null && s.label!.trim().isNotEmpty).toList(),
          itemLabelBuilder: (s) => s.label ?? '',
          onSelected: (s) => setState(() => _selectedStatus = s.value),
        ),
      ],
    );
  }

  Widget _buildLinksCard(LegalCaseOptionsEntity? options) {
    final properties = options?.properties ?? [];
    final units = options?.units ?? [];
    final contracts = options?.contracts ?? [];
    final invoices = options?.invoices ?? [];

    return _buildCard(
      title: LocaleKeys.related_links.tr(),
      children: [
        _buildLabeledDropdown(
          label: LocaleKeys.property.tr(),
          hint: LocaleKeys.select_property_optional.tr(),
          value: properties.where((p) => p.id == _selectedPropertyId).firstOrNull,
          items: properties.where((p) => p.id != null && p.name != null && p.name!.trim().isNotEmpty).toList(),
          itemLabelBuilder: (p) => p.name ?? '',
          onSelected: (p) {
            setState(() {
              _selectedPropertyId = p.id;
              _selectedUnitId = null;
              _selectedContractId = null;
              _selectedInvoiceId = null;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.unit.tr(),
          hint: LocaleKeys.select_unit_optional.tr(),
          value: units.where((u) => u.id == _selectedUnitId).firstOrNull,
          items: units.where((u) => 
            u.id != null && 
            u.name != null && 
            u.name!.trim().isNotEmpty &&
            (_selectedPropertyId == null || u.propertyId == _selectedPropertyId)
          ).toList(),
          itemLabelBuilder: (u) => u.name ?? '',
          onSelected: (u) {
            setState(() {
              _selectedUnitId = u.id;
              if (u.propertyId != null) _selectedPropertyId = u.propertyId;
              _selectedContractId = null;
              _selectedInvoiceId = null;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.contract.tr(),
          hint: LocaleKeys.select_contract_optional.tr(),
          value: contracts.where((c) => c.id == _selectedContractId).firstOrNull,
          items: contracts.where((c) => 
            c.id != null && 
            c.contractNumber != null && 
            c.contractNumber!.trim().isNotEmpty &&
            (_selectedPropertyId == null || c.propertyId == _selectedPropertyId) &&
            (_selectedUnitId == null || c.unitId == _selectedUnitId)
          ).toList(),
          itemLabelBuilder: (c) => c.contractNumber ?? '',
          onSelected: (c) {
            setState(() {
              _selectedContractId = c.id;
              if (c.propertyId != null) _selectedPropertyId = c.propertyId;
              if (c.unitId != null) _selectedUnitId = c.unitId;
              _selectedInvoiceId = null;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLabeledDropdown(
          label: LocaleKeys.invoice.tr(),
          hint: LocaleKeys.select_invoice_optional.tr(),
          value: invoices.where((i) => i.id == _selectedInvoiceId).firstOrNull,
          items: invoices.where((i) {
            if (i.id == null || i.invoiceNumber == null || i.invoiceNumber!.trim().isEmpty) return false;
            if (_selectedContractId != null && i.contractId != _selectedContractId) return false;
            
            final relatedContract = contracts.where((c) => c.id == i.contractId).firstOrNull;
            if (relatedContract != null) {
              if (_selectedPropertyId != null && relatedContract.propertyId != _selectedPropertyId) return false;
              if (_selectedUnitId != null && relatedContract.unitId != _selectedUnitId) return false;
            } else if (_selectedPropertyId != null || _selectedUnitId != null) {
              return false; // Invoice has no valid contract but property/unit is selected
            }
            return true;
          }).toList(),
          itemLabelBuilder: (i) => i.invoiceNumber ?? '',
          onSelected: (i) {
            setState(() {
              _selectedInvoiceId = i.id;
              if (i.contractId != null) {
                _selectedContractId = i.contractId;
                final relatedContract = contracts.where((c) => c.id == i.contractId).firstOrNull;
                if (relatedContract != null) {
                  if (relatedContract.propertyId != null) _selectedPropertyId = relatedContract.propertyId;
                  if (relatedContract.unitId != null) _selectedUnitId = relatedContract.unitId;
                }
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCourtAndPartiesCard() {
    return _buildCard(
      title: LocaleKeys.court_and_parties.tr(),
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _courtController,
                label: LocaleKeys.court.tr(),
                hintText: LocaleKeys.enter_court.tr(),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomTextField(
                controller: _circuitController,
                label: LocaleKeys.circuit.tr(),
                hintText: LocaleKeys.enter_circuit.tr(),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _plaintiffController,
                label: LocaleKeys.plaintiff.tr(),
                hintText: LocaleKeys.enter_plaintiff.tr(),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomTextField(
                controller: _defendantController,
                label: LocaleKeys.defendant.tr(),
                hintText: LocaleKeys.enter_defendant.tr(),
                validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: _lawyerController,
          label: LocaleKeys.lawyer.tr(),
          hintText: LocaleKeys.enter_lawyer.tr(),
          validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _lawyerPhoneController,
                label: LocaleKeys.lawyer_phone.tr(),
                hintText: LocaleKeys.optional.tr(),
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomTextField(
                controller: _lawyerOfficeController,
                label: LocaleKeys.lawyer_office.tr(),
                hintText: LocaleKeys.optional.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialsAndDatesCard() {
    return _buildCard(
      title: LocaleKeys.financials_and_dates.tr(),
      children: [
        CustomTextField(
          controller: _amountController,
          label: LocaleKeys.amount.tr(),
          hintText: LocaleKeys.enter_amount.tr(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) => v == null || v.isEmpty ? LocaleKeys.required_field.tr() : null,
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _hearingDate ?? DateTime.now(),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularMd,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.hearing_date.tr(),
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryLight),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _hearingDate != null ? DateFormat('yyyy-MM-dd').format(_hearingDate!) : LocaleKeys.select_date.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _hearingDate != null ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.calendar_today, color: context.primaryColor, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    return _buildCard(
      title: LocaleKeys.notes.tr(),
      children: [
        CustomTextField(
          controller: _notesController,
          label: LocaleKeys.notes.tr(),
          hintText: LocaleKeys.optional.tr(),
          maxLines: 4,
        ),
      ],
    );
  }
}
