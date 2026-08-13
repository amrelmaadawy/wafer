import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/presentation/widgets/section_header.dart';
import '../../../../../../core/utils/launcher_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyLocationCard extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyLocationCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    if (property.city == null &&
        property.district == null &&
        property.streetName == null &&
        property.buildingNumber == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXxl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: LocaleKeys.deedsLocationInfo.tr(),
            icon: Icons.map_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationItem(
                  context,
                  label: LocaleKeys.deedsCity.tr(),
                  value: property.city ?? '-',
                  icon: Icons.location_city_rounded,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.dividerSubtleLight),
              Expanded(
                child: _buildLocationItem(
                  context,
                  label: LocaleKeys.deedsDistrict.tr(),
                  value: property.district ?? '-',
                  icon: Icons.holiday_village_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.dividerSubtleLight),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationItem(
                  context,
                  label: LocaleKeys.deedsStreetName.tr(),
                  value: property.streetName ?? '-',
                  icon: Icons.add_road_rounded,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.dividerSubtleLight),
              Expanded(
                child: _buildLocationItem(
                  context,
                  label: LocaleKeys.deedsBuildingNumber.tr(),
                  value: property.buildingNumber ?? '-',
                  icon: Icons.domain_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final query = [
                  property.buildingNumber,
                  property.streetName,
                  property.district,
                  property.city
                ].where((e) => e != null && e.isNotEmpty).join(', ');
                
                if (query.isNotEmpty) {
                  LauncherUtils.openMap(query);
                }
              },
              icon: Icon(Icons.directions_outlined, size: 18, color: context.primaryColor),
              label: Text(
                LocaleKeys.properties_open_map.tr(),
                style: TextStyle(color: context.primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.primaryColor.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circularLg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
