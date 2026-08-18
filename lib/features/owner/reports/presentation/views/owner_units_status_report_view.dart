import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_responsive_content.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../domain/entities/portfolio_units_display_mode.dart';
import '../../domain/entities/units_status_item_entity.dart';
import '../cubit/owner_units_status_cubit.dart';
import '../cubit/owner_units_status_state.dart';
import '../widgets/portfolio_units_header.dart';
import '../widgets/portfolio_units_list.dart';
import '../widgets/portfolio_units_toolbar.dart';
import '../widgets/report_empty_widget.dart';
import '../widgets/units_status_export_actions.dart';
import '../widgets/units_status_filter_bar.dart';
import '../widgets/units_status_skeleton.dart';
import '../widgets/units_status_summary_header.dart';

class OwnerUnitsStatusReportView extends StatefulWidget {
  const OwnerUnitsStatusReportView({super.key});

  @override
  State<OwnerUnitsStatusReportView> createState() =>
      _OwnerUnitsStatusReportViewState();
}

class _OwnerUnitsStatusReportViewState
    extends State<OwnerUnitsStatusReportView> {
  final _scrollController = ScrollController();
  PortfolioUnitsDisplayMode _mode = PortfolioUnitsDisplayMode.cards;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 280) {
      context.read<OwnerUnitsStatusCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackgroundColor,
      appBar: CustomAppBar(
        title: LocaleKeys.reports_portfolioUnitsTitle.tr(),
        actions: const [UnitsStatusExportActions()],
      ),
      body: BlocBuilder<OwnerUnitsStatusCubit, OwnerUnitsStatusState>(
        builder: (context, state) {
          if (state is OwnerUnitsStatusInitial ||
              state is OwnerUnitsStatusLoading) {
            return const AppResponsiveContent(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: UnitsStatusSkeleton(),
            );
          }
          if (state is OwnerUnitsStatusError) {
            return CustomErrorWidget(message: state.message, onRetry: _refresh);
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: AppResponsiveContent(child: _content(state)),
          );
        },
      ),
    );
  }

  Widget _content(OwnerUnitsStatusState state) {
    final filters = state is OwnerUnitsStatusLoaded
        ? state.report.filterOptions
        : (state as OwnerUnitsStatusEmpty).filterOptions;
    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      children: [
        const PortfolioUnitsHeader(),
        const SizedBox(height: AppSpacing.lg),
        UnitsStatusFilterBar(filterOptions: filters),
        const SizedBox(height: AppSpacing.lg),
        if (state is OwnerUnitsStatusEmpty)
          SizedBox(
            height: 360,
            child: ReportEmptyWidget(
              message: LocaleKeys.reports_empty_state.tr(),
              icon: Icons.maps_home_work_outlined,
            ),
          )
        else if (state is OwnerUnitsStatusLoaded) ...[
          UnitsStatusSummaryHeader(summary: state.report.summary),
          const SizedBox(height: AppSpacing.lg),
          PortfolioUnitsToolbar(
            total: state.report.pagination.total,
            mode: _mode,
            onChanged: (mode) => setState(() => _mode = mode),
          ),
          const SizedBox(height: AppSpacing.md),
          PortfolioUnitsList(
            units: state.report.items,
            mode: _mode,
            onTap: _openUnit,
          ),
          if (!state.hasReachedMax)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ],
    );
  }

  Future<void> _refresh() => context
      .read<OwnerUnitsStatusCubit>()
      .loadUnitsStatusReport(forceRefresh: true);

  void _openUnit(UnitsStatusItemEntity unit) {
    context.push(
      Routes.ownerUnitDetailsPath(unit.property.id.toString(), unit.id.toString()),
    );
  }
}
