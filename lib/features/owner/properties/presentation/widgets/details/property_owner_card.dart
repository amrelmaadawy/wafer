import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_owner_entity.dart';
import '../../cubit/details/property_details_cubit.dart';

class PropertyOwnerCard extends StatelessWidget {
  final PropertyOwnerEntity owner;
  final int propertyId;
  final int? actionOwnerId;
  final bool isMakingRep;
  final bool isRemovingRep;

  const PropertyOwnerCard({
    super.key,
    required this.owner,
    required this.propertyId,
    required this.actionOwnerId,
    required this.isMakingRep,
    required this.isRemovingRep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: owner.isRepresentative
            ? context.primaryColor.withValues(alpha: 0.03)
            : AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(
          color: owner.isRepresentative
              ? context.primaryColor.withValues(alpha: 0.5)
              : AppColors.borderLight,
          width: owner.isRepresentative ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: owner.isRepresentative
                  ? context.primaryColor.withValues(alpha: 0.1)
                  : AppColors.surfaceSubtleLight,
              child: Icon(
                owner.isRepresentative
                    ? Icons.workspace_premium_rounded
                    : Icons.person_rounded,
                color: owner.isRepresentative
                    ? context.primaryColor
                    : AppColors.textSecondaryLight,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          owner.name,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtleLight,
                          borderRadius: AppRadius.circularXxl,
                        ),
                        child: Text(
                          '${owner.percentage}%',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        owner.phone ?? LocaleKeys.propertyDetailsNoPhone.tr(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActionArea(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(BuildContext context) {
    if (owner.isRepresentative) {
      if (isRemovingRep && actionOwnerId == owner.id) {
        return _buildLoading(Colors.red.shade400);
      }
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () {
            context
                .read<PropertyDetailsCubit>()
                .removeRepresentative(propertyId, owner.id);
          },
          borderRadius: AppRadius.circularMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularMd,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_remove_rounded,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys.propertyDetailsRemoveRepresentative.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (isMakingRep && actionOwnerId == owner.id) {
        return _buildLoading(context.primaryColor);
      }
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
          onTap: () {
            context
                .read<PropertyDetailsCubit>()
                .makeRepresentative(propertyId, owner.id);
          },
          borderRadius: AppRadius.circularMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.circularMd,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.how_to_reg_rounded,
                  size: 16,
                  color: context.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys.propertyDetailsMakeRepresentative.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLoading(Color color) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        ),
      ),
    );
  }
}
