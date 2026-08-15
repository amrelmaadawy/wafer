import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/app_surface_card.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/utils/widgets/app_shimmer.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/routing/routes.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/details/task_details_cubit.dart';
import '../cubit/details/task_details_state.dart';
import '../widgets/task_details_widgets.dart';
import '../cubit/delete/delete_task_cubit.dart';
import '../cubit/delete/delete_task_state.dart';
import '../../../../../core/utils/widgets/app_toast.dart';
import '../../../../../core/utils/widgets/custom_button.dart';

class OwnerTaskDetailsScreen extends StatefulWidget {
  final int taskId;

  const OwnerTaskDetailsScreen({super.key, required this.taskId});

  @override
  State<OwnerTaskDetailsScreen> createState() => _OwnerTaskDetailsScreenState();
}

class _OwnerTaskDetailsScreenState extends State<OwnerTaskDetailsScreen> {
  late final TaskDetailsCubit _cubit;
  late final DeleteTaskCubit _deleteCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<TaskDetailsCubit>()..fetchTaskDetails(widget.taskId);
    _deleteCubit = sl<DeleteTaskCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    _deleteCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _deleteCubit),
      ],
      child: Scaffold(
        backgroundColor: context.appBackgroundColor,
        appBar: CustomAppBar(
          title: LocaleKeys.task_details_title.tr(),
          actions: [
            BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
              builder: (context, state) {
                if (state is TaskDetailsLoaded) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _showDeleteConfirmation(context, state.task),
                            borderRadius: AppRadius.circularMd,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: AppColors.error.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          InkWell(
                            onTap: () async {
                              final result = await context.push(Routes.ownerTasksEdit, extra: state.task);
                              if (result == true && context.mounted) {
                                _cubit.fetchTaskDetails(widget.taskId, refresh: true);
                              }
                            },
                            borderRadius: AppRadius.circularMd,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withValues(alpha: 0.1),
                                borderRadius: AppRadius.circularMd,
                                border: Border.all(
                                  color: context.primaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: context.primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
          builder: (context, state) {
            if (state is TaskDetailsLoading || state is TaskDetailsInitial) {
              return _buildShimmer();
            } else if (state is TaskDetailsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _cubit.fetchTaskDetails(widget.taskId),
              );
            } else if (state is TaskDetailsLoaded) {
              return _buildContent(context, state.task);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (ctx) => BlocConsumer<DeleteTaskCubit, DeleteTaskState>(
        bloc: _deleteCubit,
        listener: (context, state) {
          if (state is DeleteTaskSuccess) {
            Navigator.pop(ctx);
            AppToast.showSuccess(context, LocaleKeys.task_deleted_successfully.tr());
            context.pop(true);
          } else if (state is DeleteTaskError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is DeleteTaskLoading;
          return AlertDialog(
            backgroundColor: context.appSurfaceColor,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.circularLg),
            title: Text(
              LocaleKeys.delete_task.tr(),
              style: AppTextStyles.h3.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              LocaleKeys.delete_task_confirmation.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: context.appSecondaryTextColor),
            ),
            actionsPadding: const EdgeInsets.all(AppSpacing.md),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(ctx),
                child: Text(
                  LocaleKeys.cancel.tr(),
                  style: AppTextStyles.labelLarge.copyWith(color: context.appSecondaryTextColor),
                ),
              ),
              CustomButton(
                text: LocaleKeys.delete.tr(),
                onPressed: () => _deleteCubit.deleteTask(widget.taskId),
                isLoading: isLoading,
                width: 100,
                type: ButtonType.primary,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskEntity task) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        await _cubit.fetchTaskDetails(widget.taskId, refresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainCard(context, task),
            const SizedBox(height: AppSpacing.lg),
            if (task.dates != null) ...[
              TaskDatesCard(dates: task.dates!),
              const SizedBox(height: AppSpacing.lg),
            ],
            TaskLinkedEntityCard(task: task),
            if (task.linkedEntity != null) const SizedBox(height: AppSpacing.lg),
            if (task.description != null && task.description!.isNotEmpty) ...[
              _buildSectionHeader(context, LocaleKeys.details.tr(), Icons.description_outlined),
              const SizedBox(height: AppSpacing.sm),
              AppSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  task.description!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (task.notes != null && task.notes!.isNotEmpty) ...[
              _buildSectionHeader(context, LocaleKeys.notes.tr(), Icons.sticky_note_2_outlined),
              const SizedBox(height: AppSpacing.sm),
              AppSurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  task.notes!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.appSecondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, TaskEntity task) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.code != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.appSecondaryTextColor.withValues(alpha: 0.08),
                          borderRadius: AppRadius.circularSm,
                        ),
                        child: Text(
                          '#${task.code}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: context.appSecondaryTextColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Text(
                      task.title,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w800,
                        color: context.appOnSurfaceColor,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              if (task.status != null) _buildStatusPill(context, task.status!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.04),
              borderRadius: AppRadius.circularMd,
              border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.progress.tr(),
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      '${task.progress}%',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppRadius.circularSm,
                  child: LinearProgressIndicator(
                    value: task.progress / 100,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    color: Theme.of(context).primaryColor,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (task.priority != null)
                _buildInfoChip(
                  context,
                  icon: Icons.flag_rounded,
                  label: task.priority!.label,
                  color: _parseColor(task.priority!.color, AppColors.warning),
                ),
              if (task.category != null)
                _buildInfoChip(
                  context,
                  icon: Icons.category_rounded,
                  label: task.category!.label,
                  color: _parseColor(task.category!.color, AppColors.info),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, TaskOptionEntity status) {
    final bgColor = _parseColor(status.backgroundColor, Theme.of(context).primaryColor.withValues(alpha: 0.1));
    final textColor = _parseColor(status.color, Theme.of(context).primaryColor);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.circularLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: AppTextStyles.labelMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularSm,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w800,
            color: context.appOnSurfaceColor,
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.isEmpty) return defaultColor;
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return defaultColor;
    }
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppShimmer.box(height: 160, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 140, borderRadius: AppRadius.circularMd),
          const SizedBox(height: AppSpacing.md),
          AppShimmer.box(height: 80, borderRadius: AppRadius.circularMd),
        ],
      ),
    );
  }
}
