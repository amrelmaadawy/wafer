import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/routing/routes.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_empty_widget.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../cubits/list/tasks_list_cubit.dart';
import '../widgets/task_list_item.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/di/service_locator.dart';
import 'package:go_router/go_router.dart';

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
      _cubit.fetchTasks();
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
            if (result == true && context.mounted) {
              _cubit.fetchTasks(refresh: true);
            }
          },
          backgroundColor: context.primaryColor,
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            await _cubit.fetchTasks(refresh: true);
          },
          child: BlocBuilder<TasksListCubit, TasksListState>(
            builder: (context, state) {
              if (state.status == TasksListStatus.initial ||
                  (state.status == TasksListStatus.loading && state.items.isEmpty)) {
                return _buildShimmer();
              }

              if (state.status == TasksListStatus.error && state.items.isEmpty) {
                return CustomErrorWidget(
                  message: state.errorMessage ?? LocaleKeys.errorOccurred.tr(),
                  onRetry: () => _cubit.fetchTasks(refresh: true),
                );
              }

              if (state.items.isEmpty) {
                return CustomEmptyWidget(
                  title: LocaleKeys.no_tasks_yet.tr(),
                  subtitle: '',
                  icon: Icons.task_rounded,
                );
              }

              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.hasReachedMax ? state.items.length : state.items.length + 1,
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Center(
                        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  return TaskListItem(task: state.items[index]);
                },
              );
            },
          ),
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
