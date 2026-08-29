import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:wafer/core/di/service_locator.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/presentation/widgets/app_status_badge.dart';
import 'package:wafer/core/presentation/widgets/custom_app_bar.dart';
import 'package:wafer/core/presentation/widgets/custom_error_widget.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_fonts.dart';
import 'package:wafer/core/theme/app_radius.dart';
import 'package:wafer/core/theme/app_spacing.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:wafer/core/theme/theme_context.dart';
import '../../domain/entities/suppliers/supplier_entity.dart';
import '../cubit/suppliers/details/owner_supplier_details_cubit.dart';
import '../cubit/suppliers/details/owner_supplier_details_state.dart';
import '../cubit/suppliers/delete/owner_supplier_delete_cubit.dart';
import '../cubit/suppliers/delete/owner_supplier_delete_state.dart';
import 'package:wafer/core/presentation/widgets/app_confirm_dialog.dart';
import 'package:wafer/core/presentation/widgets/app_loading_overlay.dart';
import 'package:wafer/core/utils/widgets/app_toast.dart';

class OwnerSupplierDetailsView extends StatelessWidget {
  final int supplierId;

  const OwnerSupplierDetailsView({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<OwnerSupplierDetailsCubit>()..fetchSupplierDetails(supplierId),
        ),
        BlocProvider(
          create: (_) => sl<OwnerSupplierDeleteCubit>(),
        ),
      ],
      child: const _OwnerSupplierDetailsContent(),
    );
  }
}

class _OwnerSupplierDetailsContent extends StatelessWidget {
  const _OwnerSupplierDetailsContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OwnerSupplierDeleteCubit, OwnerSupplierDeleteState>(
      listener: (context, state) {
        if (state is OwnerSupplierDeleteSuccess) {
          AppToast.showSuccess(context, LocaleKeys.supplier_delete_success.tr());
          context.pop(true);
        } else if (state is OwnerSupplierDeleteError) {
          AppToast.showError(context, state.message);
        }
      },
      child: BlocBuilder<OwnerSupplierDeleteCubit, OwnerSupplierDeleteState>(
        builder: (context, deleteState) {
          return AppLoadingOverlay(
            isLoading: deleteState is OwnerSupplierDeleteLoading,
            child: Scaffold(
              backgroundColor: context.appBackgroundColor,
              appBar: CustomAppBar(
                title: LocaleKeys.supplier_details_title.tr(),
                showBackButton: true,
                actions: [
                  BlocBuilder<OwnerSupplierDetailsCubit, OwnerSupplierDetailsState>(
                    builder: (context, state) {
                      if (state is OwnerSupplierDetailsSuccess) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                final supplierId = context.findAncestorWidgetOfExactType<OwnerSupplierDetailsView>()!.supplierId;
                                AppConfirmDialog.show(
                                  context: context,
                                  titleKey: LocaleKeys.supplier_delete_confirm_title.tr(),
                                  messageKey: LocaleKeys.supplier_delete_confirm_msg.tr(),
                                  isDangerous: true,
                                ).then((confirmed) {
                                  if (confirmed == true && context.mounted) {
                                    context.read<OwnerSupplierDeleteCubit>().deleteSupplier(supplierId);
                                  }
                                });
                              },
                              icon: const Icon(Icons.delete_outline_rounded),
                              color: Theme.of(context).colorScheme.error,
                            ),
                              IconButton(
                                onPressed: () async {
                                  final supplierId = context.findAncestorWidgetOfExactType<OwnerSupplierDetailsView>()!.supplierId;
                                  final result = await context.push('/owner/warehouse/suppliers/$supplierId/update', extra: state.supplier);
                                  if (result == true) {
                                    if (context.mounted) {
                                      context.read<OwnerSupplierDetailsCubit>().fetchSupplierDetails(supplierId);
                                    }
                                  }
                                },
                              icon: const Icon(Icons.edit_rounded),
                              color: context.primaryColor,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              body: BlocBuilder<OwnerSupplierDetailsCubit, OwnerSupplierDetailsState>(
                builder: (context, state) {
                  if (state is OwnerSupplierDetailsLoading || state is OwnerSupplierDetailsInitial) {
                    return const _DetailsShimmer();
                  } else if (state is OwnerSupplierDetailsError) {
                    return CustomErrorWidget(
                      message: state.message,
                      isLoading: false,
                      onRetry: () {
                        context.read<OwnerSupplierDetailsCubit>().fetchSupplierDetails(
                          context.findAncestorWidgetOfExactType<OwnerSupplierDetailsView>()!.supplierId,
                        );
                      },
                    );
                  } else if (state is OwnerSupplierDetailsSuccess) {
                    return _SupplierDetailsBody(supplier: state.supplier);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailsShimmer extends StatelessWidget {
  const _DetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: context.appSurfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ],
    );
  }
}

class _SupplierDetailsBody extends StatelessWidget {
  final SupplierEntity supplier;

  const _SupplierDetailsBody({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.primaryColor,
      backgroundColor: context.appSurfaceColor,
      onRefresh: () => context.read<OwnerSupplierDetailsCubit>().fetchSupplierDetails(supplier.id),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildHeaderCard(context),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.appBorderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_shipping_rounded, color: context.primaryColor, size: 36),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            supplier.companyName,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
              
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            supplier.supplierCode,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.appSecondaryTextColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppStatusBadge(
            color: supplier.isActive ? AppColors.success : AppColors.error,
            labelKey: supplier.statusLabel,
            translateText: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appSurfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.appBorderColor, width: 1.0),
      ),
      child: Column(
        children: [
          if (supplier.contactPerson != null && supplier.contactPerson!.isNotEmpty)
            _buildListTile(context, Icons.person_rounded, LocaleKeys.supplier_contact_person_label.tr(), supplier.contactPerson!),
          if (supplier.contactPerson != null && supplier.contactPerson!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          if (supplier.phone != null && supplier.phone!.isNotEmpty)
            _buildListTile(context, Icons.phone_android_rounded, LocaleKeys.supplier_phone_label.tr(), supplier.phone!, isLtr: true),
          if (supplier.phone != null && supplier.phone!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          if (supplier.companyPhone != null && supplier.companyPhone!.isNotEmpty)
            _buildListTile(context, Icons.phone_rounded, LocaleKeys.supplier_company_phone_label.tr(), supplier.companyPhone!, isLtr: true),
          if (supplier.companyPhone != null && supplier.companyPhone!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          if (supplier.email != null && supplier.email!.isNotEmpty)
            _buildListTile(context, Icons.email_rounded, LocaleKeys.supplier_email_label.tr(), supplier.email!, isLtr: true),
          if (supplier.email != null && supplier.email!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          if (supplier.taxNumber != null && supplier.taxNumber!.isNotEmpty)
            _buildListTile(context, Icons.receipt_long_rounded, LocaleKeys.supplier_tax_number_label.tr(), supplier.taxNumber!),
          if (supplier.taxNumber != null && supplier.taxNumber!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          if (supplier.address != null && supplier.address!.isNotEmpty)
            _buildListTile(context, Icons.location_on_rounded, LocaleKeys.supplier_address_label.tr(), supplier.address!),
          if (supplier.address != null && supplier.address!.isNotEmpty)
            Divider(height: 1, color: context.appBorderColor),
            
          _buildListTile(context, Icons.sync_alt_rounded, LocaleKeys.supplier_movements_count.tr(), supplier.movementsCount.toString()),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String value, {bool isLtr = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.appSecondaryTextColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.appSecondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    
                  ),
                  textDirection: isLtr ? ui.TextDirection.ltr : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
