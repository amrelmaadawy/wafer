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

  // New location controllers
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _regionController;
  late TextEditingController _streetController;
  late TextEditingController _buildingController;

  // New specs controllers
  late TextEditingController _lengthController;
  late TextEditingController _widthController;

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

    _cityController = TextEditingController(text: widget.property.city ?? '');
    _districtController = TextEditingController(text: widget.property.district ?? '');
    _regionController = TextEditingController(text: widget.property.region ?? '');
    _streetController = TextEditingController(text: widget.property.streetName ?? '');
    _buildingController = TextEditingController(text: widget.property.buildingNumber ?? '');

    _lengthController = TextEditingController(
        text: widget.property.length != null ? widget.property.length.toString() : '');
    _widthController = TextEditingController(
        text: widget.property.width != null ? widget.property.width.toString() : '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyEditCubit>().init(
            widget.property.id,
            widget.property.branchId,
            widget.property.deedId,
            widget.property.propertyType,
            usageType: widget.property.usageType,
            amenities: widget.property.amenities,
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
    _cityController.dispose();
    _districtController.dispose();
    _regionController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
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

    final cubitState = context.read<PropertyEditCubit>().state;

    final data = {
      'name': name,
      'address': _addressController.text.trim(),
      'area': num.tryParse(_areaController.text.trim()),
      'construction_year': year,
      'description': _descriptionController.text.trim(),
      'city': _cityController.text.trim(),
      'district': _districtController.text.trim(),
      'region': _regionController.text.trim(),
      'street_name': _streetController.text.trim(),
      'building_number': _buildingController.text.trim(),
      'length': num.tryParse(_lengthController.text.trim()),
      'width': num.tryParse(_widthController.text.trim()),
      if (cubitState.selectedUsageType != null) 'usage_type': cubitState.selectedUsageType,
      'amenities': cubitState.selectedAmenities,
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

                      // Section 1: Basic Info
                      _buildSectionHeader('المعلومات الأساسية', Icons.info_outline_rounded),
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
                              hint: 'المساحة (م²)',
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
                      const SizedBox(height: 32),

                      // Section 2: Location Details
                      _buildSectionHeader('تفاصيل الموقع', Icons.map_outlined),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _cityController,
                              'المدينة',
                              Icons.location_city_outlined,
                              hint: 'مثال: الرياض',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              _districtController,
                              'الحي',
                              Icons.holiday_village_outlined,
                              hint: 'مثال: النرجس',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _regionController,
                              'المنطقة',
                              Icons.explore_outlined,
                              hint: 'مثال: الوسطى',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              _buildingController,
                              'رقم المبنى',
                              Icons.tag_rounded,
                              isNumber: true,
                              hint: 'مثال: 12',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        _streetController,
                        'اسم الشارع',
                        Icons.add_road_rounded,
                        hint: 'مثال: شارع الملك فهد',
                      ),
                      const SizedBox(height: 32),

                      // Section 3: Specifications
                      _buildSectionHeader('المواصفات والأبعاد', Icons.straighten_rounded),
                      const SizedBox(height: 16),
                      Text(
                        'نوع الاستخدام',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomDropdownMenu<String>(
                        items: const ['residential', 'commercial', 'administrative', 'mixed'],
                        value: state.selectedUsageType,
                        hint: 'اختر نوع الاستخدام',
                        itemLabelBuilder: (val) {
                          switch (val) {
                            case 'residential':
                              return 'سكني';
                            case 'commercial':
                              return 'تجاري';
                            case 'administrative':
                              return 'إداري';
                            case 'mixed':
                              return 'مختلط';
                            default:
                              return val;
                          }
                        },
                        onSelected: (val) => context.read<PropertyEditCubit>().selectUsageType(val),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              _lengthController,
                              'الطول (م)',
                              Icons.height_rounded,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              isNumber: true,
                              hint: 'مثال: 30',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              _widthController,
                              'العرض (م)',
                              Icons.swap_horiz_rounded,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              isNumber: true,
                              hint: 'مثال: 20',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Section 4: Amenities
                      _buildSectionHeader('المميزات والإضافات', Icons.star_outline_rounded),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 10,
                        children: const [
                          ('elevator', 'مصعد'),
                          ('parking', 'موقف سيارات'),
                          ('security', 'حراسة 24/7'),
                          ('pool', 'مسبح'),
                          ('gym', 'صالة رياضية'),
                          ('generator', 'مولد كهرباء'),
                          ('central_ac', 'تكييف مركزي'),
                          ('internet', 'ألياف بصرية (إنترنت)'),
                        ].map((amenity) {
                          final isSelected = state.selectedAmenities.contains(amenity.$1);
                          return FilterChip(
                            label: Text(amenity.$2),
                            selected: isSelected,
                            onSelected: (_) => context.read<PropertyEditCubit>().toggleAmenity(amenity.$1),
                            selectedColor: context.primaryColor.withValues(alpha: 0.12),
                            checkmarkColor: context.primaryColor,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1,
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.circularFull),
                          );
                        }).toList(),
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
          ),
          child: Icon(icon, size: 18, color: context.primaryColor),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Divider(color: Color(0xFFE2E8F0), height: 1),
        ),
      ],
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
