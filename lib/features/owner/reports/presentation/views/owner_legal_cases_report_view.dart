import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/services/excel/builders/legal_cases_excel_builder.dart';
import '../../../../../core/services/excel/excel_export_service.dart';
import '../../../../../core/services/pdf/builders/legal_cases_pdf_builder.dart';
import '../../../../../core/services/pdf/pdf_generator_service.dart';
import '../cubit/legal_cases/owner_legal_cases_report_cubit.dart';
import '../cubit/legal_cases/owner_legal_cases_report_state.dart';
import '../widgets/report_export_button.dart';
import '../widgets/report_empty_widget.dart';
import '../../domain/entities/legal_cases_report_entity.dart';
import '../../../../../core/presentation/widgets/custom_dropdown_menu.dart';

class OwnerLegalCasesReportView extends StatefulWidget {
  const OwnerLegalCasesReportView({super.key});

  @override
  State<OwnerLegalCasesReportView> createState() =>
      _OwnerLegalCasesReportViewState();
}

class _OwnerLegalCasesReportViewState extends State<OwnerLegalCasesReportView> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<OwnerLegalCasesReportCubit>().fetchReport(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OwnerLegalCasesReportCubit>().fetchReport(
        status: _selectedStatus,
      );
    }
  }

  Future<void> _onRefresh() async {
    await context.read<OwnerLegalCasesReportCubit>().fetchReport(
      isRefresh: true,
      status: _selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.reports_legalCases.tr(),
        actions: [
          BlocBuilder<OwnerLegalCasesReportCubit, OwnerLegalCasesReportState>(
            builder: (context, state) {
              if (state is OwnerLegalCasesReportLoaded) {
                return ReportExportButton(
                  onPdfPressed: () async {
                    final pdf = await LegalCasesPdfBuilder.build(
                      state.report.items,
                      state.report.summary,
                    );
                    if (!context.mounted) return;
                    await PdfGeneratorService.exportAndPrint(
                      context: context,
                      pdf: pdf,
                      fileName: 'legal_cases_report.pdf',
                    );
                  },
                  onExcelPressed: () async {
                    final bytes = await LegalCasesExcelBuilder.build(
                      state.report.items,
                      state.report.summary,
                    );
                    if (!context.mounted) return;
                    await ExcelExportService.saveAndShare(
                      context: context,
                      bytes: bytes,
                      fileName: 'legal_cases_report.xlsx',
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OwnerLegalCasesReportCubit, OwnerLegalCasesReportState>(
        builder: (context, state) {
          if (state is OwnerLegalCasesReportInitial ||
              (state is OwnerLegalCasesReportLoading && state.isFirstFetch)) {
            return const _LegalCasesReportSkeleton();
          }

          if (state is OwnerLegalCasesReportError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _onRefresh,
            );
          }

          if (state is OwnerLegalCasesReportEmpty) {
            return Column(
              children: [
                _buildFilterDropdown(
                  (context.read<OwnerLegalCasesReportCubit>().state as dynamic)
                          .report
                          ?.filterOptions
                          .statuses ??
                      [],
                ),
                Expanded(
                  child: ReportEmptyWidget(
                    message: LocaleKeys.reports_noData.tr(),
                    icon: Icons.gavel_rounded,
                  ),
                ),
              ],
            );
          }

          if (state is OwnerLegalCasesReportLoaded ||
              (state is OwnerLegalCasesReportLoading && !state.isFirstFetch)) {
            final report = (state is OwnerLegalCasesReportLoaded)
                ? state.report
                : (context.read<OwnerLegalCasesReportCubit>().state as dynamic)
                      .report;

            final reportData =
                (context.read<OwnerLegalCasesReportCubit>().state as dynamic)
                    .report ??
                report;

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
                        _buildFilterDropdown(
                          reportData.filterOptions.statuses ?? [],
                        ),
                        const SizedBox(height: 16),
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
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            );
                          }
                          final item = reportData.items[index];
                          return _LegalCaseCard(item: item);
                        },
                        childCount: state is OwnerLegalCasesReportLoading
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

  Widget _buildFilterDropdown(List<LegalCasesStatusFilterEntity> statuses) {
    if (statuses.isEmpty) return const SizedBox.shrink();

    // Create a special entity for the "All" option
    final allOption = LegalCasesStatusFilterEntity(
      value: 'all',
      label: LocaleKeys.all.tr(),
    );

    // Combine "All" with the rest of the statuses
    final allStatuses = [allOption, ...statuses];

    // Find the currently selected entity, default to "All" if none selected
    final selectedEntity = _selectedStatus == null
        ? allOption
        : allStatuses.firstWhere(
            (s) => s.value == _selectedStatus,
            orElse: () => allOption,
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomDropdownMenu<LegalCasesStatusFilterEntity>(
        items: allStatuses,
        value: selectedEntity,
        hint: LocaleKeys.reports_status.tr(),
        itemLabelBuilder: (item) => item.label,
        onSelected: (selected) {
          final newStatus = selected.value == 'all' ? null : selected.value;
          if (_selectedStatus != newStatus) {
            setState(() {
              _selectedStatus = newStatus;
            });
            context.read<OwnerLegalCasesReportCubit>().fetchReport(
              isRefresh: true,
              status: newStatus,
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryCards(dynamic summary) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_total.tr(),
            value: summary.total.toString(),
            icon: Icons.gavel_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_active.tr(),
            value: summary.active.toString(),
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: LocaleKeys.reports_resolved.tr(),
            value: summary.resolved.toString(),
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _LegalCaseCard extends StatelessWidget {
  final LegalCaseItemEntity item;

  const _LegalCaseCard({required this.item});

  @override
  Widget build(BuildContext context) {
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.gavel, size: 20, color: context.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.legalCases_caseNumber.tr(),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.caseNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: _getStatusColor(item.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailRow(
                        context,
                        Icons.person_outline,
                        LocaleKeys.legalCases_plaintiff.tr(),
                        item.plaintiff ?? '-',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailRow(
                        context,
                        Icons.person_off_outlined,
                        LocaleKeys.legalCases_defendant.tr(),
                        item.defendant ?? '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  context,
                  Icons.account_balance_outlined,
                  LocaleKeys.legalCases_court.tr(),
                  item.court ?? '-',
                ),
                if (item.propertyName != null || item.unitName != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context,
                    Icons.business_outlined,
                    LocaleKeys.property.tr(),
                    '${item.propertyName ?? ''} ${item.unitName != null ? ' - ${item.unitName}' : ''}',
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (item.hearingDate != null)
                      Expanded(
                        child: _buildDetailRow(
                          context,
                          Icons.calendar_today_outlined,
                          LocaleKeys.legalCases_hearingDate.tr(),
                          item.hearingDate!,
                        ),
                      ),
                    if (item.nextHearingDate != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDetailRow(
                          context,
                          Icons.event_outlined,
                          LocaleKeys.legalCases_nextHearingDate.tr(),
                          item.nextHearingDate!,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('تم حل') || status.contains('محلول')) {
      return Colors.green;
    } else if (status.contains('مرفوض') || status.contains('موقوف')) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _LegalCasesReportSkeleton extends StatelessWidget {
  const _LegalCasesReportSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonBox(80)),
            const SizedBox(width: 8),
            Expanded(child: _buildSkeletonBox(80)),
            const SizedBox(width: 8),
            Expanded(child: _buildSkeletonBox(80)),
          ],
        ),
        const SizedBox(height: 24),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSkeletonBox(150),
          ),
        ),
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
