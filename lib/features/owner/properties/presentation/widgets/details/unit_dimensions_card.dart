import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../../../../../../core/presentation/widgets/collapsible_section.dart';

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

    return CollapsibleSection(
      title: LocaleKeys.unit_details_dimensions.tr(),
      icon: Icons.square_foot_rounded,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rows.length,
            separatorBuilder: (_, _) => const Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: AppColors.surfaceSubtleLight,
            ),
            itemBuilder: (context, i) => _buildRow(context, rows[i]),
          ),
        ),
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
              borderRadius: AppRadius.circularMd,
            ),
            child: Icon(row.icon, size: 16, color: context.primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Text(
            row.value,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimaryLight,
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


