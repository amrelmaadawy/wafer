import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../cubits/list/legal_cases_list_cubit.dart';
import '../cubits/list/legal_cases_list_state.dart';
import '../widgets/legal_case_card_widget.dart';
import '../widgets/legal_cases_filter_chips.dart';
import '../widgets/legal_cases_list_skeleton.dart';

class LegalCasesListView extends StatefulWidget {
  const LegalCasesListView({super.key});

  @override
  State<LegalCasesListView> createState() => _LegalCasesListViewState();
}

class _LegalCasesListViewState extends State<LegalCasesListView> {
  late final LegalCasesListCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCasesListCubit>()..fetchLegalCases();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchLegalCases(status: _selectedStatus);
    }
  }

  Future<void> _onRefresh() async {
    await _cubit.fetchLegalCases(status: _selectedStatus, isRefresh: true);
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
        appBar: AppBar(
          title: Text(LocaleKeys.legal_cases.tr(), style: AppTextStyles.h4),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: AppColors.backgroundLight,
        body: BlocBuilder<LegalCasesListCubit, LegalCasesListState>(
          builder: (context, state) {
            if (state is LegalCasesListInitial ||
                (state is LegalCasesListLoading && state.isFirstFetch)) {
              return const LegalCasesListSkeleton();
            }

            if (state is LegalCasesListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () =>
                          _cubit.fetchLegalCases(status: _selectedStatus, isRefresh: true),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (state is LegalCasesListLoaded) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(
                  children: [
                    if (state.stats?.byStatus != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: LegalCasesFilterChips(
                          statsByStatus: state.stats!.byStatus!,
                          selectedStatus: _selectedStatus,
                          onStatusSelected: (status) {
                            setState(() {
                              _selectedStatus = status;
                            });
                            _cubit.fetchLegalCases(status: status, isRefresh: true);
                          },
                        ),
                      ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: state.legalCases.isEmpty
                            ? ListView(
                                key: const ValueKey('empty_list'),
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.gavel,
                                            size: 64,
                                            color: AppColors.borderLight,
                                          ),
                                          const SizedBox(height: AppSpacing.md),
                                          Text(
                                            LocaleKeys.no_legal_cases_found.tr(),
                                            style: AppTextStyles.bodyLarge.copyWith(
                                              color: AppColors.textSecondaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                key: ValueKey('list_${_selectedStatus ?? "all"}'),
                                controller: _scrollController,
                                padding: const EdgeInsets.all(AppSpacing.md),
                                itemCount: state.legalCases.length +
                                    (state.hasReachedMax ? 0 : 1),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: AppSpacing.md),
                              itemBuilder: (context, index) {
                                if (index >= state.legalCases.length) {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: AppSpacing.md),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                final legalCase = state.legalCases[index];
                                return LegalCaseCardWidget(
                                  legalCase: legalCase,
                                  onTap: () {
                                    context.push('${Routes.ownerLegalCases}/${Routes.ownerLegalCaseDetails}/${legalCase.id}');
                                  },
                                );
                              },
                            ),
                    ),
                  )],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
