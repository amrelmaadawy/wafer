import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';
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
        EditSectionHeader(title: LocaleKeys.propertyDetailsLocation.tr(), icon: Icons.map_outlined),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EditFormField(
                controller: cityController,
                label: LocaleKeys.propertyDetailsCity.tr(),
                icon: Icons.location_city_outlined,
                hint: LocaleKeys.propertyDetailsCityHint.tr(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: districtController,
                label: LocaleKeys.propertyDetailsDistrict.tr(),
                icon: Icons.holiday_village_outlined,
                hint: LocaleKeys.propertyDetailsDistrictHint.tr(),
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
                label: LocaleKeys.propertyDetailsRegion.tr(),
                icon: Icons.explore_outlined,
                hint: LocaleKeys.propertyDetailsRegionHint.tr(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: EditFormField(
                controller: buildingController,
                label: LocaleKeys.propertyDetailsBuildingNumber.tr(),
                icon: Icons.tag_rounded,
                isNumber: true,
                hint: LocaleKeys.propertyDetailsBuildingNumberHint.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        EditFormField(
          controller: streetController,
          label: LocaleKeys.propertyDetailsStreet.tr(),
          icon: Icons.add_road_rounded,
          hint: LocaleKeys.propertyDetailsStreetHint.tr(),
        ),
      ],
    );
  }
}
