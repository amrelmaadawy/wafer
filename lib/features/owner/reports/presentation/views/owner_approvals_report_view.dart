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
                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                                child: Icon(Icons.check_circle_outline, color: context.primaryColor),
                              ),
                              title: Text(item.typeLabel ?? item.typeValue ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.userName != null) Text(item.userName!),
                                  if (item.date != null) Text(item.date!),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(item.amount ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: context.primaryColor)),
                                  Text(item.status, style: TextStyle(color: _getStatusColor(item.status), fontSize: 12)),
                                ],
                              ),
                            ),
                          );
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
