import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../owner/maintenance/domain/entities/maintenance_item_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_maintenance_mini_card.dart';

class OwnerMaintenanceHubSection extends StatelessWidget {
  final int pendingCount;
  final List<MaintenanceItemEntity> recentItems;
  final MaintenanceBreakdownEntity? breakdown;

  const OwnerMaintenanceHubSection({
    super.key,
    required this.pendingCount,
    required this.recentItems,
    this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXxl,
        border: Border.all(color: AppColors.borderLight),
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
          if (breakdown != null) ...[
            const SizedBox(height: 16),
            _buildBreakdownRow(),
          ],
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
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularMd,
          ),
          child: const Icon(
            Icons.build_circle_outlined,
            color: AppColors.accent,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          LocaleKeys.dashboardMaintenanceHub.tr(),
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
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
    final color = hasPending ? AppColors.error : AppColors.textTertiaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularFull,
      ),
      child: Text(
        hasPending
            ? LocaleKeys.dashboardMaintenancePending.tr(
                args: [pendingCount.toString()],
              )
            : LocaleKeys.dashboardMaintenanceNoRequests.tr(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBreakdownRow() {
    return Row(
      children: [
        Expanded(
          child: _buildBreakdownItem(
            LocaleKeys.dashboard_maint_new.tr(),
            breakdown!.newRequests,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBreakdownItem(
            LocaleKeys.dashboard_maint_in_progress.tr(),
            breakdown!.inProgress,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBreakdownItem(
            LocaleKeys.dashboard_maint_urgent.tr(),
            breakdown!.urgent,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: AppRadius.circularMd,
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasPending = pendingCount > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtleLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(
            hasPending ? Icons.build_circle_outlined : Icons.handyman_rounded,
            size: 32,
            color: hasPending ? context.primaryColor : AppColors.textTertiaryLight,
          ),
          const SizedBox(height: 12),
          Text(
            hasPending
                ? LocaleKeys.dashboardMaintenancePending.tr(
                    args: [pendingCount.toString()],
                  )
                : LocaleKeys.dashboardMaintenanceNoRequests.tr(),
            style: const TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasPending
                ? LocaleKeys.maintenanceRequestsList.tr()
                : LocaleKeys.dashboardMaintenanceNoRequestsSub.tr(),
            style: const TextStyle(color: AppColors.textTertiaryLight, fontSize: 11.5),
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
        itemBuilder: (_, index) =>
            OwnerMaintenanceMiniCard(item: recentItems[index]),
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

