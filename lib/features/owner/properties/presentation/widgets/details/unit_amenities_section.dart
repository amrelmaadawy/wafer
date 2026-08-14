import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../../../../../../core/presentation/widgets/collapsible_section.dart';

class UnitAmenitiesSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  const UnitAmenitiesSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    if (unit.amenities.isEmpty) return const SizedBox.shrink();

    return CollapsibleSection(
      title: LocaleKeys.unit_details_amenities.tr(),
      icon: Icons.star_border_rounded,
      child: Container(
        alignment: Alignment.centerRight,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: unit.amenities.map((a) {
            final meta = _amenityMeta(a);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.circularXxl,
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(meta.icon, size: 16, color: context.primaryColor),
                  const SizedBox(width: 7),
                  Text(
                    meta.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _AmenityMeta _amenityMeta(String key) {
    switch (key.toLowerCase()) {
      case 'parking':
        return _AmenityMeta(Icons.local_parking_outlined, LocaleKeys.properties_amenity_parking.tr());
      case 'elevator':
        return _AmenityMeta(Icons.elevator_outlined, LocaleKeys.properties_amenity_elevator.tr());
      case 'gym':
        return _AmenityMeta(Icons.fitness_center_outlined, LocaleKeys.properties_amenity_gym.tr());
      case 'pool':
        return _AmenityMeta(Icons.pool_outlined, LocaleKeys.properties_amenity_pool.tr());
      case 'security':
        return _AmenityMeta(Icons.security_outlined, LocaleKeys.properties_amenity_security.tr());
      case 'garden':
        return _AmenityMeta(Icons.park_outlined, LocaleKeys.properties_amenity_garden.tr());
      case 'internet':
        return _AmenityMeta(Icons.wifi_outlined, LocaleKeys.properties_amenity_internet.tr());
      case 'ac':
        return _AmenityMeta(Icons.ac_unit_outlined, LocaleKeys.properties_amenity_ac.tr());
      case 'smart_lock':
        return _AmenityMeta(Icons.lock_outline_rounded, LocaleKeys.properties_amenity_smart_lock.tr());
      case 'central_ac':
        return _AmenityMeta(Icons.ac_unit_rounded, LocaleKeys.properties_amenity_central_ac.tr());
      default:
        final formattedKey = key
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}' : '')
            .join(' ');
        return _AmenityMeta(Icons.check_circle_outline, formattedKey);
    }
  }
}

class _AmenityMeta {
  final IconData icon;
  final String label;
  const _AmenityMeta(this.icon, this.label);
}


