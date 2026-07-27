import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/maintenance_requests_item_entity.dart';

class MaintenanceRequestsReportItemCard extends StatelessWidget {
  final MaintenanceRequestsItemEntity item;

  const MaintenanceRequestsReportItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const Divider(height: 1, color: AppColors.borderLight),
          _buildBody(context),
          const Divider(height: 1, color: AppColors.borderLight),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withAlpha(25),
                  borderRadius: AppRadius.circularSm,
                ),
                child: Icon(
                  Icons.build_circle_rounded,
                  size: 20,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.requestNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.createdAt.split(' ').first,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;

    switch (item.status) {
      case 'new':
      case 'pending_supervisor':
        bgColor = Colors.blue.withAlpha(25);
        textColor = Colors.blue.shade700;
        break;
      case 'in_progress':
      case 'assigned':
        bgColor = Colors.orange.withAlpha(25);
        textColor = Colors.orange.shade700;
        break;
      case 'executed':
      case 'completed':
      case 'closed':
        bgColor = Colors.green.withAlpha(25);
        textColor = Colors.green.shade700;
        break;
      case 'cancelled':
      case 'rejected':
        bgColor = Colors.red.withAlpha(25);
        textColor = Colors.red.shade700;
        break;
      default:
        bgColor = AppColors.backgroundLight;
        textColor = AppColors.textSecondaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.circularXl,
      ),
      child: Text(
        item.statusLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.description.isNotEmpty) ...[
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.person_outline_rounded,
                  label: LocaleKeys.maintenanceRequestsClient.tr(),
                  value: item.clientName.isNotEmpty ? item.clientName : LocaleKeys.maintenanceRequestsUnknownRenter.tr(),
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.phone_outlined,
                  label: LocaleKeys.maintenanceRequestsPhone.tr(),
                  value: item.clientPhone.isNotEmpty ? item.clientPhone : '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondaryLight),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.business_rounded,
                  size: 16,
                  color: context.primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${item.property.name.isNotEmpty ? item.property.name : item.property.code} - ${item.unit.name.isNotEmpty ? item.unit.name : item.unit.unitNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
