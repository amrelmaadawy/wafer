import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_radius.dart' show AppRadius;
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../cubit/details/property_details_cubit.dart';
import '../../cubit/details/property_details_state.dart';

import 'property_owner_card.dart';

class PropertyOwnersTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOwnersTab({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyDetailsCubit, PropertyDetailsState>(
      listener: (context, state) {
        if (state is PropertyDetailsLoaded &&
            state.actionOwnerId == null &&
            !state.isMakingRepresentative) {
          // Success is implied if we go from isMakingRepresentative = true back to false.
        }
      },
      buildWhen: (previous, current) {
        if (previous is! PropertyDetailsLoaded || current is! PropertyDetailsLoaded) return true;
        return previous.property.owners != current.property.owners ||
               previous.actionOwnerId != current.actionOwnerId ||
               previous.isMakingRepresentative != current.isMakingRepresentative ||
               previous.isRemovingRepresentative != current.isRemovingRepresentative;
      },
      builder: (context, state) {
        final currentProperty = state is PropertyDetailsLoaded
            ? state.property
            : property;
        final actionOwnerId = state is PropertyDetailsLoaded
            ? state.actionOwnerId
            : null;
        final isMakingRep = state is PropertyDetailsLoaded
            ? state.isMakingRepresentative
            : false;
        final isRemovingRep = state is PropertyDetailsLoaded
            ? state.isRemovingRepresentative
            : false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyDetailsOwners.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              if (currentProperty.owners.isEmpty)
                Center(child: Text(LocaleKeys.propertyDetailsNoOwners.tr()))
              else
                ...currentProperty.owners.map(
                  (owner) => PropertyOwnerCard(
                    owner: owner,
                    propertyId: currentProperty.id,
                    actionOwnerId: actionOwnerId,
                    isMakingRep: isMakingRep,
                    isRemovingRep: isRemovingRep,
                  ),
                ),

              const SizedBox(height: 24),
              Text(
                LocaleKeys.propertyDetailsDeedAndDocs.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.circularXl,
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDocRow(
                        LocaleKeys.deedsNumber.tr(),
                        currentProperty.deedNumber ?? '-',
                      ),
                      const Divider(color: AppColors.dividerSubtleLight),
                      _buildDocRow(
                        LocaleKeys.deedsDate.tr(),
                        currentProperty.deedDate ?? '-',
                      ),
                      const Divider(color: AppColors.dividerSubtleLight),
                      _buildDocRow(
                        LocaleKeys.deedsDocumentType.tr(),
                        currentProperty.documentType ?? '-',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
        ],
      ),
    );
  }
}

