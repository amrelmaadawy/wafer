import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';

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
              const Text('العدادات والمرافق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'رقم عداد الكهرباء',
                hintText: 'مثال: 123456789',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.electricityMeterNumber,
                onChanged: (val) => context.read<UnitCreateCubit>().updateLocationUtilities(electricityMeter: val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'رقم عداد المياه',
                hintText: 'مثال: 123456789',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.waterMeterNumber,
                onChanged: (val) => context.read<UnitCreateCubit>().updateLocationUtilities(waterMeter: val),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'رقم عداد الغاز',
                hintText: 'مثال: 123456789',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.gasMeterNumber,
                onChanged: (val) => context.read<UnitCreateCubit>().updateLocationUtilities(gasMeter: val),
              ),
              const SizedBox(height: 24),

              const Text('المميزات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildAmenityChip(context, 'balcony', 'بلكونة', state.amenities),
                  _buildAmenityChip(context, 'kitchen', 'مطبخ راكب', state.amenities),
                  _buildAmenityChip(context, 'ac', 'مكيفات', state.amenities),
                  _buildAmenityChip(context, 'internet', 'إنترنت', state.amenities),
                  _buildAmenityChip(context, 'parking', 'موقف سيارات', state.amenities),
                  _buildAmenityChip(context, 'security', 'حراسة', state.amenities),
                  _buildAmenityChip(context, 'elevator', 'مصعد', state.amenities),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenityChip(BuildContext context, String id, String label, List<String> selectedAmenities) {
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
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? context.primaryColor : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1,
        ),
      ),
    );
  }
}
