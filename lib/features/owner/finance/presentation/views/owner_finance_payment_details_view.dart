import 'package:flutter/material.dart';
import 'package:wafer/core/theme/color_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_status_extension.dart';
import '../cubit/payments/finance_payment_details_cubit.dart';
import '../cubit/payments/finance_payment_details_state.dart';
import '../cubit/payments/cancel_finance_payment_cubit.dart';
import '../cubit/payments/cancel_finance_payment_state.dart';
import '../widgets/cancel_payment_dialog.dart';

class OwnerFinancePaymentDetailsView extends StatefulWidget {
  final int paymentId;

  const OwnerFinancePaymentDetailsView({super.key, required this.paymentId});

  @override
  State<OwnerFinancePaymentDetailsView> createState() => _OwnerFinancePaymentDetailsViewState();
}

class _OwnerFinancePaymentDetailsViewState extends State<OwnerFinancePaymentDetailsView> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<FinancePaymentDetailsCubit>().fetchPaymentDetails(widget.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: Text(
          LocaleKeys.ownerFinancePaymentDetailsTitle.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<FinancePaymentDetailsCubit, FinancePaymentDetailsState>(
            builder: (context, state) {
              if (state is FinancePaymentDetailsSuccess && state.payment.canEdit) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.push(
                        Routes.ownerFinancePaymentUpdate,
                        extra: {
                          'payment': state.payment,
                        },
                      ).then((_) {
                        _fetchDetails(); // Refresh after edit
                      });
                    },
                    icon: Icon(Icons.edit_rounded, color: context.primaryColor, size: 20),
                    tooltip: LocaleKeys.ownerFinanceUpdatePayment.tr(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<FinancePaymentDetailsCubit, FinancePaymentDetailsState>(
        builder: (context, state) {
          if (state is FinancePaymentDetailsLoading) {
            return _buildLoading();
          } else if (state is FinancePaymentDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _fetchDetails,
            );
          } else if (state is FinancePaymentDetailsSuccess) {
            return BlocListener<CancelFinancePaymentCubit, CancelFinancePaymentState>(
              listener: (context, cancelState) {
                if (cancelState is CancelFinancePaymentLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                } else if (cancelState is CancelFinancePaymentSuccess) {
                  Navigator.of(context, rootNavigator: true).pop(); // Close loading
                  AppToast.showSuccess(context, LocaleKeys.ownerFinanceCancelPaymentSuccess.tr());
                  _fetchDetails(); // Refresh details
                } else if (cancelState is CancelFinancePaymentError) {
                  Navigator.of(context, rootNavigator: true).pop(); // Close loading
                  AppToast.showError(context, cancelState.message);
                }
              },
              child: _buildDetails(context, state.payment),
            );
          }
          return const SizedBox.shrink();
        },
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

  Widget _buildDetails(BuildContext context, PaymentEntity payment) {
    return RefreshIndicator(
      onRefresh: () async => _fetchDetails(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeader(context, payment),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: LocaleKeys.ownerFinanceBasicInfo.tr(),
            children: [
              _buildDetailRow(context, LocaleKeys.ownerFinancePaymentNumber.tr(), payment.paymentNumber),
              _buildDetailRow(context, LocaleKeys.ownerFinancePaymentDate.tr(), payment.paymentDate),
              _buildDetailRow(context, LocaleKeys.ownerFinancePaymentMethod.tr(), payment.paymentMethod.label),
              if (payment.notes != null && payment.notes!.isNotEmpty)
                _buildDetailRow(context, LocaleKeys.ownerFinanceNotes.tr(), payment.notes!),
            ],
          ),
          const SizedBox(height: 16),
          if (payment.debitAccount != null || payment.creditAccount != null)
            _buildInfoCard(
              context,
              title: LocaleKeys.ownerFinanceAccountsTitle.tr(),
              children: [
                if (payment.debitAccount != null)
                  _buildDetailRow(context, LocaleKeys.ownerFinanceDebitAccount.tr(), payment.debitAccount!.nameAr),
                if (payment.creditAccount != null)
                  _buildDetailRow(context, LocaleKeys.ownerFinanceCreditAccount.tr(), payment.creditAccount!.nameAr),
              ],
            ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: LocaleKeys.ownerFinanceRelations.tr(),
            children: [
              _buildDetailRow(context, LocaleKeys.ownerFinancePayee.tr(), payment.payee.name),
              if (payment.propertyId != null)
                _buildDetailRow(context, LocaleKeys.ownerFinancePropertyId.tr(), payment.propertyId.toString()),
              if (payment.contractId != null)
                _buildDetailRow(context, LocaleKeys.ownerFinanceContractId.tr(), payment.contractId.toString()),
            ],
          ),
          if (payment.journalEntry != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: LocaleKeys.ownerFinanceJournalEntry.tr(),
              children: [
                _buildDetailRow(context, LocaleKeys.ownerFinanceJournalEntryNumber.tr(), payment.journalEntry!.entryNumber),
                _buildDetailRow(context, LocaleKeys.ownerFinanceJournalEntryDate.tr(), payment.journalEntry!.entryDate),
                _buildDetailRow(context, LocaleKeys.ownerFinanceJournalEntryStatus.tr(), payment.journalEntry!.status),
                _buildDetailRow(context, LocaleKeys.ownerFinanceTotalDebit.tr(), '${payment.journalEntry!.totalDebit} ${LocaleKeys.owner_finance_currency_sar.tr()}'),
                _buildDetailRow(context, LocaleKeys.ownerFinanceTotalCredit.tr(), '${payment.journalEntry!.totalCredit} ${LocaleKeys.owner_finance_currency_sar.tr()}'),
              ],
            ),
          ],
          if (payment.canCancel) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) => CancelPaymentDialog(
                      onConfirm: (reason) {
                        context.read<CancelFinancePaymentCubit>().cancelPayment(payment.id, reason);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                label: Text(
                  LocaleKeys.ownerFinanceCancelPayment.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.circularLg,
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PaymentEntity payment) {
    Color statusColor;
    if (payment.isPaid || payment.status == 'confirmed') {
      statusColor = AppColors.success;
    } else if (payment.isPending || payment.isDraft) {
      statusColor = AppColors.warning;
    } else {
      statusColor = AppColors.error;
    }
    final statusText = payment.status;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppRadius.circularXl,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimaryLight.withValues(alpha: 0.02),
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
              Row(
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
                  Text(
                    LocaleKeys.ownerFinanceTotalAmount.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
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
              '${payment.amount} ${LocaleKeys.owner_finance_currency_sar.tr()}',
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: AppRadius.circularSm,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
                height: 1.3,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

