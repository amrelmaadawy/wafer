import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/launcher_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';
import 'maintenance_status_badge.dart';

class MaintenanceAssignmentsSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceAssignmentsSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.assignments == null || item.assignments!.isEmpty) {
      return const SizedBox.shrink();
    }

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
              Icon(Icons.engineering_outlined,
                  size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                'الفنيين المسند إليهم الطلب', // Could be localized later
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...item.assignments!.map((assignment) => _buildTechnicianCard(context, assignment)),
        ],
      ),
    );
  }

  Widget _buildTechnicianCard(BuildContext context, dynamic assignment) {
    final tech = assignment.technician;
    if (tech == null) return const SizedBox.shrink();

    final techName = tech.name ?? '';
    final techPhone = tech.phone;
    final techSpecialty = tech.specialty ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.circularLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.handyman,
                            color: AppColors.info, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            techName,
                            style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (techSpecialty.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              techSpecialty,
                              style: const TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (techPhone != null && techPhone.isNotEmpty)
                _buildActionButton(
                  context,
                  icon: Icons.call,
                  color: AppColors.primary,
                  onTap: () => LauncherUtils.makePhoneCall(techPhone),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderLight, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaintenanceStatusBadge(
                status: assignment.status ?? 'pending',
                statusLabel: assignment.statusLabel ?? '',
              ),
              if (assignment.dueDate != null)
                Text(
                  '${LocaleKeys.commonInfo.tr()}: ${assignment.dueDate}', // generic due date text
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.circularMd,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.circularMd,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
