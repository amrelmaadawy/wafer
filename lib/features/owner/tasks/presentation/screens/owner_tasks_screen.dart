import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_filter_chips.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/presentation/widgets/list/filter_sort_header_bar.dart';
import '../../../../../core/presentation/widgets/list/paginated_list_view.dart';
import '../../../../../core/presentation/widgets/list/unified_search_field.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/app_page_status.dart';
import '../../../tasks/domain/entities/task_entity.dart';
import '../cubits/list/tasks_list_cubit.dart';
import '../widgets/task_filter_sheet.dart';
import '../widgets/task_list_item.dart';
import '../widgets/task_sort_sheet.dart';
import '../widgets/tasks_list_skeleton.dart';
import '../../../shell/presentation/widgets/owner_top_app_bar.dart';

class OwnerTasksScreen extends StatefulWidget {
  const OwnerTasksScreen({super.key});

  @override
  State<OwnerTasksScreen> createState() => _OwnerTasksScreenState();
}

class _OwnerTasksScreenState extends State<OwnerTasksScreen> {
  late final TasksListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TasksListCubit>()..fetchTasks();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  List<AppFilterOption<String>> get _statusOptions => const [
    AppFilterOption(
      value: '',
      labelKey: LocaleKeys.taskFilterAll,
      icon: Icons.all_inbox_rounded,
    ),
    AppFilterOption(
      value: 'new',
      labelKey: LocaleKeys.taskFilterNew,
      icon: Icons.fiber_new_rounded,
    ),
    AppFilterOption(
      value: 'in_progress',
      labelKey: LocaleKeys.taskFilterInProgress,
      icon: Icons.pending_actions_rounded,
    ),
    AppFilterOption(
      value: 'review',
      labelKey: LocaleKeys.taskFilterReview,
      icon: Icons.rate_review_outlined,
    ),
    AppFilterOption(
      value: 'completed',
      labelKey: LocaleKeys.taskFilterCompleted,
      icon: Icons.check_circle_outline_rounded,
    ),
    AppFilterOption(
      value: 'cancelled',
      labelKey: LocaleKeys.taskFilterCancelled,
      icon: Icons.cancel_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: OwnerTopAppBar(title: LocaleKeys.drawerNavTasks.tr()),
        floatingActionButton: FloatingActionButton(heroTag: null, 
          onPressed: () async {
            final result = await context.push(Routes.ownerTasksCreate);
            if (result == true && mounted) {
              _cubit.fetchTasks(refresh: true);
            }
          },
          backgroundColor: context.primaryColor,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
        body: Column(
          children: [
            BlocBuilder<TasksListCubit, TasksListState>(
              builder: (context, state) {
                final filter = state.filterParams;
                return FilterSortHeaderBar<String>(
                  searchField: UnifiedSearchField(
                    hintLocaleKey: LocaleKeys.taskSearchHint,
                    onChanged: _cubit.search,
                    onClear: () => _cubit.search(''),
                  ),
                  activeFiltersCount: filter.activeFiltersCount,
                  isSortActive: filter.isSortActive,
                  quickFilterOptions: _statusOptions,
                  selectedQuickFilter: filter.status ?? '',
                  onQuickFilterSelected: (val) => _cubit.filterByStatus(
                    val?.isEmpty == true ? null : val,
                  ),
                  onFilterTap: () {
                    TaskFilterSheet.show(
                      context,
                      currentFilter: filter,
                      onApply: _cubit.applyAdvancedFilter,
                    );
                  },
                  onSortTap: () {
                    TaskSortSheet.show(
                      context,
                      currentFilter: filter,
                      onApply: _cubit.setSort,
                    );
                  },
                );
              },
            ),
            Expanded(
              child: BlocBuilder<TasksListCubit, TasksListState>(
                builder: (context, state) {
                  return PaginatedListView<TaskEntity>(
                    items: state.items,
                    isLoading: state.isLoading,
                    isFetchingMore: state.isLoadingNextPage,
                    hasReachedMax: state.hasReachedMax,
                    useStaggeredAnimation: true,
                    onRefresh: () => _cubit.fetchTasks(refresh: true),
                    onLoadMore: () => _cubit.fetchTasks(isLoadMore: true),
                    loadingWidget: const TasksListSkeleton(),
                    errorWidget: state.status == AppPageStatus.error
                        ? CustomErrorWidget(
                            message: state.errorMessage ??
                                LocaleKeys.errorOccurred.tr(),
                            onRetry: () => _cubit.fetchTasks(refresh: true),
                          )
                        : null,
                    emptyWidget: CustomEmptyWidget(
                      title: LocaleKeys.no_tasks_yet.tr(),
                      subtitle: '',
                      icon: Icons.task_rounded,
                    ),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index, task) =>
                        TaskListItem(task: task),
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
