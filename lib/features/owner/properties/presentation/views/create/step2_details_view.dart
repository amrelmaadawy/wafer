import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';

class Step2DetailsView extends StatefulWidget {
  const Step2DetailsView({super.key});

  @override
  State<Step2DetailsView> createState() => _Step2DetailsViewState();
}

class _Step2DetailsViewState extends State<Step2DetailsView> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  late TextEditingController _yearController;
  late TextEditingController _descController;
  late FocusNode _nameNode;
  late FocusNode _addressNode;
  late FocusNode _areaNode;
  late FocusNode _yearNode;
  late FocusNode _descNode;

  @override
  void initState() {
    super.initState();
    final state = context.read<PropertyCreateCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _addressController = TextEditingController(text: state.address);
    _areaController = TextEditingController(text: state.area?.toString() ?? '');
    _yearController = TextEditingController(text: state.constructionYear?.toString() ?? '');
    _descController = TextEditingController(text: state.description);

    _nameNode = FocusNode();
    _addressNode = FocusNode();
    _areaNode = FocusNode();
    _yearNode = FocusNode();
    _descNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _yearController.dispose();
    _descController.dispose();
    _nameNode.dispose();
    _addressNode.dispose();
    _areaNode.dispose();
    _yearNode.dispose();
    _descNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.propertyWizardStep2Title.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  if (state.isAutoSavingDetails)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: LocaleKeys.propertyCreatePropertyName.tr(),
                hintText: LocaleKeys.propertyCreatePropertyName.tr(),
                controller: _nameController,
                focusNode: _nameNode,
                prefixIcon: const Icon(Icons.home_work_outlined),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_addressNode),
                onChanged: (val) => context.read<PropertyCreateCubit>().updateName(val),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: LocaleKeys.propertyCreateAddress.tr(),
                hintText: LocaleKeys.propertyCreateAddress.tr(),
                controller: _addressController,
                focusNode: _addressNode,
                prefixIcon: const Icon(Icons.location_on_outlined),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_areaNode),
                onChanged: (val) => context.read<PropertyCreateCubit>().updateAddress(val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: LocaleKeys.propertyCreateArea.tr(),
                      hintText: '0',
                      controller: _areaController,
                      focusNode: _areaNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      prefixIcon: const Icon(Icons.square_foot_outlined),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_yearNode),
                      onChanged: (val) => context.read<PropertyCreateCubit>().updateArea(double.tryParse(val) ?? 0.0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: LocaleKeys.propertyCreateYearLabel.tr(),
                      hintText: 'YYYY',
                      controller: _yearController,
                      focusNode: _yearNode,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      maxLength: 4,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (val) {
                        final year = int.tryParse(val);
                        if (year != null) {
                          context.read<PropertyCreateCubit>().updateConstructionYear(year);
                        } else if (val.isEmpty) {
                          context.read<PropertyCreateCubit>().updateConstructionYear(0);
                        }
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descNode),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: LocaleKeys.propertyCreateDescription.tr(),
                hintText: LocaleKeys.propertyCreateDescription.tr(),
                controller: _descController,
                focusNode: _descNode,
                maxLines: 4,
                prefixIcon: const Icon(Icons.description_outlined),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                onChanged: (val) => context.read<PropertyCreateCubit>().updateDescription(val),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
