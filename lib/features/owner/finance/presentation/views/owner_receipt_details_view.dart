import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../generated/locale_keys.dart';
import '../../domain/entities/receipt_entity.dart';
import '../cubit/receipts/finance_receipt_details_cubit.dart';
import '../cubit/receipts/finance_receipt_details_state.dart';

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
        title: const Text('تفاصيل السند', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<FinanceReceiptDetailsCubit, FinanceReceiptDetailsState>(
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
            title: 'البيانات الأساسية',
            children: [
              _buildDetailRow(context, 'رقم السند', receipt.receiptNumber),
              _buildDetailRow(context, 'تاريخ السند', receipt.receiptDate),
              _buildDetailRow(context, 'طريقة الدفع', receipt.paymentMethod.label),
              if (receipt.notes != null && receipt.notes!.isNotEmpty)
                _buildDetailRow(context, 'الملاحظات', receipt.notes!),
            ],
          ),
          const SizedBox(height: 16),
          if (receipt.debitAccount != null || receipt.creditAccount != null)
            _buildInfoCard(
              context,
              title: 'الحسابات المالية',
              children: [
                if (receipt.debitAccount != null)
                  _buildDetailRow(context, 'الحساب المدين', receipt.debitAccount!.nameAr),
                if (receipt.creditAccount != null)
                  _buildDetailRow(context, 'الحساب الدائن', receipt.creditAccount!.nameAr),
              ],
            ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: 'الارتباطات',
            children: [
              _buildDetailRow(context, 'صاحب الحساب', receipt.owner.name),
              if (receipt.propertyId != null)
                _buildDetailRow(context, 'رقم العقار', receipt.propertyId.toString()),
              if (receipt.contractId != null)
                _buildDetailRow(context, 'رقم العقد', receipt.contractId.toString()),
            ],
          ),
          if (receipt.journalEntry != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'القيد اليومي',
              children: [
                _buildDetailRow(context, 'رقم القيد', receipt.journalEntry!.entryNumber),
                _buildDetailRow(context, 'تاريخ القيد', receipt.journalEntry!.entryDate),
                _buildDetailRow(context, 'الحالة', receipt.journalEntry!.status),
                _buildDetailRow(context, 'إجمالي المدين', '${receipt.journalEntry!.totalDebit} ر.س'),
                _buildDetailRow(context, 'إجمالي الدائن', '${receipt.journalEntry!.totalCredit} ر.س'),
              ],
            ),
          ],
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
                    'المبلغ الإجمالي',
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
              '${receipt.amount} ر.س',
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
