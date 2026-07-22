import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyBasicInfoCard extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyBasicInfoCard({
    super.key,
    required this.property,
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
              Icon(Icons.info_outline_rounded, size: 18, color: context.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'البيانات الأساسية',
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          _buildInfoRow('كود العقار', property.code, Icons.qr_code_rounded),
          _buildInfoRow('نوع العقار', property.propertyType, Icons.apartment_rounded),
          if (property.usageType != null)
            _buildInfoRow('نوع الاستخدام', property.usageType!, Icons.category_outlined),
          if (property.branchName != null)
            _buildInfoRow('فرع الإدارة', property.branchName!, Icons.storefront_outlined),
          if (property.constructionYear != null)
            _buildInfoRow('سنة البناء', '${property.constructionYear}', Icons.calendar_today_rounded),
          _buildInfoRow('العنوان', property.formattedAddress, Icons.location_on_outlined),
          if (property.description != null && property.description!.isNotEmpty)
            _buildInfoRow('ملاحظات', property.description!, Icons.notes_rounded),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
