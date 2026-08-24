import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/di/service_locator.dart';
import 'cubit/statement/owner_client_statement_cubit.dart';
import 'cubit/statement/owner_client_statement_state.dart';
import 'widgets/statement_shimmer.dart';
import 'widgets/statement_summary_card.dart';
import 'widgets/statement_transaction_card.dart';

class OwnerClientStatementView extends StatelessWidget {
  final int clientId;

  const OwnerClientStatementView({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerClientStatementCubit>()
        ..getStatement(clientId: clientId),
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.clientStatementTitle.tr(),
          showBackButton: true,
        ),
        body: _StatementBody(clientId: clientId),
      ),
    );
  }
}

class _StatementBody extends StatelessWidget {
  final int clientId;

  const _StatementBody({required this.clientId});

  Future<void> _selectDateRange(BuildContext context) async {
    final cubit = context.read<OwnerClientStatementCubit>();
    final state = cubit.state;
    DateTimeRange? initialRange;
    if (state is OwnerClientStatementLoaded && state.startDate != null && state.endDate != null) {
      initialRange = DateTimeRange(
        start: DateTime.parse(state.startDate!),
        end: DateTime.parse(state.endDate!),
      );
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            ),
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onPrimary: Colors.white,
              surface: context.appSurfaceColor,
              onSurface: context.appOnSurfaceColor,
              secondary: context.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // For the save button in AppBar
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: context.appSurfaceColor,
              headerBackgroundColor: context.primaryColor,
              headerForegroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String startDate = DateFormat('yyyy-MM-dd').format(picked.start);
      final String endDate = DateFormat('yyyy-MM-dd').format(picked.end);
      String? currentTxType;
      if (state is OwnerClientStatementLoaded) {
        currentTxType = state.transactionType;
      }
      cubit.getStatement(
        clientId: clientId,
        startDate: startDate,
        endDate: endDate,
        transactionType: currentTxType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerClientStatementCubit, OwnerClientStatementState>(
      builder: (context, state) {
        if (state is OwnerClientStatementLoading) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: StatementShimmer(),
          );
        } else if (state is OwnerClientStatementError) {
          return CustomErrorWidget(
            message: state.failure.message,
            onRetry: () => context
                .read<OwnerClientStatementCubit>()
                .getStatement(clientId: clientId, isRefresh: true),
          );
        } else if (state is OwnerClientStatementLoaded) {
          return RefreshIndicator(
            onRefresh: () => context
                .read<OwnerClientStatementCubit>()
                .getStatement(clientId: clientId, isRefresh: true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDateRange(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: context.appBorderColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.appBorderColor.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, size: 18, color: context.primaryColor),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    (state.startDate != null && state.endDate != null)
                                        ? '${state.startDate} - ${state.endDate}'
                                        : LocaleKeys.statementFilter.tr(),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: (state.startDate != null) ? context.appOnSurfaceColor : context.appSecondaryTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (state.startDate != null || state.endDate != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () => context.read<OwnerClientStatementCubit>().resetFilters(clientId),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.error.withValues(alpha: 0.1),
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  StatementSummaryCard(
                    summary: state.statementResponse.summary,
                    client: state.statementResponse.client,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: state.statementResponse.transactions.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                              CustomEmptyWidget(
                                title: LocaleKeys.statementEmpty.tr(),
                                subtitle: LocaleKeys.statementEmptySubtitle.tr(),
                                icon: Icons.receipt_long_rounded,
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: state.statementResponse.transactions.length,
                            itemBuilder: (context, index) {
                              return StatementTransactionCard(
                                transaction:
                                    state.statementResponse.transactions[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
