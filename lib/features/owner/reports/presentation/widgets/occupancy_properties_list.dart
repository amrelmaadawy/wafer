import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/occupancy_property_entity.dart';
import 'occupancy_property_card.dart';

class OccupancyPropertiesList extends StatelessWidget {
  final List<OccupancyPropertyEntity> properties;

  const OccupancyPropertiesList({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.domain_rounded,
                size: 18, color: AppColors.textPrimaryLight),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.occupancyPropertiesSection.tr(),
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: properties.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            return OccupancyPropertyCard(property: properties[index]);
          },
        ),
      ],
    );
  }
}
