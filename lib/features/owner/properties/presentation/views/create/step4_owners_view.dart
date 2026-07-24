import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../cubit/create/property_create_cubit.dart';
import '../../cubit/create/property_create_state.dart';
import '../../widgets/create/owner_entry_card.dart';
import '../../widgets/create/owner_selection_sheet.dart';

class Step4OwnersView extends StatelessWidget {
  const Step4OwnersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyCreateCubit, PropertyCreateState>(
      builder: (context, state) {
        final cubit = context.read<PropertyCreateCubit>();
        final double totalPercentage = state.owners.fold(0.0, (sum, o) => sum + o.percentage.toDouble());
        final is100 = (totalPercentage - 100.0).abs() < 0.01;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.propertyWizardStep4Title.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.propertyCreateOwnersSubtitle.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              _buildAddOwnerSection(context, state, cubit),
              const SizedBox(height: 24),
              _buildProgressBar(context, totalPercentage, is100),
              const SizedBox(height: 24),
              if (state.owners.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${LocaleKeys.propertyCreateOwnersAddedCount.tr()} (${state.owners.length})',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    TextButton.icon(
                      onPressed: () => cubit.autoDistributePercentages(),
                      icon: const Icon(Icons.calculate_outlined, size: 18),
                      label: Text(LocaleKeys.propertyOwnersAutoDistribute.tr()),
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...state.owners.map((owner) => OwnerEntryCard(owner: owner, cubit: cubit)),
              ] else
                _buildEmptyState(context),
              
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOwnerSection(BuildContext context, PropertyCreateState state, PropertyCreateCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.propertyOwnersAddOwner.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final availableOwners = state.formData?.options.owners ?? [];
                
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return OwnerSelectionSheet(
                      availableOwners: availableOwners,
                      addedOwnerIds: state.owners.map((e) => e.id).toSet(),
                      onSelect: (owner) {
                        cubit.addOwner(PropertyOwnerEntity(
                          id: owner.id,
                          name: owner.name,
                          percentage: 0,
                          isRepresentative: false,
                        ));
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.person_add_alt_1_outlined, color: context.primaryColor, size: 20),
              label: Text(
                LocaleKeys.propertyOwnersAddOwner.tr(),
                style: TextStyle(color: context.primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.primaryColor.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double totalPercentage, bool is100) {
    final progressColor = is100 ? AppColors.success : context.primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.propertyOwnersTotalPercentage.tr(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              '${totalPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: progressColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: AppRadius.circularFull,
          child: LinearProgressIndicator(
            value: (totalPercentage / 100).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFE2E8F0),
            color: progressColor,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.propertyOwnersNoOwners.tr(),
            style: const TextStyle(color: AppColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }
}
