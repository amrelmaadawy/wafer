import 'package:flutter/material.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/routing/routes.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/receipt_entity.dart';
import '../cubit/receipts/finance_receipt_details_cubit.dart';
import '../cubit/receipts/finance_receipt_details_state.dart';
import '../cubit/receipts/cancel_finance_receipt_cubit.dart';
import '../cubit/receipts/cancel_finance_receipt_state.dart';
import '../cubit/receipts/finance_receipts_cubit.dart';
import '../widgets/cancel_receipt_dialog.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/di/service_locator.dart';

class OwnerReceiptDetailsView extends StatefulWidget {
  final int receiptId;

  const OwnerReceiptDetailsView({super.key, required this.receiptId});

  @override
  State<OwnerReceiptDetailsView> createState() => _OwnerReceiptDetailsViewState();
}

class _OwnerReceiptDetailsViewState extends State<OwnerReceiptDetailsView> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<FinanceReceiptDetailsCubit>().fetchReceiptDetails(widget.receiptId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: Text(LocaleKeys.owner_receipt_details.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<FinanceReceiptDetailsCubit, FinanceReceiptDetailsState>(
            builder: (context, state) {
              if (state is FinanceReceiptDetailsSuccess) {
                if (state.receipt.status.toLowerCase() == 'cancelled') {
                  return const SizedBox.shrink();
                }
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.push(
                        Routes.ownerFinanceReceiptUpdate,
                        extra: {'receipt': state.receipt},
                      ).then((_) {
                        _fetchDetails(); // Refresh after edit
                      });
                    },
                    icon: Icon(Icons.edit_rounded, color: context.primaryColor, size: 20),
                    tooltip: LocaleKeys.owner_receipt_edit.tr(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (_) => sl<CancelFinanceReceiptCubit>(),
        child: BlocConsumer<CancelFinanceReceiptCubit, CancelFinanceReceiptState>(
          listener: (context, cancelState) {
            if (cancelState is CancelFinanceReceiptLoading) {
              AppToast.showInfo(context, LocaleKeys.owner_receipt_canceling.tr());
            } else if (cancelState is CancelFinanceReceiptSuccess) {
              AppToast.showSuccess(context, LocaleKeys.owner_receipt_cancel_success.tr());
              _fetchDetails();
              context.read<FinanceReceiptsCubit>().fetchReceipts(isRefresh: true);
            } else if (cancelState is CancelFinanceReceiptError) {
              AppToast.showError(context, cancelState.message);
            }
          },
          builder: (context, cancelState) {
            return BlocBuilder<FinanceReceiptDetailsCubit, FinanceReceiptDetailsState>(
              builder: (context, state) {
                if (state is FinanceReceiptDetailsLoading) {
                  return _buildLoading();
                } else if (state is FinanceReceiptDetailsError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: _fetchDetails,
                  );
                } else if (state is FinanceReceiptDetailsSuccess) {
                  return _buildDetails(context, state.receipt);
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        AppShimmer.box(width: double.infinity, height: 120, borderRadius: AppRadius.circularXl),
        const SizedBox(height: 16),
        AppShimmer.box(width: double.infinity, height: 200, borderRadius: AppRadius.circularXl),
        const SizedBox(height: 16),
        AppShimmer.box(width: double.infinity, height: 150, borderRadius: AppRadius.circularXl),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, ReceiptEntity receipt) {
    return RefreshIndicator(
      onRefresh: () async => _fetchDetails(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeader(context, receipt),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: LocaleKeys.owner_receipt_basic_info.tr(),
            children: [
              _buildDetailRow(context, LocaleKeys.owner_receipt_number.tr(), receipt.receiptNumber),
              _buildDetailRow(context, LocaleKeys.owner_receipt_date.tr(), receipt.receiptDate),
              _buildDetailRow(context, LocaleKeys.owner_receipt_payment_method.tr(), receipt.paymentMethod.label),
              if (receipt.notes != null && receipt.notes!.isNotEmpty)
                _buildDetailRow(context, LocaleKeys.owner_receipt_notes.tr(), receipt.notes!),
            ],
          ),
          const SizedBox(height: 16),
          if (receipt.debitAccount != null || receipt.creditAccount != null)
            _buildInfoCard(
              context,
              title: LocaleKeys.owner_receipt_financial_accounts.tr(),
              children: [
                if (receipt.debitAccount != null)
                  _buildDetailRow(context, LocaleKeys.owner_receipt_debit_account.tr(), receipt.debitAccount!.nameAr),
                if (receipt.creditAccount != null)
                  _buildDetailRow(context, LocaleKeys.owner_receipt_credit_account.tr(), receipt.creditAccount!.nameAr),
              ],
            ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: LocaleKeys.owner_receipt_connections.tr(),
            children: [
              _buildDetailRow(context, LocaleKeys.owner_receipt_account_owner.tr(), receipt.owner.name),
              if (receipt.propertyId != null)
                _buildDetailRow(context, LocaleKeys.owner_receipt_property_number.tr(), receipt.propertyId.toString()),
              if (receipt.contractId != null)
                _buildDetailRow(context, LocaleKeys.owner_receipt_contract_number.tr(), receipt.contractId.toString()),
            ],
          ),
          if (receipt.journalEntry != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: LocaleKeys.owner_receipt_journal_entry.tr(),
              children: [
                _buildDetailRow(context, LocaleKeys.owner_receipt_entry_number.tr(), receipt.journalEntry!.entryNumber),
                _buildDetailRow(context, LocaleKeys.owner_receipt_entry_date.tr(), receipt.journalEntry!.entryDate),
                _buildDetailRow(context, LocaleKeys.owner_receipt_status.tr(), receipt.journalEntry!.status),
                _buildDetailRow(context, LocaleKeys.owner_receipt_total_debit.tr(), '${receipt.journalEntry!.totalDebit} ${LocaleKeys.owner_finance_currency_sar.tr()}'),
                _buildDetailRow(context, LocaleKeys.owner_receipt_total_credit.tr(), '${receipt.journalEntry!.totalCredit} ${LocaleKeys.owner_finance_currency_sar.tr()}'),
              ],
            ),
          ],
          if (receipt.status != 'cancelled') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => CancelReceiptDialog(
                      onConfirm: (reason) {
                        context.read<CancelFinanceReceiptCubit>().cancelReceipt(receipt.id, reason);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                label: Text(
                  LocaleKeys.owner_receipt_cancel_action.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
                ),
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ReceiptEntity receipt) {
    final isConfirmed = receipt.status == 'confirmed';
    final statusColor = isConfirmed ? AppColors.success : AppColors.error;
    final statusText = isConfirmed ? LocaleKeys.profile_active.tr() : LocaleKeys.profile_inactive.tr();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: context.primaryLight.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circularLg,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: context.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        LocaleKeys.owner_receipt_total_amount.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.circularLg,
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${receipt.amount} ${LocaleKeys.owner_finance_currency_sar.tr()}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.fontFamilyEn,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryLight),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.fontFamilyEn,
                ),
          ),
        ],
      ),
    );
  }
}
