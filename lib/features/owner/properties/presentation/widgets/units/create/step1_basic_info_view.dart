import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';

class Step1BasicInfoView extends StatelessWidget {
  const Step1BasicInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.unitsBasicInfoTitle.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsUnitNameLabel.tr(),
                hintText: LocaleKeys.unitsUnitNameHint.tr(),
                initialValue: state.name,
                onChanged: (val) =>
                    context.read<UnitCreateCubit>().updateBasicInfo(name: val),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return LocaleKeys.unitsUnitNameValidation.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsUnitNumberLabel.tr(),
                hintText: LocaleKeys.unitsUnitNumberHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.unitNumber,
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateBasicInfo(unitNumber: val),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return LocaleKeys.unitsUnitNumberValidation.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: LocaleKeys.unitsUnitTypeLabel.tr(),
                value: state.unitType,
                items: {
                  'apartment': LocaleKeys.unitsUnitTypeApartment.tr(),
                  'office': LocaleKeys.unitsUnitTypeOffice.tr(),
                  'shop': LocaleKeys.unitsUnitTypeShop.tr(),
                  'villa': LocaleKeys.unitsUnitTypeVilla.tr(),
                },
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateBasicInfo(unitType: val),
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: LocaleKeys.unitsUsageTypeLabel.tr(),
                value: state.usageType,
                items: {
                  'residential': LocaleKeys.unitsUsageTypeResidential.tr(),
                  'commercial': LocaleKeys.unitsUsageTypeCommercial.tr(),
                },
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateBasicInfo(usageType: val),
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: LocaleKeys.unitsPurposeLabel.tr(),
                value: state.purpose,
                items: {
                  'for_rent': LocaleKeys.unitsPurposeRent.tr(),
                  'for_sale': LocaleKeys.unitsPurposeSale.tr(),
                },
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateBasicInfo(purpose: val),
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: LocaleKeys.unitsFinishingTypeLabel.tr(),
                value: state.finishingType,
                items: {
                  'finished': LocaleKeys.unitsFinishingTypeFinished.tr(),
                  'semi_finished': LocaleKeys.unitsFinishingTypeSemiFinished
                      .tr(),
                  'without_finish': LocaleKeys.unitsFinishingTypeWithout.tr(),
                },
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateBasicInfo(finishingType: val),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.unitsIsFurnishedLabel.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    CupertinoSwitch(
                      value: state.isFurnished,
                      activeTrackColor: context.primaryColor,
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateBasicInfo(isFurnished: val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdownMenu<String>(
          items: items.keys.toList(),
          value: items.containsKey(value) ? value : items.keys.first,
          hint: '${LocaleKeys.unitsSelectPrefix.tr()} $label',
          itemLabelBuilder: (key) => items[key] ?? key,
          onSelected: (val) => onChanged(val),
        ),
      ],
    );
  }
}
