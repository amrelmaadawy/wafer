import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';

class Step3LocationUtilitiesView extends StatelessWidget {
  const Step3LocationUtilitiesView({super.key});

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
                LocaleKeys.unitsLocationUtilsTitle.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsElectricityMeterLabel.tr(),
                hintText: LocaleKeys.unitsElectricityMeterHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.electricityMeterNumber,
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateLocationUtilities(electricityMeter: val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsWaterMeterLabel.tr(),
                hintText: LocaleKeys.unitsWaterMeterHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.waterMeterNumber,
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateLocationUtilities(waterMeter: val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: LocaleKeys.unitsGasMeterLabel.tr(),
                hintText: LocaleKeys.unitsGasMeterHint.tr(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.gasMeterNumber,
                onChanged: (val) => context
                    .read<UnitCreateCubit>()
                    .updateLocationUtilities(gasMeter: val),
              ),
              const SizedBox(height: 24),

              Text(
                LocaleKeys.unitsUnitAmenitiesLabel.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildAmenityChip(
                    context,
                    'balcony',
                    LocaleKeys.unitsAmenityBalcony.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'kitchen',
                    LocaleKeys.unitsAmenityKitchen.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'ac',
                    LocaleKeys.unitsAmenityAc.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'internet',
                    LocaleKeys.unitsAmenityInternet.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'parking',
                    LocaleKeys.unitsAmenityParking.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'security',
                    LocaleKeys.unitsAmenitySecurity.tr(),
                    state.amenities,
                  ),
                  _buildAmenityChip(
                    context,
                    'elevator',
                    LocaleKeys.unitsAmenityElevator.tr(),
                    state.amenities,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenityChip(
    BuildContext context,
    String id,
    String label,
    List<String> selectedAmenities,
  ) {
    final isSelected = selectedAmenities.contains(id);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => context.read<UnitCreateCubit>().toggleAmenity(id),
      selectedColor: context.primaryColor.withValues(alpha: 0.12),
      checkmarkColor: context.primaryColor,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? context.primaryColor : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularXxl,
        side: BorderSide(
          color: isSelected ? context.primaryColor : AppColors.borderLight,
          width: isSelected ? 1.5 : 1,
        ),
      ),
    );
  }
}


