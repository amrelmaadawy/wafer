import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../core/presentation/widgets/app_info_banner.dart';
import '../../../../core/presentation/widgets/app_status_badge.dart';
import '../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/translations/locale_keys.g.dart';
import '../domain/entities/warehouse_item_details_entity.dart';
import 'cubit/details/owner_warehouse_item_details_cubit.dart';
import 'cubit/details/owner_warehouse_item_details_state.dart';
import 'widgets/warehouse_movement_card.dart';

class OwnerWarehouseItemDetailsView extends StatefulWidget {
  final int itemId;

  const OwnerWarehouseItemDetailsView({
    super.key,
    required this.itemId,
  });

  @override
  State<OwnerWarehouseItemDetailsView> createState() =>
      _OwnerWarehouseItemDetailsViewState();
}

class _OwnerWarehouseItemDetailsViewState
    extends State<OwnerWarehouseItemDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerWarehouseItemDetailsCubit>().fetchItemDetails(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.warehouse_item_details_title.tr(),
        showBackButton: true,
      ),
      body: BlocBuilder<OwnerWarehouseItemDetailsCubit,
          OwnerWarehouseItemDetailsState>(
        builder: (context, state) {
          if (state is OwnerWarehouseItemDetailsLoading) {
            return const _ItemDetailsShimmer();
          } else if (state is OwnerWarehouseItemDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<OwnerWarehouseItemDetailsCubit>()
                  .fetchItemDetails(widget.itemId),
            );
          } else if (state is OwnerWarehouseItemDetailsLoaded) {
            return _buildContent(context, state.details);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseItemDetailsEntity details) {
    return RefreshIndicator(
      onRefresh: () => context
          .read<OwnerWarehouseItemDetailsCubit>()
          .fetchItemDetails(widget.itemId),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context, details),
            const SizedBox(height: AppSpacing.md),
            _buildPricingCard(context, details.pricing),
            const SizedBox(height: AppSpacing.lg),
            SectionHeader(
              title: LocaleKeys.warehouse_item_movements.tr(),
              icon: Icons.history_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            if (details.recentMovements.isEmpty)
              AppInfoBanner(
                messageKey: LocaleKeys.warehouse_recent_movements_empty,
                icon: Icons.info_outline_rounded,
                type: AppInfoBannerType.info,
              )
            else
              ...details.recentMovements.map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: WarehouseMovementCard(movement: m),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, WarehouseItemDetailsEntity details) {
    return AppSurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    details.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AppStatusBadge(
                  labelKey: details.statusLabel,
                  color: AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailRow(
                context, LocaleKeys.warehouse_sku.tr(), details.sku ?? '-'),
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(context, LocaleKeys.warehouse_item_category.tr(),
                details.category),
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(context, LocaleKeys.warehouse_item_quantity.tr(),
                details.quantityAvailable.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(
      BuildContext context, WarehouseItemPricingEntity pricing) {
    return AppSurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.warehouse_item_pricing.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    context,
                    LocaleKeys.warehouse_item_unit_price.tr(),
                    '${pricing.unitPrice} ${LocaleKeys.warehouse_currency.tr()}',
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    context,
                    LocaleKeys.warehouse_item_selling_price.tr(),
                    '${pricing.sellingPrice} ${LocaleKeys.warehouse_currency.tr()}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow(
                    context,
                    LocaleKeys.warehouse_item_discount_value.tr(),
                    pricing.discountAmount > 0
                        ? '${pricing.discountAmount} ${LocaleKeys.warehouse_currency.tr()}'
                        : LocaleKeys.warehouse_discount_none.tr(),
                  ),
                ),
                Expanded(
                  child: _buildDetailRow(
                    context,
                    LocaleKeys.warehouse_item_tax_percentage.tr(),
                    '${pricing.taxPercentage}%',
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(),
            ),
            _buildDetailRow(
              context,
              LocaleKeys.warehouse_item_final_selling_price.tr(),
              '${pricing.finalSellingPrice} ${LocaleKeys.warehouse_currency.tr()}',
              valueStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {TextStyle? valueStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.appOnSurfaceColor.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: valueStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ItemDetailsShimmer extends StatelessWidget {
  const _ItemDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.box(height: 120, width: double.infinity),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 160, width: double.infinity),
          const SizedBox(height: AppSpacing.lg),
          AppShimmer.box(height: 24, width: 150),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 80, width: double.infinity),
          const SizedBox(height: AppSpacing.sm),
          AppShimmer.box(height: 80, width: double.infinity),
        ],
      ),
    );
  }
}
