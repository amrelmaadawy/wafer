import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';
import 'edit_form_utils.dart';

class EditBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController areaController;
  final TextEditingController yearController;
  final TextEditingController descriptionController;

  const EditBasicInfoSection({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.areaController,
    required this.yearController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditSectionHeader(
          title: 'المعلومات الأساسية',
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: nameController,
          label: LocaleKeys.propertyCreatePropertyName.tr(),
          icon: Icons.apartment_rounded,
          isRequired: true,
          hint: 'أدخل اسم العقار (مثال: عمارة الياسمين)',
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: addressController,
          label: LocaleKeys.propertyCreateAddress.tr(),
          icon: Icons.location_on_outlined,
          hint: 'أدخل العنوان بالتفصيل...',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EditFormField(
                controller: areaController,
                label: LocaleKeys.propertyCreateArea.tr(),
                icon: Icons.square_foot_outlined,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                isNumber: true,
                hint: 'المساحة (م²)',
                suffixText: LocaleKeys.propertyDetailsAreaUnit.tr(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: yearController,
                label: LocaleKeys.propertyCreateYearLabel.tr(),
                icon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
                isNumber: true,
                hint: 'YYYY',
                maxLength: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: descriptionController,
          label: LocaleKeys.propertyCreateDescription.tr(),
          icon: Icons.notes_rounded,
          maxLines: 4,
          hint: 'أضف وصفاً مفصلاً للعقار ومميزاته...',
        ),
      ],
    );
  }
}
