import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../../domain/entities/property_owner_entity.dart';

class PropertyOwnersCard extends StatelessWidget {
  final PropertyDetailsEntity property;
  final VoidCallback? onEditTap;

  const PropertyOwnersCard({
    super.key,
    required this.property,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline_rounded, size: 18, color: context.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  LocaleKeys.propertyOwnersTitle.tr(),
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Edit button only shown for draft properties
              if (property.isDraft && onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.08),
                      borderRadius: AppRadius.circularFull,
                      border: Border.all(
                        color: context.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 13, color: context.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          LocaleKeys.propertyOwnersEditBtn.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          property.owners.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    LocaleKeys.propertyOwnersNoOwners.tr(),
                    style: const TextStyle(
                        color: AppColors.textSecondaryLight, fontSize: 13),
                  ),
                )
              : Column(
                  children: property.owners
                      .map((owner) => _buildOwnerRow(context, owner))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildOwnerRow(BuildContext context, PropertyOwnerEntity owner) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: context.primarySubtle,
                child: Text(
                  owner.name.isNotEmpty ? owner.name[0] : 'م',
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            owner.name,
                            style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (owner.isRepresentative) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: context.primaryColor.withValues(alpha: 0.1),
                              borderRadius: AppRadius.circularFull,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    size: 11, color: context.primaryColor),
                                const SizedBox(width: 3),
                                Text(
                                  LocaleKeys.propertyOwnersRepresentative.tr(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: context.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (owner.phone != null)
                      Text(
                        owner.phone!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${owner.percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: AppRadius.circularFull,
            child: LinearProgressIndicator(
              value: (owner.percentage / 100).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFF1F5F9),
              color: context.primaryColor,
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}
