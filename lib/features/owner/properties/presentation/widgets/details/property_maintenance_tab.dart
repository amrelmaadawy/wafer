import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/maintenance_entity.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import 'package:wafer/features/owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:wafer/features/owner/maintenance/presentation/widgets/maintenance_status_badge.dart';

class PropertyMaintenanceTab extends StatelessWidget {
  final List<MaintenanceEntity> maintenanceRequests;

  const PropertyMaintenanceTab({super.key, required this.maintenanceRequests});

  @override
  Widget build(BuildContext context) {
    if (maintenanceRequests.isEmpty) {
      return CustomEmptyWidget(
        icon: Icons.handyman_outlined,
        title: LocaleKeys.maintenanceNoRequestsTitle.tr(),
        subtitle: LocaleKeys.dashboard_no_data.tr(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: maintenanceRequests.length,
      itemBuilder: (context, index) {
        final request = maintenanceRequests[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.push(
                  Routes.ownerMaintenanceDetails,
                  extra: MaintenanceItemEntity(
                    id: request.id,
                    requestNumber: request.requestNumber,
                    description: request.description,
                    status: request.status,
                    statusLabel: request.statusLabel,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Icon(Icons.handyman_rounded, size: 16, color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          request.requestNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                    MaintenanceStatusBadge(
                      status: request.status,
                      statusLabel: request.statusLabel,
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (request.description.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description_outlined, size: 16, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              request.description,
                              style: const TextStyle(
                                color: AppColors.textPrimaryLight,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        const Icon(Icons.meeting_room_outlined, size: 16, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 8),
                        Text(
                          '${LocaleKeys.maintenanceUnitLabel.tr()}: ',
                          style: const TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            request.unitName,
                            style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.payments_outlined, size: 16, color: context.primaryColor),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.maintenanceEstimatedCost.tr(),
                                  style: const TextStyle(
                                    color: AppColors.textSecondaryLight,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${request.estimatedCost} ر.س',
                                  style: TextStyle(
                                    color: context.primaryColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (request.requestedDate != null)
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondaryLight),
                              const SizedBox(width: 4),
                              Text(
                                request.requestedDate!,
                                style: const TextStyle(
                                  color: AppColors.textSecondaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
              ),
            ),
          ),
        );
      },
    );
  }
}
