import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../domain/entities/deed_entity.dart';

class DeedDetailsInfoCard extends StatelessWidget {
  final DeedEntity deed;

  const DeedDetailsInfoCard({super.key, required this.deed});

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
                child: Icon(Icons.info_outline_rounded, color: context.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.deedBasicInfo.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            icon: Icons.numbers_rounded,
            label: LocaleKeys.deedNumber.tr(),
            value: deed.documentNumber ?? '-',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.borderLight),
          ),
          _buildInfoRow(
            context,
            icon: Icons.calendar_today_rounded,
            label: LocaleKeys.deedDate.tr(),
            value: deed.documentDate ?? '-',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.borderLight),
          ),
          _buildInfoRow(
            context,
            icon: Icons.square_foot_rounded,
            label: LocaleKeys.deedArea.tr(),
            value: '${deed.area} ${LocaleKeys.deedAreaUnit.tr()}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondaryLight),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
