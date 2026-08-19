import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../../../../core/theme/theme_context.dart';
import '../../domain/entities/legal_case_item_entity.dart';
import '../cubits/list/legal_cases_list_cubit.dart';
import '../cubits/list/legal_cases_list_state.dart';
import '../widgets/legal_case_card_widget.dart';
import '../widgets/legal_cases_list_skeleton.dart';
import '../widgets/legal_cases_filter_chips.dart';
import '../../../shell/presentation/widgets/owner_top_app_bar.dart';

class LegalCasesListView extends StatefulWidget {
  const LegalCasesListView({super.key});

  @override
  State<LegalCasesListView> createState() => _LegalCasesListViewState();
}

class _LegalCasesListViewState extends State<LegalCasesListView> {
  late final LegalCasesListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<LegalCasesListCubit>()..fetchLegalCases();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: OwnerTopAppBar(title: LocaleKeys.drawerNavLegalCases.tr()),
        backgroundColor: context.appBackgroundColor,
        floatingActionButton: FloatingActionButton(heroTag: null, 
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
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: UnifiedSearchField(
                hintLocaleKey: LocaleKeys.legalCasesSearchHint,
                onChanged: _cubit.search,
                onClear: () => _cubit.search(''),
              ),
            ),
            BlocBuilder<LegalCasesListCubit, LegalCasesListState>(
              buildWhen: (p, c) => 
                  p.filterParams.status != c.filterParams.status || 
                  p.stats?.byStatus != c.stats?.byStatus,
              builder: (context, state) {
                return LegalCasesFilterChips(
                  statsByStatus: state.stats?.byStatus ?? {},
                  selectedStatus: state.filterParams.status,
                  onStatusSelected: (val) => _cubit.filterByStatus(val),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<LegalCasesListCubit, LegalCasesListState>(
                builder: (context, state) {
                  return PaginatedListView<LegalCaseItemEntity>(
                    items: state.legalCases,
                    isLoading: state.isLoading,
                    isFetchingMore: state.isLoadingNextPage,
                    hasReachedMax: state.hasReachedMax,
                    useStaggeredAnimation: true,
                    onRefresh: () => _cubit.fetchLegalCases(refresh: true),
                    onLoadMore: () => _cubit.fetchLegalCases(isLoadMore: true),
                    loadingWidget: const LegalCasesListSkeleton(),
                    errorWidget: state.isError
                        ? CustomErrorWidget(
                            message: state.errorMessage ??
                                LocaleKeys.errorOccurred.tr(),
                            onRetry: () => _cubit.fetchLegalCases(refresh: true),
                          )
                        : null,
                    emptyWidget: CustomEmptyWidget(
                      title: LocaleKeys.no_legal_cases_found.tr(),
                      subtitle: '',
                      icon: Icons.gavel_rounded,
                    ),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index, legalCase) {
                      return LegalCaseCardWidget(
                        legalCase: legalCase,
                        onTap: () async {
                          final result = await context.push(
                            Routes.ownerLegalCaseDetailsPath(
                              legalCase.id.toString(),
                            ),
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
          ],
        ),
      ),
    );
  }
}
