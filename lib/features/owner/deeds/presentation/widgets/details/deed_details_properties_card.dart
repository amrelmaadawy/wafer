import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../domain/entities/deed_entity.dart';

import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/presentation/widgets/animations/animated_press_card.dart';

class DeedDetailsPropertiesCard extends StatelessWidget {
  final DeedEntity deed;

  const DeedDetailsPropertiesCard({super.key, required this.deed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.apartment_rounded, color: context.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.deedPropertiesTitle.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${deed.propertiesCount}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (deed.properties.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deed.properties.length,
              separatorBuilder: (_, _) => const Divider(color: AppColors.borderLight, height: 16),
              itemBuilder: (context, index) {
                final property = deed.properties[index];
                return AnimatedPressCard(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    context.push('${Routes.ownerPropertyDetails}?id=${property.id}');
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.home_work_rounded, color: context.primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.name ?? LocaleKeys.occupancyUnnamedProperty.tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              property.code,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (property.status != null)
                            _buildBadge(
                              property.status!,
                              property.status == 'published' ? const Color(0xFF10B981) : AppColors.textSecondaryLight,
                            ),
                          if (property.propertyType != null) ...[
                            const SizedBox(height: 4),
                            _buildBadge(
                              property.propertyType!,
                              context.primaryColor,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(Icons.layers_clear_rounded, size: 40, color: AppColors.textSecondaryLight.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.deedNoPropertiesFound.tr(), // Fallback or maybe we should add specific empty state key, but this works for now or create a better one.
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text, // ideally localized using tr(), e.g. status.tr() if mapping exists.
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
