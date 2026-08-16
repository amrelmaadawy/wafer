import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/presentation/widgets/app_filter_chips.dart';
import '../../../../../core/presentation/widgets/app_pagination_loader.dart';
import '../../../../../core/presentation/widgets/app_search.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubits/list/tasks_list_cubit.dart';
import '../widgets/task_list_item.dart';

class OwnerTasksScreen extends StatefulWidget {
  const OwnerTasksScreen({super.key});

  @override
  State<OwnerTasksScreen> createState() => _OwnerTasksScreenState();
}

class _OwnerTasksScreenState extends State<OwnerTasksScreen> {
  final _scrollController = ScrollController();
  late final TasksListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TasksListCubit>()..fetchTasks();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.fetchTasks(isLoadMore: true);
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
          labelKey: LocaleKeys.taskFilterAll,
          icon: Icons.all_inbox_rounded,
        ),
        AppFilterOption(
          value: 'pending',
          labelKey: LocaleKeys.taskFilterPending,
          icon: Icons.schedule_rounded,
        ),
        AppFilterOption(
          value: 'in_progress',
          labelKey: LocaleKeys.taskFilterInProgress,
          icon: Icons.pending_actions_rounded,
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
        appBar: CustomAppBar(
          title: LocaleKeys.dashboard_tasks.tr(),
        ),
        floatingActionButton: FloatingActionButton(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
              child: AppSearch(
                hintLocaleKey: LocaleKeys.taskSearchHint,
                onChanged: _cubit.search,
              ),
            ),
            BlocBuilder<TasksListCubit, TasksListState>(
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
                  await _cubit.fetchTasks(refresh: true);
                },
                child: BlocBuilder<TasksListCubit, TasksListState>(
                  builder: (context, state) {
                    if (state.isLoading && state.items.isEmpty) {
                      return _buildShimmer();
                    }

                    if (state.isError && state.items.isEmpty) {
                      return CustomErrorWidget(
                        message: state.errorMessage ?? LocaleKeys.errorOccurred.tr(),
                        onRetry: () => _cubit.fetchTasks(refresh: true),
                      );
                    }

                    if (state.isEmpty || state.items.isEmpty) {
                      return CustomEmptyWidget(
                        title: LocaleKeys.no_tasks_yet.tr(),
                        subtitle: '',
                        icon: Icons.task_rounded,
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.items.length + (state.isLoadingNextPage ? 1 : 0),
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const AppPaginationLoader();
                        }
                        return TaskListItem(task: state.items[index]);
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

  Widget _buildShimmer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          child: AppShimmer.box(
            height: 120,
            borderRadius: AppRadius.circularMd,
          ),
        );
      },
    );
  }
}
