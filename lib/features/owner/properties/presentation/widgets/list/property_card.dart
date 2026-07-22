import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_list_item_entity.dart';

class PropertyCard extends StatelessWidget {
  final PropertyListItemEntity property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  IconData get _typeIcon {
    switch (property.propertyType.toLowerCase()) {
      case 'land':
        return Icons.landscape_rounded;
      case 'villa':
        return Icons.villa_rounded;
      case 'complex':
        return Icons.domain_rounded;
      default:
        return Icons.apartment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDraft = property.isDraft;
    final statusColor = isDraft ? AppColors.warning : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFEDF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.circularXl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.primarySubtle,
                      borderRadius: AppRadius.circularLg,
                    ),
                    child: Icon(_typeIcon, color: context.primaryColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              property.code,
                              style: TextStyle(
                                color: context.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                property.name,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property.displayAddress,
                                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularFull,
                    ),
                    child: Text(
                      property.statusLabel.isNotEmpty ? property.statusLabel : (isDraft ? LocaleKeys.propertiesStatusDraft.tr() : LocaleKeys.propertiesStatusPublished.tr()),
                      style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.meeting_room_outlined, size: 15, color: context.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        '${property.unitsCount} ${LocaleKeys.propertiesCardUnits.tr()}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      if (property.area != null) ...[
                        const SizedBox(width: 14),
                        const Icon(Icons.square_foot_outlined, size: 15, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 4),
                        Text(
                          '${property.area} ${LocaleKeys.propertiesCardArea.tr()}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ],
                  ),
                  if (property.primaryOwnerName != null)
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 4),
                        Text(
                          property.primaryOwnerName!,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
