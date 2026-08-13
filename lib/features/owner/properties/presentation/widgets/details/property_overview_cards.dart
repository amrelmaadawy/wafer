import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_breakpoints.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/property_details_entity.dart';
import 'property_basic_info_card.dart';
import 'property_deed_card.dart';
import 'property_location_card.dart';

class PropertyOverviewCards extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOverviewCards({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final basic = PropertyBasicInfoCard(property: property);
    final secondary = Column(
      children: [
        PropertyLocationCard(property: property),
        const SizedBox(height: AppSpacing.md),
        PropertyDeedCard(property: property),
      ],
    );

    if (!context.isExpanded) {
      return Column(
        children: [
          basic,
          const SizedBox(height: AppSpacing.md),
          secondary,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: basic),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: secondary),
      ],
    );
  }
}
