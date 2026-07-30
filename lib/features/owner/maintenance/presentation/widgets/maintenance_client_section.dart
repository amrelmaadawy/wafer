import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/launcher_utils.dart';
import '../../domain/entities/maintenance_item_entity.dart';

class MaintenanceClientSection extends StatelessWidget {
  final MaintenanceItemEntity item;

  const MaintenanceClientSection({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.client == null || (item.client?.name?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    final clientName = item.client!.name!;
    final clientPhone = item.client!.phone;

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
              Icon(Icons.person_outline, size: 20, color: context.primaryColor),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.maintenanceCostBearerClient
                    .tr(), // Or a more generic 'Client Info' if available
                style: const TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    clientName.isNotEmpty ? clientName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (clientPhone != null && clientPhone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        clientPhone,
                        style: const TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (clientPhone != null && clientPhone.isNotEmpty) ...[
                _buildActionButton(
                  context,
                  icon: Icons.call,
                  color: AppColors.primary,
                  onTap: () => LauncherUtils.makePhoneCall(clientPhone),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  icon: Icons.chat_bubble_outline,
                  color: AppColors.success,
                  onTap: () => LauncherUtils.openWhatsApp(clientPhone),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
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
