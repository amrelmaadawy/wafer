import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/state_color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

/// A clean info card showing code, type, usage, floor and description.
class UnitBasicInfoCard extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitBasicInfoCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    // Build the quick-info items list – only non-null / non-zero values
    final items = <_InfoItem>[
      if (unit.code != null && unit.code!.isNotEmpty)
        _InfoItem(
          icon: Icons.tag_rounded,
          label: LocaleKeys.unitDetailsUnitCode.tr(),
          value: unit.code!,
        ),
      if (unit.typeLabel != null || unit.type != null)
        _InfoItem(
          icon: Icons.category_outlined,
          label: LocaleKeys.unitDetailsUnitType.tr(),
          value: unit.typeLabel ?? unit.type ?? '-',
          color: StateColorUtils.getUnitTypeColor(unit.type),
        ),
      if (unit.usageType != null)
        _InfoItem(
          icon: Icons.business_center_outlined,
          label: LocaleKeys.unitDetailsUsageType.tr(),
          value: _usageLabel(unit.usageType),
          color: StateColorUtils.getUsageTypeColor(unit.usageType),
        ),
      if (unit.floor != null && unit.floor!.isNotEmpty)
        _InfoItem(
          icon: Icons.layers_outlined,
          label: LocaleKeys.unit_details_floor_number.tr(),
          value: unit.floor!,
        ),
    ];

    if (items.isEmpty &&
        (unit.description == null || unit.description!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _buildInfoGrid(context, items),
            ),
          if (unit.description != null && unit.description!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.unitDetailsDescription.tr(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    unit.description!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF334155),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, List<_InfoItem> items) {
    // Lay items in pairs per row
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _buildInfoCell(context, left)),
            if (right != null) ...[
              Container(width: 1, height: 52, color: const Color(0xFFF1F5F9)),
              Expanded(child: _buildInfoCell(context, right)),
            ] else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < items.length) {
        rows.add(const Divider(height: 1, color: Color(0xFFF1F5F9)));
      }
    }
    return Column(children: rows);
  }

  Widget _buildInfoCell(BuildContext context, _InfoItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: context.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: item.color ?? const Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _usageLabel(String? usage) {
    switch (usage?.toLowerCase()) {
      case 'residential':
        return LocaleKeys.unitDetailsUsageResidential.tr();
      case 'commercial':
        return LocaleKeys.unitDetailsUsageCommercial.tr();
      case 'administrative':
        return LocaleKeys.unitDetailsUsageAdministrative.tr();
      default:
        return usage ?? '-';
    }
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });
}
