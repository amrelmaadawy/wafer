import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/presentation/widgets/animations/animated_press_card.dart';
import '../../domain/entities/deed_entity.dart';

class DeedCard extends StatelessWidget {
  final DeedEntity deed;
  final VoidCallback? onTap;
  final VoidCallback? onAttachmentTap;

  const DeedCard({
    super.key,
    required this.deed,
    this.onTap,
    this.onAttachmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.circularXl,
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF94A3B8).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildBody(context),
            if (deed.hasAttachment) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),
              _buildAttachmentButton(context),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.primarySubtle,
            borderRadius: AppRadius.circularLg,
          ),
          child: Icon(
            Icons.description_rounded,
            color: context.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deed.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.tag_rounded, size: 12, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text(
                    deed.code,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildTypeBadge(),
      ],
    );
  }

  Widget _buildTypeBadge() {
    final bool isElectronic = deed.isElectronic;
    final Color bgColor = isElectronic ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE);
    final Color textColor = isElectronic ? const Color(0xFF059669) : const Color(0xFF2563EB);
    final String label = isElectronic ? LocaleKeys.deeds_electronic_deed.tr() : LocaleKeys.deeds_manual_deed.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.circularFull,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            icon: Icons.aspect_ratio_rounded,
            label: LocaleKeys.deeds_area_label.tr(),
            value: '${deed.area}',
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.location_city_rounded,
            label: deed.city ?? LocaleKeys.maintenance_not_determined_yet.tr(),
            value: deed.district ?? '',
          ),
        ),
        Expanded(
          child: _buildInfoItem(
            icon: Icons.home_work_rounded,
            label: LocaleKeys.deeds_properties_count_label.tr(args: ['']),
            value: '${deed.propertiesCount}',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAttachmentButton(BuildContext context) {
    return GestureDetector(
      onTap: onAttachmentTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.file_download_outlined, size: 18, color: context.primaryColor),
          const SizedBox(width: 6),
          Text(
            LocaleKeys.deeds_document_attachment.tr(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
