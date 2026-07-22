import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyDeedValuationCard extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyDeedValuationCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    if (property.deedNumber == null && property.valuationAmount == null) {
      return const SizedBox.shrink();
    }

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
              Icon(Icons.description_outlined, size: 18, color: context.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'بيانات الصك والتقييم',
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
          if (property.deedNumber != null) ...[
            _buildRow('رقم الصك', property.deedNumber!, Icons.tag_rounded),
            if (property.deedDate != null)
              _buildRow('تاريخ الصك', property.deedDate!, Icons.event_available_rounded),
            if (property.documentType != null)
              _buildRow('نوع الوثيقة', property.documentType!, Icons.file_present_rounded),
          ],
          if (property.valuationAmount != null) ...[
            if (property.deedNumber != null) const SizedBox(height: 8),
            _buildRow('قيمة التقييم', '${property.valuationAmount} ر.س', Icons.monetization_on_outlined),
            if (property.valuationEntity != null)
              _buildRow('جهة التقييم', property.valuationEntity!, Icons.business_rounded),
            if (property.valuationDate != null)
              _buildRow('تاريخ التقييم', property.valuationDate!, Icons.date_range_rounded),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
