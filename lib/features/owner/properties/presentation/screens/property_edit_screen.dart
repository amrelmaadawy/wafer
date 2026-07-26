import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
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

// New section imports
import 'edit/widgets/edit_basic_info_section.dart';
import 'edit/widgets/edit_location_section.dart';
import 'edit/widgets/edit_specs_section.dart';

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

                      EditBasicInfoSection(
                        nameController: _nameController,
                        addressController: _addressController,
                        areaController: _areaController,
                        yearController: _yearController,
                        descriptionController: _descriptionController,
                      ),
                      const SizedBox(height: 32),

                      EditLocationSection(
                        cityController: _cityController,
                        districtController: _districtController,
                        regionController: _regionController,
                        buildingController: _buildingController,
                        streetController: _streetController,
                      ),
                      const SizedBox(height: 32),

                      EditSpecsSection(
                        state: state,
                        lengthController: _lengthController,
                        widthController: _widthController,
                      ),
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
}
