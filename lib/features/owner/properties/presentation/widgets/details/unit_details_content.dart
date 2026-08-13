import 'package:flutter/material.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import 'unit_amenities_section.dart';
import 'unit_basic_info_card.dart';
import 'unit_contract_banner.dart';
import 'unit_dimensions_card.dart';
import 'unit_maintenance_section.dart';
import 'unit_media_section.dart';
import 'unit_meters_section.dart';
import 'unit_prices_section.dart';
import 'unit_specs_grid.dart';

class UnitDetailsContent extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitDetailsContent({super.key, required this.unit});

  bool get _hasMeters =>
      unit.meters.electricity != null ||
      unit.meters.water != null ||
      unit.meters.gas != null;

  List<Widget> get _mobileSections => [
    UnitBasicInfoCard(unit: unit),
    if (unit.currentContract case final contract?)
      UnitContractBanner(contract: contract),
    UnitPricesSection(unit: unit),
    UnitSpecsGrid(unit: unit),
    UnitDimensionsCard(unit: unit),
    if (_hasMeters) UnitMetersSection(unit: unit),
    if (unit.amenities.isNotEmpty) UnitAmenitiesSection(unit: unit),
    if (unit.videos.isNotEmpty || unit.attachments.isNotEmpty)
      UnitMediaSection(unit: unit),
    if (unit.maintenanceRequests.isNotEmpty) UnitMaintenanceSection(unit: unit),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return _SectionGroup(children: _mobileSections);
        }
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _SectionGroup(
                    children: [
                      UnitBasicInfoCard(unit: unit),
                      if (unit.currentContract case final contract?)
                        UnitContractBanner(contract: contract),
                      UnitSpecsGrid(unit: unit),
                      UnitDimensionsCard(unit: unit),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _SectionGroup(
                    children: [
                      UnitPricesSection(unit: unit),
                      if (_hasMeters) UnitMetersSection(unit: unit),
                      if (unit.amenities.isNotEmpty)
                        UnitAmenitiesSection(unit: unit),
                    ],
                  ),
                ),
              ],
            ),
            if (unit.videos.isNotEmpty ||
                unit.attachments.isNotEmpty ||
                unit.maintenanceRequests.isNotEmpty) ...[
              const SizedBox(height: 28),
              _SectionGroup(
                children: [
                  if (unit.videos.isNotEmpty || unit.attachments.isNotEmpty)
                    UnitMediaSection(unit: unit),
                  if (unit.maintenanceRequests.isNotEmpty)
                    UnitMaintenanceSection(unit: unit),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SectionGroup extends StatelessWidget {
  final List<Widget> children;

  const _SectionGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 28),
          children[index],
        ],
      ],
    );
  }
}
