import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';

class MaintenanceImagesSection extends StatelessWidget {
  final List<String> images;

  const MaintenanceImagesSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library_outlined,
                  size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.maintenanceImagesSection.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (images.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: AppRadius.circularLg,
              ),
              child: Text(
                LocaleKeys.maintenanceNoImages.tr(),
                style: const TextStyle(
                    color: AppColors.textSecondaryLight, fontSize: 13),
              ),
            )
          else
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: AppRadius.circularLg,
                    child: Container(
                      width: 110,
                      height: 110,
                      color: AppColors.backgroundLight,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image_outlined,
                                color: AppColors.textSecondaryLight),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
