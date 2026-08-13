import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/property_details_entity.dart';
import 'draft_completion_banner.dart';
import 'property_details_metrics_bar.dart';
import 'property_incomplete_data_card.dart';
import 'property_overview_cards.dart';

class PropertyOverviewTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOverviewTab({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyDetailsMetricsBar(property: property),
          AppResponsiveContent(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  PropertyIncompleteDataCard(property: property),
                  if (property.isDraft) ...[
                    const SizedBox(height: AppSpacing.sm),
                    DraftCompletionBanner(
                      property: property,
                      onContinue: () => context.push(
                        Routes.ownerPropertyEdit,
                        extra: property,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  PropertyOverviewCards(property: property),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
