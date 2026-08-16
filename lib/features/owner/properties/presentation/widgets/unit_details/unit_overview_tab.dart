import 'package:flutter/material.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../domain/entities/unit_full_details_entity.dart';
import '../details/unit_amenities_section.dart';
import '../details/unit_basic_info_card.dart';
import '../details/unit_dimensions_card.dart';
import '../details/unit_media_section.dart';
import '../details/unit_meters_section.dart';
import '../details/unit_prices_section.dart';
import '../details/unit_specs_grid.dart';

class UnitOverviewTab extends StatelessWidget {
  final UnitFullDetailsEntity unit;

  const UnitOverviewTab({super.key, required this.unit});

  bool get _hasMeters =>
      unit.meters.electricity != null ||
      unit.meters.water != null ||
      unit.meters.gas != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      child: AppResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UnitBasicInfoCard(unit: unit),
            const SizedBox(height: 20),
            UnitPricesSection(unit: unit),
            const SizedBox(height: 20),
            UnitSpecsGrid(unit: unit),
            const SizedBox(height: 20),
            UnitDimensionsCard(unit: unit),
            if (_hasMeters) ...[
              const SizedBox(height: 20),
              UnitMetersSection(unit: unit),
            ],
            if (unit.amenities.isNotEmpty) ...[
              const SizedBox(height: 20),
              UnitAmenitiesSection(unit: unit),
            ],
            if (unit.videos.isNotEmpty || unit.attachments.isNotEmpty) ...[
              const SizedBox(height: 20),
              UnitMediaSection(unit: unit),
            ],
          ],
        ),
      ),
    );
  }
}
