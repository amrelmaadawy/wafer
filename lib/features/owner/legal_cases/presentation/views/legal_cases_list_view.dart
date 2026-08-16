import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/app_filter_chips.dart';
import '../../../../../../core/presentation/widgets/app_pagination_loader.dart';
import '../../../../../../core/presentation/widgets/app_search.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../cubits/list/legal_cases_list_cubit.dart';
import '../cubits/list/legal_cases_list_state.dart';
import '../widgets/legal_case_card_widget.dart';
import '../widgets/legal_cases_list_skeleton.dart';

class LegalCasesListView extends StatefulWidget {
  const LegalCasesListView({super.key});

  @override
  State<LegalCasesListView> createState() => _LegalCasesListViewState();
}

class _LegalCasesListViewState extends State<LegalCasesListView> {
  late final LegalCasesListCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCasesListCubit>()..fetchLegalCases();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.fetchLegalCases(isLoadMore: true);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  List<AppFilterOption<String>> get _statusOptions => const [
        AppFilterOption(
          value: '',
          labelKey: LocaleKeys.legalCaseFilterAll,
          icon: Icons.all_inbox_rounded,
        ),
        AppFilterOption(
          value: 'active',
          labelKey: LocaleKeys.legalCaseFilterActive,
          icon: Icons.play_arrow_rounded,
        ),
        AppFilterOption(
          value: 'in_progress',
          labelKey: LocaleKeys.legalCaseFilterInProgress,
          icon: Icons.pending_actions_rounded,
        ),
        AppFilterOption(
          value: 'closed',
          labelKey: LocaleKeys.legalCaseFilterClosed,
          icon: Icons.check_circle_outline_rounded,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocaleKeys.legal_cases.tr(),
        ),
        backgroundColor: AppColors.backgroundLight,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.push<bool>(Routes.ownerLegalCaseCreate);
            if (result == true && mounted) {
              _cubit.fetchLegalCases(refresh: true);
            }
          },
          backgroundColor: context.primaryColor,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
              child: AppSearch(
                hintLocaleKey: LocaleKeys.legalCasesSearchHint,
                onChanged: _cubit.search,
              ),
            ),
            BlocBuilder<LegalCasesListCubit, LegalCasesListState>(
              buildWhen: (p, c) => p.filterParams.status != c.filterParams.status,
              builder: (context, state) {
                return AppFilterChips<String>(
                  options: _statusOptions,
                  selectedValue: state.filterParams.status ?? '',
                  onSelected: (val) => _cubit.filterByStatus(val?.isEmpty == true ? null : val),
                );
              },
            ),
            Expanded(
              child: RefreshIndicator(
                color: context.primaryColor,
                onRefresh: () async {
                  await _cubit.fetchLegalCases(refresh: true);
                },
                child: BlocBuilder<LegalCasesListCubit, LegalCasesListState>(
                  builder: (context, state) {
                    if (state.isLoading && state.legalCases.isEmpty) {
                      return const LegalCasesListSkeleton();
                    }

                    if (state.isError && state.legalCases.isEmpty) {
                      return CustomErrorWidget(
                        message: state.errorMessage ?? LocaleKeys.errorOccurred.tr(),
                        onRetry: () => _cubit.fetchLegalCases(refresh: true),
                      );
                    }

                    if (state.isEmpty || state.legalCases.isEmpty) {
                      return CustomEmptyWidget(
                        title: LocaleKeys.no_legal_cases_found.tr(),
                        subtitle: '',
                        icon: Icons.gavel_rounded,
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.legalCases.length + (state.isLoadingNextPage ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        if (index >= state.legalCases.length) {
                          return const AppPaginationLoader();
                        }
                        final legalCase = state.legalCases[index];
                        return LegalCaseCardWidget(
                          legalCase: legalCase,
                          onTap: () async {
                            final result = await context.push(
                              Routes.ownerLegalCaseDetailsPath(legalCase.id.toString()),
                            );
                            if (result == true && context.mounted) {
                              _cubit.fetchLegalCases(refresh: true);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
