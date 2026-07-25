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
              const Text('البيانات الأساسية للوحدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'اسم الوحدة',
                hintText: 'مثال: شقة 101',
                initialValue: state.name,
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(name: val),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال اسم الوحدة';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'رقم الوحدة',
                hintText: 'مثال: 101',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.unitNumber,
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(unitNumber: val),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'يرجى إدخال رقم الوحدة';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'نوع الوحدة',
                value: state.unitType,
                items: const {
                  'apartment': 'شقة',
                  'office': 'مكتب',
                  'shop': 'محل',
                  'villa': 'فيلا',
                },
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(unitType: val),
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'نوع الاستخدام',
                value: state.usageType,
                items: const {
                  'residential': 'سكني',
                  'commercial': 'تجاري',
                  'administrative': 'إداري',
                },
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(usageType: val),
              ),
              const SizedBox(height: 16),
              
              _buildDropdown(
                label: 'الغرض',
                value: state.purpose,
                items: const {
                  'for_rent': 'للإيجار',
                  'for_sale': 'للبيع',
                },
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(purpose: val),
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'نوع التشطيب',
                value: state.finishingType,
                items: const {
                  'finished': 'مشطب',
                  'semi_finished': 'نصف مشطب',
                  'without_finish': 'بدون تشطيب',
                },
                onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(finishingType: val),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الوحدة مفروشة؟',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimaryLight),
                    ),
                    CupertinoSwitch(
                      value: state.isFurnished,
                      activeTrackColor: context.primaryColor,
                      onChanged: (val) => context.read<UnitCreateCubit>().updateBasicInfo(isFurnished: val),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight)),
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
