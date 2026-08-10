import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/unit_full_details_entity.dart';

class UnitMediaSection extends StatelessWidget {
  final UnitFullDetailsEntity unit;
  
  const UnitMediaSection({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final videos = unit.videos;
    final files = unit.attachments;

    if (videos.isEmpty && files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularMd,
              ),
              child: Icon(
                Icons.perm_media_outlined,
                color: context.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              LocaleKeys.unitsMediaSectionTitle.tr(),
              style: AppTextStyles.h4,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularLg,
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
              if (videos.isNotEmpty) ...[
                Text(
                  LocaleKeys.unitsVideosCount.tr(),
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return _buildVideoCard(context, videos[index]);
                    },
                  ),
                ),
              ],
              if (videos.isNotEmpty && files.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
              if (files.isNotEmpty) ...[
                Text(
                  LocaleKeys.unitsFilesCount.tr(),
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: files.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _buildFileCard(context, files[index]);
                  },
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, String videoUrl) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(videoUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularLg,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Assuming we don't have video thumbnails, show a placeholder
            Icon(
              Icons.video_file_outlined,
              size: 48,
              color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, String fileUrl) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(fileUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.circularMd,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: AppRadius.circularSm,
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileUrl.split('/').last,
                style: AppTextStyles.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.download_rounded,
              color: AppColors.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
