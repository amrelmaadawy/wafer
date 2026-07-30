import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

class UnitAmenitiesSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  const UnitAmenitiesSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    if (unit.amenities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.unit_details_amenities.tr(), style: AppTextStyles.h3),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: unit.amenities.map((a) {
            final meta = _amenityMeta(a);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEDF0F7)),
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
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _AmenityMeta _amenityMeta(String key) {
    switch (key.toLowerCase()) {
      case 'parking':
        return _AmenityMeta(Icons.local_parking_outlined, 'موقف سيارات');
      case 'elevator':
        return _AmenityMeta(Icons.elevator_outlined, 'مصعد');
      case 'gym':
        return _AmenityMeta(Icons.fitness_center_outlined, 'نادي رياضي');
      case 'pool':
        return _AmenityMeta(Icons.pool_outlined, 'مسبح');
      case 'security':
        return _AmenityMeta(Icons.security_outlined, 'أمن وحراسة');
      case 'garden':
        return _AmenityMeta(Icons.park_outlined, 'حديقة');
      case 'internet':
        return _AmenityMeta(Icons.wifi_outlined, 'إنترنت');
      case 'ac':
        return _AmenityMeta(Icons.ac_unit_outlined, 'تكييف');
      default:
        return _AmenityMeta(Icons.check_circle_outline, key);
    }
  }
}

class _AmenityMeta {
  final IconData icon;
  final String label;
  const _AmenityMeta(this.icon, this.label);
}
