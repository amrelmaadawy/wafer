import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_radius.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
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
          title: 'المواصفات والأبعاد',
          icon: Icons.straighten_rounded,
        ),
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
          items: const ['residential', 'commercial', 'industrial', 'mixed'],
          value: state.selectedUsageType,
          hint: 'اختر نوع الاستخدام',
          itemLabelBuilder: (val) {
            switch (val) {
              case 'residential':
                return 'سكني';
              case 'commercial':
                return 'تجاري';
              case 'industrial':
                return 'صناعي';
              case 'mixed':
                return 'مختلط';
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
                label: 'الطول (م)',
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
                label: 'العرض (م)',
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
          title: 'المميزات والإضافات',
          icon: Icons.star_outline_rounded,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children:
              const [
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
                  onSelected: (_) => context
                      .read<PropertyEditCubit>()
                      .toggleAmenity(amenity.$1),
                  selectedColor: context.primaryColor.withValues(alpha: 0.12),
                  checkmarkColor: context.primaryColor,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? context.primaryColor
                        : const Color(0xFFE2E8F0),
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
