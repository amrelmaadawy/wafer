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
          title: LocaleKeys.propertyDetailsBasicInfo.tr(),
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: nameController,
          label: LocaleKeys.commonPropertyName.tr(),
          icon: Icons.apartment_rounded,
          isRequired: true,
          hint: LocaleKeys.propertyDetailsNameHint.tr(),
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: addressController,
          label: LocaleKeys.commonAddress.tr(),
          icon: Icons.location_on_outlined,
          hint: LocaleKeys.propertyDetailsAddressHint.tr(),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                maxLength: 4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Description field (multi-line)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.commonDescription.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: LocaleKeys.propertyDetailsDescriptionHint.tr(),
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade400,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
