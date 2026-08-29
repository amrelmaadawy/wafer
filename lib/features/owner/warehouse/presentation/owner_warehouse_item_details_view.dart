import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../core/utils/widgets/app_toast.dart';
import '../../../../core/theme/app_radius.dart';
import 'cubit/delete_item/delete_owner_warehouse_item_cubit.dart';
import 'cubit/delete_item/delete_owner_warehouse_item_state.dart';


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
import 'widgets/owner_warehouse_item_edit_sheet.dart';
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
    return BlocProvider(
      create: (context) => sl<DeleteOwnerWarehouseItemCubit>(),
      child: BlocListener<DeleteOwnerWarehouseItemCubit, DeleteOwnerWarehouseItemState>(
        listener: (context, state) {
          if (state is DeleteOwnerWarehouseItemSuccess) {
            AppToast.showSuccess(
              context,
              LocaleKeys.warehouse_item_deleted_success.tr(),
            );
            context.pop();
          } else if (state is DeleteOwnerWarehouseItemError) {
            AppToast.showError(
              context,
              state.message,
            );
          }
        },
        child: Scaffold(
          backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.warehouse_item_details_title.tr(),
        showBackButton: true,
        actions: [
          BlocBuilder<OwnerWarehouseItemDetailsCubit,
              OwnerWarehouseItemDetailsState>(
            builder: (context, state) {
              if (state is OwnerWarehouseItemDetailsLoaded) {
                return Row(
                  children: [
                    _buildActionButton(
                      context: context,
                      icon: Icons.delete_outline_rounded,
                      color: AppColors.error,
                      onPressed: () async {
                        final confirm = await AppConfirmDialog.show(
                          context: context,
                          titleKey: LocaleKeys.warehouse_delete_item_title,
                          messageKey: LocaleKeys.warehouse_delete_item_message,
                        );
                        if (confirm == true && context.mounted) {
                          context
                              .read<DeleteOwnerWarehouseItemCubit>()
                              .deleteItem(widget.itemId);
                        }
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _buildActionButton(
                      context: context,
                      icon: Icons.edit_rounded,
                      color: context.primaryColor,
                      onPressed: () {
                        OwnerWarehouseItemEditSheet.show(
                          context,
                          item: state.details,
                          onSuccess: () {
                            context
                                .read<OwnerWarehouseItemDetailsCubit>()
                                .fetchItemDetails(widget.itemId);
                          },
                        );
                      },
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
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
      ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WarehouseItemDetailsEntity details) {
    return RefreshIndicator(
      color: context.primaryColor,
      backgroundColor: context.appSurfaceColor,
      onRefresh: () => context
          .read<OwnerWarehouseItemDetailsCubit>()
          .fetchItemDetails(widget.itemId),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroHeader(context, details),
            const SizedBox(height: AppSpacing.lg),
            _buildMetricsGrid(context, details),
            const SizedBox(height: AppSpacing.xl),
            _buildPricingSection(context, details.pricing),
            const SizedBox(height: AppSpacing.xl),
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
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, WarehouseItemDetailsEntity details) {
    final bool isLowStock = details.status == 'low' || details.status == 'out_of_stock';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.inventory_2_rounded,
            size: 36,
            color: context.primaryColor,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      details.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AppStatusBadge(
                    labelKey: details.statusLabel,
                    color: isLowStock ? AppColors.error : AppColors.success,
                    translateText: false,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                details.category,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (details.sku != null)
                Row(
                  children: [
                    Icon(
                      Icons.tag_rounded,
                      size: 14,
                      color: context.appOnSurfaceColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      details.sku!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.appOnSurfaceColor.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context, WarehouseItemDetailsEntity details) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: LocaleKeys.warehouse_item_quantity.tr(),
            value: details.quantityAvailable.toString(),
            icon: Icons.layers_rounded,
            iconColor: context.primaryColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricCard(
            title: LocaleKeys.warehouse_item_min_quantity.tr(),
            value: details.quantityMinLimit.toString(),
            icon: Icons.warning_rounded,
            iconColor: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(BuildContext context, WarehouseItemPricingEntity pricing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: LocaleKeys.warehouse_item_pricing.tr(),
          icon: Icons.monetization_on_rounded,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _PricingRow(
                title: LocaleKeys.warehouse_item_unit_price.tr(),
                value: '${pricing.unitPrice} ${LocaleKeys.warehouse_currency.tr()}',
                icon: Icons.storefront_rounded,
              ),
              const _DashedDivider(),
              _PricingRow(
                title: LocaleKeys.warehouse_item_selling_price.tr(),
                value: '${pricing.sellingPrice} ${LocaleKeys.warehouse_currency.tr()}',
                icon: Icons.sell_rounded,
              ),
              if (pricing.discountAmount > 0) ...[
                const _DashedDivider(),
                _PricingRow(
                  title: LocaleKeys.warehouse_item_discount_amount.tr(),
                  value: '- ${pricing.discountAmount} ${LocaleKeys.warehouse_currency.tr()}',
                  icon: Icons.money_off_rounded,
                  valueColor: AppColors.error,
                ),
              ],
              const _DashedDivider(),
              _PricingRow(
                title: LocaleKeys.warehouse_item_tax_amount.tr(),
                value: '+ ${pricing.taxAmount} ${LocaleKeys.warehouse_currency.tr()}',
                icon: Icons.account_balance_rounded,
                valueColor: context.appOnSurfaceColor.withValues(alpha: 0.6),
                subtitle: '(${pricing.taxPercentage}%)',
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.warehouse_item_final_selling_price.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.primaryColor,
                          ),
                    ),
                    Text(
                      '${pricing.finalSellingPrice} ${LocaleKeys.warehouse_currency.tr()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: context.primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appOnSurfaceColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final String? subtitle;

  const _PricingRow({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: context.appOnSurfaceColor.withValues(alpha: 0.4),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appOnSurfaceColor.withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? context.appOnSurfaceColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 4.0;
          const dashHeight = 1.0;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appOnSurfaceColor.withValues(alpha: 0.1),
                  ),
                ),
              );
            }),
          );
        },
      ),
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
          Row(
            children: [
              AppShimmer.box(height: 72, width: 72),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(height: 24, width: 200),
                    const SizedBox(height: 8),
                    AppShimmer.box(height: 16, width: 120),
                    const SizedBox(height: 8),
                    AppShimmer.box(height: 14, width: 100),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: AppShimmer.box(height: 100, width: double.infinity)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: AppShimmer.box(height: 100, width: double.infinity)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppShimmer.box(height: 24, width: 150),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 200, width: double.infinity),
          const SizedBox(height: AppSpacing.xl),
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
