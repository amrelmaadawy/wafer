import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../core/di/service_locator.dart';
import '../../domain/entities/option_value_label_entity.dart';
import '../cubit/edit_unit/unit_edit_cubit.dart';
import '../cubit/edit_unit/unit_edit_state.dart';
import '../widgets/units/edit/unit_edit_shimmer.dart';

class UnitEditScreen extends StatelessWidget {
  final int propertyId;
  final int unitId;

  const UnitEditScreen({
    super.key,
    required this.propertyId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitEditCubit>()..loadData(propertyId, unitId),
      child: _UnitEditScreenContent(unitId: unitId),
    );
  }
}

class _UnitEditScreenContent extends StatefulWidget {
  final int unitId;
  const _UnitEditScreenContent({required this.unitId});

  @override
  State<_UnitEditScreenContent> createState() => _UnitEditScreenContentState();
}

class _UnitEditScreenContentState extends State<_UnitEditScreenContent> {
  final _formKey = GlobalKey<FormState>();

  // Basic
  late TextEditingController _nameController;
  late TextEditingController _unitNumberController;
  late TextEditingController _descriptionController;

  // Dimensions
  late TextEditingController _floorNumberController;
  late TextEditingController _areaController;
  late TextEditingController _roomsController;
  late TextEditingController _bathroomsController;

  // Pricing
  late TextEditingController _rentPriceController;

  // Dropdowns
  String? _selectedUnitType;
  String? _selectedUnitStatus;
  String? _selectedPurpose;
  String? _selectedUsageType;
  String? _selectedFloorType;
  String? _selectedFinishingType;

