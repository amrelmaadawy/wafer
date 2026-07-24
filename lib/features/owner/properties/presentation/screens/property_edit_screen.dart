import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/routing/routes.dart';
import '../../domain/entities/property_details_entity.dart';
import '../../domain/entities/form_branch_entity.dart';
import '../cubit/edit/property_edit_cubit.dart';
import '../cubit/edit/property_edit_state.dart';
import '../widgets/create/deed_selector_widget.dart';
import '../widgets/create/property_type_selector_widget.dart';
import '../widgets/edit/property_edit_bottom_nav.dart';
import '../widgets/edit/property_edit_header_card.dart';

class PropertyEditScreen extends StatefulWidget {
  final PropertyDetailsEntity property;

  const PropertyEditScreen({super.key, required this.property});

  @override
  State<PropertyEditScreen> createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends State<PropertyEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.property.name);
    _addressController = TextEditingController(text: widget.property.address ?? '');
    _areaController = TextEditingController(
        text: widget.property.area != null ? widget.property.area.toString() : '');
    _yearController = TextEditingController(
        text: widget.property.constructionYear != null ? widget.property.constructionYear.toString() : '');
    _descriptionController = TextEditingController(text: widget.property.description ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyEditCubit>().init(
            widget.property.id,
            widget.property.branchId,
            widget.property.deedId,
            widget.property.propertyType,
          );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.showError(context, LocaleKeys.propertyCreateNameRequired.tr());
      return;
    }

    final yearText = _yearController.text.trim();
    final year = int.tryParse(yearText);
    if (yearText.isNotEmpty && (year == null || year < 1900 || year > 2030)) {
      AppToast.showError(context, LocaleKeys.propertyCreateYearInvalid.tr());
      return;
    }

    final data = {
      'name': name,
      'address': _addressController.text.trim(),
      'area': num.tryParse(_areaController.text.trim()),
      'construction_year': year,
      'description': _descriptionController.text.trim(),
    }..removeWhere((key, value) => value == null || (value is String && value.isEmpty));

    context.read<PropertyEditCubit>().saveChanges(widget.property.id, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.propertyEditTitle.tr(),
      ),
      body: BlocConsumer<PropertyEditCubit, PropertyEditState>(
        listener: (context, state) {
          if (state.isSuccess) {
            AppToast.showSuccess(context, LocaleKeys.propertyEditSuccess.tr());
            context.pop();
          } else if (state.errorMessage != null) {
            AppToast.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PropertyEditHeaderCard(property: widget.property),
                      const SizedBox(height: 24),
                      if (state.isLoadingForm)
                        const Center(child: CircularProgressIndicator())
                      else if (state.formData != null) ...[
                        if (state.branches.length > 1) ...[
                          Text(
                            LocaleKeys.propertyCreateSelectBranch.tr(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<FormBranchEntity>(
                            items: state.branches,
                            value: state.branches.where((b) => b.id == state.selectedBranchId).firstOrNull,
                            hint: LocaleKeys.propertyCreateSelectBranch.tr(),
                            itemLabelBuilder: (b) => b.name,
                            onSelected: (b) => context.read<PropertyEditCubit>().selectBranch(b.id),
                          ),
                          const SizedBox(height: 24),
                        ],
                        DeedSelectorWidget(
                          deeds: state.deeds,
                          selectedDeedId: state.selectedDeedId,
                          onSelect: context.read<PropertyEditCubit>().selectDeed,
                          onCreateNew: () async {
                            final result = await context.push(Routes.ownerDeedsCreate);
                            if (result != null && context.mounted) {
                              context.read<PropertyEditCubit>().loadFormData();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        if (state.formData?.options.propertyTypes != null) ...[
                          Text(
                            LocaleKeys.propertyCreateSelectType.tr(),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          PropertyTypeSelectorWidget(
                            propertyTypes: state.formData!.options.propertyTypes,
                            selectedType: state.selectedType,
                            onSelect: context.read<PropertyEditCubit>().selectType,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                      Text(
                        LocaleKeys.propertyDetailsBasicInfo.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        _nameController,
                        LocaleKeys.propertyCreatePropertyName.tr(),
                        Icons.apartment_rounded,
                        isRequired: true,
                        hint: 'أدخل اسم العقار (مثال: عمارة الياسمين)',
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        _addressController,
                        LocaleKeys.propertyCreateAddress.tr(),
                        Icons.location_on_outlined,
                        hint: 'أدخل العنوان بالتفصيل...',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _areaController,
                              LocaleKeys.propertyCreateArea.tr(),
                              Icons.square_foot_outlined,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              isNumber: true,
                              hint: 'أدخل المساحة بالأرقام فقط (م²)',
                              suffixText: LocaleKeys.propertyDetailsAreaUnit.tr(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              _yearController,
                              LocaleKeys.propertyCreateYearLabel.tr(),
                              Icons.calendar_today_outlined,
                              keyboardType: TextInputType.number,
                              isNumber: true,
                              hint: 'YYYY',
                              maxLength: 4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        _descriptionController,
                        LocaleKeys.propertyCreateDescription.tr(),
                        Icons.notes_rounded,
                        maxLines: 4,
                        hint: 'أضف وصفاً مفصلاً للعقار ومميزاته...',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              PropertyEditBottomNav(state: state, onSave: () => _onSave(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isNumber = false,
    String? hint,
    int? maxLength,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight)),
            if (isRequired)
              const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: isNumber
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
                ]
              : maxLength != null
                  ? [LengthLimitingTextInputFormatter(maxLength)]
                  : null,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
            suffixText: suffixText,
            suffixStyle: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
            prefixIcon: maxLines > 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Icon(icon, size: 20, color: context.primaryColor),
                  )
                : Icon(icon, size: 20, color: context.primaryColor),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.circularLg,
              borderSide: BorderSide(color: context.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
