import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

/// Specs grid: area, rooms, baths, halls, kitchens, entrances, furnished.
class UnitSpecsGrid extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitSpecsGrid({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final specs = <_SpecItem>[
      if (unit.area != null && unit.area! > 0)
        _SpecItem(
          Icons.square_foot_rounded,
          '${unit.area!.toStringAsFixed(0)} ${LocaleKeys.commonAreaM2.tr(args: [''])}',
          LocaleKeys.propertyDetailsArea.tr(),
        ),
      if (unit.roomsCount > 0)
        _SpecItem(
          Icons.bed_outlined,
          '${unit.roomsCount}',
          LocaleKeys.commonRooms.tr(args: ['']),
        ),
      if (unit.bathroomsCount > 0)
        _SpecItem(
          Icons.bathtub_outlined,
          '${unit.bathroomsCount}',
          LocaleKeys.commonBathrooms.tr(args: ['']),
        ),
      if (unit.hallsCount > 0)
        _SpecItem(
          Icons.weekend_outlined,
          '${unit.hallsCount}',
          LocaleKeys.commonHalls.tr(args: ['']),
        ),
      if (unit.kitchensCount > 0)
        _SpecItem(
          Icons.kitchen_outlined,
          '${unit.kitchensCount}',
          LocaleKeys.commonKitchens.tr(args: ['']),
        ),
      if (unit.entrancesCount > 0)
        _SpecItem(
          Icons.door_front_door_outlined,
          '${unit.entrancesCount}',
          LocaleKeys.unit_details_entrances_count.tr(),
        ),
      // Furnished is always shown
      _SpecItem(
        unit.isFurnished ? Icons.chair_rounded : Icons.chair_alt_outlined,
        unit.isFurnished
            ? LocaleKeys.unit_details_furnished.tr()
            : LocaleKeys.unit_details_unfurnished.tr(),
        LocaleKeys.unit_details_is_furnished.tr(),
      ),
    ];

    if (specs.isEmpty) return const SizedBox.shrink();

    return _SectionCard(
      title: LocaleKeys.unit_details_specs.tr(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final colCount = constraints.maxWidth > 320 ? 3 : 2;
          final spacing = 10.0;
          final itemWidth =
              (constraints.maxWidth - spacing * (colCount - 1)) / colCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: specs
                .map(
                  (s) => _SpecTile(
                    item: s,
                    width: itemWidth,
                    primaryColor: context.primaryColor,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _SpecItem {
  final IconData icon;
  final String value;
  final String label;
  const _SpecItem(this.icon, this.value, this.label);
}

class _SpecTile extends StatelessWidget {
  final _SpecItem item;
  final double width;
  final Color primaryColor;

  const _SpecTile({
    required this.item,
    required this.width,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(item.icon, color: primaryColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            style: AppTextStyles.h4.copyWith(color: const Color(0xFF1E293B)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Shared Section Card ──────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}
