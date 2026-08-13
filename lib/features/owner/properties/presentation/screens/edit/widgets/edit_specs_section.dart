import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../../../../../core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../cubit/edit/property_edit_cubit.dart';
import '../../../cubit/edit/property_edit_state.dart';
import 'edit_form_utils.dart';

class EditSpecsSection extends StatelessWidget {
  final PropertyEditState state;
  final TextEditingController lengthController;
  final TextEditingController widthController;

  const EditSpecsSection({
    super.key,
    required this.state,
    required this.lengthController,
    required this.widthController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditSectionHeader(
          title: LocaleKeys.propertyDetailsSpecsTitle.tr(),
          icon: Icons.straighten_rounded,
        ),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.propertiesUsageTitle.tr(),
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        CustomDropdownMenu<String>(
          items: const ['residential', 'commercial', 'industrial', 'mixed'],
          value: state.selectedUsageType,
          hint: LocaleKeys.propertyDetailsUsageHint.tr(),
          itemLabelBuilder: (val) {
            switch (val) {
              case 'residential':
                return LocaleKeys.propertiesUsageResidential.tr();
              case 'commercial':
                return LocaleKeys.propertiesUsageCommercial.tr();
              case 'industrial':
                return LocaleKeys.propertiesUsageIndustrial.tr();
              case 'mixed':
                return LocaleKeys.propertiesUsageMixed.tr();
              default:
                return val;
            }
          },
          onSelected: (val) =>
              context.read<PropertyEditCubit>().selectUsageType(val),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EditFormField(
                controller: lengthController,
                label: LocaleKeys.propertyDetailsLength.tr(),
                icon: Icons.height_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                isNumber: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: widthController,
                label: LocaleKeys.propertyDetailsWidth.tr(),
                icon: Icons.swap_horiz_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                isNumber: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Section 4: Amenities
        EditSectionHeader(
          title: LocaleKeys.propertyDetailsAmenitiesTitle.tr(),
          icon: Icons.star_outline_rounded,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children:
              [
                ('elevator', LocaleKeys.amenityElevator.tr()),
                ('parking', LocaleKeys.amenityParking.tr()),
                ('security', LocaleKeys.amenitySecurity.tr()),
                ('pool', LocaleKeys.amenityPool.tr()),
                ('gym', LocaleKeys.amenityGym.tr()),
                ('generator', LocaleKeys.amenityGenerator.tr()),
                ('central_ac', LocaleKeys.amenityCentralAc.tr()),
                ('internet', LocaleKeys.amenityInternet.tr()),
              ].map((amenity) {
                final isSelected = state.selectedAmenities.contains(amenity.$1);
                return FilterChip(
                  label: Text(amenity.$2),
                  selected: isSelected,
                  onSelected: (_) => context
                      .read<PropertyEditCubit>()
                      .toggleAmenity(amenity.$1),
                  selectedColor: context.primaryColor.withValues(alpha: 0.12),
                  checkmarkColor: context.primaryColor,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? context.primaryColor
                        : AppColors.borderLight,
                    width: isSelected ? 1.5 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? context.primaryColor
                        : AppColors.textPrimaryLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circularFull,
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