  // Bools
  bool _isFurnished = false;
  final bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _unitNumberController = TextEditingController();
    _descriptionController = TextEditingController();
    _floorNumberController = TextEditingController();
    _areaController = TextEditingController();
    _roomsController = TextEditingController();
    _bathroomsController = TextEditingController();
    _rentPriceController = TextEditingController();
  }

  void _populateData(UnitEditState state) {
    final unit = state.initialUnit;
    if (unit != null) {
      if (_nameController.text.isEmpty) {
        _nameController.text = unit.name ?? '';
        _unitNumberController.text = unit.unitNumber;
        _descriptionController.text = unit.description ?? '';
        _floorNumberController.text = unit.floor ?? '0';
        _areaController.text = unit.area?.toString() ?? '';
        _roomsController.text = unit.roomsCount.toString();
        _bathroomsController.text = unit.bathroomsCount.toString();
        _rentPriceController.text = unit.rentPrice.toString();

        _selectedUnitType = unit.type;
        _selectedUnitStatus = unit.status;
        _selectedUsageType = unit.usageType;
        _selectedFinishingType = unit.finishingType;
        _isFurnished = unit.isFurnished;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitNumberController.dispose();
    _descriptionController.dispose();
    _floorNumberController.dispose();
    _areaController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _rentPriceController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedUnitType == null ||
        _selectedUnitStatus == null ||
        _selectedPurpose == null ||
        _selectedUsageType == null ||
        _selectedFloorType == null ||
        _selectedFinishingType == null) {
      AppToast.showError(context, 'errorOccurred'.tr());
      return;
    }

    context.read<UnitEditCubit>().submit(
      unitId: widget.unitId,
      name: _nameController.text,
      unitNumber: _unitNumberController.text,
      unitType: _selectedUnitType!,
      unitStatus: _selectedUnitStatus!,
      purpose: _selectedPurpose!,
      usageType: _selectedUsageType!,
      finishingType: _selectedFinishingType!,
      isFurnished: _isFurnished,
      description: _descriptionController.text,
      isCompleted: _isCompleted,
      floorType: _selectedFloorType!,
      floorNumber: int.tryParse(_floorNumberController.text) ?? 0,
      area: double.tryParse(_areaController.text) ?? 0.0,
      roomsCount: int.tryParse(_roomsController.text),
      bathroomsCount: int.tryParse(_bathroomsController.text),
      annualRentMonthly: double.tryParse(_rentPriceController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitEditCubit, UnitEditState>(
      listenWhen: (prev, current) =>
          prev.submitError != current.submitError ||
          (prev.isSubmitting && !current.isSubmitting),
      listener: (context, state) {
        if (state.submitError != null) {
          AppToast.showError(context, state.submitError!.message);
        } else if (!state.isSubmitting && state.error == null) {
          AppToast.showSuccess(
              context, 'units.wizard_success'.tr());
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: CustomAppBar(
              title: LocaleKeys.unitsEditUnit.tr(),
              onBackPressed: () => context.pop(),
            ),
            body: const UnitEditShimmer(),
          );
        }

        if (state.error != null) {
          return Scaffold(
            appBar: CustomAppBar(
              title: LocaleKeys.unitsEditUnit.tr(),
              onBackPressed: () => context.pop(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!.message),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'retry'.tr(),
                    onPressed: () {
                      context.read<UnitEditCubit>().loadData(
                            state.initialUnit?.propertyId ?? 0,
                            widget.unitId,
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        _populateData(state);

        return Scaffold(
          appBar: CustomAppBar(
            title: LocaleKeys.unitsEditUnit.tr(),
            onBackPressed: () => context.pop(),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(state),
                  const SizedBox(height: 24),
                  _buildDimensionsSection(),
                  const SizedBox(height: 24),
                  _buildFinancialsSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, state),
        );
      },
    );
  }

  Widget _buildBasicInfoSection(UnitEditState state) {
    final opts = state.formData?.options;
    
    String getLabel(List<OptionValueLabelEntity>? options, String val) {
      if (options == null) return val;
      try {
        return options.firstWhere((e) => e.value == val).label;
      } catch (_) {
        return val;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'units.unit_name_label'.tr(),
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _unitNumberController,
          label: 'units.unit_number_label'.tr(),
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUnitType,
          hint: 'units.unit_type_label'.tr(),
          items: opts?.unitTypes.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.unitTypes, val),
          onSelected: (v) => setState(() => _selectedUnitType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUnitStatus,
          hint: 'units.status'.tr(),
          items: opts?.unitStatuses.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.unitStatuses, val),
          onSelected: (v) => setState(() => _selectedUnitStatus = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedPurpose,
          hint: 'units.purpose_label'.tr(),
          items: opts?.unitPurposes.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.unitPurposes, val),
          onSelected: (v) => setState(() => _selectedPurpose = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedUsageType,
          hint: 'units.usage_type_label'.tr(),
          items: opts?.usageTypes.map((e) => e.value).toList() ?? [],
          itemLabelBuilder: (val) => getLabel(opts?.usageTypes, val),
          onSelected: (v) => setState(() => _selectedUsageType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedFloorType,
          hint: 'units.floor_type_label'.tr(),
          items: const ['ground', 'upper'],
          itemLabelBuilder: (val) => val,
          onSelected: (v) => setState(() => _selectedFloorType = v),
        ),
        const SizedBox(height: 16),
        CustomDropdownMenu<String>(
          value: _selectedFinishingType,
          hint: 'units.finishing_type_label'.tr(),
          items: const ['finished', 'semi_finished'],
          itemLabelBuilder: (val) => val,
          onSelected: (v) => setState(() => _selectedFinishingType = v),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Text('units.is_furnished_label'.tr()),
          value: _isFurnished,
          onChanged: (v) => setState(() => _isFurnished = v),
          activeThumbColor: context.primaryColor,
        ),
      ],
    );
  }

  Widget _buildDimensionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _floorNumberController,
                label: 'units.floor_number_label'.tr(),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _areaController,
                label: 'units.area_label'.tr(),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _roomsController,
                label: 'units.rooms_count_label'.tr(),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _bathroomsController,
                label: 'units.bathrooms_count_label'.tr(),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _rentPriceController,
          label: 'units.annual_rent_monthly_label'.tr(),
          keyboardType: TextInputType.number,
          validator: (v) => v!.isEmpty ? 'required_field'.tr() : null,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, UnitEditState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: 'common_save'.tr(),
          isLoading: state.isSubmitting,
          onPressed: () => _onSave(context),
        ),
      ),
    );
  }
}