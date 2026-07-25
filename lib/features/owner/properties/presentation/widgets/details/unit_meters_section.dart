import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

/// Electric / Water / Gas meters with colored icon indicators.
class UnitMetersSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  const UnitMetersSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final rows = <_MeterRow>[];

    if (unit.meters.electricity != null) {
      rows.add(_MeterRow(
        icon: Icons.electric_bolt_rounded,
        color: const Color(0xFFF59E0B),
        label: LocaleKeys.unit_details_electricity.tr(),
        value: unit.meters.electricity!,
      ));
    }
    if (unit.meters.water != null) {
      rows.add(_MeterRow(
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF3B82F6),
        label: LocaleKeys.unit_details_water.tr(),
        value: unit.meters.water!,
      ));
    }
    if (unit.meters.gas != null) {
      rows.add(_MeterRow(
        icon: Icons.local_fire_department_outlined,
        color: const Color(0xFFEF4444),
        label: LocaleKeys.unit_details_gas.tr(),
        value: unit.meters.gas!,
      ));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.unit_details_meters.tr(), style: AppTextStyles.h3),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEDF0F7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rows.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF8FAFC)),
            itemBuilder: (_, i) => _buildRow(rows[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(_MeterRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: row.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(row.icon, size: 18, color: row.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(row.label,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: const Color(0xFF64748B))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: row.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(row.value,
                style: AppTextStyles.labelLarge.copyWith(color: row.color)),
          ),
        ],
      ),
    );
  }
}

class _MeterRow {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _MeterRow({required this.icon, required this.color, required this.label, required this.value});
}