import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../domain/entities/property_details_entity.dart';
import 'property_basic_info_card.dart';
import 'property_deed_valuation_card.dart';
import 'property_details_metrics_bar.dart';
import 'property_owners_card.dart';
import 'draft_completion_banner.dart';

class PropertyOverviewTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOverviewTab({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyDetailsMetricsBar(property: property),
          if (property.isDraft)
            DraftCompletionBanner(
              property: property,
              onContinue: () => context.push(Routes.ownerPropertyEdit, extra: property),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                PropertyBasicInfoCard(property: property),
                const SizedBox(height: 16),
                PropertyOwnersCard(property: property),
                const SizedBox(height: 16),
                PropertyDeedValuationCard(property: property),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
