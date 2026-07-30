import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

/// Dimensions + technical details (direction, finishing) in a single tile list.
class UnitDimensionsCard extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  const UnitDimensionsCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final rows = <_DetailRow>[];

    if (unit.length != null && unit.length! > 0) {
      rows.add(
        _DetailRow(
          Icons.straighten_outlined,
          LocaleKeys.unit_details_length.tr(),
          '${unit.length!.toStringAsFixed(2)} ${LocaleKeys.unitDetailsMeters.tr()}',
        ),
      );
    }
    if (unit.width != null && unit.width! > 0) {
      rows.add(
        _DetailRow(
          Icons.swap_horiz_outlined,
          LocaleKeys.unit_details_width.tr(),
          '${unit.width!.toStringAsFixed(2)} ${LocaleKeys.unitDetailsMeters.tr()}',
        ),
      );
    }
    if (unit.height != null && unit.height! > 0) {
      rows.add(
        _DetailRow(
          Icons.height_outlined,
          LocaleKeys.unit_details_height.tr(),
          '${unit.height!.toStringAsFixed(2)} ${LocaleKeys.unitDetailsMeters.tr()}',
        ),
      );
    }
    if (unit.facadeLength != null && unit.facadeLength! > 0) {
      rows.add(
        _DetailRow(
          Icons.architecture_outlined,
          LocaleKeys.unit_details_facade_length.tr(),
          '${unit.facadeLength!.toStringAsFixed(2)} ${LocaleKeys.unitDetailsMeters.tr()}',
        ),
      );
    }
    if (unit.direction != null && unit.direction!.isNotEmpty) {
      rows.add(
        _DetailRow(
          Icons.explore_outlined,
          LocaleKeys.unit_details_direction.tr(),
          unit.direction!,
        ),
      );
    }
    if (unit.finishingType != null && unit.finishingType!.isNotEmpty) {
      rows.add(
        _DetailRow(
          Icons.format_paint_outlined,
          LocaleKeys.unit_details_finishing_type.tr(),
          unit.finishingType!,
        ),
      );
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.unit_details_dimensions.tr(), style: AppTextStyles.h3),
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
            separatorBuilder: (_, _) => const Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: Color(0xFFF8FAFC),
            ),
            itemBuilder: (context, i) => _buildRow(context, rows[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, _DetailRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(row.icon, size: 16, color: context.primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Text(
            row.value,
            style: AppTextStyles.labelLarge.copyWith(
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);
}
