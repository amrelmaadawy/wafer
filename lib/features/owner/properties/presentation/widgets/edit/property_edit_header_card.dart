import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyEditHeaderCard extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyEditHeaderCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final hasImage = property.imageUrls.isNotEmpty;
    final completionPct = property.completionPercentage;
    final primary = context.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow.withValues(alpha: 0.05),
            blurRadius: 15,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner Section
          Container(
            height: 140, // Slightly taller for a premium feel
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: hasImage ? null : primary.withValues(alpha: 0.04),
              image: hasImage
                  ? DecorationImage(
                      image: NetworkImage(property.imageUrls.first),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                if (!hasImage) ...[
                  // Decorative background element
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(
                      Icons.apartment_rounded,
                      size: 120,
                      color: primary.withValues(alpha: 0.04),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.maps_home_work_rounded,
                        size: 32,
                        color: primary,
                      ),
                    ),
                  ),
                ],
                if (hasImage)
                  // Gradient overlay for better text readability on images
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                // Property Code (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: AppRadius.circularFull,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: hasImage
                              ? Colors.black.withValues(alpha: 0.3)
                              : AppColors.textPrimaryLight.withValues(
                                  alpha: 0.05,
                                ),
                          borderRadius: AppRadius.circularFull,
                          border: Border.all(
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_rounded,
                              color: hasImage
                                  ? Colors.white
                                  : AppColors.textSecondaryLight,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              property.code,
                              style: TextStyle(
                                color: hasImage
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Status Badge (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: ClipRRect(
                    borderRadius: AppRadius.circularFull,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: hasImage
                              ? Colors.white.withValues(alpha: 0.2)
                              : primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.circularFull,
                          border: Border.all(
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.3)
                                : primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          property.statusLabel ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: hasImage ? Colors.white : primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimaryLight,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: AppColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  (property.address == null ||
                                          property.address!.isEmpty)
                                      ? LocaleKeys.commonNotSpecified.tr()
                                      : property.address!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondaryLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.08),
                        borderRadius: AppRadius.circularMd,
                        border: Border.all(
                          color: primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        property.propertyType ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (completionPct > 0) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.propertyDetailsCompletionPercentage.tr(),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (completionPct >= 80
                                      ? Colors.green
                                      : Colors.orange)
                                  .withValues(alpha: 0.1),
                          borderRadius: AppRadius.circularSm,
                        ),
                        child: Text(
                          '$completionPct%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: completionPct >= 80
                                ? Colors.green
                                : Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight.withValues(alpha: 0.5),
                          borderRadius: AppRadius.circularFull,
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            height: 6,
                            width:
                                constraints.maxWidth * (completionPct / 100.0),
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.circularFull,
                              gradient: LinearGradient(
                                colors: completionPct >= 80
                                    ? [Colors.green.shade400, Colors.green]
                                    : [Colors.orange.shade300, Colors.orange],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (completionPct >= 80
                                              ? Colors.green
                                              : Colors.orange)
                                          .withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
