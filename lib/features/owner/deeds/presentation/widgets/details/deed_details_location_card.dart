import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../domain/entities/deed_entity.dart';

class DeedDetailsLocationCard extends StatelessWidget {
  final DeedEntity deed;

  const DeedDetailsLocationCard({super.key, required this.deed});

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
                child: Icon(Icons.location_on_outlined, color: context.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.deedLocationInfo.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.location_city_rounded,
                  label: LocaleKeys.deedCity.tr(),
                  value: deed.city ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.map_rounded,
                  label: LocaleKeys.deedDistrict.tr(),
                  value: deed.district ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.signpost_rounded,
                  label: LocaleKeys.deedStreetName.tr(),
                  value: deed.streetName ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.home_rounded,
                  label: LocaleKeys.deedBuildingNumber.tr(),
                  value: deed.buildingNumber ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.public_rounded,
                  label: LocaleKeys.deedRegion.tr(),
                  value: deed.region ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationItem(
                  context,
                  icon: Icons.markunread_mailbox_rounded,
                  label: LocaleKeys.deedPostalCode.tr(),
                  value: deed.postalCode ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: context.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
