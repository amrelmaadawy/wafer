import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/color_utils.dart';
import '../../../cubit/units/unit_create_cubit.dart';
import '../../../cubit/units/unit_create_state.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/localization/locale_keys.dart';

class Step6ReviewView extends StatelessWidget {
  const Step6ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitCreateCubit, UnitCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.unitsReviewTitle.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.unitsReviewSubtitle.tr(),
                style: const TextStyle(color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),

              _buildSection(
                context,
                title: LocaleKeys.unitsBasicInfoTitle.tr(),
                icon: Icons.info_outline,
                children: [
                  _buildReviewItem(
                    LocaleKeys.unitsUnitNameLabel.tr(),
                    state.name ?? LocaleKeys.unitsNotSpecified.tr(),
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsUnitNumberLabel.tr(),
                    state.unitNumber ?? LocaleKeys.unitsNotSpecified.tr(),
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsUnitTypeLabel.tr(),
                    state.unitType,
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsPurposeLabel.tr(),
                    state.purpose,
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsFinishingTypeLabel.tr(),
                    state.finishingType,
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsIsFurnishedLabel.tr(),
                    state.isFurnished
                        ? LocaleKeys.unitsYes.tr()
                        : LocaleKeys.unitsNo.tr(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: LocaleKeys.unitsSpecsTitle.tr(),
                icon: Icons.square_foot,
                children: [
                  _buildReviewItem(
                    LocaleKeys.unitsAreaLabel.tr(),
                    '${state.area ?? 0} م²',
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsFloorTypeLabel.tr(),
                    '${state.floorType} (${state.floorNumber ?? 0})',
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsRooms.tr(),
                    '${state.roomsCount ?? 0}',
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsBathrooms.tr(),
                    '${state.bathroomsCount ?? 0}',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: LocaleKeys.unitsLocationUtilsTitle.tr(),
                icon: Icons.location_on_outlined,
                children: [
                  _buildReviewItem(
                    LocaleKeys.unitsCity.tr(),
                    state.city ?? LocaleKeys.unitsNotSpecified.tr(),
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsDistrict.tr(),
                    state.district ?? LocaleKeys.unitsNotSpecified.tr(),
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsFeatures.tr(),
                    state.amenities.isEmpty
                        ? LocaleKeys.unitsNone.tr()
                        : state.amenities.join('، '),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: LocaleKeys.unitsFinancialsTitle.tr(),
                icon: Icons.attach_money,
                children: [
                  _buildReviewItem(
                    LocaleKeys.unitsAnnualRentMonthlyLabel.tr(),
                    '${state.annualRentMonthly ?? 0}',
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsAnnualRent2PaymentsLabel.tr(),
                    '${state.annualRent2Payments ?? 0}',
                  ),
                  _buildReviewItem(
                    LocaleKeys.unitsAnnualRent4PaymentsLabel.tr(),
                    '${state.annualRent4Payments ?? 0}',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSection(
                context,
                title: LocaleKeys.unitsImagesTitle.tr(),
                icon: Icons.image_outlined,
                children: [
                  _buildReviewItem(
                    LocaleKeys.unitsAttachedImagesCount.tr(),
                    '${state.images.length} ${LocaleKeys.unitsImagesCount.tr()}',
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: const Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: context.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
