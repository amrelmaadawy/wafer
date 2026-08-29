import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/color_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/translations/locale_keys.g.dart';
import '../domain/entities/warehouse_entity.dart';
import 'cubit/owner_warehouse_details_cubit.dart';
import 'cubit/owner_warehouse_details_state.dart';
import 'widgets/warehouse_card_shimmer.dart';

class OwnerWarehouseDetailsView extends StatelessWidget {
  final int warehouseId;

  const OwnerWarehouseDetailsView({
    super.key,
    required this.warehouseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OwnerWarehouseDetailsCubit>()..fetchWarehouseDetails(warehouseId),
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: CustomAppBar(
          title: LocaleKeys.warehouse_details_title.tr(),
          showBackButton: true,
        ),
        body: BlocBuilder<OwnerWarehouseDetailsCubit, OwnerWarehouseDetailsState>(
          builder: (context, state) {
            if (state is OwnerWarehouseDetailsLoading) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: const [
                  WarehouseCardShimmer(),
                  SizedBox(height: AppSpacing.md),
                  WarehouseCardShimmer(),
                ],
              );
            }

            if (state is OwnerWarehouseDetailsError) {
              return Center(
                child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<OwnerWarehouseDetailsCubit>().fetchWarehouseDetails(warehouseId),
                ),
              );
            }

            if (state is OwnerWarehouseDetailsLoaded) {
              return _buildContent(context, state.warehouse);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseEntity warehouse) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _buildBasicInfoCard(context, warehouse),
        const SizedBox(height: AppSpacing.md),
        _buildStatisticsCard(context, warehouse),
      ],
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, WarehouseEntity warehouse) {
    return AppSurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline_rounded, color: context.primaryColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  LocaleKeys.warehouse_basic_info.tr(),
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                AppStatusBadge(
                  color: warehouse.isActive ? AppColors.success : AppColors.error,
                  labelKey: warehouse.statusLabel,
                  translateText: false,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            _buildDetailRow(
              context, 
              LocaleKeys.warehouse_name_label.tr(), 
              warehouse.name,
              isBold: true,
              icon: Icons.storefront_rounded,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(
              context, 
              LocaleKeys.warehouse_code_label.tr(), 
              warehouse.code,
              icon: Icons.qr_code_rounded,
            ),
            
            if (warehouse.parent != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildDetailRow(
                context, 
                LocaleKeys.warehouse_parent.tr(), 
                '${warehouse.parent!.name} (${warehouse.parent!.code})',
                icon: Icons.account_tree_rounded,
              ),
            ],

            if (warehouse.notes != null && warehouse.notes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.notes_rounded, size: 18, color: context.appSecondaryTextColor),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.warehouse_notes.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(color: context.appSecondaryTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.appSubtleSurfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: context.appBorderColor),
                ),
                child: Text(
                  warehouse.notes!,
                  style: AppTextStyles.bodyMedium.copyWith(color: context.appOnSurfaceColor, height: 1.5),
                ),
              ),
            ],
            
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.appSubtleSurfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                children: [
                  _buildDateRow(context, LocaleKeys.warehouse_created_at.tr(), warehouse.createdAt),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1, color: context.appBorderColor.withValues(alpha: 0.5)),
                  ),
                  _buildDateRow(context, LocaleKeys.warehouse_updated_at.tr(), warehouse.updatedAt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context, WarehouseEntity warehouse) {
    return AppSurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.analytics_rounded, color: context.primaryColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  LocaleKeys.warehouse_statistics.tr(),
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatBlock(
                    context,
                    icon: Icons.category_rounded,
                    label: LocaleKeys.warehouse_warehouse_items_count.tr(),
                    value: warehouse.itemsCount.toString(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatBlock(
                    context,
                    icon: Icons.swap_horiz_rounded,
                    label: LocaleKeys.warehouse_warehouse_movements_count.tr(),
                    value: warehouse.movementsCount.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBlock(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.05),
            context.primaryColor.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.appSurfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: context.primaryColor, size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTextStyles.h1.copyWith(fontWeight: FontWeight.w900, color: context.primaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(color: context.appSecondaryTextColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isBold = false, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: context.appBackgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.appSecondaryTextColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(color: context.appSecondaryTextColor),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: context.appOnSurfaceColor,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: context.appSecondaryTextColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: context.appSecondaryTextColor),
            ),
          ],
        ),
        Text(
          date,
          style: AppTextStyles.bodyMedium.copyWith(color: context.appOnSurfaceColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
