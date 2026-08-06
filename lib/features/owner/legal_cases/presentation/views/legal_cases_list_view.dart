import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import 'dart:async';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
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

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCasesListCubit>()..fetchLegalCases();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _cubit.fetchLegalCases(status: _selectedStatus);
      });
    }
  }

  Future<void> _onRefresh() async {
    await _cubit.fetchLegalCases(status: _selectedStatus, isRefresh: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
          scrolledUnderElevation: 0,
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
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => _cubit.fetchLegalCases(
                        status: _selectedStatus,
                        isRefresh: true,
                      ),
                      child: Text(LocaleKeys.retry.tr()),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: LegalCasesFilterChips(
                          statsByStatus: state.stats!.byStatus!,
                          selectedStatus: _selectedStatus,
                          onStatusSelected: (status) {
                            setState(() {
                              _selectedStatus = status;
                            });
                            _cubit.fetchLegalCases(
                              status: status,
                              isRefresh: true,
                            );
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
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.gavel,
                                            size: 64,
                                            color: context.primaryColor,
                                          ),
                                          const SizedBox(height: AppSpacing.md),
                                          Text(
                                            LocaleKeys.no_legal_cases_found
                                                .tr(),
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
                                                  color: AppColors
                                                      .textSecondaryLight,
                                                ),
                                          ),
                                          const SizedBox(height: AppSpacing.lg),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              final result = await context
                                                  .push<bool>(
                                                    '${Routes.ownerLegalCases}/${Routes.ownerLegalCaseCreate}',
                                                  );
                                              if (result == true) {
                                                _cubit.fetchLegalCases(
                                                  isRefresh: true,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  context.primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: AppSpacing.lg,
                                                    vertical: AppSpacing.md,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    AppRadius.circularMd,
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            label: Text(
                                              LocaleKeys.create_legal_case.tr(),
                                              style: AppTextStyles.labelLarge
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                key: ValueKey(
                                  'list_${_selectedStatus ?? "all"}',
                                ),
                                controller: _scrollController,
                                padding: const EdgeInsets.all(AppSpacing.md),
                                itemCount:
                                    state.legalCases.length +
                                    (state.hasReachedMax ? 0 : 1),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  if (index >= state.legalCases.length) {
                                    if (state.paginationError != null) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.md,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              state.paginationError!,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: AppColors.error,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.sm,
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _cubit.fetchLegalCases(
                                                    status: _selectedStatus,
                                                  ),
                                              child: Text(
                                                LocaleKeys.retry.tr(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const LegalCaseCardSkeleton();
                                  }
                                  final legalCase = state.legalCases[index];
                                  return LegalCaseCardWidget(
                                    legalCase: legalCase,
                                    onTap: () {
                                      context
                                          .push(
                                            '${Routes.ownerLegalCases}/${Routes.ownerLegalCaseDetails.replaceAll(':id', '${legalCase.id}')}',
                                          )
                                          .then((deleted) {
                                            if (deleted == true &&
                                                context.mounted) {
                                              _cubit.fetchLegalCases(
                                                status: _selectedStatus,
                                                isRefresh: true,
                                              );
                                            }
                                          });
                                    },
                                    onEditTap: () async {
                                      final result = await context.push<bool>(
                                        '${Routes.ownerLegalCases}/${Routes.ownerLegalCaseEdit}',
                                        extra: legalCase,
                                      );
                                      if (result == true) {
                                        _cubit.fetchLegalCases(isRefresh: true);
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await context.push<bool>(
              '${Routes.ownerLegalCases}/${Routes.ownerLegalCaseCreate}',
            );
            if (result == true) {
              _cubit.fetchLegalCases(isRefresh: true);
            }
          },
          backgroundColor: context.primaryColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            LocaleKeys.create_legal_case.tr(),
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
