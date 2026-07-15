import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import 'owner_maintenance_mini_card.dart';

class OwnerMaintenanceHubSection extends StatelessWidget {
  final int pendingCount;
  final List<MaintenanceItemEntity> recentItems;

  const OwnerMaintenanceHubSection({
    super.key,
    required this.pendingCount,
    required this.recentItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: const Color(0xFFEDF0F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          if (recentItems.isEmpty)
            _buildEmptyState(context)
          else
            _buildRecentList(context),
          if (recentItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildViewAllButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
          ),
          child: const Icon(Icons.build_circle_outlined, color: Color(0xFF8B5CF6), size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleKeys.dashboardMaintenanceHub.tr(),
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        _buildBadge(),
      ],
    );
  }

  Widget _buildBadge() {
    final hasPending = pendingCount > 0;
    final color = hasPending ? AppColors.error : const Color(0xFF94A3B8);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularFull,
      ),
      child: Text(
        hasPending 
            ? LocaleKeys.dashboardMaintenancePending.tr(args: [pendingCount.toString()])
            : '0',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: const Color(0xFFEDF0F7)),
      ),
      child: Column(
        children: [
          const Icon(Icons.handyman_rounded, size: 32, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.dashboardMaintenanceNoRequests.tr(),
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.dashboardMaintenanceNoRequestsSub.tr(),
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildViewAllButton(context),
        ],
      ),
    );
  }

  Widget _buildRecentList(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recentItems.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (_, index) => OwnerMaintenanceMiniCard(item: recentItems[index]),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
        context.push(Routes.ownerMaintenance);
        },
        style: TextButton.styleFrom(
          foregroundColor: context.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.dashboardMaintenanceViewAll.tr(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
