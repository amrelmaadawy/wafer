import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/utils/translations/locale_keys.g.dart';
import 'cubit/warehouses/owner_warehouses_cubit.dart';
import 'cubit/warehouses/owner_warehouses_state.dart';
import 'widgets/warehouse_card.dart';
import 'widgets/warehouse_card_shimmer.dart';
import 'widgets/owner_warehouse_create_sheet.dart';
import 'widgets/owner_warehouse_edit_sheet.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/presentation/widgets/app_confirm_dialog.dart';
import '../../../../../core/presentation/widgets/app_loading_overlay.dart';
import 'cubit/delete_warehouse/owner_warehouse_delete_cubit.dart';
import 'cubit/delete_warehouse/owner_warehouse_delete_state.dart';


class OwnerWarehousesListView extends StatelessWidget {
  const OwnerWarehousesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<OwnerWarehousesCubit>()..fetchWarehouses(),
        ),
        BlocProvider(
          create: (context) => sl<OwnerWarehouseDeleteCubit>(),
        ),
      ],
      child: BlocConsumer<OwnerWarehouseDeleteCubit, OwnerWarehouseDeleteState>(
        listener: (context, state) {
          if (state is OwnerWarehouseDeleteSuccess) {
            AppToast.showSuccess(context, LocaleKeys.warehouse_delete_success.tr());
            context.read<OwnerWarehousesCubit>().fetchWarehouses();
          } else if (state is OwnerWarehouseDeleteError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, deleteState) {
          return AppLoadingOverlay(
            isLoading: deleteState is OwnerWarehouseDeleteLoading,
            child: Scaffold(
            backgroundColor: context.appBackgroundColor,
            appBar: CustomAppBar(
              title: LocaleKeys.warehouse_warehouses_list_title.tr(),
              showBackButton: false,
              showMenuButton: true,
            ),
            body: const _OwnerWarehousesListBody(),

            floatingActionButton: FloatingActionButton(
              heroTag: null,
              backgroundColor: context.primaryColor,
              elevation: 4,
              onPressed: () {
                OwnerWarehouseCreateSheet.show(
                  context,
                  onSuccess: () {
                    context.read<OwnerWarehousesCubit>().fetchWarehouses();
                  },
                );
              },
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
          ),
          );
        },
      ),
    );
  }
}

class _OwnerWarehousesListBody extends StatelessWidget {
  const _OwnerWarehousesListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerWarehousesCubit, OwnerWarehousesState>(
      builder: (context, state) {
        if (state is OwnerWarehousesLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => const WarehouseCardShimmer(),
          );
        } else if (state is OwnerWarehousesError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<OwnerWarehousesCubit>().fetchWarehouses();
            },
          );
        } else if (state is OwnerWarehousesLoaded) {
          final warehouses = state.response.warehouses;
          if (warehouses.isEmpty) {
            return CustomEmptyWidget(
              title: LocaleKeys.warehouse_no_warehouses_found.tr(),
              subtitle: LocaleKeys.warehouse_no_warehouses_found_sub.tr(),
              icon: Icons.inventory_2_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<OwnerWarehousesCubit>().fetchWarehouses();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: warehouses.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final warehouse = warehouses[index];
                return WarehouseCard(
                  warehouse: warehouse,
                  onTap: () {
                    context.push(Routes.ownerWarehouseDetails, extra: warehouse.id);
                  },
                  onEdit: () {
                    OwnerWarehouseEditSheet.show(
                      context,
                      warehouse: warehouse,
                      onSuccess: () {
                        context.read<OwnerWarehousesCubit>().fetchWarehouses();
                      },
                    );
                  },
                  onDelete: () async {
                    final confirm = await AppConfirmDialog.show(
                      context: context,
                      titleKey: LocaleKeys.warehouse_delete_title,
                      messageKey: LocaleKeys.warehouse_delete_message,
                      isDangerous: true,
                    );
                    if (confirm == true && context.mounted) {
                      context.read<OwnerWarehouseDeleteCubit>().deleteWarehouse(warehouse.id);
                    }
                  },
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
