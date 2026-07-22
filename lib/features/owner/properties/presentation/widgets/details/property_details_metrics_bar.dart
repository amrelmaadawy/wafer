import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';

class PropertyDetailsMetricsBar extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyDetailsMetricsBar({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildMetricCard(
            context,
            label: 'إجمالي الوحدات',
            value: '${property.unitsCount}',
            subtext: '${property.rentedUnits} مؤجرة | ${property.availableUnits} متاحة',
            icon: Icons.meeting_room_rounded,
            color: context.primaryColor,
            bgColor: context.primarySubtle,
          ),
          const SizedBox(width: 10),
          _buildMetricCard(
            context,
            label: 'نسبة الإشغال',
            value: '${property.occupancyRate.toStringAsFixed(0)}%',
            subtext: 'معدل التأجير الفعلي',
            icon: Icons.pie_chart_rounded,
            color: const Color(0xFF10B981),
            bgColor: const Color(0xFFD1FAE5),
          ),
          if (property.area != null) ...[
            const SizedBox(width: 10),
            _buildMetricCard(
              context,
              label: 'المساحة الإجمالية',
              value: '${property.area} م²',
              subtext: property.length != null && property.width != null
                  ? '${property.length}م × ${property.width}م'
                  : 'مساحة المسح الميداني',
              icon: Icons.square_foot_rounded,
              color: const Color(0xFF8B5CF6),
              bgColor: const Color(0xFFF3E8FF),
            ),
          ],
          if (property.valuationAmount != null) ...[
            const SizedBox(width: 10),
            _buildMetricCard(
              context,
              label: 'قيمة التقييم',
              value: '${property.valuationAmount} ر.س',
              subtext: property.valuationEntity ?? 'تقييم معتمد',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFFF59E0B),
              bgColor: const Color(0xFFFEF3C7),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: AppRadius.circularMd,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryLight,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.5),
              borderRadius: AppRadius.circularFull,
            ),
            child: Text(
              subtext,
              style: TextStyle(
                fontSize: 10.5,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
