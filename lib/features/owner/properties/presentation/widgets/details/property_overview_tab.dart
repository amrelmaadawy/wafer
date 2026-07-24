import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../cubit/details/property_details_cubit.dart';
import '../../cubit/owners/sync_owners_cubit.dart';
import 'draft_completion_banner.dart';
import 'owner_sync_sheet.dart';
import 'property_basic_info_card.dart';
import 'property_deed_valuation_card.dart';
import 'property_details_metrics_bar.dart';
import 'property_owners_card.dart';

class PropertyOverviewTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOverviewTab({
    super.key,
    required this.property,
  });

  void _showOwnerSyncSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<SyncOwnersCubit>()
          ..loadOwnersFromApi(currentOwners: property.owners),
        child: OwnerSyncSheet(
          propertyId: property.id,
          onSuccess: () {
            context.read<PropertyDetailsCubit>().loadDetails(property.id);
          },
        ),
      ),
    );
  }

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
              onContinue: () =>
                  context.push(Routes.ownerPropertyEdit, extra: property),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                PropertyBasicInfoCard(property: property),
                const SizedBox(height: 16),
                PropertyOwnersCard(
                  property: property,
                  onEditTap: () => _showOwnerSyncSheet(context),
                ),
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
