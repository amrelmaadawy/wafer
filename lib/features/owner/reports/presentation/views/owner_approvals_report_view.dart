import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../cubit/owner_approvals_report_cubit.dart';
import '../cubit/owner_approvals_report_state.dart';
import '../widgets/report_export_button.dart';
import '../widgets/report_empty_widget.dart';
import '../../../../../core/utils/widgets/app_toast.dart';

class OwnerApprovalsReportView extends StatefulWidget {
  const OwnerApprovalsReportView({super.key});

  @override
  State<OwnerApprovalsReportView> createState() => _OwnerApprovalsReportViewState();
}

class _OwnerApprovalsReportViewState extends State<OwnerApprovalsReportView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OwnerApprovalsReportCubit>().fetchReport(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerApprovalsReportCubit>().fetchReport();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<OwnerApprovalsReportCubit>().fetchReport(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.ownerReportsApprovals.tr(),
        actions: [
          BlocBuilder<OwnerApprovalsReportCubit, OwnerApprovalsReportState>(
            builder: (context, state) {
              if (state is OwnerApprovalsReportLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    AppToast.showError(context, "PDF Export will be implemented using PdfBuilder");
                  },
                  onExcelPressed: () async {
                    AppToast.showError(context, "Excel Export will be implemented using ExcelBuilder");
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OwnerApprovalsReportCubit, OwnerApprovalsReportState>(
        builder: (context, state) {
          if (state is OwnerApprovalsReportInitial || (state is OwnerApprovalsReportLoading && state.isFirstFetch)) {
            return const _ApprovalsReportSkeleton();
          }

          if (state is OwnerApprovalsReportError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _onRefresh,
            );
          }

          if (state is OwnerApprovalsReportEmpty) {
            return ReportEmptyWidget(
              message: 'No approvals found',
              icon: Icons.checklist_rtl,
            );
          }

          if (state is OwnerApprovalsReportLoaded || (state is OwnerApprovalsReportLoading && !state.isFirstFetch)) {
            final report = (state is OwnerApprovalsReportLoaded)
                ? state.report
                : (context.read<OwnerApprovalsReportCubit>().state as dynamic).report;
            
            final reportData = (context.read<OwnerApprovalsReportCubit>().state as dynamic).report ?? report;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: context.primaryColor,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildSummaryCards(reportData.summary),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= reportData.items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(color: AppColors.primaryLight),
                              ),
                            );
                          }
                          final item = reportData.items[index];
                          return _ApprovalItemCard(item: item);
                        },
                        childCount: state is OwnerApprovalsReportLoading
                            ? reportData.items.length + 1
                            : reportData.items.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSummaryCards(dynamic summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ApprovalsSummaryCard(
                title: LocaleKeys.ownerReportsTotalApprovals.tr(),
                value: summary.total.toString(),
                icon: Icons.list_alt,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ApprovalsSummaryCard(
                title: LocaleKeys.ownerReportsApproved.tr(),
                value: summary.approved.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ApprovalsSummaryCard(
                title: LocaleKeys.ownerReportsPending.tr(),
                value: summary.pending.toString(),
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ApprovalsSummaryCard(
                title: LocaleKeys.ownerReportsRejected.tr(),
                value: summary.rejected.toString(),
                icon: Icons.cancel,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ApprovalsSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ApprovalsSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _ApprovalsReportSkeleton extends StatelessWidget {
  const _ApprovalsReportSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonBox(100)),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonBox(100)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSkeletonBox(100)),
            const SizedBox(width: 16),
            Expanded(child: _buildSkeletonBox(100)),
          ],
        ),
        const SizedBox(height: 24),
        ...List.generate(5, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSkeletonBox(80),
        )),
      ],
    );
  }

  Widget _buildSkeletonBox(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _ApprovalItemCard extends StatelessWidget {
  final dynamic item; // ApprovalItemEntity

  const _ApprovalItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(item.status);
    final statusLabel = item.statusLabel ?? item.status;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 18, color: context.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title != null && item.title!.isNotEmpty ? item.title! : (item.typeLabel ?? item.typeValue ?? 'Unknown'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Body: Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.account_tree_outlined, item.typeLabel ?? 'Unknown'),
                      const SizedBox(height: 8),
                      if (item.userName != null) ...[
                        _buildInfoRow(Icons.person_outline, item.userName!),
                        const SizedBox(height: 8),
                      ],
                      if (item.date != null)
                        _buildInfoRow(Icons.calendar_today_outlined, item.date!),
                    ],
                  ),
                ),
                if (item.amount != null && item.amount!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        LocaleKeys.reports_totalRentValue.tr(), // Using this as a fallback for 'Amount' or just 'القيمة'
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item.amount} ${LocaleKeys.contractsCurrency.tr()}',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'pending_approval':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
