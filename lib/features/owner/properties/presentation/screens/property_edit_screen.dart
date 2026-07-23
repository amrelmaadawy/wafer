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
import '../../domain/entities/property_details_entity.dart';
import '../cubit/edit/property_edit_cubit.dart';
import '../cubit/edit/property_edit_state.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../widgets/create/deed_selector_widget.dart';
import '../../domain/entities/form_branch_entity.dart';
import '../../../../../core/routing/routes.dart';

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
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.property.name);
    _addressController = TextEditingController(text: widget.property.address ?? '');
    _areaController = TextEditingController(
        text: widget.property.area != null ? widget.property.area.toString() : '');
    _descriptionController =
        TextEditingController(text: widget.property.description ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyEditCubit>().init(
            widget.property.id,
            widget.property.branchId,
            widget.property.deedId,
          );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppToast.showError(context, 'يرجى إدخال اسم العقار');
      return;
    }

    final data = {
      'name': name,
      'address': _addressController.text.trim(),
      'area': num.tryParse(_areaController.text.trim()),
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
                      _buildHeaderCard(context),
                      const SizedBox(height: 24),
                      if (state.isLoadingForm)
                        const Center(child: CircularProgressIndicator())
                      else if (state.formData != null) ...[
                        if (state.branches.length > 1) ...[
                          Text(
                            LocaleKeys.propertyCreateSelectBranch.tr(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          CustomDropdownMenu<FormBranchEntity>(
                            items: state.branches,
                            value: state.branches
                                .where((b) => b.id == state.selectedBranchId)
                                .firstOrNull,
                            hint: LocaleKeys.propertyCreateSelectBranch.tr(),
                            itemLabelBuilder: (b) => b.name,
                            onSelected: (b) =>
                                context.read<PropertyEditCubit>().selectBranch(b.id),
                          ),
                          const SizedBox(height: 24),
                        ],
                        DeedSelectorWidget(
                          deeds: state.deeds,
                          selectedDeedId: state.selectedDeedId,
                          onSelect: context.read<PropertyEditCubit>().selectDeed,
                          onCreateNew: () async {
                            final result = await context.push(Routes.ownerDeedsCreate);
                            if (result != null) {
                              if (!context.mounted) return;
                              // Re-fetch form data to get the newly added deed, or add it directly if we had a FormDeedEntity
                              context.read<PropertyEditCubit>().loadFormData();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
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
                      _buildField(
                        _areaController,
                        LocaleKeys.propertyCreateArea.tr(),
                        Icons.square_foot_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        isNumber: true,
                        hint: 'أدخل المساحة بالأرقام فقط (م²)',
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
              _buildBottomNav(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.05),
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.maps_home_work_rounded, color: context.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.code,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.property.propertyType,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularMd,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              widget.property.statusLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, PropertyEditState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: state.isSaving ? null : () => _onSave(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            ),
            child: state.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    LocaleKeys.propertyEditSave.tr(),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
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
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:  TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
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
