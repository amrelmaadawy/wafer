import 'package:flutter/material.dart';
import 'edit_form_utils.dart';

class EditLocationSection extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController districtController;
  final TextEditingController regionController;
  final TextEditingController buildingController;
  final TextEditingController streetController;

  const EditLocationSection({
    super.key,
    required this.cityController,
    required this.districtController,
    required this.regionController,
    required this.buildingController,
    required this.streetController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditSectionHeader(title: 'تفاصيل الموقع', icon: Icons.map_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EditFormField(
                controller: cityController,
                label: 'المدينة',
                icon: Icons.location_city_outlined,
                hint: 'مثال: الرياض',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: districtController,
                label: 'الحي',
                icon: Icons.holiday_village_outlined,
                hint: 'مثال: النرجس',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EditFormField(
                controller: regionController,
                label: 'المنطقة',
                icon: Icons.explore_outlined,
                hint: 'مثال: الوسطى',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: buildingController,
                label: 'رقم المبنى',
                icon: Icons.tag_rounded,
                isNumber: true,
                hint: 'مثال: 12',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: streetController,
          label: 'اسم الشارع',
          icon: Icons.add_road_rounded,
          hint: 'مثال: شارع الملك فهد',
        ),
      ],
    );
  }
}
