import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../../core/presentation/widgets/custom_dropdown_menu.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';

class Step2SpecsView extends StatelessWidget {
  const Step2SpecsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المواصفات والمساحات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'الدور',
                      value: state.floorType,
                      items: const {
                        'ground': 'أرضي',
                        'typical': 'متكرر',
                        'roof': 'روف',
                        'basement': 'بدروم',
                      },
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(floorType: val),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'رقم الدور',
                      hintText: 'مثال: 3',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: state.floorNumber?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(floorNumber: int.tryParse(val)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'الأبعاد (اختياري)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'الطول (م)',
                      hintText: 'مثال: 12',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      initialValue: state.length?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(length: double.tryParse(val)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      label: 'المساحة (م²)',
                      hintText: 'مثال: 120',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      initialValue: state.area?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(area: double.tryParse(val)),
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      label: 'العرض (م)',
                      hintText: 'مثال: 10',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      initialValue: state.width?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(width: double.tryParse(val)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      label: 'الارتفاع (م)',
                      hintText: 'مثال: 3',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      initialValue: state.height?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(height: double.tryParse(val)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'طول الواجهة (م)',
                hintText: 'مثال: 8',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                initialValue: state.facadeLength?.toString(),
                onChanged: (val) => context.read<UnitCreateCubit>().updateSpecs(
                  facadeLength: double.tryParse(val),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'التقسيم الداخلي',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'الغرف',
                      hintText: 'مثال: 3',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: state.roomsCount?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(roomsCount: int.tryParse(val)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'دورات المياه',
                      hintText: 'مثال: 2',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: state.bathroomsCount?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(bathroomsCount: int.tryParse(val)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'الصالات',
                      hintText: 'مثال: 1',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: state.hallsCount?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(hallsCount: int.tryParse(val)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'المطابخ',
                      hintText: 'مثال: 1',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      initialValue: state.kitchensCount?.toString(),
                      onChanged: (val) => context
                          .read<UnitCreateCubit>()
                          .updateSpecs(kitchensCount: int.tryParse(val)),
                    ),
                  ),
                ],
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
          hint: 'اختر $label',
          itemLabelBuilder: (key) => items[key] ?? key,
          onSelected: (val) => onChanged(val),
        ),
      ],
    );
  }
}
