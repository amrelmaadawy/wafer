import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../owner/maintenance/domain/entities/maintenance_item_entity.dart';
import '../../../../owner/maintenance/presentation/screens/owner_maintenance_details_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/owner_dashboard_cubit.dart';

class OwnerMaintenanceMiniCard extends StatelessWidget {
  final MaintenanceItemEntity item;

  const OwnerMaintenanceMiniCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final title = (item.title?.isNotEmpty ?? false)
        ? item.title!
        : '#${item.requestNumber ?? item.id}';
    final propertyName = item.property?.name ?? '';
    final unitName = item.unit?.name ?? '';
    final locationTitle = unitName.isNotEmpty && propertyName.isNotEmpty
        ? '$propertyName - $unitName'
        : propertyName.isNotEmpty
        ? propertyName
        : 'غير محدد';
    final requestedDate = item.dates?.requestedDate ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => OwnerMaintenanceDetailsScreen(item: item),
            ),
          );
          if (result == true && context.mounted) {
            context.read<OwnerDashboardCubit>().loadDashboardStats(
              forceRefresh: true,
            );
          }
        },
        borderRadius: AppRadius.circularXl,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.circularXl,
            border: Border.all(color: const Color(0xFFEDF0F7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBadge(),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.domain_rounded,
                    size: 12,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      locationTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                requestedDate,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    switch (item.status) {
      case 'pending':
      case 'new':
        color = const Color(0xFFF59E0B);
        break;
      case 'approved':
      case 'in_progress':
        color = const Color(0xFF3B82F6);
        break;
      case 'executed':
      case 'completed':
        color = const Color(0xFF10B981);
        break;
      case 'rejected':
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            item.statusLabel ?? '',
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
