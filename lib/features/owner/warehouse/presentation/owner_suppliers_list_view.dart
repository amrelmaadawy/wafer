import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/theme/color_utils.dart';
import '../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../core/utils/translations/locale_keys.g.dart';
import 'cubit/suppliers/owner_suppliers_cubit.dart';
import 'cubit/suppliers/owner_suppliers_state.dart';
import 'widgets/suppliers/supplier_card.dart';
import 'widgets/suppliers/supplier_card_shimmer.dart';

class OwnerSuppliersListView extends StatefulWidget {
  const OwnerSuppliersListView({super.key});

  @override
  State<OwnerSuppliersListView> createState() => _OwnerSuppliersListViewState();
}

class _OwnerSuppliersListViewState extends State<OwnerSuppliersListView> {
  final ScrollController _scrollController = ScrollController();
  late OwnerSuppliersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OwnerSuppliersCubit>()..fetchSuppliers();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchSuppliers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: CustomAppBar(
          title: LocaleKeys.warehouse_suppliers_title.tr(),
          showBackButton: false,
          showMenuButton: true,
        ),
                floatingActionButton: FloatingActionButton(
          backgroundColor: context.primaryColor,
          onPressed: () async {
            final result = await context.push(Routes.ownerWarehouseSupplierCreate);
            if (result == true && context.mounted) {
              _cubit.fetchSuppliers(isRefresh: true);
            }
          },
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
        body: const _OwnerSuppliersListBody(),
      ),
    );
  }
}

class _OwnerSuppliersListBody extends StatelessWidget {
  const _OwnerSuppliersListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerSuppliersCubit, OwnerSuppliersState>(
      builder: (context, state) {
        if (state is OwnerSuppliersLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => const SupplierCardShimmer(),
          );
        } else if (state is OwnerSuppliersError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<OwnerSuppliersCubit>().fetchSuppliers(isRefresh: true);
            },
          );
        } else if (state is OwnerSuppliersLoaded || state is OwnerSuppliersPaginationLoading) {
          final suppliers = state is OwnerSuppliersLoaded 
              ? state.suppliers 
              : (state as OwnerSuppliersPaginationLoading).oldSuppliers;
              
          if (suppliers.isEmpty) {
            return CustomEmptyWidget(
              title: LocaleKeys.warehouse_no_suppliers_found.tr(),
              subtitle: LocaleKeys.warehouse_no_suppliers_found_sub.tr(),
              icon: Icons.local_shipping_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<OwnerSuppliersCubit>().fetchSuppliers(isRefresh: true);
            },
            child: ListView.separated(
              controller: context.findAncestorStateOfType<_OwnerSuppliersListViewState>()?._scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: suppliers.length + (state is OwnerSuppliersPaginationLoading ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index >= suppliers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final supplier = suppliers[index];
                                return SupplierCard(
                  supplier: supplier,
                  onTap: () async {
                  final result = await context.push('/owner/warehouse/suppliers/${supplier.id}');
                  if (result == true && context.mounted) {
                    context.read<OwnerSuppliersCubit>().fetchSuppliers(isRefresh: true);
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
