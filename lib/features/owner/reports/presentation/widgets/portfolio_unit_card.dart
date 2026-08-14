import 'package:flutter/material.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/units_status_item_entity.dart';
import 'portfolio_unit_card_content.dart';

class PortfolioUnitCard extends StatelessWidget {
  final UnitsStatusItemEntity unit;
  final bool compact;
  final VoidCallback onTap;

  const PortfolioUnitCard({
    super.key,
    required this.unit,
    required this.compact,
    required this.onTap,
  });

  Color get _statusColor => switch (unit.status.toLowerCase()) {
    'available' || 'vacant' => const Color(0xFF10B981),
    'rented' || 'leased' || 'occupied' => const Color(0xFFF59E0B),
    'maintenance' || 'under_maintenance' => const Color(0xFFEF4444),
    _ => const Color(0xFF64748B),
  };

  @override
  Widget build(BuildContext context) {
    final title = unit.name.isNotEmpty ? unit.name : unit.unitNumber;
    final property = unit.property.name.isNotEmpty
        ? unit.property.name
        : unit.property.code;
    final badge = _StatusBadge(
      label: unit.statusLabel.isNotEmpty ? unit.statusLabel : unit.status,
      color: _statusColor,
    );
    return Material(
      color: context.appSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularLg,
        side: BorderSide(color: context.appBorderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularLg,
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
          child: compact
              ? PortfolioUnitCompactContent(
                  title: title,
                  property: property,
                  status: badge,
                )
              : PortfolioUnitComfortableContent(
                  unit: unit,
                  title: title,
                  property: property,
                  status: badge,
                ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: AppRadius.circularFull,
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
    ),
  );
}
